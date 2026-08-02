# D5 — Our own distilled model on TernaryCore silicon (2026-08-01)

**Verification of the distilled ternary student on the Arty A7-100T,
DEPTH=1024 bitstream, branch `feat/d5-arty`.**

## Result 1 — First layers, exact

| Layer (1024×1024) | LOADW | Accel vs SW | Board vs NumPy | Speedup |
|---|---|---|---|---|
| block 0 `k_proj` | 262,144 B, checksum match | VERIFY PASS | **EXACT MATCH** | 3.54× |
| block 27 `v_proj` | 262,144 B, checksum match | VERIFY PASS | **EXACT MATCH** | 3.45× |

## Result 2 — Full single-tile sweep (`host/d5_sweep.py`)

**56/56 layers exact-match in 22.3 min** — every k_proj and v_proj of all
28 transformer blocks of `d4-student-sst2-r2`, each 262,144 packed bytes
streamed over UART, checksummed, computed, and matched bit-for-bit against
the training-side reference.

## Result 3 — Host-side tiling: every projection shape (`host/tile_verify.py`)

**Block 0, all 7 projections, EXACT via tiling, zero firmware changes
(5.9 min):**

| Projection | Shape | Tiles | Mode | Result |
|---|---|---|---|---|
| q_proj | 2048×1024 | 2 | column tiles | EXACT-MATCH |
| k_proj | 1024×1024 | 1 | single | EXACT-MATCH |
| v_proj | 1024×1024 | 1 | single | EXACT-MATCH |
| o_proj | 1024×2048 | 2 | **depth-chunk accumulation** | EXACT-MATCH |
| gate_proj | 3072×1024 | 3 | column tiles | EXACT-MATCH |
| up_proj | 3072×1024 | 3 | column tiles | EXACT-MATCH |
| down_proj | 1024×3072 | 3 | depth-chunk accumulation | EXACT-MATCH |

Both tiling modes proven ⇒ **all 196 projections of the model are now
computable on the board.** The "firmware out-tiling" task from the
desktop-inference plan closed as pure host orchestration — the board stays
a 1024×1024 tile engine; the host does the algebra.

## Pipeline proven end-to-end

Qwen3-0.6B → SubLN surgery → 100 M-token QAT warm-up → SST-2 KD
distillation → absmean snap → 2-bit pack → UART → multiplier-free ternary
GEMM on Artix-7 — bit-exact against the training-side reference, same day
as training.

## Bring-up notes

- 1024×1024 packed layer = 262,144 bytes = exactly the 256 KB weight BRAM.
- Blackout #3 truncated freshly written test vectors to 0 bytes (ext4
  delayed allocation) — the "0-byte LOADW, checksum 0, all-zero outputs"
  run is preserved in the logs as a cautionary tale; `os.sync()` after
  vector generation now.
- First PING timeout after power-cycle = xsdb two-pass programming race
  (same as Tier-1); manual PONG check settles it.
- Third variant of the pkill/pgrep self-match footgun found (a queued
  waiter matched its own command line). Standing rule: bracket-trick
  patterns (`d5_sweep` → `d5_swee[p]`) or separate commands, always.

**Next:** full forward pass via tiling — one real token, every MAC on
silicon (needs the FP-parts export + NumPy ops shell); then MIG/DDR3.

---

## Note on the "Accel vs SW" column (added 2 Aug)

The three-way check above — board accelerator vs board CPU vs host NumPy —
was valid when recorded on 1 Aug. Commit `c7778d5` (2 Aug 06:00) removed the
weight BRAM's third port, and with it AXI readback, to fix BRAM inference;
`read_weight_byte()` now returns `0xDEADBEEF`, so the firmware's `RUN`
self-verify computes on garbage and reports `VERIFY FAIL` regardless of
correctness. All verification from that commit onward is two-way — board
accelerator vs host reference — via `SLOAD`/`SRUN`, and `tier2_host.py`
compares the board's full-vector `SCHK` checksum, not just the first 8
outputs. Do not read `VERIFY FAIL` on a post-c7778d5 bitstream as a
correctness failure.
