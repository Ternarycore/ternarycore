#include <verilated.h>
#include "Vfp8_to_q15.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

int main() {
    Vfp8_to_q15* dut = new Vfp8_to_q15;
    int errors = 0;

    // E5M2 test cases
    struct Test { uint8_t fp8; int16_t exp_q15; const char* desc; };
    // 1.0 = 0 01111 00 = 0x3C
    // 2.0 = 0 10000 00 = 0x40
    // 0.5 = 0 01110 00 = 0x38
    // -1.0 = 1 01111 00 = 0xBC
    // 1.5 = 0 10000 10 = 0x42? No: 1.5 = 0 01111 10 = 0x3E
    // 0.0 = 0 00000 00 = 0x00
    Test cases[] = {
        {0x3C, 32768,  "1.0"},
        {0x40, 65536,  "2.0"},
        {0x38, 16384,  "0.5"},
        {0xBC, -32768, "-1.0"},
        {0x3E, 49152,  "1.5"},
        {0x00, 0,      "0.0"},
    };

    for (int i = 0; i < 6; i++) {
        dut->fp8 = cases[i].fp8;
        dut->eval();
        int16_t got = dut->q15;
        if (got != cases[i].exp_q15) {
            printf("FAIL: %s (0x%02x) => %d exp %d\n",
                   cases[i].desc, cases[i].fp8, got, cases[i].exp_q15);
            errors++;
        } else {
            printf("PASS: %s (0x%02x) => %d\n",
                   cases[i].desc, cases[i].fp8, got);
        }
    }
    delete dut; printf("--- %d error(s) ---\n", errors); return errors;
}
