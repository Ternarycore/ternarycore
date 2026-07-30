#!/usr/bin/env bash
# build_all.sh -- one-shot Arty A7-100T build for the TernaryCore BitNet dev kit.
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
#
# Requires Vivado 2024.x on PATH. Run from the repo root:
#     bash Arty7/build_all.sh
#
# Produces the MicroBlaze + AXI GEMM block design, then synthesises,
# implements (timing-gated at 100 MHz), and writes the bitstream + .xsa.
# Build the firmware next -- see DEVKIT.md.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"

if ! command -v vivado >/dev/null 2>&1; then
  echo "error: 'vivado' not found on PATH. Install Vivado 2024.x WebPACK." >&2
  exit 1
fi

echo "[1/3] Packaging custom IPs (axi_gemm_wrapper, weight_bram)..."
vivado -mode batch -source "$HERE/../ip/package_axi_gemm_wrapper.tcl"
vivado -mode batch -source "$HERE/../ip/package_weight_bram.tcl"

echo "[2/3] Creating block design (MicroBlaze + AXI GEMM + UART + GPIO)..."
vivado -mode batch -source "$HERE/create_bd.tcl"

echo "[3/3] Synthesis + implementation + bitstream (timing-gated @ 100 MHz)..."
vivado -mode batch -source "$HERE/generate_bitstream.tcl"

echo ""
echo "Done. Bitstream + .xsa are under Arty7/arty_mb_gemm/ ."
echo "Next: build firmware/tier1_bench.c in Vitis from the exported .xsa (see DEVKIT.md)."
