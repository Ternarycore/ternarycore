// test_device_logic.cpp
// Standalone C++ test of the ternary GEMM pipeline logic.
// Compiles and runs without any gvsoc dependency.
// Verifies the bit-exact same computation as the RTL pipeline:
//   activation_quant -> ternary_gemm (dot products) -> scale
//
// Compile: g++ -std=c++17 -O2 -o test_device_logic test_device_logic.cpp && ./test_device_logic

#include <cassert>
#include <cmath>
#include <cstdint>
#include <cstdio>

#include "ternarycore_model.hpp"

// ============================================================================
// Device-logic: exact C++ model of the RTL ternary pipeline
// ============================================================================

// Data widths matching the RTL params
static constexpr int DATA_WIDTH = 8;
static constexpr int ACC_WIDTH = 32;

// Compute inv = round(2^PRECISION * Q_MAX / absmax)
static inline int compute_inv(int absmax) {
    assert(absmax > 0);
    return static_cast<int>(std::round(
        static_cast<double>(1 << ternarycore::PRECISION)
        * ternarycore::Q_MAX / absmax));
}

// Run the full ternary pipeline: quantize -> GEMM -> scale
// activations: array of VECTOR_LEN signed 8-bit values
// weights_packed: one packed row per depth position, matching device MMIO:
//   weights_packed[k] = {col3[k], col2[k], col1[k], col0[k]}
// alphas: array of COLS Q15 scale factors
// inv: precomputed inverse absmax for activation quantization
// result: output array of COLS int32_t values
void ternary_pipeline_cpp(
    const int8_t* activations, int vector_len,
    const uint8_t* weights_packed,  // [VECTOR_LEN], 2 bits per column
    const uint16_t* alphas, int cols,
    uint32_t inv,
    int32_t* result)
{
    const bool accepted = ternarycore::run_pipeline(
        reinterpret_cast<const uint8_t *>(activations), weights_packed,
        alphas, static_cast<uint32_t>(vector_len), cols, inv, result);
    assert(accepted);
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
    uint8_t weights[4] = {
        0b10'01'00'01, // k0: [+1,  0, +1, -1]
        0b10'01'00'10, // k1: [-1,  0, +1, -1]
        0b10'01'01'00, // k2: [ 0, +1, +1, -1]
        0b10'01'10'01, // k3: [+1, -1, +1, -1]
    };

    uint16_t alphas[4] = {32768, 32768, 16384, 0};
    uint32_t inv = compute_inv(127);  // absmax=127

    int32_t result[4];
    ternary_pipeline_cpp(acts, vector_len, weights, alphas, cols, inv, result);

    // Manual computation with quantization:
    // inv=32768, q = round(clip(x * 32768 >> 15, -127, 127)) = x (for small x)
    // Since acts are all < 127: q ≈ acts

    // Col 0: 10(q0) + (-20)(q1) + 0 + 40(q3) = 30
    // Col 1: 0 + 0 + 30(q2) + (-40)(q3) = -10
    // Col 2: 10+20+30+40 = 100 → 100*16384 >> 15 = 50, rounding? Lower bits: 100*16384 = 1638400, >> 15 = 50 exactly. Result = 50
    // Col 3 uses alpha=0, so its result is zero.

    int32_t expected[4] = {30, -10, 50, 0};

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
    uint8_t* weights = new uint8_t[vector_len];
    for (int k = 0; k < vector_len; k++)
        weights[k] = 0b01'00'10'01; // columns [+1, -1, 0, +1]

    // Per-channel scales (Q15) - same as verilator test
    uint16_t alphas[4] = {32768, 16384, 0, 32768};

    // inv from absmax=127
    uint32_t inv = compute_inv(127);
    printf("inv = %u\n", inv);

    int32_t result[4];
    ternary_pipeline_cpp(acts, vector_len, weights, alphas, cols, inv, result);

    printf("Results: [%d, %d, %d, %d]\n", result[0], result[1], result[2], result[3]);

    const int32_t expected[4] = {-6237, 3119, 0, -6237};
    for (int col = 0; col < cols; ++col) {
        char message[80];
        snprintf(message, sizeof(message),
                 "result[%d] = %d (expected %d)",
                 col, result[col], expected[col]);
        TEST_CHECK(result[col] == expected[col], message);
    }

    delete[] acts;
    delete[] weights;
}

