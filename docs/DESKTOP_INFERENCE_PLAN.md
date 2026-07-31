# Desktop Inference Plan — Arty A7-100T

> **Goal:** turn the Arty A7-100T into an Ethernet-attached BitNet inference
> service. The desktop sends a prompt; the board sends back tokens. Every
> weight-layer GEMM runs on the ternary array; the desktop supplies nothing
> but token IDs and receives nothing but logits.
>
> **Status baseline (2026-07-31):** Tier-1 silicon-validated (3.55–3.67× vs
> soft CPU, real BitNet b1.58 weights, 6/6 layers exact match). Tier-2
> line-rate feeder sim-verified (771 cycles/768-deep pass, 64 MACs/cycle,
> 12.8 GOPS @ 100 MHz). INT8 same-fabric baseline built. UART host protocol
> (LOADW/LOADA/RUN) proven at three-way verification.

---

## 1. What "desktop inference" means on this board

The XC7A100T-CSG324 bonds **zero GTP transceivers** — there is no PCIe path,
ever, on this package. The Arty therefore attaches to a desktop the only way
it can: as a **network service**.

```
┌──────────────┐   Ethernet 100 Mb/s     ┌─────────────────────────────────┐
│   Desktop    │   (lwIP UDP, ~8–10 MB/s)│  Arty A7-100T                   │
│  Python      │◄───────────────────────►│  MicroBlaze  ── request/response│
│  client +    │                         │      │        server           │
│  tokenizer   │                         │  AXI interconnect               │
└──────────────┘                         │   ├─ MIG ── DDR3 256 MB        │
                                         │   │         (weights + KV)      │
                                         │   ├─ weight pager (DMA)         │
                                         │   └─ ternary_gemm_stream        │
                                         │      64 MACs/cycle @ 100 MHz    │
                                         └─────────────────────────────────┘
```

Division of labor, fixed from the start:

| Piece | Runs where | Why |
|---|---|---|
| Tokenizer, sampling UI | Desktop | Pure software; no reason to burden the board |
| Weight-layer GEMMs (q/k/v/o/gate/up/down) | Ternary array | The whole point |
| Embeddings lookup, KV cache | DDR3 (MicroBlaze-managed) | Bandwidth-light, capacity-heavy |
| RMSNorm, softmax, RoPE, quant/requant | MicroBlaze C first; int8/DSP offload only if profiling demands it | Activation-domain ops, out of ternary scope |

**Target model:** `1bitLLM/bitnet_b1_58-large` (~729 M params). Packed at
2 bits/weight ≈ 175 MB — fits DDR3 with ~80 MB left for KV cache, activations,
and MicroBlaze code/heap. The 2B4T checkpoint (~480 MB packed) does **not**
fit and is permanently out of scope for this board.

## 2. The performance ceiling, stated up front

Per generated token, every weight must be read once from DDR3:

- **Memory bound:** 175 MB ÷ ~1 GB/s effective DDR3 bandwidth ≈ **175 ms → 5.7 tok/s**
- **Compute bound:** ~1.46 GOP/token ÷ 12.8 GOPS ≈ 114 ms → 8.7 tok/s
- **Realistic, with overlap and protocol overhead: 4–6 tok/s**

This is a *bandwidth-bound* design point and we say so honestly everywhere we
publish it. The deliverable is not a fast assistant; it is a complete,
verified, open, multiplier-free inference pipeline on a $299 board — and the
measured proof that the array is no longer the bottleneck, the memory is.

## 3. Phases

Each phase ends in something demonstrable and publishable on its own. No
phase gates on the distillation track (all validation uses the published
checkpoint).

### Phase 1 — Tier-2 feeder on silicon *(days; next fort session)*

The feeder (`rtl/ternary_gemm_stream.v`) is sim-verified; it has never met
the fabric. Silicon has humbled this project three times — assume a fourth.

