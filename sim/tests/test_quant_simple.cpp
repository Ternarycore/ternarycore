#include <verilated.h>
#include "Vactivation_quant.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vactivation_quant* dut = new Vactivation_quant;
    int inv = round(32768.0 * 127.0 / 40.0);
    printf("inv=%d\n", inv);

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    int8_t acts[4] = {10, 20, 30, 40};
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->x = acts[i]; dut->inv = inv;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        printf("IN %d: x=%d q_valid=%d q=%d\n", i, acts[i], dut->valid_out, (int8_t)dut->q);
    }

    dut->valid_in = 0;
    for (int i = 0; i < 5; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        printf("OUT %d: q_valid=%d q=%d\n", i, dut->valid_out, (int8_t)dut->q);
    }
    delete dut;
}
