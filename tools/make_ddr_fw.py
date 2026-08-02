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
    '\n        else if (starts(line, "ETHLINK")) cmd_ethlink();', 1)

s = s.replace("IO32(UART_RBR_THR) = 54u;", "IO32(UART_RBR_THR) = 44u;", 1)
s = s.replace("/* DLL: 100e6/(16*115200) */", "/* DLL: 81.25e6/(16*115200) */", 1)
s = s.replace("Tier2 streaming firmware READY", "Phase2 DDR firmware READY", 1)

open(dst, "w").write(s)
print("wrote", dst, len(s), "bytes")
