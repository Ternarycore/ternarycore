#!/usr/bin/env bash
# Opens a VCD waveform file using the best available viewer.
# Priority: surfer → WaveTrace (macOS) → gtkwave
set -euo pipefail

VCD_FILE="${1:?Usage: $0 <file.vcd>}"

if [ ! -f "$VCD_FILE" ]; then
    echo "Error: VCD file not found: $VCD_FILE"
    echo "Run the simulation first: make tb_$(basename "$VCD_FILE" .vcd | sed 's/tb_//')"
    exit 1
fi

# 1. surfer — modern Rust-based TUI/GUI viewer
if command -v surfer &>/dev/null; then
    echo "Opening $VCD_FILE with surfer..."
    exec surfer "$VCD_FILE"
fi

# 2. WaveTrace — macOS native app
if [ "$(uname)" = "Darwin" ] && [ -d "/Applications/WaveTrace.app" ]; then
    echo "Opening $VCD_FILE with WaveTrace..."
    exec open -a WaveTrace "$VCD_FILE"
fi

# 3. GTKWave — legacy fallback
if command -v gtkwave &>/dev/null; then
    echo "Opening $VCD_FILE with GTKWave..."
    exec gtkwave "$VCD_FILE"
fi

# 4. No viewer found — print instructions
echo "No waveform viewer found. Install one:"
echo ""
echo "  # surfer (recommended):"
echo "  cargo install surfer"
echo "  surfer $VCD_FILE"
echo ""
echo "  # WaveTrace (macOS):"
echo "  brew install --cask wavetrace"
echo "  open -a WaveTrace $VCD_FILE"
echo ""
echo "  # GTKWave (legacy):"
echo "  brew install gtkwave"
echo "  gtkwave $VCD_FILE"
echo ""
echo "Or open the VCD file directly: $VCD_FILE"
exit 1