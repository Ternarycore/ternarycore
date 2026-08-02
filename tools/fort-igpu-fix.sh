#!/bin/bash
# fort-igpu-fix.sh — make the onboard Radeon (Raphael, 0000:79:00.0) bind
# reliably, and record evidence either way.
#
#   sudo bash fort-igpu-fix.sh          # apply the fix + install the logger
#   sudo bash fort-igpu-fix.sh --log    # logger only, no change (baseline)
#   bash fort-igpu-fix.sh --report      # show the tally across boots
#
# Diagnosis: amdgpu fails at probe with -22 on roughly half of boots, dying
# before `pci_enable_device` — i.e. while evicting whoever owns the firmware
# framebuffer. The iGPU is the boot VGA device on this board, so simpledrm
# claims it first, and nvidia registers into the same vga_switcheroo registry.
# Loading amdgpu from the initramfs lets it claim the device in early boot,
# before either competitor exists.
#
# SPDX-License-Identifier: CERN-OHL-S-2.0
set -euo pipefail

MODE=apply
case "${1:-}" in
    --log)    MODE=log ;;
    --report) MODE=report ;;
    "")       ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
esac

TALLY=/var/log/tc-igpu-boots.log

if [ "$MODE" = report ]; then
    [ -f "$TALLY" ] || { echo "no data yet at $TALLY"; exit 0; }
    ok=$(grep -c ' OK$'   "$TALLY" || true)
    bad=$(grep -c ' FAIL$' "$TALLY" || true)
    echo "amdgpu bind results across $((ok + bad)) boots:  $ok OK / $bad FAIL"
    echo
    tail -20 "$TALLY"
    exit 0
fi

[ "$(id -u)" = 0 ] || { echo "run with sudo" >&2; exit 1; }

# ------------------------------------------------------------- the evidence
# Runs late enough that the probe has resolved, and appends one line per boot
# so we can count rather than guess.
cat > /usr/local/sbin/tc-igpu-check <<'SCRIPT'
#!/bin/bash
TALLY=/var/log/tc-igpu-boots.log
stamp=$(date '+%Y-%m-%d %H:%M:%S')
kern=$(uname -r)
if [ -e /sys/bus/pci/drivers/amdgpu/0000:79:00.0 ]; then
    echo "$stamp kernel $kern amdgpu OK" >> "$TALLY"
else
    why=$(journalctl -k -b --no-pager 2>/dev/null \
          | grep -m1 -i 'amdgpu.*failed with error' | sed 's/.*amdgpu/amdgpu/')
    echo "$stamp kernel $kern ${why:-amdgpu absent} FAIL" >> "$TALLY"
fi
SCRIPT
chmod 755 /usr/local/sbin/tc-igpu-check

cat > /etc/systemd/system/tc-igpu-check.service <<'UNIT'
[Unit]
Description=Record whether amdgpu bound this boot
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/tc-igpu-check

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable tc-igpu-check.service >/dev/null
/usr/local/sbin/tc-igpu-check
echo "==> logger installed; this boot recorded in $TALLY"

if [ "$MODE" = log ]; then
    echo "==> baseline mode: no change made. Reboot a few times, then --report."
    exit 0
fi

# ------------------------------------------------------------------ the fix
MODS=/etc/initramfs-tools/modules
if grep -qx amdgpu "$MODS" 2>/dev/null; then
    echo "==> amdgpu already in $MODS"
else
    printf '\n# Claim the iGPU in early boot, before simpledrm or nvidia exist.\namdgpu\n' >> "$MODS"
    echo "==> added amdgpu to $MODS"
fi

update-initramfs -u
echo "==> initramfs rebuilt"

cat <<'NOTE'

Reboot when convenient. Then:

    bash fort-igpu-fix.sh --report

Judge it over several boots, not one — the failure was intermittent at about
three in six, so a single good boot proves nothing. Five clean boots is
reasonable evidence; one failure in five means the race is narrowed, not
closed, and the next lever is BIOS: set Primary Display to PCIe/dGPU so the
firmware framebuffer lands on the NVIDIA card and leaves the iGPU alone.

If it gets worse rather than better, undo with:
    sudo sed -i '/^amdgpu$/d' /etc/initramfs-tools/modules && sudo update-initramfs -u
NOTE
