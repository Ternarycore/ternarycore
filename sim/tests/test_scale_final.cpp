#include <verilated.h>
#include "Vternary_scale.h"
#include <cstdio>
#include <cstdint>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_scale* dut = new Vternary_scale;
    int errors = 0;
    int32_t acc[4] = {100, 200, -100, -200};
    for (int c = 0; c < 4; c++) dut->acc_in.at(c) = (uint32_t)acc[c];
    dut->alpha = 0x8000800080008000ULL;  // alpha=1.0 per channel

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1; dut->valid_in = 1;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->valid_in = 0;

    if (dut->valid_out) {
        bool ok = true;
        for (int c = 0; c < 4; c++) {
            int32_t got = (int32_t)dut->result.at(c);
            if (got != acc[c]) ok = false;
        }
        printf("%s alpha=1.0\n", ok ? "PASS" : "FAIL"); if (!ok) errors++;
    }

    dut->alpha = 0x0001000100010001ULL;  // alpha=1/32768 ~= 0
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1; dut->valid_in = 1;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    if (dut->valid_out) {
        bool ok = true;
        for (int c = 0; c < 4; c++) {
            int32_t got = (int32_t)dut->result.at(c);
            if (got != 0) ok = false;
        }
        printf("%s alpha~0\n", ok ? "PASS" : "FAIL"); if (!ok) errors++;
    }
    delete dut; printf("--- %d error(s) ---\n", errors); return errors;
}
