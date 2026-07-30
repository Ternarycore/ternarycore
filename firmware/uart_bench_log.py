#!/usr/bin/env python3
"""Timestamp UART lines from the Tier 1 benchmark and compute cycle counts.

Usage: python3 uart_bench_log.py /dev/ttyUSB1 /tmp/tier1_uart.log
Stdlib only (termios) -- no pyserial required. Fabric clock = 100 MHz exactly,
so cycles = seconds * 100e6.
"""
import sys, os, termios, time

DEV = sys.argv[1] if len(sys.argv) > 1 else "/dev/ttyUSB1"
LOG = sys.argv[2] if len(sys.argv) > 2 else "/tmp/tier1_uart.log"
F_CLK = 100e6

fd = os.open(DEV, os.O_RDONLY | os.O_NOCTTY)
attrs = termios.tcgetattr(fd)
attrs[0] = 0                       # iflag: raw
attrs[1] = 0                       # oflag
attrs[2] = termios.CS8 | termios.CREAD | termios.CLOCAL   # cflag 8N1
attrs[3] = 0                       # lflag: raw
attrs[4] = termios.B115200
attrs[5] = attrs[4]
attrs[6][termios.VMIN] = 0
attrs[6][termios.VTIME] = 5        # 0.5 s read timeout
termios.tcsetattr(fd, termios.TCSANOW, attrs)
termios.tcflush(fd, termios.TCIFLUSH)

marks = {}
passes = {}
buf = b""
log = open(LOG, "a", buffering=1)
log.write("=== logger start %s ===\n" % time.strftime("%F %T"))
deadline = time.monotonic() + 900   # 15 min hard stop

def emit(line, t):
    log.write("[%12.6f] %s\n" % (t, line))
    parts = line.split()
    if parts and parts[0] == "MARK" and len(parts) >= 2:
        marks[parts[1]] = t
        if len(parts) >= 3 and parts[2].isdigit():
            passes[parts[1]] = int(parts[2])

while time.monotonic() < deadline:
    chunk = os.read(fd, 4096)
    now = time.monotonic()
    if chunk:
        buf += chunk
        while b"\n" in buf:
            raw, buf = buf.split(b"\n", 1)
            line = raw.decode("ascii", "replace").strip()
            if line:
                emit(line, now)
    if "BENCH_DONE" in marks:
        break

def phase(start, end, npass):
    if start in marks and end in marks and npass:
        dt = marks[end] - marks[start]
        cyc = dt * F_CLK
        return dt, dt / npass, cyc / npass
    return None

a = phase("ACCEL_START", "ACCEL_END", passes.get("ACCEL_START"))
s = phase("SW_START", "SW_END", passes.get("SW_START"))
if a and s:
    log.write("RESULT accel: %.4f s total, %.6f s/pass, %.0f cycles/pass\n" % a)
    log.write("RESULT sw:    %.4f s total, %.6f s/pass, %.0f cycles/pass\n" % s)
    log.write("RESULT speedup: %.2fx\n" % (s[1] / a[1]))
else:
    log.write("RESULT incomplete: marks=%r passes=%r\n" % (marks, passes))
log.write("=== logger end ===\n")
