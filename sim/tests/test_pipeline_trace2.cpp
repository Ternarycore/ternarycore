#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    int8_t acts[4] = {-9, 33, -36, 40};
    int weight_rows[4] = {168, 129, 41, 162};
    uint64_t alpha = 0x8000800080008000ULL;
    int inv = round(32768.0 * 127.0 / 40.0);
    int errors = 0;

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    int cycle = -4;
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = acts[i]; dut->inv = inv;
        dut->weight_enc = weight_rows[i]; dut->alpha = alpha;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); cycle++;
    }
    dut->valid_in = 0;
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); cycle++;
        if (dut->valid_out)
            printf("valid_out at cycle %d: [%d %d %d %d]\n", cycle,
                   (int32_t)dut->result.at(0), (int32_t)dut->result.at(1),
                   (int32_t)dut->result.at(2), (int32_t)dut->result.at(3));
    }

    // Re-check: expected with correct pipeline alignment
    int sw[4] = {-136, 143, 16, -203};
    printf("\nExpected: [-136, 143, 16, -203]\n");
    delete dut;
}
