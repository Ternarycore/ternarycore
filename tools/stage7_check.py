#!/usr/bin/env python3
"""stage7_check.py -- softmax against the reference.

Two checks, because they fail differently. The int8 probabilities are
compared elementwise with tc_ref's, and the attention weights are
reconstructed from the reported scalars and required to sum to one. A
result can have the right shape and the wrong scale, and only the second
notices.

  python tools/stage7_check.py

The cases vary what makes softmax hard, not what makes it long. Flat
scores spread quantization error across every key; peaked scores put
everything on one and lean on the exp table's tail; widely spread K
scales exercise the exponent alignment, which nothing before this stage
has needed.
"""
import argparse, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from stage_check import Board

HD, NKV, PMAX = 128, 8, 127
BIAS = 512


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


def blockfloat(x):
    """Positive float -> (mantissa in [2^30,2^31), exponent)."""
    if x <= 0:
        return 0, 0
    e = 0
    m = float(x)
    while m < (1 << 30):
        m *= 2; e -= 1
    while m >= (1 << 31):
        m /= 2; e += 1
    return int(round(m)), e


def run_case(b, name, npos, spread, peak, seed):
    rng = np.random.default_rng(seed)
    blk, kvh = 0, 0

    # Scores as they arrive: int32 dots plus a per-position K scale.
    dots = (rng.standard_normal(npos) * peak * 2e5).astype(np.int32)
    ks = np.exp(rng.standard_normal(npos) * spread) * 3e-5
    vs = np.exp(rng.standard_normal(npos) * spread) * 7e-5
    s_q = 4.1e-4

    sc = np.zeros(NKV * 4, dtype=np.int32)
    zeros = np.zeros(NKV * HD, dtype=np.int8)
    for pos in range(npos):
        km, ke = blockfloat(ks[pos])
        vm, ve = blockfloat(vs[pos])
        sc[kvh * 4:kvh * 4 + 4] = [km, ke, vm, ve]
        loadb(b, 5, zeros)
        loadb(b, 6, zeros)
        b.loadv(7, sc)
        b.send(f"KVW {blk} {pos} 5 6 7 {NKV} {HD}\n")
        b.until("OK KVW")

    b.loadv(3, dots)
    qm, qe = blockfloat(s_q)
    b.send(f"SM {blk} {kvh} {npos-1} 3 {qm} {qe + BIAS} 11 12\n")
    b.until("OK SM")
    got = b.dumpr(11, npos)
    so = dumpi32(b, 12, 4)
    wmax, vemax, sume = int(so[0]), int(so[1]), int(so[2])

    # Reference, deferred-normalization form, on the same numbers.
    score = dots.astype(np.float64) * s_q * ks * (HD ** -0.5)
    e = np.exp(score - score.max())
    w = e * vs
    want = np.rint(w / w.max() * PMAX).astype(int)

    d = got.astype(int) - want
    nz = int(np.count_nonzero(d))
    worst = int(np.abs(d).max()) if npos else 0

    # The two reported scalars are what closes the normalization
    # downstream, so check them against the reference directly rather than
    # reconstructing something that happens to come out near 1.0.
    got_wmax = wmax * (2.0 ** vemax)
    got_sume = sume / 65536.0
    rel_w = abs(got_wmax - w.max()) / w.max()
    rel_s = abs(got_sume - e.sum()) / e.sum()

    print(f"  {name:<22} n={npos:<4} diff {nz}/{npos}, max |d| {worst}, "
          f"mean {d.mean():+.3f}   wmax {rel_w*100:5.2f}%  sum-exp "
          f"{rel_s*100:5.2f}%")
    return worst <= 1 and rel_w < 0.01 and rel_s < 0.01


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    a = ap.parse_args()
    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")
    print("stage 6: softmax\n")

    cases = [("flat scores",      32,  0.05, 0.05, 11),
             ("peaked scores",    32,  0.05, 3.00, 12),
             ("spread K scales",  32,  1.50, 0.50, 13),
             ("one key",           1,  0.10, 1.00, 14),
             ("chunk boundary",   65,  0.60, 0.80, 15),
             ("long context",    200,  0.80, 1.20, 16)]
    ok = sum(int(run_case(b, *c)) for c in cases)
    print(f"\n{ok}/{len(cases)} within 1 LSB with the scale closing")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
