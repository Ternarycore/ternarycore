// Test GEMM with 1-cycle delayed weight_enc (simulating pipeline)
#include <verilated.h>
#include "Vternary_gemm.h"
#include <cstdio>

int main() {
    Vternary_gemm* dut = new Vternary_gemm;
    // Feed quantized activations & weights directly (as pipeline should)
    int8_t q[4] = {-29, 105, -114, 127};
    int w_raw[4] = {168, 129, 41, 162};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    // Simulate pipeline: activation and weight_enc_d1 with 1-cycle offset
    int w_d1[4] = {0, 168, 129, 41};  // 1-cycle delayed version
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1;
        dut->activation = q[i];
        dut->weight_enc = w_d1[i];
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            printf("EARLY valid_out at i=%d\n", i);
    }
    dut->valid_in = 0;
    // On cycle 5, weight_enc should be 162
    dut->weight_enc = 162;
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            printf("OUT: [%d %d %d %d]\n",
                   (int32_t)dut->acc_out.at(0), (int32_t)dut->acc_out.at(1),
                   (int32_t)dut->acc_out.at(2), (int32_t)dut->acc_out.at(3));
    }
    delete dut;
}
