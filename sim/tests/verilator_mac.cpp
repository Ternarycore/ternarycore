#include <verilated.h>
#include "Vternary_mac.h"

#include <cstdint>
#include <cstdio>

namespace {

void tick(Vternary_mac& dut)
{
    dut.clk = 0;
    dut.eval();
    dut.clk = 1;
    dut.eval();
    dut.clk = 0;
    dut.eval();
}

}  // namespace

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);
    Vternary_mac dut;

    int errors = 0;
    struct TestCase {
        int8_t activation;
        uint8_t weight;
        int32_t acc_in;
        int32_t expected;
    };
    const TestCase cases[] = {
        {10,   0b01,  0,  10},   // +1
        {25,   0b01, 10,  35},
        {10,   0b10, 35,  25},   // -1
        {25,   0b10, 25,   0},
        {99,   0b00, 42,  42},   // zero
        {127,  0b00,  0,   0},
        {-5,   0b01,  0,  -5},
        {-5,   0b10,  0,   5},
        {-128, 0b10,  0, 128},   // widened negation must not overflow int8
        {-128, 0b11,  7, 135},   // reserved code follows RTL's -1 path
    };

    dut.rst_n = 0;
    dut.valid_in = 0;
    for (int i = 0; i < 3; ++i)
        tick(dut);
    dut.rst_n = 1;
    tick(dut);

    for (const auto& test : cases) {
        dut.valid_in = 1;
        dut.activation = static_cast<uint8_t>(test.activation);
        dut.weight_enc = test.weight;
        dut.acc_in = test.acc_in;
        tick(dut);

        if (!dut.valid_out || static_cast<int32_t>(dut.acc_out) != test.expected) {
            std::printf("FAIL: act=%d weight=%u acc_in=%d => valid=%d got=%d expected=%d\n",
                        static_cast<int>(test.activation), test.weight, test.acc_in,
                        static_cast<int>(dut.valid_out),
                        static_cast<int32_t>(dut.acc_out), test.expected);
            ++errors;
        }

        dut.valid_in = 0;
        tick(dut);

        if (dut.valid_out) {
            std::printf("FAIL: valid_out remained high after valid_in cleared\n");
            ++errors;
        }
    }

    std::printf("--- checked %zu MAC cases; %d error(s) ---\n",
                sizeof(cases) / sizeof(cases[0]), errors);
    return errors == 0 ? 0 : 1;
}
