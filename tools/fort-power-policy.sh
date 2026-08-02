#!/bin/bash
# fort-power-policy.sh — blackout policy for fort-silicon.
#
#   sudo bash fort-power-policy.sh              # poweroff on mains loss (recommended)
#   sudo bash fort-power-policy.sh --suspend    # suspend instead
#   sudo bash fort-power-policy.sh --grace 45   # minutes to let the battery charge
#
# Installs three things:
#   1. tc-clear-nologin.service — deletes /etc/nologin at every boot, before
#      getty and ssh. You can never again be locked out of the console by an
#      aborted shutdown.
#   2. /etc/apcupsd/onbattery — acts within seconds of mains loss: sync, then
#      poweroff (or suspend), ignoring inhibitors so nothing can stall it.
#   3. tc-grace.service/.timer — a marker that says "battery still charging",
#      so heavy work doesn't restart the moment the machine boots.
#
# SPDX-License-Identifier: CERN-OHL-S-2.0
set -euo pipefail

ACTION=poweroff
GRACE=30
CONFIRM=10           # seconds on battery before acting; rides out short blips

while [ $# -gt 0 ]; do
    case "$1" in
        --suspend)  ACTION=suspend; shift ;;
        --poweroff) ACTION=poweroff; shift ;;
        --grace)    GRACE="$2"; shift 2 ;;
        --confirm)  CONFIRM="$2"; shift 2 ;;
        *) echo "unknown option: $1" >&2; exit 1 ;;
    esac
done

[ "$(id -u)" = 0 ] || { echo "run with sudo" >&2; exit 1; }

echo "==> action on mains loss : $ACTION (after ${CONFIRM}s confirmation)"
echo "==> charge grace period  : ${GRACE} min"

# ---------------------------------------------------------------- 1. nologin
# systemd-user-sessions writes /etc/nologin when a shutdown starts and removes
# it on the next boot. A shutdown that starts and then aborts leaves the file
# with nothing left running to clean it up, and every console login is refused
# before it is even asked for a password. Remove it unconditionally at boot.
cat > /etc/systemd/system/tc-clear-nologin.service <<'UNIT'
[Unit]
Description=Clear stale /etc/nologin left by an aborted shutdown
DefaultDependencies=no
After=local-fs.target
Before=systemd-user-sessions.service getty.target ssh.service

[Service]
Type=oneshot
ExecStart=/bin/rm -f /etc/nologin /run/nologin
RemainAfterExit=yes

[Install]
WantedBy=sysinit.target
UNIT
systemctl daemon-reload
systemctl enable --now tc-clear-nologin.service >/dev/null
echo "==> tc-clear-nologin.service installed and run"

# ------------------------------------------------------------- 2. power loss
cat > /usr/local/sbin/tc-onbattery <<SCRIPT
#!/bin/bash
# Called by apcupsd the moment the UPS reports mains loss.
# Note: the USB-attached UPS powers the mini, not fort. Its battery figures do
# not describe this machine — only its mains-state signal is meaningful here,
# and both units share the same wall, so it is a valid early warning.
set -u
log() { logger -t tc-power "\$*"; echo "tc-power: \$*"; }

log "mains loss signalled; confirming for ${CONFIRM}s"
sleep ${CONFIRM}
if apcaccess status 2>/dev/null | grep -q "STATUS.*ONLINE"; then
    log "mains back within ${CONFIRM}s — no action"
    exit 0
fi

# Stop GPU work first so the driver is idle and checkpoints are on disk.
pkill -f "warmup_trai[n]"  2>/dev/null || true
pkill -f "d4_glu[e]"       2>/dev/null || true
pkill -f "llama-serve[r]"  2>/dev/null || true
sleep 3
sync

log "still on battery — ${ACTION}"
touch /run/tc-power-event
systemctl --no-block ${ACTION} -i
SCRIPT
chmod 755 /usr/local/sbin/tc-onbattery

cat > /etc/apcupsd/onbattery <<'HOOK'
#!/bin/sh
exec /usr/local/sbin/tc-onbattery
HOOK
chmod 755 /etc/apcupsd/onbattery
echo "==> /etc/apcupsd/onbattery -> tc-onbattery"

# ----------------------------------------------------------------- 3. grace
cat > /usr/local/bin/tc-ready <<'SCRIPT'
#!/bin/sh
# Exit 0 once the charge grace period has elapsed. Use before restarting
# anything heavy:  tc-ready && start-my-training
[ -f /run/tc-charging ] && exit 1
exit 0
SCRIPT
chmod 755 /usr/local/bin/tc-ready

cat > /etc/systemd/system/tc-grace.service <<UNIT
[Unit]
Description=Hold heavy workloads off for ${GRACE} min so the UPS can recharge

[Service]
Type=oneshot
ExecStart=/bin/rm -f /run/tc-charging
UNIT

cat > /etc/systemd/system/tc-grace.timer <<UNIT
[Unit]
Description=Clear the charging marker ${GRACE} min after boot

[Timer]
OnBootSec=${GRACE}min
AccuracySec=30s

[Install]
WantedBy=timers.target
UNIT

cat > /etc/systemd/system/tc-grace-mark.service <<'UNIT'
[Unit]
Description=Mark the UPS as recharging at boot
DefaultDependencies=no
After=local-fs.target
Before=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/touch /run/tc-charging
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable tc-grace.timer tc-grace-mark.service >/dev/null
echo "==> tc-grace: /run/tc-charging present for ${GRACE} min after each boot"

# Keep llama-server from grabbing 11.6 GB of VRAM the instant the box boots.
if [ -f /home/yoda/localAI/start_server.sh ]; then
    if ! grep -q tc-ready /home/yoda/localAI/start_server.sh; then
        sed -i '1a\
# Wait out the UPS charge grace period before taking 11.6 GB of VRAM.\
command -v tc-ready >/dev/null \&\& until tc-ready; do sleep 60; done' \
            /home/yoda/localAI/start_server.sh
        echo "==> start_server.sh now waits for tc-ready"
    fi
fi

echo
echo "Done. Verify with:"
echo "  systemctl status tc-clear-nologin tc-grace.timer"
echo "  ls -l /run/tc-charging      # present = still charging"
echo
echo "Then set BIOS 'Restore on AC Power Loss' = Power On, so the machine"
echo "comes back by itself after the mains returns."
