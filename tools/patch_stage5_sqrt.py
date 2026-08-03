"""Make stage5_check's sqrt test independent of the implementation.

The reference mirrored the firmware's algorithm exactly -- even exponent,
mantissa shifted up 32, integer root -- which only proves C and Python
agree on a recipe. Squaring the result back and comparing against the
input checks the answer instead of the method.

Idempotent; safe to run twice.
"""
p = "tools/stage5_check.py"
s = open(p).read()

old = """            else:
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
                          f"want {float(want):.10g}")"""

new = """            else:
                want = None          # checked by squaring it back, below
            gm, ge = sct(b, op, ma, ea, mb, eb)
            n += 1
            got = Fraction(gm) * Fraction(2) ** ge
            if want is None:
                # Independent of how the root is computed. Mirroring the
                # firmware's algorithm here would agree with a wrong one
                # as happily as with a right one.
                ok = abs(got * got - A) <= 2 * A / Fraction(1 << 30)
                want = got * got
            else:
                ok = ulp_ok(gm, ge, want)
            if not ok:
                bad += 1
                if bad <= 2:
                    print(f"  {name}: got {float(got):.10g} "
                          f"want {float(want):.10g}")"""

if "squaring it back" not in s:
    assert old in s, "anchor missing"
    s = s.replace(old, new, 1)
    open(p, "w").write(s)
print("patched" if "squaring it back" in s else "MISS")
