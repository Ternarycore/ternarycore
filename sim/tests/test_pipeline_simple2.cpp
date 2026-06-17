#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    // Simpler: acts = all 1s, weights = all +1s
    int8_t acts[4] = {1, 1, 1, 1};
    // All +1 weights: col encoding 01 = +1
    // pack = 01|01|01|01 = 0x55
    int w_all_plus = 0x55;
    uint64_t alpha = 0x8000800080008000ULL;
    int inv = round(32768.0 * 127.0 / 1.0);  // absmax=1
    // Expected: q = round(1*127/1) = 127 for all, so each col = 127
    // Each col has weight +1, so dot = 127+127+127+127 = 508
    // alpha=1.0 => 508
    int expected[4] = {508, 508, 508, 508};

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

    printf("All-1s test:\n");
    for (int c = 0; c < 4; c++)
        printf("  col%d: %d (exp %d) %s\n", c, r[c], expected[c],
               r[c]==expected[c]?"OK":"MIS");
    delete dut;
}
