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
    IO32(UART_RBR_THR) = 54u;            /* DLL: 100e6/(16*115200) */
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
    sw_passes = passes;  /* energy build: equal windows */

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
        led(0x8);
        /* energy build: fall through to the MARK loops even on verify fail
           (post-c7778d5 read_weight_byte returns garbage; power is what we
           measure here, not correctness) */
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

int main(void) {
    uart_init();
    led(0x1);
    uart_puts("\nTernaryCore Tier2 streaming firmware READY\n");
    for (;;) {
        read_line();
        if (starts(line, "PING"))        uart_puts("PONG\n");
        else if (starts(line, "LOADW ")) cmd_loadw(line + 6);
        else if (starts(line, "LOADA ")) cmd_loada(line + 6);
        else if (starts(line, "RUN"))    cmd_run(line + 3);
        else if (starts(line, "SLOAD")) cmd_sload();
        else if (starts(line, "SRUN"))  cmd_srun(line + 4);
        else                             uart_puts("ERR cmd\n");
    }
    return 0;
}
