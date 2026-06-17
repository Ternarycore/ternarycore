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

    // Per-channel scales (Q15)
    int alphas[4] = {32768, 16384, 65536, 32768};
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

    // Drain pipeline
    dut->valid_in = 0;
    bool got_result = false;
    int32_t results[4] = {0};
    for (int i = 0; i < 20; i++) {
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        if (dut->valid_out) {
            got_result = true;
            for (int c = 0; c < 4; c++)
                results[c] = (int32_t)dut->result.at(c);
            break;
        }
    }

    if (!got_result) {
        printf("FAIL: valid_out never asserted after %d elements\n", N);
        errors++;
    } else {
        printf("PASS: valid_out asserted, results: [%d, %d, %d, %d]\n",
               results[0], results[1], results[2], results[3]);
    }

    delete dut;
    printf("--- %d error(s) ---\n", errors);
    return errors ? 1 : 0;
}