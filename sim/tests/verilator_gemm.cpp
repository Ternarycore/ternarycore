#include <verilated.h>
#include "Vternary_gemm.h"
#include <cstdio>
#include <cstdint>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_gemm* dut = new Vternary_gemm;

    int errors = 0;
    int act[4] = {1,2,3,4};
    int w_const = 0b01100110;  // col: 01 (+1), 10 (-1), 01 (+1), 10 (-1)

    // Expected: for each column, sum of (activation_i * weight_i) over depth
    // col0 (-1): -(1+2+3+4) = -10
    // col1 (+1):   1+2+3+4  =  10
    // col2 (-1): -(1+2+3+4) = -10
    // col3 (+1):   1+2+3+4  =  10
    int exp[4] = {-10, 10, -10, 10};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1;
        dut->activation = act[i];
        dut->weight_enc = w_const;
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
    }

    dut->valid_in = 0;
    bool found = false;
    for (int i = 0; i < 5 && !found; i++) {
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        if (dut->valid_out) {
            found = true;
            for (int c = 0; c < 4; c++) {
                int32_t got = dut->acc_out[c];  // VlWide accessor
                if (got != exp[c]) {
                    printf("FAIL col %d: got %d expected %d\n", c, (int)got, exp[c]);
                    errors++;
                }
            }
        }
    }
    if (!found) { printf("FAIL: valid_out never asserted\n"); errors++; }

    printf("--- %d error(s) ---\n", errors);
    delete dut;
    return errors ? 1 : 0;
}
