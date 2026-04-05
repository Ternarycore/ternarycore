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

### Key Design Parameters (configurable via parameters)

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
│   └── run_icarus.sh
├── constraints/
│   └── arty_a7_100t.xdc        ← pin constraints for Arty A7-100T
├── scripts/
│   └── synth_arty.tcl          ← Vivado synthesis script
└── results/
    └── benchmarks.md           ← published benchmark data
```

---

## Phase 1: Simulation on Mac (Start Here)

### Tools — no Vivado needed, all free, all run natively on macOS

```bash
brew install icarus-verilog verilator gtkwave
```

| Tool         | What it does                                         |
|--------------|------------------------------------------------------|
| `iverilog`   | Compiles and simulates Verilog — simplest path       |
| `verilator`  | Compiles Verilog to C++, 10-100x faster simulation   |
| `gtkwave`    | Views waveform `.vcd` files — your oscilloscope      |

**Vivado** (Xilinx's synthesis tool) is Linux/Windows only and is NOT needed for simulation. You only need it when you're ready to program a real FPGA board. At that point you run it in a Linux VM (UTM is excellent on Apple Silicon) or Docker.

### Simulation workflow

```bash
# Compile and simulate ternary_mac unit
cd sim
make tb_ternary_mac
# Opens GTKWave with waveform automatically
```

### First RTL to write: `ternary_mac.v`

This is the atomic unit — one ternary multiply-accumulate cell. It's ~20 lines of Verilog. Start here.

```verilog
// ternary_mac.v — single ternary MAC cell
// weight_enc: 2-bit encoded ternary {00=0, 01=+1, 10=-1}
module ternary_mac #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  valid_in,
    input  wire [DATA_WIDTH-1:0] activation,
    input  wire [1:0]            weight_enc,
    input  wire [ACC_WIDTH-1:0]  acc_in,
    output reg  [ACC_WIDTH-1:0]  acc_out,
    output reg                   valid_out
);

    // Ternary multiply: no multiplier, just mux
    wire signed [DATA_WIDTH-1:0] weighted;
    assign weighted = (weight_enc == 2'b00) ? {DATA_WIDTH{1'b0}} :       // 0
                      (weight_enc == 2'b01) ? activation :                 // +1
                                              (~activation + 1'b1);        // -1

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_out   <= '0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            acc_out   <= acc_in + {{(ACC_WIDTH-DATA_WIDTH){weighted[DATA_WIDTH-1]}}, weighted};
            valid_out <= 1'b1;
        end
    end
endmodule
```

This is your prototype. Once you have a testbench proving correct output, you have what Crowd Supply needs to approve your campaign.

---

## Phase 2: First Real Hardware — Arty A7-100T

### What to buy

**Digilent Arty A7-100T** — this is the recommended first board.

| | |
|-|-|
| FPGA | Xilinx Artix-7 XC7A100T |
| Logic cells | 101,440 |
| Block RAM | 4.86 Mb |
| DSP slices | 240 |
| Price (new) | ~$179 at digilent.com |
| Price (used) | ~$80–120 on eBay |
| Vivado support | Free WebPACK tier (no licence needed) |

**Where to buy:**
- New: [digilent.com](https://digilent.com) — official, ships fast
- Used: eBay — search "Arty A7 100T" or "Xilinx Artix 7 dev board"
- Also available: Mouser, Digi-Key (same price as Digilent)

> ⚠️ Avoid AliExpress clones of Xilinx boards — the FPGA chips are often counterfeit and Vivado will reject them during device programming.

**Why not the 35T (smaller/cheaper)?** The 100T has 3x the logic and fits more accumulation lanes — worth the extra $80 for this project.

### Vivado setup for Arty A7

Vivado WebPACK (free, no licence) fully supports Artix-7:
1. Download from [xilinx.com/support/download](https://www.xilinx.com/support/download)
2. Install on Linux (Ubuntu 22.04 in a VM via UTM on your Mac Mini, or native Linux machine)
3. Artix-7 devices are in the WebPACK free tier — no licence needed
4. Use `scripts/synth_arty.tcl` (in this repo) to automate synthesis

---

## Phase 3: Benchmark-Grade Hardware — Xilinx Alveo

This is what the Crowd Supply campaign funds.

| Card | LUTs | HBM / DDR | PCIe | Used price (eBay) |
|------|------|-----------|------|-------------------|
| Alveo U50 | 872K | 8GB HBM2 | Gen4 x16 | ~$800–1,500 |
| Alveo U250 | 1.7M | 64GB DDR4 | Gen3 x16 | ~$1,500–3,000 |
| Alveo U280 | 1.1M | 8GB HBM2 + 32GB DDR4 | Gen4 x16 | ~$1,200–2,500 |

**Recommended: Alveo U50** — HBM2 is critical for memory bandwidth, and the U50 is the most affordable entry point. Buy used on eBay.

The Alveo cards require a host machine with a PCIe x16 slot and a Linux driver stack (Xilinx Runtime, XRT). Your Phase 2 AI lab machine (see separate spec) will host this.

---

## Implementation Phases

### Phase 1 — Simulation (Mac Mini, no hardware cost)
- [ ] Implement `ternary_mac.v` — single MAC cell
- [ ] Testbench: verify +1, -1, 0 weight paths produce correct accumulation
- [ ] Implement `ternary_dot.v` — 64-element vector dot product
- [ ] Testbench: random vector correctness vs Python reference
- [ ] Implement `ternary_gemm.v` — tiled matrix multiply
- [ ] End-to-end test: run a small BitNet weight matrix through the design
- [ ] Screenshot testbench output → submit Crowd Supply application

### Phase 2 — Arty A7 Bringup (~$100–180 hardware)
- [ ] Synthesise `ternary_gemm` for Artix-7 with Vivado
- [ ] Meet timing at 100MHz
- [ ] Program board, verify output over UART
- [ ] Measure power consumption (Artix-7 has onboard current sensing)
- [ ] Publish first real-hardware numbers

### Phase 3 — Alveo Benchmark (Crowd Supply funded)
- [ ] Port design to Alveo U50 (HLS or straight RTL)
- [ ] Integrate with XRT host driver
- [ ] Run BitNet 1B inference benchmark vs GPU baseline
- [ ] Publish tokens/sec and tokens/watt comparison
- [ ] Release final open-source RTL + benchmark scripts

---

## AI-Assisted Development

The [ralph loop](https://github.com/shepherdscientific/mr-wiggum) (AI agent → commit → review → repeat) is designed for software and is not directly portable to HDL — synthesis tools, timing closure, and hardware simulation require domain-specific steps that a general bash loop can't manage.

However, AI assistance is still highly valuable here in a manual-loop pattern:

1. **Write a testbench first** (what output do you expect?)
2. **Ask Claude / Copilot to implement the RTL** to pass that testbench
3. **Run simulation** — `make sim`
4. **Paste failing waveform / error back** into the AI chat
5. **Iterate** until testbench passes
6. **Only then** move to synthesis

This is essentially a TDD (test-driven) loop for hardware. The testbench is your spec. Simulation is your unit test runner.

---

## Reference Links

- Benchmark repo that motivated this project: [github.com/shepherdscientific/llama-server-tuning](https://github.com/shepherdscientific/llama-server-tuning)
- BitNet paper: [arxiv.org/abs/2402.17764](https://arxiv.org/abs/2402.17764)
- Digilent Arty A7 docs: [digilent.com/reference/programmable-logic/arty-a7/start](https://digilent.com/reference/programmable-logic/arty-a7/start)
- Vivado WebPACK download: [xilinx.com/support/download](https://www.xilinx.com/support/download)
- Crowd Supply pre-launch: *(add link when live)*
