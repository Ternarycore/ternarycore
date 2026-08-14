# RISC-V Vector reference

`bitnet_rvv.c` implements the same activation-quantize, ternary-dot, and Q15
scale semantics as the RTL and GVSoC model. It accepts 1–4 columns and vectors
up to 1024 elements; packed weight code `11` follows the RTL default and means
`-1`.

Include `bitnet_rvv.h` and call `ternarycore_rvv_gemm()`. The function returns
zero on success and `-1` for invalid pointers or dimensions.

```bash
make
make CROSS=riscv64-unknown-elf-gcc ARCH=rv64gcv_zvl128b ABI=lp64d
```

The Makefile auto-detects `riscv64-unknown-elf-gcc` and
`riscv64-elf-gcc`. Override `CROSS`, `ARCH`, or `ABI` for another toolchain.
The implementation uses fixed internal scratch buffers and is therefore not
reentrant; callers must serialize `ternarycore_rvv_gemm()` calls.
