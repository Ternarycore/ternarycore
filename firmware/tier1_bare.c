// tier1_bare.c
// SPDX-License-Identifier: CERN-OHL-S-2.0
// TernaryCore Tier 1 benchmark -- bare-metal build, no Vitis BSP.
//
// Differences from tier1_bench.c:
//   * WEIGHT_BRAM corrected to 0x44100000 (create_bd.tcl maps it there;
//     0x44010000 in the original is unmapped address space).
//   * No xil_io/xtime/xil_printf: direct register I/O + own UART16550 driver.
//   * Timing via host-side wall clock: firmware prints MARK lines, the host
//     timestamps them. Fabric clock is exactly 100 MHz, so
//     cycles = seconds * 100e6.
//
// Compile (Vitis 2025.2 MicroBlaze GCC):
//   mb-gcc -O2 -Wall -mlittle-endian -mcpu=v11.0 -mxl-barrel-shift \
//          -mno-xl-soft-mul -mno-xl-soft-div -mxl-pattern-compare \
//          -Wl,--defsym=_STACK_SIZE=0x1000 -o tier1_bare.elf tier1_bare.c

#define IO32(a) (*(volatile unsigned int *)(a))

// ---- Address map (matches Arty7/create_bd.tcl) ----------------------------
#define GEMM_BASE     0x44000000u
#define WEIGHT_BRAM   0x44100000u
#define UART_BASE     0x40600000u
#define GPIO_BASE     0x40000000u

// GEMM registers
#define REG_CTRL       0x00u
#define REG_ACTIVATION 0x04u
#define REG_WEIGHT_ENC 0x08u
#define REG_ACC_OUT0   0x10u
#define REG_ACC_OUT1   0x14u
#define REG_ACC_OUT2   0x18u
#define REG_ACC_OUT3   0x1Cu
#define CTRL_START     0x00000001u
#define CTRL_DONE      0x80000000u

// AXI UART16550: 16550 regs live at +0x1000, one per 32-bit word, LSB byte
#define UART_THR   (UART_BASE + 0x1000u)   // write (DLAB=0)
#define UART_DLL   (UART_BASE + 0x1000u)   // write (DLAB=1)
#define UART_IER   (UART_BASE + 0x1004u)   // DLM when DLAB=1
#define UART_FCR   (UART_BASE + 0x1008u)
#define UART_LCR   (UART_BASE + 0x100Cu)
#define UART_LSR   (UART_BASE + 0x1014u)
#define LSR_THRE   0x20u

// ---- Benchmark dimensions --------------------------------------------------
#define DEPTH        768
#define COLS_TOTAL   768
#define GROUPS       (COLS_TOTAL / 4)
#define ACCEL_PASSES 200
#define SW_PASSES    10

// ---- UART ------------------------------------------------------------------
static void uart_init(void) {
    IO32(UART_LCR) = 0x83u;              // DLAB=1, 8N1
    IO32(UART_DLL) = 54u;                // 100 MHz / (16*115200) = 54.25
    IO32(UART_IER) = 0u;                 // DLM
    IO32(UART_LCR) = 0x03u;              // DLAB=0, 8N1
    IO32(UART_FCR) = 0x07u;              // enable + reset FIFOs
}

static void uart_putc(char c) {
    while (!(IO32(UART_LSR) & LSR_THRE)) { }
    IO32(UART_THR) = (unsigned int)(unsigned char)c;
}

static void uart_puts(const char *s) {
    while (*s) {
        if (*s == '\n') uart_putc('\r');
        uart_putc(*s++);
    }
}

static void uart_putdec(long v) {
    char buf[12];
    int  i = 0;
    unsigned long u;
    if (v < 0) { uart_putc('-'); u = (unsigned long)(-v); }
    else       { u = (unsigned long)v; }
    do { buf[i++] = (char)('0' + (u % 10u)); u /= 10u; } while (u);
    while (i) uart_putc(buf[--i]);
}

static void uart_puthex(unsigned long v) {
    static const char *h = "0123456789abcdef";
    int i;
    uart_puts("0x");
    for (i = 28; i >= 0; i -= 4) uart_putc(h[(v >> i) & 0xFu]);
}

static void led(unsigned int v) { IO32(GPIO_BASE) = v; }

// ---- Ternary helpers (identical to tier1_bench.c) --------------------------
static unsigned char encode_ternary(signed char val) {
    if (val > 0) return 0x01u;
    if (val < 0) return 0x02u;
    return 0x00u;
}

static signed char decode_ternary(unsigned char bits) {
    bits &= 0x3u;
    if (bits == 0x01u) return 1;
    if (bits == 0x02u) return -1;
    return 0;
}

static signed char activations[DEPTH];
static long accel_out[COLS_TOTAL];
static long sw_out[COLS_TOTAL];

static unsigned char read_weight_byte(unsigned int byte_addr) {
    unsigned int word_addr = byte_addr & ~3u;
    unsigned int word      = IO32(WEIGHT_BRAM + word_addr);
    return (unsigned char)(word >> (8u * (byte_addr & 3u)));
}