void test_max_vector_1024() {
    printf("\n=== Test: Maximum VECTOR_LEN=1024 ===\n");
    uint8_t acts[ternarycore::MAX_VECTOR_LEN];
    uint8_t weights[ternarycore::MAX_VECTOR_LEN];
    for (int index = 0; index < ternarycore::MAX_VECTOR_LEN; ++index) {
        acts[index] = 127;
        weights[index] = 0b01'01'01'01;
    }
    uint16_t alphas[4] = {32768, 32768, 32768, 32768};
    int32_t result[4] = {};
    bool accepted = ternarycore::run_pipeline(
        acts, weights, alphas, ternarycore::MAX_VECTOR_LEN, 4,
        compute_inv(127), result);
    TEST_CHECK(accepted, "maximum vector length is accepted");
    for (int value : result)
        TEST_CHECK(value == 1024 * 127, "maximum vector result is exact");
}

void test_weight_encodings() {
    printf("\n=== Test: All weight encodings ===\n");

    int8_t acts[1] = {100};
    int cols = 4;
    uint8_t weights[1] = {0b11'00'10'01}; // +1, -1, 0, reserved(11)->-1
    uint16_t alphas[4] = {32768, 32768, 32768, 32768};
    uint32_t inv = compute_inv(127);

    int32_t result[4];
    ternary_pipeline_cpp(acts, 1, weights, alphas, cols, inv, result);

    // q = 100 (since 100*32768>>15 = 100)
    // w=+1: acc = 100 -> 100*32768>>15 = 100
    // w=-1: acc = -100 -> -100*32768>>15 = -100
    // w=0:  acc = 0 -> 0
    TEST_CHECK(result[0] == 100,  "weight +1: result = 100");
    TEST_CHECK(result[1] == -100, "weight -1: result = -100");
    TEST_CHECK(result[2] == 0,    "weight  0: result = 0");
    TEST_CHECK(result[3] == -100, "weight 11 follows RTL default: result = -100");
}

void test_scale_with_rounding() {
    printf("\n=== Test: Scale multiply with rounding ===\n");

    int8_t acts[2] = {10, 10};
    int cols = 2;

    // Two columns, same weights [+1, +1]
    uint8_t weights[2] = {0b01'01, 0b01'01};

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
    TEST_CHECK(ternarycore::scale_accumulator(-20, 1) == 0,
               "negative fractional result follows RTL upward rounding");
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

    q = ternarycore::quantize_activation(127, inv_max);
    TEST_CHECK(q == 127, "quantize(127, 65535) clips to max");
    printf("  quantize(127, %u) = %d ✓\n", inv_max, q);

    q = ternarycore::quantize_activation(-128, inv_max);
    TEST_CHECK(q == -127, "quantize(-128, 65535) clips to min");
    printf("  quantize(-128, %u) = %d ✓\n", inv_max, q);

    q = ternarycore::quantize_activation(50, inv_max);
    TEST_CHECK(q == 100, "quantize(50, 65535) within range");
    printf("  quantize(50, %u) = %d ✓\n", inv_max, q);

    q = ternarycore::quantize_activation(
        1, (1u << ternarycore::INV_WIDTH) | 32768u);
    TEST_CHECK(q == 1, "quantization masks INV to the RTL port width");
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

void test_invalid_dimensions_clear_results() {
    printf("\n=== Test: Invalid dimensions are rejected ===\n");
    uint8_t acts[1] = {1};
    uint8_t weights[1] = {0b01};
    uint16_t alphas[4] = {32768, 32768, 32768, 32768};
    int32_t result[4] = {1, 2, 3, 4};

    bool accepted = ternarycore::run_pipeline(
        acts, weights, alphas, 0, 4, 32768, result);
    TEST_CHECK(!accepted, "zero vector length is rejected");
    for (int value : result)
        TEST_CHECK(value == 0, "rejected run clears visible results");

    accepted = ternarycore::run_pipeline(
        acts, weights, alphas, ternarycore::MAX_VECTOR_LEN + 1, 4,
        32768, result);
    TEST_CHECK(!accepted, "oversized vector length is rejected");

    accepted = ternarycore::run_pipeline(
        nullptr, weights, alphas, 1, 4, 32768, result);
    TEST_CHECK(!accepted, "null activation buffer is rejected");
    accepted = ternarycore::run_pipeline(
        acts, weights, alphas, 1, 4, 32768, nullptr);
    TEST_CHECK(!accepted, "null result buffer is rejected");
}

int main() {
    printf("TernaryCore Device Logic Test\n");
    printf("=============================\n");
    printf("Parameters: DATA_WIDTH=%d ACC_WIDTH=%d PRECISION=%d Q_MAX=%d\n",
           DATA_WIDTH, ACC_WIDTH, ternarycore::PRECISION, ternarycore::Q_MAX);

    test_simple_gemm_4x4();
    test_large_vector_576();
    test_max_vector_1024();
    test_weight_encodings();
    test_scale_with_rounding();
    test_quantization_clipping();
    test_zero_activations();
    test_invalid_dimensions_clear_results();

    printf("\n=============================\n");
    printf("Total errors: %d\n", total_errors);
    return total_errors ? 1 : 0;
}
