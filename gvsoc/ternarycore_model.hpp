// SPDX-License-Identifier: CERN-OHL-S-2.0
// Dependency-free, bit-exact software model shared by GVSoC and host tests.

#ifndef TERNARYCORE_MODEL_HPP
#define TERNARYCORE_MODEL_HPP

#include <algorithm>
#include <cstdint>

namespace ternarycore {

inline constexpr int MAX_VECTOR_LEN = 1024;
inline constexpr int MAX_COLS = 4;
inline constexpr int PRECISION = 15;
inline constexpr int INV_WIDTH = 22;
inline constexpr int Q_MAX = 127;
inline constexpr int Q_MIN = -127;

inline std::int64_t arithmetic_shift_right(std::int64_t value, int bits)
{
    const std::int64_t divisor = std::int64_t{1} << bits;
    if (value >= 0)
        return value / divisor;
    return -((-value + divisor - 1) / divisor);
}

inline std::int8_t quantize_activation(std::int32_t activation, std::uint32_t inv)
{
    const auto masked_inv = inv & ((std::uint32_t{1} << INV_WIDTH) - 1);
    const std::int64_t product =
        static_cast<std::int64_t>(activation) * masked_inv;
    const std::int64_t biased = product + (std::int64_t{1} << (PRECISION - 1));
    const std::int64_t shifted = arithmetic_shift_right(biased, PRECISION);
    return static_cast<std::int8_t>(std::clamp<std::int64_t>(shifted, Q_MIN, Q_MAX));
}

// Match ternary_weight.v: 00=0, 01=+1, every other code=-1.
inline int decode_weight(std::uint8_t encoding)
{
    if (encoding == 0b00)
        return 0;
    if (encoding == 0b01)
        return 1;
    return -1;
}

inline std::int32_t scale_accumulator(std::int32_t accumulator,
                                      std::uint16_t alpha)
{
    const std::int64_t product =
        static_cast<std::int64_t>(accumulator) * alpha;
    const auto truncated = static_cast<std::uint64_t>(product)
        & ((std::uint64_t{1} << PRECISION) - 1);
    const std::int64_t shifted = arithmetic_shift_right(product, PRECISION);
    return static_cast<std::int32_t>(shifted + (truncated != 0));
}

inline bool run_pipeline(const std::uint8_t *activations,
                         const std::uint8_t *packed_weights,
                         const std::uint16_t *alphas,
                         std::uint32_t vector_len,
                         int cols,
                         std::uint32_t inv,
                         std::int32_t *results)
{
    if (results != nullptr) {
        for (int col = 0; col < std::clamp(cols, 0, MAX_COLS); ++col)
            results[col] = 0;
    }
    if (activations == nullptr || packed_weights == nullptr || alphas == nullptr
        || results == nullptr || vector_len == 0 || vector_len > MAX_VECTOR_LEN
        || cols <= 0 || cols > MAX_COLS)
        return false;

    std::int32_t accumulators[MAX_COLS] = {};
    for (std::uint32_t index = 0; index < vector_len; ++index) {
        const auto activation = static_cast<std::int8_t>(activations[index]);
        const auto quantized = quantize_activation(activation, inv);
        const auto packed = packed_weights[index];
        for (int col = 0; col < cols; ++col) {
            const int weight = decode_weight((packed >> (2 * col)) & 0x3);
            accumulators[col] += weight * quantized;
        }
    }

    for (int col = 0; col < cols; ++col)
        results[col] = scale_accumulator(accumulators[col], alphas[col]);
    return true;
}

}  // namespace ternarycore

#endif
