"""Make QKN's gain product normalize by the data instead of a fixed 15.

Stage 3 passed on synthetic accumulators and fails on real ones. k_norm's
gains span 42x from largest to median, so a typical gain is 777 in Q15 and
a fixed >>15 divides the accumulator by 42 before the 8-bit quantizer sees
it. q_norm spans 6.2x, which is why q's worst error was 2 and k's was 6.

Third appearance of the same bug: a shift sized for a theoretical maximum
rather than the vector's actual one.

Idempotent; safe to run twice.
"""
p = "tools/fw_exec_s3.py"
s = open(p).read()

old = """        for (i = 0; i < hd; i++)
            u[i] = rsh(rsh(qh[i], s1) * g[i], 15);    /* 16x16 -> 32 */
"""

new = """        /* The gain product is normalized by what it actually reaches,
           not by a fixed 15. k_norm's gains span 42x, so a typical one is
           777 in Q15 and a fixed shift divides the accumulator by 42
           before an 8-bit quantizer ever sees it. Third appearance of the
           same shape of bug: a shift sized for a theoretical maximum
           rather than for the data. */
        tmx = 0;
        for (i = 0; i < hd; i++) {
            u[i] = rsh(qh[i], s1) * g[i];             /* 16x16 -> 32 */
            v = u[i]; if (v < 0) v = -v; if (v > tmx) tmx = v;
        }
        st = 0;
        while ((tmx >> st) > 32767) st++;
        for (i = 0; i < hd; i++) u[i] = rsh(u[i], st);
"""

if "tmx = 0;" not in s:
    assert old in s, "anchor missing"
    s = s.replace(old, new, 1)
    s = s.replace("int v, a, b, amx = 0, s1 = 0, sq = 0, mx = 0, w;",
                  "int v, a, b, amx = 0, s1 = 0, sq = 0, st = 0, tmx = 0, "
                  "mx = 0, w;", 1)
    open(p, "w").write(s)
print("patched" if "tmx = 0;" in s else "MISS")
