# BitNet Inference Developer Kit — Arty A7-100T (Track A)

> **Where the code lives.** This document describes the Track A system whose
> RTL (`axi_gemm_wrapper.v`, `weight_bram.v`), block-design scripts (`Arty7/`),
> firmware (`firmware/tier1_bench.c`) and weight tooling (`tools/`) currently
> live on the
> [`feat/bitnet-accelerator`](https://github.com/Ternarycore/ternarycore/tree/feat/bitnet-accelerator)
> branch. It is kept on `main` as the canonical statement of the plan; the
> branch merges to `main` once the design is confirmed on real silicon.

This is the developer-kit guide for the TernaryCore **Track A** BitNet b1.58
inference accelerator on a Digilent **Arty A7-100T** (Xilinx Artix-7
`xc7a100tcsg324-1`). It ties the RTL, the Vivado build flow, the MicroBlaze
firmware, and the weight tooling into one reproducible path:

**simulate → build bitstream → build firmware → flash → read benchmark → load your own weights**

> **Honest status.** The full RTL + AXI + BRAM stack and the MicroBlaze
> benchmark firmware are **complete and pass simulation**; the Vivado flow is
> scripted and timing-/utilization-gated at 100 MHz. What is **not yet done**:
> the design has not been independently confirmed on real silicon in this repo
> (needs your Vivado + board), and weights/activations are currently generated
> **on-chip** — there is no host→board load path yet (see
> [Pending](#whats-validated-vs-pending)). This guide makes the kit buildable
> and gives you the recipe to run a *real* BitNet layer.
>
> `build.md` in the repo root is the older Tier-0 (single-MAC) plan and is
> superseded by this document for Track A.

## Bill of materials & tools

| Item | Notes |
|---|---|
| Arty A7-100T | `xc7a100tcsg324-1`; free Vivado WebPACK tier (no licence) |
| Vivado 2024.x | Linux/Windows; macOS users run it in a Linux VM |
| Vitis 2024.x | to build the MicroBlaze firmware from the exported `.xsa` |
| Icarus Verilog | RTL simulation (`brew install icarus-verilog` / `apt install iverilog`) |
| USB cable | board JTAG + USB-UART (FTDI) |
| Python 3 | weight tooling in `tools/` |

## Track A layout (this branch)

```
rtl/
  ternary_mac.v / ternary_dot.v / ternary_gemm.v   core ternary GEMM (generate-loop, DEPTH=768)
  axi_gemm_wrapper.v        AXI4-Lite slave: CTRL / ACTIVATION / WEIGHT_ENC / ACC_OUT0-3
  weight_bram.v             dual-port BRAM, 4 weights/byte, AXI write + combinational read
constraints/
  arty_a7_100t_mb.xdc       Arty A7-100T pins: sys_clock E3, reset C2, uart D10/A9, LEDs
ip/
  package_axi_gemm_wrapper.tcl / package_weight_bram.tcl   package RTL as Vivado IP
Arty7/
  create_bd.tcl             MicroBlaze + AXI interconnect + GEMM + UART16550 + GPIO block design
  generate_bitstream.tcl    synth + impl + timing/LUT gate + write_bitstream
  build_all.sh              one-shot wrapper for the two tcl steps
firmware/
  tier1_bench.c             bare-metal benchmark: accel GEMM vs pure-C, reports speedup over UART
tools/
  quantum-mapping.py        ternarize float checkpoints -> {-1,0,+1} (absmean / QUBO / quantum)
  weights-to-mem.py         pack ternary weights -> .mem / C header / int8 activations
```

## 1. Simulate (no board)

```bash
cd sim && make all
```

Expect the core suite (`ternary_mac` / `dot` / `gemm`) plus the Track A
testbenches to pass: `tb_axi_gemm_wrapper` (AXI register read/write + GEMM
result) and `tb_weight_bram` (packed read/write). Simulation passing is
*necessary but not sufficient* — latches, timing, and reset behaviour are only
proven in Vivado implementation.

## 2. Build the bitstream (Vivado)

```bash
# from the repo root, with `vivado` on PATH:
bash Arty7/build_all.sh
#   step 1: vivado -mode batch -source Arty7/create_bd.tcl
#   step 2: vivado -mode batch -source Arty7/generate_bitstream.tcl
```

`generate_bitstream.tcl` **fails the build** if it cannot close timing at
100 MHz (`WNS`/`WHS` ≥ 0) or if LUTs exceed the 63,400 budget, and warns on
inferred latches. Outputs: the block-design wrapper bitstream
`arty_mb_gemm/.../impl/arty_mb_gemm_wrapper.bit` and a hardware handoff `.xsa`
for Vitis.

## 3. Build the firmware (Vitis / mb-gcc)

`firmware/tier1_bench.c` is bare-metal MicroBlaze. Build it against a Vitis
platform created from the exported `.xsa` (gives you `xil_io.h`, `xil_printf`,
`xtime_l.h` and the BSP), or compile with the MicroBlaze GCC from the Vitis
toolchain:

```bash
mb-gcc -O2 -Wall -o tier1_bench.elf firmware/tier1_bench.c   # + BSP include/lib paths
```

Address map (must match `Arty7/create_bd.tcl`):

| Block | Base | Key registers |
|---|---|---|
| GEMM wrapper | `0x44000000` | `CTRL` `0x00` (bit0 START, bit31 DONE), `ACTIVATION` `0x04`, `WEIGHT_ENC` `0x08`, `ACC_OUT0-3` `0x10-0x1C` |
| Weight BRAM | `0x44010000` | 256 KB, 4 ternary weights/byte (LSB first) |
| AXI UART16550 | `0x40600000` | 115200 8N1 |
| AXI GPIO (LEDs) | `0x40000000` | status LEDs |

## 4. Flash & run

Program the `.bit` (Vivado Hardware Manager or `openFPGALoader`) and download
`tier1_bench.elf` (Vitis run/debug). Open the USB-UART at **115200 8N1**:

```
TernaryCore Tier 1 Benchmark
Initializing...
Verification PASS
Running 100 accelerator passes...
Running 100 software passes...
ACCEL: <cycles>  SW: <cycles>  Speedup: N.Nx
```

The `Verification PASS` line is the real acceptance gate: the accelerator output
is compared element-by-element against a pure-C reference GEMM on the same
weights/activations before any timing is reported.

## 5. Load your own BitNet weights

Today `init_weights()` fills the BRAM with a deterministic synthetic pattern.
To run a **real** ternary layer, generate a C header from your checkpoint and
swap it in.

```bash
# (a) ternarize a float weight matrix and sanity-check the quantization error
python3 tools/quantum-mapping.py --in layer0.npy --strategy absmean --report

# (b) pack to the exact BRAM byte layout (4 weights/byte, LSB-first) as a C array
python3 tools/weights-to-mem.py --in layer0.npy --layout bytes \
        --emit-c-header firmware/bitnet_weights.h --name bitnet_weights
```

Then replace the body of `init_weights()` (guarded so the synthetic path still
builds) — the byte order matches `weights-to-mem.py --layout bytes` exactly:

```c
#ifdef USE_REAL_WEIGHTS
#include "bitnet_weights.h"          /* generated above */
static void init_weights(void) {
    unsigned int i, b, word;
    unsigned int total_words = 256u * 1024u / 4u;     /* 65536 words */
    for (i = 0u; i < total_words; i++) {
        word = 0u;
        for (b = 0u; b < 4u; b++) {
            unsigned int idx = i * 4u + b;
            unsigned char by = (idx < BITNET_WEIGHTS_LEN) ? bitnet_weights[idx] : 0u;
            word |= ((unsigned int)by) << (8u * b);   /* zero-pad the tail */
        }
        Xil_Out32(WEIGHT_BRAM + i * 4u, word);
    }
}
#endif
```

Activations stream in through `REG_ACTIVATION` as int8; quantize a real
activation vector with `weights-to-mem.py --activations acts.csv` and feed the
tokens in place of the synthetic `(k % 7) - 3` pattern.

## What's validated vs pending

**Validated (simulation):** ternary MAC/dot/GEMM math, AXI register interface,
packed weight BRAM, full accel-vs-software equivalence in firmware logic.

**Scripted but unconfirmed here:** 100 MHz timing closure and ≤63,400-LUT fit
(asserted by `generate_bitstream.tcl`; reproduce on your Vivado to confirm).
No bitstream is committed.

**Pending (the real next milestones):**

1. **On-hardware bring-up** — program a board, confirm `Verification PASS` and
   capture the real `Speedup` and power numbers over UART.
2. **Host→board data path** — today weights are loaded by the CPU and
   activations are synthetic; there is no UART/SPI/USB protocol to stream a
   *real* model's weights/activations from a PC. Recommended next step: a small
   UART command (`LOADW <addr> <bytes>` / `LOADA <bytes>` / `RUN`) plus a host
   sender that calls `weights-to-mem.py`. This is the single biggest gap
   between "benchmark demo" and "developer kit."
3. **Wider GEMM** — the AXI map currently exposes 4 accumulator columns; scaling
   to the ROADMAP's hundreds of columns needs a wider result interface.

## License

RTL under **CERN-OHL-S v2**; the Python tools under **MIT** (see repo `LICENSE`).