static void init_weights(void) {
    unsigned int i, b, w;
    unsigned int total_words = 256u * 1024u / 4u;
    for (i = 0u; i < total_words; i++) {
        unsigned int word = 0u;
        for (b = 0u; b < 4u; b++) {
            unsigned char byte_val = 0u;
            for (w = 0u; w < 4u; w++) {
                signed char val = (signed char)(((i * 16u + b * 4u + w) % 3u) - 1);
                byte_val |= (unsigned char)(encode_ternary(val) << (2u * w));
            }
            word |= ((unsigned int)byte_val << (8u * b));
        }
        IO32(WEIGHT_BRAM + i * 4u) = word;
    }
}

static void init_activations(void) {
    int k;
    for (k = 0; k < DEPTH; k++)
        activations[k] = (signed char)((k % 7) - 3);
}

static void accel_forward_pass(long *outputs) {
    int g, k;
    for (g = 0; g < GROUPS; g++) {
        IO32(GEMM_BASE + REG_CTRL) = CTRL_START;
        for (k = 0; k < DEPTH; k++) {
            unsigned char wb = read_weight_byte((unsigned int)(k * GROUPS + g));
            IO32(GEMM_BASE + REG_WEIGHT_ENC) = (unsigned int)wb;
            IO32(GEMM_BASE + REG_ACTIVATION) = (unsigned int)(unsigned char)activations[k];
        }
        while (!(IO32(GEMM_BASE + REG_CTRL) & CTRL_DONE)) { }
        outputs[g * 4 + 0] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT0);
        outputs[g * 4 + 1] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT1);
        outputs[g * 4 + 2] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT2);
        outputs[g * 4 + 3] = (long)(int)IO32(GEMM_BASE + REG_ACC_OUT3);
    }
}

static void sw_forward_pass(long *outputs) {
    int c, k;
    for (c = 0; c < COLS_TOTAL; c++) {
        long sum = 0;
        int  g   = c / 4;
        int  bp  = (c & 3) * 2;
        for (k = 0; k < DEPTH; k++) {
            unsigned char wb = read_weight_byte((unsigned int)(k * GROUPS + g));
            signed char   w  = decode_ternary((unsigned char)((wb >> bp) & 0x3u));
            sum += (long)activations[k] * (long)w;
        }
        outputs[c] = sum;
    }
}

static int verify_outputs(const long *accel, const long *sw) {
    int c, errors = 0;
    for (c = 0; c < COLS_TOTAL; c++) {
        if (accel[c] != sw[c]) {
            errors++;
            if (errors <= 5) {
                uart_puts("MISMATCH col ");
                uart_putdec(c);
                uart_puts(": accel=");
                uart_putdec(accel[c]);
                uart_puts(" sw=");
                uart_putdec(sw[c]);
                uart_puts("\n");
            }
        }
    }
    return errors;
}

int main(void) {
    int pass, errors, c;
    unsigned long checksum = 0;

    uart_init();
    led(0x1);
    uart_puts("\nTernaryCore Tier 1 Benchmark (bare-metal)\n");
    uart_puts("Initializing weights (256 KB BRAM)...\n");
    init_weights();
    init_activations();
    led(0x3);

    uart_puts("Verifying accel vs software (1 pass each)...\n");
    accel_forward_pass(accel_out);
    sw_forward_pass(sw_out);
    errors = verify_outputs(accel_out, sw_out);
    if (errors > 0) {
        uart_puts("FAIL: ");
        uart_putdec(errors);
        uart_puts(" output mismatch(es)\n");
        led(0x8);
        for (;;) { }
    }
    uart_puts("Verification PASS\n");
    for (c = 0; c < COLS_TOTAL; c++) checksum += (unsigned long)accel_out[c] * (unsigned long)(c + 1);
    uart_puts("Output checksum: ");
    uart_puthex(checksum);
    uart_puts("  out[0..3]=");
    uart_putdec(accel_out[0]); uart_puts(",");
    uart_putdec(accel_out[1]); uart_puts(",");
    uart_putdec(accel_out[2]); uart_puts(",");
    uart_putdec(accel_out[3]); uart_puts("\n");
    led(0x7);

    // ---- Accelerator benchmark ----
    uart_puts("MARK ACCEL_START "); uart_putdec(ACCEL_PASSES); uart_puts("\n");
    for (pass = 0; pass < ACCEL_PASSES; pass++)
        accel_forward_pass(accel_out);
    uart_puts("MARK ACCEL_END\n");

    // ---- Software benchmark ----
    uart_puts("MARK SW_START "); uart_putdec(SW_PASSES); uart_puts("\n");
    for (pass = 0; pass < SW_PASSES; pass++)
        sw_forward_pass(sw_out);
    uart_puts("MARK SW_END\n");

    uart_puts("MARK BENCH_DONE\n");
    led(0xF);
    for (;;) { }
    return 0;
}
