// Deterministic randomized regression for the currently shipped ternary_dot.
//
// The RTL exposes valid_out as a level: it rises after the terminal input,
// while acc_out is latched on the following clock. A low valid_in recovery
// cycle is therefore required between vectors. This test deliberately models
// that interface instead of assuming a one-cycle pulse or zero-gap restart.
#include <verilated.h>
#include "Vternary_dot.h"

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <random>

namespace {

constexpr int kVectorLen = 8;
constexpr uint32_t kDefaultSeed = 0x54434f52u;

void tick(Vternary_dot* dut, bool valid, int8_t activation, uint8_t weight)
{
    dut->valid_in = valid;
    dut->activation = static_cast<uint8_t>(activation);
    dut->weight_enc = weight;
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
    dut->clk = 0;
    dut->eval();
}

void reset(Vternary_dot* dut)
{
    dut->rst_n = 0;
    for (int i = 0; i < 3; ++i)
        tick(dut, false, 0, 0);
    dut->rst_n = 1;
    tick(dut, false, 0, 0);
}

int32_t weighted_activation(int8_t activation, uint8_t weight)
{
    // Match ternary_weight.v: 00=0, 01=+1, every other code=-1.
    if (weight == 0)
        return 0;
    if (weight == 1)
        return activation;
    return -static_cast<int32_t>(activation);
}

}  // namespace

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);

    const uint32_t seed = argc > 1
        ? static_cast<uint32_t>(std::strtoul(argv[1], nullptr, 0))
        : kDefaultSeed;
    const int trials = argc > 2 ? std::atoi(argv[2]) : 2000;
    if (trials <= 0) {
        std::fprintf(stderr, "trials must be positive\n");
        return 2;
    }

    std::mt19937 rng(seed);
    Vternary_dot dut;
    int errors = 0;
    int vectors_checked = 0;

    std::printf("--- ternary_dot randomized test (VLEN=%d, seed=%u, trials=%d) ---\n",
                kVectorLen, seed, trials);

    for (int trial = 0; trial < trials; ++trial) {
        reset(&dut);
        const int vector_count = 1 + static_cast<int>(rng() % 3);

        for (int vector = 0; vector < vector_count; ++vector) {
            int32_t expected = 0;

            for (int item = 0; item < kVectorLen; ++item) {
                // Exercise arbitrary bubbles, including an extended recovery
                // gap before the next vector starts.
                const int bubbles = static_cast<int>(rng() % 3);
                for (int bubble = 0; bubble < bubbles; ++bubble)
                    tick(&dut, false, 0, 0);

                const int8_t activation = static_cast<int8_t>(rng() & 0xffu);
                const uint8_t weight = static_cast<uint8_t>(rng() & 0x3u);
                expected += weighted_activation(activation, weight);
                tick(&dut, true, activation, weight);

                if (vector > 0 && item == 0 && dut.valid_out) {
                    if (errors < 20)
                        std::printf("FAIL trial %d vector %d: valid_out did not clear on restart\n",
                                    trial, vector);
                    ++errors;
                }
            }

            if (!dut.valid_out) {
                if (errors < 20)
                    std::printf("FAIL trial %d vector %d: completion was not signaled\n",
                                trial, vector);
                ++errors;
            }

            // The shipped output register trails valid_out by one clock.
            tick(&dut, false, 0, 0);
            const int32_t actual = static_cast<int32_t>(dut.acc_out);
            if (!dut.valid_out || actual != expected) {
                if (errors < 20)
                    std::printf("FAIL trial %d vector %d: expected %d, got %d (valid=%d)\n",
                                trial, vector, expected, actual,
                                static_cast<int>(dut.valid_out));
                ++errors;
            }
            ++vectors_checked;
        }
    }

    std::printf("--- checked %d vectors; %d error(s) ---\n",
                vectors_checked, errors);
    return errors == 0 ? 0 : 1;
}
