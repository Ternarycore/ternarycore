#include <verilated.h>
#include "Vternary_pipeline.h"
#include <cstdio>
#include <cstdint>
#include <cmath>

static int compute_inv(int absmax) {
    return round(32768.0 * 127.0 / absmax);
}

int main() {
    Vternary_pipeline* dut = new Vternary_pipeline;
    int8_t acts[4] = {10, 20, 30, 40};
    int w_packed = (2<<6)|(1<<4)|(2<<2)|(1<<0); // col: +1,-1,+1,-1
    uint64_t alpha_packed = (uint64_t)32768<<48 | (uint64_t)65536<<32 |
                            (uint64_t)16384<<16 | (uint64_t)32768;
    int inv = compute_inv(40);

    dut->rst_n = 0;
    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }
    dut->rst_n = 1;

    int cycle = 0;
    for (int i = 0; i < 4; i++) {
        dut->valid_in = 1; dut->activation = acts[i];
        dut->inv = inv; dut->weight_enc = w_packed; dut->alpha = alpha_packed;
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); cycle++;
        printf("C%02d in:  act=%3d q_valid=%d gemm_valid=%d scale_valid=%d valid_out=%d\n",
               cycle, dut->activation, dut->quant->valid_out,
               dut->gemm->valid_out, dut->scale->valid_out, dut->valid_out);
    }

    dut->valid_in = 0;
    for (int i = 0; i < 15; i++) {
        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); cycle++;
        printf("C%02d out: q_valid=%d gemm_valid=%d scale_valid=%d valid_out=%d",
               cycle, dut->quant->valid_out,
               dut->gemm->valid_out, dut->scale->valid_out, dut->valid_out);
        if (dut->valid_out) {
            printf(" result=[%d,%d,%d,%d]",
                   (int32_t)dut->result.at(0), (int32_t)dut->result.at(1),
                   (int32_t)dut->result.at(2), (int32_t)dut->result.at(3));
        }
        printf("\n");
    }
    delete dut;
}
