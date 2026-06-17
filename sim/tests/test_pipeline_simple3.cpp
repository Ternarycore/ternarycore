#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    int8_t acts[4] = {-9, 33, -36, 40};
    int w_all_plus = 0x55;  // all cols = +1
    uint64_t alpha = 0x8000800080008000ULL;
    int inv = round(32768.0 * 127.0 / 40.0);
    // Quantized: round(-9*127/40)=-29, round(33*127/40)=105,
    //            round(-36*127/40)=-114, round(40*127/40)=127
    // Sum = -29+105-114+127 = 89
    int expected[4] = {89, 89, 89, 89};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = acts[i]; dut->weight_enc = w_all_plus;
        dut->alpha = alpha; dut->inv = inv;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
    }

    dut->valid_in = 0;
    int32_t r[4] = {0};
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            for (int c = 0; c < 4; c++) r[c] = (int32_t)dut->result.at(c);
    }

    printf("All+1 weights, mixed acts:\n");
    for (int c = 0; c < 4; c++)
        printf("  col%d: %d (exp %d) %s\n", c, r[c], expected[c],
               r[c]==expected[c]?"OK":"MIS");
    delete dut;
}
