// BitNet full pipeline end-to-end test.
// Drives activation_quant → ternary_gemm → ternary_scale through
// rtl/ternary_pipeline.v with synthetic but realistic BitNet patterns.
//
// Test scenario: 4×4 matmul with ternary weights and per-channel scales.
//   activations: [10, 20, -10, -20]  (raw int8)
//   weights/col: [+1, -1, 0, +1]     (ternary)
//   alpha:       [1.0, 0.5, 2.0, 1.0] (Q15 scales)
//
// Manual expected:
//   col0 (+1):  10 + 20 + -10 + -20 = 0,  ×1.0  = 0
//   col1 (-1): -10 -20 + 10 + 20   = 0,  ×0.5  = 0
//   col2 (0):   0,  ×2.0 = 0
//   col3 (+1):  10 + 20 + -10 + -20 = 0,  ×1.0  = 0
//
// Hmm, that sums to zero!  Let me use asymmetric weights to get non-zero results.
//   col0 (+1): activation sum = 10+20-10-20 = 0
//   Let me use activation [10, 20, 30, 40] weights [+1, -1, +1, -1]
//   col0 (+1): 10+20+30+40 = 100, ×1.0 = 100
//   col1 (-1): -10-20-30-40 = -100, ×0.5 = -50
//   col2 (+1): 10+20+30+40 = 100, ×2.0 = 200
//   col3 (-1): -10-20-30-40 = -100, ×1.0 = -100

#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

static int compute_inv(int absmax) {
    return round(32768.0 * 127.0 / absmax);
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_pipeline* dut = new Vternary_pipeline;
    int errors = 0;

    int8_t acts[4] = {10, 20, 30, 40};
    int    weights[4] = {1, -1, 1, -1};  // per column
    int    alphas[4] = {32768, 16384, 65536, 32768};  // Q15: 1.0, 0.5, 2.0, 1.0
    int32_t expected[4] = {100, -50, 200, -100};

    int absmax = 40;  // max of |acts|
    int inv = compute_inv(absmax);

    // Pack weights: col 0 = bits[1:0], col 1 = bits[3:2], etc.
    // encoding: 0=00, +1=01, -1=10
    int w_packed = 0;
    for (int c = 0; c < 4; c++)
        w_packed |= (weights[c] == 1 ? 1 : weights[c] == -1 ? 2 : 0) << (2 * c);

    // Pack alphas into uint64_t (col 0 = bits[15:0], col 1 = bits[31:16], ...)
    uint64_t alpha_packed = 0;
    for (int c = 0; c < 4; c++)
        alpha_packed |= (uint64_t)(uint16_t)alphas[c] << (c * 16);

    // Reset
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    // Feed 4 activations
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1;
        dut->activation = acts[i];
        dut->inv = inv;
        dut->weight_enc = w_packed;
        dut->alpha = alpha_packed;
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
    }

    // Drain pipeline
    dut->valid_in = 0;
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        if (dut->valid_out) {
            printf("Pipeline output: valid_out asserted at cycle %d\n", i);
            for (int c = 0; c < 4; c++) {
                int32_t got = (int32_t)dut->result.at(c);
                int32_t exp = expected[c];
                printf("  col %d: got %d expected %d", c, got, exp);
                if (got == exp) printf(" ✓\n");
                else { printf(" ✗\n"); errors++; }
            }
            break;
        }
    }

    if (!dut->valid_out) {
        printf("FAIL: pipeline never produced valid_out\n");
        errors++;
    }

    delete dut;
    printf("─── %d error(s) ───\n", errors);
    return errors ? 1 : 0;
}