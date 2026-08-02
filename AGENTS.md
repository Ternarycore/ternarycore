# AGENTS.md — working on TernaryCore (humans and AI agents)

Ground rules for anyone — person or agent — touching this repository.

## The one law

**Silicon sees nothing simulation hasn't blessed.** Every RTL change runs the
iverilog suite before Vivado ever opens. Three silicon-only bug classes are
documented in DEBUGGING.md and docs/article-03; do not add a fourth by
skipping the testbenches.

## Verification commands (run from `sim/`)

- `make all` — full testbench suite (MAC, dot, GEMM, wrapper, BRAM)
- `make verify` — Python/NumPy golden-model cross-check (needs `numpy`)
- `make tb_ternary_mac` — MAC unit tests
- `make tb_ternary_dot` — dot-product streaming tests
- `make tb_ternary_gemm` — COLS-parallel GEMM tests
- `make tb_axi_gemm_wrapper` — AXI wrapper + gap-injection regression
- `make tb_weight_bram` — weight store tests
- `make clean` — remove sim build artifacts

## Repository map

- `rtl/` — synthesizable Verilog (CERN-OHL-S v2). No vendor primitives.
- `tb/` — testbenches; every module has one; integration TBs for AXI paths.
- `sim/` — Makefile drives iverilog + Python verification.
- `Arty7/` — Vivado build scripts (block design, bitstream) for Arty A7-100T.
- `ip/` — Vivado IP packaging scripts + packaged cores.
- `firmware/` — bare-metal MicroBlaze C (no BSP; see DEVKIT.md for mb-gcc flags).
- `host/` — PC-side drivers/benchmarks (stdlib-only Python, termios serial).
- `training/` — distillation track: BitLinear QAT, task distillation, run log.
- `tools/` — checkpoint export/packing, reading-list fetcher, ops scripts.
- `docs/` — plans, guides, articles.

## Conventions

- Weight encoding is 2-bit: `00`=0, `01`=+1, `10`=−1; 4 weights/byte,
  LSB-first; packed layout `addr = k*GROUPS + g`. Do not invent alternatives.
- Long-running jobs on lab machines use `nohup` + crash-safe checkpoints and
  must survive a power cut (see training/RUNLOG.md postmortems).
- Never combine `pkill`/`pgrep` patterns with commands whose own text matches
  the pattern (three documented self-kill incidents).
- Measured numbers go in `training/RUNLOG.md` / `docs/` with raw-log paths;
  a number without a log is a rumor.
- Docs-only changes may go straight to `main`; RTL/firmware/training changes
  go through a PR with CI green.

## CI expectations

CI (`.github/workflows/ci.yml`) runs the sim suite, Verilator lint, and doc
checks on every PR. If `make all` and `make verify` pass locally, CI should
agree; if CI disagrees with your local run, believe CI and reproduce with a
clean checkout.
