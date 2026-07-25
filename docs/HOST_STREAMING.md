# Host→Board Streaming: The Path from Layer Benchmark to Model Benchmark

> Status: plan (July 2026). Tier 1 (on-chip synthetic weights, CPU vs
> accelerator A/B) is the current milestone. This document defines what it
> takes to benchmark a *real BitNet model* — and where the Arty A7 stops
> being the right board.

---

## Stages

### Stage 1 — UART command protocol (days, no new RTL)

The smallest step that upgrades the benchmark from synthetic weights to
**real BitNet checkpoint layers**.

```
Host (python)                     MicroBlaze firmware
  LOADW <addr> <nbytes>  ───────►  write packed weights into weight BRAM
  LOADA <nbytes>         ───────►  load activation vector
  RUN <passes>           ───────►  run benchmark, reply with results
```

- Firmware: extend `tier1_bare.c` with a tiny UART command parser.
- Host: python sender that calls `tools/weights-to-mem.py` on a checkpoint
  layer and streams it. The Arty's FT2232 sustains 3 Mbaud — the 256 KB
  weight BRAM fills in about a second.
- Result: `Verification PASS` and cycle counts on a *real* `bitnet_b1_58`
  projection layer, not a synthetic pattern.

### Stage 2 — DDR3 + DMA (1–2 weeks)

To hold more than one layer:

- MIG DDR3 controller (~8K LUTs, already budgeted in ROADMAP.md).
- DMA (or a simple mover) ping-pong-buffering weight tiles DDR→BRAM so the
  GEMM array never stalls.
- Widen the result interface past the current 4 AXI-exposed columns.
- Ethernet (Arty has 10/100): ~10 MB/s means a whole packed model loads in
  ~15 s instead of ~8 min over UART. lwIP on MicroBlaze.

### Stage 3 — the actual model (weeks)

A transformer is not just ternary GEMMs. Missing pieces, none of which
TernaryCore can do (they are not ternary-weight operations):

| Op | Why not ternary | Where it runs |
|---|---|---|
| Attention QK^T, PV | activation × activation | int8 MAC unit on the 240 idle DSP48s |
| RMSNorm, softmax, rotary | scalar/elementwise | MicroBlaze (or small fixed-function units) |
| KV cache | storage + bandwidth | DDR3 |
| Embedding, sampling | lookup / host-side | MicroBlaze or host |

Legitimate interim publish: host does attention + norms, board does every
ternary projection — framed exactly as "all BitNet weight layers on FPGA."

---

## Bandwidth math: what the Arty A7 can and cannot do

Single-token inference reads every weight once per token. That makes model
benchmarking **memory-bandwidth-bound**, not LUT-bound:

| Quantity | Value |
|---|---|
| bitnet_b1_58-large (729M params) packed at 1.6 bit/w | ~146 MB |
| Arty DDR3 (16-bit, 667 MT/s) through MIG, realistic | ~0.9–1.3 GB/s |
| **Tokens/sec ceiling (bandwidth)** | **~5–7 tok/s** |
| 400-column GEMM array @ 100 MHz (40 GOPS) could sustain | ~27 tok/s |
| Microsoft BitNet-2B-4T packed | ~480 MB — **does not fit** 256 MB DDR3 |

The compute array outruns the memory 4× — adding columns past ~150 buys
nothing for full-model inference on this board. Against MicroBlaze pure
software (~minutes per token) the accelerated path is still a ~100×+ story,
and that A/B on identical silicon is the point of the Arty track.

## Board comparison for model-level benchmarking

| Board | ~Price | What changes | Realistic target |
|---|---|---|---|
| **Arty A7-100T** (owned) | — | pure fabric + soft CPU; the with/without-ternary proof machine | ≤700M models @ ~5 tok/s ceiling; layer benchmarks |
| **Arty Z7-20 / PYNQ-Z2** (Zynq-7020) | ~$150–230 | hard dual Cortex-A9 + Linux **deletes the host-streaming problem**: weights via Ethernet/SD, ARM runs attention/norms, fabric does ternary GEMM over AXI. A/B becomes "ARM NEON vs ARM + ternary fabric" | working model in days, similar tok/s ceiling to Arty |
| **Kria KV260** (Zynq US+) | ~$250 | 4 GB DDR4 >10 GB/s, ~3× faster fabric | 2B-4T fits; tens of tok/s |
| **Alveo U50** (budgeted) | — | 8 GB HBM2 @ ~316 GB/s, PCIe host | 100+ tok/s on 2B models; the "beats a desktop CPU" tier |

**Recommendation.** Stage 1 on the Arty now (real-weight layer benchmarks,
protects the current momentum). Keep the Arty as the clean
with/without-ternary proof. Do model-level tokens/sec on a Zynq-class board
or the U50 — don't force the Arty into a role its memory bus can't sustain.
