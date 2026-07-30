// tier1_bench.c
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// Tier 1 Benchmark: Accelerated ternary GEMM vs pure-software GEMM.
// Loads 1M ternary weights into on-chip BRAM, runs 100 forward passes
// (768-int8-activations -> 768-int32-outputs) through both paths,
// and reports cycle counts + speedup over UART.
//
// Compile: mb-gcc -O2 -Wall -o tier1_bench.elf tier1_bench.c

#include "xil_io.h"
#include "xtime_l.h"
#include "xil_printf.h"

// ---------------------------------------------------------------------------
// Address map (matches Arty7/create_bd.tcl)
// ---------------------------------------------------------------------------
#define GEMM_BASE     0x44000000u
#define WEIGHT_BRAM   0x44010000u

// GEMM register offsets (word-aligned)
#define REG_CTRL      0x00u
#define REG_ACTIVATION 0x04u
#define REG_WEIGHT_ENC 0x08u
#define REG_ACC_OUT0  0x10u
#define REG_ACC_OUT1  0x14u
#define REG_ACC_OUT2  0x18u
#define REG_ACC_OUT3  0x1Cu

#define CTRL_START    0x00000001u
#define CTRL_DONE     0x80000000u

// ---------------------------------------------------------------------------
// Matrix dimensions (hardware: DEPTH=768, COLS=4, ROWS=4)
// ---------------------------------------------------------------------------
#define DEPTH         768
#define COLS_TOTAL    768
#define GROUPS        (COLS_TOTAL / 4)  // 192 column groups

// ---------------------------------------------------------------------------
// Ternary weight encoding: 00 = zero, 01 = +1, 10 = -1
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Global data
// ---------------------------------------------------------------------------
static signed char activations[DEPTH];

// ---------------------------------------------------------------------------
// read_weight_byte -- read one packed byte from weight BRAM via AXI
// ---------------------------------------------------------------------------
static unsigned char read_weight_byte(unsigned int byte_addr) {
    unsigned int word_addr = byte_addr & ~3u;
    unsigned int word      = Xil_In32(WEIGHT_BRAM + word_addr);
    return (unsigned char)(word >> (8u * (byte_addr & 3u)));
}

// ---------------------------------------------------------------------------
// init_weights -- fill 256 KB weight BRAM with deterministic ternary params
//   Packing: 4 ternary weights per byte (2 bits each, LSB first)
//            4 bytes per 32-bit word -> 16 ternary weights per AXI write
// ---------------------------------------------------------------------------
static void init_weights(void) {
    unsigned int i, b, w;
    unsigned int total_words = 256u * 1024u / 4u;  // 65536 words

    for (i = 0u; i < total_words; i++) {
        unsigned int word = 0u;
        for (b = 0u; b < 4u; b++) {
            unsigned char byte_val = 0u;
            for (w = 0u; w < 4u; w++) {
                signed char val = (signed char)(((i * 16u + b * 4u + w) % 3u) - 1);
                byte_val |= (unsigned char)(encode_ternary(val) << (2u * w));
            }
            word |= (byte_val << (8u * b));
        }
        Xil_Out32(WEIGHT_BRAM + i * 4u, word);
    }
}

// ---------------------------------------------------------------------------
// init_activations -- generate test activation vector
// ---------------------------------------------------------------------------
static void init_activations(void) {
    int k;
    for (k = 0; k < DEPTH; k++) {
        activations[k] = (signed char)((k % 7) - 3);  // -3 .. +3
    }
}

