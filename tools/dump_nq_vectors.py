#!/usr/bin/env python3
"""dump_nq_vectors.py -- golden vectors for the fabric normalizer, from silicon.

The fabric RMSNorm+quantizer has to agree with nq_core. The tempting way
to check that is to reimplement nq_core in Python and compare the Verilog
against it -- which tests whether two of my transcriptions agree, not
whether the hardware matches the firmware that is actually running.

So the reference comes off the board. Run NQ on real inputs, capture what
silicon returned, and let the testbench compare against that. If the
Verilog matches these files it matches the thing it is replacing, with no
third copy of the arithmetic in between.

  python tools/dump_nq_vectors.py -o sim/vectors

Writes per case: x.hex, g.hex (32-bit two's complement, one per line),
o8.hex (the int8 result), and meta.txt with n, mx, ss, xs.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board

Q15 = 32767

#      name        n     how x is drawn
CASES = (("uniform",   1024, "uniform"),
         ("gauss",     1024, "gauss"),
         ("spiky",     1024, "spiky"),
         ("wide",      3072, "gauss"),
         ("small",     1024, "small"))


def make_x(kind, n, rng):
    """Distributions chosen for what they do to mx and xs, not for realism.

    'spiky' pins a few elements at full scale and leaves the rest tiny,
    which is the shape that drives mx far from the bulk and makes the
    reciprocal's precision actually matter. 'small' keeps everything near
    zero, where the output is a handful of levels and any error in the
    scale is immediately visible as a wrong level.
    """
    if kind == "uniform":
        x = rng.integers(-Q15, Q15 + 1, n)
    elif kind == "gauss":
        x = np.clip(np.rint(rng.standard_normal(n) * (Q15 / 4)), -Q15, Q15)
    elif kind == "spiky":
        x = np.rint(rng.standard_normal(n) * 200)
        x[rng.integers(0, n, 6)] = Q15
    else:                                   # small
        x = rng.integers(-300, 301, n)
    return np.clip(x, -Q15, Q15).astype(np.int32)


def hexlines(v, bits=32):
    m = (1 << bits) - 1
    return "\n".join(f"{int(a) & m:0{bits // 4}x}" for a in v) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("-o", "--outdir", default="sim/vectors")
    a = ap.parse_args()

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    out = a.outdir if os.path.isabs(a.outdir) else os.path.join(root, a.outdir)
    os.makedirs(out, exist_ok=True)

    b = Board(a.dev)
    b.sync()
    print("dumping NQ reference vectors from the board\n")

    index = []
    for ci, (name, n, kind) in enumerate(CASES):
        rng = np.random.default_rng(900 + ci)
        x = make_x(kind, n, rng)
        g = np.clip(np.rint(np.abs(rng.standard_normal(n)) * (Q15 / 3)),
                    1, Q15).astype(np.int32)

        b.loadv(0, x)
        b.loadv(1, g)
        b.send(f"NQ 0 1 2 {n}\n")
        res = b.until("OK NQ", timeout=30)
        tok = [l for l in res.splitlines() if l.startswith("NQ ")][0].split()
        mx, ss, xs = int(tok[2]), int(tok[4], 16), int(tok[6])
        o8 = b.dumpr(2, n)

        d = os.path.join(out, name)
        os.makedirs(d, exist_ok=True)
        open(os.path.join(d, "x.hex"), "w").write(hexlines(x))
        open(os.path.join(d, "g.hex"), "w").write(hexlines(g))
        open(os.path.join(d, "o8.hex"), "w").write(hexlines(o8, 8))
        open(os.path.join(d, "meta.txt"), "w").write(
            f"n {n}\nmx {mx}\nss {ss}\nxs {xs}\n")

        index.append((name, n, mx, ss, xs))
        print(f"  {name:9s} n={n:<5d} |x|max {int(np.abs(x).max()):>6d}  "
              f"mx {mx:>12d}  ss {ss:>12d}  xs {xs}  "
              f"o8 range [{int(o8.min())}, {int(o8.max())}]")

    with open(os.path.join(out, "index.txt"), "w") as f:
        for name, n, mx, ss, xs in index:
            f.write(f"{name} {n} {mx} {ss} {xs}\n")
    print(f"\n{len(CASES)} cases -> {out}")


if __name__ == "__main__":
    main()
