// test_device_logic.cpp
// Standalone C++ test of the ternary GEMM pipeline logic.
// Compiles and runs without any gvsoc dependency.
// Verifies the bit-exact same computation as the RTL pipeline:
//   activation_quant -> ternary_gemm (dot products) -> scale
//
// Compile: g++ -std=c++17 -O2 -o test_device_logic test_device_logic.cpp && ./test_device_logic

#include <cstdio>
#include <cstdint>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <cassert>

// ============================================================================
// Device-logic: exact C++ model of the RTL ternary pipeline
// ============================================================================

// Data widths matching the RTL params
static constexpr int DATA_WIDTH = 8;
static constexpr int ACC_WIDTH  = 32;
static constexpr int Q_WIDTH    = 8;      // quantized activation width
static constexpr int PRECISION  = 15;     // Q15 for alpha (1.0 = 0x8000)
static constexpr int INV_WIDTH  = 22;     // PRECISION + Q_WIDTH
static constexpr int Q_MAX      = 127;    // 2^(Q_WIDTH-1) - 1
static constexpr int Q_MIN      = -127;   // -(2^(Q_WIDTH-1)) + 1

// Weight encoding: 00=zero, 01=+1, 10=-1
static inline int decode_weight(uint8_t enc) {
    switch (enc) {
        case 0b01: return +1;
        case 0b10: return -1;
        default:   return  0;  // 0b00 or 0b11
    }
}

// Activation quantization: q = round(clip(x * inv >> PRECISION, -Q_MAX, Q_MAX))
// Matches activation_quant.v (2-stage: multiply -> shift+round+clip)
static inline int8_t quantize_activation(int x, uint32_t inv) {
    // Stage 1: product (32-bit signed, matching Verilog product width)
    int64_t product = (int64_t)x * (int64_t)(int32_t)(inv & 0x3FFFFF);

    // Stage 2: shift + round + clip
    int64_t round_amt = 1 << (PRECISION - 1);
    int64_t biased = product + round_amt;
    int64_t shifted = biased >> PRECISION;

    if (shifted > Q_MAX) return Q_MAX;
    if (shifted < Q_MIN) return Q_MIN;
    return (int8_t)shifted;
}

// Compute inv = round(2^PRECISION * Q_MAX / absmax)
static inline int compute_inv(int absmax) {
    return (int)round((double)(1 << PRECISION) * Q_MAX / absmax);
}

// Run the full ternary pipeline: quantize -> GEMM -> scale
// activations: array of VECTOR_LEN signed 8-bit values
// weights_packed: 2*COLS bits per column, stored as array of 2-bit values
//   (each column has VECTOR_LEN weights, each 2-bit encoded)
// alphas: array of COLS Q15 scale factors
// inv: precomputed inverse absmax for activation quantization
// result: output array of COLS int32_t values
void ternary_pipeline_cpp(
    const int8_t* activations, int vector_len,
    const uint8_t* weights_packed,  // [COLS][VECTOR_LEN] packed 2-bit
    const uint16_t* alphas, int cols,
    uint32_t inv,
    int32_t* result)
{
    // Stage 1: Quantize activations
    int8_t* q = new int8_t[vector_len];
    for (int i = 0; i < vector_len; i++) {
        q[i] = quantize_activation(activations[i], inv);
    }

    // Stage 2: GEMM - for each column, accumulate weighted activations
    int32_t* acc = new int32_t[cols]();

    for (int c = 0; c < cols; c++) {
        for (int k = 0; k < vector_len; k++) {
            int w = decode_weight(weights_packed[c * vector_len + k]);
            if (w == +1) acc[c] += q[k];
            else if (w == -1) acc[c] -= q[k];
            // w == 0: no-op
        }
    }

    // Stage 3: Scale multiply (matching ternary_scale.v)
    //   result = (acc * alpha + round_bit) >> PRECISION
    //   rounding: if any lower bits are set, add 1
    for (int c = 0; c < cols; c++) {
        int64_t prod = (int64_t)acc[c] * (int64_t)(int32_t)(alphas[c] & 0xFFFF);
        uint32_t trunc = prod & ((1 << PRECISION) - 1);
        int round_bit = (trunc != 0) ? 1 : 0;
        int64_t shifted = prod >> PRECISION;
        result[c] = (int32_t)(shifted) + round_bit;
    }

    delete[] q;
    delete[] acc;
}

// ============================================================================
// Test runner
// ============================================================================

static int total_errors = 0;

