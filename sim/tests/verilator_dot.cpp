#include <verilated.h>
#include "Vternary_dot.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_dot* dut = new Vternary_dot;

    int errors = 0;
    int act[8] = {1, -1, 2, -2, 3, -3, 4, -4};
    int w[8][2] = {{0,1},{1,0},{0,1},{1,0},{0,0},{0,1},{1,0},{0,1}}; // +1,-1,+1,-1,0,+1,-1,+1
    int expected = (1*1) + (-1*-1) + (2*1) + (-2*-1) + (3*0) + (-3*1) + (4*-1) + (-4*1);
    // = 1 + 1 + 2 + 2 + 0 + -3 + -4 + -4 = -5

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    // Stream 8 elements
    for (int i = 0; i < 8; i++) {
        dut->valid_in = 1;
        dut->activation = act[i];
        dut->weight_enc = (w[i][0] << 1) | w[i][1];
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
    }

    // Wait for valid_out. It pulses high for exactly one cycle (between the
    // last feed posedge and the following posedge), so sample it at clk=0
    // BEFORE advancing the clock — advancing first would clear it.
    dut->valid_in = 0;
    for (int i = 0; i < 5; i++) {
        dut->clk = 0; dut->eval();
        if (dut->valid_out) {
            printf("PASS: dot product = %d (expected %d)\n", (int32_t)dut->acc_out, expected);
            if ((int32_t)dut->acc_out != expected) errors++;
            break;
        }
        dut->clk = 1; dut->eval();
    }
    if (!dut->valid_out) { printf("FAIL: valid_out never asserted\n"); errors++; }

    delete dut;
    printf("--- %d error(s) ---\n", errors);
    return errors ? 1 : 0;
}
