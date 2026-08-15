"""Simulate the board's exact MLP-gate pipeline in Python.

The board's error fell monotonically with gate scale, which fits two
different stories: a design that loses precision at small magnitudes, or
firmware that does not implement the design. They want opposite fixes.

This reproduces the firmware's arithmetic step for step -- the same
block-float exponent, the same shifts, the same table and interpolation,
the same truncations. If it reproduces the board's error, the design is
wrong. If it comes out clean, the firmware diverges from the design.

  python tools/sim_mlp_gate.py
"""
import numpy as np

LUTN = 1024


def bf(x):
    """Positive float -> (mantissa in [2^30, 2^31), exponent), as sc_norm."""
    e, m = 0, float(x)
    while m < 2 ** 30:
        m *= 2; e -= 1
    while m >= 2 ** 31:
        m /= 2; e += 1
    return int(round(m)), e


# silu_lut[i] = silu((i-512)/16) in Q16.16, as build_luts computes it.
i = np.arange(LUTN)
xq = (i - 512) * 4096                       # Q16.16
xr = xq / 65536.0
lut = np.floor(xq * (65536.0 / (1 + np.exp(-xr))) / 65536.0).astype(np.int64)

print("span      sh   ixf range        worst |d|   correlation")
for span, n, seed in ((0.5, 1024, 21), (4.0, 3072, 22),
                      (20.0, 3072, 23), (40.0, 3072, 24)):
    rng = np.random.default_rng(seed)
    g = rng.integers(-130048, 130048, n).astype(np.int64)
    u = rng.integers(-130048, 130048, n).astype(np.int64)
    s_g = span / 130048.0

    Gm, Ge = bf(s_g)
    Ge += 8                                  # x * 256
    sa = su = 2
    sh = -(sa + 16 + Ge)

    t = (g >> sa) * (Gm >> 16)
    ixf = (t >> sh) if sh >= 0 else (t << (-sh))
    idx = (ixf >> 4) + 512
    frac = ixf & 15
    tail_hi = idx >= LUTN - 1
    tail_lo = idx < 0
    idx = np.clip(idx, 0, LUTN - 2)
    sv = lut[idx] + (((lut[idx + 1] - lut[idx]) * frac) >> 4)
    sv = np.where(tail_hi, ixf << 8, sv)     # SiLU(x) -> x
    sv = np.where(tail_lo, 0, sv)            # SiLU(x) -> 0
    m = sv * (u >> su)

    x = g * s_g
    want = x / (1 + np.exp(-x)) * u
    gn = m / max(abs(m).max(), 1)
    wn = want / abs(want).max()
    print(f"+-{span:<6} {sh:<4} {ixf.min():>7}..{ixf.max():<7}  "
          f"{np.abs(gn - wn).max():.5f}     "
          f"{np.corrcoef(gn, wn)[0, 1]:.6f}")
