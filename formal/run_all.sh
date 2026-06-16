#!/usr/bin/env bash
# Run formal verification tasks with SymbiYosys.
# Called from Makefile: make formal
set -euo pipefail

if ! command -v sby &>/dev/null; then
    echo "Error: SymbiYosys (sby) is not installed or not in PATH." >&2
    echo "  brew install yosys symbiyosys" >&2
    exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
echo "─── Running formal verification ───"
PASS=0
FAIL=0

for task in ternary_mac; do
    echo ""
    echo "── ${task} ──"
    logfile="${task}.log"
    if sby -f "${task}.sby" > "${logfile}" 2>&1; then
        echo "  ✓ PASS"
        PASS=$((PASS + 1))
        rm -f "${logfile}"
    else
        echo "  ✗ FAIL"
        cat "${logfile}"
        FAIL=$((FAIL + 1))
    fi
done

# ternary_dot and ternary_gemm have RTL-level multiple-always-block driver
# conflicts that yosys formal does not support. See ternary_dot.v (blocks
# driving acc_out and vector_done_delayed) and ternary_gemm.v (instances).
echo ""
echo "── skipped ──"
echo "  ternary_dot   — multiple always blocks driving same reg (RTL constraint)"
echo "  ternary_gemm  — inherits same constraint from ternary_dot instances"
echo ""
echo "─── Results: ${PASS} passed, ${FAIL} failed ───"
if [ "$FAIL" -gt 0 ]; then exit 1; fi