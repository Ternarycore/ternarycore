#!/usr/bin/env python3
"""patch_nq_core.py -- split cmd_nq into a callable core and a command.

The block driver has to call RMSNorm+quantize four times per block
without a UART round trip, and it needs the three numbers cmd_nq
currently only publishes by printing them: mx, the sum of squares, and
the shift that kept the squares in 32 bits. The host has been parsing
those off a serial line. That stops being possible the moment the
sequencing moves on-board.

So the arithmetic moves into nq_core and cmd_nq becomes a wrapper that
prints what it used to print. The body is copied character for character
-- the reciprocal at 46 fractional bits, the symmetric rounding, the
2047 threshold on the squares. Every one of those was a bug once, and
this is a refactor, not an improvement.

Inertness is checked rather than asserted: stage_check.py exercises NQ
and must give the same answers afterwards. A refactor that changes
behaviour is just an undocumented rewrite.

  python tools/patch_nq_core.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fw_exec.py")
s = open(p).read()

if "nq_core" in s:
    sys.exit("already patched")

OLD = '''static void cmd_nq(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), dst = parse_u(&p),
                  n = parse_u(&p), i;
    const int *x = (const int *)VSLOT(src);
    const int *g = (const int *)VSLOT(gsl);
    int *t = (int *)VS_TMP;
    signed char *o8 = (signed char *)VSLOT(dst);
    int v, u, w, q, mx = 0, amx = 0, xs = 0;
    unsigned int ss = 0u;
    long long inv, qq;

    if (n == 0u || n > VS_MAX) { uart_puts("ERR range\\n"); return; }

    for (i = 0; i < n; i++) {
        v = x[i];
        if (v < 0) v = -v;
        if (v > amx) amx = v;
    }
    if (amx > 32767) {
        uart_puts("ERR x not 16-bit, max "); uart_putdec((long)amx);
        uart_puts("\\n"); return;
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

    /* |t| <= mx, so |t * inv| <= 127 << 46 = 8.9e15, well inside int64. */
    inv = ((long long)127 << 46) / (long long)mx;
    for (i = 0; i < n; i++) {
        qq = (long long)t[i] * inv;
        qq = (qq >= 0) ? ((qq + ((long long)1 << 45)) >> 46)
                       : -((((-qq) + ((long long)1 << 45)) >> 46));
        q = (int)qq;
        if (q > 127) q = 127; else if (q < -128) q = -128;
        o8[i] = (signed char)q;
    }

    uart_puts("NQ mx "); uart_putdec((long)mx);
    uart_puts(" ss "); uart_puthex(ss);
    uart_puts(" xs "); uart_putdec((long)xs);
    uart_puts("\\nOK NQ\\n");
}'''

NEW = '''/* What nq_core computed, where a caller can reach it. The host used to
   read these off a UART line; the block driver cannot, because by then
   there is no round trip left to read them from. */
static int nq_mx, nq_xs, nq_amx;
static unsigned int nq_ss;

/* Returns 0 if the input does not fit 16 bits, having set nq_amx so the
   caller can say by how much. Body identical to what cmd_nq did. */
static int nq_core(const int *x, const int *g, signed char *o8,
                   unsigned long n) {
    int *t = (int *)VS_TMP;
    int v, u, w, q, mx = 0, amx = 0, xs = 0;
    unsigned int ss = 0u;
    long long inv, qq;
    unsigned long i;

    for (i = 0; i < n; i++) {
        v = x[i];
        if (v < 0) v = -v;
        if (v > amx) amx = v;
    }
    nq_amx = amx;
    if (amx > 32767) return 0;
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

    /* |t| <= mx, so |t * inv| <= 127 << 46 = 8.9e15, well inside int64. */
    inv = ((long long)127 << 46) / (long long)mx;
    for (i = 0; i < n; i++) {
        qq = (long long)t[i] * inv;
        qq = (qq >= 0) ? ((qq + ((long long)1 << 45)) >> 46)
                       : -((((-qq) + ((long long)1 << 45)) >> 46));
        q = (int)qq;
        if (q > 127) q = 127; else if (q < -128) q = -128;
        o8[i] = (signed char)q;
    }

    nq_mx = mx; nq_ss = ss; nq_xs = xs;
    return 1;
}

static void nq_report(void) {
    uart_puts("NQ mx "); uart_putdec((long)nq_mx);
    uart_puts(" ss "); uart_puthex(nq_ss);
    uart_puts(" xs "); uart_putdec((long)nq_xs);
    uart_puts("\\nOK NQ\\n");
}

static void cmd_nq(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), dst = parse_u(&p),
                  n = parse_u(&p);

    if (n == 0u || n > VS_MAX) { uart_puts("ERR range\\n"); return; }
    if (!nq_core((const int *)VSLOT(src), (const int *)VSLOT(gsl),
                 (signed char *)VSLOT(dst), n)) {
        uart_puts("ERR x not 16-bit, max "); uart_putdec((long)nq_amx);
        uart_puts("\\n"); return;
    }
    nq_report();
}'''

if OLD not in s:
    sys.exit("anchor missing: cmd_nq is not the text this patch expects")
open(p, "w").write(s.replace(OLD, NEW, 1))
print("fw_exec.py: nq_core extracted, cmd_nq is now a wrapper")
