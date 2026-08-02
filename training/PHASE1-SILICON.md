# Phase 1 — Tier-2 streaming GEMM on silicon (2026-08-02)

**Desktop-inference plan Phase 1: COMPLETE. Exit criterion ≥500×: achieved 557×.**

| Measurement | Value |
|---|---|
| Cycles per 64-col tile pass (1024 elements) | **1,031** — identical to simulation (1031) |
| Full 1024-col layer (16 tiles), pure datapath | 16,496 cycles |
| Full layer incl. AXI poll overhead (measured wall) | ~15,988 cycles-equivalent |
| Baseline: CPU-fed same layer (D5 measurement) | 9,183,783 cycles |
| **Speedup** | **557× pure / 574× incl-poll** |
| Throughput | **12.7 GOPS @ 100 MHz, 0 DSP** |
| Verification | HOST REFERENCE MATCH — distilled-model k_proj (block 0), board vs NumPy |
| Timing | WNS +0.377 ns @ 100 MHz, 0 failing endpoints |
| Utilization (clean, debug-stripped) | 3,957 slices (25%), LUT section 10,179 — debug attrs had inflated the array ~2.5× |

## The bring-up ladder (3 builds, all diagnosed from reports)

1. **Build 1 FAILED**: 128-bit BRAM write used variable-offset partial writes
   → block-RAM inference broke → 131,072 LUT-RAMs (7× the chip). Fix: the
   canonical byte-enable write pattern (constant-offset unrolled loop).
   Second defect behind it: live stream port + AXI readback = 3 memory ports
   → BRAM replication over budget. Fix: readback removed (returns 0xDEADBEEF;
   verification is host-side).
2. **Build 2 FAILED**: 16,626/14,915 slices. Root cause: `mark_debug` /
   `dont_touch` / `keep` attributes on ternary_dot outputs — 64 instances of
   pinned debug registers blocking optimization (the long-pending "clean
   debug-stripped re-synthesis" from the P1 checklist). Fix: stripped;
   TB re-passed unchanged.
3. **Build 3 PASSED**: bitstream + timing met.

Sim-to-silicon cycle-exact parity (1031 = 1031) after the discipline of
"iverilog first, Vivado second" — the integration TB caught the two RTL
bugs (port name, depth-latch semantics) before synthesis ever ran.

## P1 paper impact

- §6.4 Tier-2 on-hardware: **CLOSED** (this measurement)
- §6.1/6.5 clean debug-stripped utilization: **CLOSED** (build-3 reports)
- Remaining paper gate: energy (§6.6, blocked on shunt delivery)

## Artifacts

- Bitstream: `arty_mb_gemm.runs/impl_1/` (tier2), previous archived to `~/bitstreams/`
- RTL: `rtl/axi_gemm_stream.v`, `rtl/weight_bram128.v` + TB `tb/tb_axi_gemm_stream.v`
- Firmware: generated `firmware/tier2_host.c` (tools/make_tier2_fw.py), driver `host/tier2_host.py`
- Raw log: `~/tc-tier2-bench2.log` on fort