- Integrate the streaming feeder into the Tier-1 SoC: activation BRAM +
  weight BRAM dual-ported to the feeder, AXI-Lite control (START, base
  addresses, DONE + result readback).
- Reuse the gap-injection discipline: a hardware smoke test that runs one
  768-deep pass and compares against the C reference before any benchmark.
- Benchmark with the existing MARK-line host timing.

**Exit criteria:** exact-match on a real 768×768 BitNet layer; ≥500× vs the
CPU-fed path (sim predicts ~574×); timing closed at 100 MHz.
**Risks:** BRAM port contention with the AXI write path; the 64-column result
readback (2 KB of accumulators) needs a widened or sequenced read port.

### Phase 2 — DDR3 via MIG + weight paging *(2–4 weeks; the big lift)*

Today weights live in 256 KB of BRAM — one layer at a time, loaded over UART.
Real inference needs the whole 175 MB model resident and paged layer-by-layer.

- MIG 7-series core bring-up (200 MHz ref clock, calibration on the Arty's
  DDR3L part), AXI4 port into the interconnect.
- **Enable MicroBlaze I/D caches** and relocate code/heap to DDR3. This is a
  prerequisite hiding inside this phase: lwIP (Phase 3) cannot live in 64 KB
  LMB, and a cacheless MicroBlaze executing from DDR3 is unusably slow.
- Weight pager: AXI datamover/DMA that streams the next layer's packed
  weights DDR3 → BRAM while the array chews the current layer
  (double-buffered ping/pong). At ~147 KB per 768×768 layer and ~1 GB/s,
  a page-in is ~150 µs against ~9,250 cycles (~92 µs) of compute — paging
  and compute are the same order, so the overlap is not optional decoration,
  it is the design.
- Extend the UART protocol first (LOADM: bulk model upload to DDR3) so
  Phase 2 is testable before Ethernet exists — upload at UART speed once,
  then run many passes.

**Exit criteria:** all six matrices of a transformer block executed
back-to-back from DDR3-resident weights with automatic paging, exact match
vs NumPy; measured pager overlap efficiency.
**Risks:** MIG calibration is the classic FPGA time sink; interconnect
arbitration between MicroBlaze cache traffic and the pager; timing pressure
from the added AXI fabric. Budget says 2 weeks; history says 4.

### Phase 3 — Ethernet host link *(1–2 weeks)*

Replace the 11 KB/s UART with the board's 10/100 PHY.

- AXI EthernetLite + lwIP (raw API, UDP) on the now-cached MicroBlaze.
- Port the proven protocol: `LOADM` (one-time model upload, ~175 MB at
  8–10 MB/s ≈ 20–25 s, chunked + checksummed exactly like LOADW),
  `PROMPT` (token IDs in), `LOGITS`/`TOKEN` (results out), `PING`/`STATS`.
- Keep UART alive as console + fallback — it is the debug lifeline.

**Exit criteria:** desktop Python client uploads the model, runs the Phase-2
block-sweep over Ethernet, checksums verified end-to-end; sustained ≥8 MB/s.
**Risks:** lwIP memory tuning; packet loss handling on UDP (simple
seq/ack + retransmit, same spirit as the UART checksum protocol).

### Phase 4 — Full transformer layer on board *(2–3 weeks; the long pole)*

Everything that is not a weight-layer GEMM, in MicroBlaze C first:

- Embedding lookup from DDR3; RMSNorm; RoPE; attention scores + softmax
  (int8 in/out with per-tensor scales, fp accumulation in software);
  KV cache append/read in DDR3; absmax activation quantization between ops.
- Profile with the MARK method per op. Only ops that dominate get offloaded
  to a small int8/DSP helper — resist building hardware nobody measured
  a need for.
- Verification: layer-by-layer lockstep against a NumPy reference of the
  same checkpoint, tolerance-checked at int8 precision (exact match where
  exact is defined, ULP-bounded where it is not).

