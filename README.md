# TernaryCore

**An open-source FPGA accelerator for BitNet ternary neural network inference.**

BitNet b1.58 encodes every model weight as {-1, 0, +1}. That collapses matrix multiplication — the core operation of every transformer layer — into additions, subtractions, and conditional skips. No multiplies. TernaryCore is hardware built to match that arithmetic natively.

[![License: CERN-OHL-S v2](https://img.shields.io/badge/License-CERN--OHL--S%20v2-blue)](https://ohwr.org/cern_ohl_s_v2.txt)
[![Simulation: Passing](https://img.shields.io/badge/Simulation-Passing-brightgreen)]()

---

## Simulation Status

| Module | Tests | Status |
|--------|-------|--------|
| `ternary_mac` | 8/8 | ✅ All passing |
| `ternary_dot` | 7/7 | ✅ All passing |
| `ternary_gemm` | 16/16 (4×4) | ✅ All passing |

> **All configured checks pass.** Icarus and Verilator simulations are backed by
> Python references and bounded formal checks for the core datapaths.

### Verified `ternary_dot` Interface

The verification harnesses model the behavior of the currently shipped RTL:

- `valid_out` rises after the terminal input and remains asserted until the
  first accepted item of the next vector.
- `acc_out` is registered on the following clock while `valid_out` is high.
- Hold `valid_in` low for at least one recovery cycle between vectors.
- Randomized Verilator coverage checks this protocol with bubbles and all four
  2-bit weight encodings using a reproducible seed.

Formal cover and bounded proofs check the MAC, dot-product completion, and GEMM
reference models in CI.

---

## Waveforms

`ternary_mac` — 8 test vectors, all passing:

![ternary_mac waveform](docs/waveform_mac.svg)

`acc_out` updates exactly one clock after each `valid_in` pulse. Sign extension and two's-complement negation handled with no DSP blocks — adders and mux logic only.

`ternary_dot` — streaming dot product, 7/7 tests passing (VLEN=8 shown):

![ternary_dot waveform](docs/waveform_dot.svg)

Eight activations stream in one per clock with weight=+1. `valid_out` rises on
the terminal input; the registered result (36) appears on the following clock.

`ternary_gemm` — 4×4 matrix multiply, 16/16 tests passing:

![ternary_gemm waveform](docs/waveform_gemm.svg)

Four parallel `ternary_dot` instances (col_0–col_3) receive the same activation
broadcast per clock, each with its own weight encoding. One registered result
row lands simultaneously across all four columns while `valid_out` is high.

---

## Architecture

```mermaid
graph TD
    subgraph inputs["Inputs (per cycle)"]
        A["activation\n(int8)"]
        W["weight_enc\n(2-bit: 00=0, 01=+1, 10=−1)"]
    end

    subgraph mac["ternary_mac — atomic cell"]
        MUX["2:1 mux\n(add / sub / zero)"]
        REG1["acc register"]
        A --> MUX
        W --> MUX
        MUX --> REG1
    end

    subgraph dot["ternary_dot — streaming dot product"]
        LOOP["× VECTOR_LEN\nmac cells in series"]
        VREG["result register\n(valid_out level)"]
        REG1 --> LOOP
        LOOP --> VREG
    end

    subgraph gemm["ternary_gemm — matrix multiply"]
        PAR["× COLS\nparallel dot units"]
        OUT["output row\n(int32 × COLS)"]
        VREG --> PAR
        PAR --> OUT
    end
```

Three layers, each building on the last:

**`ternary_mac`** — the atomic cell. Takes one activation, one 2-bit weight, and a running accumulator. Outputs `acc_in ± activation` or `acc_in` (zero weight), registered on the clock edge. No multiplier.

**`ternary_dot`** — streaming dot product over `VECTOR_LEN` elements (default
64). Signals completion with `valid_out`; the registered result is available on
the following clock. A low `valid_in` recovery cycle separates vectors.

**`ternary_gemm`** — matrix multiply using `COLS` parallel `ternary_dot` instances. One activation is broadcast per cycle to all column dots, each receiving its own weight encoding. Produces one output row every `DEPTH` cycles.

### Weight Encoding

| `weight_enc` | Ternary value | Operation |
|---|---|---|
| `2'b00` | 0 | No contribution (skip) |
| `2'b01` | +1 | `acc_out = acc_in + activation` |
| `2'b10` | -1 | `acc_out = acc_in - activation` |
| `2'b11` | -1 | Reserved encoding follows the RTL default subtraction path |

---

## Getting Started

### Prerequisites

**All platforms:**
- Python 3 (for verification scripts)

**Verilog Simulator (choose one):**
- **Icarus Verilog** (recommended, open source)
  - **macOS**: `brew install icarus-verilog`
  - **Ubuntu/Debian**: `sudo apt-get install iverilog`
  - **Fedora/RHEL**: `sudo dnf install iverilog`
  - **Windows** (WSL2): Use Ubuntu/Debian commands above
  - **Windows** (native): Install from [Icarus Verilog Windows builds](http://bleyer.org/icarus/)

- **Verilator** (alternative, faster simulation)
  - **macOS**: `brew install verilator`
  - **Ubuntu/Debian**: `sudo apt-get install verilator`
  - See [verilator.org](https://verilator.org) for other platforms

### Setup

```bash
git clone https://github.com/shepherdscientific/ternarycore.git
cd ternarycore/sim
```

### Run simulations

```bash
make tb_ternary_mac    # ternary_mac — 8 tests
make tb_ternary_dot    # ternary_dot — 7 tests (VLEN=8)
make tb_ternary_gemm   # ternary_gemm — 4×4 matrix multiply
make all               # run the complete Icarus regression suite
make extended          # include streaming, INT8 baseline, and AXI-gap tests
make verilator-all     # run MAC, dot, randomized dot, and GEMM C++ tests
make formal            # run every SymbiYosys task (requires sby/yosys)
```

### Cross-verify with Python

```bash
make verify
# or individually:
python3 verify/verify_mac.py
python3 verify/verify_dot.py
python3 verify/verify_gemm_simple.py  # No numpy dependency
```

### View waveforms

**For debugging waveforms (.vcd files):**
- **GTKWave** (cross-platform, open source)
  - **macOS**: `brew install gtkwave`
  - **Ubuntu/Debian**: `sudo apt-get install gtkwave`
  - **Windows**: Available via [MSYS2](https://www.msys2.org/) or WSL

- **Alternative options:**
  - **WaveTrace** (macOS app, free) - Recommended for macOS users
  - **Verilog HDL VSCode Extension** (VSCode plugin with waveform viewer)
  - **Scansion** (macOS, paid)
  - **ModelSim/QuestaSim** (commercial, university licenses available)

**Note for macOS users:** GTKWave may have issues on newer macOS versions. Consider WaveTrace or Verilog HDL VSCode Extension as alternatives.

---

## Repository Layout

```
ternarycore/
├── rtl/
│   ├── ternary_mac.v       # single MAC cell
│   ├── ternary_dot.v       # streaming dot product
│   └── ternary_gemm.v      # matrix multiply
├── tb/
│   ├── tb_ternary_mac.v
│   ├── tb_ternary_dot.v
│   └── tb_ternary_gemm.v
├── sim/
│   ├── Makefile
│   └── verify/
│       ├── verify_mac.py
│       ├── verify_dot.py
│       └── verify_gemm.py
├── docs/
│   ├── ROADMAP.md          # Track A/B system design (soft CPU + ternary accelerator)
│   └── waveform_mac.svg
├── DEVKIT.md               # build → flash → benchmark guide (Track A)
└── LICENSE                 # CERN-OHL-S v2 (RTL) + MIT (scripts)
```

---

## The Question This Project Answers

Ternary compute is proven on silicon: a `ternary_mac` cell runs on the Arty
A7-100T (and Tang Nano 9k) using **0 DSP slices** — LUTs and flip-flops only
(see the [bring-up write-up](docs/article-02.md)). The next question is the
one that matters:

> **Put a soft CPU on the same fabric next to TernaryCore, and run BitNet
> models both ways — pure CPU vs CPU + ternary offload — on identical
> weights.** Same board, same clock, same model: the with/without-ternary A/B
> is the proof that native ternary hardware earns its place.

The system design for this is captured in [`docs/ROADMAP.md`](docs/ROADMAP.md)
(Track A: MicroBlaze + AXI + ternary GEMM array on the Arty A7; Track B:
PicoRV32 + ternary PQC accelerator on the Tang Nano), and the reproducible
build/flash/benchmark path is in [`DEVKIT.md`](DEVKIT.md). The Tier 1
benchmark firmware runs the same 768→768 projection through the accelerator
and through pure C on the soft CPU, verifies element-by-element agreement,
then reports cycles and speedup over UART.

## Roadmap

- [x] `ternary_mac` — single cell, all tests passing
- [x] `ternary_dot` — 64-element vector dot product, all tests passing
- [x] `ternary_gemm` — 4×4 matrix multiply, all tests passing
- [x] Deploy to Xilinx Artix-7 (Arty A7-100T) — single MAC verified on silicon via ILA, 0 DSPs ([write-up](docs/article-02.md))
- [x] Timing closure and resource utilisation report (single MAC: ~81 LUTs / 32 FFs)
- [x] Track A system design: soft CPU (MicroBlaze) + AXI + GEMM array + weight BRAM + Tier 1 A/B benchmark firmware — passing simulation on [`feat/bitnet-accelerator`](https://github.com/Ternarycore/ternarycore/tree/feat/bitnet-accelerator)
- [x] **Tier 1 on hardware** — `Verification PASS` on the Arty A7 (July 25, 2026): 768→768 ternary projection, accelerator 5.32M cycles/pass vs soft-CPU 19.5M cycles/pass on the same silicon — **3.67× speedup** with the GEMM array at ~3% utilization (CPU-fed AXI is the bottleneck, as designed for Tier 1; see the [bring-up article](https://github.com/Ternarycore/ternarycore/blob/feat/bitnet-accelerator/docs/article-03.md))
- [ ] Host→board weight streaming (`LOADW`/`LOADA`/`RUN` UART protocol) — run *real* BitNet checkpoints, not synthetic weights
- [ ] Scale GEMM columns toward the 40 GOPS target (Tier 2)
- [ ] Head-to-head benchmark: tokens/sec and W vs CPU/GPU baseline
- [ ] Full transformer layer pipeline

---

## License

RTL source files (`rtl/`, `tb/`) are licensed under the **CERN Open Hardware Licence v2 — Strongly Reciprocal (CERN-OHL-S v2)**. Derivative hardware designs must remain open under the same terms.

Software tools and verification scripts (`sim/verify/*.py`) are licensed under the **MIT License**.

See [LICENSE](LICENSE) for full terms.

---

## Related Work

- Benchmark repo (KV cache / local LLM inference): [github.com/shepherdscientific/llama-server-tuning](https://github.com/shepherdscientific/llama-server-tuning)
- BitNet b1.58: [arxiv.org/abs/2402.17764](https://arxiv.org/abs/2402.17764)
- CERN-OHL-S v2: [ohwr.org/cern_ohl_s_v2.txt](https://ohwr.org/cern_ohl_s_v2.txt)
