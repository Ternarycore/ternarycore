#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    int8_t acts[4] = {10, 20, 30, 40};
    int w_packed = 0x99; // col0=+1, col1=-1, col2=+1, col3=-1
    uint64_t alpha_packed = (uint64_t)32768 << 48 | (uint64_t)32768 << 32 |
                            (uint64_t)16384 << 16 | (uint64_t)32768;
    int inv = round(32768.0 * 127.0 / 40.0);

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = acts[i]; dut->inv = inv;
        dut->weight_enc = w_packed; dut->alpha = alpha_packed;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
    }

    dut->valid_in = 0;
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        printf("C%02d: v_out=%d res=[%d, %d, %d, %d]\n",
               i, dut->valid_out,
               (int32_t)dut->result.at(0), (int32_t)dut->result.at(1),
               (int32_t)dut->result.at(2), (int32_t)dut->result.at(3));
    }
    delete dut;
}
