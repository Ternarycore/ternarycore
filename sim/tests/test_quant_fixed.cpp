#include <verilated.h>
#include "Vactivation_quant.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

static int compute_inv(int absmax) {
    return round(32768.0 * 127.0 / absmax);
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vactivation_quant* dut = new Vactivation_quant;
    int errors = 0;
    struct Test { int8_t x; int absmax; int8_t exp; };
    Test cases[] = {
        {50,  6,   127}, {100, 6,   127}, {127, 6,   127}, {-50, 6,   -127},
        {0,   6,   0},   {1,   200, 1},   {100, 200, 64},  {127, 200, 81},
    };
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;
    for (int i = 0; i < 8; i++) {
        auto& c = cases[i];
        int inv = compute_inv(c.absmax);
        dut->valid_in = 1; dut->x = c.x; dut->inv = inv;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        dut->valid_in = 0;
        if ((int8_t)dut->q != c.exp) { printf("FAIL\n"); errors++; }
    }
    delete dut; printf("--- %d error(s) ---\n", errors); return errors;
}
