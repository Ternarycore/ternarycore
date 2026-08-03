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

static void uart_putc(char c) {
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
static long accel_out[COLS_TOTAL];
static long sw_out[COLS_TOTAL];

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

    dcache_flush_range(DDR_BASE + off, PAGE_BYTES);

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
        else { if (++spin > 200000000u) break; continue; }
        spin = 0;
        if (eth_hdr_type(buf) == 0x88B5u) {
            seq = eth_seq(buf);
            len = eth_len(buf);
            if (len > chunk) len = chunk;
            dst = off + seq * chunk;
            for (i = 0; i < len; i += 4u) {
                w = IO32(buf + 20u + i);
                IO32(DDR_BASE + dst + i) = w;
                sum += (w & 0xFFu) + ((w >> 8) & 0xFFu)
                     + ((w >> 16) & 0xFFu) + ((w >> 24) & 0xFFu);
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

int main(void) {
    uart_init();
    led(0x1);
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
        else if (starts(line, "LOADM ")) cmd_loadm(line + 6);
        else if (starts(line, "PAGEDMA ")) cmd_pagedma(line + 8);
        else if (starts(line, "PAGE "))  cmd_page(line + 5);
        else if (starts(line, "ETHLINK")) cmd_ethlink();
        else if (starts(line, "ETHLOAD ")) cmd_ethload(line + 8);
        else if (starts(line, "ETHRX")) cmd_ethrx(line + 5);
        else                             uart_puts("ERR cmd\n");
    }
    return 0;
}
