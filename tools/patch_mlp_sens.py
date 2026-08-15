#!/usr/bin/env python3
"""patch_mlp_sens.py -- ask whether the block check can see the MLP scale.

Switching s_m from the reference-derived value to the analytic one moved
the block's error by nothing at all: rel 0.028250 both times, identical to
six decimals. Two readings that agree that exactly are either a correct
result or a blind instrument, and the difference matters -- the analytic
scale is the one number the token loop cannot get any other way, so
"verified" here has to mean verified.

The input has eight elements deliberately scaled by 40, and rel is a max
over the vector. If that max sits on a spike where the MLP's contribution
is negligible, the check is measuring the attention half and reporting a
pass for the MLP half for free.

So sweep s_m across a factor of sixteen and print the error at each. If
rel barely moves, this comparison does not test the MLP scale and the
token loop needs a different one before it is trusted.

  python tools/patch_mlp_sens.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "block_full.py")
s = open(p).read()

OLD = '''    r_out = np.abs(x2 - want).max() / max(np.abs(want).max(), 1e-30)
    print(f"\\n  block output vs golden model  rel {r_out:.6f}")
    ok = r_out < 0.05'''

NEW = '''    r_out = np.abs(x2 - want).max() / max(np.abs(want).max(), 1e-30)
    print(f"\\n  block output vs golden model  rel {r_out:.6f}")

    # Is this comparison actually sensitive to the MLP's output scale?
    # Switching s_m from reference-derived to analytic moved rel by
    # nothing, to six decimals. Either it is right or the metric cannot
    # see it, and those want opposite responses. rel is a max over the
    # vector and the input carries eight deliberate 40x spikes, so the
    # max may well sit where the MLP contributes nothing.
    print(f"    |x1| {np.abs(x1).max():10.3f}   |d| {np.abs(d).max():10.3f}"
          f"   ratio {np.abs(d).max()/max(np.abs(x1).max(), 1e-30):.4f}")
    for k in (0.25, 0.5, 1.0, 2.0, 4.0):
        rk = np.abs(x1 + d * k - want).max() / max(np.abs(want).max(), 1e-30)
        print(f"    s_m x{k:<5g}  rel {rk:.6f}")

    ok = r_out < 0.05'''

if "Is this comparison actually sensitive" in s:
    sys.exit("already patched")
if OLD not in s:
    sys.exit("anchor missing")
open(p, "w").write(s.replace(OLD, NEW, 1))
print("block_full.py: MLP scale sensitivity sweep added")
