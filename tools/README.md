# tools/ — TernaryCore weight tooling

The **Quantum → FPGA bridge**: turn trained model weights into the ternary
`{-1, 0, +1}` codes the hardware runs natively. These two scripts are the
"compilation" step described in the project's quantum-weight notes — the
complexity lives here in Python, so the RTL stays elegant and multiplier-free.

## Weight encoding (shared by all repos)

| 2-bit code | ternary | MAC operation        |
|------------|---------|----------------------|
| `0b00`     | 0       | skip (acc unchanged) |
| `0b01`     | +1      | `acc += activation`  |
| `0b10`     | −1      | `acc -= activation`  |
| `0b11`     | —       | illegal (never emitted) |

Packing is **LSB-first, 2 bits per weight**. A GEMM row of columns
`(+1, −1, +1, 0)` packs to the byte `0x19`, matching `tb/tb_ternary_gemm.v`
`W_row[0]` and `rtl/weight_bram.v` (4 weights/byte).

## `quantum-mapping.py`

Ternarize weights three ways and benchmark them honestly:

```bash
python3 tools/quantum-mapping.py --demo
python3 tools/quantum-mapping.py --in W.npy --strategy qubo   --report
python3 tools/quantum-mapping.py --in W.npy --strategy quantum --report  # IBM Q if available
```

- `absmean` — standard BitNet b1.58 quantizer (default).
- `qubo` — per-weight QUBO with redundancy penalty (exact 4-state solve).
- `quantum` — the same QUBO on IBM Quantum via Qiskit/QAOA; **falls back to the
  exact solve when qiskit is not installed**, so the script always runs.
- `error-feedback` — experimental sigma-delta carry (see honesty note in the file).

`--report` prints per-element MSE *and* row-sum residual (baseline vs strategy)
— the reproducible "quantum advantage benchmark" for articles / the O-1 record.
Note: for an independent per-weight objective the QUBO optimum equals rounding;
its value is the publishable Quantum→FPGA bridge, not a free accuracy win.

## `weights-to-mem.py`

Pack ternary weights into the formats the toolchain consumes:

```bash
python3 tools/weights-to-mem.py --demo
python3 tools/weights-to-mem.py --in W.npy --out weights.mem --layout gemm
python3 tools/weights-to-mem.py --in W.npy --emit-c-header weights.h --name bitnet_w
python3 tools/weights-to-mem.py --in acts.csv --activations acts.csv --act-out act.mem
```

- `--out` → `$readmemh`-ready `.mem` (`gemm` / `bytes` / `flat` layouts).
- `--emit-c-header` → C byte array for firmware BRAM init (Arty7 `tier1_bench.c`).
- `--activations` → int8 two's-complement hex stream for testbenches.

Inputs may be floats (auto-ternarized via absmean) or already-ternary
`{-1,0,+1}`; formats `.npy/.npz/.csv/.txt`.

## Requirements

Pure-Python core (no numpy needed for `.csv/.txt` or `--demo`). `numpy` is only
imported for `.npy/.npz`. `qiskit` / `qiskit-optimization` are optional and only
used by `--strategy quantum`.
