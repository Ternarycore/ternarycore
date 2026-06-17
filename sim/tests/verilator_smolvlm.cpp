// SmolVLM layer 0 gate_proj test through ternarycore pipeline
#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    int errors = 0;
    int8_t acts[4] = {-9, 33, -36, 40};
    int weight_rows[4] = {168, 129, 41, 162};
    int expected[4] = {-43, 45, 5, -64};
    uint64_t alpha = 0x8000800080008000ULL;
    int inv = round(32768.0 * 127.0 / 40.0);
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = acts[i]; dut->inv = inv;
        dut->weight_enc = weight_rows[i]; dut->alpha = alpha;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
    }
    dut->valid_in = 0;
    int32_t r[4] = {0};
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            for (int c = 0; c < 4; c++) r[c] = (int32_t)dut->result.at(c);
    }
    printf("SmolVLM gate_proj 4x4:\n");
    for (int c = 0; c < 4; c++) {
        printf("  col%d: HW=%d SW=%d %s\n", c, r[c], expected[c], r[c]==expected[c]?"OK":"MIS");
        if (r[c] != expected[c]) errors++;
    }
    printf("--- %d error(s) ---\n", errors);
    delete dut; return errors ? 1 : 0;
}
