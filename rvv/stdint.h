#ifndef TERNARYCORE_FREESTANDING_STDINT_H
#define TERNARYCORE_FREESTANDING_STDINT_H

/*
 * Minimal fixed-width types for bare-metal RISC-V toolchains that provide
 * riscv_vector.h without a C library or sysroot. Compiler-defined types keep
 * this correct across RV32/RV64 and avoid Makefile-generated headers.
 */
typedef __INT8_TYPE__ int8_t;
typedef __INT16_TYPE__ int16_t;
typedef __INT32_TYPE__ int32_t;
typedef __INT64_TYPE__ int64_t;
typedef __UINT8_TYPE__ uint8_t;
typedef __UINT16_TYPE__ uint16_t;
typedef __UINT32_TYPE__ uint32_t;
typedef __UINT64_TYPE__ uint64_t;

#endif
