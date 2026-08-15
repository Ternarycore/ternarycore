#!/usr/bin/env python3
"""pph.py -- where a projection's 827 us goes, phase by phase.

    python tools/pph.py

Each phase is run at two repetition counts and the difference taken, so
the serial round trip and the command parse subtract out. The board is
repeatable to well under a millisecond (see tools/tokrep.py), so the
slope between two counts is the operator and nothing else.

  0  activations in          1024 writes to S_ACTWR, which is a FIFO
  1  the array               16 tile launches and their done polls
  2  results out             2048 accesses: write S_RIDX, read S_RDATA
  3  results out, read only  1024 accesses, no index write

Phase 3 returns wrong data on purpose. Without the index write every read
hits the same accumulator -- but it costs exactly what an
auto-incrementing read port would cost, so the RTL change can be priced
before anybody writes it.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse, os, sys, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board

NAMES = ["activations in (1024 x S_ACTWR)",
         "the array (16 tile launches)",
         "results out (2048 accesses)",
         "results out, read only (1024)"]


def slope(b, ph, lo, hi):
    ts = []
    for n in (lo, hi):
        t0 = time.time()
        b.send(f"PPH {ph} {n}\n")
        b.until("OK PPH", timeout=300)
        ts.append(time.time() - t0)
    return (ts[1] - ts[0]) / (hi - lo) * 1e6      # us per repetition


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--lo", type=int, default=50)
    ap.add_argument("--hi", type=int, default=200)
    a = ap.parse_args()

    b = Board(a.dev); b.sync()
    b.loadv(3, np.arange(1024, dtype=np.int32) % 127)
    b.send("PAGEDMA 0\n"); b.until("OK PD", timeout=30)

    print(f"\n  one projection, by phase   ({a.lo} vs {a.hi} repetitions)\n")
    us = [slope(b, p, a.lo, a.hi) for p in range(4)]
    whole = us[0] + us[1] + us[2]
    for p in range(4):
        print(f"    {p}  {NAMES[p]:<34} {us[p]:8.1f} us"
              + (f"   {100*us[p]/whole:5.1f}%" if p < 3 else ""))
    print(f"\n    {'phases 0+1+2':<37} {whole:8.1f} us"
          f"   against 827 us measured for the whole call")
    saved = us[2] - us[3]
    print(f"\n  an auto-incrementing S_RDATA would save {saved:.1f} us a "
          f"call,\n  {100*saved/whole:.1f}% of a projection, for about three "
          f"lines of Verilog.")
    print(f"  DMA has to attack {us[0]+us[2]:.1f} us -- and S_ACTWR is a "
          f"FIFO, so\n  that half needs the activation BRAM exposed as an "
          f"AXI4 range first.")


if __name__ == "__main__":
    main()
