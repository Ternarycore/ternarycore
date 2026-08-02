#!/bin/bash
# fort-silicon UPS power-resilience setup. Run once:  sudo bash tools/fort-ups-setup.sh
# APC USB UPS (051d:0002) -> on battery >40s: suspend-to-RAM with RTC wake
# every 8 min; resume automatically when mains returns. Training survives in RAM.
set -e

echo '== 1/5 install apcupsd =='
DEBIAN_FRONTEND=noninteractive apt-get install -y apcupsd >/dev/null

echo '== 2/5 apcupsd.conf =='
cat > /etc/apcupsd/apcupsd.conf <<'EOF'
UPSNAME fortups
UPSCABLE usb
UPSTYPE usb
DEVICE
ONBATTERYDELAY 6
BATTERYLEVEL 20
MINUTES 3
TIMEOUT 40
KILLDELAY 0
NETSERVER on
NISIP 127.0.0.1
EOF
sed -i 's/^ISCONFIGURED=no/ISCONFIGURED=yes/' /etc/default/apcupsd 2>/dev/null || true

echo '== 3/5 suspend loop hook =='
cat > /usr/local/bin/tc-suspend-loop.sh <<'EOF'
#!/bin/bash
# On-battery handler: suspend with RTC self-wake until mains returns.
logger "tc-power: on battery >40s, entering suspend/wake loop"
sync
for i in $(seq 1 75); do            # ~10 h worth of 8-min naps
    rtcwake -m mem -s 480 >/dev/null 2>&1 || { logger 'tc-power: rtcwake failed'; exit 1; }
    sleep 10                        # let USB/UPS re-enumerate after wake
    if apcaccess -p STATUS 2>/dev/null | grep -q ONLINE; then
        logger "tc-power: mains restored after $i naps, staying awake"
        exit 0
    fi
    logger "tc-power: still on battery (nap $i), re-suspending"
done
logger "tc-power: outage exceeded ~10 h, powering off"
shutdown -h now
EOF
chmod +x /usr/local/bin/tc-suspend-loop.sh

# custom doshutdown: apccontrol runs this instead of poweroff (exit 99 = skip default)
cat > /etc/apcupsd/doshutdown <<'EOF'
#!/bin/bash
setsid /usr/local/bin/tc-suspend-loop.sh >/dev/null 2>&1 &
exit 99
EOF
chmod +x /etc/apcupsd/doshutdown

echo '== 4/5 NVIDIA suspend-to-RAM support =='
cat > /etc/modprobe.d/nvidia-power.conf <<'EOF'
options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp
EOF
systemctl enable nvidia-suspend.service nvidia-resume.service 2>/dev/null || true
update-initramfs -u >/dev/null 2>&1 &

echo '== 5/5 Wake-on-LAN (bonus: wake fort from the Mac) =='
IF=$(ip route show default | awk '{print $5; exit}')
ethtool -s "$IF" wol g 2>/dev/null && echo "WoL enabled on $IF" || echo "WoL not supported on $IF"
cat > /etc/systemd/system/wol@.service <<'EOF'
[Unit]
Description=Enable Wake-on-LAN on %i
After=network.target
[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s %i wol g
[Install]
WantedBy=multi-user.target
EOF
systemctl enable "wol@$IF.service" 2>/dev/null || true

systemctl restart apcupsd
sleep 3
echo '== UPS status =='
apcaccess status | grep -E 'STATUS|BCHARGE|TIMELEFT|MODEL' || true
echo
echo 'DONE. Behavior: mains lost -> 40 s grace -> suspend-to-RAM -> self-wake'
echo 'every 8 min to check mains -> stay up when power returns. Note: NVIDIA'
echo 'video-memory preservation fully applies after the next reboot; until'
echo 'then CUDA jobs may die on resume (checkpoint auto-resume covers it).'
""""""
