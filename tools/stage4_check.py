#!/usr/bin/env python3
"""stage4_check.py -- does the KV cache round-trip through bit planes?

Write known vectors, read them back reconstructed from the sliced form,
require exact equality. There is no arithmetic here and so no floor to
argue about: the layout is either right or wrong.

  python tools/stage4_check.py

The cases target the boundaries the indexing can get wrong. Positions 63
and 64 straddle a K chunk. 0 and 511 are the ends of the range. Vectors
with bit 7 set catch sign extension, and -128 in particular is the value
that broke the ternary cell once already. Two heads are interleaved
because K strides by (block, head, chunk) and V by (block, head,
position), and a stride with the wrong factor corrupts its neighbour
rather than itself.
"""
import argparse, os, sys
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from stage_check import Board

HD, NKV = 128, 8


def loadb(b, slot, vec):
    v = np.asarray(vec, dtype=np.int8)
    b.send(f"LOADB {slot} {v.size}\n")
    import time
    time.sleep(0.2)
    b.send(v.tobytes())
    b.until("OK B")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    a = ap.parse_args()

    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")
    print("stage 4: KV cache round-trip through bit planes\n")

    rng = np.random.default_rng(4)
    cases = [(0, 0), (0, 63), (0, 64), (0, 511), (13, 1), (27, 300)]
    truth = {}

    # Write every case first, so a later write that corrupts an earlier
    # entry is caught -- which a write-then-read-immediately loop misses.
    for blk, pos in cases:
        k = rng.integers(-128, 128, NKV * HD).astype(np.int8)
        v = rng.integers(-128, 128, NKV * HD).astype(np.int8)
        k[0], k[HD] = -128, 127          # the corners that break sign handling
        v[0], v[HD] = 127, -128
        sc = np.zeros(NKV * 4, dtype=np.int32)
        for h in range(NKV):
            sc[h * 4 + 0] = 20000 + h + pos      # k mantissa
            sc[h * 4 + 1] = -13 - h              # k exponent
            sc[h * 4 + 2] = 30000 + h            # v mantissa
            sc[h * 4 + 3] = -15 + h              # v exponent
        loadb(b, 5, k)
        loadb(b, 6, v)
        b.loadv(7, sc)
        b.send(f"KVW {blk} {pos} 5 6 7 {NKV} {HD}\n")
        b.until("OK KVW")
        truth[(blk, pos)] = (k, v, sc)

    bad = 0
    for blk, pos in cases:
        k, v, sc = truth[(blk, pos)]
        for h in (0, 3, 7):
            for which, want in ((0, k), (1, v)):
                b.send(f"KVR {blk} {pos} {h} 8 {which}\n")
                out = b.until("OK KVR")
                got = b.dumpr(8, HD)
                exp = want[h * HD:(h + 1) * HD]
                line = [l for l in out.splitlines()
                        if l.startswith("KVS")][0].split()
                gs = [int(x) for x in line[1:5]]
                ws = sc[h * 4:h * 4 + 4].tolist()
                nz = int(np.count_nonzero(got.astype(int) - exp.astype(int)))
                if nz or gs != ws:
                    bad += 1
                    print(f"  blk {blk:2d} pos {pos:3d} h{h} "
                          f"{'K' if which == 0 else 'V'}: "
                          f"{nz} wrong, scales {gs} vs {ws}")
    total = len(cases) * 3 * 2
    print(f"\n{total - bad}/{total} vectors exact")
    sys.exit(0 if bad == 0 else 1)


if __name__ == "__main__":
    main()
