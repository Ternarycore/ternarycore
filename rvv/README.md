# RISC-V Vector reference

`bitnet_rvv.c` implements the same activation-quantize, ternary-dot, and Q15
scale semantics as the RTL and GVSoC model. It accepts 1–4 columns and vectors
up to 1024 elements; packed weight code `11` follows the RTL default and means
`-1`.

Include `bitnet_rvv.h` and call `ternarycore_rvv_gemm()`. The function returns
zero on success and `-1` for invalid pointers or dimensions.

```bash
make
make CROSS=riscv64-unknown-elf-gcc ARCH=rv64gcv_zvl128b ABI=lp64d FREESTANDING=0
```

The Makefile auto-detects `riscv64-unknown-elf-gcc` and
`riscv64-elf-gcc`. Override `CROSS`, `ARCH`, or `ABI` for another toolchain.
The default `rv64gcv` architecture includes the `G` extension (including
double-precision `D`), so the default ABI is `lp64d`. Select `ABI=lp64` when
using an integer-only ABI/toolchain. Bare-metal builds use the bundled
fixed-width type definitions by default; pass `FREESTANDING=0` when the
selected toolchain provides a hosted `<stdint.h>`.
The implementation uses fixed internal scratch buffers and is therefore not
reentrant; callers must serialize `ternarycore_rvv_gemm()` calls.
