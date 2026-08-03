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

## Phase 2.5 + 3 — CDMA pager and Ethernet first light (build 14, 2 Aug)

Build 12 closed timing (WNS +0.988 ns) with zero errors and was
**functionally dead**: every layer returned all-zeros. Two silent
address-decode failures, caught only because the regression runs on every
bitstream.

- **Bug 1** — hanging the CDMA off `axi_smc` gave the CPU a second route to
  `weight_bram`. Vivado bound the segment to `M_AXI_DC`, but MicroBlaze
  issues non-cacheable addresses on `M_AXI_DP`, which had no decode: DECERR
  on every weight write, and bare-metal firmware never checks `bresp`.
- **Bug 2** — `assign_bd_address` auto-**excluded** `weight_bram` from the
  CDMA's address space: wire present, decode absent. `CDMA SR 0x5042` =
  DMADecErr. A `catch` had hidden the failure, so it shipped.

Fixes: a private SmartConnect crossbar per master, an explicit
`include_bd_addr_seg`, and build-time assertions on the address map — a
bitstream can no longer reach silicon with a master that cannot reach its
slave.

Build 14 (WNS +1.049 ns, WHS +0.013 ns):

| Measurement | Result |
|---|---|
| phase2_demo | 2/2 DDR-resident layers paged + computed EXACT |
| PAGEDMA correctness | 2/2 EXACT |
| PAGEDMA per 256 KB page | **4.750 ms** (n=64 and n=256 agree) |
| CPU pager per page | 47.998 ms |
| Speedup | **10.1x** |
| ETHLINK | PHY 1, ID1 0x2000, BMSR 0x786d — **LINK UP** |

4.750 ms is 55 MB/s against a 325 MB/s ceiling at 81.25 MHz (~5.9 cycles
per 32-bit word): the CDMA is not bursting into the BRAM. Widening its
data path is follow-up work, not a blocker.

## Build 15 — AXI4 burst slave on silicon (WNS +1.316 ns)

| Measurement | Build 14 | Build 15 |
|---|---|---|
| PAGEDMA per 256 KB page | 4.750 ms | **~0.94 ms** |
| cycles per 32-bit word | 5.9 | **1.16** (sim predicted 1.25) |
| CPU PAGE per page | 47.998 ms | 63.994 ms (slower, see below) |
| phase2_demo via PAGEDMA | 2/2 EXACT | 2/2 EXACT |
| phase2_demo via CPU PAGE | 2/2 EXACT | 2/2 EXACT |
| tile cycles | 1031 | 1031 |

Measured by slope, so the UART latency on the MARK lines cancels:

| n pages | total | slope | cycles/word |
|---|---|---|---|
| 64 → 128 | 47.98 → 111.97 ms | 1.000 ms/page | 1.24 |
| 128 → 256 | 111.97 → 223.99 ms | 0.875 ms/page | 1.09 |
| 256 → 512 | 223.99 → 463.98 ms | 0.937 ms/page | 1.16 |

Silicon lands on the simulated 1.25 cycles/word. **5.1x faster than build 14**,
and 68x faster than the CPU pager.

The CPU `PAGE` path got *slower*, 48 -> 64 ms, and that is expected: a
single-word CPU write is now an AWLEN=0 burst, so it walks IDLE -> DATA ->
RESP instead of firing AW and W together. Three cycles instead of two, on a
path that PAGEDMA supersedes. Worth knowing, not worth fixing.

Block 0 re-verified on build 15: all 7 projections, 15 tiles, EXACT via host
tiling. The burst slave changes how weights arrive, not what arrives.

## Build 16 — CDMA max burst 16 -> 256 beats (WNS +1.316 ns)

| n pages | total | slope | cycles/word |
|---|---|---|---|
| 256 -> 512 | 207.98 -> 415.97 ms | 0.8125 ms/page | 1.01 |
| 512 -> 1024 | 415.97 -> 831.97 ms | 0.8125 ms/page | 1.01 |

**0.8125 ms/page, 1.01 cycles/word.** The floor for a 32-bit AXI port at
81.25 MHz is 0.806 ms, so the pager runs at 99.2% of what this bus width can
deliver; nothing further is winnable without widening the port. 78.8x the CPU
pager, 5.85x build 14, implying ~2.9 tok/s for a 110 MB model at 420 pages
per token.

Correctness unchanged: phase2_demo 2/2 EXACT on both --pager dma and
--pager cpu; tile cycles still 1031.

## Build 18 — int8 attention path in the bitstream (WNS +0.862 ns)

CTRL bit3 selects int8 mode; the feeder expands one bit-slice of 64 int8
operands per sub-cycle into the array 2-bit codes and shifts the activation.
The array is untouched. Timing: +1.316 -> +0.862 ns, the wider datapath cost
0.45 ns and still closes with margin, so no pipelining was needed.

Silicon regression on the new bitstream: phase2_demo 2/2 EXACT, 1031 cycles.
