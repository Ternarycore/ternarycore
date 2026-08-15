"""Block executor stage 7: P.V through the array.

Q.K^T with the operands transposed, which changes the whole feeding
pattern. Same escaping caution: these strings become C, so a newline
inside a C string literal is written \\n here.
"""

EXEC8 = r"""
/* ---- Stage 7: P.V ----------------------------------------------------
   The same array operation as Q.K^T with its operands swapped, and that
   swap changes everything about how it is fed.

   Q.K^T sums over head_dim and yields one number per key: keys are the
   64 columns, and the 128 dims fill the array's depth exactly once, so
   one pass covers 64 keys. P.V sums over keys and yields one number per
   dim: dims are the columns, keys are the depth, and bit-serial int8
   spends eight depth slots per element -- so 1024 slots hold 128 keys,
   not 512. A full context is four accumulating passes across two column
   groups: eight array runs per head, where Q.K^T needed eight for the
   whole 512.

   The activations are the probabilities. They are non-negative by
   construction, so nothing here has to think about sign extension, and a
   partially filled final chunk is zero-padded rather than masked: a zero
   activation selects zero whatever stale bit planes lie beyond the
   current position, so the tail costs nothing and needs no clearing.

   Accumulation across position chunks is in software because each pass
   is an independent 128-deep dot product -- one add per output per chunk,
   against the 128x128 MACs the array does in the same pass. */

static void cmd_pv(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  psl = parse_u(&p), osl = parse_u(&p);
    const signed char *pr = (const signed char *)VSLOT(psl);
    int *o = (int *)VSLOT(osl);
    unsigned long npos, npch, pch, dch, i, b, j;
    unsigned long chk = 0;
    int v;

    if (blk >= 28u || kvh >= KV_NKV || pos >= KV_MAXP) {
        uart_puts("ERR range\n"); return;
    }
    npos = pos + 1u;
    npch = (npos + 127u) / 128u;

    for (i = 0; i < KV_HD; i++) o[i] = 0;

    for (dch = 0; dch < 2u; dch++) {
        for (pch = 0; pch < npch; pch++) {
            IO32(STREAM_BASE + S_CTRL) = 0x4u;          /* act ptr reset */
            for (i = 0; i < 128u; i++) {
                j = pch * 128u + i;
                v = (j < npos) ? (int)pr[j] : 0;
                for (b = 0; b < 8u; b++)
                    IO32(STREAM_BASE + S_ACTWR) =
                        (unsigned int)(unsigned char)v;
            }
            kv_dma(kv_vbase(blk, kvh, pch, dch), KV_CH);
            IO32(STREAM_BASE + S_CTRL) = 0x9u;           /* START | INT8 */
            while (!(IO32(STREAM_BASE + S_STATUS) & 0x2u)) { }
            IO32(STREAM_BASE + S_CTRL) = 0x2u;
            for (i = 0; i < 64u; i++) {
                IO32(STREAM_BASE + S_RIDX) = (unsigned int)i;
                o[dch * 64u + i] += (int)IO32(STREAM_BASE + S_RDATA);
            }
        }
    }

    for (i = 0; i < KV_HD; i++)
        chk += (unsigned long)o[i] * (unsigned long)(i + 1u);
    uart_puts("PVCHK "); uart_puthex(chk);
    uart_puts(" N "); uart_putdec((long)npos);
    uart_puts(" P "); uart_putdec((long)npch);
    uart_puts("\nOK PV\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "SM ")) cmd_sm(line + 3);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "PV ")) cmd_pv(line + 3);'
