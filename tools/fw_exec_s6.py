"""Block executor stage 5b: Q.K^T from the KV cache through the array.

Same escaping caution: these strings become C, so a newline inside a C
string literal is written \\n here.
"""

EXEC6 = r"""
/* ---- Stage 5b: Q.K^T ------------------------------------------------
   AMAC has been exact on silicon since build 19, against keys the host
   bit-sliced and shipped over the wire. This is the same operator reading
   keys the board produced itself, out of a 29 MB cache, by DMA.

   Three things matter here and none of them is arithmetic.

   The cache is written through the data cache and the CDMA reads DDR
   directly, so a chunk has to be flushed before its transfer. The same
   flush has sat in cmd_pagedma since phase 2.5 doing precisely nothing,
   because the D-cache was never enabled until today. This is the first
   place it earns its keep.

   In int8 mode the feeder addresses weight words as {4'd0, k[9:0]} and
   ignores the column-tile select, so AMAC always reads the first 16 KB of
   the weight BRAM. Every chunk lands at the base, not at an offset. The
   alternative gives a plausible wrong answer on every chunk after the
   first.

   The query is written into act_ram once and persists across chunks --
   eight writes per element, because the bit-serial path consumes one
   plane per sub-cycle and the feeder expects them already expanded. */

static void kv_dma(unsigned int src, unsigned int bytes) {
    unsigned long spin = 0;
    dcache_flush_range(src, bytes);
    IO32(CDMA_CR) = 0x04u;
    while (IO32(CDMA_CR) & 0x04u) { }
    IO32(CDMA_SA)  = src;
    IO32(CDMA_DA)  = WEIGHT_BRAM;
    IO32(CDMA_BTT) = bytes;
    while (!(IO32(CDMA_SR) & 0x02u)) {
        if (++spin > 20000000u) { uart_puts("ERR cdma timeout\n"); return; }
    }
    if (IO32(CDMA_SR) & CDMA_ERR_MASK) {
        uart_puts("ERR cdma SR "); uart_puthex(IO32(CDMA_SR)); uart_puts("\n");
    }
}

static void cmd_qk(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  qsl = parse_u(&p), dsl = parse_u(&p);
    const signed char *q = (const signed char *)VSLOT(qsl);
    int *o = (int *)VSLOT(dsl);
    unsigned long npos, nch, c, i, b;
    unsigned long chk = 0;

    if (blk >= 28u || kvh >= KV_NKV || pos >= KV_MAXP) {
        uart_puts("ERR range\n"); return;
    }
    npos = pos + 1u;
    nch  = (npos + 63u) / 64u;

    /* One load of the query, reused for every chunk. */
    IO32(STREAM_BASE + S_CTRL) = 0x4u;
    for (i = 0; i < KV_HD; i++)
        for (b = 0; b < 8u; b++)
            IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)q[i];

    for (c = 0; c < nch; c++) {
        kv_dma(kv_kbase(blk, kvh, c), KV_CH);
        IO32(STREAM_BASE + S_CTRL) = 0x9u;               /* START | INT8 */
        while (!(IO32(STREAM_BASE + S_STATUS) & 0x2u)) { }
        IO32(STREAM_BASE + S_CTRL) = 0x2u;
        for (i = 0; i < 64u; i++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)i;
            o[c * 64u + i] = (int)IO32(STREAM_BASE + S_RDATA);
        }
    }
    for (i = 0; i < npos; i++)
        chk += (unsigned long)o[i] * (unsigned long)(i + 1u);
    uart_puts("QKCHK "); uart_puthex(chk);
    uart_puts(" N "); uart_putdec((long)npos);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nOK QKD\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "SCT ")) cmd_sct(line + 4);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "QKD ")) cmd_qk(line + 4);'
