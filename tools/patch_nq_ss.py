#!/usr/bin/env python3
"""patch_nq_ss.py -- nq_core's sum of squares can overflow, for n > 1024.

    while ((amx >> xs) > 2047) xs++;   /* n squares must fit 32 bits */

That bound is derived for n = 1024 and only for n = 1024:

    1024 * 2047^2 = 4,290,774,016   fits 2^32, by 0.1%
    2048 * 2047^2 = 8,581,548,032   does not
    3072 * 2047^2 = 12,872,322,048  does not

o_proj.subln is 2048 elements and down_proj.subln is 3072, so two of the
four RMSNorms in every block are outside the bound the comment claims.
Real vectors land around 22-28% of 2^32, so it is not happening -- but
the margin comes from the data being roughly Gaussian rather than from
anything the code guarantees, and a vector with many elements near its
maximum would wrap silently into a wrong scale.

The fix keeps the wire format identical. Accumulate in 64 bits, then
renormalize into 32 before reporting:

    while (ss >= 2^32) { ss >>= 2; xs++; }

because the host computes rms = sqrt(ss * 4^xs / n), and shifting ss
right by two while adding one to xs leaves that product unchanged. So
the reported pair stays two 32-bit numbers, no parser changes, and the
values are bit-identical on every vector that did not overflow -- which
is every vector ever tested. Provably inert where it has been exercised,
and correct where it had not.

Doing this before the fabric version matters: that datapath has to be
bit-exact with this function, and hardware is a bad place to discover
you enshrined an overflow.

  python tools/patch_nq_ss.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fw_exec.py")
s = open(p).read()

if "ss64" in s:
    sys.exit("already patched")

OLD_DECL = """    int v, u, w, q, mx = 0, amx = 0, xs = 0;
    unsigned int ss = 0u;
    long long inv, qq;
    unsigned long i;"""

NEW_DECL = """    int v, u, w, q, mx = 0, amx = 0, xs = 0;
    unsigned int ss;
    unsigned long long ss64 = 0ull;
    long long inv, qq;
    unsigned long i;"""

OLD_ACC = """        ss += (unsigned int)(u * u);"""
NEW_ACC = """        ss64 += (unsigned long long)(unsigned int)(u * u);"""

OLD_MX = """    if (mx == 0) mx = 1;"""
NEW_MX = """    if (mx == 0) mx = 1;

    /* The 2047 threshold above bounds n squares by 2^32 only for n = 1024,
       and two of the four RMSNorms in a block are wider than that. So the
       accumulator is 64-bit and gets renormalized here instead.

       The host computes rms = sqrt(ss * 4^xs / n), and (ss >> 2) with
       (xs + 1) leaves that product unchanged -- so the reported pair stays
       two 32-bit numbers and no parser has to know this happened. */
    while (ss64 >= (1ull << 32)) { ss64 >>= 2; xs++; }
    ss = (unsigned int)ss64;"""

for old, new in ((OLD_DECL, NEW_DECL), (OLD_ACC, NEW_ACC), (OLD_MX, NEW_MX)):
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:120]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("fw_exec.py: nq_core accumulates ss in 64 bits, reports 32 with xs adjusted")
