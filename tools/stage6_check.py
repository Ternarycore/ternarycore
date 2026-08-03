#!/usr/bin/env python3
"""stage6_check.py -- Q.K^T from the cache, against numpy.

Fills the KV cache with known keys, runs a query against all of them, and
compares every dot product.

  python tools/stage6_check.py

Key counts sit around the chunk boundary: the array covers 64 keys per
pass, so an off-by-one in the chunk loop is invisible at 63 and obvious at
65. The whole vector is compared rather than a checksum -- a checksum says
something disagrees, the vector says which chunk, and that is the
difference between knowing there is a bug and knowing where.
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


def dumpv_all(b, slot, n):
    """int32 read-back, one word at a time via the raw byte path."""
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


def run_case(b, blk, kvh, nkeys):
    rng = np.random.default_rng(blk * 31 + nkeys)
    K = rng.integers(-128, 128, (nkeys, HD)).astype(np.int8)
    q = rng.integers(-128, 128, HD).astype(np.int8)
    K[0, 0], q[0] = -128, -128          # the corner that broke the MAC once

    zeros = np.zeros(NKV * HD, dtype=np.int8)
    sc = np.zeros(NKV * 4, dtype=np.int32)
    for pos in range(nkeys):
        k = zeros.copy()
        k[kvh * HD:(kvh + 1) * HD] = K[pos]
        loadb(b, 5, k)
        loadb(b, 6, zeros)
        b.loadv(7, sc)
        b.send(f"KVW {blk} {pos} 5 6 7 {NKV} {HD}\n")
        b.until("OK KVW")

    loadb(b, 9, q)
    b.send(f"QKD {blk} {kvh} {nkeys - 1} 9 10\n")
    out = b.until("OK QKD")
    got = dumpv_all(b, 10, nkeys)

    want = K.astype(np.int32) @ q.astype(np.int32)
    d = got.astype(np.int64) - want.astype(np.int64)
    nz = int(np.count_nonzero(d))
    line = [l for l in out.splitlines() if l.startswith("QKCHK")][0]
    print(f"  blk {blk:2d} kvh {kvh} {nkeys:3d} keys  {line}")
    if nz:
        first = int(np.argmax(d != 0))
        print(f"    {nz}/{nkeys} wrong, first at key {first} "
              f"(chunk {first // 64}): got {got[first]} want {want[first]}")
    else:
        print(f"    {nkeys}/{nkeys} exact")
    return nz == 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    a = ap.parse_args()
    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")
    print("stage 5b: Q.K^T from the cache\n")

    cases = [(0, 0, 1), (0, 0, 63), (0, 0, 64), (0, 0, 65), (5, 3, 200)]
    ok = sum(int(run_case(b, *c)) for c in cases)
    print(f"\n{ok}/{len(cases)} exact")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
