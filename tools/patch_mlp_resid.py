#!/usr/bin/env python3
"""patch_mlp_resid.py -- the MLP's contribution to the residual was ~0.

block_full.py computed

    d = project(down_proj, da) * down_proj.s * s_d * s_m

and that s_m is spurious. nq's returned scale is scale invariant, and it
has to be: q15v normalizes its input by the input's own maximum, so the
board's sum of squares is taken over a vector already normalized, and

    s = gmax * mx * max|x| / (Q15^2 * 127 * rms(x))

leaves max|x| and rms(x) both proportional to the input's magnitude.
Feed it m or feed it s_m*m and it returns the same number -- which is
the same scale invariance that lets RMSNorm cancel every global gain in
this design. Only exp and SiLU ever break it, and SiLU has already been
paid for by the time down_proj's SubLN sees the product.

So multiplying by s_m = 3.3e-05 scaled the entire MLP half out of the
residual. Measured: |x1| = 171.845, |d| = 0.0000 against a reference
contribution of 4.86.

And it passed. rel is measured against max|want| = 171.8 while the MLP
contributes 4.86, so a *completely absent* MLP reads as

    4.86 / 171.8 = 0.02830

against a threshold of 0.05. The reported rel 0.028250 was never
rounding error. It was the size of the missing half, and three
consecutive runs printed it as a PASS.

The sweep added by patch_mlp_sens.py is what caught it: sixteen-fold
changes in the MLP's contribution moved the error by four parts in a
million.

So the acceptance now requires the check to be capable of failing --
a 4x error in the MLP's contribution must cost at least 5x the error.
A threshold alone already proved it will accept a dead half.

  python tools/patch_mlp_resid.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "block_full.py")
s = open(p).read()

if "sensitivity" in s and "* s_d * s_m" not in s:
    sys.exit("already patched")

OLD_D = '''    d = project(b, W["down_proj"], da) * float(z[f"{blk}.down_proj.s"]) \\
        * s_d * s_m'''

NEW_D = '''    # No s_m here, and that is the whole point. nq's scale is invariant
    # to its input's magnitude -- q15v normalizes by max|x|, so the
    # returned gmax*mx*max|x| / (Q15^2 * 127 * rms(x)) has the input's
    # magnitude in both numerator and denominator. Feed it m or s_m*m and
    # it answers the same, because RMSNorm cancels global gain and SiLU
    # has already been paid for upstream.
    #
    # Multiplying by s_m = 3.3e-05 therefore scaled the MLP's entire
    # contribution to the residual out of existence: |d| = 0.0000 against
    # a reference contribution of 4.86, with |x1| = 171.8.
    d = project(b, W["down_proj"], da) * float(z[f"{blk}.down_proj.s"]) \\
        * s_d'''

OLD_OK = '''    for k in (0.25, 0.5, 1.0, 2.0, 4.0):
        rk = np.abs(x1 + d * k - want).max() / max(np.abs(want).max(), 1e-30)
        print(f"    s_m x{k:<5g}  rel {rk:.6f}")

    ok = r_out < 0.05'''

NEW_OK = '''    rk = {}
    for k in (0.25, 0.5, 1.0, 2.0, 4.0):
        rk[k] = np.abs(x1 + d * k - want).max() / max(np.abs(want).max(), 1e-30)
        print(f"    MLP x{k:<5g}  rel {rk[k]:.6f}")
    sens = min(rk[0.25], rk[4.0]) / max(r_out, 1e-30)
    print(f"    sensitivity {sens:6.1f}x")

    # Two conditions, because the threshold alone passed a block whose
    # MLP contributed nothing at all. rel is measured against |x1| = 171.8
    # and the MLP contributes 4.86, so an absent MLP reads as 0.0283 --
    # comfortably under 0.05. Three runs printed that as a PASS.
    #
    # Requiring the error to move when the MLP's contribution moves is
    # what makes this check able to fail.
    ok = r_out < 0.05 and sens > 5.0
    if not ok and r_out < 0.05:
        print("\\n  FAIL: the block agrees with the reference but the "
              "comparison cannot see the MLP -- that is not a pass")'''

for old, new in ((OLD_D, NEW_D), (OLD_OK, NEW_OK)):
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:160]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("block_full.py: spurious s_m removed from the residual, "
      "acceptance now requires sensitivity")
