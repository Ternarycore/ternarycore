#!/usr/bin/env python3
"""Generate firmware/tier2_host.c from tier1_host.c: adds the Tier-2
streaming-GEMM commands (SLOAD, SRUN) at 0x44200000. Deterministic anchor
patching so the proven UART/protocol code is inherited verbatim.
Note: on the tier2 bitstream the weight AXI readback returns 0xDEADBEEF by
design, so the legacy RUN's software verify is not meaningful there —
verification is host-side (three-way becomes board-vs-NumPy).
"""
import os, sys

src = os.path.join(os.path.dirname(__file__), "..", "firmware", "tier1_host.c")
dst = os.path.join(os.path.dirname(__file__), "..", "firmware", "tier2_host.c")
s = open(src).read()

DEFS = """
/* ---- Tier-2 streaming GEMM (axi_gemm_stream @ 0x44200000) ---- */
#define STREAM_BASE   0x44200000u
#define S_CTRL        0x00u
#define S_STATUS      0x04u
#define S_ACTWR       0x08u
#define S_CT          0x0Cu
#define S_RIDX        0x14u
#define S_RDATA       0x18u
#define S_CYC         0x20u
"""

FUNCS = """
/* ---- Tier-2 stream commands ---- */
static void cmd_sload(void) {
    unsigned long k;
    IO32(STREAM_BASE + S_CTRL) = 0x4u;              /* act ptr reset */
    for (k = 0; k < DEPTH; k++)
        IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)activations[k];
    uart_puts("OK SL\\n");
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
    uart_puts("CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC)); uart_puts("\\n");
    uart_puts("MARK STREAM_START "); uart_putdec((long)passes); uart_puts("\\n");
    for (i = 0; i < passes; i++)
        for (ct = 0; ct < 16; ct++) stream_tile(ct);
    uart_puts("MARK STREAM_END\\n");
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
    uart_puts("\\nDONE\\n");
}

"""

anchor = "#define GPIO_BASE     0x40000000u"
assert anchor in s
s = s.replace(anchor, anchor + "\n" + DEFS, 1)

anchor = "int main(void) {"
assert anchor in s
s = s.replace(anchor, FUNCS + anchor, 1)

anchor = 'else if (starts(line, "RUN"))    cmd_run(line + 3);'
assert anchor in s
s = s.replace(anchor, anchor +
    '\n        else if (starts(line, "SLOAD")) cmd_sload();' +
    '\n        else if (starts(line, "SRUN"))  cmd_srun(line + 4);', 1)

s = s.replace("Stage1 host-streaming firmware READY",
              "Tier2 streaming firmware READY", 1)

open(dst, "w").write(s)
print("wrote", dst, len(s), "bytes")
""""""
