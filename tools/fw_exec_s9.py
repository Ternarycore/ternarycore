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

   Only one of the two operands needs a real scale, which is worth saying
   plainly because it halves the bookkeeping. SiLU is a nonlinearity, so
   the gate must arrive in true units. The up projection is multiplied in
   linearly, and everything after the product -- RMSNorm, then an absmax
   quantizer -- is scale invariant, so any global factor in up cancels
   and is never tracked at all.

   The index is the same shape as softmax's. silu_lut[i] holds
   silu((i-512)/16) in Q16.16, so the index is round(x*16) + 512: the exp
   table's round(delta*16) with an offset for the negative half. The
   shift guard below is written the way softmax's is *after* its fix --
   a large right shift means the argument vanishes toward zero, which for
   SiLU is the middle of the table, not its end.

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
    int v, t, idx, sa = 0, su = 0, sm = 0, sh;
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

    /* x * 16, where x = acc * s_g -- the table's own index units. */
    sc_mul((unsigned int)gmu, (int)(long)geb - 512, 1u << 30, -30, &Gm, &Ge);
    Ge += 4;
    sh = -(sa + 16 + Ge);

    for (i = 0; i < n; i++) {
        t = (g[i] >> sa) * (int)(Gm >> 16);
        if (sh >= 31)            idx = 0;       /* argument vanishes */
        else if (sh >= 0)        idx = t >> sh;
        else if ((-sh) >= 31)    idx = (t >= 0) ? (LUTN - 1) : -(LUTN);
        else if (t > (0x7FFFFFFF >> (-sh)))  idx = LUTN - 1;
        else if (t < -(0x7FFFFFFF >> (-sh))) idx = -(LUTN);
        else                     idx = t << (-sh);
        idx += 512;
        if (idx < 0) idx = 0;
        else if (idx >= LUTN) idx = LUTN - 1;

        /* silu is Q16.16 and at most 2^22; >>6 leaves 16 bits, and the
           up operand is already inside 16, so the product is 30. */
        m[i] = (silu_lut[idx] >> 6) * (up[i] >> su);
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
