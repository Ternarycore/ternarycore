"""Block executor stage 10b: operators that read what the last one wrote.

Two commands, each removing a class of UART traffic from the block:

  NQD   RMSNorm+quantize with its gain read from DDR instead of received
        from the host, and taking a raw projection accumulator directly
        by shifting it into range itself.
  PJO   a projection with an activation offset, so segment s reads the
        slot NQD already wrote rather than having the host resend those
        1024 bytes.

Between them, roughly 70 KB of a block's 162 KB. The rest is projection
accumulators, and those stop crossing the wire only when the residual
adds move here too -- which is what these two make possible.

Escaping caution: these strings become C, so a newline inside a C string
literal is written \\n here.
"""

EXEC10B = r"""
/* ---- NQD: RMSNorm + quantize, gain from DDR, input auto-ranged -------
   nq_core forms x*g as a 16x16 product, so it needs |x| <= 32767.
   Projection accumulators arrive as large as 1024*127 = 130048, and the
   host has been normalizing them to Q15 and sending them back down. Do
   it here: find the maximum, shift into range, report the shift.

   The shift is applied in place, which is safe only because every vector
   this runs on is scratch the host does not read afterwards. Applied to
   a slot someone still wanted, it would take their low bits without
   saying so -- so the caller, not this function, owns that decision.

   Rounding is symmetric, through rsh. An arithmetic shift truncates
   toward negative infinity and one discarded unit here is worth mx/127
   output LSBs. That exact magnitude put five differing elements per
   thousand into stage 1, twice, before the same fix was applied there. */

static void cmd_nqd(const char *p) {
    unsigned long src = parse_u(&p), gi = parse_u(&p), dst = parse_u(&p),
                  blk = parse_u(&p), n = parse_u(&p), i;
    int *x = (int *)VSLOT(src);
    int v, amx = 0, sh = 0;

    if (n == 0u || n > VS_MAX || gi >= 6u || blk >= 28u) {
        uart_puts("ERR range\n"); return;
    }
    if (n != gain_len[gi]) {
        uart_puts("ERR gain len "); uart_putdec((long)gain_len[gi]);
        uart_puts("\n"); return;
    }

    for (i = 0; i < n; i++) {
        v = x[i]; if (v < 0) v = -v;
        if (v > amx) amx = v;
    }
    while ((amx >> sh) > 32767) sh++;
    if (sh) for (i = 0; i < n; i++) x[i] = rsh(x[i], sh);

    if (!nq_core(x, (const int *)(meta_rec(blk) + gain_off[gi]),
                 (signed char *)VSLOT(dst), n)) {
        uart_puts("ERR x not 16-bit after shift\n"); return;
    }
    uart_puts("NQD sh "); uart_putdec((long)sh); uart_puts("\n");
    nq_report();
}

/* ---- PJO: a projection reading its activations at an offset ----------
   o_proj reads 2048 and down_proj 3072, so both run in 1024-deep
   segments and the activations for segment s begin at s*1024 in the slot
   NQD wrote. The four-argument PROJ still exists, offset zero, so every
   check written against it stays valid. */

static void cmd_projo(const char *p) {
    unsigned long asrc = parse_u(&p), aoff = parse_u(&p), dst = parse_u(&p),
                  ntile = parse_u(&p), seg = parse_u(&p), j;
    unsigned long chk = 0;
    const int *o;

    if (ntile == 0u || ntile > 16u || aoff > VS_MAX) {
        uart_puts("ERR range\n"); return;
    }
    proj_core((const signed char *)VSLOT(asrc) + aoff,
              (int *)VSLOT(dst), ntile, seg);

    o = (const int *)VSLOT(dst);
    for (j = 0; j < ntile * 64u; j++)
        chk += (unsigned long)o[j] * (unsigned long)(j + 1u);
    uart_puts("PCHK "); uart_puthex(chk);
    uart_puts("\nOK PJO\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "MREAD ")) cmd_mread(line + 6);'
CMD_NEW = (CMD_OLD
           + '\n        else if (starts(line, "NQD ")) cmd_nqd(line + 4);'
           + '\n        else if (starts(line, "PJO ")) cmd_projo(line + 4);')
