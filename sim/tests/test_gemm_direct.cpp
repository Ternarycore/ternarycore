// Direct GEMM test — bypass quantizer
#include <verilated.h>
#include "Vternary_gemm.h"
#include <cstdio>

int main() {
    Vternary_gemm* dut = new Vternary_gemm;
    int8_t acts[4] = {-9, 33, -36, 40};  // raw activations
    int weight_rows[4] = {168, 129, 41, 162};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1;
        dut->activation = acts[i];
        dut->weight_enc = weight_rows[i];
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        printf("IN %d: act=%d valid_out=%d\n", i, dut->activation, dut->valid_out);
    }

    dut->valid_in = 0;
    int32_t r0=0,r1=0,r2=0,r3=0;
    for (int i = 0; i < 10; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            printf("OUT %d: valid_out=1 acc_out=[%d,%d,%d,%d]\n", i,
                   (int32_t)dut->acc_out,  // only shows low 32 bits of 128-bit acc_out
                   0,0,0);
    }
    delete dut;
}
