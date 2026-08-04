#!/usr/bin/env python3
"""attn_probe.py -- where attention diverges, before anything downstream.

blk_check says position 0 is exact and positions 1..3 are 4-6% out. That
is a block-output number, and a block output is attention plus a residual
plus an MLP; it says something is wrong and nothing about what.

This compares the attention output itself. The board leaves it in S_ATT
and nothing overwrites it before BLK returns, so it can be read straight
out; tc_ref traces the same tensor at {blk}.attn_out. Two things make the
comparison meaningful:

  * per head, because a scale error common to all sixteen would be
    normalised away downstream and a per-head one would not, and those
    are different bugs;
  * direction only, because S_ATT carries an arbitrary common scale by
    construction -- the o_proj normalisation cancels it -- so the angle
    is the whole content and the magnitude is noise.

It also reports the softmax probabilities for head 0, which is the one
number that says whether the scores reaching exp are right. If the
probabilities are flat when they should be peaked, the q and k scales are
in the wrong units and everything downstream of exp is a consequence.

  python tools/attn_probe.py --positions 4

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from block_check import dumpi32, blockfloat, q15v, loadb, H, BIAS, Q15

NH, HD = 16, 128


def rope_slot(pos):
    cos, sin = tc_ref.rope_tables(pos)
    ci = np.clip(np.rint(cos[:64] * 32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(sin[:64] * 32768), -Q15, Q15).astype(np.int32)
    return np.concatenate([ci, si])


def board_block(b, blk, x, pos, fab=1):
    b.loadv(16, rope_slot(pos))
    b.send(f"POS {pos}\n"); b.until("OK POS")
    xi, xf = q15v(x)
    m, e = blockfloat(xf)
    b.loadv(0, xi.astype(np.int32))
    b.send(f"XSC {m} {e + BIAS}\n"); b.until("OK XSC")
    b.send(f"BLK {blk} {fab}\n")
    b.until("OK BLK", timeout=120)
    return dumpi32(b, 6, NH * HD).astype(np.float64)


def ang(a, w):
    """Relative error after the best common scale -- direction only."""
    na, nw = np.linalg.norm(a), np.linalg.norm(w)
    if na < 1e-30 or nw < 1e-30:
        return 1.0
    return float(np.linalg.norm(a / na - w / nw))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--blk", type=int, default=0)
    ap.add_argument("--positions", type=int, default=4)
    a = ap.parse_args()

    r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=28)
    b = Board(a.dev)
    b.sync()

    rng = np.random.default_rng(7000 + a.blk)
    xs = []
    for _ in range(a.positions):
        v = rng.standard_normal(H) * 3.0
        v[rng.integers(0, H, 8)] *= 40.0
        xs.append(v)

    r.reset()
    print(f"attention output, block {a.blk}, direction only "
          f"(the common scale is cancelled downstream)\n")
    print(f"  {'pos':>3}  {'all heads':>10}  {'worst head':>10} "
          f"{'':>4}  head 0, int8 and dots")
    print("  " + "-" * 74)

    for pos, x in enumerate(xs):
        r.trace = {}
        r.block(a.blk, x.copy(), pos, *tc_ref.rope_tables(pos))
        want = np.asarray(r.trace[f"{a.blk}.attn_out"],
                          dtype=np.float64).ravel()
        got = board_block(b, a.blk, x, pos)

        whole = ang(got, want)
        per = [ang(got[h * HD:(h + 1) * HD], want[h * HD:(h + 1) * HD])
               for h in range(NH)]
        worst = int(np.argmax(per))

        # Head 0's q int8 and its dot products. Neither involves a
        # scale anywhere -- quant_a is absmax, and the dots are int8
        # times int8 -- so agreement here says the quantization and the
        # cache are right and the fault is in what reaches exp, while
        # disagreement says it is upstream of that and the scales are
        # innocent. Splitting it this way costs one extra QKD.
        # qkn_core is verified against this exact reference at stage 3,
        # so if its output is wrong its inputs are. The gain is the one
        # input the driver fetches for itself, out of the DDR record.
        gn = dumpi32(b, 26, HD).astype(np.int64)
        gq = np.load(a.cache)[f"{a.blk}.q_norm"].astype(np.float64)
        gw = q15v(gq)[0].astype(np.int64)
        dg = int(np.abs(gn - gw).max())

        q8 = b.dumpr(17, NH * HD)
        qr = np.asarray(r.trace[f"{a.blk}.q_roped"]).reshape(NH, HD)[0]
        qa = tc_ref.quant_a(qr)[0]
        dq = int(np.abs(q8[:HD].astype(int) - qa.astype(int)).max())

        loadb(b, 30, q8[:HD])
        b.send(f"QKD {a.blk} 0 {pos} 30 22\n")
        b.until("OK QKD", timeout=60)
        gd = dumpi32(b, 22, pos + 1).astype(np.int64)
        wd = np.asarray(r.trace[f"{a.blk}.h0.dots"]).ravel().astype(np.int64)
        dd = int(np.abs(gd - wd).max())

        pr = r.trace.get(f"{a.blk}.h0.probs")
        ps = ("  ".join(f"{v:.3f}" for v in np.asarray(pr).ravel()[:6])
              if pr is not None else "(not traced)")
        print(f"  {pos:>3}  {whole:>10.6f}  {max(per):>10.6f} "
              f"(h{worst:02d})  gain max|d| {dg}   q8 max|d| {dq}   dots max|d| {dd}")
        print(f"       ref probs   {ps}")
        print(f"       ref dots    "
              + "  ".join(f"{int(v)}" for v in wd[:6]))
        print(f"       board dots  "
              + "  ".join(f"{int(v)}" for v in gd[:6]))

    print("\n  a flat probability row where it should be peaked means the "
          "scores\n  reaching exp are in the wrong units, and everything "
          "after it follows.")


if __name__ == "__main__":
    main()
