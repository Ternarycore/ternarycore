// Fuzz test for ternary_dot — random activations/weights/valid_in with reference.
// VECTOR_LEN=8 (set by -GVECTOR_LEN=8 in the Makefile).
// Supports CLI args: argv[1]=seed, argv[2]=trials
#include <verilated.h>
#include "Vternary_dot.h"
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <ctime>

#define VLEN 8

static int32_t reference_dot(const int8_t *acts, const int *wenc, int n) {
    int32_t acc = 0;
    for (int i = 0; i < n; i++) {
        int8_t w = (wenc[i] == 1) ? 1 : (wenc[i] == 2) ? -1 : 0;
        acc += (int32_t)acts[i] * w;
    }
    return acc;
}

static void drive(Vternary_dot *dut, int valid, int8_t act, int wenc) {
    dut->valid_in = valid;
    dut->activation = act;
    dut->weight_enc = wenc;
    dut->clk = 0; dut->eval();
    dut->clk = 1; dut->eval();
}

// Sample valid_out at clk=0 (pre-posedge) and capture on rising edge.
// Returns 1 if captured, 0 otherwise.
static int sample_vo(Vternary_dot *dut, int *result, int *prev_vo) {
    dut->valid_in = 0;
    dut->clk = 0; dut->eval();
    int vo = dut->valid_out;
    if (vo && !*prev_vo) {
        *result = (int32_t)dut->acc_out;
        *prev_vo = vo;
        dut->clk = 1; dut->eval();
        return 1;
    }
    *prev_vo = vo;
    dut->clk = 1; dut->eval();
    return 0;
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    int seed = (argc > 1) ? atoi(argv[1]) : (int)time(nullptr);
    int trials = (argc > 2) ? atoi(argv[2]) : 2000;
    int half = trials / 2;
    int quart = trials / 4;

    Vternary_dot *dut = new Vternary_dot;
    int errors = 0;

    printf("--- ternary_dot fuzz test (VLEN=%d, seed %d, %d trials) ---\n",
           VLEN, seed, trials);

    auto reset = [&]() {
        dut->rst_n = 0; dut->valid_in = 0;
        for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
        dut->rst_n = 1;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();
    };

    srand(seed);

    // Phase 1: single vectors, capture on rising edge of valid_out
    printf("Phase 1: single vectors with random bubbles...\n");
    for (int t = 0; t < half; t++) {
        reset();
        int8_t act[VLEN]; int wenc[VLEN]; int valid[VLEN]; int fc = 0;
        for (int i = 0; i < VLEN; i++) {
            act[i] = (int8_t)(rand() % 256 - 128);
            wenc[i] = rand() % 3;
            valid[i] = (rand() % 5 != 0) ? 1 : 0;
            if (valid[i]) fc++;
        }
        if (fc < VLEN) { t--; continue; }
        for (int i = 0; i < VLEN; i++) drive(dut, valid[i], act[i], wenc[i]);

        int result = 0, pvo = 0, captured = 0;
        for (int i = 0; i < 10 && !captured; i++)
            captured = sample_vo(dut, &result, &pvo);

        int exp = reference_dot(act, wenc, VLEN);
        if (!captured) { printf("FAIL t%d: no pulse\n", t); errors++; }
        else if (result != exp) {
            printf("FAIL t%d: expected %d, got %d\n", t, exp, result);
            errors++;
        }
    }

    // Phase 2: back-to-back (no bubbles) — capture inline during feed
    printf("Phase 2: back-to-back vectors...\n");
    for (int t = 0; t < quart; t++) {
        reset();
        int8_t act[2*VLEN]; int wenc[2*VLEN];
        for (int i = 0; i < 2*VLEN; i++) {
            act[i] = (int8_t)(rand() % 256 - 128);
            wenc[i] = rand() % 3;
        }
        int got[2] = {0,0}, pvo = 0, pulses = 0;
        for (int i = 0; i < 2*VLEN; i++) {
            dut->valid_in = 1; dut->activation = act[i]; dut->weight_enc = wenc[i];
            dut->clk = 0; dut->eval();
            if (dut->valid_out && !pvo && pulses < 2) { got[pulses] = (int32_t)dut->acc_out; pulses++; }
            pvo = dut->valid_out;
            dut->clk = 1; dut->eval();
        }
        for (int i = 0; i < 5 && pulses < 2; i++) {
            dut->valid_in = 0; dut->clk = 0; dut->eval();
            if (dut->valid_out && !pvo && pulses < 2) { got[pulses] = (int32_t)dut->acc_out; pulses++; }
            pvo = dut->valid_out;
            dut->clk = 1; dut->eval();
        }
        int32_t e[2] = {reference_dot(act, wenc, VLEN), reference_dot(act+VLEN, wenc+VLEN, VLEN)};
        if (pulses != 2) { printf("FAIL b2b t%d: got %d pulses\n", t, pulses); errors++; }
        else { for (int v = 0; v < 2; v++) if (got[v] != e[v]) {
            printf("FAIL b2b t%d vec%d: expected %d, got %d\n", t, v, e[v], got[v]);
            errors++; }
        }
    }

    // Phase 3: inter-vector gap — sample first result, gap, feed second, sample second
    printf("Phase 3: vectors with inter-vector gap...\n");
    for (int t = 0; t < quart; t++) {
        reset();
        int8_t act[2*VLEN]; int wenc[2*VLEN];
        for (int i = 0; i < 2*VLEN; i++) {
            act[i] = (int8_t)(rand() % 256 - 128);
            wenc[i] = rand() % 3;
        }
        for (int i = 0; i < VLEN; i++) drive(dut, 1, act[i], wenc[i]);

        int r0 = 0, pvo = 0;
        for (int i = 0; i < 5; i++) sample_vo(dut, &r0, &pvo);

        int gap = rand() % 4;
        for (int i = 0; i < gap; i++) drive(dut, 0, 0, 0);
        for (int i = 0; i < VLEN; i++) drive(dut, 1, act[VLEN+i], wenc[VLEN+i]);

        int r1 = 0; pvo = 0;
        for (int i = 0; i < 5; i++) sample_vo(dut, &r1, &pvo);

        int32_t e0 = reference_dot(act, wenc, VLEN);
        int32_t e1 = reference_dot(act+VLEN, wenc+VLEN, VLEN);
        if (r0 != e0) { printf("FAIL gap t%d vec0: expected %d, got %d\n", t, e0, r0); errors++; }
        if (r1 != e1) { printf("FAIL gap t%d vec1: expected %d, got %d\n", t, e1, r1); errors++; }
    }

    delete dut;
    printf("--- %d error(s) out of %d trials ---\n", errors, trials);
    return errors ? 1 : 0;
}