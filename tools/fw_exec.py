"""Block executor, injected into ddr_host.c by make_ddr_fw.py.

fw_ops.py is benchmarks. This is the datapath: the operators that will
actually run a transformer block, in the order tc_ref.py runs them, each
one verified against tc_ref before the next is written.

Careful with escapes: these strings become C, so a newline inside a C
string literal must be written \\n here.
"""

EXEC = r"""
/* ---- Block executor: scratch vectors ---------------------------------
   Every stage is checked against tools/tc_ref.py before the next one is
   written, which needs a way to put a known vector on the board and read
   a result back. Sixteen 16 KB slots in DDR, each big enough for the
   widest vector a block handles (3072 int32 = 12 KB), plus one scratch.

   DUMPV returns a position-weighted checksum and the first eight values;
   position-weighted because a plain byte sum is order independent, and
   this project has already had one of those report a perfect match on a
   page whose weights had been scrambled. DUMPR returns the whole vector
   raw, because "the checksum differs" is not a diagnosis. */

#define VS_BASE   (DDR_BASE + 0x0D000000u)
#define VS_STRIDE 0x4000u
#define VS_SLOTS  16u
#define VSLOT(s)  (VS_BASE + ((unsigned int)(s) % VS_SLOTS) * VS_STRIDE)
#define VS_TMP    (VS_BASE + VS_SLOTS * VS_STRIDE)
#define VS_MAX    4096u

/* Arithmetic shift rounds toward negative infinity, which puts a sign on
   the error of every negative element. Round away from zero on both. */
static int rsh(int v, int s) {
    if (s <= 0) return v;
    return (v >= 0) ? ((v + (1 << (s - 1))) >> s)
                    : -(((-v) + (1 << (s - 1))) >> s);
}

static void cmd_loadv(const char *p) {
    unsigned long slot = parse_u(&p), n = parse_u(&p), i, j;
    unsigned int w, base;
    if (n > VS_MAX) { uart_puts("ERR range\n"); return; }
    base = VSLOT(slot);
    for (i = 0; i < n; i++) {
        w = 0u;
        for (j = 0; j < 4u; j++) w |= ((unsigned int)uart_getc()) << (8u * j);
        IO32(base + i * 4u) = w;
    }
    uart_puts("OK V\n");
}

static void cmd_dumpv(const char *p) {
    unsigned long slot = parse_u(&p), n = parse_u(&p), i, c = 0;
    const int *v = (const int *)VSLOT(slot);
    for (i = 0; i < n; i++) c += (unsigned long)v[i] * (unsigned long)(i + 1u);
    uart_puts("VCHK "); uart_puthex(c); uart_puts(" V");
    for (i = 0; i < n && i < 8u; i++) { uart_puts(" "); uart_putdec((long)v[i]); }
    uart_puts("\nOK DV\n");
}

static void cmd_dumpb(const char *p) {
    unsigned long slot = parse_u(&p), n = parse_u(&p), i, c = 0;
    const signed char *b = (const signed char *)VSLOT(slot);
    for (i = 0; i < n; i++)
        c += (unsigned long)(long)b[i] * (unsigned long)(i + 1u);
    uart_puts("BCHK "); uart_puthex(c); uart_puts(" B");
    for (i = 0; i < n && i < 8u; i++) { uart_puts(" "); uart_putdec((long)b[i]); }
    uart_puts("\nOK DB\n");
}

/* Raw int8 read-back: header, then exactly n bytes, then the trailer. The
   payload can contain any byte including newline, so the host must count
   bytes rather than read lines. */
static void cmd_dumpr(const char *p) {
    unsigned long slot = parse_u(&p), n = parse_u(&p), i;
    const signed char *b = (const signed char *)VSLOT(slot);
    if (n > VS_MAX) { uart_puts("ERR range\n"); return; }
    uart_puts("RAW "); uart_putdec((long)n); uart_puts("\n");
    for (i = 0; i < n; i++) uart_putc((char)b[i]);
    uart_puts("\nOK DR\n");
}

/* ---- Stage 1: fused RMSNorm + absmax int8 quantize -------------------
   Every BitLinear input in this model is RMSNorm(x)*g followed by absmax
   int8 quantization. Absmax is scale invariant, so RMSNorm's 1/rms factor
   divides out of all 1024 elements and is never computed per element here.
   It survives as one scalar in the output scale,

       s_a = gmax * max|x*g| / (rms * 127)

   and rms itself needs only the sum of squares, which is a reduction, not
   a vector operation. The same argument disposes of the gain's own scale:
   any global factor in g cancels in the maximum, so g arrives normalized
   to +-32767 in Q15 with gmax kept on the host.

   x must arrive with its mantissas inside 16 bits -- the host scales the
   residual stream, and this checks rather than trusts, because a silent
   overflow here would look exactly like a quantization artefact
   twenty-eight blocks downstream.

   Two passes where the obvious implementation has four. Pass one is the
   range scan the sum of squares needs; pass two computes t = x*g,
   accumulates sum(x^2) and tracks max|t| in the same loop that writes t --
   that fusion is what the cold-to-hot gap in the DDR benchmark was
   measuring. Pass three only scales.

   On precision: t is the *full* 32-bit product and is not shifted on the
   way into memory. An earlier version wrote (v*g) >> 15, and that
   truncation cost one unit of t, which is worth mx/127 output LSBs -- at
   mx=32767 it is invisible, and at mx=564 it flipped one rounding in nine
   downward. The maximum is normalized into 16 bits afterwards instead, so
   the reciprocal can carry 23 fractional bits with |t>>ms| <= 65535 and
   the product bounded near 1.065e9, safely inside int32. No 64-bit
   arithmetic anywhere; that cost RoPE a factor of six. */

static void cmd_nq(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), dst = parse_u(&p),
                  n = parse_u(&p), i;
    const int *x = (const int *)VSLOT(src);
    const int *g = (const int *)VSLOT(gsl);
    int *t = (int *)VS_TMP;
    signed char *o8 = (signed char *)VSLOT(dst);
    int v, u, w, q, mx = 0, amx = 0, xs = 0, ms = 0, mxn, inv;
    unsigned int ss = 0u;

    if (n == 0u || n > VS_MAX) { uart_puts("ERR range\n"); return; }

    for (i = 0; i < n; i++) {
        v = x[i];
        if (v < 0) v = -v;
        if (v > amx) amx = v;
    }
    if (amx > 32767) {
        uart_puts("ERR x not 16-bit, max "); uart_putdec((long)amx);
        uart_puts("\n"); return;
    }
    while ((amx >> xs) > 2047) xs++;      /* n squares must fit 32 bits */

    for (i = 0; i < n; i++) {
        v = x[i];
        u = v >> xs;
        ss += (unsigned int)(u * u);
        w = v * g[i];                     /* full product, nothing discarded */
        t[i] = w;
        if (w < 0) w = -w;
        if (w > mx) mx = w;
    }
    if (mx == 0) mx = 1;
    while ((mx >> ms) > 65535) ms++;
    mxn = mx >> ms;
    if (mxn == 0) mxn = 1;
    inv = (int)(((unsigned int)127u << 23) / (unsigned int)mxn);

    for (i = 0; i < n; i++) {
        q = rsh(rsh(t[i], ms) * inv, 23);
        if (q > 127) q = 127; else if (q < -128) q = -128;
        o8[i] = (signed char)q;
    }

    uart_puts("NQ mx "); uart_putdec((long)mx);
    uart_puts(" ss "); uart_puthex(ss);
    uart_puts(" xs "); uart_putdec((long)xs);
    uart_puts(" ms "); uart_putdec((long)ms);
    uart_puts("\nOK NQ\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "MEMTEST")) cmd_memtest();'
CMD_NEW = (CMD_OLD +
           '\n        else if (starts(line, "LOADV ")) cmd_loadv(line + 6);'
           '\n        else if (starts(line, "DUMPV ")) cmd_dumpv(line + 6);'
           '\n        else if (starts(line, "DUMPB ")) cmd_dumpb(line + 6);'
           '\n        else if (starts(line, "DUMPR ")) cmd_dumpr(line + 6);'
           '\n        else if (starts(line, "NQ ")) cmd_nq(line + 3);')
