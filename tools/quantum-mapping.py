#!/usr/bin/env python3
"""
quantum-mapping.py -- Ternary weight optimizer for TernaryCore (BitNet b1.58).

Maps real-valued model weights to the ternary set {-1, 0, +1} and the 2-bit
hardware encoding used across every TernaryCore RTL module:

    code 0b00 -> 0   (skip:  acc unchanged)
    code 0b01 -> +1  (add:   acc += activation)
    code 0b10 -> -1  (sub:   acc -= activation)
    code 0b11 -> illegal (never emitted)

Three strategies are provided:

  1. absmean      Classical BitNet "absmean" ternarization (default).
                  scale alpha = mean(|W|);  q = clip(round(W/alpha), -1, +1).
                  Standard, fast, defensible BitNet b1.58 quantizer.

  2. qubo         Per-weight QUBO with redundancy penalty. Two binary vars
                  q_a (+1) and q_b (-1) minimise
                      (w - (q_a - q_b))**2 + lambda * (q_a * q_b)
                  The lambda term steers the solver to the canonical 0b00 over
                  the illegal 0b11 for a zero. For one weight the QUBO has four
                  states and is solved exactly by enumeration.

  3. quantum      The identical QUBO, solved on IBM Quantum via Qiskit/QAOA when
                  qiskit-optimization is installed. Falls back to the exact
                  enumeration (strategy 2) if Qiskit is unavailable, so this
                  script always runs.

HONESTY NOTE
------------
For an *independent* per-weight objective the QUBO optimum equals threshold
rounding -- so QUBO/quantum and absmean produce the same per-weight MSE. The
QUBO's value is (a) the publishable Quantum->FPGA bridge artifact and (b) a
substrate for *global* row/matrix objectives (e.g. preserving dot products under
a known activation distribution), not a free per-weight accuracy win. The
`error-feedback` strategy is an experimental sigma-delta carry that trades
per-element error for accumulated-error control: it helps on some weight
distributions and hurts on others. Do not assume a win -- run `--report` on your
own data. The report prints per-element MSE and the row-sum residual (the error
that actually matters once a row is summed inside a GEMM dot product).

USAGE
-----
    python3 quantum-mapping.py --demo
    python3 quantum-mapping.py --in weights.npy --out weights.mem --report
    python3 quantum-mapping.py --in W.csv --strategy quantum --report

The 2-bit codes can be written straight to a $readmemh-compatible .mem via
--out (delegates to the same packing used by weights-to-mem.py: 2 bits/weight,
LSB-first, COLS weights per line).
"""

from __future__ import annotations
import argparse
import math
import sys

# Ternary value -> 2-bit hardware code
CODE = {0: 0b00, 1: 0b01, -1: 0b10}


# --------------------------------------------------------------------------- #
# Core quantizers (pure Python; no numpy required so this always runs)
# --------------------------------------------------------------------------- #
def absmean_scale(values):
    """BitNet absmean scale alpha = mean(|w|), guarded against all-zero rows."""
    mags = [abs(v) for v in values]
    a = sum(mags) / len(mags) if mags else 0.0
    return a if a > 1e-12 else 1.0


def ternarize_absmean(values):
    """Standard BitNet b1.58 ternarization. Returns (q_list, alpha)."""
    alpha = absmean_scale(values)
    q = [max(-1, min(1, round(v / alpha))) for v in values]
    return q, alpha


def qubo_weight(w, lam=3.0):
    """Exact per-weight QUBO solve. Returns ternary value in {-1, 0, +1}."""
    # f(q_a, q_b) = (w - (q_a - q_b))**2 + lam * (q_a * q_b)
    states = {
        (0, 0): (w - 0) ** 2,            # -> 0
        (1, 0): (w - 1) ** 2,            # -> +1
        (0, 1): (w + 1) ** 2,            # -> -1
        (1, 1): (w - 0) ** 2 + lam,      # -> 0 (penalised)
    }
    qa, qb = min(states, key=states.get)
    return qa - qb  # -1, 0, or +1


def qubo_weight_quantum(w, lam=3.0):
    """Solve the same QUBO on IBM Quantum via Qiskit/QAOA, else exact fallback."""
    try:
        from qiskit_optimization import QuadraticProgram
        from qiskit_optimization.algorithms import MinimumEigenOptimizer
        from qiskit_algorithms import QAOA
        from qiskit_algorithms.optimizers import COBYLA
        from qiskit.primitives import Sampler
    except Exception:
        return qubo_weight(w, lam)  # graceful fallback -- identical optimum

    qp = QuadraticProgram("TernaryQuantization")
    qp.binary_var("qa")
    qp.binary_var("qb")
    qp.minimize(
        constant=w * w,
        linear={"qa": 1 - 2 * w, "qb": 1 + 2 * w},
        quadratic={("qa", "qb"): lam - 2.0},
    )
    solver = MinimumEigenOptimizer(QAOA(sampler=Sampler(), optimizer=COBYLA(), reps=1))
    x = solver.solve(qp).x
    return int(round(x[0])) - int(round(x[1]))


def ternarize_qubo(values, lam=3.0, quantum=False):
    """Ternarize a list via the QUBO, scaling inputs by absmean first."""
    alpha = absmean_scale(values)
    solve = qubo_weight_quantum if quantum else qubo_weight
    q = [solve(v / alpha, lam) for v in values]
    return q, alpha


