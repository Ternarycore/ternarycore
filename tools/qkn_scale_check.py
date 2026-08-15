#!/usr/bin/env python3
"""qkn_scale_check.py -- is the QK-norm scale derivation right?

The KV cache stores a block-float scale per key and per value. Until now
the host computed them in float64 from the reference model and handed
them to the board, which is fine for a check and impossible for a block
driver. qkn_core now derives them from its own shifts:

    scale = mx * 2^(s1+st) * (gmax/32767) / (127 * sqrt(ss * 4^(s1+sq)/hd))

with the input's own scale cancelling for q and k -- the QK-norm's
division by the root-mean-square is deferred, so it lives in the scale
rather than in the data -- and *not* cancelling for v, which is absmax
quantized and never normalized at all.

That asymmetry is the whole risk. A scale wrong by a constant reads as
rounding in everything downstream, and this project has shipped three of
those. So this checks the derivation directly, against float64, before
anything is built on top of it.

  python tools/qkn_scale_check.py

Two properties, not one:

  * the scale matches float64 to a tolerance far tighter than an int8
    quantizer can notice, and
  * for q and k it does not move when the input is scaled, because the
    deferred rms is what makes it absolute. A formula that accidentally
    kept the input's scale would still match on a single case -- it is
    the second column that catches it.

The magnitudes are swept deliberately. The first version of the NQD
shift check had every case landing on the same shift, and passed a bug
that only appears at the boundary. s1, sq and st all have to move.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from block_check import blockfloat, q15v, BIAS, Q15, HD

NH, NKV = 16, 8


def qkn(b, acc, gq, cq, nh, hd, gm, ge, norm, am, ae):
    """One QKN call; returns the per-head scales the board derived."""
    b.loadv(0, acc.astype(np.int32))
    b.loadv(1, gq.astype(np.int32))
    b.loadv(2, cq.astype(np.int32))
    b.send(f"QGX {gm} {ge + BIAS} {norm} {am} {ae + BIAS}\n")
    b.until("OK QGX")
    b.send(f"QKN 0 1 2 3 4 {nh} {hd}\n")
    b.until("OK QK", timeout=30)
    b.send(f"QSC {nh}\n")
    out = b.until("OK QSC", timeout=30)
    s = np.zeros(nh)
    for line in out.splitlines():
        t = line.split()
        if len(t) >= 6 and t[0] == "QSC":
            s[int(t[1])] = int(t[3], 16) * (2.0 ** int(t[5]))
    return s


def rope_q(pos):
    cos, sin = tc_ref.rope_tables(pos)
    ci = np.clip(np.rint(cos[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(sin[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
    # tc_ref.rope wants full-length tables (each half repeated); the
    # board wants the two halves concatenated. Same numbers, and the
    # reference uses the *quantized* ones so table rounding is not part
    # of what this is measuring.
    f = np.concatenate([ci, ci]) / 32768.0
    g = np.concatenate([si, si]) / 32768.0
    return np.concatenate([ci, si]), f, g


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--tol", type=float, default=2e-3)
    a = ap.parse_args()

    b = Board(a.dev)
    b.sync()
    rng = np.random.default_rng(4242)
    print("QK-norm scale derivation vs float64\n")
    print(f"  {'case':<22} {'worst rel':>10} {'scale drift':>12}   heads")
    print("  " + "-" * 62)

    ok = True

    # ---- q and k: the deferred rms, so the input scale must cancel ------
    for name, mag, pos in (("q  tiny,   pos 0", 1e2, 0),
                           ("q  small,  pos 0", 1e3, 0),
                           ("q  medium, pos 7", 1e4, 7),
                           ("q  large,  pos 63", 1e6, 63),
                           ("q  spiky,  pos 3", 1e5, 3)):
        acc = (rng.standard_normal(NH * HD) * mag)
        if "spiky" in name:
            acc[rng.integers(0, NH * HD, 12)] *= 60.0
        acc = np.rint(acc).astype(np.int64)
        acc = np.clip(acc, -(1 << 30), (1 << 30)).astype(np.int32)
        gain = rng.standard_normal(HD) * 0.4 + 1.0
        gq, gs = q15v(gain)
        gmax = float(np.abs(gain).max())
        gm, ge = blockfloat(gmax)
        cq, cf, sf = rope_q(pos)

        # A is the accumulator's own scale, and for q/k it must not matter
        got = {}
        for tag, A in (("A", 3.7e-5), ("A*1024", 3.7e-5 * 1024)):
            am, ae = blockfloat(A)
            got[tag] = qkn(b, acc, gq, cq, NH, HD, gm, ge, 1, am, ae)

        # Two references. tc_ref.rmsnorm adds EPS = 1e-6 inside the
        # square root; the firmware does not, and never has -- the QK-norm
        # has been 4/4 exact against tc_ref since stage 3 because at the
        # magnitudes a real model produces, EPS is a 1e-6 effect. It stops
        # being negligible when mean(x^2) approaches EPS itself, which the
        # smallest case below is chosen to reach. Reporting both columns
        # is what turns "the small case fails" into "EPS is why", and the
        # difference between those two sentences is the whole reason this
        # script exists.
        want = np.zeros(NH)
        want0 = np.zeros(NH)
        for h in range(NH):
            v = acc[h * HD:(h + 1) * HD].astype(np.float64) * 3.7e-5
            _, s = tc_ref.quant_a(tc_ref.rope(tc_ref.rmsnorm(v, gain),
                                              cf, sf))
            want[h] = s
            r0 = (v / np.sqrt((v * v).mean())) * gain
            _, s0 = tc_ref.quant_a(tc_ref.rope(r0, cf, sf))
            want0[h] = s0
        rel_eps = float(np.max(np.abs(got["A"] - want) / want))
        rel = float(np.max(np.abs(got["A"] - want0) / want0))
        drift = float(np.max(np.abs(got["A*1024"] - got["A"])
                             / np.maximum(got["A"], 1e-30)))
        good = rel < a.tol and drift < 1e-9
        ok &= good
        print(f"  {name:<22} {rel:>10.2e} {drift:>12.2e}   "
              f"{'ok' if good else 'FAIL'}"
              + (f"   (vs tc_ref with EPS: {rel_eps:.1e})"
                 if rel_eps > 10 * rel + 1e-9 else ""))

    # ---- v: absmax only, so the input scale must NOT cancel -------------
    ones = np.full(HD, Q15, dtype=np.int32)
    ident = np.concatenate([np.full(HD // 2, Q15, dtype=np.int32),
                            np.zeros(HD // 2, dtype=np.int32)])
    for name, mag, A in (("v  small", 1e2, 3.7e-5),
                         ("v  large", 1e6, 3.7e-5),
                         ("v  large, A*1024", 1e6, 3.7e-5 * 1024)):
        acc = np.clip(np.rint(rng.standard_normal(NKV * HD) * mag),
                      -(1 << 30), (1 << 30)).astype(np.int32)
        am, ae = blockfloat(A)
        got = qkn(b, acc, ones, ident, NKV, HD, 1 << 30, -30, 0, am, ae)
        want = np.array([tc_ref.quant_a(
            acc[h * HD:(h + 1) * HD].astype(np.float64) * A)[1]
            for h in range(NKV)])
        rel = float(np.max(np.abs(got - want) / want))
        good = rel < a.tol
        ok &= good
        print(f"  {name:<22} {rel:>10.2e} {'':>12}   "
              f"{'ok' if good else 'FAIL'}")

    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
