// Direct GEMM test with known quantized activations
#include <verilated.h>
#include "Vternary_gemm.h"
#include <cstdio>

int main() {
    Vternary_gemm* dut = new Vternary_gemm;
    int8_t q[4] = {-29, 105, -114, 127};  // quantized activations
    int w[4] = {168, 129, 41, 162};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = q[i]; dut->weight_enc = w[i];
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
    }

    dut->valid_in = 0;
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            printf("[%d %d %d %d]\n",
                   (int32_t)dut->acc_out.at(0), (int32_t)dut->acc_out.at(1),
                   (int32_t)dut->acc_out.at(2), (int32_t)dut->acc_out.at(3));
    }
    delete dut;
}
