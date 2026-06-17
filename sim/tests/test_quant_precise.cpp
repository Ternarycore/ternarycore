#include <verilated.h>
#include "Vactivation_quant.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vactivation_quant* dut = new Vactivation_quant;
    int inv = round(32768.0 * 127.0 / 40.0);
    int8_t x[4] = {-9, 33, -36, 40};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    int8_t qv[4] = {0};
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->x = x[i]; dut->inv = inv;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        // Capture q when valid
        if (dut->valid_out) qv[i-1] = (int8_t)dut->q;  // q is from prev input
    }
    // Capture last q from drain
    dut->valid_in = 0;
    for (int i = 0; i < 3; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
        if (dut->valid_out) qv[3] = (int8_t)dut->q;
    }

    int sum = 0;
    printf("Quantized:\n");
    for (int i = 0; i < 4; i++) {
        printf("  x=%d -> q=%d\n", x[i], qv[i]);
        sum += qv[i];
    }
    printf("Sum = %d\n", sum);
    delete dut;
}
