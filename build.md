# TernaryCore Build Plan

> Open-source FPGA accelerator for BitNet b1.58 ternary inference.  
> Weights are `{-1, 0, +1}`. No multiplications. Native hardware.

---

## What This Project Is

BitNet b1.58 encodes every model weight as one of three values: **-1, 0, or +1**. Matrix multiplication therefore collapses into additions, subtractions, and conditional skips — no floating-point multiply-accumulate units needed.

This project builds an FPGA IP core that implements that arithmetic natively. It is not a wrapper around a GPU kernel. It is hardware designed from scratch for ternary math.

All RTL will be open-sourced under the MIT licence from the first commit.

---

## Architecture Overview

```
┌─────────────────────────────────────────────┐
│              TernaryCore IP Core             │
│                                             │
│  Input activations (INT8 or FP16)           │
│         │                                   │
│         ▼                                   │
│  ┌─────────────────┐                        │
│  │  Ternary GEMM   │  ← weights: 2-bit      │
│  │  Engine         │    encoded {-1,0,+1}   │
│  │  (no multipliers│                        │
│  │   adders only)  │                        │
│  └────────┬────────┘                        │
│           │                                 │
│           ▼                                 │
│  ┌─────────────────┐                        │
│  │  Accumulator    │  ← parallel lanes      │
│  │  Array          │                        │
│  └────────┬────────┘                        │
│           │                                 │
│           ▼                                 │
│  Output (INT32 pre-activation)              │
└─────────────────────────────────────────────┘
```

### Weight Encoding

| Ternary value | 2-bit code |
|---------------|------------|
| 0             | `00`       |
| +1            | `01`       |
| -1            | `10`       |

A 2-bit weight drives a 3-way mux: pass activation unchanged (+1), negate it (-1), or zero it (0). No multiplier instantiated — ever.

### Key Design Parameters (configurable)

| Parameter       | Default | Description                              |
|-----------------|---------|------------------------------------------|
| `DATA_WIDTH`    | 8       | Input activation bit width               |
| `ACC_WIDTH`     | 32      | Accumulator width                        |
| `VECTOR_LEN`    | 64      | Dot product vector length per cycle      |
| `NUM_LANES`     | 16      | Parallel accumulation lanes              |

---

## Directory Structure

```
ternarycore/
├── build.md                    ← you are here
├── SIMULATION_GUIDE.md         ← start here if running sim for first time
├── CONTRIBUTING.md
├── rtl/
│   ├── ternary_mac.v           ← single multiply-accumulate cell
│   ├── ternary_dot.v           ← vector dot product (VECTOR_LEN cells)
│   ├── ternary_gemm.v          ← tiled matrix multiply
│   └── top.v                   ← top-level integration
├── tb/
│   ├── tb_ternary_mac.v        ← unit testbench
│   ├── tb_ternary_dot.v
│   └── tb_ternary_gemm.v
├── sim/
│   ├── Makefile                ← `make sim` runs full sim suite
│   └── verify/
│       └── verify_mac.py       ← Python reference checker
├── constraints/
│   └── arty_a7_100t.xdc        ← pin constraints for Arty A7-100T
├── scripts/
│   └── synth_arty.tcl          ← Vivado synthesis script
└── results/
    └── benchmarks.md           ← published benchmark data
```

---

## Phase 1: Simulation on Mac (Start Here)

> See **SIMULATION_GUIDE.md** for the full step-by-step walkthrough.

Three tools, all free, all native on macOS:

```bash
brew install icarus-verilog verilator gtkwave
```

| Tool         | What it does                                       |
|--------------|----------------------------------------------------|
| `iverilog`   | Compiles and simulates Verilog — simplest path     |
| `verilator`  | Compiles Verilog to C++, 10–100× faster simulation |
| `gtkwave`    | Views waveform `.vcd` files — your oscilloscope    |

