# D5 — Our own distilled model on TernaryCore silicon (2026-08-01)

**Layer-level exact-match verification of `d4-student-sst2` (the SST-2
ternary student distilled this morning) on the Arty A7-100T, DEPTH=1024
bitstream, branch `feat/d5-arty`.**

| Layer (1024×1024) | LOADW | Board accel vs board SW | Board vs NumPy reference | Speedup vs soft CPU |
|---|---|---|---|---|
| block 0 `k_proj` | 262,144 B, checksum match | VERIFY PASS | **EXACT MATCH** | 3.54× (9.18 M vs 32.5 M cycles/pass) |
| block 27 `v_proj` | 262,144 B, checksum match | VERIFY PASS | **EXACT MATCH** | 3.45× |

Pipeline proven end-to-end: **Qwen3-0.6B → SubLN surgery → 100 M-token QAT
warm-up → SST-2 logit-KD distillation → absmean snap → 2-bit pack → UART
LOADW → multiplier-free ternary GEMM on Artix-7 — bit-exact against the
training-side reference.** The model trained overnight computes on the
hardware the same afternoon.

Bring-up notes (all recoverable, all logged):
- 1024×1024 packed layer = 262,144 bytes = exactly the 256 KB weight BRAM.
- Blackout #3 truncated freshly written test vectors to 0 bytes (ext4
  delayed allocation) — the "0-byte LOADW, checksum 0 match, all-zero
  outputs" run is a good cautionary log; regenerate with `os.sync()`.
- First PING timeout was a programming race after power-cycle; second xsdb
  pass + manual PONG check resolved it (same two-pass pattern as Tier-1).
- Scope of DEPTH=1024 single-tile testing: layers with in=1024 and out≤1024
  (k/v projections). q (out 2048), o (in 2048) and MLP (3072) need the
  firmware out-tiling extension or Tier-2 paging — next hardware step.

Firmware/BD deltas live in this branch (create_bd.tcl CONFIG.DEPTH 1024,
tier1_host.c DEPTH/COLS_TOTAL 1024, stubs.c recreated).
