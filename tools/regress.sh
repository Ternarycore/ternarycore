#!/bin/bash
# regress.sh -- everything that has to still be true, in one command.
#
#   bash tools/regress.sh
#
# This exists because a corrupt weight page survived here for months.
# Not for want of tests: block_check, block_multi, stage11 and token_loop
# all passed the whole time. They passed because the value that was wrong
# was one nothing read, and nobody ran the full set often enough to
# notice the set had a hole in it.
#
# It turned out the suite was the thing corrupting it. block_check's page
# loader defaulted to DDR offset 0 -- block 0's q_proj -- so every run
# overwrote a resident page with host-packed bytes in a different layout
# and left it that way. Fixed at the source: tests load at SCRATCH now,
# and stage2_check.scratch_only refuses anything below the image.
#
# So the order is deliberate: the resident image first, because every
# other result is downstream of it and a wrong image makes all of them
# lies. Then the operators, then a block, then a token. And the image
# again at the end, because "the suite left the machine as it found it"
# is a property worth testing, and this suite once did not have it.
#
# SPDX-License-Identifier: CERN-OHL-S-2.0
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PY="${PY_BIN:-$HOME/tc-train/bin/python}"
cd "$ROOT"

fail=0
run() {
    printf '\n=== %s\n' "$1"; shift
    if "$@"; then printf '    ok\n'; else printf '    FAILED\n'; fail=1; fi
}

run "the resident image against the file"  \
    "$PY" tools/ddr_audit.py --meta
run "the fabric normalizer against the soft CPU" \
    "$PY" tools/stage11_check.py
run "attention at four positions, three blocks" \
    "$PY" tools/blk_check.py --blocks 0,13,27 --fab --positions 4
run "the attention operators at four positions" \
    "$PY" tools/block_multi.py
run "a generated sequence against the golden model" \
    "$PY" tools/ternary.py "The movie was" -n 4 --compare
run "the resident image again, after all of the above" \
    "$PY" tools/ddr_audit.py

printf '\n'
if [ $fail -eq 0 ]; then
    printf 'ALL PASS\n'
else
    printf 'SOMETHING FAILED -- and the image check is first for a reason:\n'
    printf 'if it failed, reload with tools/eth_load.py before believing\n'
    printf 'anything below it. If the first image check passed and the\n'
    printf 'last one did not, a tool in between wrote where it should not.\n'
fi
exit $fail
