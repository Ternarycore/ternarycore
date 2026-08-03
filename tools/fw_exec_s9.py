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

   Only one of the two operands needs a real scale, which halves the
   bookkeeping. SiLU is a nonlinearity, so the gate must arrive in true
   units. The up projection is multiplied in linearly, and everything
   after the product -- RMSNorm, then an absmax quantizer -- is scale
   invariant, so any global factor in up cancels and is never tracked.

   The table is interpolated, and that is not a refinement. silu_lut spans
   x in [-32, 32) with 1024 entries, a step of 1/16, and nearest-entry
   lookup measures 7.4% wrong over a +-0.5 span against exact SiLU, 0.87%
   over +-4, 0.17% over +-20. The error is worst precisely where
   activations live, because SiLU is smallest near zero and a fixed step
   is largest relative to it there. Linear interpolation between adjacent
   entries takes those to 0.078%, 0.0062% and 0.0012% for one multiply
   and one shift -- so the index carries four extra fractional bits
   instead of discarding them.

   Ranges were bounded before this was written, so nothing here is
   64-bit: accumulators reach 17 bits, silu tops out at 22 and shifts to
   16, and their product lands at 30.

   The result is normalized into 16 bits for stage 1 to consume, and the
   shift is reported so the host can reconstruct the true magnitude of
   the down projection's contribution to the residual. */

static void cmd_mlp(const char *p) {
    unsigned long gsl = parse_u(&p), usl = parse_u(&p), osl = parse_u(&p),
                  gmu = parse_u(&p), geb = parse_u(&p), n = parse_u(&p), i;
    const int *g = (const int *)VSLOT(gsl);
    const int *up = (const int *)VSLOT(usl);
    int *o = (int *)VSLOT(osl);
    int *m = (int *)VS_TMP;
    int v, t, ixf, idx, frac, sv, sa = 0, su = 0, sm = 0, sh;
    int gmx = 0, umx = 0, mmx = 0;
    unsigned int Gm; int Ge;

    if (n == 0u || n > VS_MAX) { uart_puts("ERR range\n"); return; }
    build_luts();

    for (i = 0; i < n; i++) {
        v = g[i];  if (v < 0) v = -v;  if (v > gmx) gmx = v;
        v = up[i]; if (v < 0) v = -v;  if (v > umx) umx = v;
    }
    while ((gmx >> sa) > 32767) sa++;
    while ((umx >> su) > 32767) su++;

    /* x * 256: the table's own index units (x*16) with four more
       fractional bits kept for the interpolation. */
    sc_mul((unsigned int)gmu, (int)(long)geb - 512, 1u << 30, -30, &Gm, &Ge);
    Ge += 8;
    sh = -(sa + 16 + Ge);

    for (i = 0; i < n; i++) {
        t = (g[i] >> sa) * (int)(Gm >> 16);
        if (sh >= 31)            ixf = 0;       /* argument vanishes */
        else if (sh >= 0)        ixf = t >> sh;
        else if ((-sh) >= 31)    ixf = (t >= 0) ? (LUTN << 4) : -(LUTN << 4);
        else if (t >  (0x7FFFFFFF >> (-sh)))  ixf =  (LUTN << 4);
        else if (t < -(0x7FFFFFFF >> (-sh)))  ixf = -(LUTN << 4);
        else                     ixf = t << (-sh);

        idx  = (ixf >> 4) + 512;                /* arithmetic shift floors */
        frac = ixf & 15;                        /* ... so this stays >= 0 */
        if (idx < 0) { idx = 0; frac = 0; }
        else if (idx >= LUTN - 1) { idx = LUTN - 2; frac = 15; }

        sv = silu_lut[idx]
           + (((silu_lut[idx + 1] - silu_lut[idx]) * frac) >> 4);

        /* silu is Q16.16 and at most 2^22; >>6 leaves 16 bits, and the
           up operand is already inside 16, so the product is 30. */
        m[i] = (sv >> 6) * (up[i] >> su);
        v = m[i]; if (v < 0) v = -v; if (v > mmx) mmx = v;
    }

    while ((mmx >> sm) > 32767) sm++;
    for (i = 0; i < n; i++) o[i] = rsh(m[i], sm);

    uart_puts("MLP sa "); uart_putdec((long)sa);
    uart_puts(" su "); uart_putdec((long)su);
    uart_puts(" sm "); uart_putdec((long)sm);
    uart_puts(" mmx "); uart_putdec((long)mmx);
    uart_puts("\nOK MLP\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "PV ")) cmd_pv(line + 3);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "MLP ")) cmd_mlp(line + 4);'
