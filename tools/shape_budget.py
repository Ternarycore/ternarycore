#!/usr/bin/env python3
"""shape_budget.py -- what a different model shape would cost on this board.

    python tools/shape_budget.py                 # the candidate shapes
    python tools/shape_budget.py --ctx 128
    python tools/shape_budget.py --shape 18,1024,2048,8,8,128
    python tools/shape_budget.py --ladder      # the campaign ladder

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




# ---- the campaign ladder ---------------------------------------------
#
#  The shape is one lever. These are the others, and they multiply, so the
#  order they are listed in is not the order they are worth.
#
#  The anchors here are measurements, not the budget's totals, because
#  pairing those two up wrongly is what produced the "the budget held to
#  4.2%" claim in article 05. It did not. tools/tokrep.py, minimum of
#  several runs, repeatability 0.5 ms:
#
#      soft-CPU normalizer  pos 0  3247.3    pos 511  5023.9
#      fabric  normalizer   pos 0  2863.5    pos 511  4639.9
#
#  docs/TOKEN-BUDGET.md's operator total is 4469.0 at context 512 with the
#  soft-CPU normalizer. The machine does 5023.9. The 554.9 ms difference
#  is the block driver's own bookkeeping, and it reconciles exactly:
#
#      operators 4469.0 + glue 554.9 - fabric normalizer 384.0 = 4639.9
#
#  Three corrections fall out of that line, all of them to numbers this
#  project has published:
#
#    * The budget is 11% low against the machine, not 4.2%. The 4.2%
#      compared a soft-CPU prediction against a fabric measurement.
#    * The driver's glue is 554.9 ms, not 246. The 246 was the same
#      mispairing: the fabric normalizer's 384 ms saving was hiding
#      inside it.
#    * The fabric normalizer saves 384 ms and not the 484 the operator
#      benchmark predicts. NQF in isolation is 21.4 ms a token; in the
#      driver it costs about 100 ms more than that. Worth finding.
#
#  And it is already switched on -- `fab` defaults to 1 everywhere -- so
#  it is banked in the 4639.9 baseline and is not available to spend
#  again.
BASE = 4639.9              # measured, fabric normalizer, context 512
GLUE = 554.9               # measured, and position-independent
GROUPS = {                 # docs/TOKEN-BUDGET.md, regrouped by what fixes them
    "feed": 1954.8,        # projections + Q.Kᵀ + P.V, poked in a word at a time
    "cpu":  2162.0 - 384.0,   # elementwise, with the fabric normalizer applied
    "mem":  352.4,         # weight paging
}
#  Fraction of each group that is the walk over the KV cache, from the
#  position curve: 1835.0 ms of the 2226.3 attention rows at context 512.
WALK = {"feed": 1835.0 * (1035.0 + 573.9) / 2226.3,
        "cpu":  1835.0 * 617.4 / 2226.3, "mem": 0.0}

#  The DMA row used to say 0.07, from "PROJ is 827 us of which the array
#  is 12.7". tools/pph.py went and measured it, and both halves of that
#  sentence were wrong.
#
#  A projection, by phase, at 50 against 200 repetitions:
#
#      activations in, 1024 writes to S_ACTWR      109.3 us   13.2%
#      the array, sixteen passes                   212.0 us   25.6%
#      results out, 2048 accesses                  320.4 us   38.7%
#      accumulate into the output slot             185.3 us   22.4%
#                                                  827.0 us
#
#  **The array is 212 us of a projection, not 12.7.** S_CYC reads 1031 for
#  ntile 1, 4 and 16 alike -- it is a per-pass counter, and a projection
#  is sixteen passes. Every number this project has published about the
#  array's share counted one. 440 projections a token x 203 us is 89 ms:
#  the array does arithmetic for 2.0% of a token, not 0.12%.
#
#  That also puts a floor under the DMA campaign, which is the useful
#  part. Two CDMA moves at the ~24 us setup the pager measures, plus the
#  array, is 286 us; leave the accumulate loop on the CPU and it is 471.
#  So DMA is worth a factor of 0.35 to 0.57 on the feed group, not 0.07 --
#  between 2x and 3x, not fourteen. The row below uses 0.45.
#
#  And a cheaper thing fell out. Reading a result costs an index write and
#  a data read, 2048 accesses for 1024 numbers. Phase 3 times the reads
#  alone: 106.5 us a call, 12.9% of a projection, for a read port that
#  increments its own index. About three lines of Verilog, and it is the
#  best ratio on this list.
STEPS = [
    ("the recommended shape (a training run, no FPGA work)",
     dict(shape=True)),
    ("auto-incrementing S_RDATA (three lines of Verilog)",
     dict(feed=0.87)),
    ("DMA the array's operands and results (measured floor)",
     dict(feed=0.517)),
    ("halve the driver's glue",                  dict(glue=0.5)),
    ("128-bit weight bus",                       dict(mem=0.25)),
    ("interleaved 128 window, 1 full layer in 4", dict(window=0.4375)),
    ("SiLU and QK-norm/RoPE into fabric",        dict(cpu=0.606)),
    ("KV append and softmax into fabric",        dict(cpu=0.606 * 0.47)),
]


def ladder(shape_factor):
    f = {"feed": 1.0, "cpu": 1.0, "mem": 1.0}
    glue, window, sh = 1.0, 1.0, 1.0
    print(f"\n  {'':52s} {'ms':>8s} {'tok/s':>8s} {'vs today':>9s}")
    print("  " + "-" * 82)

    def total():
        t = glue * GLUE * sh
        for g, v in GROUPS.items():
            walk = WALK[g]
            t += ((v - walk) + walk * window) * f[g] * sh
        return t

    print(f"  {'today, as it ships':52s} {total():8.1f} "
          f"{1000/total():8.3f} {1.0:8.2f}x")
    for name, kw in STEPS:
        if kw.pop("shape", False):
            sh = shape_factor
        glue *= kw.pop("glue", 1.0)
        window *= kw.pop("window", 1.0)
        for g, v in kw.items():
            f[g] *= v
        t = total()
        print(f"  + {name:50s} {t:8.1f} {1000/t:8.3f} {BASE/t:8.2f}x")
    print("\n  4-6 tok/s, the figure in the published plan, is 167-250 ms.")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ctx", type=int, default=512)
    ap.add_argument("--shape", default="", help="L,H,I,NH,NKV,HD")
    ap.add_argument("--ladder", action="store_true",
                    help="the campaign ladder, on measured anchors")
    a = ap.parse_args()

    print(f"predicted board cost at a {a.ctx}-token context")
    print("  coefficients from docs/TOKEN-BUDGET.md and tools/tokcurve.py;")
    print("  a linear model good for ranking shapes, not a measurement.")

    if a.shape:
        keys = ["L", "H", "I", "NH", "NKV", "HD"]
        show("--shape", dict(zip(keys, map(int, a.shape.split(",")))), a.ctx)
        return

    if a.ladder:
        _, _, p = predict(REF, a.ctx)
        rec = dict(L=18, H=1024, I=2048, NH=8, NKV=8, HD=128)
        t_ref, _, _ = predict(REF, 512)
        t_rec, _, _ = predict(rec, 512)
        ladder(t_rec / t_ref)
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
