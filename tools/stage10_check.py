#!/usr/bin/env python3
"""stage10_check.py -- can the firmware read the constants in DDR?

meta.bin's record layout exists twice: once in build_ddr_meta.py's GAINS
table and once in the firmware's gain_off/gain_len arrays. They are the
same layout written in two languages by two different pieces of code,
which is a standing invitation for them to drift.

This asks the board to hand back what it thinks it has, and compares
against the file. Every gain, several blocks, plus both block-float
scalars -- the maximum the Q15 normalization divided out, and the
projection's own weight scale.

  python tools/stage10_check.py

Blocks 0, 13 and 27 rather than just 0: a wrong stride is invisible at
block 0, where the offset is zero and any stride multiplies to nothing.
That is the arithmetic that made q_proj's packing bug invisible for eight
stages, and it costs nothing to not repeat it.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import struct
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board
from block_check import dumpi32
from build_ddr_meta import GAINS, SCALES_OFF, GMAX_OFF, STRIDE, PROJS


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--meta",
                    default=os.path.expanduser("~/tc-ddr/meta.bin"))
    a = ap.parse_args()

    img = open(a.meta, "rb").read()
    b = Board(a.dev)
    b.sync()
    print("stage 10a: the firmware reads the constants in DDR\n")

    ok = True
    for blk in (0, 13, 27):
        rec = img[blk * STRIDE:(blk + 1) * STRIDE]
        for gi, (name, n, off) in enumerate(GAINS):
            b.send(f"MREAD {blk} {gi} 0\n")
            out = b.until("OK MR", timeout=20)
            line = [l for l in out.splitlines()
                    if l.startswith("MREAD")][0].split()
            got = dumpi32(b, 0, n)
            want = np.frombuffer(rec, dtype="<i4", count=n, offset=off)

            gm, ge = int(line[4], 16), int(line[5])
            wm, we = struct.unpack_from("<Ii", rec, GMAX_OFF + gi * 8)
            sm, se = int(line[7], 16), int(line[8])
            pm, pe = struct.unpack_from("<Ii", rec, SCALES_OFF + gi * 8)

            nd = int(np.count_nonzero(got - want))
            good = (nd == 0 and int(line[2]) == n
                    and (gm, ge) == (wm, we) and (sm, se) == (pm, pe))
            ok &= good
            print(f"  blk {blk:2d} {name:16s} {n:5d} elems  "
                  f"{'exact' if nd == 0 else str(nd) + ' DIFFER'}  "
                  f"gmax {'ok' if (gm, ge) == (wm, we) else 'BAD'}  "
                  f"{PROJS[gi]}.s {'ok' if (sm, se) == (pm, pe) else 'BAD'}")
            if not good and nd:
                i = int(np.argmax(got != want))
                print(f"      first at {i}: got {got[i]} want {want[i]}")

    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
