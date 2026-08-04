#!/usr/bin/env python3
"""stage10b_check.py -- NQD and PJO, the two slot-to-slot operators.

NQD is checked against the golden model rather than against NQ, because
checking it against NQ would only prove the two agree about a shift they
were both given. What has to be true is that a raw projection
accumulator, handed over with no host arithmetic at all, produces the
same int8 the reference produces from the same numbers in float64.

PJO is checked against PROJ on the same data at offset zero -- exactly,
not approximately. It is the same core function with a pointer moved, so
anything other than bit-identical means the offset went somewhere it
should not have.

  python tools/stage10b_check.py

Accumulator magnitudes on purpose: 1024*127 = 130048 is the largest a
projection can produce, and NQD's whole job is that the host no longer
has to know that.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from stage2_check import loadb
from block_check import dumpi32
from build_ddr_meta import GAINS


def nqd(b, slot, gi, dst, blk, n):
    b.send(f"NQD {slot} {gi} {dst} {blk} {n}\n")
    out = b.until("OK NQ", timeout=30)
    sh = int([l for l in out.splitlines()
              if l.startswith("NQD")][0].split()[2])
    return b.dumpr(dst, n), sh


def check_nqd(b, z):
    ok = True
    rng = np.random.default_rng(31)
    for blk in (0, 27):
        for gi, (name, n, _) in enumerate(GAINS):
            # A projection accumulator, at the magnitude one really has.
            x = rng.integers(-130048, 130049, n).astype(np.int64)
            b.loadv(0, x.astype(np.int32))
            got, sh = nqd(b, 0, gi, 1, blk, n)

            g = z[f"{blk}.{name}"].astype(np.float64)
            want, _ = tc_ref.quant_a(tc_ref.rmsnorm(x.astype(np.float64), g))
            d = got.astype(int) - want.astype(int)
            worst = int(np.abs(d).max())
            nd = int(np.count_nonzero(d))
            good = worst <= 1
            ok &= good
            print(f"  NQD blk {blk:2d} {name:16s} n={n:<5d} sh={sh:<2d} "
                  f"{nd:4d}/{n} differ, max |d| {worst}"
                  f"{'' if good else '   FAIL'}")
    return ok


def check_pjo(b):
    """Same weights, same activations, offset 0 versus offset 1024."""
    ok = True
    rng = np.random.default_rng(32)
    a = rng.integers(-128, 128, 2048).astype(np.int8)

    for off in (0, 1024):
        loadb(b, 5, a)                       # the long vector, once
        b.send(f"PJO 5 {off} 6 16 0\n")
        b.until("OK PJO", timeout=30)
        via_pjo = dumpi32(b, 6, 1024)

        loadb(b, 3, a[off:off + 1024])       # the old way: host slices it
        b.send("PROJ 3 4 16 0\n")
        b.until("OK PJ", timeout=30)
        via_proj = dumpi32(b, 4, 1024)

        nd = int(np.count_nonzero(via_pjo - via_proj))
        ok &= nd == 0
        print(f"  PJO aoff {off:5d}  vs PROJ on the same slice: "
              f"{'identical' if nd == 0 else str(nd) + ' DIFFER'}")
    return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    a = ap.parse_args()

    z = np.load(a.cache)
    b = Board(a.dev)
    b.sync()
    print("stage 10b: NQD and PJO\n")

    ok = check_nqd(b, z)
    print()
    ok &= check_pjo(b)
    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
