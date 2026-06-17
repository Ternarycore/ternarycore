// Bypass quantizer: feed pre-quantized activations and corrected weights to GEMM through pipeline
#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    // Pre-quantized acts
    int8_t q[4] = {-29, 105, -114, 127};
    // WEIGHT_ENC must align: quantizer introduces 1-cycle delay
    // Pipeline captures weight_enc on valid_in, GEMM reads 1 cycle later
    // So we feed weights ONE cycle early in the test
    int w_d1[4] = {0, 168, 129, 41};  // 1-cycle early with 0 for first cycle
    int expected[4] = {-136, 143, 16, -203};
    uint64_t alpha = 0x8000800080008000ULL;
    int inv = 0; // unused when quantizer is bypassed... but it's still wired

    // Set weight_enc before valid_in for the pipeline's register
    dut->alpha = alpha;
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        // Set weight_enc BEFORE valid_in, so weight_enc_d1 captures it
        dut->weight_enc = w_d1[i];
        dut->clk = 0; dut->eval();  // weight_enc settles
        dut->valid_in = 1;
        dut->activation = q[i]; // direct quantized value
        dut->inv = inv;
        dut->clk = 1; dut->eval();  // posedge: weight_enc_d1 captured, quant starts
    }

    dut->valid_in = 0;
    dut->clk = 0; dut->eval();
    // Set the 4th weight for GEMM: weight_enc_d1 should have 162 from cycle 3
    dut->weight_enc = 162;
    dut->clk = 1; dut->eval();

    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out) {
            printf("[%d %d %d %d]\n",
                   (int32_t)dut->result.at(0), (int32_t)dut->result.at(1),
                   (int32_t)dut->result.at(2), (int32_t)dut->result.at(3));
            break;
        }
    }
    delete dut;
}
