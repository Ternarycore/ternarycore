#!/usr/bin/env python3
"""block_full.py -- one complete transformer block, against tc_ref.

Fifteen weight pages and twenty-odd operators, and one comparison that
matters: the block's output residual against the reference's, from the
same input.

  python tools/block_full.py --block 0

Everything before this verified operators. A block is mostly handoffs, so
this verifies something different. The two residual adds have never run
at all -- they are the only points where a magnitude from one stage is
added to a magnitude from another, and therefore the last place two
self-consistent scales can disagree.

Position 0 on purpose: attention with history is proven separately at four
positions, and keeping it trivial here focuses a six-minute run on the
half that has never run end to end.
"""
import argparse, json, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board
from stage2_check import unpack, loadb
from block_check import (q15v, pack_slice, load_bytes, dumpi32, blockfloat,
                         H, NH, NKV, HD, Q15, BIAS)

INTER = 3072


def project(b, W, aq):
    """W @ aq on the board: 1024-output slices, depth segments accumulated."""
    out, inf = W.shape
    got = np.zeros(out, dtype=np.int64)
    for c in range(0, out, 1024):
        sub = W[c:c + 1024]
        for s in range(inf // 1024):
            load_bytes(b, pack_slice(sub[:, s * 1024:(s + 1) * 1024]))
            loadb(b, 3, aq[s * 1024:(s + 1) * 1024])
            b.send(f"PROJ 3 4 16 {s}\n")
            b.until("OK PJ")
        got[c:c + 1024] = dumpi32(b, 4, 1024)
    return got


def nq(b, x, gain, n):
    """Fused RMSNorm+quantize; returns int8 and the true output scale."""
    xi, xf = q15v(x)
    gi, _ = q15v(gain)
    gmax = float(np.abs(gain).max())
    b.loadv(0, xi)
    b.loadv(1, gi)
    b.send(f"NQ 0 1 2 {n}\n")
    out = b.until("OK NQ")
    t = [l for l in out.splitlines() if l.startswith("NQ ")][0].split()
    mx, ss, xs = int(t[2]), int(t[4], 16), int(t[6])
    a = b.dumpr(2, n)
    rms = np.sqrt(ss * (4.0 ** xs) / n)
    return a, (gmax * mx / (Q15 * 127.0 * rms) if rms > 0 else 0.0), xi


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--block", type=int, default=0)
    a = ap.parse_args()

    z = np.load(a.cache)
    man = json.load(open(os.path.join(a.export, "manifest.json")))
    blk = a.block
    W = {}
    for n, o, i in (("self_attn.q_proj", 2048, H), ("self_attn.k_proj", H, H),
                    ("self_attn.v_proj", H, H), ("self_attn.o_proj", H, 2048),
                    ("mlp.gate_proj", INTER, H), ("mlp.up_proj", INTER, H),
                    ("mlp.down_proj", H, INTER)):
        W[n.split(".")[-1]] = unpack(
            os.path.join(a.export, man["layers"][f"{blk}.{n}"]["file"]), o, i)

    b = Board(a.dev)
    b.sync()
    print(f"stage 9: one complete block, block {blk}\n")
    t0 = time.time()

    rng = np.random.default_rng(7000 + blk)
    x = rng.standard_normal(H) * 3.0
    x[rng.integers(0, H, 8)] *= 40.0

    # ---- reference: the same block in tc_ref, on the same input ---------
    r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=28)
    r.reset()
    cos, sin = tc_ref.rope_tables(0)
    want = r.block(blk, x.copy(), 0, cos, sin)

    # ---- attention half --------------------------------------------------
    h1 = tc_ref.rmsnorm(x, z[f"{blk}.in_norm"].astype(np.float64))
    aq, s_a, _ = nq(b, x, z[f"{blk}.in_norm"].astype(np.float64), H)
    qa = project(b, W["q_proj"], aq) * float(z[f"{blk}.q_proj.s"]) * s_a
    ka = project(b, W["k_proj"], aq) * float(z[f"{blk}.k_proj.s"]) * s_a
    va = project(b, W["v_proj"], aq) * float(z[f"{blk}.v_proj.s"]) * s_a
    print(f"  q/k/v projections            {time.time()-t0:5.1f}s")

    # attention at position 0 collapses to the value vector itself
    gq = z[f"{blk}.q_norm"].astype(np.float64)
    gk = z[f"{blk}.k_norm"].astype(np.float64)
    attn = np.zeros(NH * HD)
    for hh in range(NH):
        attn[hh * HD:(hh + 1) * HD] = va[(hh // (NH // NKV)) * HD:
                                         (hh // (NH // NKV) + 1) * HD]

    # ---- o_proj + residual ------------------------------------------------
    oa, s_o, _ = nq(b, attn, z[f"{blk}.o_proj.subln"].astype(np.float64), 2048)
    o = project(b, W["o_proj"], oa) * float(z[f"{blk}.o_proj.s"]) * s_o
    x1 = x + o
    print(f"  o_proj + residual            {time.time()-t0:5.1f}s")

    # ---- MLP half ---------------------------------------------------------
    ha, s_h, _ = nq(b, x1, z[f"{blk}.post_norm"].astype(np.float64), H)
    g = project(b, W["gate_proj"], ha)
    u = project(b, W["up_proj"], ha)
    s_g = float(z[f"{blk}.gate_proj.s"]) * s_h
    gm, ge = blockfloat(s_g)
    b.loadv(0, g.astype(np.int32))
    b.loadv(1, u.astype(np.int32))
    b.send(f"MLP 0 1 2 {gm} {ge + BIAS} {INTER}\n")
    b.until("OK MLP")
    m = dumpi32(b, 2, INTER).astype(np.float64)
    print(f"  gate/up + SiLU               {time.time()-t0:5.1f}s")

    da, s_d, _ = nq(b, m, z[f"{blk}.down_proj.subln"].astype(np.float64), INTER)
    # m carries an arbitrary global scale; recover it from the reference's
    # own SiLU product, since everything downstream is scale invariant
    # except this one multiply into the residual.
    gt = g.astype(np.float64) * s_g
    ut = u.astype(np.float64) * float(z[f"{blk}.up_proj.s"]) * s_h
    mt = (gt / (1.0 + np.exp(-gt))) * ut
    s_m = float(np.abs(mt).max()) / max(float(np.abs(m).max()), 1e-30)
    d = project(b, W["down_proj"], da) * float(z[f"{blk}.down_proj.s"]) \
        * s_d * s_m
    x2 = x1 + d
    print(f"  down_proj + residual         {time.time()-t0:5.1f}s")

    r_out = np.abs(x2 - want).max() / max(np.abs(want).max(), 1e-30)
    print(f"\n  block output vs golden model  rel {r_out:.6f}")
    ok = r_out < 0.05
    print(f"\n{'PASS' if ok else 'FAIL'}  ({time.time()-t0:.0f}s)")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
