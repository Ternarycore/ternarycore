#include <verilated.h>
#include "Vfp8_to_q15.h"
#include <cstdio>
#include <cstdint>

int main() {
    Vfp8_to_q15* dut = new Vfp8_to_q15;
    int errors = 0;
    // 2.0 overflows Q15 → saturates to 65535 (max Q15 ≈ 1.99997)
    struct Test { uint8_t fp8; uint16_t exp; const char* desc; };
    Test cases[] = {
        {0x3C, 32768,  "1.0"},
        {0x40, 65535,  "2.0 (sat)"},  // saturates to max Q15
        {0x38, 16384,  "0.5"},
        {0x3E, 49152,  "1.5"},
        {0x00, 0,      "0.0"},
    };
    for (int i = 0; i < 5; i++) {
        dut->fp8 = cases[i].fp8; dut->eval();
        if (dut->q15 != cases[i].exp) {
            printf("FAIL: %s => %d exp %d\n", cases[i].desc, dut->q15, cases[i].exp);
            errors++;
        } else printf("PASS: %s => %d\n", cases[i].desc, dut->q15);
    }
    delete dut; printf("--- %d error(s) ---\n", errors); return errors;
}
