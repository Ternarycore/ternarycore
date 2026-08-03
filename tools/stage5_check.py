#!/usr/bin/env python3
"""stage5_check.py -- block-float scalars against exact arithmetic.

Checked against Fraction and math.isqrt rather than float. The board
represents magnitudes a double cannot always hold exactly, so comparing
one approximation with another would show agreement without showing
correctness.

  python tools/stage5_check.py

Every result must land within 1 ulp of the 31-bit mantissa. That is the
smallest error the representation admits, so it is a bound rather than a
tolerance picked to pass. isqrt64 is required to be exactly
floor(sqrt(v)), because it is exact by construction.
"""
import argparse, math, os, sys
from fractions import Fraction
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from stage_check import Board

BIAS = 512          # exponents cross the wire unsigned


def norm(m, e):
    """Reference normalization into [2^30, 2^31)."""
    if m == 0:
        return 0, 0
    while m < (1 << 30):
        m <<= 1; e -= 1
    while m >= (1 << 31):
        m >>= 1; e += 1
    return m, e


def ulp_ok(gm, ge, want):
    """Is (gm, ge) within one mantissa ulp of the exact rational `want`?"""
    if want == 0:
        return gm == 0
    got = Fraction(gm) * Fraction(2) ** ge
    return abs(got - want) <= abs(want) / Fraction(1 << 30)


def sct(b, op, ma, ea, mb=0, eb=0):
    b.send(f"SCT {op} {ma} {ea + BIAS} {mb} {eb + BIAS}\n")
    out = b.until("OK SCT")
    line = [l for l in out.splitlines() if l.startswith("SC ")][0].split()
    return int(line[1], 16), int(line[2])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    a = ap.parse_args()

    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")
    print("stage 5a: block-float scalars\n")

    rng = np.random.default_rng(5)
    fails = 0

    # --- isqrt64, exact by construction --------------------------------
    vals = [0, 1, 2, 3, 4, (1 << 62), (1 << 62) - 1, (1 << 62) + 1,
            (1 << 31) ** 2, (1 << 31) ** 2 - 1]
    vals += [int(v) for v in rng.integers(0, 1 << 62, 14)]
    bad = 0
    for v in vals:
        gm, _ = sct(b, 4, (v >> 32) & 0xFFFFFFFF, 0, v & 0xFFFFFFFF, 0)
        if gm != math.isqrt(v):
            bad += 1
            print(f"  isqrt64({v}) = {gm}, want {math.isqrt(v)}")
    print(f"  isqrt64      {len(vals)-bad}/{len(vals)} exact")
    fails += bad

    # --- normalize, multiply, divide, sqrt ------------------------------
    for name, op in (("normalize", 0), ("multiply", 1),
                     ("divide", 2), ("sqrt", 3)):
        bad = n = 0
        for _ in range(16):
            ma = int(rng.integers(1, 1 << 31))
            mb = int(rng.integers(1, 1 << 31))
            ea = int(rng.integers(-60, 60))
            eb = int(rng.integers(-60, 60))
            A = Fraction(ma) * Fraction(2) ** ea
            B = Fraction(mb) * Fraction(2) ** eb
            if op == 0:
                want = A
            elif op == 1:
                want = A * B
            elif op == 2:
                want = A / B
            else:
                nm, ne = ma, ea
                if ne & 1:
                    nm >>= 1; ne += 1
                want = Fraction(math.isqrt(nm << 32)) * Fraction(2) ** ((ne - 32) // 2)
            gm, ge = sct(b, op, ma, ea, mb, eb)
            n += 1
            if not ulp_ok(gm, ge, want):
                bad += 1
                if bad <= 2:
                    got = Fraction(gm) * Fraction(2) ** ge
                    print(f"  {name}: got {float(got):.10g} "
                          f"want {float(want):.10g}")
        print(f"  {name:<12} {n-bad}/{n} within 1 ulp")
        fails += bad

    print(f"\n{'all exact' if fails == 0 else str(fails) + ' failures'}")
    sys.exit(0 if fails == 0 else 1)


if __name__ == "__main__":
    main()
