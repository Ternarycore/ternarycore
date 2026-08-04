// tier1_host.c
// SPDX-License-Identifier: CERN-OHL-S-2.0
// TernaryCore Stage 1 host-streaming firmware (HOST_STREAMING.md).
// UART command protocol over the AXI UART16550, bare-metal (no BSP):
//
//   PING                     -> "PONG"
//   LOADW <off> <len>\n      -> then <len> raw bytes -> packed weights into
//                               weight BRAM at byte offset <off> (off%4==0).
//                               Reply: "OK W <hexsum>"
//   LOADA <len>\n            -> then <len> raw int8 activations (len<=768).
//                               Reply: "OK A <hexsum>"
//   RUN <passes>\n           -> verify accel vs sw (1 pass each), then run
//                               <passes> accel passes and <passes/20+1> sw
//                               passes between MARK lines. Replies with
//                               outputs + checksum, ends "DONE".
//
// Same address map and datapath as tier1_bare.c. Compile:
//   mb-gcc -O2 -Wall -mlittle-endian -mcpu=v11.0 -mxl-barrel-shift \
//          -mno-xl-soft-mul -mno-xl-soft-div -mxl-pattern-compare \
//          -Wl,--defsym=_STACK_SIZE=0x1000 -L. -o tier1_host.elf tier1_host.c stubs.c

#define IO32(a) (*(volatile unsigned int *)(a))

#define GEMM_BASE     0x44000000u
#define WEIGHT_BRAM   0x44100000u
#define UART_BASE     0x40600000u
#define GPIO_BASE     0x40000000u


/* ---- Phase-2: DDR3 via MIG ---- */
#define DDR_BASE      0x80000000u
#define PAGE_BYTES    262144u

/* ---- Phase-2.5: AXI CDMA hardware pager ---- */
#define CDMA_BASE     0x44300000u
#define CDMA_CR       (CDMA_BASE + 0x00u)   /* bit2 = soft reset            */
#define CDMA_SR       (CDMA_BASE + 0x04u)   /* bit1 = Idle, bits 4-6/8-10 err */
#define CDMA_SA       (CDMA_BASE + 0x18u)   /* source address               */
#define CDMA_DA       (CDMA_BASE + 0x20u)   /* destination address          */
#define CDMA_BTT      (CDMA_BASE + 0x28u)   /* bytes-to-transfer; write starts */
#define CDMA_ERR_MASK 0x00000770u           /* DMA + SG decode/slave/internal */

/* ---- Phase-3: AXI EthernetLite MDIO ---- */
#define ETH_BASE      0x40E00000u
#define ETH_MDIOADDR  (ETH_BASE + 0x07E4u)
#define ETH_MDIOWR    (ETH_BASE + 0x07E8u)
#define ETH_MDIORD    (ETH_BASE + 0x07ECu)
#define ETH_MDIOCTRL  (ETH_BASE + 0x07F0u)  /* bit0 = status/start, bit3 = enable */

/* EthernetLite buffers. No DMA: the CPU copies frames by hand.
   TX ping 0x0000..0x07FF, TPLR 0x07F4, TSR 0x07FC (bit0 busy, bit1 prog MAC)
   RX ping 0x1000..0x17FF, RSR 0x17FC (bit0 = frame present, write 0 to clear)
   RX pong 0x1800..0x1FFF, RSR 0x1FFC                                       */
#define ETH_TXBUF     (ETH_BASE + 0x0000u)
#define ETH_TPLR      (ETH_BASE + 0x07F4u)
#define ETH_TSR       (ETH_BASE + 0x07FCu)
#define ETH_RXBUF0    (ETH_BASE + 0x1000u)
#define ETH_RSR0      (ETH_BASE + 0x17FCu)
#define ETH_RXBUF1    (ETH_BASE + 0x1800u)
#define ETH_RSR1      (ETH_BASE + 0x1FFCu)
#define TSR_BUSY      0x00000001u
#define TSR_PROG_MAC  0x00000002u
#define RSR_RECV      0x00000001u
/* ---- Tier-2 streaming GEMM (axi_gemm_stream @ 0x44200000) ---- */
#define STREAM_BASE   0x44200000u
#define S_CTRL        0x00u
#define S_STATUS      0x04u
#define S_ACTWR       0x08u
#define S_CT          0x0Cu
#define S_RIDX        0x14u
#define S_RDATA       0x18u
#define S_CYC         0x20u


#define REG_CTRL       0x00u
#define REG_ACTIVATION 0x04u
#define REG_WEIGHT_ENC 0x08u
#define REG_ACC_OUT0   0x10u
#define CTRL_START     0x00000001u
#define CTRL_DONE      0x80000000u

#define UART_RBR_THR (UART_BASE + 0x1000u)
#define UART_IER     (UART_BASE + 0x1004u)
#define UART_FCR     (UART_BASE + 0x1008u)
#define UART_LCR     (UART_BASE + 0x100Cu)
#define UART_LSR     (UART_BASE + 0x1014u)
#define LSR_DR       0x01u
#define LSR_THRE     0x20u

#define DEPTH        1024
#define COLS_TOTAL   1024
#define GROUPS       (COLS_TOTAL / 4)
#define WBYTES       (DEPTH * GROUPS)   /* 147,456 bytes for one 768x768 layer */

static void uart_init(void) {
    IO32(UART_LCR) = 0x83u;
    IO32(UART_RBR_THR) = 44u;            /* DLL: 81.25e6/(16*115200) */
    IO32(UART_IER) = 0u;                 /* DLM */
    IO32(UART_LCR) = 0x03u;
    IO32(UART_FCR) = 0x07u;
}

static int uart_mute = 0;

static void uart_putc(char c) {
    if (uart_mute) return;
    while (!(IO32(UART_LSR) & LSR_THRE)) { }
    IO32(UART_RBR_THR) = (unsigned int)(unsigned char)c;
}

static unsigned char uart_getc(void) {
    while (!(IO32(UART_LSR) & LSR_DR)) { }
    return (unsigned char)IO32(UART_RBR_THR);
}

static void uart_puts(const char *s) {
    while (*s) { if (*s == '\n') uart_putc('\r'); uart_putc(*s++); }
}

static void uart_putdec(long v) {
    char b[12]; int i = 0; unsigned long u;
    if (v < 0) { uart_putc('-'); u = (unsigned long)(-v); } else u = (unsigned long)v;
    do { b[i++] = (char)('0' + (u % 10u)); u /= 10u; } while (u);
    while (i) uart_putc(b[--i]);
}

static void uart_puthex(unsigned long v) {
    static const char *h = "0123456789abcdef"; int i;
    uart_puts("0x");
    for (i = 28; i >= 0; i -= 4) uart_putc(h[(v >> i) & 0xFu]);
}

static void led(unsigned int v) { IO32(GPIO_BASE) = v; }

static signed char activations[DEPTH];
static long * const accel_out = (long *)(DDR_BASE + 0x0E040000u);
static long * const sw_out = (long *)(DDR_BASE + 0x0E030000u);

static unsigned char read_weight_byte(unsigned int a) {
    unsigned int w = IO32(WEIGHT_BRAM + (a & ~3u));
    return (unsigned char)(w >> (8u * (a & 3u)));
}

static signed char decode_ternary(unsigned char b) {
    b &= 0x3u;
    if (b == 0x01u) return 1;
    if (b == 0x02u) return -1;
    return 0;
}

static void accel_forward_pass(long *o) {
    int g, k;
    for (g = 0; g < GROUPS; g++) {
        IO32(GEMM_BASE + REG_CTRL) = CTRL_START;
        for (k = 0; k < DEPTH; k++) {
            IO32(GEMM_BASE + REG_WEIGHT_ENC) = (unsigned int)read_weight_byte((unsigned int)(k * GROUPS + g));
            IO32(GEMM_BASE + REG_ACTIVATION) = (unsigned int)(unsigned char)activations[k];
        }
        while (!(IO32(GEMM_BASE + REG_CTRL) & CTRL_DONE)) { }
        o[g*4+0] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT0 + 0x0);
        o[g*4+1] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT0 + 0x4);
        o[g*4+2] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT0 + 0x8);
        o[g*4+3] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT0 + 0xC);
    }
}

static void sw_forward_pass(long *o) {
    int c, k;
    for (c = 0; c < COLS_TOTAL; c++) {
        long s = 0; int g = c / 4, bp = (c & 3) * 2;
        for (k = 0; k < DEPTH; k++) {
            unsigned char wb = read_weight_byte((unsigned int)(k * GROUPS + g));
            s += (long)activations[k] * (long)decode_ternary((unsigned char)((wb >> bp) & 0x3u));
        }
        o[c] = s;
    }
}

/* ---- command parsing ---- */
static char line[64];

static void read_line(void) {
    int i = 0; unsigned char c;
    for (;;) {
        c = uart_getc();
        if (c == '\n' || c == '\r') { if (i == 0) continue; break; }
        if (i < 63) line[i++] = (char)c;
    }
    line[i] = 0;
}

static const char *skip_ws(const char *p) { while (*p == ' ') p++; return p; }

static unsigned long parse_u(const char **pp) {
    const char *p = skip_ws(*pp); unsigned long v = 0;
    while (*p >= '0' && *p <= '9') v = v * 10u + (unsigned long)(*p++ - '0');
    *pp = p; return v;
}

static int starts(const char *s, const char *pfx) {
    while (*pfx) if (*s++ != *pfx++) return 0;
    return 1;
}

static void cmd_loadw(const char *p) {
    unsigned long off = parse_u(&p), len = parse_u(&p), i, sum = 0;
    unsigned int word = 0;
    if ((off & 3u) || off + len > 256u * 1024u) { uart_puts("ERR range\n"); return; }
    for (i = 0; i < len; i++) {
        unsigned char b = uart_getc();
        sum += b;
        word |= ((unsigned int)b) << (8u * (i & 3u));
        if ((i & 3u) == 3u) { IO32(WEIGHT_BRAM + off + (i & ~3u)) = word; word = 0; }
    }
    if (len & 3u) IO32(WEIGHT_BRAM + off + (len & ~3u)) = word;
    uart_puts("OK W "); uart_puthex(sum); uart_puts("\n");
}

static void cmd_loada(const char *p) {
    unsigned long len = parse_u(&p), i, sum = 0;
    if (len > DEPTH) { uart_puts("ERR range\n"); return; }
    for (i = 0; i < len; i++) {
        unsigned char b = uart_getc();
        sum += b;
        activations[i] = (signed char)b;
    }
    for (; i < DEPTH; i++) activations[i] = 0;
    uart_puts("OK A "); uart_puthex(sum); uart_puts("\n");
}

static void cmd_run(const char *p) {
    unsigned long passes = parse_u(&p), i;
    unsigned long checksum = 0;
    int c, errors = 0;
    unsigned long sw_passes;
    if (passes == 0) passes = 1;
    sw_passes = passes / 20u + 1u;

    accel_forward_pass(accel_out);
    sw_forward_pass(sw_out);
    for (c = 0; c < COLS_TOTAL; c++) if (accel_out[c] != sw_out[c]) errors++;
    if (errors) {
        uart_puts("VERIFY FAIL "); uart_putdec(errors); uart_puts("\n");
        for (c = 0; c < COLS_TOTAL && errors > 0; c++)
            if (accel_out[c] != sw_out[c]) {
                uart_puts("MISMATCH "); uart_putdec(c); uart_puts(" ");
                uart_putdec(accel_out[c]); uart_puts(" "); uart_putdec(sw_out[c]); uart_puts("\n");
                if (--errors < COLS_TOTAL - 5) break;
            }
        uart_puts("DONE\n");
        led(0x8);
        return;
    }
    uart_puts("VERIFY PASS\n");
    for (c = 0; c < COLS_TOTAL; c++) checksum += (unsigned long)accel_out[c] * (unsigned long)(c + 1);
    uart_puts("CHK "); uart_puthex(checksum);
    uart_puts(" OUT ");
    for (c = 0; c < 8; c++) { uart_putdec(accel_out[c]); uart_putc(c < 7 ? ',' : ' '); }
    uart_puts("\n");
    led(0x7);

    uart_puts("MARK ACCEL_START "); uart_putdec((long)passes); uart_puts("\n");
    for (i = 0; i < passes; i++) accel_forward_pass(accel_out);
    uart_puts("MARK ACCEL_END\n");
    uart_puts("MARK SW_START "); uart_putdec((long)sw_passes); uart_puts("\n");
    for (i = 0; i < sw_passes; i++) sw_forward_pass(sw_out);
    uart_puts("MARK SW_END\n");
    uart_puts("DONE\n");
    led(0xF);
}


/* ---- Tier-2 stream commands ---- */
static void cmd_sload(void) {
    unsigned long k;
    IO32(STREAM_BASE + S_CTRL) = 0x4u;              /* act ptr reset */
    for (k = 0; k < DEPTH; k++)
        IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)activations[k];
    uart_puts("OK SL\n");
}

static void stream_tile(unsigned int ct) {
    IO32(STREAM_BASE + S_CT)   = ct;
    IO32(STREAM_BASE + S_CTRL) = 0x1u;              /* start */
    while (!(IO32(STREAM_BASE + S_STATUS) & 0x2u)) { }
    IO32(STREAM_BASE + S_CTRL) = 0x2u;              /* clear done */
}

