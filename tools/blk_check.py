#!/usr/bin/env python3
"""blk_check.py -- the block driver, against the golden model.

block_full.py runs the same block, but the host is in the middle of it:
every activation and every accumulator crosses 115200 baud, twenty-one
seconds a block. BLK runs the whole thing on the board -- normalize,
quantize, seven projections off DDR, both residual adds, SiLU -- and the
only things on the wire are the input vector, the output vector and one
block-float scale.

So this compares two numbers that were computed the same way and one
number that was not: tc_ref's float64 block on the host.

  python tools/blk_check.py                 # block 0, CPU normalizer
  python tools/blk_check.py --fab           # ... via the fabric
  python tools/blk_check.py --blocks 0,13,27

The acceptance is block_full's, unchanged and for the same reason. A
relative error is not enough on its own: the MLP once contributed
nothing and the block still scored 0.028, because that was the size of
the missing half. So the input is perturbed and the output has to move
with it -- a block that ignores its own MLP cannot follow a scaled one.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from block_check import dumpi32, blockfloat, q15v, H, BIAS, Q15


def rope_slot(pos):
    """The rotation for this position, 64 cosines then 64 sines in Q15.

    512 bytes, and the same for all twenty-eight blocks, so the host
    sends it once a token rather than the board holding a 512-entry
    table. That table is a better idea and can wait until something is
    measured to want it."""
    cos, sin = tc_ref.rope_tables(pos)
    ci = np.clip(np.rint(cos[:64] * 32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(sin[:64] * 32768), -Q15, Q15).astype(np.int32)
    return np.concatenate([ci, si])


def run_blk(b, blk, x, fab, cmd="BLK", pos=0):
    """One block on the board. Returns the output vector in true units."""
    b.loadv(16, rope_slot(pos))
    b.send(f"POS {pos}\n")
    b.until("OK POS")
    xi, xf = q15v(x)
    m, e = blockfloat(xf)
    b.loadv(0, xi.astype(np.int32))
    b.send(f"XSC {m} {e + BIAS}\n")
    b.until("OK XSC")
    t0 = time.time()
    b.send(f"{cmd} {blk} {fab}\n" if cmd == "BLK" else f"{cmd} {blk} {fab}\n")
    out = b.until(f"OK {cmd}", timeout=600)
    dt = time.time() - t0
    tok = [l for l in out.splitlines() if l.startswith(cmd + " m")]
    if not tok:
        raise RuntimeError(f"{cmd}: no scale line in {out!r}")
    t = tok[0].split()
    om, oe = int(t[2], 16), int(t[4])
    v = dumpi32(b, 0, H).astype(np.float64)
    return v * om * (2.0 ** oe), dt


def make_xs(blk, n):
    """One input per position, all different, spikes included."""
    rng = np.random.default_rng(7000 + blk)
    return [np.where(np.arange(H) < 0, 0.0, v)
            for v in (spike(rng) for _ in range(n))]


def spike(rng):
    x = rng.standard_normal(H) * 3.0
    x[rng.integers(0, H, 8)] *= 40.0
    return x


def board_seq(b, blk, xs, fab):
    """A fresh sequence from position 0.

    The cache accumulates as it goes, so this always starts at 0 and
    walks up. Nothing here resets the board's cache: writing position p
    overwrites what a previous sequence left there, and attention at p
    only ever reads 0..p, all of which this sequence has just written.
    """
    out, t = [], 0.0
    for pos, x in enumerate(xs):
        g, dt = run_blk(b, blk, x, fab, pos=pos)
        out.append(g)
        t += dt
    return out, t


def ref_seq(r, blk, xs):
    r.reset()
    return [r.block(blk, x.copy(), pos, *tc_ref.rope_tables(pos))
            for pos, x in enumerate(xs)], None


def rel(a, w):
    d = np.linalg.norm(a - w)
    return d / max(np.linalg.norm(w), 1e-30)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--blocks", default="0")
    ap.add_argument("--fab", action="store_true",
                    help="normalize in fabric instead of on the soft CPU")
    ap.add_argument("--tol", type=float, default=0.05)
    ap.add_argument("--positions", type=int, default=1,
                    help="how many positions to walk, from 0 upward")
    a = ap.parse_args()

    fab = 1 if a.fab else 0
    blocks = [int(t) for t in a.blocks.split(",")]
    r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=28)
    cos, sin = tc_ref.rope_tables(0)

    b = Board(a.dev)
    b.sync()
    print(f"block driver on the board, normalizer "
          f"{'in fabric' if fab else 'on the CPU'}\n")

    ok = True
    for blk in blocks:
        xs = make_xs(blk, a.positions)
        want, _ = ref_seq(r, blk, xs)
        got, dt = board_seq(b, blk, xs, fab)

        # The sensitivity check block_full earned the hard way: scale the
        # input and the output has to follow. A block missing a whole
        # term still tracks a scaled input badly, and that is what
        # separates "close" from "computing the right thing".
        #
        # It has to be its own sequence from position 0. Re-running one
        # position with a scaled input rewrites that position's cache
        # entry, and every later position then attends over a key that
        # belongs to neither run.
        xs2 = [x * 0.25 for x in xs]
        want2, _ = ref_seq(r, blk, xs2)
        got2, _ = board_seq(b, blk, xs2, fab)

        for pos in range(a.positions):
            e0 = rel(got[pos], want[pos])
            e1 = rel(got2[pos], want2[pos])
            sens = rel(got2[pos], want[pos]) / max(e0, 1e-12)
            good = e0 < a.tol and e1 < a.tol and sens > 5.0
            ok &= good
            print(f"  block {blk:2d} pos {pos:3d}   rel {e0:.6f}   "
                  f"x0.25 rel {e1:.6f}   sensitivity {sens:6.1f}x   "
                  f"{'ok' if good else 'FAIL'}", flush=True)
        print(f"    {dt:5.2f} s for {a.positions} position"
              f"{'s' if a.positions != 1 else ''}", flush=True)

    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