**Vivado** (Xilinx's synthesis tool) is Linux/Windows only and is NOT needed for simulation. You only need it when programming a real FPGA board.

---

## Phase 2: First Real Hardware — Arty A7-100T

**Digilent Arty A7-100T** — recommended first board.

| | |
|-|-|
| FPGA | Xilinx Artix-7 XC7A100T |
| Logic cells | 101,440 |
| Block RAM | 4.86 Mb |
| DSP slices | 240 |
| Price (new) | ~$179 at digilent.com |
| Price (used) | ~$80–120 on eBay |
| Vivado tier | Free WebPACK (no licence needed) |

**Where to buy:**
- New: [digilent.com](https://digilent.com) — official, ships fast
- Used: eBay — search `Arty A7 100T` or `Xilinx Artix 7 dev board`
- Also: Mouser, Digi-Key

> ⚠️ Avoid AliExpress clones — FPGA chips are often counterfeit and Vivado will refuse to program them.

**Why not the 35T?** The 100T has 3× the logic cells and fits more parallel accumulation lanes — worth the extra $80.

### Vivado setup
1. Download WebPACK (free) from [xilinx.com/support/download](https://www.xilinx.com/support/download)
2. Install on Ubuntu 22.04 — run in UTM (free VM app, excellent on Apple Silicon Mac)
3. Artix-7 is in the free WebPACK tier — no licence file needed
4. Use `scripts/synth_arty.tcl` in this repo to automate synthesis

---

## Phase 3: Benchmark-Grade Hardware — Xilinx Alveo

This is what the Crowd Supply campaign funds.

| Card | LUTs | Memory | PCIe | Used price (eBay) |
|------|------|--------|------|-------------------|
| Alveo U50 | 872K | 8GB HBM2 | Gen4 x16 | ~$800–1,500 |
| Alveo U250 | 1.7M | 64GB DDR4 | Gen3 x16 | ~$1,500–3,000 |
| Alveo U280 | 1.1M | 8GB HBM2 + 32GB DDR4 | Gen4 x16 | ~$1,200–2,500 |

**Recommended: Alveo U50** — HBM2 bandwidth is critical; U50 is the most affordable entry point. Buy used on eBay.

Alveo requires: PCIe x16 host slot + Linux + Xilinx Runtime (XRT) driver. The Phase 2 AI lab machine handles this.

---

## Implementation Checklist

### Phase 1 — Simulation (Mac Mini, zero hardware cost)
- [ ] Run `tb_ternary_mac` — all 8 test vectors pass
- [ ] Implement `ternary_dot.v` + testbench — dot product matches Python reference
- [ ] Implement `ternary_gemm.v` + testbench — matrix multiply matches NumPy reference
- [ ] Screenshot passing testbench output → submit Crowd Supply application

### Phase 2 — Arty A7 Bringup (~$100–180)
- [ ] Synthesise `ternary_gemm` for Artix-7 in Vivado
- [ ] Meet timing at 100 MHz
- [ ] Program board, verify output over UART
- [ ] Measure power consumption
- [ ] Publish first real-hardware numbers

### Phase 3 — Alveo Benchmark (Crowd Supply funded)
- [ ] Port design to Alveo U50
- [ ] Integrate with XRT host driver
- [ ] Run BitNet 1B inference vs GPU baseline
- [ ] Publish tokens/sec and tokens/watt
- [ ] Release final open-source RTL + benchmark scripts

---

## Reference Links

- Motivating benchmarks: [github.com/shepherdscientific/llama-server-tuning](https://github.com/shepherdscientific/llama-server-tuning)
- BitNet paper: [arxiv.org/abs/2402.17764](https://arxiv.org/abs/2402.17764)
- Digilent Arty A7 docs: [digilent.com/reference/programmable-logic/arty-a7/start](https://digilent.com/reference/programmable-logic/arty-a7/start)
- Vivado WebPACK: [xilinx.com/support/download](https://www.xilinx.com/support/download)
- Crowd Supply pre-launch: *(add link when live)*
