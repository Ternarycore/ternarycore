#!/usr/bin/env python3
"""Generate firmware/ddr_host.c from tier2_host.c: Phase-2 commands.
  MEMTEST            — strided write/read pattern across 64 MB of DDR3
  LOADM <off> <len>  — UART bytes -> DDR3 at 0x80000000+off (checksummed)
  PAGE <off>         — copy 262144 B DDR3 -> weight BRAM (one packed layer)
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
    '\n        else if (starts(line, "PAGE "))  cmd_page(line + 5);', 1)

s = s.replace("IO32(UART_RBR_THR) = 54u;", "IO32(UART_RBR_THR) = 44u;", 1)
s = s.replace("/* DLL: 100e6/(16*115200) */", "/* DLL: 81.25e6/(16*115200) */", 1)
s = s.replace("Tier2 streaming firmware READY", "Phase2 DDR firmware READY", 1)

open(dst, "w").write(s)
print("wrote", dst, len(s), "bytes")
""""""
