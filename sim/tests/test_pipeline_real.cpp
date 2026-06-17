#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    // Raw activations (not pre-quantized)
    int8_t acts[4] = {-9, 33, -36, 40};
    // weight_enc: quantizer delays acts by 1 cycle, weight_enc_d1 captures on valid_in
    // So weight_enc[i] is captured at cycle i and read by GEMM at cycle i+1
    int w[4] = {168, 129, 41, 162};
    uint64_t alpha = 0x8000800080008000ULL;
    int inv = round(32768.0 * 127.0 / 40.0);
    int errors = 0;

    // Expected: with quantized acts [-29, 105, -114, 127], weight_aligned correctly
    // GEMM processes at cycles 1-4: q_valid fires
    // weight_enc_d1 captured at cycles 0-3
    // GEMM sees weight_enc_d1[0]=168 @ cycle1, [1]=129 @ cycle2, [2]=41 @ cycle3, [3]=162 @ cycle4
    // => [-136, 143, 16, -203]
    int expected[4] = {-136, 143, 16, -203};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1;
        dut->activation = acts[i];
        dut->weight_enc = w[i];
        dut->alpha = alpha;
        dut->inv = inv;
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
    }

    dut->valid_in = 0;
    int32_t r[4] = {0};
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out)
            for (int c = 0; c < 4; c++)
                r[c] = (int32_t)dut->result.at(c);
    }

    printf("Pipeline with weight_enc_d1:\n");
    for (int c = 0; c < 4; c++) {
        printf("  col%d: HW=%d SW=%d %s\n", c, r[c], expected[c],
               r[c] == expected[c] ? "OK" : "MIS");
        if (r[c] != expected[c]) errors++;
    }
    printf("--- %d error(s) ---\n", errors);
    delete dut; return errors;
}
