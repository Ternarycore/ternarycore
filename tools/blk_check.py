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
        rng = np.random.default_rng(7000 + blk)
        x = rng.standard_normal(H) * 3.0
        x[rng.integers(0, H, 8)] *= 40.0

        r.reset()
        want = r.block(blk, x.copy(), 0, cos, sin)
        got, dt = run_blk(b, blk, x, fab)
        e0 = rel(got, want)

        # The sensitivity check block_full earned the hard way: scale the
        # input and the output has to follow. A block missing a whole
        # term still tracks a scaled input badly, and that is what
        # separates "close" from "computing the right thing".
        r.reset()
        want2 = r.block(blk, (x * 0.25).copy(), 0, cos, sin)
        got2, _ = run_blk(b, blk, x * 0.25, fab)
        e1 = rel(got2, want2)
        sens = rel(got2, want) / max(e0, 1e-12)

        good = e0 < a.tol and e1 < a.tol and sens > 5.0
        ok &= good
        print(f"  block {blk:2d}   rel {e0:.6f}   x0.25 rel {e1:.6f}   "
              f"sensitivity {sens:5.1f}x   {dt:5.2f} s   "
              f"{'ok' if good else 'FAIL'}", flush=True)

    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
