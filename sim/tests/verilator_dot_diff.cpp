#include <verilated.h>
#include "Vternary_dot.h"
#include <cstdio>
#include <cstdint>
#include <cstdlib>

#define VLEN 8

static uint32_t lcg_next(uint32_t *state) {
    *state = *state * 1103515245 + 12345;
    return *state;
}

// mirror device model + RTL pipeline: quant → dot → scale
static int8_t activation_quant(int8_t x) {
    int inv = 41615;
    int64_t prod = (int64_t)x * inv;
    int q = (int)((prod + (1 << 14)) >> 15);
    if (q > 127) q = 127;
    if (q < -127) q = -127;
    return (int8_t)q;
}

static int32_t scale_q15(int32_t acc, int alpha) {
    int64_t prod = (int64_t)acc * alpha;
    int32_t trunc = (int32_t)(prod & 0x7FFF);
    int round = (trunc != 0) ? 1 : 0;
    return (int32_t)(prod >> 15) + round;
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    if (argc < 2) { fprintf(stderr, "usage: %s <seed>\n", argv[0]); return 1; }
    uint32_t seed = (uint32_t)atol(argv[1]);
    uint32_t rng = seed;

    Vternary_dot *dut = new Vternary_dot;

    // reset
    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;
    dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();

    // generate random acts + weight_enc (same LCG as device model)
    int8_t act[2 * VLEN];
    int wenc[2 * VLEN];
    for (int i = 0; i < 2 * VLEN; i++) {
        rng = lcg_next(&rng);
        act[i]  = (int8_t)((int32_t)(rng % 256) - 128);
        rng = lcg_next(&rng);
        wenc[i] = (int)(rng % 3);
    }

    // drive the DUT (raw activations — the dot doesn't quantize)
    int pulses = 0;
    int32_t got[2] = {0, 0};
    for (int i = 0; i < 2 * VLEN; i++) {
        dut->valid_in   = 1;
        dut->activation = act[i];
        dut->weight_enc = wenc[i];
        dut->clk = 0; dut->eval();
        if (dut->valid_out && pulses < 2) {
            got[pulses] = (int32_t)dut->acc_out;
            pulses++;
        }
        dut->clk = 1; dut->eval();
    }
    // drain
    dut->valid_in = 0;
    for (int i = 0; i < 5 && pulses < 2; i++) {
        dut->clk = 0; dut->eval();
        if (dut->valid_out && pulses < 2) {
            got[pulses] = (int32_t)dut->acc_out;
            pulses++;
        }
        dut->clk = 1; dut->eval();
    }

    // compute the same quantized dot + scale that the device model uses
    int alpha = 32768;
    int32_t qdots[2], scaled[2];
    for (int v = 0; v < 2; v++) {
        int32_t acc = 0;
        for (int i = 0; i < VLEN; i++) {
            int idx = v * VLEN + i;
            int8_t q = activation_quant(act[idx]);
            int w = (wenc[idx] == 1) ? 1 : (wenc[idx] == 2) ? -1 : 0;
            acc += (int32_t)q * w;
        }
        qdots[v] = acc;
        scaled[v] = scale_q15(acc, alpha);
    }

    printf("RESULT: %d %d\n", got[0], got[1]);

    delete dut;
    return (pulses == 2) ? 0 : 1;
}