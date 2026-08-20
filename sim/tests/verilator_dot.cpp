#include <verilated.h>
#include "Vternary_dot.h"
#include <cstdio>
#include <cstdint>

// Clock helper: drive one full cycle ending after posedge eval.
static void tick(Vternary_dot* dut) {
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_dot* dut = new Vternary_dot;

    int errors = 0;
    int act[8] = {1, -1, 2, -2, 3, -3, 4, -4};
    // weight_enc: 00=0, 01=+1, 10=-1
    int w_enc[8] = {0b01, 0b10, 0b01, 0b10, 0b00, 0b01, 0b10, 0b01};
    int expected = (1 * 1) + (-1 * -1) + (2 * 1) + (-2 * -1) + (3 * 0) + (-3 * 1) + (4 * -1) + (-4 * 1);
    // = 1 + 1 + 2 + 2 + 0 + -3 + -4 + -4 = -5

    dut->rst_n = 0;
    dut->valid_in = 0;
    dut->activation = 0;
    dut->weight_enc = 0;
    for (int i = 0; i < 4; i++) tick(dut);
    dut->rst_n = 1;
    tick(dut);

    // Stream 8 elements (VECTOR_LEN=8)
    for (int i = 0; i < 8; i++) {
        dut->valid_in = 1;
        dut->activation = (uint8_t)act[i];
        dut->weight_enc = w_enc[i];
        tick(dut);
    }

    // Main RTL: valid_out = vector_done is sticky; acc_out updates on the
    // *next* posedge after vector_done rises (separate always block).
    // Match tb_ternary_dot.v: drop valid_in, wait one more posedge, then sample.
    dut->valid_in = 0;
    tick(dut);

    if (!dut->valid_out) {
        printf("FAIL: valid_out never asserted\n");
        errors++;
    } else {
        int32_t got = (int32_t)dut->acc_out;
        if (got != expected) {
            printf("FAIL: dot product = %d (expected %d)\n", got, expected);
            errors++;
        } else {
            printf("PASS: dot product = %d (expected %d)\n", got, expected);
        }
    }

    delete dut;
    printf("--- %d error(s) ---\n", errors);
    return errors ? 1 : 0;
}
