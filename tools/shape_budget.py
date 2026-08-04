#!/usr/bin/env python3
"""shape_budget.py -- what a different model shape would cost on this board.

    python tools/shape_budget.py                 # the candidate shapes
    python tools/shape_budget.py --ctx 128
    python tools/shape_budget.py --shape 18,1024,2048,8,8,128

The next student's shape is a training decision and a hardware decision at
the same time, and the second half of that is computable right now. This
takes the measured token budget apart into terms that scale with something
about the model, and re-adds it for a shape that does not exist yet.

Every coefficient is divided out of a measurement, not estimated:

  * docs/TOKEN-BUDGET.md, the fused-operator table, 4469.0 ms at a
    512-token context. Nine rows, each attributed below to the thing it
    actually scales with.
  * tools/tokcurve.py, the board timed directly: 2880 ms at position 0 and
    4656 at 511. That second number splits the three attention rows into a
    fixed part and a per-key part. 2226 ms of attention at context 512 is
    not 2226 ms at context 1, and a model that assumed it was would
    recommend the wrong shape.

Two findings come straight out of it, and both are counter-intuitive
enough to be worth the file:

  * **Parameter count is 16% of a token.** Weight paging and the seven
    projections together are 698 of 4469 ms. A student with half the
    parameters is NOT twice as fast. The other 84% scales with depth,
    width and head count.
  * **Query heads are the largest single lever.** Sixteen of them cost
    1113 ms -- a quarter of a token -- against 13% of the parameters.
    Nothing else in the model has that ratio.

The shape validator is not decoration either. The array is 1024 wide and
1024 deep, the exporter packs `GROUPS = out/4`, and a layer whose output
is not a multiple of 1024 does not tile -- this project has already lost a
week to exactly that arithmetic on q_proj. A shape that fails `check()`
cannot be exported, whatever it does for perplexity.

The predictions are a linear model fitted to two points. Good for ranking
shapes and choosing one; not measurements, and not to be quoted as any.
When a shape is chosen, export it, load it, and run tools/tokcurve.py --
which is the only number that counts.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse

TILE = 1024                      # the array is 1024 wide and 1024 deep

# ---- the shape that was measured ------------------------------------
REF = dict(L=28, H=1024, I=3072, NH=16, NKV=8, HD=128)

# ---- docs/TOKEN-BUDGET.md, ms at a 512-token context ------------------
POS_INDEP = [
    (505.4, "LH",   "RMSNorm + quantize, fused"),
    (402.0, "LqkH", "QK-norm + RoPE + quantize, fused"),
    (368.5, "LI",   "SiLU + the gate product"),
    (352.4, "P",    "weight paging"),
    (345.9, "P",    "the seven projections"),
    (268.7, "Lkv",  "KV append, bit-sliced"),
]
#  P.V + softmax + Q.K^T are 2226.4 ms together at context 512. The board's
#  2880 ms at position 0 against 4656 at 511 says 1835 of that is the walk
#  over the keys; the rest is per-head, per-block call overhead that does
#  not care how long the context is.
ATTN_FIXED = 387.4               # ms, scales with L*NH
ATTN_PER_KEY = 3.591             # ms per key, scales with L*NH*HD


def check(s):
    """Why this shape can or cannot be exported. Empty list means it can.

    Both dimensions of every projection have to be whole tiles. o_proj is
    the one that looks like an exception and is not: it reads NH*HD and
    writes H, and the depth split is the segment case the pager already
    handles -- but the depth still has to divide.
    """
    bad, qd, kvd = [], s["NH"] * s["HD"], s["NKV"] * s["HD"]
    for name, v in (("hidden", s["H"]), ("intermediate", s["I"]),
                    ("query heads x head_dim", qd),
                    ("kv heads x head_dim", kvd)):
        if v % TILE:
            bad.append(f"{name} = {v} is not a multiple of {TILE}")
    if s["NH"] % s["NKV"]:
        bad.append(f"{s['NH']} query heads do not group into "
                   f"{s['NKV']} kv heads")
    return bad


def terms(s):
    qd, kvd = s["NH"] * s["HD"], s["NKV"] * s["HD"]
    p = s["L"] * (2 * s["H"] * qd + 2 * s["H"] * kvd + 3 * s["H"] * s["I"])
    return {
        "LH":   s["L"] * s["H"],
        "LI":   s["L"] * s["I"],
        "LqkH": s["L"] * (qd + kvd),
        "Lkv":  s["L"] * kvd,
        "P":    p,
        "LNH":  s["L"] * s["NH"],
        "LNHD": s["L"] * s["NH"] * s["HD"],
    }, p


R, PREF = terms(REF)


def predict(s, ctx):
    t, p = terms(s)
    rows = [(ms * t[k] / R[k], name) for ms, k, name in POS_INDEP]
    rows.append((ATTN_FIXED * t["LNH"] / R["LNH"]
                 + ATTN_PER_KEY * ctx * t["LNHD"] / R["LNHD"],
                 "attention: Q.Kᵀ, softmax, P.V"))
    return sum(r[0] for r in rows), rows, p


def show(name, s, ctx, verbose=True):
    bad = check(s)
    total, rows, p = predict(s, ctx)
    ref_total, _, _ = predict(REF, ctx)
    print(f"\n  {name}")
    print(f"    L={s['L']}  H={s['H']}  I={s['I']}  "
          f"{s['NH']}q/{s['NKV']}kv x {s['HD']}")
    if bad:
        for b in bad:
            print(f"    CANNOT EXPORT: {b}")
        return
    print(f"    {p/1e6:7.1f} M ternary  {p/4/1e6:6.1f} MB packed   "
          f"({p/PREF*100:4.1f}% of the current student)")
    if verbose:
        for ms, label in sorted(rows, reverse=True):
            print(f"      {ms:8.1f} ms   {label}")
    print(f"    {total:8.1f} ms/token   {1000/total:5.3f} tok/s   "
          f"{ref_total/total:4.2f}x on the board   "
          f"{PREF/p:4.2f}x the warm-up tokens for the same GPU-hours")


#  Every one of these clears check(). The ones that do not are in the
#  article's file, not in this list.
SHAPES = [
    ("current -- d4-student-sst2-r2", dict(REF)),
    ("8 query heads, nothing else changed", dict(REF, NH=8)),
    ("8 heads, intermediate 2048", dict(REF, NH=8, I=2048)),
    ("half depth, everything else as it is", dict(REF, L=14)),
    ("L20, 8 heads, intermediate 2048",
     dict(L=20, H=1024, I=2048, NH=8, NKV=8, HD=128)),
    ("the recommendation: L18 H1024 I2048 8q/8kv",
     dict(L=18, H=1024, I=2048, NH=8, NKV=8, HD=128)),
]

REJECTED = [
    ("narrower -- H=768", dict(L=20, H=768, I=2048, NH=8, NKV=8, HD=128)),
    ("4 kv heads at head_dim 128",
     dict(L=18, H=1024, I=2048, NH=8, NKV=4, HD=128)),
    ("intermediate 2560", dict(L=18, H=1024, I=2560, NH=8, NKV=8, HD=128)),
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ctx", type=int, default=512)
    ap.add_argument("--shape", default="", help="L,H,I,NH,NKV,HD")
    a = ap.parse_args()

    print(f"predicted board cost at a {a.ctx}-token context")
    print("  coefficients from docs/TOKEN-BUDGET.md and tools/tokcurve.py;")
    print("  a linear model good for ranking shapes, not a measurement.")

    if a.shape:
        keys = ["L", "H", "I", "NH", "NKV", "HD"]
        show("--shape", dict(zip(keys, map(int, a.shape.split(",")))), a.ctx)
        return

    for name, s in SHAPES:
        show(name, s, a.ctx)

    print("\n  ---- shapes that do not tile, kept so nobody proposes them "
          "twice ----")
    for name, s in REJECTED:
        show(name, s, a.ctx, verbose=False)

    print("\n  Parameter count is 16% of a token. Query heads are 25% and "
          "13% of\n  the parameters. Depth is everything else. That is the "
          "whole finding,\n  and it says shrink depth and heads, not width.")


if __name__ == "__main__":
    main()
