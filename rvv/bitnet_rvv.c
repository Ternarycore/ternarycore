#include <riscv_vector.h>

typedef unsigned char      u8;
typedef signed char        i8;
typedef unsigned short     u16;
typedef          int       i32;
typedef          long long i64;

void decode(const u8 *packed, i8 *pos, i8 *neg, int cols, int vlen) {
    for (int c = 0; c < cols; c++)
        for (int k = 0; k < vlen / 4; k++) {
            u8 byte = packed[c * (vlen / 4) + k];
            for (int b = 0; b < 4; b++) {
                int idx = 4 * k + b;
                u8 enc = (byte >> (2 * b)) & 3;
                pos[c * vlen + idx] = (enc == 1) ? 1 : 0;
                neg[c * vlen + idx] = (enc == 2) ? 1 : 0;
            }
        }
}

static i32 dot(const i8 *acts, const i8 *pos, const i8 *neg, int vlen) {
    i32 acc = 0;
    size_t vl;

    for (size_t k = 0; k < vlen; k += vl) {
        vl = __riscv_vsetvl_e8m1(vlen - k);

        // Load int8, widen to int16
        vint16m2_t v_act16 = __riscv_vsext_vf2_i16m2(
            __riscv_vle8_v_i8m1(acts + k, vl), vl);
        vint16m2_t v_p16 = __riscv_vsext_vf2_i16m2(
            __riscv_vle8_v_i8m1(pos + k, vl), vl);
        vint16m2_t v_n16 = __riscv_vsext_vf2_i16m2(
            __riscv_vle8_v_i8m1(neg + k, vl), vl);

        // Widening multiply int16→int32
        vint32m4_t v_mul_p = __riscv_vwmul_vv_i32m4(v_act16, v_p16, vl);
        vint32m4_t v_mul_n = __riscv_vwmul_vv_i32m4(v_act16, v_n16, vl);
        vint32m4_t v_diff  = __riscv_vsub_vv_i32m4(v_mul_p, v_mul_n, vl);

        // Reduce
        vint32m1_t v_one = __riscv_vmv_v_x_i32m1(0, 1);
        vint32m1_t v_red = __riscv_vredsum_vs_i32m4_i32m1(v_diff, v_one, vl);
        acc += __riscv_vmv_x_s_i32m1_i32(v_red);
    }
    return acc;
}

void gemm(const i8 *acts, const u8 *packed, const u16 *alphas,
          i32 *results, int cols, int vlen) {
    #define MAX_C 4
    #define MAX_V 64
    static i8 pos[MAX_C * MAX_V];
    static i8 neg[MAX_C * MAX_V];
    decode(packed, pos, neg, cols, vlen);

    for (int c = 0; c < cols; c++) {
        i32 d = dot(acts, pos + c * vlen, neg + c * vlen, vlen);
        results[c] = ((i64)d * (i64)alphas[c]) >> 15;
    }
}
