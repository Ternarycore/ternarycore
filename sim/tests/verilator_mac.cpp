#include <verilated.h>
#include "Vternary_mac.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_mac* dut = new Vternary_mac;

    int errors = 0;
    struct TestCase { int act; int w[2]; int acc_in; int expected; };
    TestCase cases[] = {
        {10,  {0,1}, 0, 10},   // w=+1
        {25,  {0,1}, 10, 35},
        {10,  {1,0}, 35, 25},  // w=-1
        {25,  {1,0}, 25, 0},
        {99,  {0,0}, 42, 42},  // w=0
        {127, {0,0}, 0, 0},
        {-5,  {0,1}, 0, -5},   // signed
        {-5,  {1,0}, 0, 5},
    };
    int n = sizeof(cases) / sizeof(cases[0]);

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    for (int i = 0; i < n; i++) {
        auto& c = cases[i];
        dut->valid_in = 1;
        dut->activation = c.act;
        dut->weight_enc = (c.w[0] << 1) | c.w[1];
        dut->acc_in = c.acc_in;

        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();  // posedge: pipeline in

        dut->valid_in = 0;
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();  // posedge: pipeline out

        if (dut->acc_out != (int32_t)c.expected) {
            printf("FAIL: act=%d w=%d acc_in=%d => got %d expected %d\n",
                   c.act, (c.w[0]<<1|c.w[1]), c.acc_in, dut->acc_out, c.expected);
            errors++;
        } else {
            printf("PASS: act=%d w=%d acc_in=%d => %d\n",
                   c.act, (c.w[0]<<1|c.w[1]), c.acc_in, dut->acc_out);
        }
    }

    delete dut;
    printf("--- %d error(s) ---\n", errors);
    return errors ? 1 : 0;
}