// ---------------------------------------------------------------------------
// accel_forward_pass -- one GEMM forward pass via hardware accelerator
//   Feeds 768 activation/weight pairs per column group (192 groups).
//   Each activation write triggers one valid_in pulse to the GEMM pipeline.
// ---------------------------------------------------------------------------
static void accel_forward_pass(long *outputs) {
    int g, k;
    for (g = 0; g < GROUPS; g++) {
        Xil_Out32(GEMM_BASE + REG_CTRL, CTRL_START);

        for (k = 0; k < DEPTH; k++) {
            unsigned char wb = read_weight_byte((unsigned int)(k * GROUPS + g));
            Xil_Out32(GEMM_BASE + REG_WEIGHT_ENC, (unsigned int)wb);
            Xil_Out32(GEMM_BASE + REG_ACTIVATION, (unsigned int)(unsigned char)activations[k]);
        }

        while (!(Xil_In32(GEMM_BASE + REG_CTRL) & CTRL_DONE));

        outputs[g * 4 + 0] = (long)(int)Xil_In32(GEMM_BASE + REG_ACC_OUT0);
        outputs[g * 4 + 1] = (long)(int)Xil_In32(GEMM_BASE + REG_ACC_OUT1);
        outputs[g * 4 + 2] = (long)(int)Xil_In32(GEMM_BASE + REG_ACC_OUT2);
        outputs[g * 4 + 3] = (long)(int)Xil_In32(GEMM_BASE + REG_ACC_OUT3);
    }
}

// ---------------------------------------------------------------------------
// sw_forward_pass -- software reference GEMM (pure C, reads from BRAM)
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// verify_outputs -- compare accel and sw results
// ---------------------------------------------------------------------------
static int verify_outputs(const long *accel, const long *sw) {
    int c, errors = 0;
    for (c = 0; c < COLS_TOTAL; c++) {
        if (accel[c] != sw[c]) {
            errors++;
            if (errors <= 5) {
                xil_printf("MISMATCH col %d: accel=%d sw=%d\r\n", c, (int)accel[c], (int)sw[c]);
            }
        }
    }
    return errors;
}

// ---------------------------------------------------------------------------
// main
// ---------------------------------------------------------------------------
int main(void) {
    XTime    t_start, t_end;
    unsigned long long accel_ticks, sw_ticks;
    long               accel_out[COLS_TOTAL];
    long               sw_out[COLS_TOTAL];
    int                pass, errors;

    xil_printf("\r\nTernaryCore Tier 1 Benchmark\r\n");
    xil_printf("Initializing...\r\n");

    init_weights();
    init_activations();

    // Verify correctness with a single pass before benchmark
    accel_forward_pass(accel_out);
    sw_forward_pass(sw_out);
    errors = verify_outputs(accel_out, sw_out);
    if (errors > 0) {
        xil_printf("FAIL: %d output mismatch(es)\r\n", errors);
        return 1;
    }
    xil_printf("Verification PASS\r\n");

    // ---- Accelerated benchmark (100 passes) ----
    xil_printf("Running 100 accelerator passes...\r\n");
    XTime_GetTime(&t_start);
    for (pass = 0; pass < 100; pass++) {
        accel_forward_pass(accel_out);
    }
    XTime_GetTime(&t_end);
    accel_ticks = (unsigned long long)(t_end - t_start);

    // ---- Software benchmark (100 passes) ----
    xil_printf("Running 100 software passes...\r\n");
    XTime_GetTime(&t_start);
    for (pass = 0; pass < 100; pass++) {
        sw_forward_pass(sw_out);
    }
    XTime_GetTime(&t_end);
    sw_ticks = (unsigned long long)(t_end - t_start);

    // Compute speedup with one decimal place
    {
        unsigned long long sp_x10  = (sw_ticks * 10ull) / accel_ticks;
        unsigned int      sp_int  = (unsigned int)(sp_x10 / 10ull);
        unsigned int      sp_frac = (unsigned int)(sp_x10 % 10ull);

        xil_printf("ACCEL: %u%08u cycles  SW: %u%08u cycles  Speedup: %u.%ux\r\n",
            (unsigned int)(accel_ticks >> 32), (unsigned int)(accel_ticks & 0xFFFFFFFFull),
            (unsigned int)(sw_ticks >> 32),     (unsigned int)(sw_ticks & 0xFFFFFFFFull),
            sp_int, sp_frac);
    }

    return 0;
}
