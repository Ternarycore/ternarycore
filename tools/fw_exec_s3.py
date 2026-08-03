"""Block executor stage 3: QK-norm and rotary embedding.

Separate from fw_exec.py so each stage's contribution to the 64 KB local
memory is visible on its own. Same escaping caution: these strings become
C, so a newline inside a C string literal is written \\n here.
"""

EXEC3 = r"""
/* ---- Stage 3: QK-norm and rotary embedding ---------------------------
   Per head: RMSNorm across head_dim with its own gain, the rotation, then
   absmax int8 for the attention dot.

   Three scale-invariant steps in a row -- the norm's 1/rms, any global
   factor in the gain, and the rotation, which preserves length -- so none
   of them is applied per element. One sum of squares per head survives,
   and only because the score scale needs it: exp is not scale invariant,
   so this is the first place in the block where a magnitude has to be
   carried instead of cancelled.

   Two normalizing shifts, both forced by range. Accumulators arrive as
   large as 1024*127 = 130048, and 130048 * 32767 overflows int32 by
   exactly one bit; the rotation would overflow again after that. So the
   head is shifted into 16 bits before the gain, and back into 16 bits
   before the rotation. Every product is then 16x16 into 32 bits, which
   for this operator is the difference between 18.6 and 113.8 cycles per
   element -- RoPE is where 64-bit arithmetic actually costs.

   cos and sin share one slot: cos in [0, hd/2), sin in [hd/2, hd), both
   Q15, sent by the host for the current position. 512 bytes a token beats
   tabling 512 positions at 256 KB, and beats recomputing them here with
   no FPU.

   Per-head scalars land in a slot as [ss, s1, sq, mx] so the host can
   reconstruct the score scale exactly; the board does not need them until
   softmax. */

static void cmd_qkn(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), cs = parse_u(&p),
                  dst = parse_u(&p), ssl = parse_u(&p),
                  nh = parse_u(&p), hd = parse_u(&p);
    const int *q  = (const int *)VSLOT(src);
    const int *g  = (const int *)VSLOT(gsl);
    const int *co = (const int *)VSLOT(cs);
    signed char *o8 = (signed char *)VSLOT(dst);
    int *sc = (int *)VSLOT(ssl);
    int *u  = (int *)VS_TMP;
    const int *si;
    unsigned long h, i, half;
    unsigned long chk = 0;

    if (hd == 0u || hd > 512u || nh == 0u || nh * hd > VS_MAX) {
        uart_puts("ERR range\n"); return;
    }
    half = hd / 2u;
    si = co + half;

    for (h = 0; h < nh; h++) {
        const int *qh = q + h * hd;
        signed char *oh = o8 + h * hd;
        int v, a, b, amx = 0, s1 = 0, sq = 0, mx = 0, w;
        unsigned int ss = 0u;
        long long inv, qq;

        for (i = 0; i < hd; i++) {
            v = qh[i];
            if (v < 0) v = -v;
            if (v > amx) amx = v;
        }
        while ((amx >> s1) > 32767) s1++;
        while (((amx >> s1) >> sq) > 2047) sq++;

        for (i = 0; i < hd; i++) {
            v = (qh[i] >> s1) >> sq;
            ss += (unsigned int)(v * v);
        }
        for (i = 0; i < hd; i++)
            u[i] = ((qh[i] >> s1) * g[i]) >> 15;      /* 16x16 -> 32 */

        for (i = 0; i < half; i++) {
            a = u[i];
            b = u[i + half];
            u[i]        = (a * co[i] - b * si[i]) >> 15;
            u[i + half] = (b * co[i] + a * si[i]) >> 15;
        }
        for (i = 0; i < hd; i++) {
            v = u[i];
            if (v < 0) v = -v;
            if (v > mx) mx = v;
        }
        if (mx == 0) mx = 1;

        inv = ((long long)127 << 46) / (long long)mx;
        for (i = 0; i < hd; i++) {
            qq = (long long)u[i] * inv;
            qq = (qq >= 0) ? ((qq + ((long long)1 << 45)) >> 46)
                           : -((((-qq) + ((long long)1 << 45)) >> 46));
            w = (int)qq;
            if (w > 127) w = 127; else if (w < -128) w = -128;
            oh[i] = (signed char)w;
        }

        sc[h * 4u + 0u] = (int)ss;
        sc[h * 4u + 1u] = s1;
        sc[h * 4u + 2u] = sq;
        sc[h * 4u + 3u] = mx;
    }

    for (i = 0; i < nh * hd; i++)
        chk += (unsigned long)(long)o8[i] * (unsigned long)(i + 1u);
    uart_puts("QCHK "); uart_puthex(chk); uart_puts("\nOK QK\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "NQ ")) cmd_nq(line + 3);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "QKN ")) cmd_qkn(line + 4);'
