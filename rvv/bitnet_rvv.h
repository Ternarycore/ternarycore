#ifndef TERNARYCORE_BITNET_RVV_H
#define TERNARYCORE_BITNET_RVV_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define TERNARYCORE_RVV_MAX_COLS 4
#define TERNARYCORE_RVV_MAX_VECTOR_LEN 1024

// Run quantize -> ternary GEMM -> Q15 scale. Packed weights contain one
// 2-bit value per column in each byte: 00=0, 01=+1, 10/11=-1.
// Returns 0 on success and -1 for null pointers or unsupported dimensions.
// The implementation uses static scratch storage and is not reentrant.
int ternarycore_rvv_gemm(const int8_t *activations,
                         const uint8_t *packed_weights,
                         const uint16_t *alphas,
                         int32_t *results,
                         int cols,
                         int vector_len,
                         uint32_t inv);

#ifdef __cplusplus
}
#endif

#endif
