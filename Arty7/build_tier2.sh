#!/usr/bin/env bash
# build_tier2.sh -- Tier-2 streaming-GEMM bitstream for the Arty A7-100T.
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Derives create_bd_tier2.tcl from create_bd.tcl (weight_bram -> weight_bram128,
# +axi_gemm_stream on M04 at 0x44200000), then builds. Archives any previous
# bitstream first. Run from repo root with vivado on PATH:
#     bash Arty7/build_tier2.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/bitstreams"
OLD="$HERE/../arty_mb_gemm/arty_mb_gemm.runs/impl_1/arty_mb_gemm_wrapper.bit"
[ -f "$OLD" ] && cp "$OLD" "$HOME/bitstreams/pre-tier2-$(date +%s).bit"

command -v vivado >/dev/null || { echo 'vivado not on PATH' >&2; exit 1; }

vivado -mode batch -source "$HERE/../ip/package_weight_bram128.tcl"
vivado -mode batch -source "$HERE/../ip/package_axi_gemm_stream.tcl"

sed \
  -e 's|user:weight_bram:1.0 weight_bram_0|user:weight_bram128:1.0 weight_bram_0|' \
  -e 's|ip weight_bram\] \\|ip weight_bram] \\\n    [file join $repo_root ip weight_bram128] \\\n    [file join $repo_root ip axi_gemm_stream] \\|' \
  -e 's|rtl weight_bram.v|rtl weight_bram128.v|' \
  -e 's|CONFIG.NUM_MI {4}|CONFIG.NUM_MI {5}|' \
  -e 's|M03_ACLK\]|M03_ACLK] \\\n    [get_bd_pins microblaze_0_axi_periph/M04_ACLK]|' \
  -e 's|M03_ARESETN\]|M03_ARESETN] \\\n    [get_bd_pins microblaze_0_axi_periph/M04_ARESETN]|' \
  "$HERE/create_bd.tcl" > "$HERE/create_bd_tier2.tcl"

# weight_bram128 has no DATA_WIDTH parameter -- drop it from the bram config
perl -0pi -e 's/CONFIG\.ADDR_WIDTH \{18\} \\\n    CONFIG\.DATA_WIDTH \{8\} \\/CONFIG.ADDR_WIDTH {18} \\/' "$HERE/create_bd_tier2.tcl"

# insert the tier2 block after the weight-bram address range line
sed -i '/range  256K/r '"$HERE/tier2_block.tcl" "$HERE/create_bd_tier2.tcl"

grep -q axi_gemm_stream_0 "$HERE/create_bd_tier2.tcl" || { echo 'patch failed' >&2; exit 1; }

vivado -mode batch -source "$HERE/create_bd_tier2.tcl"
vivado -mode batch -source "$HERE/generate_bitstream.tcl"
echo 'Tier-2 build complete.'
