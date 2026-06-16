#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    int8_t acts[4] = {10, 20, 30, 40};
    int w_packed = (2<<6)|(1<<4)|(2<<2)|(1<<0);
    // alpha=1.0 for all cols (alpha_2=65536 overflows to 0)
    uint64_t alpha_packed = (uint64_t)32768 << 48 | (uint64_t)0 << 32 |
                            (uint64_t)16384 << 16 | (uint64_t)32768;
    int inv = round(32768.0 * 127.0 / 40.0);
    printf("inv=%d\n", inv);

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = acts[i]; dut->inv = inv;
        dut->weight_enc = w_packed; dut->alpha = alpha_packed;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
    }

    dut->valid_in = 0;
    int result_cycle = -1;
    int32_t results[4] = {0};
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out && result_cycle < 0) {
            result_cycle = i;
            for (int c = 0; c < 4; c++) results[c] = (int32_t)dut->result.at(c);
        }
    }

    printf("valid_out fired at drain cycle %d\n", result_cycle);
    printf("result: col0=%d col1=%d col2=%d col3=%d\n",
           results[0], results[1], results[2], results[3]);

    // Expected with full quantization: 32+64+96+127 = 319 per col
    // col 0 (+1, alpha=1.0): 319
    // col 1 (-1, alpha=0.5): -319 * 16384 / 32768 = -159.5 -> -160
    // col 2 (+1, alpha=0): 0
    // col 3 (-1, alpha=1.0): -319
    printf("expected: col0=319 col1=-160 col2=0 col3=-319\n");

    delete dut;
}
