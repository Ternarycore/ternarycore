# tools/ — TernaryCore weight tooling

The **Quantum → FPGA bridge**: turn trained model weights into the ternary
`{-1, 0, +1}` codes the hardware runs natively. These scripts are the
"compilation" step — complexity lives here in Python, so the RTL stays elegant
and multiplier-free.

## Weight encoding (shared by all repos)

| 2-bit code | ternary | MAC operation        |
|------------|---------|----------------------|
| `0b00`     | 0       | skip (acc unchanged) |
| `0b01`     | +1      | `acc += activation`  |
| `0b10`     | −1      | `acc -= activation`  |
| `0b11`     | —       | illegal (never emitted) |

Packing is **LSB-first, 2 bits per weight**. A GEMM row of columns
`(+1, −1, +1, 0)` packs to the byte `0x19`, matching `tb/tb_ternary_gemm.v`
`W_row[0]`; `--layout bytes` (4 weights/byte) matches `rtl/weight_bram.v` and
`firmware/tier1_bench.c` `init_weights()`.

## `quantum-mapping.py`

```bash
python3 tools/quantum-mapping.py --demo
python3 tools/quantum-mapping.py --in W.npy --strategy qubo    --report
python3 tools/quantum-mapping.py --in W.npy --strategy quantum --report  # IBM Q if installed
```

Strategies: `absmean` (standard BitNet, default), `qubo` (exact per-weight QUBO),
`quantum` (same QUBO on Qiskit/QAOA, **graceful fallback to exact when qiskit is
absent**), `error-feedback` (experimental sigma-delta). `--report` prints
per-element MSE *and* row-sum residual (baseline vs strategy) — the reproducible
benchmark for articles / the O-1 record. Note: for an independent per-weight
objective the QUBO optimum equals rounding; its value is the Quantum→FPGA bridge,
not a free accuracy win.

## `weights-to-mem.py`

```bash
python3 tools/weights-to-mem.py --demo
python3 tools/weights-to-mem.py --in W.npy --out weights.mem --layout gemm
python3 tools/weights-to-mem.py --in W.npy --layout bytes \
        --emit-c-header firmware/bitnet_weights.h --name bitnet_weights
```

- `--out` → `$readmemh`-ready `.mem` (`gemm` / `bytes` / `flat` layouts).
- `--emit-c-header` → C byte array for firmware BRAM init (see `DEVKIT.md` §5).
- `--activations` → int8 two's-complement hex stream for testbenches.

Inputs may be floats (auto-ternarized via absmean) or already-ternary
`{-1,0,+1}`; formats `.npy/.npz/.csv/.txt`.

## Requirements

Pure-Python core (no numpy needed for `.csv/.txt` or `--demo`). `numpy` only for
`.npy/.npz`. `qiskit` / `qiskit-optimization` optional, only for `--strategy quantum`.
