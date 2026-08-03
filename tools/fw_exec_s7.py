"""Block executor stage 6: softmax over the attention scores.

The first operator whose input scale cannot be cancelled away.

Same escaping caution: these strings become C, so a newline inside a C
string literal is written \\n here.
"""

EXEC7 = r"""
/* ---- Stage 6: softmax ------------------------------------------------
   exp is the first operator in this block that needs a real magnitude.
   Everything before it rode on scale invariance -- RMSNorm's 1/rms, the
   gains, the rotation -- and all of it cancelled inside an absmax
   quantizer. Here the K scale varies per position, so it cannot even be
   pulled out of the vector.

   The alignment trick: mantissas are normalized, so the exponent carries
   the whole ordering. Take the largest K exponent, shift each position's
   product right by its own deficit, and every score sits on one common
   scale in plain 32-bit arithmetic. A per-element block-float multiply
   would be correct and would cost more than the dot products themselves
   at 229,000 score elements per token.

   Ranges were bounded before this was written, which is why none of it is
   64-bit. |q.k| worst case is 128*127*127 = 21 bits; shifted down 6 and
   times a 15-bit mantissa it is 30. exp (Q16.16, at most 2^16) times a
   15-bit V mantissa reaches 31 bits, hence unsigned.

   The probability reciprocal carries 23 fractional bits, not the 46 stage
   1 uses. That is deliberate: the sweep at 512 context found probability
   width flat from 4 bits to 12, so precision here was measured not to
   matter and is not worth paying for.

   Normalization is deferred. The unnormalized exponentials are quantized
   with the largest at full scale, each key's V scale folded in first so a
   single int8 dot serves all of them, and the divide happens once per
   head downstream. Reported scalars let the host close that:

       out_d = num_d * wmax * 2^vemax * 65536 / (127 * sume)                */

#define SM_SCALE_M 1518500250u        /* 1/sqrt(128) as m * 2^e ... */
#define SM_SCALE_E (-34)              /* ... = 0.08838834765         */

static void cmd_sm(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  dsl = parse_u(&p), qmu = parse_u(&p), qeb = parse_u(&p),
                  psl = parse_u(&p), ssl = parse_u(&p);
    const int *dot = (const int *)VSLOT(dsl);
    signed char *pi = (signed char *)VSLOT(psl);
    int *so = (int *)VSLOT(ssl);
    int *u  = (int *)VS_TMP;                        /* scores, then exp */
    unsigned int *w = (unsigned int *)(VS_TMP + 0x2000u);
    unsigned long npos = pos + 1u, j;
    int kemax = -1000000, vemax = -1000000, umax, dmax = 0, sd = 0, sh, ws = 0;
    unsigned int wmax = 0u, sume = 0u, inv, wn;
    unsigned int Km; int Ke;

    if (blk >= 28u || kvh >= KV_NKV || npos > KV_MAXP) {
        uart_puts("ERR range\n"); return;
    }
    build_luts();

    for (j = 0; j < npos; j++) {
        int e = (int)IO32(kv_sbase(blk, kvh, j) + 4u);
        if (e > kemax) kemax = e;
    }
    for (j = 0; j < npos; j++) {
        unsigned int m = IO32(kv_sbase(blk, kvh, j));
        int e  = (int)IO32(kv_sbase(blk, kvh, j) + 4u);
        int s2 = kemax - e;
        int t  = (dot[j] >> 6) * (int)(m >> 16);
        u[j] = (s2 >= 31) ? 0 : (t >> s2);
    }
    umax = u[0];
    for (j = 1; j < npos; j++) if (u[j] > umax) umax = u[j];
    for (j = 0; j < npos; j++) {
        int d = umax - u[j];
        if (d > dmax) dmax = d;
    }
    while ((dmax >> sd) > 32767) sd++;

    /* score_j = u_j * 2^(kemax+22) * s_q * SCALE, and the table is indexed
       in sixteenths of a natural log unit, so fold in one more factor of
       16 and read the shift off the result. */
    sc_mul((unsigned int)qmu, (int)(long)qeb - 512,
           SM_SCALE_M, SM_SCALE_E, &Km, &Ke);
    Ke += kemax + 22 + 4;
    sh = -(sd + 16 + Ke);

    for (j = 0; j < npos; j++) {
        int d = (umax - u[j]) >> sd;
        int t = d * (int)(Km >> 16);
        int idx;
        if (sh >= 31)            idx = LUTN - 1;
        else if (sh >= 0)        idx = t >> sh;
        else if ((-sh) >= 31)    idx = LUTN - 1;
        else if (t > (0x7FFFFFFF >> (-sh))) idx = LUTN - 1;
        else                     idx = t << (-sh);
        if (idx < 0) idx = 0;
        else if (idx >= LUTN) idx = LUTN - 1;
        u[j] = exp_lut[idx];                        /* Q16.16, <= 65536 */
    }

    for (j = 0; j < npos; j++) {
        int e = (int)IO32(kv_sbase(blk, kvh, j) + 12u);
        if (e > vemax) vemax = e;
    }
    for (j = 0; j < npos; j++) {
        unsigned int m = IO32(kv_sbase(blk, kvh, j) + 8u);
        int e  = (int)IO32(kv_sbase(blk, kvh, j) + 12u);
        int s2 = vemax - e;
        unsigned int t = (unsigned int)u[j] * (m >> 16);   /* 31 bits */
        w[j] = (s2 >= 32) ? 0u : (t >> s2);
        if (w[j] > wmax) wmax = w[j];
        sume += (unsigned int)u[j];
    }
    if (wmax == 0u) wmax = 1u;

    while ((wmax >> ws) > 65535u) ws++;
    wn  = wmax >> ws;
    if (wn == 0u) wn = 1u;
    inv = (127u << 23) / wn;                 /* <= 32512, product < 2^31 */
    for (j = 0; j < npos; j++) {
        unsigned int t = (w[j] >> ws) * inv;
        int v = (int)((t + (1u << 22)) >> 23);
        if (v > 127) v = 127;
        else if (v < 0) v = 0;
        pi[j] = (signed char)v;
    }

    so[0] = (int)wmax;
    so[1] = vemax;
    so[2] = (int)sume;
    so[3] = (int)npos;

    uart_puts("SM wmax "); uart_puthex(wmax);
    uart_puts(" ve "); uart_putdec((long)vemax);
    uart_puts(" sume "); uart_puthex(sume);
    uart_puts(" n "); uart_putdec((long)npos);
    uart_puts("\nOK SM\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "QKD ")) cmd_qk(line + 4);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "SM ")) cmd_sm(line + 3);'