**Exit criteria:** one full transformer layer (attention + FFN) computed
entirely on-board matches the reference; a cycle budget table showing where
the token's time actually goes.
**Risks:** softmax/norm cost on a soft CPU may dominate and drag tok/s below
the bandwidth ceiling — this is *the* open measurement, and either result is
publishable.

### Phase 5 — Autoregressive tokens *(1–2 weeks)*

- Loop Phase 4 across all layers with the pager; greedy decode first,
  temperature sampling on the desktop after.
- Desktop client: tokenizer (HF `tokenizers`), streaming display,
  tok/s telemetry.
- The demo: type a prompt on the desktop, watch tokens arrive from a $299
  FPGA running a multiplier-free ternary datapath.

**Exit criteria:** sustained text generation; measured tok/s vs the 4–6
prediction; energy per token once the shunt arrives (method already in
P1 §5).

## 4. Schedule and dependencies

```
P1 Tier-2 silicon ──► P2 MIG + paging ──► P3 Ethernet ──► P4 full layer ──► P5 tokens
   (days)               (2–4 wk)            (1–2 wk)        (2–3 wk)          (1–2 wk)
```

P3 depends only on P2's cache work, not on the pager — it can start as soon
as MicroBlaze runs cached from DDR3, overlapping the pager debug. Total:
**~2–3 months part-time**, with a publishable milestone at every arrow.

| Milestone | Publishable artifact |
|---|---|
| P1 done | Article-04: "574× — feeding the array at line rate" + P1 paper §6.4 hw numbers |
| P2 done | Whole-block-from-DDR3 result; P1 paper discussion §7 strengthened |
| P3 done | Live demo video: Ethernet-attached accelerator |
| P4 done | Cycle-budget-per-token table (nobody publishes these honestly) |
| P5 done | The money demo + tok/s + energy/token → Article-05 and P1 camera-ready |

## 5. What this plan deliberately does not do

- **No PCIe work on the Arty** — physically impossible (zero GTP on CSG324).
  If desktop-class latency ever matters, that is an M.2 Artix-7 board
  (Acorn CLE-215+/LiteFury, ~$100–200, LiteX/LitePCIe) in fort's M.2 slot —
  same RTL, different shell. Documented as the upgrade path, not scoped here.
- **No 2B4T** — 480 MB packed does not fit 256 MB DDR3.
- **No custom tokenizer/sampling hardware** — desktop-side forever.
- **No speculative int8 offload hardware** before Phase-4 profiling proves
  which op deserves it.
- **No dependency on the distilled model** — the day our own distilled
  ~700 M ternary checkpoint lands, it drops into `LOADM` unchanged; until
  then, `bitnet_b1_58-large` is the model of record.

## 6. Risk register (top five)

| # | Risk | Phase | Mitigation |
|---|---|---|---|
| 1 | MIG bring-up stalls | P2 | Start from Digilent's known-good MIG project for this exact board; UART console survives all experiments |
| 2 | Timing fails with feeder + MIG + interconnect at 100 MHz | P2 | Feeder already closes with margin standalone; fall back to 83.3 MHz fabric clock (tok/s ceiling barely moves — memory-bound) |
| 3 | Soft-CPU softmax/norm dominates token time | P4 | Measure first; int8 DSP helper second; both outcomes are results |
| 4 | lwIP heap/pbuf exhaustion | P3 | Cached DDR3 heap (P2 prerequisite); UDP raw API, static pbuf pools |
| 5 | Silicon-only bug class #4 we haven't met yet | all | The regression discipline from Tier-1: lint clean, gap-injection TBs, hardware smoke test before every benchmark, one variable at a time |

---

*TernaryCore — CERN-OHL-S v2. Plan drafted 2026-07-31 against the Arty
A7-100T integration guide; supersedes the "Next" section of
docs/HOST_STREAMING.md for desktop-attachment scope.*