static void cmd_srun(const char *p) {
    unsigned long passes = parse_u(&p), i;
    unsigned int ct; int c;
    unsigned long checksum = 0;
    if (passes == 0) passes = 1;
    stream_tile(0);
    uart_puts("CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC)); uart_puts("\n");
    uart_puts("MARK STREAM_START "); uart_putdec((long)passes); uart_puts("\n");
    for (i = 0; i < passes; i++)
        for (ct = 0; ct < 16; ct++) stream_tile(ct);
    uart_puts("MARK STREAM_END\n");
    for (ct = 0; ct < 16; ct++) {
        stream_tile(ct);
        for (c = 0; c < 64; c++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
            accel_out[(int)ct*64 + c] = (long)(int)IO32(STREAM_BASE + S_RDATA);
        }
    }
    for (c = 0; c < COLS_TOTAL; c++)
        checksum += (unsigned long)accel_out[c] * (unsigned long)(c + 1);
    uart_puts("SCHK "); uart_puthex(checksum); uart_puts(" OUT ");
    for (c = 0; c < 8; c++) { uart_putdec(accel_out[c]); uart_putc(c < 7 ? ',' : ' '); }
    uart_puts("\nDONE\n");
}


/* ---- Phase-2 DDR commands ---- */
static void cmd_memtest(void) {
    unsigned long i, errs = 0;
    /* 4096 words strided 16 KB apart across 64 MB: defeats the 16 KB dcache */
    for (i = 0; i < 4096u; i++)
        IO32(DDR_BASE + i * 16384u) = 0xA5000000u ^ (unsigned int)(i * 2654435761u);
    for (i = 0; i < 4096u; i++)
        if (IO32(DDR_BASE + i * 16384u) != (0xA5000000u ^ (unsigned int)(i * 2654435761u))) errs++;
    if (errs) { uart_puts("MEMTEST FAIL "); uart_putdec((long)errs); uart_puts("\n"); }
    else      { uart_puts("MEMTEST OK 4096 words / 64MB span\n"); }
}

static void cmd_loadm(const char *p) {
    unsigned long off = parse_u(&p), len = parse_u(&p), i, sum = 0;
    unsigned int word = 0;
    if ((off & 3u) || off + len > 224u * 1024u * 1024u) { uart_puts("ERR range\n"); return; }
    for (i = 0; i < len; i++) {
        unsigned char b = uart_getc();
        sum += b;
        word |= ((unsigned int)b) << (8u * (i & 3u));
        if ((i & 3u) == 3u) { IO32(DDR_BASE + off + (i & ~3u)) = word; word = 0; }
    }
    if (len & 3u) IO32(DDR_BASE + off + (len & ~3u)) = word;
    uart_puts("OK M "); uart_puthex(sum); uart_puts("\n");
}

static void cmd_page(const char *p) {
    unsigned long off = parse_u(&p), i;
    if (off & 3u) { uart_puts("ERR align\n"); return; }
    uart_puts("MARK PAGE_START\n");
    for (i = 0; i < PAGE_BYTES; i += 4u)
        IO32(WEIGHT_BRAM + i) = IO32(DDR_BASE + off + i);
    uart_puts("MARK PAGE_END\nOK P\n");
}

/* ---- Phase-2.5: hardware pager ----
   LOADM wrote the page through the data cache. The CDMA reads DDR3 directly
   over AXI and never sees the cache, so any dirty line still resident would
   make it fetch stale bytes. Flush the source range first. On a write-through
   dcache wdc.flush degrades to an invalidate, which is harmless here. */
static void dcache_flush_range(unsigned long base, unsigned long bytes) {
    unsigned long i, zero = 0;
    for (i = 0; i < bytes; i += 32u)   /* MicroBlaze cache line = 32 B */
        __asm__ __volatile__ ("wdc.flush %0, %1" :: "r"(base + i), "r"(zero));
    __asm__ __volatile__ ("mbar 1");
}

static void cmd_pagedma(const char *p) {
    unsigned long off = parse_u(&p), n = parse_u(&p), k, spin = 0;
    unsigned int sr;
    if (off & 3u) { uart_puts("ERR align\n"); return; }
    if (n == 0u) n = 1u;   /* optional repeat count: amortise UART latency */

    IO32(CDMA_CR) = 0x04u;                                  /* soft reset */
    while (IO32(CDMA_CR) & 0x04u)
        if (++spin > 1000000u) { uart_puts("ERR cdma reset\n"); return; }

    /* No flush of the source. It cost 0.744 ms of a 1.537 ms page --
       8192 wdc.flush instructions over 256 KB -- which is 312 ms of every
       token, and it was protecting against a dirty line that cannot
       exist: the weight image is written by the Ethernet DMA and read by
       this CDMA, and the CPU never touches it. That is the whole
       argument, and it stops holding the moment anything on the CPU
       writes or reads DDR below 0x068F0000. Proven by a block check
       against the golden model, not by this comment. */

    uart_puts("MARK PAGEDMA_START\n");
    for (k = 0; k < n; k++) {
    IO32(CDMA_SA)  = DDR_BASE + off;
    IO32(CDMA_DA)  = WEIGHT_BRAM;
    IO32(CDMA_BTT) = PAGE_BYTES;                            /* starts transfer */
    spin = 0;
    while (!(IO32(CDMA_SR) & 0x02u)) {                      /* bit1 = Idle */
        if (++spin > 40000000u) {
            uart_puts("ERR cdma timeout SR "); uart_puthex(IO32(CDMA_SR));
            uart_puts("\n"); return;
        }
    }
    }
    uart_puts("MARK PAGEDMA_END\n");
    sr = IO32(CDMA_SR);
    if (sr & CDMA_ERR_MASK) { uart_puts("ERR cdma SR "); uart_puthex(sr); uart_puts("\n"); return; }
    uart_puts("OK PD\n");
}

/* ---- Phase-3: MDIO / PHY link check ---- */
static unsigned int mdio_read(unsigned int phy, unsigned int reg) {
    unsigned long spin = 0;
    IO32(ETH_MDIOCTRL) = 0x08u;                              /* MDIO enable */
    IO32(ETH_MDIOADDR) = (1u << 10) | ((phy & 0x1Fu) << 5) | (reg & 0x1Fu);
    IO32(ETH_MDIOCTRL) = 0x08u | 0x01u;                      /* enable + start */
    while (IO32(ETH_MDIOCTRL) & 0x01u)
        if (++spin > 1000000u) return 0xFFFFFFFFu;
    return IO32(ETH_MDIORD) & 0xFFFFu;
}

static void cmd_ethlink(void) {
    unsigned int phy, id1, bmsr;
    for (phy = 0; phy < 32u; phy++) {
        id1 = mdio_read(phy, 2u);                            /* PHYIDR1 */
        if (id1 == 0xFFFFu || id1 == 0x0000u || id1 == 0xFFFFFFFFu) continue;
        /* BMSR link status is latching-low: read twice for the live state */
        (void)mdio_read(phy, 1u);
        bmsr = mdio_read(phy, 1u);
        uart_puts("ETHLINK PHY ");  uart_putdec((long)phy);
        uart_puts(" ID1 ");         uart_puthex(id1);
        uart_puts(" BMSR ");        uart_puthex(bmsr);
        uart_puts((bmsr & 0x0004u) ? "  LINK UP\n" : "  LINK DOWN\n");
        return;
    }
    uart_puts("ETHLINK no PHY responded\n");
}

/* ---- Phase-3: raw frame reception ----
   No IP stack. The board talks to exactly one host over a direct link, so a
   custom EtherType with a sequence number is enough, and it saves an entire
   networking stack on a bare-metal MicroBlaze.
   Frame: [0..5] dst MAC [6..11] src MAC [12..13] 0x88B5
          [14..17] seq BE [18..19] payload len BE [20..] payload            */

static unsigned char eth_mac[6] = { 0x02u, 0x54u, 0x43u, 0x00u, 0x00u, 0x01u };

static void eth_set_mac(void) {
    unsigned long spin = 0;
    /* The core reads the address out of the TX ping buffer when PROG_MAC is
       set, so stage it there first. */
    IO32(ETH_TXBUF + 0u) = (unsigned int)eth_mac[0] | ((unsigned int)eth_mac[1] << 8)
        | ((unsigned int)eth_mac[2] << 16) | ((unsigned int)eth_mac[3] << 24);
    IO32(ETH_TXBUF + 4u) = (unsigned int)eth_mac[4] | ((unsigned int)eth_mac[5] << 8);
    IO32(ETH_TPLR) = 6u;
    /* PROG_MAC in Xilinx's driver is BUSY|PROGRAM (0x03), not PROGRAM alone:
       the core needs the busy bit to actually start the update. */
    IO32(ETH_TSR)  = TSR_BUSY | TSR_PROG_MAC;
    while (IO32(ETH_TSR) & TSR_PROG_MAC)
        if (++spin > 1000000u) { uart_puts("ERR mac program\n"); return; }
}

static unsigned int eth_hdr_type(unsigned int buf) {
    unsigned int w = IO32(buf + 12u);          /* bytes 12..15 */
    return ((w & 0xFFu) << 8) | ((w >> 8) & 0xFFu);
}

static unsigned long eth_be32(unsigned int buf, unsigned long off) {
    unsigned int w = IO32(buf + off);
    return ((unsigned long)(w & 0xFFu) << 24)
         | ((unsigned long)((w >> 8) & 0xFFu) << 16)
         | ((unsigned long)((w >> 16) & 0xFFu) << 8)
         | (unsigned long)((w >> 24) & 0xFFu);
}


/* Header fields at bytes 14..19 straddle 32-bit word boundaries, and AXI4-Lite
   has no unaligned reads. Extract from the two aligned words instead. The
   first version read at buf+14 directly and only appeared to work because the
   sequence number under test was zero. */
static unsigned long eth_seq(unsigned int buf) {
    unsigned int a = IO32(buf + 12u), b = IO32(buf + 16u);
    return ((unsigned long)((a >> 16) & 0xFFu) << 24)
         | ((unsigned long)((a >> 24) & 0xFFu) << 16)
         | ((unsigned long)(b & 0xFFu) << 8)
         | (unsigned long)((b >> 8) & 0xFFu);
}

static unsigned long eth_len(unsigned int buf) {
    unsigned int b = IO32(buf + 16u);
    return ((unsigned long)((b >> 16) & 0xFFu) << 8)
         | (unsigned long)((b >> 24) & 0xFFu);
}

/* ETHLOAD <off> <count> <chunk> -- bulk weights into DDR3 over raw Ethernet.
   Frame seq n lands at DDR_BASE + off + n*chunk, so the host can blast frames
   in any order and retry a page without re-sending the whole model. The byte
   checksum uses the same convention as LOADM, so the fast path can be checked
   against the slow one. */

/* ---- Phase-5 scoping: what do the non-matrix ops actually cost? ----
   This CPU has no FPU, so everything is fixed point, Q16.16 throughout.
   BENCH <op> <reps> <n> repeats an op and brackets it with MARK lines, so
   the host measures the slope and UART latency cancels -- the same trick
   PAGEDMA needed once a page got faster than one serial line.
   op 0 = copy baseline (loop overhead, to subtract)
      1 = RMSNorm     2 = softmax     3 = SiLU                            */

#define BN 1024
static int * const bench_buf = (int *)(DDR_BASE + 0x0E000000u);
static int * const bench_out = (int *)(DDR_BASE + 0x0E010000u);

/* 2^f for f in [0,1), Q16.16, 32 entries + linear interpolation */
static const unsigned int exp2_lut[33] = {
 65535,67008,68507,70048,71615,73216,74858,76534,78246,80006,81797,83628,
 85507,87421,89380,91384,93430,95522,97662,99845,102079,104358,106688,
 109070,111500,113988,116526,119123,121775,124487,127256,130087,65535 };

/* 2^z for z <= 0, Q16.16 in and out. Integer part is a shift, fraction is
   the table. This is the whole reason softmax is affordable without an FPU. */
static int fx_exp2(int z) {
    int i, f, k, r, a, b, v;
    if (z <= -(31 << 16)) return 0;
    i = -(z >> 16);   /* floors, so this is ceil(-z/65536) */
    f = z & 0xFFFF;
    k = f >> 11; r = f & 0x7FF;
    a = (int)exp2_lut[k]; b = (int)exp2_lut[k + 1];
    v = a + (((b - a) * r) >> 11);
    return v >> i;
}

/* 1/sqrt(v) in Q16.16 via integer sqrt then one divide -- once per norm,
   so its cost is amortised over the whole vector. */
static int fx_rsqrt(unsigned int v) {
    unsigned int s = v, t;
    if (v == 0u) return 0;
    for (t = 0; t < 20u; t++) { unsigned int q = v / (s ? s : 1u); s = (s + q) >> 1; if (s == 0u) break; }
    return (int)((1u << 24) / (s ? s : 1u));
}

static void bench_copy(int n) {
    int i;
    for (i = 0; i < n; i++) bench_out[i] = bench_buf[i];
}

static void bench_rmsnorm(int n) {
    unsigned int ss = 0u;
    int i, x, inv;
    for (i = 0; i < n; i++) { x = bench_buf[i]; ss += (unsigned int)((x * x) >> 8); }
    inv = fx_rsqrt(ss / (unsigned int)n);
    for (i = 0; i < n; i++) bench_out[i] = (int)(((long)bench_buf[i] * inv) >> 16);
}

static void bench_softmax(int n) {
    int i, mx = bench_buf[0], e;
    unsigned int sum = 0u;
    for (i = 1; i < n; i++) if (bench_buf[i] > mx) mx = bench_buf[i];
    for (i = 0; i < n; i++) {
        e = fx_exp2((int)(((long)(bench_buf[i] - mx) * 94548) >> 16));  /* *log2(e) */
        bench_out[i] = e;
        sum += (unsigned int)e;
    }
    if (sum == 0u) sum = 1u;
    for (i = 0; i < n; i++)
        bench_out[i] = (int)((((unsigned int)bench_out[i]) << 12) / (sum >> 4 ? sum >> 4 : 1u));
}

static void bench_silu(int n) {
    int i, x, ax, e, s;
    for (i = 0; i < n; i++) {
        x  = bench_buf[i];
        ax = (x < 0) ? -x : x;
        e  = fx_exp2((int)(((long)(-ax) * 94548) >> 16));      /* exp(-|x|) */
        s  = (int)((1u << 28) / (unsigned int)(((65536 + e) >> 4) ? ((65536 + e) >> 4) : 1));
        if (x < 0) s = 65536 - s;
        bench_out[i] = (int)(((long)x * s) >> 16);
    }
}


/* Softmax variants, to find where the 88.7 cycles/element actually go.
   The naive version divides per element; MicroBlaze's hardware divider is
   ~30+ cycles, so a thousand of them may be most of the cost. */

static void bench_softmax_r(int n) {      /* one reciprocal, then multiply */
    int i, mx = bench_buf[0], e, inv;
    unsigned int sum = 0u;
    for (i = 1; i < n; i++) if (bench_buf[i] > mx) mx = bench_buf[i];
    for (i = 0; i < n; i++) {
        e = fx_exp2((int)(((long)(bench_buf[i] - mx) * 94548) >> 16));
        bench_out[i] = e; sum += (unsigned int)e;
    }
    if (sum == 0u) sum = 1u;
    inv = (int)((1u << 30) / sum);                       /* the only divide */
    for (i = 0; i < n; i++)
        bench_out[i] = (int)(((long)bench_out[i] * inv) >> 14);
}

/* Deferred normalisation: attention never needs normalised weights. Weight
   the value vectors with raw exponentials and divide the result once per
   head -- 128 divides instead of one per KV entry. This measures the exp
   pass alone, which is what that would actually cost. */
static void bench_softmax_d(int n) {
    int i, mx = bench_buf[0], e;
    unsigned int sum = 0u;
    for (i = 1; i < n; i++) if (bench_buf[i] > mx) mx = bench_buf[i];
    for (i = 0; i < n; i++) {
        e = fx_exp2((int)(((long)(bench_buf[i] - mx) * 94548) >> 16));
        bench_out[i] = e; sum += (unsigned int)e;
    }
    bench_out[0] += (int)(sum & 0xFFu);   /* keep sum live */
}


/* ---- Operator set: tables, not arithmetic ----
   exp and SiLU are elementwise, so on a CPU with no FPU the right
   implementation is a lookup built once at startup. Same principle as the
   ternary weights: replace expensive arithmetic with cheap structure. */
#define LUTN 1024
static int * const exp_lut = (int *)(DDR_BASE + 0x0E050000u);    /* exp(-i/16), Q16.16              */
static int * const silu_lut = (int *)(DDR_BASE + 0x0E060000u);   /* silu(x), x = (i-512)/16, Q16.16 */
static int luts_ready = 0;

static void build_luts(void) {
    int i, xq, ax, e, s;
    if (luts_ready) return;
    for (i = 0; i < LUTN; i++)
        exp_lut[i] = fx_exp2(-(int)(((unsigned int)i * 94548u) >> 4));
    for (i = 0; i < LUTN; i++) {
        xq = ((i - 512) << 16) / 16;
        ax = (xq < 0) ? -xq : xq;
        e  = fx_exp2(-(int)(((long long)ax * 94548) >> 16));
        s  = (int)((1u << 28) / (unsigned int)(((65536 + e) >> 4) ? ((65536 + e) >> 4) : 1));
        if (xq < 0) s = 65536 - s;
        silu_lut[i] = (int)(((long long)xq * s) >> 16);
    }
    luts_ready = 1;
}

/* Softmax, production form: direct exp table, no per-element divide, no
   normalisation pass. Attention divides once per head downstream. */
static void bench_softmax_l(int n) {
    int i, mx = bench_buf[0], d;
    unsigned int sum = 0u;
    for (i = 1; i < n; i++) if (bench_buf[i] > mx) mx = bench_buf[i];
    for (i = 0; i < n; i++) {
        d = (mx - bench_buf[i]) >> 4;
        if (d >= LUTN) d = LUTN - 1;
        bench_out[i] = exp_lut[d];
        sum += (unsigned int)exp_lut[d];
    }
    bench_out[0] += (int)(sum & 0xFFu);
}

static void bench_silu_l(int n) {
    int i, idx;
    for (i = 0; i < n; i++) {
        idx = (bench_buf[i] >> 4) + 512;
        if (idx < 0) idx = 0; else if (idx >= LUTN) idx = LUTN - 1;
        bench_out[i] = silu_lut[idx];
    }
}


/* Attention's own matmuls (Q.K^T and P.V) are activation x activation, so
   the ternary array cannot touch them -- it multiplies ternary weights by
   int8 activations. On this CPU they are a plain MAC loop. Measure it: at
   512 context this is ~58.7M MACs per token and may dominate everything. */

/* ---- Phase-5: the operators the budget never counted -----------------
   The token budget has measured lines for the pager, softmax, SiLU and
   RMSNorm. It had no line at all for the activation quantizer, which runs
   six times a block on vectors up to 3072 wide -- about 315,000 elements
   per token -- and RoPE's 11 ms was an estimate. */

static signed char * const bench_i8 = (signed char *)(DDR_BASE + 0x0E020000u);
static int rope_cos[64], rope_sin[64];
static int rope_ready = 0;

static void bench_quant(int n) {
    int i, v, mx = 0, inv;
    for (i = 0; i < n; i++) {
        v = bench_buf[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    if (mx == 0) mx = 1;
    inv = (int)(((unsigned int)127u << 24) / (unsigned int)mx);
    for (i = 0; i < n; i++)
        bench_i8[i] = (signed char)(((long long)bench_buf[i] * inv) >> 24);
    bench_out[0] = mx;
}

static void rope_init(void) {
    int i;
    if (rope_ready) return;
    for (i = 0; i < 64; i++) {
        rope_cos[i] = 60000 - i * 37;
        rope_sin[i] = 12000 + i * 41;
    }
    rope_ready = 1;
}

static void bench_rope(int n) {
    int h, i, a, b;
    rope_init();
    for (h = 0; h + 128 <= n; h += 128) {
        for (i = 0; i < 64; i++) {
            a = bench_buf[h + i];
            b = bench_buf[h + 64 + i];
            bench_out[h + i] = (int)((((long long)a * rope_cos[i])
                                    - ((long long)b * rope_sin[i])) >> 16);
            bench_out[h + 64 + i] = (int)((((long long)b * rope_cos[i])
                                         + ((long long)a * rope_sin[i])) >> 16);
        }
    }
}

static void bench_sumsq(int n) {
    int i;
    long long s = 0;
    for (i = 0; i < n; i++) s += (long long)bench_buf[i] * bench_buf[i];
    bench_out[0] = (int)(s >> 20);
}

/* ---- The same three, with no 64-bit arithmetic anywhere -------------- */

static void op_quant_p(const int *in, signed char *o8, int n) {
    int i, v, mx = 0, inv, sh = 0;
    for (i = 0; i < n; i++) {
        v = in[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    if (mx == 0) mx = 1;
    while ((mx >> sh) > 32767) sh++;
    v = mx >> sh; if (v == 0) v = 1;
    inv = (127 << 15) / v;
    for (i = 0; i < n; i++)
        o8[i] = (signed char)(((in[i] >> sh) * inv) >> 15);
    bench_out[0] = mx;
}

static void op_rope_p(const int *in, int *out, int n) {
    int h, i, a, b, c, s;
    rope_init();
    for (h = 0; h + 128 <= n; h += 128) {
        for (i = 0; i < 64; i++) {
            a = in[h + i] >> 8;
            b = in[h + 64 + i] >> 8;
            c = rope_cos[i] >> 1;
            s = rope_sin[i] >> 1;
            out[h + i]      = ((a * c - b * s) >> 15) << 8;
            out[h + 64 + i] = ((b * c + a * s) >> 15) << 8;
        }
    }
}

static void op_sumsq_p(const int *in, int n) {
    int i, v, mx = 0, sh = 0;
    unsigned int s = 0u;
    for (i = 0; i < n; i++) {
        v = in[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    while ((mx >> sh) > 2047) sh++;
    for (i = 0; i < n; i++) {
        v = in[i] >> sh;
        s += (unsigned int)(v * v);
    }
    bench_out[0] = (int)(s >> 4);
}

static void bench_quant32(int n) { op_quant_p(bench_buf, bench_i8, n); }
static void bench_rope32(int n)  { op_rope_p(bench_buf, bench_out, n); }
static void bench_sumsq32(int n) { op_sumsq_p(bench_buf, n); }

/* ---- The same operators, on DDR-resident vectors ---------------------
   Everything above runs in local memory: single cycle, no cache, the
   fastest memory this CPU will ever address. The block executor cannot
   use it. LMB is 64 KB, the firmware already holds 56 KB, and one block's
   working set -- residual, normed copy, Q, K, V, attention output, gate
   and up -- is about 56 KB. All of it lives in DDR.

   HOT reuses one buffer; COLD walks a 256 KB region. With a working cache
   those two must differ. Measured, they did not. */

#define DDRB_BASE   (DDR_BASE + 0x0C000000u)  /* 192 MB in, clear of weights */
#define DDRB_STRIDE 0x4000u                   /* 16 KB, one D-cache worth    */
#define DDRB_SLOTS  16u                       /* 256 KB total, 16x the cache */
#define DDRB_OUT    0x00100000u
#define DDRB_I8     0x00200000u

static unsigned int ddrb_rep = 0u;
static int ddrb_ready = 0;

static void ddrb_init(void) {
    unsigned int i;
    if (ddrb_ready) return;
    for (i = 0; i < DDRB_SLOTS * DDRB_STRIDE; i += 4u)
        IO32(DDRB_BASE + i) = (unsigned int)(i * 2654435761u) & 0x3FFFu;
    ddrb_ready = 1;
}

static unsigned int ddrb_slot(int cold) {
    unsigned int s = cold ? ((ddrb_rep % DDRB_SLOTS) * DDRB_STRIDE) : 0u;
    ddrb_rep++;
    return s;
}

static void bench_quant_ddr(int n, int cold) {
    unsigned int s = ddrb_slot(cold);
    ddrb_init();
    op_quant_p((const int *)(DDRB_BASE + s),
               (signed char *)(DDRB_BASE + DDRB_I8 + s), n);
}

static void bench_rope_ddr(int n, int cold) {
    unsigned int s = ddrb_slot(cold);
    ddrb_init();
    op_rope_p((const int *)(DDRB_BASE + s),
              (int *)(DDRB_BASE + DDRB_OUT + s), n);
}

static void bench_sumsq_ddr(int n, int cold) {
    unsigned int s = ddrb_slot(cold);
    ddrb_init();
    op_sumsq_p((const int *)(DDRB_BASE + s), n);
}

/* ---- The data cache, which has never been switched on ----------------
   create_bd_ddr.tcl gives this MicroBlaze 16 KB of D-cache. main() has
   never executed the msrset that enables it, so every DDR access this
   project has made went to the MIG uncached -- the CPU pager's 48 ms per
   page, and every operator above at roughly 4.5x its local-memory cost.

   The benchmark said so before the source did: DDR hot and DDR cold came
   back within 1% on all three operators. One 4 KB buffer reused and a
   256 KB region walked cannot cost the same through a cache.

   Toggleable rather than always-on. Switching it on makes the flush in
   cmd_pagedma load-bearing for the first time -- until now it has been
   flushing a cache that was not there -- so the ternary and int8
   verifications have to be re-run with it enabled before anything here
   is believed. An A/B inside one firmware build settles the size of the
   effect without a second variable. */

static int dcache_on = 0;

static void dcache_invalidate_all(void) {
    unsigned long i, zero = 0;
    for (i = 0; i < 16384u; i += 32u)
        __asm__ __volatile__ ("wdc %0, %1" :: "r"(DDR_BASE + i), "r"(zero));
    __asm__ __volatile__ ("mbar 1");
}

static void cmd_cache(const char *p) {
    p = skip_ws(p);
    if (*p == '1') {
        if (!dcache_on) {
            dcache_invalidate_all();
            __asm__ __volatile__ ("msrset r0, 0x80" ::: "memory");
            dcache_on = 1;
        }
    } else if (*p == '0') {
        if (dcache_on) {
            __asm__ __volatile__ ("msrclr r0, 0x80" ::: "memory");
            dcache_on = 0;
        }
    }
    uart_puts(dcache_on ? "OK CACHE 1\n" : "OK CACHE 0\n");
}

static void bench_mac(int n) {
    int i;
    int acc = 0;
    for (i = 0; i < n; i++) acc += bench_buf[i] * bench_out[i];
    bench_out[0] = acc;
}


/* ---- Phase-5: attention on the ternary array ----
   AMAC computes Q.K^T for 64 keys at once. The bit-sliced K must already be
   in the weight BRAM (LOADW or ETHLOAD) and Q must be in act_ram, each value
   written eight times -- see SLOAD8. CTRL bit3 puts the feeder in int8 mode,
   where it expands one bit-slice per sub-cycle into the array's 2-bit codes
   and shifts the activation. No multiplier and no DSP anywhere in that path. */

static void cmd_sload8(void) {
    unsigned long k; int b;
    IO32(STREAM_BASE + S_CTRL) = 0x4u;                  /* act ptr reset */
    for (k = 0; k < 128u; k++)
        for (b = 0; b < 8; b++)
            IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)activations[k];
    uart_puts("OK SL8\n");
}

static void cmd_amac(void) {
    int c;
    long v;
    unsigned long checksum = 0;
    IO32(STREAM_BASE + S_CTRL) = 0x9u;                  /* START | INT8 */
    while (!(IO32(STREAM_BASE + S_STATUS) & 0x2u)) { }
    IO32(STREAM_BASE + S_CTRL) = 0x2u;                  /* clear done */
    uart_puts("ACYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nAOUT");
    for (c = 0; c < 64; c++) {
        IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
        v = (long)(int)IO32(STREAM_BASE + S_RDATA);
        checksum += (unsigned long)v * (unsigned long)(c + 1);
        if (c < 8) { uart_puts(" "); uart_putdec(v); }
    }
    uart_puts("\nACHK "); uart_puthex(checksum); uart_puts("\nOK AM\n");
}

static void cmd_bench(const char *p) {
    unsigned long op = parse_u(&p), reps = parse_u(&p), n = parse_u(&p), r;
    if (n == 0u || n > (unsigned long)BN) n = 1024u;
    if (reps == 0u) reps = 100u;
    for (r = 0; r < n; r++)
        bench_buf[r] = (int)((unsigned int)(r * 2654435761u) & 0x3FFFu) - 8192;
    build_luts();
    uart_puts("MARK BENCH_START\n");
    for (r = 0; r < reps; r++) {
        if      (op == 0u) bench_copy((int)n);
        else if (op == 1u) bench_rmsnorm((int)n);
        else if (op == 2u) bench_softmax((int)n);
        else if (op == 3u) bench_silu((int)n);
        else if (op == 4u) bench_softmax_r((int)n);
        else if (op == 5u) bench_softmax_d((int)n);
        else if (op == 6u) bench_softmax_l((int)n);
        else if (op == 7u) bench_silu_l((int)n);
        else if (op == 9u)  bench_quant((int)n);
        else if (op == 10u) bench_rope((int)n);
        else if (op == 11u) bench_sumsq((int)n);
        else if (op == 12u) bench_quant32((int)n);
        else if (op == 13u) bench_rope32((int)n);
        else if (op == 14u) bench_sumsq32((int)n);
        else if (op == 15u) bench_quant_ddr((int)n, 0);
        else if (op == 16u) bench_quant_ddr((int)n, 1);
        else if (op == 17u) bench_rope_ddr((int)n, 0);
        else if (op == 18u) bench_rope_ddr((int)n, 1);
        else if (op == 19u) bench_sumsq_ddr((int)n, 0);
        else if (op == 20u) bench_sumsq_ddr((int)n, 1);
        else               bench_mac((int)n);
    }
    uart_puts("MARK BENCH_END\nOK B ");
    uart_puthex((unsigned int)bench_out[0]); uart_puts("\n");
}

static void cmd_ethload(const char *p) {
    unsigned long off = parse_u(&p), count = parse_u(&p), chunk = parse_u(&p);
    unsigned long got = 0, sum = 0, spin = 0, i, seq, len, dst;
    unsigned int buf = 0, rsr = 0, w;
    if (chunk == 0u) chunk = 1024u;
    eth_set_mac();
    uart_puts("MARK ETHLOAD_START\n");
    while (got < count) {
        if (IO32(ETH_RSR0) & RSR_RECV)      { buf = ETH_RXBUF0; rsr = ETH_RSR0; }
        else if (IO32(ETH_RSR1) & RSR_RECV) { buf = ETH_RXBUF1; rsr = ETH_RSR1; }
        else { if (++spin > 2000000u) break; continue; }  /* idle timeout: a lost
           frame must fail fast and be retried, not hang the transfer */
        spin = 0;
        if (eth_hdr_type(buf) == 0x88B5u) {
            seq = eth_seq(buf);
            len = eth_len(buf);
            if (len > chunk) len = chunk;
            dst = off + seq * chunk;
            for (i = 0; i < len; i += 4u) {
                w = IO32(buf + 20u + i);
                IO32(DDR_BASE + dst + i) = w;
                /* Weighted by word index. A plain byte sum is
                   order-independent and cannot see frames landing at the
                   wrong offset -- it matched perfectly on scrambled memory. */
                sum += w * (((dst + i) >> 2u) + 1u);
            }
            got++;
        }
        IO32(rsr) = 0u;
    }
    uart_puts("MARK ETHLOAD_END\n");
    uart_puts("OK E "); uart_puthex(sum);
    uart_puts(" n ");   uart_putdec((long)got); uart_puts("\n");
}

static void cmd_ethrx(const char *p) {
    unsigned long budget = parse_u(&p), spin = 0, seen = 0;
    unsigned int buf = 0, rsr = 0, i;
    if (budget == 0u) budget = 20000000u;
    eth_set_mac();
    uart_puts("ETHRX waiting\n");
    while (spin++ < budget) {
        if (IO32(ETH_RSR0) & RSR_RECV)      { buf = ETH_RXBUF0; rsr = ETH_RSR0; }
        else if (IO32(ETH_RSR1) & RSR_RECV) { buf = ETH_RXBUF1; rsr = ETH_RSR1; }
        else continue;
        seen++;
        uart_puts("ETHRX FRAME type "); uart_puthex(eth_hdr_type(buf));
        uart_puts(" seq ");   uart_putdec((long)eth_be32(buf, 14u));
        uart_puts(" dst ");
        for (i = 0; i < 6u; i++)
            uart_puthex((IO32(buf + (i & ~3u)) >> (8u * (i & 3u))) & 0xFFu);
        uart_puts(" p0 ");    uart_puthex(IO32(buf + 20u));
        uart_puts("\n");
        IO32(rsr) = 0u;                      /* release the buffer */
        break;
    }
    if (!seen) uart_puts("ETHRX none\n");
    else       uart_puts("OK RX\n");
}


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
/* Thirty-two. VSLOT still takes its index modulo this, so every host
   command ever written against slots 0..15 addresses the same memory it
   always did; the driver uses 16..29 for the intermediates the host used
   to hold on its side of the wire. */
#define VS_SLOTS  32u
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
    /* n is a BYTE count here, so the bound is the slot size, not the
       element cap -- 3072 int32 is 12288 bytes and was being refused. */
    if (n > VS_STRIDE) { uart_puts("ERR range\n"); return; }
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

/* What nq_core computed, where a caller can reach it. The host used to
   read these off a UART line; the block driver cannot, because by then
   there is no round trip left to read them from. */

/* Results of the last *_core call, for callers that have no UART to read
   a report from. core_ok is cleared by the caller and set only where a
   core runs to completion, so every early return -- including the range
   checks, which are untouched -- reads as failure. */
static int core_ok;
static unsigned long core_chk, core_n, core_p;

/* Stage 5's block-float helpers, declared early because QKN needs them
   and QKN is two stages older. */
static void sc_mul(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo);
static void sc_div(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo);
static void sc_sqrt(unsigned int m, int e, unsigned int *mo, int *eo);

/* What qkn_core needs and cannot parse for itself, and what it returns
   beyond the int8. qkn_norm picks which of the two operators this call
   is: 1 divides by the deferred root-mean-square and the input's own
   scale cancels, 0 does not and it does not. */
static unsigned int qkn_gm = 1u, qkn_am = 1u;
static int          qkn_ge = 0,  qkn_ae = 0;
static int          qkn_norm = 1;
static unsigned int qkn_sm[16];
static int          qkn_se[16];

/* ---- Stage 16 slots and forward declarations -------------------------
   Sixteen scratch slots were enough while the host held every
   intermediate. The block driver holds them all at once: q, k and v
   int8, their scales, the cache's scale record, the dot products, the
   probabilities and the numerator, all live together. */
#define S_CS   16u   /* cos and sin, 64 + 64, from the host once a token */
#define S_Q8   17u   /* q int8, 16 heads x 128                           */
#define S_K8   18u   /* k int8, 8 heads x 128                            */
#define S_V8   19u   /* v int8, 8 heads x 128                            */
#define S_QS   20u   /* per-head q scale, (mantissa, exponent) pairs     */
#define S_KVS  21u   /* the cache's record: km, ke, vm, ve per kv head   */
#define S_DOT  22u   /* Q.K^T, one int per key; QKN's scalars before it  */
#define S_PR   23u   /* probabilities, int8                              */
#define S_SO   24u   /* wmax, vemax, sume, npos                          */
#define S_NUM  25u   /* P.V numerator, 128 ints                          */
#define S_GN   26u   /* a gain copied out of the DDR record              */
#define S_ONE  27u   /* unit gain, for v                                 */
#define S_ID   28u   /* identity rotation, for v                         */
#define S_QH   29u   /* one query head, where qk_core expects it         */

static void attn_init(void);
static void qkn_run(unsigned long blk, unsigned long gi, unsigned long src,
                    unsigned long dst, unsigned long nh, int norm,
                    unsigned int am, int ae);
static int  attn_heads(unsigned long blk, unsigned long pos);

/* The position this token is being written at. Sticky, set by POS. */
static unsigned long blk_pos = 0;
static int nq_mx, nq_xs, nq_amx;
static unsigned int nq_ss;

/* Returns 0 if the input does not fit 16 bits, having set nq_amx so the
   caller can say by how much. Body identical to what cmd_nq did. */
static int nq_core(const int *x, const int *g, signed char *o8,
                   unsigned long n) {
    int *t = (int *)VS_TMP;
    int v, u, w, q, mx = 0, amx = 0, xs = 0;
    unsigned int ss;
    unsigned long long ss64 = 0ull;
    long long inv, qq;
    unsigned long i;

    for (i = 0; i < n; i++) {
        v = x[i];
        if (v < 0) v = -v;
        if (v > amx) amx = v;
    }
    nq_amx = amx;
    if (amx > 32767) return 0;
    while ((amx >> xs) > 2047) xs++;      /* n squares must fit 32 bits */

    for (i = 0; i < n; i++) {
        v = x[i];
        u = v >> xs;
        ss64 += (unsigned long long)(unsigned int)(u * u);
        w = v * g[i];                     /* full product, nothing discarded */
        t[i] = w;
        if (w < 0) w = -w;
        if (w > mx) mx = w;
    }
    if (mx == 0) mx = 1;

    /* The 2047 threshold above bounds n squares by 2^32 only for n = 1024,
       and two of the four RMSNorms in a block are wider than that. So the
       accumulator is 64-bit and gets renormalized here instead.

       The host computes rms = sqrt(ss * 4^xs / n), and (ss >> 2) with
       (xs + 1) leaves that product unchanged -- so the reported pair stays
       two 32-bit numbers and no parser has to know this happened. */
    while (ss64 >= (1ull << 32)) { ss64 >>= 2; xs++; }
    ss = (unsigned int)ss64;

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

    nq_mx = mx; nq_ss = ss; nq_xs = xs;
    return 1;
}

static void nq_report(void) {
    uart_puts("NQ mx "); uart_putdec((long)nq_mx);
    uart_puts(" ss "); uart_puthex(nq_ss);
    uart_puts(" xs "); uart_putdec((long)nq_xs);
    uart_puts("\nOK NQ\n");
}

static void cmd_nq(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), dst = parse_u(&p),
                  n = parse_u(&p);

    if (n == 0u || n > VS_MAX) { uart_puts("ERR range\n"); return; }
    if (!nq_core((const int *)VSLOT(src), (const int *)VSLOT(gsl),
                 (signed char *)VSLOT(dst), n)) {
        uart_puts("ERR x not 16-bit, max "); uart_putdec((long)nq_amx);
        uart_puts("\n"); return;
    }
    nq_report();
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

/* The activations are a pointer, not a slot index, so the caller can
   start a segment part-way into a vector. cmd_proj passes offset zero
   and behaves exactly as before. */
static void proj_core(const signed char *a, int *o,
                      unsigned long ntile, unsigned long seg) {
    unsigned long k, j;
    unsigned int ct;
    int c, v;

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
}

static void cmd_proj(const char *p) {
    unsigned long asrc = parse_u(&p), dst = parse_u(&p), ntile = parse_u(&p),
                  seg = parse_u(&p), j;
    const int *o;
    unsigned long chk = 0;

    if (ntile == 0u || ntile > 16u) { uart_puts("ERR range\n"); return; }

    proj_core((const signed char *)VSLOT(asrc), (int *)VSLOT(dst),
              ntile, seg);

    o = (const int *)VSLOT(dst);
    for (j = 0; j < ntile * 64u; j++)
        chk += (unsigned long)o[j] * (unsigned long)(j + 1u);
    uart_puts("PCHK "); uart_puthex(chk);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nOK PJ\n");
}


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

   All three shifts round away from zero. An arithmetic shift truncates
   toward negative infinity, and one discarded unit here is 127/32767 =
   0.004 of an output LSB -- the exact magnitude that put five differing
   elements per thousand into stage 1 before the same fix was applied
   there. Twice was enough.

   cos and sin share one slot: cos in [0, hd/2), sin in [hd/2, hd), both
   Q15, sent by the host for the current position. 512 bytes a token beats
   tabling 512 positions at 256 KB, and beats recomputing them with no FPU.

   Per-head scalars land in a slot as [ss, s1, sq, mx] so the host can
   reconstruct the score scale exactly; the board needs them at softmax. */

static int rsh(int v, int s) {
    if (s <= 0) return v;
    return (v >= 0) ? ((v + (1 << (s - 1))) >> s)
                    : -(((-v) + (1 << (s - 1))) >> s);
}

static void qkn_core(unsigned long src, unsigned long gsl,
                     unsigned long cs, unsigned long dst, unsigned long ssl,
                     unsigned long nh, unsigned long hd) {
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
        int v, a, b, amx = 0, s1 = 0, sq = 0, st = 0, tmx = 0, mx = 0, w;
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
            v = rsh(rsh(qh[i], s1), sq);
            ss += (unsigned int)(v * v);
        }
        /* The gain product is normalized by what it actually reaches,
           not by a fixed 15. k_norm's gains span 42x, so a typical one is
           777 in Q15 and a fixed shift divides the accumulator by 42
           before an 8-bit quantizer ever sees it. Third appearance of the
           same shape of bug: a shift sized for a theoretical maximum
           rather than for the data. */
        tmx = 0;
        for (i = 0; i < hd; i++) {
            u[i] = rsh(qh[i], s1) * g[i];             /* 16x16 -> 32 */
            v = u[i]; if (v < 0) v = -v; if (v > tmx) tmx = v;
        }
        st = 0;
        while ((tmx >> st) > 32767) st++;
        for (i = 0; i < hd; i++) u[i] = rsh(u[i], st);

        for (i = 0; i < half; i++) {
            a = u[i];
            b = u[i + half];
            u[i]        = rsh(a * co[i] - b * si[i], 15);
            u[i + half] = rsh(b * co[i] + a * si[i], 15);
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

        /* This head's int8 in true units. See the stage 15 note: one
           unit of o8 is mx * 2^(s1+st) * (gmax/32767) / 127 of the
           unnormalized product, then divided by the deferred rms for q
           and k -- against which the input's own scale cancels -- or
           multiplied by that input scale for v, which is absmax
           quantized and never normalized at all. */
        {
            unsigned int t, r;
            int te, re;
            sc_mul(qkn_gm, qkn_ge, (unsigned int)mx, s1 + st, &t, &te);
            sc_div(t, te, 4161409u, 0, &t, &te);       /* 32767 * 127 */
            if (qkn_norm) {
                sc_div((unsigned int)ss, 2 * (s1 + sq),
                       (unsigned int)hd, 0, &r, &re);
                sc_sqrt(r, re, &r, &re);
                sc_div(t, te, r, re, &t, &te);
            } else {
                sc_mul(t, te, qkn_am, qkn_ae, &t, &te);
            }
            qkn_sm[h] = t;
            qkn_se[h] = te;
        }
    }

    for (i = 0; i < nh * hd; i++)
        chk += (unsigned long)(long)o8[i] * (unsigned long)(i + 1u);
    core_chk = chk; core_ok = 1;
}

static void cmd_qkn(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), cs = parse_u(&p),
                  dst = parse_u(&p), ssl = parse_u(&p),
                  nh = parse_u(&p), hd = parse_u(&p);
    core_ok = 0;
    qkn_core(src, gsl, cs, dst, ssl, nh, hd);
    if (!core_ok) return;
    uart_puts("QCHK "); uart_puthex(core_chk); uart_puts("\nOK QK\n");
}


/* ---- Stage 4: the KV cache -------------------------------------------
   Laid out in the form attention will read it, which is bit-sliced at the
   weight BRAM's own stride. Two facts fix the geometry.

   First, slicing on demand was measured against slicing on append:
   3,584 chunks of 1024 word-gathers per token is about 8.7 s, against
   17 ms for slicing each vector once as it arrives. So nothing is ever
   stored unsliced.

   Second, the weight BRAM is 128 bits wide -- 16384 words of 16 bytes --
   and AMAC reads the low 64 bits of each. Packing the planes at 8-byte
   stride round-trips perfectly through KVR and still cannot be DMA'd into
   the array without an expanding copy, so the stride is 16 with the upper
   half unused. Twice the memory, and every load becomes a straight burst.

   K and V slice along opposite axes, which is the easy thing to get
   wrong. Q.K^T sums over head_dim and yields one number per key, so keys
   are the array's 64 columns and dims are its depth: appending a key sets
   one bit in each of 128*8 words. P.V sums over keys and yields one
   number per dim, so dims are the columns and keys are the depth:
   appending a value writes eight whole words per 64-dim group.

   That transposition also sets the chunk sizes. Bit-serial int8 spends
   eight depth slots per element and the array is 1024 deep, so a pass
   covers 128 depth elements. For K the depth is head_dim = 128, which
   fits exactly once. For V the depth is the key index, so a chunk holds
   128 positions and a 512-token context takes four accumulating passes.

     K   8 chunks of 64 keys, 128 dims x 8 bits x 16 B = 16 KB per chunk
     V   4 position-chunks x 2 dim-chunks, 128 pos x 8 bits x 16 B
   Both come to 128 KB per (block, head) and 29.4 MB overall.

   No zeroing is needed on a fresh chunk: every bit is explicitly set or
   cleared, never OR-ed in. */

#define KV_K    (DDR_BASE + 0x08000000u)      /* 128 MB, 29.4 MB */
#define KV_V    (DDR_BASE + 0x0A000000u)      /* 160 MB, 29.4 MB */
#define KV_S    (DDR_BASE + 0x0C000000u)      /* 192 MB, scales  */
#define KV_NKV  8u
#define KV_HD   128u
#define KV_MAXP 512u
#define KV_CH   16384u                        /* one AMAC load, 1024 x 16 B */

/* K: one 64-key chunk for (blk, head). Depth is head_dim. */
static unsigned int kv_kbase(unsigned long blk, unsigned long h,
                             unsigned long chunk) {
    return KV_K + (((unsigned int)blk * KV_NKV + (unsigned int)h) * 8u
                   + (unsigned int)chunk) * KV_CH;
}

/* V: one (128-position, 64-dim) chunk for (blk, head). Depth is position. */
static unsigned int kv_vbase(unsigned long blk, unsigned long h,
                             unsigned long pch, unsigned long dch) {
    return KV_V + ((((unsigned int)blk * KV_NKV + (unsigned int)h) * 4u
                    + (unsigned int)pch) * 2u + (unsigned int)dch) * KV_CH;
}

/* Four int32 per (blk, head, pos): k mantissa, k exponent, v mantissa,
   v exponent. The host computes them; the board stores and returns them,
   so the scale convention lives in exactly one place. */
static unsigned int kv_sbase(unsigned long blk, unsigned long h,
                             unsigned long pos) {
    return KV_S + ((((unsigned int)blk * KV_NKV + (unsigned int)h)
                    * KV_MAXP + (unsigned int)pos) * 16u);
}

static void kvw_core(unsigned long blk, unsigned long pos,
                     unsigned long ksl, unsigned long vsl, unsigned long scl,
                     unsigned long nkv, unsigned long hd) {
    const signed char *k = (const signed char *)VSLOT(ksl);
    const signed char *v = (const signed char *)VSLOT(vsl);
    const int *sc = (const int *)VSLOT(scl);
    unsigned long h, d, b, dch;
    unsigned int j, c, pch, pj, base, addr, word, bit, kb;

    if (blk >= 28u || pos >= KV_MAXP || nkv > KV_NKV || hd != KV_HD) {
        uart_puts("ERR range\n"); return;
    }
    c   = (unsigned int)(pos >> 6);          /* K chunk: 64 keys   */
    j   = (unsigned int)(pos & 63u);
    pch = (unsigned int)(pos >> 7);          /* V chunk: 128 depth */
    pj  = (unsigned int)(pos & 127u);

    for (h = 0; h < nkv; h++) {
        /* K: one bit per (dim, plane) -- 1024 read-modify-writes. */
        base = kv_kbase(blk, h, c);
        for (d = 0; d < hd; d++) {
            kb = (unsigned int)(unsigned char)k[h * hd + d];
            for (b = 0; b < 8u; b++) {
                addr = base + ((unsigned int)d * 8u + (unsigned int)b) * 16u
                       + (j >> 5) * 4u;
                bit  = 1u << (j & 31u);
                word = IO32(addr);
                IO32(addr) = ((kb >> b) & 1u) ? (word | bit) : (word & ~bit);
            }
        }
        /* V: whole words -- one depth row per position, per dim group. */
        for (dch = 0; dch < 2u; dch++) {
            base = kv_vbase(blk, h, pch, dch);
            for (b = 0; b < 8u; b++) {
                unsigned int lo = 0u, hi = 0u, dd;
                for (dd = 0; dd < 64u; dd++) {
                    kb = (unsigned int)(unsigned char)
                         v[h * hd + dch * 64u + dd];
                    if ((kb >> b) & 1u) {
                        if (dd < 32u) lo |= 1u << dd;
                        else          hi |= 1u << (dd - 32u);
                    }
                }
                addr = base + (pj * 8u + (unsigned int)b) * 16u;
                IO32(addr)      = lo;
                IO32(addr + 4u) = hi;
            }
        }
        addr = kv_sbase(blk, h, pos);
        IO32(addr)       = (unsigned int)sc[h * 4u + 0u];
        IO32(addr + 4u)  = (unsigned int)sc[h * 4u + 1u];
        IO32(addr + 8u)  = (unsigned int)sc[h * 4u + 2u];
        IO32(addr + 12u) = (unsigned int)sc[h * 4u + 3u];
    }
    core_ok = 1;
}

static void cmd_kvw(const char *p) {
    unsigned long blk = parse_u(&p), pos = parse_u(&p), ksl = parse_u(&p),
                  vsl = parse_u(&p), scl = parse_u(&p),
                  nkv = parse_u(&p), hd = parse_u(&p);
    core_ok = 0;
    kvw_core(blk, pos, ksl, vsl, scl, nkv, hd);
    if (core_ok) uart_puts("OK KVW\n");
}

/* Reconstruct one cached vector from the sliced form. A slicing bug would
   otherwise appear as wrong scores twenty operators downstream. */
static void cmd_kvr(const char *p) {
    unsigned long blk = parse_u(&p), pos = parse_u(&p), h = parse_u(&p),
                  dst = parse_u(&p), which = parse_u(&p);
    signed char *o = (signed char *)VSLOT(dst);
    unsigned long d, b;
    unsigned int j, c, base, addr, val, dd, dch, pch, pj;

    if (blk >= 28u || pos >= KV_MAXP || h >= KV_NKV) {
        uart_puts("ERR range\n"); return;
    }
    if (which == 0u) {
        c = (unsigned int)(pos >> 6);
        j = (unsigned int)(pos & 63u);
        base = kv_kbase(blk, h, c);
        for (d = 0; d < KV_HD; d++) {
            val = 0u;
            for (b = 0; b < 8u; b++) {
                addr = base + ((unsigned int)d * 8u + (unsigned int)b) * 16u
                       + (j >> 5) * 4u;
                if ((IO32(addr) >> (j & 31u)) & 1u) val |= 1u << b;
            }
            o[d] = (signed char)(unsigned char)val;
        }
    } else {
        pch = (unsigned int)(pos >> 7);
        pj  = (unsigned int)(pos & 127u);
        for (d = 0; d < KV_HD; d++) {
            dch = (unsigned int)(d >> 6);
            dd  = (unsigned int)(d & 63u);
            base = kv_vbase(blk, h, pch, dch);
            val = 0u;
            for (b = 0; b < 8u; b++) {
                addr = base + (pj * 8u + (unsigned int)b) * 16u
                       + ((dd < 32u) ? 0u : 4u);
                if ((IO32(addr) >> (dd & 31u)) & 1u) val |= 1u << b;
            }
            o[d] = (signed char)(unsigned char)val;
        }
    }
    addr = kv_sbase(blk, h, pos);
    uart_puts("KVS ");
    uart_putdec((long)(int)IO32(addr));      uart_puts(" ");
    uart_putdec((long)(int)IO32(addr + 4u)); uart_puts(" ");
    uart_putdec((long)(int)IO32(addr + 8u)); uart_puts(" ");
    uart_putdec((long)(int)IO32(addr + 12u));
    uart_puts("\nOK KVR\n");
}


/* ---- Block-float scalars ---------------------------------------------
   Every stage so far has exploited scale invariance: RMSNorm's 1/rms, any
   global factor in a gain, and the rotation's length preservation all
   cancel inside an absmax quantizer, so no real magnitude ever had to be
   represented. exp is where that stops. Attention scores need a true
   magnitude, and the K scale varies per position, so it cannot be pulled
   out of the vector the way the others could.

   With no floating-point unit, a scale is m * 2^e with m normalized into
   [2^30, 2^31). Scales here are positive, so m is unsigned and keeps all
   31 bits of significance, and the product of two normalized mantissas is
   at most 2^62 -- exact in a 64-bit intermediate.

   These are scalar operations, once per head rather than once per
   element, so the 64-bit arithmetic that cost RoPE a factor of six is
   free here. Same argument that gave stage 1 an exact reciprocal: the
   benchmark says where the width is affordable.

   Every routine normalizes its own inputs. They did not at first, and the
   result was a divide wrong by a whole factor of two rather than by
   rounding. A function that quietly loses precision on input it never
   documented a requirement for is a trap, so these are total. */

static void sc_norm(unsigned int *m, int *e) {
    if (*m == 0u) { *e = 0; return; }
    while (*m < (1u << 30)) { *m <<= 1; (*e)--; }
    while (*m >= (1u << 31)) { *m >>= 1; (*e)++; }
}

static void sc_mul(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo) {
    unsigned long long p;
    int sh;
    sc_norm(&ma, &ea);
    sc_norm(&mb, &eb);
    if (ma == 0u || mb == 0u) { *mo = 0u; *eo = 0; return; }
    /* Both in [2^30, 2^31), so p is in [2^60, 2^62). A fixed shift of 31
       would land below 2^30 half the time and normalization would then
       shift zeros back in, so pick the shift from the range. */
    p  = (unsigned long long)ma * (unsigned long long)mb;
    sh = (p < ((unsigned long long)1 << 61)) ? 30 : 31;
    *mo = (unsigned int)((p + ((unsigned long long)1 << (sh - 1))) >> sh);
    *eo = ea + eb + sh;
    sc_norm(mo, eo);
}

static void sc_div(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo) {
    unsigned long long n;
    sc_norm(&ma, &ea);
    sc_norm(&mb, &eb);
    if (ma == 0u || mb == 0u) { *mo = 0u; *eo = 0; return; }
    /* Normalized inputs put the ratio in (1/2, 2), so the quotient of
       (ma << 31) by mb is between 2^30 and 2^32 and stays in 32 bits. */
    n = (unsigned long long)ma << 31;
    *mo = (unsigned int)(n / (unsigned long long)mb);
    *eo = ea - eb - 31;
    sc_norm(mo, eo);
}

/* Bit-by-bit restoring square root: no division, no table, exact for
   every input. A Newton iteration would want a seed that needs a table. */
static unsigned int isqrt64(unsigned long long v) {
    unsigned long long r = 0u, bit = (unsigned long long)1 << 62;
    while (bit > v) bit >>= 2;
    while (bit != 0u) {
        if (v >= r + bit) { v -= r + bit; r = (r >> 1) + bit; }
        else r >>= 1;
        bit >>= 2;
    }
    return (unsigned int)r;
}

/* sqrt(m * 2^e). The exponent is made even first, then the mantissa is
   shifted up 32 bits so the root keeps its full width. */
static void sc_sqrt(unsigned int m, int e, unsigned int *mo, int *eo) {
    sc_norm(&m, &e);
    if (m == 0u) { *mo = 0u; *eo = 0; return; }
    if (e & 1) { m >>= 1; e++; }
    *mo = isqrt64((unsigned long long)m << 32);
    *eo = (e - 32) / 2;
    sc_norm(mo, eo);
}

/* Value as Q16.16, saturating. Used to index the exp table. */
static int sc_q16(unsigned int m, int e) {
    int s = -(e + 16);
    if (s >= 32) return 0;
    if (s <= 0) {
        if (-s >= 2 || m > (0x7FFFFFFFu >> (-s))) return 0x7FFFFFFF;
        return (int)(m << (-s));
    }
    return (int)(m >> s);
}

/* Exercise the above against the host, before anything depends on it. A
   scale quietly wrong by a factor of two makes attention that looks
   plausible and is not. */
static void cmd_sct(const char *p) {
    unsigned long op = parse_u(&p);
    unsigned int ma = (unsigned int)parse_u(&p);
    unsigned long ea = parse_u(&p);
    unsigned int mb = (unsigned int)parse_u(&p);
    unsigned long eb = parse_u(&p);
    unsigned int mo = 0u;
    int eo = 0, xa = (int)(long)ea - 512, xb = (int)(long)eb - 512;

    if      (op == 0u) { mo = ma; eo = xa; sc_norm(&mo, &eo); }
    else if (op == 1u) sc_mul(ma, xa, mb, xb, &mo, &eo);
    else if (op == 2u) sc_div(ma, xa, mb, xb, &mo, &eo);
    else if (op == 3u) sc_sqrt(ma, xa, &mo, &eo);
    else if (op == 4u) {
        unsigned long long v = ((unsigned long long)ma << 32)
                             | (unsigned long long)mb;
        mo = isqrt64(v); eo = 0;
    }
    else { mo = (unsigned int)sc_q16(ma, xa); eo = 0; }

    uart_puts("SC "); uart_puthex(mo);
    uart_puts(" "); uart_putdec((long)eo);
    uart_puts("\nOK SCT\n");
}


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

static void qk_core(unsigned long blk, unsigned long kvh,
                    unsigned long pos, unsigned long qsl, unsigned long dsl) {
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
    core_chk = chk; core_n = npos; core_ok = 1;
}

static void cmd_qk(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  qsl = parse_u(&p), dsl = parse_u(&p);
    core_ok = 0;
    qk_core(blk, kvh, pos, qsl, dsl);
    if (!core_ok) return;
    uart_puts("QKCHK "); uart_puthex(core_chk);
    uart_puts(" N "); uart_putdec((long)core_n);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nOK QKD\n");
}


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

static void sm_core(unsigned long blk, unsigned long kvh,
                    unsigned long pos, unsigned long dsl, unsigned long qmu,
                    unsigned long qeb, unsigned long psl, unsigned long ssl) {
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
        /* sh is a RIGHT shift: large sh means the multiplier vanishes and
           the score difference is negligible, so idx = 0 and exp = 1. The
           table end is what a large LEFT shift reaches. Inverting these
           two sent every probability to exp(-63.9) and every key to zero. */
        if (sh >= 31)            idx = 0;
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

    core_ok = 1;
}

static void cmd_sm(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  dsl = parse_u(&p), qmu = parse_u(&p), qeb = parse_u(&p),
                  psl = parse_u(&p), ssl = parse_u(&p);
    const int *so;
    core_ok = 0;
    sm_core(blk, kvh, pos, dsl, qmu, qeb, psl, ssl);
    if (!core_ok) return;
    so = (const int *)VSLOT(ssl);
    uart_puts("SM wmax "); uart_puthex((unsigned long)so[0]);
    uart_puts(" ve "); uart_putdec((long)so[1]);
    uart_puts(" sume "); uart_puthex((unsigned long)so[2]);
    uart_puts(" n "); uart_putdec((long)so[3]);
    uart_puts("\nOK SM\n");
}


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

static void pv_core(unsigned long blk, unsigned long kvh,
                    unsigned long pos, unsigned long psl, unsigned long osl) {
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
    core_chk = chk; core_n = npos; core_p = npch; core_ok = 1;
}

static void cmd_pv(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  psl = parse_u(&p), osl = parse_u(&p);
    core_ok = 0;
    pv_core(blk, kvh, pos, psl, osl);
    if (!core_ok) return;
    uart_puts("PVCHK "); uart_puthex(core_chk);
    uart_puts(" N "); uart_putdec((long)core_n);
    uart_puts(" P "); uart_putdec((long)core_p);
    uart_puts("\nOK PV\n");
}


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

/* mlp_core reports through globals rather than the UART, because the
   block driver calls it twenty-eight times a token and twenty-eight
   thirty-character lines is 73 ms of a 1.5-second token spent telling
   nobody what the shifts were. cmd_mlp still prints them, so every host
   parser written against MLP is unchanged. */
static int mlp_sa, mlp_su, mlp_ss, mlp_sm;

static void mlp_core(const int *g, const int *up, int *o,
                     unsigned long gmu, long geb, unsigned long n) {
    unsigned long i;
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
    sc_mul((unsigned int)gmu, (int)(geb - 512), 1u << 30, -30, &Gm, &Ge);
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

    mlp_sa = sa; mlp_su = su; mlp_ss = ss; mlp_sm = sm;
}

static void cmd_mlp(const char *p) {
    unsigned long gsl = parse_u(&p), usl = parse_u(&p), osl = parse_u(&p),
                  gmu = parse_u(&p), geb = parse_u(&p), n = parse_u(&p);
    mlp_core((const int *)VSLOT(gsl), (const int *)VSLOT(usl),
             (int *)VSLOT(osl), gmu, (long)geb, n);
    uart_puts("MLP sa "); uart_putdec((long)mlp_sa);
    uart_puts(" su "); uart_putdec((long)mlp_su);
    uart_puts(" ss "); uart_putdec((long)mlp_ss);
    uart_puts(" sm "); uart_putdec((long)mlp_sm);
    uart_puts("\nOK MLP\n");
}


/* ---- Stage 10a: the block's constants, in DDR ------------------------
   The gains are constants and the host has been re-uploading them on
   every nq call, on every block, on every token -- 28 KB a block to
   repeat what the previous token already said. build_ddr_meta.py puts
   them at 0x07000000, in the gap between the weight image ending at
   110.1 MB and the KV cache starting at 128 MB: 28 records of 32 KB.

   Reading them here rather than receiving them is worth more than the
   bytes. It is the difference between the host driving the block and
   the board owning it. */

#define META_BASE    (DDR_BASE + 0x07000000u)
#define META_STRIDE  0x8000u
#define META_SCALES  0x7400u          /* 7 x (mantissa u32, exp i32) */
#define META_GMAX    0x7440u          /* 6 x (mantissa u32, exp i32) */

/* Byte offset and length of each gain within a record. This is
   build_ddr_meta.py's GAINS order and nothing may reorder it: the two
   tables are one layout written twice, in different languages, and
   MREAD exists to prove they still agree. */
static const unsigned int gain_off[6] =
    { 0x0000u, 0x1000u, 0x2000u, 0x2200u, 0x2400u, 0x4400u };
static const unsigned int gain_len[6] =
    { 1024u, 1024u, 128u, 128u, 2048u, 3072u };

static unsigned int meta_rec(unsigned long blk) {
    return META_BASE + (unsigned int)blk * META_STRIDE;
}

/* A block-float pair out of a record. A helper because reading two words
   at a computed offset is precisely where an off-by-one buys a silently
   wrong scale instead of a fault. */
static void meta_bf(unsigned long blk, unsigned int base, unsigned long i,
                    unsigned int *m, int *e) {
    unsigned int a = meta_rec(blk) + base + (unsigned int)i * 8u;
    *m = IO32(a);
    *e = (int)IO32(a + 4u);
}

/* MREAD <blk> <gidx> <dst> -- one gain into a slot, plus the scalars.

   Deliberately does no arithmetic. If this disagrees with meta.bin the
   fault is in the layout, and mixing a computation into the test would
   only give it a second place to hide. */
static void cmd_mread(const char *p) {
    unsigned long blk = parse_u(&p), gi = parse_u(&p), dst = parse_u(&p), i;
    const int *g;
    int *o;
    unsigned int m;
    int e;

    if (blk >= 28u || gi >= 6u) { uart_puts("ERR range\n"); return; }
    g = (const int *)(meta_rec(blk) + gain_off[gi]);
    o = (int *)VSLOT(dst);
    for (i = 0; i < gain_len[gi]; i++) o[i] = g[i];

    uart_puts("MREAD n "); uart_putdec((long)gain_len[gi]);
    meta_bf(blk, META_GMAX, gi, &m, &e);
    uart_puts(" gmax "); uart_puthex(m);
    uart_puts(" "); uart_putdec((long)e);
    meta_bf(blk, META_SCALES, gi, &m, &e);
    uart_puts(" wscale "); uart_puthex(m);
    uart_puts(" "); uart_putdec((long)e);
    uart_puts("\nOK MR\n");
}

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

    /* Decide the shift against what rsh will actually produce, not
       against a truncating shift. The first version tested (amx >> sh)
       and applied rsh, and those disagree exactly at the boundary:
       65535 >> 1 is 32767 and fits, while rsh(65535, 1) is 32768 and
       does not. Computing a bound one way and applying it another is
       the third truncation-versus-rounding mismatch in this codebase. */
    while (sh < 31 && rsh(amx, sh) > 32767) sh++;
    if (sh) for (i = 0; i < n; i++) x[i] = rsh(x[i], sh);

    if (!nq_core(x, (const int *)(meta_rec(blk) + gain_off[gi]),
                 (signed char *)VSLOT(dst), n)) {
        uart_puts("ERR x not 16-bit after shift, max ");
        uart_putdec((long)nq_amx); uart_puts("\n"); return;
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

/* ---- Stage 12: OPB, the board times its own operators ----------------

   The rule this exists to enforce: a number in the token budget must
   come from the code that runs in the token, not from a micro-loop
   written to resemble it. Every operator below is reached by the same
   name and the same argument string the host would send normally.

   Handlers that transform their input in place -- NQD's auto-range
   shift -- see different data on the second repetition. That is
   acceptable here and only here: these loops are fixed-trip with no
   data-dependent branch beyond a max comparison, so cycles per element
   do not move with the values. An operator that later gains a
   data-dependent branch stops being measurable this way, and the honest
   thing then is to say so rather than keep quoting the slope.        */
static void cmd_opb(const char *p) {
    unsigned long reps = parse_u(&p), r;
    const char *c = skip_ws(p);

    if (reps == 0u || reps > 100000u) { uart_puts("ERR reps\n"); return; }

    uart_puts("MARK OPB_START\n");
    for (r = 0; r <= reps; r++) {
        uart_mute = (r < reps);              /* the last pass speaks */
        if      (starts(c, "NQD "))  cmd_nqd(c + 4);
        else if (starts(c, "NQF "))  cmd_nqf(c + 4);
        else if (starts(c, "NQ "))   cmd_nq(c + 3);
        else if (starts(c, "QKN "))  cmd_qkn(c + 4);
        else if (starts(c, "SM "))   cmd_sm(c + 3);
        else if (starts(c, "PV "))   cmd_pv(c + 3);
        else if (starts(c, "MLP "))  cmd_mlp(c + 4);
        else if (starts(c, "SCT "))  cmd_sct(c + 4);
        else if (starts(c, "QKD "))  cmd_qk(c + 4);
        else if (starts(c, "KVW "))  cmd_kvw(c + 4);
        else if (starts(c, "PJO "))  cmd_projo(c + 4);
        else if (starts(c, "PAGEDMA ")) cmd_pagedma(c + 8);
        else { uart_mute = 0; uart_puts("ERR opb cmd\n"); return; }

        /* The bracket closes before the one call allowed to print, so
           the operator's own report never lands inside the timing. */
        if (r + 1u == reps) { uart_mute = 0; uart_puts("MARK OPB_END\n"); }
    }
    uart_mute = 0;
    uart_puts("OK OPB\n");
}

/* ---- Stage 13: the block driver --------------------------------------

   Page slots within a block, in the order build_ddr_image.py wrote them
   and the order blk_proj must request them: q takes two (2048 outputs),
   k and v one each, o two (2048 inputs), gate and up three each (3072
   outputs), down three (3072 inputs). Fifteen, and the image's rule is
   page = blk*15 + slot.                                              */
#define P_Q    0u
#define P_K    2u
#define P_V    3u
#define P_O    4u
#define P_G    6u
#define P_U    9u
#define P_D   12u

/* Scratch slots. Sixteen exist at 16 KB each; these are the seven the
   block needs, named rather than numbered because a projection writing
   into the slot still holding the residual stream would be silent. */
#define S_X    0u          /* residual stream, int32, 1024             */
#define S_X1   1u          /* after the attention residual             */
#define S_A8   2u          /* int8 activations, up to 3072             */
#define S_P0   3u          /* projection output, up to 3072            */
#define S_P1   4u          /* up_proj, so gate and up coexist          */
#define S_M    5u          /* the MLP product, 3072                    */
#define S_ATT  6u          /* attention output, 2048                   */

/* The residual stream's scale. A global because it is the one piece of
   state that survives from block to block, and threading it through
   every signature would only give it more places to be dropped. */
static unsigned int blk_xm = 1u;
static int          blk_xe = 0;

/* One 256 KB page, DDR to weight BRAM. cmd_pagedma with the parsing,
   the repeat count and the reporting taken out -- and, as of the
   measurement that found it, without the 8192-instruction cache flush
   that used to be 312 ms of every token. */
static int page_load(unsigned long page) {
    unsigned long spin = 0;
    IO32(CDMA_CR) = 0x04u;
    while (IO32(CDMA_CR) & 0x04u)
        if (++spin > 1000000u) { uart_puts("ERR page reset\n"); return 0; }
    IO32(CDMA_SA)  = DDR_BASE + (unsigned int)page * PAGE_BYTES;
    IO32(CDMA_DA)  = WEIGHT_BRAM;
    IO32(CDMA_BTT) = PAGE_BYTES;
    spin = 0;
    while (!(IO32(CDMA_SR) & 0x02u))
        if (++spin > 40000000u) { uart_puts("ERR page dma\n"); return 0; }
    return 1;
}

/* A whole projection: every output block against every input slice.
   Input slices accumulate (seg != 0 on all but the first), output blocks
   land in their own thousand of the destination. proj_core takes a
   pointer rather than a slot index precisely so this can offset both
   ends without copying. */
static int blk_proj(unsigned long blk, unsigned long slot0,
                    unsigned long nout, unsigned long nin,
                    const signed char *a, int *o) {
    unsigned long nc = nout >> 10, ns = nin >> 10, c, s;
    for (c = 0; c < nc; c++)
        for (s = 0; s < ns; s++) {
            if (!page_load(blk * 15u + slot0 + c * ns + s)) return 0;
            proj_core(a + (s << 10), o + (c << 10), 16u, s != 0u);
        }
    return 1;
}

/* RMSNorm and quantize, either path, with the auto-range shift in front
   of both. cmd_nqf does not shift -- stage 11 fed it vectors already
   inside 16 bits and verified against that precondition -- but a
   projection accumulator reaches 1024*127, and the fabric's pass 2 takes
   x as sixteen signed bits. Shifting first is what makes the two paths
   interchangeable on real data rather than only on the test vectors. */
static int nq_run(int fab, const int *x, unsigned long blk,
                  unsigned long gi, signed char *o8, unsigned long n) {
    int *w = (int *)VS_TMP;
    unsigned long i;
    int v, amx = 0, sh = 0;

    for (i = 0; i < n; i++) { v = x[i]; if (v < 0) v = -v;
                              if (v > amx) amx = v; }
    while (sh < 31 && rsh(amx, sh) > 32767) sh++;

    /* The shift goes to scratch, not in place. cmd_nqd applies it to the
       caller's vector and says so -- "safe only because every vector this
       runs on is scratch the host does not read afterwards" -- and the
       block driver is the first caller for which that is false. x here is
       the residual stream, which is normalized and then added to fifteen
       operators later; shifting it in place divided it by 2^14 behind the
       add's back and cost a whole block. */
    for (i = 0; i < n; i++) w[i] = rsh(x[i], sh);

    if (fab) {
        cdma_move((unsigned int)(unsigned long)w, NORM_X,
                  (unsigned int)n * 4u);
        cdma_move(meta_rec(blk) + gain_off[gi], NORM_G,
                  (unsigned int)n * 4u);
        IO32(NORM_CTRL) = (unsigned int)n | 0x80000000u;
        i = 0;
        while (!(IO32(NORM_STAT) & 0x2u))
            if (++i > 20000000u) { uart_puts("ERR nqf hang\n"); return 0; }
        cdma_move(NORM_O8, (unsigned int)(unsigned long)o8, (unsigned int)n);
        nq_mx = (int)IO32(NORM_MX);
        nq_ss = IO32(NORM_SS);
        nq_xs = (int)IO32(NORM_XS);
        return 1;
    }
    if (!nq_core(w, (const int *)(meta_rec(blk) + gain_off[gi]), o8, n)) {
        uart_puts("ERR nq range "); uart_putdec((long)nq_amx);
        uart_puts("\n"); return 0;
    }
    return 1;
}

/* The scale of what nq just wrote:  gmax * mx / (32768 * 127 * rms),
   rms = sqrt(ss * 4^xs / n).

   This is absolute, and that is the whole reason the block driver can
   forget its input's scale at every normalization. RMSNorm divides by
   the vector's own root-mean-square, so its output does not depend on
   how the input was scaled, and neither does the absmax quantizer in
   front of it. Getting that wrong in the other direction -- multiplying
   by a scale that had already cancelled -- is what made the MLP
   contribute nothing while the block still reported a pass. */
static void nq_scale(unsigned long blk, unsigned long gi, unsigned long n,
                     unsigned int *sm, int *se) {
    unsigned int gm, t, r;
    int ge, te, re;

    if (nq_ss == 0u || nq_mx == 0) { *sm = 0u; *se = 0; return; }
    meta_bf(blk, META_GMAX, gi, &gm, &ge);
    sc_div(nq_ss, 2 * nq_xs, (unsigned int)n, 0, &t, &te);
    sc_sqrt(t, te, &r, &re);
    sc_mul(r, re, 4161536u, 0, &r, &re);              /* 32768 * 127 */
    sc_mul(gm, ge, (unsigned int)nq_mx, 0, &t, &te);
    sc_div(t, te, r, re, sm, se);
}

/* round(v * m * 2^e), for m normalized and the product known to fit.
   |v| < 2^31 and m < 2^31, so the 64-bit product cannot overflow. */
static int mul_bf(int v, unsigned int m, int e) {
    long long p;
    int sh = -e;
    if (m == 0u || v == 0) return 0;
    if (sh >= 63) return 0;
    p = (long long)v * (long long)(unsigned long long)m;
    if (sh <= 0) return (int)(p << (-sh));
    p = (p >= 0) ? ((p + ((long long)1 << (sh - 1))) >> sh)
                 : -((((-p) + ((long long)1 << (sh - 1))) >> sh));
    return (int)p;
}

static void sc_max2(unsigned int am, int ae, unsigned int bm, int be,
                    unsigned int *om, int *oe) {
    sc_norm(&am, &ae); sc_norm(&bm, &be);
    if (am == 0u)      { *om = bm; *oe = be; return; }
    if (bm == 0u)      { *om = am; *oe = ae; return; }
    if (ae > be || (ae == be && am >= bm)) { *om = am; *oe = ae; }
    else                                   { *om = bm; *oe = be; }
}

/* o = x*Sx + d*Sd, renormalized so the result peaks near 2^29.

   Both terms are carried, not the larger one: the attention residual is
   often an order of magnitude below the stream it is added to, and a
   scheme that aligned on the larger exponent and let the smaller fall
   off the bottom would produce a block that passes every shape check
   and contributes nothing. Choosing the output scale from twice the
   larger magnitude leaves each term at most 2^28 and their sum at most
   2^29, so nothing saturates and the smaller term keeps every bit that
   fits under it. */
static void resid_add(const int *x, unsigned int xm, int xe,
                      const int *d, unsigned int dm, int de,
                      int *o, unsigned long n,
                      unsigned int *om, int *oe) {
    unsigned long i;
    int v, ax = 0, ad = 0;
    unsigned int Mx, Md, M, Rx, Rd;
    int Ex, Ed, E, ex, ed;

    for (i = 0; i < n; i++) {
        v = x[i]; if (v < 0) v = -v; if (v > ax) ax = v;
        v = d[i]; if (v < 0) v = -v; if (v > ad) ad = v;
    }
    sc_mul((unsigned int)ax, 0, xm, xe, &Mx, &Ex);
    sc_mul((unsigned int)ad, 0, dm, de, &Md, &Ed);
    sc_max2(Mx, Ex, Md, Ed, &M, &E);
    if (M == 0u) {
        for (i = 0; i < n; i++) o[i] = 0;
        *om = 0u; *oe = 0; return;
    }
    E += 1 - 29;                                   /* So = 2M / 2^29 */
    sc_div(xm, xe, M, E, &Rx, &ex);
    sc_div(dm, de, M, E, &Rd, &ed);
    for (i = 0; i < n; i++)
        o[i] = mul_bf(x[i], Rx, ex) + mul_bf(d[i], Rd, ed);
    *om = M; *oe = E;
}

/* One transformer block at position 0, reading everything it needs from
   DDR and leaving the result in S_X with blk_xm/blk_xe updated. */
static int run_block(unsigned long blk, unsigned long pos, int fab) {
    int *x   = (int *)VSLOT(S_X);
    int *x1  = (int *)VSLOT(S_X1);
    int *p0  = (int *)VSLOT(S_P0);
    int *p1  = (int *)VSLOT(S_P1);
    int *m   = (int *)VSLOT(S_M);
    int *att = (int *)VSLOT(S_ATT);
    int *qs  = (int *)VSLOT(S_QS);
    int *kvs = (int *)VSLOT(S_KVS);
    signed char *a8 = (signed char *)VSLOT(S_A8);
    unsigned int sa, sw, tm;
    int ea, ew, te;
    unsigned long h;

    attn_init();

    if (!nq_run(fab, x, blk, 0u, a8, 1024u)) return 0;
    nq_scale(blk, 0u, 1024u, &sa, &ea);

    /* q and k through the QK-norm and the rotation; v through the same
       operator with a gain of one, so it gets a per-head absmax on the
       same terms and there is no second quantizer to keep in step.

       The scales are saved as each is produced, because qkn_core writes
       them into one set of globals and the next call overwrites them. */
    if (!blk_proj(blk, P_Q, 2048u, 1024u, a8, p0)) return 0;
    qkn_run(blk, 2u, S_P0, S_Q8, 16u, 1, 0u, 0);
    for (h = 0; h < 16u; h++) {
        qs[h * 2u]      = (int)qkn_sm[h];
        qs[h * 2u + 1u] = qkn_se[h];
    }

    if (!blk_proj(blk, P_K, 1024u, 1024u, a8, p0)) return 0;
    qkn_run(blk, 3u, S_P0, S_K8, 8u, 1, 0u, 0);
    for (h = 0; h < 8u; h++) {
        kvs[h * 4u]      = (int)qkn_sm[h];
        kvs[h * 4u + 1u] = qkn_se[h];
    }

    /* v is the one that needs its input's scale handed in, because
       nothing normalizes it away again. */
    if (!blk_proj(blk, P_V, 1024u, 1024u, a8, p0)) return 0;
    meta_bf(blk, META_SCALES, 2u, &sw, &ew);            /* v_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    qkn_run(blk, 0u, S_P0, S_V8, 8u, 0, tm, te);
    for (h = 0; h < 8u; h++) {
        kvs[h * 4u + 2u] = (int)qkn_sm[h];
        kvs[h * 4u + 3u] = qkn_se[h];
    }

    core_ok = 0;
    kvw_core(blk, pos, S_K8, S_V8, S_KVS, 8u, 128u);
    if (!core_ok) { uart_puts("ERR kvw\n"); return 0; }

    if (!attn_heads(blk, pos)) return 0;

    if (!nq_run(fab, att, blk, 4u, a8, 2048u)) return 0;
    nq_scale(blk, 4u, 2048u, &sa, &ea);
    if (!blk_proj(blk, P_O, 1024u, 2048u, a8, p0)) return 0;
    meta_bf(blk, META_SCALES, 3u, &sw, &ew);            /* o_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    resid_add(x, blk_xm, blk_xe, p0, tm, te, x1, 1024u, &blk_xm, &blk_xe);

    if (!nq_run(fab, x1, blk, 1u, a8, 1024u)) return 0;
    nq_scale(blk, 1u, 1024u, &sa, &ea);
    if (!blk_proj(blk, P_G, 3072u, 1024u, a8, p0)) return 0;
    if (!blk_proj(blk, P_U, 3072u, 1024u, a8, p1)) return 0;
    meta_bf(blk, META_SCALES, 4u, &sw, &ew);            /* gate_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    mlp_core(p0, p1, m, tm, (long)te + 512, 3072u);

    if (!nq_run(fab, m, blk, 5u, a8, 3072u)) return 0;
    nq_scale(blk, 5u, 3072u, &sa, &ea);
    if (!blk_proj(blk, P_D, 1024u, 3072u, a8, p0)) return 0;
    meta_bf(blk, META_SCALES, 6u, &sw, &ew);            /* down_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    resid_add(x1, blk_xm, blk_xe, p0, tm, te, x, 1024u, &blk_xm, &blk_xe);
    return 1;
}

/* XSC <mantissa> <exponent+512> -- the scale of the vector in slot 0.
   The bias keeps the exponent unsigned on the wire, the same convention
   MLP and SM already use for theirs. */
static void cmd_xsc(const char *p) {
    blk_xm = (unsigned int)parse_u(&p);
    blk_xe = (int)(long)parse_u(&p) - 512;
    uart_puts("OK XSC\n");
}

static void blk_report(const char *tag) {
    uart_puts(tag);
    uart_puts(" m "); uart_puthex(blk_xm);
    uart_puts(" e "); uart_putdec((long)blk_xe);
    uart_puts("\n");
}

/* BLK <blk> <fab> -- one block. TOK <nblk> <fab> -- all of them. */
static void cmd_blk(const char *p) {
    unsigned long blk = parse_u(&p), fab = parse_u(&p);
    if (blk >= 28u) { uart_puts("ERR range\n"); return; }
    if (!run_block(blk, blk_pos, (int)fab)) return;
    blk_report("BLK");
    uart_puts("OK BLK\n");
}

static void cmd_tok(const char *p) {
    unsigned long nb = parse_u(&p), fab = parse_u(&p), b;
    if (nb == 0u || nb > 28u) { uart_puts("ERR range\n"); return; }
    for (b = 0; b < nb; b++)
        if (!run_block(b, blk_pos, (int)fab)) {
            uart_puts("ERR at block "); uart_putdec((long)b);
            uart_puts("\n"); return;
        }
    blk_report("TOK");
    uart_puts("OK TOK\n");
}

/* ---- Stage 15: reading the QK-norm scales back ----------------------- */

/* QGX <gm> <ge+512> <norm> <am> <ae+512> -- the inputs qkn_core cannot
   parse for itself. The exponent bias keeps it unsigned on the wire, the
   same convention MLP, SM and XSC already use. */
static void cmd_qgx(const char *p) {
    qkn_gm   = (unsigned int)parse_u(&p);
    qkn_ge   = (int)(long)parse_u(&p) - 512;
    qkn_norm = (int)parse_u(&p);
    qkn_am   = (unsigned int)parse_u(&p);
    qkn_ae   = (int)(long)parse_u(&p) - 512;
    uart_puts("OK QGX\n");
}

/* QSC <nh> -- the per-head scales, so the host can check a derivation
   against the float64 one it has been computing all along. */
static void cmd_qsc(const char *p) {
    unsigned long nh = parse_u(&p), h;
    if (nh == 0u || nh > 16u) { uart_puts("ERR range\n"); return; }
    for (h = 0; h < nh; h++) {
        uart_puts("QSC "); uart_putdec((long)h);
        uart_puts(" m "); uart_puthex(qkn_sm[h]);
        uart_puts(" e "); uart_putdec((long)qkn_se[h]);
        uart_puts("\n");
    }
    uart_puts("OK QSC\n");
}

/* ---- Stage 16: attention on the board -------------------------------- */

static int attn_ready = 0;

/* v is quantized by the same operator as q and k, with a gain of one and
   a rotation that does nothing -- which is how it gets a per-head absmax
   and a scale in the same units, with no second operator to keep in step
   with this one. Q15 is 32767, not 32768, because that is what q15v
   clips to and the scale derivation is written against it. */
static void attn_init(void) {
    int *o = (int *)VSLOT(S_ONE);
    int *r = (int *)VSLOT(S_ID);
    unsigned long i;
    if (attn_ready) return;
    for (i = 0; i < 128u; i++) o[i] = 32767;          /* gain of one    */
    for (i = 0; i < 64u; i++)  r[i] = 32767;          /* cos = 1        */
    for (i = 0; i < 64u; i++)  r[64u + i] = 0;        /* sin = 0        */
    attn_ready = 1;
}

/* One gain out of the block's DDR record and into a slot, because
   qkn_core addresses its operands by slot index. 128 words. */
static void meta_gain(unsigned long blk, unsigned long gi) {
    const int *g = (const int *)(meta_rec(blk) + gain_off[gi]);
    int *o = (int *)VSLOT(S_GN);
    unsigned long i;
    for (i = 0; i < gain_len[gi]; i++) o[i] = g[i];
}

/* q, k or v through the QK-norm, carrying stage 14b's scale bookkeeping.
   norm is 1 for q and k, whose deferred root-mean-square makes the result
   absolute, and 0 for v -- absmax quantized, never normalized, so the
   accumulator's own scale survives and has to be handed in. */
static void qkn_run(unsigned long blk, unsigned long gi, unsigned long src,
                    unsigned long dst, unsigned long nh, int norm,
                    unsigned int am, int ae) {
    unsigned int gm;
    int ge;
    if (norm) {
        meta_gain(blk, gi);
        meta_bf(blk, META_GMAX, gi, &gm, &ge);
        qkn_gm = gm; qkn_ge = ge;
    } else {
        qkn_gm = 1u << 30; qkn_ge = -30;              /* a gain of one */
    }
    qkn_norm = norm;
    qkn_am = am; qkn_ae = ae;
    qkn_core(src, norm ? S_GN : S_ONE, norm ? S_CS : S_ID,
             dst, S_DOT, nh, 128u);
}

/* All sixteen query heads at `pos`, over a cache already written there.
   Leaves the result in S_ATT on one common scale, which the o_proj
   normalization downstream is then free to ignore. */
static int attn_heads(unsigned long blk, unsigned long pos) {
    int *att = (int *)VSLOT(S_ATT);
    const int *num = (const int *)VSLOT(S_NUM);
    const int *so  = (const int *)VSLOT(S_SO);
    const int *qs  = (const int *)VSLOT(S_QS);
    const signed char *q8 = (const signed char *)VSLOT(S_Q8);
    signed char *qh = (signed char *)VSLOT(S_QH);
    unsigned int fm[16], Mm, t, dm;
    int fe[16], Me, te, de, amx, v;
    unsigned long h, i;

    for (h = 0; h < 16u; h++) {
        for (i = 0; i < 128u; i++) qh[i] = q8[(h << 7) + i];

        core_ok = 0; qk_core(blk, h >> 1, pos, S_QH, S_DOT);
        if (!core_ok) { uart_puts("ERR qk\n"); return 0; }

        core_ok = 0;
        sm_core(blk, h >> 1, pos, S_DOT,
                (unsigned long)(unsigned int)qs[h * 2u],
                (unsigned long)(long)(qs[h * 2u + 1u] + 512),
                S_PR, S_SO);
        if (!core_ok) { uart_puts("ERR sm\n"); return 0; }

        core_ok = 0; pv_core(blk, h >> 1, pos, S_PR, S_NUM);
        if (!core_ok) { uart_puts("ERR pv\n"); return 0; }

        /* num * wmax * 2^vemax / (127 * sume / 65536): the softmax
           denominator stage 7 deferred, in block float rather than in
           the host's float64. sume reaches 2^25 over a full context, so
           127*sume would not fit 32 bits and the product is formed as a
           block float instead of as an integer. */
        sc_mul((unsigned int)so[2], 0, 127u, 0, &dm, &de);
        sc_div((unsigned int)so[0], so[1] + 16, dm, de, &fm[h], &fe[h]);

        for (i = 0; i < 128u; i++) att[(h << 7) + i] = num[i];
    }

    /* One exponent for all sixteen. */
    Mm = 0u; Me = 0;
    for (h = 0; h < 16u; h++) {
        amx = 0;
        for (i = 0; i < 128u; i++) {
            v = att[(h << 7) + i]; if (v < 0) v = -v;
            if (v > amx) amx = v;
        }
        sc_mul((unsigned int)amx, 0, fm[h], fe[h], &t, &te);
        sc_max2(Mm, Me, t, te, &Mm, &Me);
    }
    if (Mm == 0u) {
        for (i = 0; i < 2048u; i++) att[i] = 0;
        return 1;
    }
    Me += 1 - 29;
    for (h = 0; h < 16u; h++) {
        sc_div(fm[h], fe[h], Mm, Me, &t, &te);
        for (i = 0; i < 128u; i++)
            att[(h << 7) + i] = mul_bf(att[(h << 7) + i], t, te);
    }
    return 1;
}

/* POS <p> -- the position the next BLK or TOK writes the cache at. The
   rotation for it goes into slot 16 with an ordinary LOADV: it is 512
   bytes, it is the same for all twenty-eight blocks, and a 512-entry
   table in DDR is a better idea that can wait until something is
   measured to want it. */
static void cmd_pos(const char *p) {
    unsigned long v = parse_u(&p);
    if (v >= KV_MAXP) { uart_puts("ERR range\n"); return; }
    blk_pos = v;
    uart_puts("OK POS\n");
}

/* ---- Stage 17: DSUM, the resident image's own checksum ---------------

   sum += w * ((addr >> 2) + 1) over 32-bit words, truncated to 32 bits
   at every step -- identical to fw_checksum in eth_load.py, and it has
   to stay identical or the comparison means nothing. */
static void cmd_dsum(const char *p) {
    unsigned long off = parse_u(&p), len = parse_u(&p), i;
    unsigned int sum = 0u, idx;

    if ((off | len) & 3u) { uart_puts("ERR align\n"); return; }
    if (len == 0u || off + len > 224u * 1024u * 1024u) {
        uart_puts("ERR range\n"); return;
    }
    idx = (unsigned int)(off >> 2) + 1u;
    for (i = 0; i < len; i += 4u)
        sum += IO32(DDR_BASE + off + i) * idx++;

    uart_puts("DSUM "); uart_puthex(sum); uart_puts("\nOK DS\n");
}
int main(void) {
    uart_init();
    led(0x1);
    cmd_cache("1");   /* 16 KB D-cache: 4x on every DDR access */
    uart_puts("\nTernaryCore Phase2 DDR firmware READY\n");
    for (;;) {
        read_line();
        if (starts(line, "PING"))        uart_puts("PONG\n");
        else if (starts(line, "LOADW ")) cmd_loadw(line + 6);
        else if (starts(line, "LOADA ")) cmd_loada(line + 6);
        else if (starts(line, "RUN"))    cmd_run(line + 3);
        else if (starts(line, "SLOAD")) cmd_sload();
        else if (starts(line, "SRUN"))  cmd_srun(line + 4);
        else if (starts(line, "MEMTEST")) cmd_memtest();
        else if (starts(line, "LOADV ")) cmd_loadv(line + 6);
        else if (starts(line, "LOADB ")) cmd_loadb(line + 6);
        else if (starts(line, "DUMPV ")) cmd_dumpv(line + 6);
        else if (starts(line, "DUMPB ")) cmd_dumpb(line + 6);
        else if (starts(line, "DUMPR ")) cmd_dumpr(line + 6);
        else if (starts(line, "NQ ")) cmd_nq(line + 3);
        else if (starts(line, "QKN ")) cmd_qkn(line + 4);
        else if (starts(line, "KVW ")) cmd_kvw(line + 4);
        else if (starts(line, "SCT ")) cmd_sct(line + 4);
        else if (starts(line, "QKD ")) cmd_qk(line + 4);
        else if (starts(line, "SM ")) cmd_sm(line + 3);
        else if (starts(line, "PV ")) cmd_pv(line + 3);
        else if (starts(line, "MLP ")) cmd_mlp(line + 4);
        else if (starts(line, "MREAD ")) cmd_mread(line + 6);
        else if (starts(line, "NQD ")) cmd_nqd(line + 4);
        else if (starts(line, "PJO ")) cmd_projo(line + 4);
        else if (starts(line, "NQF ")) cmd_nqf(line + 4);
        else if (starts(line, "NQBENCH ")) cmd_nqbench(line + 8);
        else if (starts(line, "OPB ")) cmd_opb(line + 4);
        else if (starts(line, "XSC ")) cmd_xsc(line + 4);
        else if (starts(line, "BLK ")) cmd_blk(line + 4);
        else if (starts(line, "TOK ")) cmd_tok(line + 4);
        else if (starts(line, "QGX ")) cmd_qgx(line + 4);
        else if (starts(line, "QSC ")) cmd_qsc(line + 4);
        else if (starts(line, "POS ")) cmd_pos(line + 4);
        else if (starts(line, "DSUM ")) cmd_dsum(line + 5);
        else if (starts(line, "KVR ")) cmd_kvr(line + 4);
        else if (starts(line, "PROJ ")) cmd_proj(line + 5);
        else if (starts(line, "CACHE")) cmd_cache(line + 5);
        else if (starts(line, "LOADM ")) cmd_loadm(line + 6);
        else if (starts(line, "PAGEDMA ")) cmd_pagedma(line + 8);
        else if (starts(line, "PAGE "))  cmd_page(line + 5);
        else if (starts(line, "ETHLINK")) cmd_ethlink();
        else if (starts(line, "SL8")) cmd_sload8();
        else if (starts(line, "AMAC")) cmd_amac();
        else if (starts(line, "BENCH ")) cmd_bench(line + 6);
        else if (starts(line, "ETHLOAD ")) cmd_ethload(line + 8);
        else if (starts(line, "ETHRX")) cmd_ethrx(line + 5);
        else                             uart_puts("ERR cmd\n");
    }
    return 0;
}