def ternarize_error_feedback(values):
    """Row-wise sigma-delta ternarization: carries residual along the row."""
    alpha = absmean_scale(values)
    q, err = [], 0.0
    for v in values:
        x = v / alpha + err
        t = max(-1, min(1, round(x)))
        err = x - t
        q.append(t)
    return q, alpha


# --------------------------------------------------------------------------- #
# Metrics
# --------------------------------------------------------------------------- #
def reconstruction_mse(values, q, alpha):
    return sum((v - alpha * t) ** 2 for v, t in zip(values, q)) / len(values)


def rowsum_residual(values, q, alpha):
    """|sum(w) - alpha*sum(q)| -- the error that survives a GEMM dot product."""
    return abs(sum(values) - alpha * sum(q))


# --------------------------------------------------------------------------- #
# IO helpers
# --------------------------------------------------------------------------- #
def load_matrix(path):
    """Load a 2-D float matrix from .npy/.npz/.csv/.txt. Returns list[list]."""
    if path.endswith((".npy", ".npz")):
        import numpy as np  # required only for binary numpy formats
        arr = np.load(path)
        if hasattr(arr, "files"):
            arr = arr[arr.files[0]]
        arr = arr.reshape(arr.shape[0], -1) if arr.ndim > 1 else arr.reshape(1, -1)
        return arr.astype(float).tolist()
    rows = []
    with open(path) as fh:
        for line in fh:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            sep = "," if "," in line else None
            rows.append([float(x) for x in line.split(sep)])
    return rows


def pack_mem(coded_rows, cols):
    """Pack 2-bit codes LSB-first, `cols` weights per line -> hex strings."""
    flat = [c for row in coded_rows for c in row]
    lines, nhex = [], max(1, math.ceil(cols * 2 / 4))
    for i in range(0, len(flat), cols):
        group, val = flat[i:i + cols], 0
        for j, c in enumerate(group):
            val |= (c & 0b11) << (2 * j)
        lines.append(format(val, "0{}x".format(nhex)))
    return lines


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #
def run(matrix, strategy, lam, cols, report, out):
    coded_rows = []
    mse_naive = mse_opt = rs_naive = rs_opt = 0.0
    for row in matrix:
        q_naive, alpha = ternarize_absmean(row)
        if strategy == "absmean":
            q = q_naive
        elif strategy == "error-feedback":
            q, alpha = ternarize_error_feedback(row)
        else:  # qubo / quantum
            q, alpha = ternarize_qubo(row, lam, quantum=(strategy == "quantum"))
        coded_rows.append([CODE[t] for t in q])
        mse_naive += reconstruction_mse(row, q_naive, alpha)
        mse_opt += reconstruction_mse(row, q, alpha)
        rs_naive += rowsum_residual(row, q_naive, alpha)
        rs_opt += rowsum_residual(row, q, alpha)

    n = len(matrix)
    if report:
        print("strategy           : {}".format(strategy))
        print("matrix             : {} rows x {} cols".format(n, len(matrix[0])))
        print("MSE  absmean-round : {:.6f}".format(mse_naive / n))
        print("MSE  {:<13}: {:.6f}".format(strategy, mse_opt / n))
        print("rowsum|resid| base : {:.6f}".format(rs_naive / n))
        print("rowsum|resid| now  : {:.6f}".format(rs_opt / n))

    if out:
        lines = pack_mem(coded_rows, cols)
        with open(out, "w") as fh:
            fh.write("// TernaryCore weights  strategy={} cols={}\n".format(strategy, cols))
            fh.write("\n".join(lines) + "\n")
        print("wrote {} ({} lines, {} weights/line) -> $readmemh ready".format(
            out, len(lines), cols))
    return coded_rows


def demo():
    print("=== quantum-mapping.py demo ===")
    w = 0.72
    print("single weight w={}:  qubo -> {:+d}  (expect +1, code 0b01)".format(
        w, qubo_weight(w)))
    matrix = [
        [0.72, -0.13, 0.55, -0.90, 0.02, 0.41, -0.38, 0.88],
        [-0.61, 0.09, -0.77, 0.33, -0.05, 0.70, 0.12, -0.49],
    ]
    print()
    for strat in ("absmean", "qubo", "error-feedback"):
        run(matrix, strat, 3.0, 4, True, None)
        print()
    print("sample .mem (qubo, cols=4):")
    for ln in pack_mem([[CODE[t] for t in ternarize_qubo(r)[0]] for r in matrix], 4):
        print("  " + ln)


def main(argv=None):
    p = argparse.ArgumentParser(description="TernaryCore quantum/classical weight mapper")
    p.add_argument("--in", dest="inp", help="weights file (.npy/.npz/.csv/.txt)")
    p.add_argument("--out", help="output .mem ($readmemh)")
    p.add_argument("--strategy", default="absmean",
                   choices=["absmean", "qubo", "quantum", "error-feedback"])
    p.add_argument("--lambda", dest="lam", type=float, default=3.0,
                   help="QUBO redundancy penalty (default 3.0)")
    p.add_argument("--cols", type=int, default=4, help="weights per .mem line (default 4)")
    p.add_argument("--report", action="store_true", help="print MSE benchmark")
    p.add_argument("--demo", action="store_true", help="run a self-contained demo")
    args = p.parse_args(argv)

    if args.demo or not args.inp:
        if not args.demo:
            p.print_help()
            print("\n(no --in given; running --demo)\n")
        demo()
        return 0
    matrix = load_matrix(args.inp)
    run(matrix, args.strategy, args.lam, args.cols, args.report or not args.out, args.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
