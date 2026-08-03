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

/* Raw int8 in, so a stage can be driven with a known activation vector
   rather than only with whatever the stage before it produced. */
static void cmd_loadb(const char *p) {
    unsigned long slot = parse_u(&p), n = parse_u(&p), i;
    signed char *b = (signed char *)VSLOT(slot);
    if (n > VS_MAX * 4u) { uart_puts("ERR range\n"); return; }
    for (i = 0; i < n; i++) b[i] = (signed char)uart_getc();
    uart_puts("OK B\n");
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

       s_a = gmax * mx / (32767 * 127 * sqrt(ss * 2^(2*xs) / n))

   which the host can evaluate from the three numbers reported below. The
   same argument disposes of the gain's own scale: any global factor in g
   cancels in the maximum, so g arrives normalized to +-32767 in Q15.

   x must arrive with its mantissas inside 16 bits -- the host scales the
   residual stream, and this checks rather than trusts, because a silent
   overflow here would look exactly like a quantization artefact
   twenty-eight blocks downstream.

   Two passes where the obvious implementation has four: pass one is the
   range scan the sum of squares needs, pass two computes t = x*g and
   accumulates sum(x^2) and max|t| in the same loop that writes t.

   Two precision lessons are baked into pass three. t is the full 32-bit
   product and is never shifted into memory -- an earlier version wrote
   (v*g) >> 15, and one truncated unit of t is worth mx/127 output LSBs,
   invisible at mx=32767 and one rounding in nine at mx=564. And the
   reciprocal carries 46 fractional bits in a 64-bit product, which is
   affordable here and nowhere else: this operator measured 18.02
   cycles/element in both 32- and 64-bit form, while RoPE paid 6x. */

static void cmd_nq(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), dst = parse_u(&p),
                  n = parse_u(&p), i;
    const int *x = (const int *)VSLOT(src);
    const int *g = (const int *)VSLOT(gsl);
    int *t = (int *)VS_TMP;
    signed char *o8 = (signed char *)VSLOT(dst);
    int v, u, w, q, mx = 0, amx = 0, xs = 0;
    unsigned int ss = 0u;
    long long inv, qq;

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
    uart_puts("\nOK NQ\n");
}

/* ---- Stage 2: a projection through the array -------------------------
   The arithmetic here is already proven -- phase2_demo has been computing
   exact 1024-wide projections through this path for weeks. What is new is
   that the activations come from a scratch slot written by stage 1 rather
   than from a UART command, and the int32 accumulators land in another
   slot rather than being checksummed and thrown away.

   The segment count exists because the array is 1024 deep and two of the
   seven projections are not: o_proj reads 2048 and down_proj reads 3072.
   Each segment is a separate weight page and a separate 1024-deep pass,
   summed here. That is one add per output per segment, and it is inherent
   to the array's depth rather than a shortcut -- the alternative is a
   deeper act_ram, which is a bitstream change.

   Segment 0 writes, later segments accumulate; the caller pages the right
   weights in between. No scale arithmetic: the output scale follows from
   what stage 1 reported, and keeping it on the host means this stage can
   be checked against exact integers instead of a float and a tolerance. */

static void cmd_proj(const char *p) {
    unsigned long asrc = parse_u(&p), dst = parse_u(&p), ntile = parse_u(&p),
                  seg = parse_u(&p), j;
    const signed char *a = (const signed char *)VSLOT(asrc);
    int *o = (int *)VSLOT(dst);
    unsigned long k;
    unsigned int ct;
    int c, v;
    unsigned long chk = 0;

    if (ntile == 0u || ntile > 16u) { uart_puts("ERR range\n"); return; }

    IO32(STREAM_BASE + S_CTRL) = 0x4u;               /* act ptr reset */
    for (k = 0; k < DEPTH; k++)
        IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)a[k];

    for (ct = 0; ct < (unsigned int)ntile; ct++) {
        stream_tile(ct);
        for (c = 0; c < 64; c++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
            v = (int)IO32(STREAM_BASE + S_RDATA);
            j = (unsigned long)ct * 64u + (unsigned long)c;
            o[j] = seg ? (o[j] + v) : v;
        }
    }
    for (j = 0; j < ntile * 64u; j++)
        chk += (unsigned long)o[j] * (unsigned long)(j + 1u);
    uart_puts("PCHK "); uart_puthex(chk);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nOK PJ\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "MEMTEST")) cmd_memtest();'
CMD_NEW = (CMD_OLD +
           '\n        else if (starts(line, "LOADV ")) cmd_loadv(line + 6);'
           '\n        else if (starts(line, "LOADB ")) cmd_loadb(line + 6);'
           '\n        else if (starts(line, "DUMPV ")) cmd_dumpv(line + 6);'
           '\n        else if (starts(line, "DUMPB ")) cmd_dumpb(line + 6);'
           '\n        else if (starts(line, "DUMPR ")) cmd_dumpr(line + 6);'
           '\n        else if (starts(line, "NQ ")) cmd_nq(line + 3);'
           '\n        else if (starts(line, "PROJ ")) cmd_proj(line + 5);')
