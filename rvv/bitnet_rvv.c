#include <riscv_vector.h>
#include "bitnet_rvv.h"

typedef unsigned char      u8;
typedef signed char        i8;
typedef unsigned short     u16;
typedef signed short       i16;
typedef unsigned int       u32;
typedef          int       i32;
typedef          long long i64;

// Max columns and vector length supported by the static pos/neg buffers.
#define MAX_C TERNARYCORE_RVV_MAX_COLS
#define MAX_V TERNARYCORE_RVV_MAX_VECTOR_LEN
#define Q_MAX 127
#define Q_MIN -127

// Weight buffer layout (matches GVSoC device model):
//   packed[k] = {col3[k]:2, col2[k]:2, col1[k]:2, col0[k]:2}
//   where bits 1:0 = col0, bits 3:2 = col1, bits 5:4 = col2, bits 7:6 = col3
static void decode(const u8 *packed, i8 *pos, i8 *neg, int cols, int vlen) {
    for (int c = 0; c < cols; c++)
        for (int k = 0; k < vlen; k++) {
            u8 enc = (packed[k] >> (2 * c)) & 3;
            pos[c * vlen + k] = (enc == 1) ? 1 : 0;
            // ternary_weight.v maps every non-00/non-01 code to -1,
            // including the reserved 2'b11 encoding.
            neg[c * vlen + k] = (enc >= 2) ? 1 : 0;
        }
}

static i32 dot(const i8 *acts, const i8 *pos, const i8 *neg, int vlen) {
    i32 acc = 0;
    size_t vl;

    for (size_t k = 0; k < (size_t)vlen; k += vl) {
        vl = __riscv_vsetvl_e8m1((size_t)vlen - k);

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
        vint32m1_t v_zero = __riscv_vmv_v_x_i32m1(0, vl);
        vint32m1_t v_red = __riscv_vredsum_vs_i32m4_i32m1(v_diff, v_zero, vl);
        acc += __riscv_vmv_x_s_i32m1_i32(v_red);
    }
    return acc;
}

static i64 arithmetic_shift_right(i64 value, unsigned int bits) {
    const i64 divisor = (i64)1 << bits;
    if (value >= 0)
        return value / divisor;
    return -((-value + divisor - 1) / divisor);
}

// Quantize a single activation: q = clip((x * inv + 2^14) >> 15, -127, 127)
// Mirrors activation_quant.v and the device model quantize_activation().
static i8 quantize(i32 x, u32 inv) {
    i64 product = (i64)x * (i64)(inv & 0x3FFFFF);
    i64 biased = product + (1 << 14);
    i64 shifted = arithmetic_shift_right(biased, 15);
    if (shifted > Q_MAX) return Q_MAX;
    if (shifted < Q_MIN) return Q_MIN;
    return (i8)shifted;
}

int ternarycore_rvv_gemm(const i8 *acts, const u8 *packed, const u16 *alphas,
                         i32 *results, int cols, int vlen, u32 inv) {
    // Bounds check: static pos/neg buffers are sized for MAX_C * MAX_V.
    if (results == 0)
        return -1;
    if (acts == 0 || packed == 0 || alphas == 0 || vlen <= 0 || cols <= 0
        || vlen > MAX_V || cols > MAX_C) {
        // Never walk beyond the implementation's fixed result capacity,
        // even when the caller supplied a nonsensical column count.
        for (int c = 0; c < cols && c < MAX_C; c++) results[c] = 0;
        return -1;
    }

    // Fixed scratch storage keeps the bare-metal API allocation-free. Calls
    // must be serialized; this reference implementation is not reentrant.
    static i8 pos[MAX_C * MAX_V];
    static i8 neg[MAX_C * MAX_V];
    // Decode 2-bit packed weights into separate +1/-1 arrays
    decode(packed, pos, neg, cols, vlen);

    // Stage 1: quantize activations (mirrors activation_quant.v)
    static i8 q[MAX_V];
    for (int i = 0; i < vlen; i++)
        q[i] = quantize(acts[i], inv);

    for (int c = 0; c < cols; c++) {
        // Stage 2: ternary GEMM dot (uses quantized q[])
        i32 d = dot(q, pos + c * vlen, neg + c * vlen, vlen);

        // Stage 3: scale with the RTL-defined upward rounding rule.
        i64 prod = (i64)d * (i64)alphas[c];
        u32 trunc = (u32)prod & 0x7FFF;         // lower 15 bits
        int round_bit = (trunc != 0) ? 1 : 0;
        i64 shifted = arithmetic_shift_right(prod, 15);
        results[c] = (i32)(shifted + round_bit);
    }
    return 0;
}
