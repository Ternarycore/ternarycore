#include <verilated.h>
#include "Vactivation_quant.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vactivation_quant* dut = new Vactivation_quant;
    int8_t x[4] = {-9, 33, -36, 40};
    int inv = round(32768.0 * 127.0 / 40.0);
    printf("inv=%d\n", inv);

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    int8_t qv[4] = {0};
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->x = x[i]; dut->inv = inv;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        qv[i] = (int8_t)dut->q;
        printf("IN %d: x=%d q_valid=%d q=%d\n", i, x[i], dut->valid_out, (int8_t)dut->q);
    }
    dut->valid_in = 0;
    for (int i = 0; i < 5; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out && i == 0) qv[3] = (int8_t)dut->q;  // last q comes on first drain
        printf("OUT %d: q_valid=%d q=%d\n", i, dut->valid_out, (int8_t)dut->q);
    }
    // Compute expected dot product
    int w[4][4] = {{0,1,1,-1}, {-1,0,-1,0}, {-1,0,-1,-1}, {-1,-1,0,-1}};
    printf("\nQuantized acts: [%d, %d, %d, %d]\n", qv[0], qv[1], qv[2], qv[3]);
    for (int c = 0; c < 4; c++) {
        int dot = 0;
        for (int k = 0; k < 4; k++) dot += qv[k] * w[c][k];
        printf("  col%d expected dot=%d\n", c, dot);
    }
    delete dut;
}
