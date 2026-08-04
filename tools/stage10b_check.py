#!/usr/bin/env python3
"""stage10b_check.py -- NQD and PJO, the two slot-to-slot operators.

NQD is checked against the golden model rather than against NQ, because
checking it against NQ would only prove the two agree about a shift they
were both given. What has to be true is that a raw projection
accumulator, handed over with no host arithmetic at all, produces the
same int8 the reference produces from the same numbers in float64.

The magnitude is swept, and the shift predicted rather than accepted.
The first version of this check drew every vector at 130048, so all
twelve cases reported sh=2 -- the auto-ranging that is NQD's whole
purpose got one branch exercised twelve times, under a PASS. It found a
real bug on its first run at 65535, where the firmware chose its shift
by truncation and applied it by rounding.

Which is why rsh is duplicated below rather than approximated: the
prediction has to round the same way the board does, or the check
disagrees with correct firmware at exactly the boundary it exists for.

PJO is checked against PROJ on the same data -- exactly, not
approximately. It is the same core function with a pointer moved, so
anything other than bit-identical means the offset went somewhere it
should not have.

  python tools/stage10b_check.py

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


def rsh(v, s):
    """The firmware's symmetric right shift, exactly."""
    if s <= 0:
        return v
    return ((v + (1 << (s - 1))) >> s if v >= 0
            else -(((-v) + (1 << (s - 1))) >> s))


def nqd(b, slot, gi, dst, blk, n):
    b.send(f"NQD {slot} {gi} {dst} {blk} {n}\n")
    out = b.until("OK NQ", timeout=30)
    sh = int([l for l in out.splitlines()
              if l.startswith("NQD")][0].split()[2])
    return b.dumpr(dst, n), sh


def one_nqd(b, z, blk, gi, name, n, x):
    """One NQD case, including whether it chose the shift we predict."""
    b.loadv(0, x.astype(np.int32))
    got, sh = nqd(b, 0, gi, 1, blk, n)

    amx = int(np.abs(x).max())
    want_sh = 0
    while rsh(amx, want_sh) > 32767:
        want_sh += 1

    g = z[f"{blk}.{name}"].astype(np.float64)
    want, _ = tc_ref.quant_a(tc_ref.rmsnorm(x.astype(np.float64), g))
    d = got.astype(int) - want.astype(int)
    worst, nd = int(np.abs(d).max()), int(np.count_nonzero(d))

    good = worst <= 1 and sh == want_sh
    print(f"  blk {blk:2d} {name:16s} n={n:<5d} |x|max {amx:>8d}  "
          f"sh={sh} (want {want_sh})  {nd:4d}/{n} differ, max |d| {worst}"
          f"{'' if good else '   FAIL'}")
    return good


def check_nqd(b, z):
    ok = True
    rng = np.random.default_rng(31)

    # 32767 fits nq_core's 16x16 product and 32768 does not, so they must
    # choose different shifts. 65535 is the case that broke the firmware:
    # it truncates to exactly 32767 and rounds to 32768.
    print("  -- magnitude sweep, in_norm on block 0 --")
    for mag in (1000, 32767, 32768, 65535, 65536, 130048, 2000000):
        x = rng.integers(-mag, mag + 1, 1024).astype(np.int64)
        x[0] = mag                  # pin the maximum so the shift is decided
        ok &= one_nqd(b, z, 0, 0, "in_norm", 1024, x)

    print("\n  -- every gain, both ends of the model --")
    for blk in (0, 27):
        for gi, (name, n, _) in enumerate(GAINS):
            # A projection accumulator, at the magnitude one really has.
            x = rng.integers(-130048, 130049, n).astype(np.int64)
            ok &= one_nqd(b, z, blk, gi, name, n, x)
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
