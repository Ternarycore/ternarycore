#!/usr/bin/env python3
"""tokrep.py -- TOK at one position, many times, reported as a minimum.

tokcurve.py times each position once, and its own numbers say what that
is worth: position 15 comes out faster than position 0, which cannot be
true, so there is roughly 60 ms of host-side jitter on a 2.9 s
measurement. Anything smaller than that is not visible to it.

The minimum is the right estimator here. Serial read scheduling only ever
adds time, so repeated runs of a deterministic board are the true cost
plus a non-negative random amount; the smallest sample is the closest to
the truth, and the median is not.

  python tools/tokrep.py --n 15
  python tools/tokrep.py --n 15 --pos 511

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import statistics
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from block_check import blockfloat, q15v, H, BIAS
from ternary import rope_slot


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--n", type=int, default=15)
    ap.add_argument("--pos", type=int, default=0)
    ap.add_argument("--blocks", type=int, default=28)
    ap.add_argument("--cpu", action="store_true")
    a = ap.parse_args()

    b = Board(a.dev)
    b.sync()
    fab = 0 if a.cpu else 1

    rng = np.random.default_rng(11)
    x = rng.standard_normal(H) * 3.0
    xi, xf = q15v(x)
    m, e = blockfloat(xf)

    b.loadv(16, rope_slot(a.pos))
    b.send(f"POS {a.pos}\n"); b.until("OK POS")

    ts = []
    for i in range(a.n):
        b.loadv(0, xi.astype(np.int32))
        b.send(f"XSC {m} {e + BIAS}\n"); b.until("OK XSC")
        t0 = time.time()
        b.send(f"TOK {a.blocks} {fab}\n")
        b.until("OK TOK", timeout=600)
        ts.append(time.time() - t0)

    ts.sort()
    print(f"\n  TOK at position {a.pos}, {a.n} runs, "
          f"{'fabric' if fab else 'soft CPU'} normalizer\n")
    print(f"    min      {ts[0]*1000:9.1f} ms   <- the number to use")
    print(f"    median   {statistics.median(ts)*1000:9.1f} ms")
    print(f"    max      {ts[-1]*1000:9.1f} ms")
    print(f"    spread   {(ts[-1]-ts[0])*1000:9.1f} ms   "
          f"({(ts[-1]-ts[0])/ts[0]*100:.1f}%)")
    print(f"\n    per block, from the minimum: {ts[0]*1000/a.blocks:.2f} ms")


if __name__ == "__main__":
    main()
