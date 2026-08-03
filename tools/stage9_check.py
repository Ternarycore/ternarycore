#!/usr/bin/env python3
"""stage9_check.py -- SiLU and the gate product, against the reference.

  python tools/stage9_check.py

Both sides are normalized before comparison, deliberately. Everything
downstream of this product is RMSNorm followed by an absmax quantizer, so
a global scale factor is unobservable to the model; comparing raw
magnitudes would report a failure the model cannot see. What must match
is the shape.

The cases target SiLU's shape rather than its length. Small gate values
sit in the near-linear region around zero. Large positive ones reach the
table's end, where SiLU(x) approaches x. Large negative ones are where
the function turns over -- and where an index clamped to the wrong end of
the table gives a wrong answer that still looks reasonable.
"""
import argparse, os, sys
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from stage_check import Board

BIAS = 512


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
    if x <= 0:
        return 0, 0
    e, m = 0, float(x)
    while m < (1 << 30):
        m *= 2; e -= 1
    while m >= (1 << 31):
        m /= 2; e += 1
    return int(round(m)), e


def run_case(b, name, n, gscale, seed):
    rng = np.random.default_rng(seed)
    gacc = rng.integers(-130048, 130048, n).astype(np.int32)
    uacc = rng.integers(-130048, 130048, n).astype(np.int32)
    s_g = gscale / 130048.0            # so gacc * s_g spans +-gscale

    b.loadv(0, gacc)
    b.loadv(1, uacc)
    gm, ge = blockfloat(s_g)
    b.send(f"MLP 0 1 2 {gm} {ge + BIAS} {n}\n")
    out = b.until("OK MLP")
    got = dumpi32(b, 2, n).astype(np.float64)

    x = gacc.astype(np.float64) * s_g
    want = (x / (1.0 + np.exp(-x))) * uacc.astype(np.float64)

    # Only the shape is defined; normalize both sides.
    gn = got / max(np.abs(got).max(), 1e-30)
    wn = want / max(np.abs(want).max(), 1e-30)
    err = np.abs(gn - wn).max()
    corr = float(np.corrcoef(gn, wn)[0, 1])
    line = [l for l in out.splitlines() if l.startswith("MLP")][0]
    print(f"  {name:<22} n={n:<5} {line}")
    print(f"    worst |d| {err:.5f}   correlation {corr:.8f}")
    return err < 0.02 and corr > 0.9999


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    a = ap.parse_args()
    b = Board(a.dev)
    b.sync()
    print("stage 8: SiLU and the gate product\n")

    cases = [("near-linear",   1024,  0.5, 21),
             ("typical",       3072,  4.0, 22),
             ("large positive", 3072, 20.0, 23),
             ("saturating",    3072, 40.0, 24),
             ("wide mixed",    3072, 12.0, 25)]
    ok = sum(int(run_case(b, *c)) for c in cases)
    print(f"\n{ok}/{len(cases)} match the reference shape")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