#define TEST_CHECK(cond, msg) do { \
    if (!(cond)) { \
        printf("  FAIL: %s\n", msg); \
        total_errors++; \
    } else { \
        printf("  PASS: %s\n", msg); \
    } \
} while (0)

void test_simple_gemm_4x4() {
    printf("\n=== Test: Simple 4x4 GEMM (VECTOR_LEN=4, COLS=4) ===\n");

    int vector_len = 4;
    int cols = 4;
    int8_t acts[4] = {10, 20, 30, 40};

    // Weights: col0=[+1,-1,0,+1], col1=[0,0,+1,-1], col2=[+1,+1,+1,+1], col3=[-1,-1,-1,-1]
    uint8_t weights[16];
    // Col 0
    weights[0]  = 0b01; // +1
    weights[1]  = 0b10; // -1
    weights[2]  = 0b00; // 0
    weights[3]  = 0b01; // +1
    // Col 1
    weights[4]  = 0b00; // 0
    weights[5]  = 0b00; // 0
    weights[6]  = 0b01; // +1
    weights[7]  = 0b10; // -1
    // Col 2
    weights[8]  = 0b01; // +1
    weights[9]  = 0b01; // +1
    weights[10] = 0b01; // +1
    weights[11] = 0b01; // +1
    // Col 3
    weights[12] = 0b10; // -1
    weights[13] = 0b10; // -1
    weights[14] = 0b10; // -1
    weights[15] = 0b10; // -1

    uint16_t alphas[4] = {32768, 32768, 16384, (uint16_t)65536}; // 65536 truncated to 0 in Q15
    uint32_t inv = compute_inv(127);  // absmax=127

    int32_t result[4];
    ternary_pipeline_cpp(acts, vector_len, weights, alphas, cols, inv, result);

    // Manual computation with quantization:
    // inv=32768, q = round(clip(x * 32768 >> 15, -127, 127)) = x (for small x)
    // Since acts are all < 127: q ≈ acts

    // Col 0: 10(q0) + (-20)(q1) + 0 + 40(q3) = 30
    // Col 1: 0 + 0 + 30(q2) + (-40)(q3) = -10
    // Col 2: 10+20+30+40 = 100 → 100*16384 >> 15 = 50, rounding? Lower bits: 100*16384 = 1638400, >> 15 = 50 exactly. Result = 50
    // Col 3: (-10)+(-20)+(-30)+(-40) = -100 → -100*65536 >> 15 = -200

    int32_t expected[4] = {30, -10, 50, 0}; // alpha[3]=65536 truncates to 0

    for (int c = 0; c < cols; c++) {
        char buf[64];
        snprintf(buf, sizeof(buf), "result[%d] = %d (expected %d)", c, result[c], expected[c]);
        TEST_CHECK(result[c] == expected[c], buf);
    }
}

void test_large_vector_576() {
    printf("\n=== Test: Large vector VECTOR_LEN=576 (SmolVLM hidden dim) ===\n");

    int vector_len = 576;
    int cols = 4;

    // Generate synthetic activations: ramp -127..127 repeating (same as verilator_pipeline_576.cpp)
    int8_t* acts = new int8_t[vector_len];
    for (int i = 0; i < vector_len; i++)
        acts[i] = (int8_t)((i % 255) - 127);

    // Fixed ternary weights per column: [+1, -1, 0, +1]
    uint8_t* weights = new uint8_t[cols * vector_len];
    int col_weights[4] = {1, -1, 0, 1};
    for (int c = 0; c < cols; c++) {
        for (int k = 0; k < vector_len; k++) {
            // Set weight encoding from the fixed pattern
            int w = col_weights[c];
            weights[c * vector_len + k] = (w == 1) ? 0b01 : (w == -1) ? 0b10 : 0b00;
        }
    }

    // Per-channel scales (Q15) - same as verilator test
    uint16_t alphas[4] = {32768, 16384, (uint16_t)65536, 32768}; // 65536 truncates to 0 in Q15

    // inv from absmax=127
    uint32_t inv = compute_inv(127);
    printf("inv = %u\n", inv);

    int32_t result[4];
    ternary_pipeline_cpp(acts, vector_len, weights, alphas, cols, inv, result);

    printf("Results: [%d, %d, %d, %d]\n", result[0], result[1], result[2], result[3]);

    // Quick sanity: results should be non-zero and deterministic
    TEST_CHECK(result[0] != 0, "result[0] != 0");
    TEST_CHECK(result[1] != 0, "result[1] != 0");

    delete[] acts;
    delete[] weights;
}

