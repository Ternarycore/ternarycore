"""Block executor stage 5a: block-float scalar arithmetic.

Attention is the first operator whose input scale cannot be cancelled, so
this is where real magnitudes start being carried. No FPU, so a scale is
a (mantissa, exponent) pair.

Same escaping caution: these strings become C, so a newline inside a C
string literal is written \\n here.
"""

EXEC5 = r"""
/* ---- Block-float scalars ---------------------------------------------
   Every stage so far has exploited scale invariance: RMSNorm's 1/rms, any
   global factor in a gain, and the rotation's length preservation all
   cancel inside an absmax quantizer, so no real magnitude ever had to be
   represented. exp is where that stops. Attention scores need a true
   magnitude, and the K scale varies per position, so it cannot be pulled
   out of the vector the way the others could.

   With no floating-point unit, a scale is m * 2^e with m normalized into
   [2^30, 2^31). Scales here are positive, so m is unsigned and keeps all
   31 bits of significance, and the product of two normalized mantissas is
   at most 2^62 -- exact in a 64-bit intermediate.

   These are scalar operations, once per head rather than once per
   element, so the 64-bit arithmetic that cost RoPE a factor of six is
   free here. Same argument that gave stage 1 an exact reciprocal: the
   benchmark says where the width is affordable. */

static void sc_norm(unsigned int *m, int *e) {
    if (*m == 0u) { *e = 0; return; }
    while (*m < (1u << 30)) { *m <<= 1; (*e)--; }
    while (*m >= (1u << 31)) { *m >>= 1; (*e)++; }
}

static void sc_set(unsigned int v, int e, unsigned int *mo, int *eo) {
    *mo = v; *eo = e; sc_norm(mo, eo);
}

static void sc_mul(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo) {
    unsigned long long p = (unsigned long long)ma * (unsigned long long)mb;
    *mo = (unsigned int)(p >> 31);
    *eo = ea + eb + 31;
    sc_norm(mo, eo);
}

static void sc_div(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo) {
    unsigned long long n = (unsigned long long)ma << 31;
    if (mb == 0u) { *mo = 0u; *eo = 0; return; }
    *mo = (unsigned int)(n / (unsigned long long)mb);
    *eo = ea - eb - 31;
    sc_norm(mo, eo);
}

/* Bit-by-bit restoring square root: no division, no table, exact for
   every input. A Newton iteration would want a seed that needs a table. */
static unsigned int isqrt64(unsigned long long v) {
    unsigned long long r = 0u, bit = (unsigned long long)1 << 62;
    while (bit > v) bit >>= 2;
    while (bit != 0u) {
        if (v >= r + bit) { v -= r + bit; r = (r >> 1) + bit; }
        else r >>= 1;
        bit >>= 2;
    }
    return (unsigned int)r;
}

/* sqrt(m * 2^e). The exponent is made even first, then the mantissa is
   shifted up 32 bits so the root keeps its full width. */
static void sc_sqrt(unsigned int m, int e, unsigned int *mo, int *eo) {
    if (m == 0u) { *mo = 0u; *eo = 0; return; }
    if (e & 1) { m >>= 1; e++; }
    *mo = isqrt64((unsigned long long)m << 32);
    *eo = (e - 32) / 2;
    sc_norm(mo, eo);
}

/* Value as Q16.16, saturating. Used to index the exp table. */
static int sc_q16(unsigned int m, int e) {
    int s = -(e + 16);
    if (s >= 32) return 0;
    if (s <= 0) {
        if (-s >= 2 || m > (0x7FFFFFFFu >> (-s))) return 0x7FFFFFFF;
        return (int)(m << (-s));
    }
    return (int)(m >> s);
}

/* Exercise the above against the host, before anything depends on it. A
   scale quietly wrong by a factor of two makes attention that looks
   plausible and is not. */
static void cmd_sct(const char *p) {
    unsigned long op = parse_u(&p);
    unsigned int ma = (unsigned int)parse_u(&p);
    unsigned long ea = parse_u(&p);
    unsigned int mb = (unsigned int)parse_u(&p);
    unsigned long eb = parse_u(&p);
    unsigned int mo = 0u;
    int eo = 0, xa = (int)(long)ea - 512, xb = (int)(long)eb - 512;

    if      (op == 0u) { mo = ma; eo = xa; sc_norm(&mo, &eo); }
    else if (op == 1u) sc_mul(ma, xa, mb, xb, &mo, &eo);
    else if (op == 2u) sc_div(ma, xa, mb, xb, &mo, &eo);
    else if (op == 3u) sc_sqrt(ma, xa, &mo, &eo);
    else if (op == 4u) {
        unsigned long long v = ((unsigned long long)ma << 32)
                             | (unsigned long long)mb;
        mo = isqrt64(v); eo = 0;
    }
    else { mo = (unsigned int)sc_q16(ma, xa); eo = 0; }

    uart_puts("SC "); uart_puthex(mo);
    uart_puts(" "); uart_putdec((long)eo);
    uart_puts("\nOK SCT\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "KVW ")) cmd_kvw(line + 4);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "SCT ")) cmd_sct(line + 4);'
