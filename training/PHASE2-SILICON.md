# Phase 2 — DDR3/MIG + weight paging on silicon (2026-08-02)

**Desktop-inference plan Phase 2 core milestone: DEMONSTRATED.**
Model layers resident in DDR3, paged into the weight BRAM, streamed through
the COLS=64 array, bit-exact against the training-side reference.

## The system (bitstream `arty_ddr`, build #8)

- MIG 7-series from the Digilent Arty `mig.prj` (DDR3-650, 256 MB @ 0x80000000)
- MicroBlaze with 16 KB I/D caches over DDR, hand-built subsystem (no BD automation)
- Whole design on MIG `ui_clk` (~81.25 MHz); UART DLL 44
- Tier-2 stream engine + weight_bram128 carried over unchanged
- Timing: **WNS +1.153 ns, 0 failing endpoints**

## Measurements

| Step | Result |
|---|---|
| MEMTEST (4096 words strided across 64 MB) | **OK** — MIG calibrated, cached AXI path correct |
| LOADM 256 KB layer → DDR over UART | 22.8 s (≈11.5 KB/s — UART-bound, one-time) |
| PAGE (DDR → BRAM, CPU memcpy 256 KB) | ~48–49 ms incl UART marks (≈5.4 MB/s) |
| Stream tile after page | **1,031 cycles** — identical to Tier-2/sim |
| Layer 0 k_proj (DDR-resident) | **EXACT-MATCH** |
| Layer 27 v_proj (DDR-resident) | **EXACT-MATCH** |

## Bring-up ladder (8 builds, 1 boot bug — all diagnosed from logs)

1–2. mig_7series bd-automation rule broke (Vivado 2025.2 `board_if` var) →
   switched to feeding Digilent's `mig.prj` directly + hand-built subsystem.
3. mdm pin typo. 4. `M_AXI_DP` needs `CONFIG.C_D_AXI`. 5. MIG preset wants a
   200 MHz `clk_ref_i` — external clk_wiz fought the pad IBUF; the preset
   generates its own 200 MHz on `ui_addn_clk_0` (MMCM /3.25 of 650) — loop it.
6–7. builds pass. First boot: dead UART → xsdb: *“Cannot stop MicroBlaze.
   Stalled on instruction fetch. PC=0x18”* → `assign_bd_address` had auto-
   placed LMB at **0x2000/8 KB** (CPU boots at 0x0) → pinned 0x0/64 K.
8. Boot: PONG, MEMTEST OK, demo green. (Blackout #6 interrupted mid-debug;
   UPS suspend fired but NVIDIA refused pre-reboot — option active now.)

## Honest notes

- Paging is CPU memcpy at ~5.4 MB/s: 49 ms/page vs 0.2 ms compute per
  64-col pass — the pager now dominates layer latency, exactly as the plan
  predicted; the DMA/double-buffer pager is the Phase-2 optimization stage,
  not needed for the milestone.
- Wide layers (q/o/MLP) use the same host-tiling as D5, now sourced from
  DDR pages: one 256 KB page per column-tile/depth-chunk.
- Full-model residency needs the remaining LOADM sweep (110 MB over UART
  ≈ 2.7 h one-time, or wait for Ethernet/Phase-3).

## Plan position after today

Phase 0 ✅ · Phase 1 ✅ (557×) · **Phase 2 core ✅** (DMA pager pending) ·
Phase 3 Ethernet — unblocked (cached MicroBlaze exists) · Phase 4/5 next.
