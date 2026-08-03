// Pipeline test with VECTOR_LEN=576 (SmolVLM hidden dimension).
// Verifies the pipeline compiles, builds, and runs to completion
// with a full 576-element vector per column through activation_quant
// -> GEMM (4 cols) -> scale.
#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>
#include <cstdlib>

static int compute_inv(int absmax) {
    return (int)round(32768.0 * 127.0 / absmax);
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_pipeline* dut = new Vternary_pipeline;
    int errors = 0;

    const int N = 576;

    // Generate synthetic activation data: ramp -127..127 repeating
    int8_t acts[N];
    for (int i = 0; i < N; i++)
        acts[i] = (int8_t)((i % 255) - 127);

    // Fixed ternary weights per column: +1, -1, 0, +1
    int weights[4] = {1, -1, 0, 1};
    int w_packed = 0;
    for (int c = 0; c < 4; c++)
        w_packed |= (weights[c] == 1 ? 1 : weights[c] == -1 ? 2 : 0) << (2 * c);

    // Per-channel scales (Q15). 1.0 = 32768; Q15 unsigned max is 65535
    // (~1.99997). An alpha of exactly 2.0 (65536) would wrap to 0 in the
    // 16-bit field, so use the saturated max 65535 instead.
    int alphas[4] = {32768, 16384, 65535, 32768};
    uint64_t alpha_packed = 0;
    for (int c = 0; c < 4; c++)
        alpha_packed |= (uint64_t)(uint16_t)alphas[c] << (c * 16);

    // Compute inv from max absolute activation
    int absmax = 127;
    int inv = compute_inv(absmax);
    printf("N=%d inv=%d\n", N, inv);

    // Reset
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    // Feed N activations
    for (int i = 0; i < N; i++) {
        dut->valid_in   = 1;
        dut->activation = acts[i];
        dut->inv        = inv;
        dut->weight_enc = w_packed;
        dut->alpha      = alpha_packed;
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
    }

    // Drain pipeline. valid_out pulses for exactly one cycle (scale's
    // valid_out = valid_in delayed 2 cycles, ~5 cycles after the last element),
    // so sample at clk=0 BEFORE advancing the clock — advancing clears it.
    dut->valid_in = 0;
    bool got_result = false;
    int32_t results[4] = {0};
    for (int i = 0; i < 20; i++) {
        dut->clk = 0; dut->eval();
        if (dut->valid_out) {
            got_result = true;
            for (int c = 0; c < 4; c++)
                results[c] = (int32_t)dut->result.at(c);
            break;
        }
        dut->clk = 1; dut->eval();
    }

    if (!got_result) {
        printf("FAIL: valid_out never asserted after %d elements\n", N);
        errors++;
    } else {
        printf("PASS: valid_out asserted, results: [%d, %d, %d, %d]\n",
               results[0], results[1], results[2], results[3]);
        // Reference: ramp sum = sum((i%255)-127, i=0..575) = -6237.
        // col0 (+1, alpha 1.0) = -6237; col1 (-1, alpha 0.5) = 6237/2 rounded = 3119;
        // col2 (0, alpha 2.0) = 0; col3 (+1, alpha 1.0) = -6237.
        const int32_t expected[4] = {-6237, 3119, 0, -6237};
        for (int c = 0; c < 4; c++) {
            if (results[c] != expected[c]) {
                printf("FAIL: col%d got %d, expected %d\n", c, results[c], expected[c]);
                errors++;
            }
        }
    }

    delete dut;
    printf("--- %d error(s) ---\n", errors);
    return errors ? 1 : 0;
}