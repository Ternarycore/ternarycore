#!/bin/bash
# run_mutations.sh — Mutation testing for TernaryCore RTL.
# Runs from sim/ directory.
# Tests each mutation against the test suite and reports coverage holes.

set -uo pipefail
TIMEOUT="timeout 30"

DOT="../rtl/ternary_dot.v"
MAC="../rtl/ternary_mac.v"
ACT="../rtl/activation_quant.v"
SCALE="../rtl/ternary_scale.v"

PASS=0
FAIL=0
TOTAL=0

cleanup() {
    for f in "$DOT" "$MAC" "$ACT" "$SCALE"; do
        if [ -f "${f}.bak" ]; then cp "${f}.bak" "$f"; fi
    done
}
trap cleanup EXIT

# Backup originals
for f in "$DOT" "$MAC" "$ACT" "$SCALE"; do
    cp "$f" "${f}.bak"
done

run_tests() {
    local name="$1"
    local file="$2"
    local base="$file"           # ../rtl/ternary_dot.v

    # Icarus all
    if $TIMEOUT make all 2>/dev/null > /dev/null; then
        :
    else
        echo "  CAUGHT by iverilog-all"
        return 0
    fi

    # Verilator all
    if $TIMEOUT make verilator-all 2>/dev/null > /dev/null; then
        :
    else
        echo "  CAUGHT by verilator-all"
        return 0
    fi

    # Verilator dot fuzz
    if $TIMEOUT make verilator-dot-fuzz 2>/dev/null > /dev/null; then
        :
    else
        echo "  CAUGHT by verilator-dot-fuzz"
        return 0
    fi

    # Formal proof (if a _prove.sby exists for this module)
    local vname; vname=$(basename "$file" .v)
    local sby_file="../formal/${vname}_prove.sby"
    if [ -f "$sby_file" ]; then
        if $TIMEOUT sby -f "$sby_file" 2>/dev/null > /dev/null; then
            :
        else
            echo "  CAUGHT by formal-${vname}_prove"
            return 0
        fi
    fi

    echo "  SURVIVED -- COVERAGE HOLE"
    return 1
}

test_mutation() {
    local name="$1"
    local file="$2"
    shift 2
    TOTAL=$((TOTAL + 1))

    printf "\n--- %s ---\n" "$name"
    if [ $# -eq 0 ]; then
        python3 tests/mutate.py "$file" "$name" > "${file}.mutated"
    else
        python3 tests/mutate.py "$file" "$@" > "${file}.mutated"
    fi
    cp "${file}.mutated" "$file"

    if run_tests "$name" "$file"; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
    fi

    cp "${file}.bak" "$file"
}

echo "===================================================="
echo "  TernaryCore Mutation Testing"
echo "===================================================="

# --- ternary_dot.v mutations ---------------------------------
test_mutation "sticky-valid"         "$DOT"
test_mutation "negate-compare"       "$DOT"
test_mutation "drop-reset"           "$DOT"
test_mutation "swap-binop + -> -"    "$DOT" "swap-binop" "+" "-"
test_mutation "swap-binop >> -> <<"  "$DOT" "swap-binop" ">>" "<<"
test_mutation "swap-binop == -> !="  "$DOT" "swap-binop" "==" "!="
test_mutation "swap-binop > -> <"    "$DOT" "swap-binop" ">" "<"
test_mutation "invert-cond 1->0"     "$DOT" "invert-cond" "16'b1" "16'b0"

# --- activation_quant.v mutations ---------------------------
test_mutation "bias-off"             "$ACT"
test_mutation "qmax-half"            "$ACT"

# --- ternary_scale.v mutations -------------------------------
test_mutation "trunc-round"          "$SCALE"

# --- parameter override mutations ----------------------------
test_mutation "change-param VECTOR_LEN" "$DOT" "change-param" "VECTOR_LEN" "128"
test_mutation "change-param DATA_WIDTH" "$DOT" "change-param" "DATA_WIDTH" "16"

echo ""
echo "===================================================="
echo "  Results: $PASS/$TOTAL mutations detected"
echo "===================================================="
