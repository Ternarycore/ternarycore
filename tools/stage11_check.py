#!/usr/bin/env python3
"""stage11_check.py -- fabric normalizer vs the CPU, on the same silicon.

NQD and NQF are the same operation: RMSNorm and absmax int8 quantize,
with the gain read from DDR. One runs on the soft CPU, one on the fabric
at 0x44400000. They must agree exactly -- every element, and mx, ss, xs.

That is the right comparison and it took a moment to see. The obvious
one, against sim/vectors/o8.hex, is wrong: those were captured with
*random* gains written into a slot, while NQF reads the *model* gain from
DDR. Comparing them would have compared two different computations and
called the difference a bug.

NQD is already verified 19/19 against the golden model, so agreeing with
it is the property that matters. The x vectors are reused from the
capture because their distributions were chosen to stress the reciprocal
-- 'spiky' pins six elements at full scale so nearly every output sits on
a rounding boundary -- and all of them satisfy |x| <= 32767, which makes
NQD's auto-range shift a no-op and the two paths directly comparable.

Three things could differ here that simulation cannot see: timing (closed
at +0.252 ns), the CDMA's route to a slave Vivado tried to exclude from
its address space, and the data cache holding stale lines for a
destination the CDMA wrote behind its back.

Also times both. The point was 32.05 + 18.02 cycles per element becoming
3.05, and an unmeasured speedup is a hoped-for speedup.

  python tools/stage11_check.py

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board

#  x vectors from the capture; gain index chosen to match the length
#  (0 = in_norm, 1024 elements; 5 = down_proj.subln, 3072)
CASES = (("uniform", 0), ("gauss", 0), ("spiky", 0),
         ("small", 0), ("wide", 5))
BLOCKS = (0, 13, 27)


def load_hex(path, bits):
    v = [int(l, 16) for l in open(path) if l.strip()]
    a = np.array(v, dtype=np.int64)
    return np.where(a >= (1 << (bits - 1)), a - (1 << bits), a)


def run(b, cmd, tok="OK NQ"):
    t0 = time.time()
    b.send(cmd)
    out = b.until(tok, timeout=30)
    return out, time.time() - t0


def scalars(out):
    t = [l for l in out.splitlines() if l.startswith("NQ mx")][0].split()
    return int(t[2]), int(t[4], 16), int(t[6])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--vec", default="sim/vectors")
    a = ap.parse_args()

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    vdir = a.vec if os.path.isabs(a.vec) else os.path.join(root, a.vec)

    b = Board(a.dev)
    b.sync()
    print("stage 11: fabric normalizer vs the CPU, same board, same gain\n")

    ok, total, tc, tf = 0, 0, 0.0, 0.0
    for name, gi in CASES:
        x = load_hex(os.path.join(vdir, name, "x.hex"), 32).astype(np.int32)
        n = len(x)
        for blk in BLOCKS:
            b.loadv(0, x)
            o_cpu, t1 = run(b, f"NQD 0 {gi} 2 {blk} {n}\n")
            cpu = b.dumpr(2, n)
            mx_c, ss_c, xs_c = scalars(o_cpu)

            b.loadv(0, x)                       # NQD shifts in place
            o_fab, t2 = run(b, f"NQF 0 {gi} 3 {blk} {n}\n")
            fab = b.dumpr(3, n)
            mx_f, ss_f, xs_f = scalars(o_fab)

            d = int(np.count_nonzero(cpu.astype(int) - fab.astype(int)))
            same = (d == 0 and (mx_c, ss_c, xs_c) == (mx_f, ss_f, xs_f))
            ok += int(same)
            total += 1
            tc += t1
            tf += t2
            print(f"  {name:8s} blk {blk:2d} n={n:<5d} "
                  f"{'exact' if same else str(d) + ' DIFFER'}   "
                  f"CPU {t1*1000:6.1f} ms   fabric {t2*1000:6.1f} ms   "
                  f"{t1/max(t2,1e-9):4.1f}x")
            if not same and d == 0:
                print(f"    scalars: cpu ({mx_c},{ss_c},{xs_c}) "
                      f"fab ({mx_f},{ss_f},{xs_f})")

    print(f"\n  {ok}/{total} exact")
    print(f"  total CPU {tc:.2f} s, fabric {tf:.2f} s, "
          f"{tc/max(tf,1e-9):.1f}x end to end")
    print("  (both include UART for the operands, so this understates it)")
    print(f"\n{'PASS' if ok == total else 'FAIL'}")
    sys.exit(0 if ok == total else 1)


if __name__ == "__main__":
    main()
