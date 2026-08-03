#!/usr/bin/env python3
"""Generate firmware/ddr_host.c from tier2_host.c: Phase-2 / 2.5 / 3 commands.
  MEMTEST            — strided write/read pattern across 64 MB of DDR3
  LOADM <off> <len>  — UART bytes -> DDR3 at 0x80000000+off (checksummed)
  PAGE <off>         — copy 262144 B DDR3 -> weight BRAM (CPU loop, one layer)
  PAGEDMA <off>      — same copy via AXI CDMA (Phase 2.5 hardware pager)
  ETHLINK            — MDIO scan + BMSR read on the EthernetLite PHY (Phase 3)
Also retunes UART DLL 54->44 for the 81.25 MHz ui_clk.
"""
import os

src = os.path.join(os.path.dirname(__file__), "..", "firmware", "tier2_host.c")
dst = os.path.join(os.path.dirname(__file__), "..", "firmware", "ddr_host.c")
s = open(src).read()

DEFS = """
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
"""

FUNCS = """
/* ---- Phase-2 DDR commands ---- */
static void cmd_memtest(void) {
    unsigned long i, errs = 0;
    /* 4096 words strided 16 KB apart across 64 MB: defeats the 16 KB dcache */
    for (i = 0; i < 4096u; i++)
        IO32(DDR_BASE + i * 16384u) = 0xA5000000u ^ (unsigned int)(i * 2654435761u);
    for (i = 0; i < 4096u; i++)
        if (IO32(DDR_BASE + i * 16384u) != (0xA5000000u ^ (unsigned int)(i * 2654435761u))) errs++;
    if (errs) { uart_puts("MEMTEST FAIL "); uart_putdec((long)errs); uart_puts("\\n"); }
    else      { uart_puts("MEMTEST OK 4096 words / 64MB span\\n"); }
}

static void cmd_loadm(const char *p) {
    unsigned long off = parse_u(&p), len = parse_u(&p), i, sum = 0;
    unsigned int word = 0;
    if ((off & 3u) || off + len > 224u * 1024u * 1024u) { uart_puts("ERR range\\n"); return; }
    for (i = 0; i < len; i++) {
        unsigned char b = uart_getc();
        sum += b;
        word |= ((unsigned int)b) << (8u * (i & 3u));
        if ((i & 3u) == 3u) { IO32(DDR_BASE + off + (i & ~3u)) = word; word = 0; }
    }
    if (len & 3u) IO32(DDR_BASE + off + (len & ~3u)) = word;
    uart_puts("OK M "); uart_puthex(sum); uart_puts("\\n");
}

static void cmd_page(const char *p) {
    unsigned long off = parse_u(&p), i;
    if (off & 3u) { uart_puts("ERR align\\n"); return; }
    uart_puts("MARK PAGE_START\\n");
    for (i = 0; i < PAGE_BYTES; i += 4u)
        IO32(WEIGHT_BRAM + i) = IO32(DDR_BASE + off + i);
    uart_puts("MARK PAGE_END\\nOK P\\n");
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
    if (off & 3u) { uart_puts("ERR align\\n"); return; }
    if (n == 0u) n = 1u;   /* optional repeat count: amortise UART latency */

    IO32(CDMA_CR) = 0x04u;                                  /* soft reset */
    while (IO32(CDMA_CR) & 0x04u)
        if (++spin > 1000000u) { uart_puts("ERR cdma reset\\n"); return; }

    dcache_flush_range(DDR_BASE + off, PAGE_BYTES);

    uart_puts("MARK PAGEDMA_START\\n");
    for (k = 0; k < n; k++) {
    IO32(CDMA_SA)  = DDR_BASE + off;
    IO32(CDMA_DA)  = WEIGHT_BRAM;
    IO32(CDMA_BTT) = PAGE_BYTES;                            /* starts transfer */
    spin = 0;
    while (!(IO32(CDMA_SR) & 0x02u)) {                      /* bit1 = Idle */
        if (++spin > 40000000u) {
            uart_puts("ERR cdma timeout SR "); uart_puthex(IO32(CDMA_SR));
            uart_puts("\\n"); return;
        }
    }
    }
    uart_puts("MARK PAGEDMA_END\\n");
    sr = IO32(CDMA_SR);
    if (sr & CDMA_ERR_MASK) { uart_puts("ERR cdma SR "); uart_puthex(sr); uart_puts("\\n"); return; }
    uart_puts("OK PD\\n");
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
        uart_puts((bmsr & 0x0004u) ? "  LINK UP\\n" : "  LINK DOWN\\n");
        return;
    }
    uart_puts("ETHLINK no PHY responded\\n");
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
        if (++spin > 1000000u) { uart_puts("ERR mac program\\n"); return; }
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
static int bench_buf[BN];
static int bench_out[BN];

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
    i = (-z) >> 16;
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
static int exp_lut[LUTN];    /* exp(-i/16), Q16.16              */
static int silu_lut[LUTN];   /* silu(x), x = (i-512)/16, Q16.16 */
static int luts_ready = 0;

static void build_luts(void) {
    int i, xq, ax, e, s;
    if (luts_ready) return;
    for (i = 0; i < LUTN; i++)
        exp_lut[i] = fx_exp2(-(int)(((unsigned int)i * 94548u) >> 4));
    for (i = 0; i < LUTN; i++) {
        xq = ((i - 512) << 16) / 16;
        ax = (xq < 0) ? -xq : xq;
        e  = fx_exp2(-(int)(((long)ax * 94548) >> 16));
        s  = (int)((1u << 28) / (unsigned int)(((65536 + e) >> 4) ? ((65536 + e) >> 4) : 1));
        if (xq < 0) s = 65536 - s;
        silu_lut[i] = (int)(((long)xq * s) >> 16);
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
    uart_puts("OK SL8\\n");
}

static void cmd_amac(void) {
    int c;
    long v;
    unsigned long checksum = 0;
    IO32(STREAM_BASE + S_CTRL) = 0x9u;                  /* START | INT8 */
    while (!(IO32(STREAM_BASE + S_STATUS) & 0x2u)) { }
    IO32(STREAM_BASE + S_CTRL) = 0x2u;                  /* clear done */
    uart_puts("ACYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\\nAOUT");
    for (c = 0; c < 64; c++) {
        IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
        v = (long)(int)IO32(STREAM_BASE + S_RDATA);
        checksum += (unsigned long)v * (unsigned long)(c + 1);
        if (c < 8) { uart_puts(" "); uart_putdec(v); }
    }
    uart_puts("\\nACHK "); uart_puthex(checksum); uart_puts("\\nOK AM\\n");
}

static void cmd_bench(const char *p) {
    unsigned long op = parse_u(&p), reps = parse_u(&p), n = parse_u(&p), r;
    if (n == 0u || n > (unsigned long)BN) n = 1024u;
    if (reps == 0u) reps = 100u;
    for (r = 0; r < n; r++)
        bench_buf[r] = (int)((unsigned int)(r * 2654435761u) & 0x3FFFu) - 8192;
    build_luts();
    uart_puts("MARK BENCH_START\\n");
    for (r = 0; r < reps; r++) {
        if      (op == 0u) bench_copy((int)n);
        else if (op == 1u) bench_rmsnorm((int)n);
        else if (op == 2u) bench_softmax((int)n);
        else if (op == 3u) bench_silu((int)n);
        else if (op == 4u) bench_softmax_r((int)n);
        else if (op == 5u) bench_softmax_d((int)n);
        else if (op == 6u) bench_softmax_l((int)n);
        else if (op == 7u) bench_silu_l((int)n);
        else               bench_mac((int)n);
    }
    uart_puts("MARK BENCH_END\\nOK B ");
    uart_puthex((unsigned int)bench_out[0]); uart_puts("\\n");
}

static void cmd_ethload(const char *p) {
    unsigned long off = parse_u(&p), count = parse_u(&p), chunk = parse_u(&p);
    unsigned long got = 0, sum = 0, spin = 0, i, seq, len, dst;
    unsigned int buf = 0, rsr = 0, w;
    if (chunk == 0u) chunk = 1024u;
    eth_set_mac();
    uart_puts("MARK ETHLOAD_START\\n");
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
    uart_puts("MARK ETHLOAD_END\\n");
    uart_puts("OK E "); uart_puthex(sum);
    uart_puts(" n ");   uart_putdec((long)got); uart_puts("\\n");
}

static void cmd_ethrx(const char *p) {
    unsigned long budget = parse_u(&p), spin = 0, seen = 0;
    unsigned int buf = 0, rsr = 0, i;
    if (budget == 0u) budget = 20000000u;
    eth_set_mac();
    uart_puts("ETHRX waiting\\n");
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
        uart_puts("\\n");
        IO32(rsr) = 0u;                      /* release the buffer */
        break;
    }
    if (!seen) uart_puts("ETHRX none\\n");
    else       uart_puts("OK RX\\n");
}

"""

