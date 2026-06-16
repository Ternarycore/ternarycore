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

# Clean output dirs (not source files)
for d in ternary_mac ternary_dot ternary_gemm; do
    [ -d "$d" ] && rm -rf "$d"
done

# BMC / cover mode tasks
for task in ternary_mac ternary_dot ternary_gemm; do
    echo ""
    echo "── ${task} (cover/BMC) ──"
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

# Prove mode (k-induction) — stronger guarantees
echo ""
echo "── ternary_mac (prove) ──"
logfile="ternary_mac_prove.log"
if sby -f "ternary_mac_prove.sby" > "${logfile}" 2>&1; then
    echo "  ✓ PASS"
    PASS=$((PASS + 1))
    rm -f "${logfile}"
else
    echo "  ✗ FAIL"
    cat "${logfile}"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "─── Results: ${PASS} passed, ${FAIL} failed ───"
if [ "$FAIL" -gt 0 ]; then exit 1; fi