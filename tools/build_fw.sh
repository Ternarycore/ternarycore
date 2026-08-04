#!/bin/bash
# build_fw.sh -- generate ddr_host.c from tier2_host.c and compile it.
#
#   bash tools/build_fw.sh
#   MB_BIN=/path/to/mb/bin bash tools/build_fw.sh
#
# The flags are not arbitrary and not guessable: -mcpu=v11.0 with hardware
# multiply and divide matches CONFIG.C_USE_HW_MUL/C_USE_DIV in
# create_bd_ddr.tcl, and -L. finds firmware/libxil.a. Change the MicroBlaze
# configuration in the block design and this line has to change with it.
#
# The LMB is 64 KB and holds both code and static data, so the size is
# printed every build. When text+data approaches 65536 the next thing to
# add has to go to DDR instead.
#
# SPDX-License-Identifier: CERN-OHL-S-2.0
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MB="${MB_BIN:-$HOME/Applications/2025.2/gnu/microblaze/lin/bin}"
PY="${PY_BIN:-$HOME/tc-train/bin/python3}"

[ -x "$MB/mb-gcc" ] || { echo "no mb-gcc under $MB -- set MB_BIN" >&2; exit 1; }

"$PY" "$ROOT/tools/make_ddr_fw.py"

cd "$ROOT/firmware"
"$MB/mb-gcc" -O2 -Wall -ffunction-sections -fdata-sections \
    -mlittle-endian -mcpu=v11.0 -mxl-barrel-shift -mxl-pattern-compare \
    -mno-xl-soft-mul -mno-xl-soft-div \
    -Wl,--gc-sections -Wl,--defsym=_STACK_SIZE=0x1000 -L. \
    -o ddr_host.elf ddr_host.c stubs.c 2>&1 \
  | grep -Ev 'multi-line comment|^ *[0-9]+ \||^ *\^|^ *\|' || true

"$MB/mb-size" ddr_host.elf
echo "==> firmware/ddr_host.elf"
