"""Block executor stage 8: the MLP gate -- SiLU and the elementwise product.

gate_proj, up_proj and down_proj are all stage 2; the SubLN and quantize
before down_proj are stage 1. This is the only new arithmetic in the MLP.

Same escaping caution: these strings become C, so a newline inside a C
string literal is written \\n here.
"""

EXEC9 = r"""
/* ---- Stage 8: SiLU and the gate product ------------------------------
   Nearly all of the MLP already exists. gate_proj and up_proj are stage 2
   unchanged, and down_proj is stage 2 with stage 1's SubLN and quantize
   in front of it. What is left is SiLU and one elementwise multiply.

   Only one of the two operands needs a real scale. SiLU is a
   nonlinearity, so the gate must arrive in true units; the up projection
   is multiplied in linearly and everything after the product -- RMSNorm,
   then an absmax quantizer -- is scale invariant, so any global factor in
   up cancels and is never tracked.

   Three things about the table, each of which cost a board run.

   It is interpolated. The step is 1/16, and nearest-entry lookup measures
   7.4% wrong over a +-0.5 span against exact SiLU. Linear interpolation
   takes that to 0.078% for one multiply, so the index keeps four extra
   fractional bits rather than discarding them.

   Its tails are computed, not clamped. The table spans x in [-32, 32),
   and outside that SiLU is trivial: x for large positive, zero for large
   negative. Both exact and cheaper than a lookup. Clamping instead cost
   20% on the extremes of a +-40 gate.

   And the shift into the product is measured, not assumed. SiLU's
   theoretical ceiling is 2^22, but a +-0.5 gate peaks near 20,000, so a
   fixed >>6 left nine bits of a sixteen-bit operand. Every other
   operator in this executor sizes its shifts from the data; this one
   now does too.

   Ranges: accumulators reach 17 bits, both operands are normalized into
   16, and the product lands at 30. Nothing here is 64-bit. */

static void cmd_mlp(const char *p) {
    unsigned long gsl = parse_u(&p), usl = parse_u(&p), osl = parse_u(&p),
                  gmu = parse_u(&p), geb = parse_u(&p), n = parse_u(&p), i;
    const int *g = (const int *)VSLOT(gsl);
    const int *up = (const int *)VSLOT(usl);
    int *o = (int *)VSLOT(osl);
    int *m = (int *)VS_TMP;
    int v, t, ixf, idx, frac, sa = 0, su = 0, ss = 0, sm = 0, sh;
    int gmx = 0, umx = 0, svmx = 0, mmx = 0;
    unsigned int Gm; int Ge;

    if (n == 0u || n > VS_MAX) { uart_puts("ERR range\n"); return; }
    build_luts();

    for (i = 0; i < n; i++) {
        v = g[i];  if (v < 0) v = -v;  if (v > gmx) gmx = v;
        v = up[i]; if (v < 0) v = -v;  if (v > umx) umx = v;
    }
    while ((gmx >> sa) > 32767) sa++;
    while ((umx >> su) > 32767) su++;

    /* x * 256: the table's index units (x*16) plus four fractional bits. */
    sc_mul((unsigned int)gmu, (int)(long)geb - 512, 1u << 30, -30, &Gm, &Ge);
    Ge += 8;
    sh = -(sa + 16 + Ge);

    /* Pass one: SiLU into m, in Q16.16, tracking what it actually reaches. */
    for (i = 0; i < n; i++) {
        t = (g[i] >> sa) * (int)(Gm >> 16);
        if (sh >= 31)            ixf = 0;              /* argument vanishes */
        else if (sh >= 0)        ixf = t >> sh;
        else if ((-sh) >= 22)    ixf = (t >= 0) ? (1 << 22) : -(1 << 22);
        else if (t >  (0x003FFFFF >> (-sh)))  ixf =  (1 << 22);
        else if (t < -(0x003FFFFF >> (-sh)))  ixf = -(1 << 22);
        else                     ixf = t << (-sh);

        idx  = (ixf >> 4) + 512;                /* arithmetic shift floors */
        frac = ixf & 15;                        /* ... so this stays >= 0 */
        if (idx >= LUTN - 1)      m[i] = ixf << 8;     /* SiLU(x) -> x     */
        else if (idx < 0)         m[i] = 0;            /* SiLU(x) -> 0     */
        else m[i] = silu_lut[idx]
                  + (((silu_lut[idx + 1] - silu_lut[idx]) * frac) >> 4);

        v = m[i]; if (v < 0) v = -v; if (v > svmx) svmx = v;
    }

    /* Pass two: the product, both operands normalized to what they use. */
    while ((svmx >> ss) > 32767) ss++;
    for (i = 0; i < n; i++) {
        m[i] = rsh(m[i], ss) * (up[i] >> su);
        v = m[i]; if (v < 0) v = -v; if (v > mmx) mmx = v;
    }

    while ((mmx >> sm) > 32767) sm++;
    for (i = 0; i < n; i++) o[i] = rsh(m[i], sm);

    uart_puts("MLP sa "); uart_putdec((long)sa);
    uart_puts(" su "); uart_putdec((long)su);
    uart_puts(" ss "); uart_putdec((long)ss);
    uart_puts(" sm "); uart_putdec((long)sm);
    uart_puts("\nOK MLP\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "PV ")) cmd_pv(line + 3);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "MLP ")) cmd_mlp(line + 4);'
