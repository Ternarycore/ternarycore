#!/usr/bin/env python3
"""stage8_check.py -- P.V from the cache, against numpy.

Fills the V cache with known vectors, feeds known probabilities, and
compares all 128 int32 outputs.

  python tools/stage8_check.py

Key counts sit on the 128-position chunk boundary, which is where P.V's
geometry differs from Q.K^T's: keys are the array's depth here, and
bit-serial int8 spends eight slots per element, so a pass covers 128 keys
rather than 64. 127/128/129 is where an off-by-one in the accumulation
loop shows up, and 300 exercises three chunks so a bug that only drops
the last one is still visible.

Probabilities are non-negative by construction, so the interesting corner
is not sign but zero: a probability of zero must contribute nothing even
where the cache holds stale bit planes beyond the current position.
"""
import argparse, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from stage_check import Board

HD, NKV = 128, 8


def loadb(b, slot, vec):
    v = np.asarray(vec, dtype=np.int8)
    b.send(f"LOADB {slot} {v.size}\n")
    time.sleep(0.15)
    b.send(v.tobytes())
    b.until("OK B")


def dumpi32(b, slot, n):
    b.send(f"DUMPR {slot} {n * 4}\n")
    hdr = b""
    while not hdr.endswith(b"\n"):
        d = os.read(b.fd, 1)
        if d:
            hdr += d
    buf = b""
    while len(buf) < n * 4:
        d = os.read(b.fd, n * 4 - len(buf))
        if d:
            buf += d
    b.until("OK DR")
    return np.frombuffer(buf, dtype=np.int32)


def run_case(b, blk, kvh, npos):
    rng = np.random.default_rng(blk * 71 + npos)
    V = rng.integers(-128, 128, (npos, HD)).astype(np.int8)
    pr = rng.integers(0, 128, npos).astype(np.int8)
    V[0, 0], V[0, 1] = -128, 127          # corners that break sign handling
    pr[min(1, npos - 1)] = 0              # a zero probability must vanish

    zeros = np.zeros(NKV * HD, dtype=np.int8)
    sc = np.zeros(NKV * 4, dtype=np.int32)
    for pos in range(npos):
        v = zeros.copy()
        v[kvh * HD:(kvh + 1) * HD] = V[pos]
        loadb(b, 5, zeros)
        loadb(b, 6, v)
        b.loadv(7, sc)
        b.send(f"KVW {blk} {pos} 5 6 7 {NKV} {HD}\n")
        b.until("OK KVW")

    loadb(b, 9, pr)
    b.send(f"PV {blk} {kvh} {npos - 1} 9 10\n")
    out = b.until("OK PV")
    got = dumpi32(b, 10, HD)

    want = pr.astype(np.int32) @ V.astype(np.int32)
    d = got.astype(np.int64) - want.astype(np.int64)
    nz = int(np.count_nonzero(d))
    line = [l for l in out.splitlines() if l.startswith("PVCHK")][0]
    print(f"  blk {blk:2d} kvh {kvh} {npos:3d} keys  {line}")
    if nz:
        first = int(np.argmax(d != 0))
        print(f"    {nz}/{HD} wrong, first at dim {first} "
              f"(column group {first // 64}): got {got[first]} "
              f"want {want[first]}")
    else:
        print(f"    {HD}/{HD} exact")
    return nz == 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    a = ap.parse_args()
    b = Board(a.dev)
    b.sync()
    print("stage 7: P.V from the cache\n")

    cases = [(0, 0, 1), (0, 0, 127), (0, 0, 128), (0, 0, 129), (7, 5, 300)]
    ok = sum(int(run_case(b, *c)) for c in cases)
    print(f"\n{ok}/{len(cases)} exact")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
