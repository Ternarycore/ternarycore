#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

shopt -s nullglob
sby_files=(*.sby)
if ((${#sby_files[@]} == 0)); then
    echo "No SymbiYosys tasks found in $script_dir" >&2
    exit 1
fi

timeout_seconds="${SBY_TIMEOUT:-180}"
log_dir="${SBY_LOG_DIR:-/tmp/ternarycore-sby}"
mkdir -p "$log_dir"

for sby_file in "${sby_files[@]}"; do
    log_file="$log_dir/${sby_file%.sby}.log"
    echo "=== $sby_file ==="
    if ! timeout "$timeout_seconds" sby -f "$sby_file" >"$log_file" 2>&1; then
        echo "FAILED: $sby_file (full log: $log_file)" >&2
        tail -50 "$log_file" >&2 || true
        exit 1
    fi
    if ! grep -E "DONE \(PASS" "$log_file" | tail -1; then
        echo "FAILED: $sby_file did not report PASS (full log: $log_file)" >&2
        tail -50 "$log_file" >&2 || true
        exit 1
    fi
done

echo "All ${#sby_files[@]} SymbiYosys tasks passed."
