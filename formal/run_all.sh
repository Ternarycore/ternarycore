#!/usr/bin/env bash
set -euo pipefail

if ! command -v sby &>/dev/null; then
    echo "Error: SymbiYosys (sby) is not installed or not in PATH." >&2; exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"; cd "$DIR"
echo "─── Running formal verification ───"
PASS=0; FAIL=0

for d in ternary_mac ternary_dot ternary_gemm activation_quant ternary_scale; do
    [ -d "$d" ] && rm -rf "$d"
done

for task in ternary_mac ternary_dot ternary_gemm activation_quant ternary_scale; do
    echo ""; echo "── ${task} (cover/BMC) ──"
    logfile="${task}.log"
    if sby -f "${task}.sby" > "${logfile}" 2>&1; then
        echo "  ✓ PASS"; PASS=$((PASS + 1)); rm -f "${logfile}"
    else echo "  ✗ FAIL"; cat "${logfile}"; FAIL=$((FAIL + 1)); fi
done

for task in ternary_mac activation_quant ternary_scale; do
    echo ""; echo "── ${task} (prove) ──"
    logfile="${task}_prove.log"
    if sby -f "${task}_prove.sby" > "${logfile}" 2>&1; then
        echo "  ✓ PASS"; PASS=$((PASS + 1)); rm -f "${logfile}"
    else echo "  ✗ FAIL"; cat "${logfile}"; FAIL=$((FAIL + 1)); fi
done

echo ""; echo "─── Results: ${PASS} passed, ${FAIL} failed ───"
[ "$FAIL" -gt 0 ] && exit 1