void test_weight_encodings() {
    printf("\n=== Test: All weight encodings ===\n");

    int8_t acts[1] = {100};
    int cols = 3;
    uint8_t weights[3] = {0b01, 0b10, 0b00}; // +1, -1, 0
    uint16_t alphas[3] = {32768, 32768, 32768};
    uint32_t inv = compute_inv(127);

    int32_t result[3];
    ternary_pipeline_cpp(acts, 1, weights, alphas, cols, inv, result);

    // q = 100 (since 100*32768>>15 = 100)
    // w=+1: acc = 100 -> 100*32768>>15 = 100
    // w=-1: acc = -100 -> -100*32768>>15 = -100
    // w=0:  acc = 0 -> 0
    TEST_CHECK(result[0] == 100,  "weight +1: result = 100");
    TEST_CHECK(result[1] == -100, "weight -1: result = -100");
    TEST_CHECK(result[2] == 0,    "weight  0: result = 0");
}

void test_scale_with_rounding() {
    printf("\n=== Test: Scale multiply with rounding ===\n");

    int8_t acts[2] = {10, 10};
    int cols = 2;

    // Two columns, same weights [+1, +1]
    uint8_t weights[4] = {0b01, 0b01, 0b01, 0b01};

    // Alpha values that trigger rounding edge cases
    // alpha=1: result = 20*1>>15 = 0 (with rounding from lsb checks)
    uint16_t alphas[2] = {1, 32768};

    uint32_t inv = compute_inv(127);

    int32_t result[2];
    ternary_pipeline_cpp(acts, 2, weights, alphas, cols, inv, result);

    // Column 0: acc=20, alpha=1, prod=20, PRECISION=15, trunc=20&0x7FFF=20, round=1
    //   shifted=0, result=0+1=1
    // Column 1: acc=20, alpha=32768, prod=20*32768=655360, trunc=655360&0x7FFF=0, round=0
    //   shifted=655360>>15=20, result=20
    TEST_CHECK(result[0] == 1,  "alpha=1: rounding adds 1 (acc=20, trunc nonzero)");
    TEST_CHECK(result[1] == 20, "alpha=1.0: result = acc (20)");
}

void test_quantization_clipping() {
    printf("\n=== Test: Activation quantization clipping ===\n");

    // Quantize_activation: q = clip((x * inv + 2^14) >> 15, -127, 127).
    // With inv = 65535 (max Q15), x=127 gives:
    //   product = 127 * 65535 = 8322945
    //   biased  = 8322945 + 16384 = 8339329
    //   shifted = 8339329 >> 15 = 254 (floor of 8339329/32768 = 254.5)
    //   clipped to 127 → clip reached!
    uint32_t inv_max = 65535;
    int8_t q;

    q = quantize_activation(127, inv_max);
    TEST_CHECK(q == 127, "quantize(127, 65535) clips to max");
    printf("  quantize(127, %u) = %d ✓\n", inv_max, q);

    q = quantize_activation(-128, inv_max);
    TEST_CHECK(q == -127, "quantize(-128, 65535) clips to min");
    printf("  quantize(-128, %u) = %d ✓\n", inv_max, q);

    q = quantize_activation(50, inv_max);
    TEST_CHECK(q == 100, "quantize(50, 65535) within range");
    printf("  quantize(50, %u) = %d ✓\n", inv_max, q);
}

void test_zero_activations() {
    printf("\n=== Test: Zero activations ===\n");

    int8_t acts[4] = {0, 0, 0, 0};
    uint8_t weights[4] = {0b01, 0b10, 0b00, 0b01};
    uint16_t alphas[4] = {32768, 32768, 32768, 32768};
    uint32_t inv = compute_inv(127);

    int32_t result[4];
    ternary_pipeline_cpp(acts, 4, weights, alphas, 4, inv, result);

    for (int c = 0; c < 4; c++) {
        TEST_CHECK(result[c] == 0, "zero activations -> zero results");
    }
}

int main(int argc, char** argv) {
    printf("TernaryCore Device Logic Test\n");
    printf("=============================\n");
    printf("Parameters: DATA_WIDTH=%d ACC_WIDTH=%d PRECISION=%d Q_MAX=%d\n",
           DATA_WIDTH, ACC_WIDTH, PRECISION, Q_MAX);

    test_simple_gemm_4x4();
    test_large_vector_576();
    test_weight_encodings();
    test_scale_with_rounding();
    test_quantization_clipping();
    test_zero_activations();

    printf("\n=============================\n");
    printf("Total errors: %d\n", total_errors);
    return total_errors ? 1 : 0;
}