#!/usr/bin/env python3
"""patch_mlp_scale.py -- take the MLP's output scale off the reference.

block_full.py recovers the MLP product's scale by computing the same
product in float64 from the reference weights and dividing. That is fine
for a check that has a reference to hand. The token loop does not, and
this is the only scale in the block obtained that way -- so as written it
would have stopped the loop at its very last step, after everything else
worked.

It is recoverable analytically. cmd_mlp already reports every shift it
chose:

    o[i] = silu(x) * up[i] * 65536 * 2^-(ss + su + sm)

so true magnitude is o[i] * s_u * 2^(ss+su+sm) / 65536, where s_u is
up_proj's own scale times the norm's. sa does not appear: it is consumed
normalizing the table index, not the result.

Keeps the reference-derived value and prints the ratio, so the next run
says whether the token loop's arithmetic is right rather than leaving it
to be discovered in the loop.

  python tools/patch_mlp_scale.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "block_full.py")
s = open(p).read()

OLD_CALL = '''    b.send(f"MLP 0 1 2 {gm} {ge + BIAS} {INTER}\\n")
    b.until("OK MLP")'''
NEW_CALL = '''    b.send(f"MLP 0 1 2 {gm} {ge + BIAS} {INTER}\\n")
    mo = b.until("OK MLP")
    mtok = [l for l in mo.splitlines() if l.startswith("MLP ")][0].split()
    su_, ss_, sm_ = int(mtok[4]), int(mtok[6]), int(mtok[8])'''

OLD_SCALE = '''    # m carries an arbitrary global scale; recover it from the reference's
    # own SiLU product, since everything downstream is scale invariant
    # except this one multiply into the residual.
    gt = g.astype(np.float64) * s_g
    ut = u.astype(np.float64) * float(z[f"{blk}.up_proj.s"]) * s_h
    mt = (gt / (1.0 + np.exp(-gt))) * ut
    s_m = float(np.abs(mt).max()) / max(float(np.abs(m).max()), 1e-30)'''

NEW_SCALE = '''    # m carries an arbitrary global scale, and everything downstream is
    # invariant to it except this one multiply into the residual.
    #
    # Analytically, from the shifts cmd_mlp reports:
    #   o[i] = silu(x) * up[i] * 65536 * 2^-(ss + su + sm)
    # so s_u * 2^(ss+su+sm) / 65536 recovers true magnitude. sa is absent
    # because it is spent normalizing the table index, not the result.
    #
    # The reference-derived value below is kept only to check this one.
    # It was what the block used to run on, and it is the single number in
    # the block that the token loop could not have obtained -- it would
    # have failed at the last step with everything before it working.
    s_u = float(z[f"{blk}.up_proj.s"]) * s_h
    s_m = s_u * (2.0 ** (ss_ + su_ + sm_)) / 65536.0

    gt = g.astype(np.float64) * s_g
    ut = u.astype(np.float64) * s_u
    mt = (gt / (1.0 + np.exp(-gt))) * ut
    s_ref = float(np.abs(mt).max()) / max(float(np.abs(m).max()), 1e-30)
    print(f"  MLP out scale   analytic {s_m:.6e}   reference {s_ref:.6e}"
          f"   ratio {s_m / s_ref:.6f}")'''

for old, new in ((OLD_CALL, NEW_CALL), (OLD_SCALE, NEW_SCALE)):
    if new.split("\\n")[0] in s and old not in s:
        sys.exit("already patched")
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:120]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("block_full.py: MLP output scale now analytic, reference kept as check")
