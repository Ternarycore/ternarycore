// Back-to-back vector regression test for ternary_dot.
//
// Regression for two fixed bugs:
//   1. Back-to-back drop: the old `valid_in && (!vector_done || ...)` gate
//      dropped the first element of every vector that arrived on the cycle
//      right after a done edge, so the second vector's dot was wrong.
//   2. Sticky valid_out: vector_done never self-cleared, so valid_out stayed
//      high forever after the first done instead of pulsing exactly once.
//
// Protocol under test: two 4-element vectors fed back-to-back with valid_in
// high every cycle (no bubble). valid_out must pulse exactly once per vector,
// and acc_out must hold each vector's true dot product on its pulse.
#include <verilated.h>
#include "Vternary_dot.h"
#include <cstdio>
#include <cstdint>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vternary_dot* dut = new Vternary_dot;

    int errors = 0;

    // Two vectors of 4 elements. Vector A weights: +1,-1,+1,-1. Vector B: +1,+1,-1,-1.
    // weight_enc 2-bit: 00=0, 01=+1, 10=-1.
    int8_t act[8]  = {1, 2, 3, 4,    10, 20, 30, 40};
    int    w_enc[8] = {1, 2, 1, 2,   1,  1,  2,  2};
    // A = 1-2+3-4 = -2 ; B = 10+20-30-40 = -40
    int32_t expected[2] = {-2, -40};

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    // Feed both vectors back-to-back (valid_in high every cycle, no bubble).
    // Sample valid_out at clk=0 BEFORE the posedge: the pulse lives exactly
    // one cycle, so the posedge would clear it.
    int pulses = 0;
    int32_t results[2] = {0, 0};
    for (int i = 0; i < 8; i++) {
        dut->valid_in   = 1;
        dut->activation = act[i];
        dut->weight_enc = w_enc[i];
        dut->clk = 0; dut->eval();
        if (dut->valid_out && pulses < 2) {
            results[pulses] = (int32_t)dut->acc_out;
            pulses++;
        }
        dut->clk = 1; dut->eval();
    }

    // Drain: capture the second vector's pulse (still may appear here).
    dut->valid_in = 0;
    for (int i = 0; i < 5; i++) {
        dut->clk = 0; dut->eval();
        if (dut->valid_out && pulses < 2) {
            results[pulses] = (int32_t)dut->acc_out;
            pulses++;
        }
        dut->clk = 1; dut->eval();
    }

    if (pulses != 2) {
        printf("FAIL: expected 2 valid_out pulses (back-to-back vectors), got %d\n", pulses);
        errors++;
    }
    for (int v = 0; v < 2; v++) {
        if (pulses >= 2 && results[v] != expected[v]) {
            printf("FAIL: vector %d got %d, expected %d\n", v, results[v], expected[v]);
            errors++;
        } else if (pulses >= 2) {
            printf("PASS: vector %d = %d\n", v, results[v]);
        }
    }

    delete dut;
    printf("--- %d error(s) ---\n", errors);
    return errors ? 1 : 0;
}