anchor = "/* ---- Tier-2 streaming GEMM (axi_gemm_stream @ 0x44200000) ---- */"
assert anchor in s
s = s.replace(anchor, DEFS + anchor, 1)

anchor = "int main(void) {"
assert anchor in s
s = s.replace(anchor, FUNCS + anchor, 1)

anchor = 'else if (starts(line, "SRUN"))  cmd_srun(line + 4);'
assert anchor in s
s = s.replace(anchor, anchor +
    '\n        else if (starts(line, "MEMTEST")) cmd_memtest();' +
    '\n        else if (starts(line, "LOADM ")) cmd_loadm(line + 6);' +
    '\n        else if (starts(line, "PAGEDMA ")) cmd_pagedma(line + 8);' +
    '\n        else if (starts(line, "PAGE "))  cmd_page(line + 5);' +
    '\n        else if (starts(line, "ETHLINK")) cmd_ethlink();' +
    '\n        else if (starts(line, "SL8")) cmd_sload8();\n        else if (starts(line, "AMAC")) cmd_amac();\n        else if (starts(line, "BENCH ")) cmd_bench(line + 6);\n        else if (starts(line, "ETHLOAD ")) cmd_ethload(line + 8);\n        else if (starts(line, "ETHRX")) cmd_ethrx(line + 5);', 1)

import fw_ops
s = s.replace(fw_ops.ANCHOR, fw_ops.OPS + fw_ops.ANCHOR, 1)
assert fw_ops.DISPATCH_OLD in s
s = s.replace(fw_ops.DISPATCH_OLD, fw_ops.DISPATCH_NEW, 1)

s = s.replace("IO32(UART_RBR_THR) = 54u;", "IO32(UART_RBR_THR) = 44u;", 1)
s = s.replace("/* DLL: 100e6/(16*115200) */", "/* DLL: 81.25e6/(16*115200) */", 1)
s = s.replace("Tier2 streaming firmware READY", "Phase2 DDR firmware READY", 1)

open(dst, "w").write(s)
print("wrote", dst, len(s), "bytes")
