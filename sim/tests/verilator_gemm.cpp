#include <verilated.h>
#include "Vternary_gemm.h"
#include <cstdio>
#include <cstdint>

static void tick(Vternary_gemm* dut) {
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_gemm* dut = new Vternary_gemm;

    int errors = 0;
    int act[4] = {1, 2, 3, 4};
    // Per-column weight_enc packed little-endian in 2-bit slices:
    //   col0 bits[1:0]=10 (-1), col1 [3:2]=01 (+1),
    //   col2 [5:4]=10 (-1),     col3 [7:6]=01 (+1)
    int w_const = 0b01100110;

    // Expected per column over depth=4 with constant weight:
    // col0 (-1): -(1+2+3+4) = -10
    // col1 (+1):   1+2+3+4  =  10
    // col2 (-1): -(1+2+3+4) = -10
    // col3 (+1):   1+2+3+4  =  10
    int exp[4] = {-10, 10, -10, 10};

    dut->rst_n = 0;
    dut->valid_in = 0;
    dut->activation = 0;
    dut->weight_enc = 0;
    for (int i = 0; i < 4; i++) tick(dut);
    dut->rst_n = 1;
    tick(dut);

    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1;
        dut->activation = (uint8_t)act[i];
        dut->weight_enc = w_const;
        tick(dut);
    }

    // Sticky valid_out; acc_out valid one posedge after terminal feed.
    dut->valid_in = 0;
    tick(dut);

    if (!dut->valid_out) {
        printf("FAIL: valid_out never asserted\n");
        errors++;
    } else {
        for (int c = 0; c < 4; c++) {
            int32_t got = (int32_t)dut->acc_out[c];
            if (got != exp[c]) {
                printf("FAIL col %d: got %d expected %d\n", c, (int)got, exp[c]);
                errors++;
            } else {
                printf("PASS col %d: %d\n", c, (int)got);
            }
        }
    }

    printf("--- %d error(s) ---\n", errors);
    delete dut;
    return errors ? 1 : 0;
}
