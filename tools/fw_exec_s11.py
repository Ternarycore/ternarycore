"""Block executor stage 11: drive the fabric normalizer.

NQF does what NQD does -- RMSNorm and absmax int8 quantize, gain from
DDR -- but hands the arithmetic to the hardware at 0x44400000 instead of
running it on the CPU. Measured on the soft CPU: 32.05 cycles per element
for the sum of squares plus 18.02 for the quantizer. In fabric: 3.05,
plus the CDMA moving 9n bytes.

The CDMA carries the vectors both ways, which is why this is a slave and
not a master -- an AXI master would have saved 0.1 ms of a 574 ms token
and cost a new master on the interconnect, which is where two shipped
bitstreams computed zeros.

Escaping caution: these strings become C, so a newline inside a C string
literal is written \\n here.
"""

EXEC11 = r"""
/* ---- Stage 11: the fabric RMSNorm + quantizer ------------------------
   Aperture from the block design, asserted reachable by both the
   MicroBlaze and the CDMA at build time:

     +0x00000  x     4096 x 32b, CDMA writes
     +0x04000  g     4096 x 32b, CDMA writes
     +0x08000  o8    4096 x  8b, CDMA reads
     +0x10000  ctrl  [12:0] n, bit 31 start
     +0x10004  stat  bit0 busy, bit1 done
     +0x10008  mx / +0x1000C ss / +0x10010 xs                          */

#define NORM_BASE  0x44400000u
#define NORM_X     (NORM_BASE + 0x00000u)
#define NORM_G     (NORM_BASE + 0x04000u)
#define NORM_O8    (NORM_BASE + 0x08000u)
#define NORM_CTRL  (NORM_BASE + 0x10000u)
#define NORM_STAT  (NORM_BASE + 0x10004u)
#define NORM_MX    (NORM_BASE + 0x10008u)
#define NORM_SS    (NORM_BASE + 0x1000Cu)
#define NORM_XS    (NORM_BASE + 0x10010u)

#define IS_DDR(a)  ((a) >= DDR_BASE && (a) < (DDR_BASE + 0x10000000u))

/* kv_dma hardcodes WEIGHT_BRAM as its destination, so this is the same
   sequence with both ends free. Kept separate rather than generalizing
   kv_dma, because that function is load-bearing for stages 6 and 8 and
   this is not the moment to re-verify them.

   Both ends get a cache flush when they are in DDR, and the return leg
   matters more than the outbound one: the CDMA writes DDR directly,
   behind the data cache, so any line the CPU still holds for the
   destination is stale the moment the transfer lands. The cache was off
   for four months of this project and turning it on was worth 4.5x;
   forgetting it is now live would be worth a wrong answer. */
static void cdma_move(unsigned int src, unsigned int dst, unsigned int bytes) {
    unsigned long spin = 0;

    if (IS_DDR(src)) dcache_flush_range(src, bytes);
    IO32(CDMA_CR) = 0x04u;
    while (IO32(CDMA_CR) & 0x04u) { }
    IO32(CDMA_SA)  = src;
    IO32(CDMA_DA)  = dst;
    IO32(CDMA_BTT) = bytes;
    while (!(IO32(CDMA_SR) & 0x02u)) {
        if (++spin > 20000000u) { uart_puts("ERR cdma timeout\n"); return; }
    }
    if (IO32(CDMA_SR) & CDMA_ERR_MASK) {
        uart_puts("ERR cdma SR "); uart_puthex(IO32(CDMA_SR)); uart_puts("\n");
    }
    if (IS_DDR(dst)) dcache_flush_range(dst, bytes);
}

/* NQF <xsrc> <gidx> <dst> <blk> <n>

   Reports through nq_report, in nq_core's exact format, so every host
   parser written against NQ and NQD works unchanged and the fabric can
   be swapped in underneath them without touching a line of Python. */
static void cmd_nqf(const char *p) {
    unsigned long xsl = parse_u(&p), gi = parse_u(&p), dst = parse_u(&p),
                  blk = parse_u(&p), n = parse_u(&p);
    unsigned long spin = 0;

    if (n == 0u || n > VS_MAX || gi >= 6u || blk >= 28u) {
        uart_puts("ERR range\n"); return;
    }
    if (n != gain_len[gi]) {
        uart_puts("ERR gain len "); uart_putdec((long)gain_len[gi]);
        uart_puts("\n"); return;
    }

    cdma_move(VSLOT(xsl), NORM_X, (unsigned int)n * 4u);
    cdma_move(meta_rec(blk) + gain_off[gi], NORM_G, (unsigned int)n * 4u);

    IO32(NORM_CTRL) = (unsigned int)n | 0x80000000u;
    while (!(IO32(NORM_STAT) & 0x2u)) {
        if (++spin > 20000000u) { uart_puts("ERR nqf timeout\n"); return; }
    }

    cdma_move(NORM_O8, VSLOT(dst), (unsigned int)n);

    nq_mx = (int)IO32(NORM_MX);
    nq_ss = IO32(NORM_SS);
    nq_xs = (int)IO32(NORM_XS);
    nq_report();
}

/* NQBENCH <fab> <gidx> <blk> <n> <reps> -- the board times itself.

   One call is ~0.5 ms on the CPU and ~0.05 ms in fabric, and the UART
   round trip that would report it is 16 ms. Timing a single call over
   the wire times the wire. Repetitions bracketed by MARK lines let the
   host take a slope, which is exactly what the pager needed once a page
   completed faster than one line of serial output could be printed. */
static void cmd_nqbench(const char *p) {
    unsigned long fab = parse_u(&p), gi = parse_u(&p), blk = parse_u(&p),
                  n = parse_u(&p), reps = parse_u(&p), r;

    if (gi >= 6u || blk >= 28u || n != gain_len[gi]) {
        uart_puts("ERR range\n"); return;
    }
    uart_puts("MARK NQB_START\n");
    for (r = 0; r < reps; r++) {
        if (fab) {
            cdma_move(VSLOT(0), NORM_X, (unsigned int)n * 4u);
            cdma_move(meta_rec(blk) + gain_off[gi], NORM_G,
                      (unsigned int)n * 4u);
            IO32(NORM_CTRL) = (unsigned int)n | 0x80000000u;
            while (!(IO32(NORM_STAT) & 0x2u)) { }
            cdma_move(NORM_O8, VSLOT(3), (unsigned int)n);
        } else {
            nq_core((const int *)VSLOT(0),
                    (const int *)(meta_rec(blk) + gain_off[gi]),
                    (signed char *)VSLOT(3), n);
        }
    }
    uart_puts("MARK NQB_END\nOK NQB\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "PJO ")) cmd_projo(line + 4);'
CMD_NEW = (CMD_OLD
           + '\n        else if (starts(line, "NQF ")) cmd_nqf(line + 4);'
           + '\n        else if (starts(line, "NQBENCH ")) cmd_nqbench(line + 8);')
