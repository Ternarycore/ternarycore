#!/usr/bin/env python3
"""P1 energy campaign: meter-bracketed windows on the tier2 bitstream.

Windows (all bracketed by GET /power from the INA226 rig, IP resolved once):
  idle    : configured tier2 bitstream, board waiting at the UART prompt
  accel   : CPU-fed array (accel_forward_pass loop)   -- RUN n, ACCEL marks
  sw      : soft-CPU GEMM (sw_forward_pass loop)      -- RUN n, SW marks
  stream  : tier2 feeder+array (stream_tile loop)     -- SRUN m, STREAM marks

Firmware: tier2_energy.elf (RUN falls through on verify-fail, sw_passes=passes).
Weights/activations must already be loaded (tier2_host.py --passes 2 first).
Output: ~/tc-energy-campaign.json + log lines on stdout.
"""
import json, os, socket, sys, termios, time, urllib.request

DEV = "/dev/ttyUSB1"
RUN_PASSES = 650          # accel ~65 s, sw ~211 s
SRUN_PASSES = 400000      # ~64 s
IDLE_S = 75

ip = socket.getaddrinfo("tc-power.local", 80)[0][4][0]
print("meter ip", ip, flush=True)

def meter():
    with urllib.request.urlopen(f"http://{ip}/power", timeout=3) as r:
        return json.load(r)

def open_serial(dev):
    fd = os.open(dev, os.O_RDWR | os.O_NOCTTY)
    a = termios.tcgetattr(fd)
    a[0] = 0; a[1] = 0
    a[2] = termios.CS8 | termios.CREAD | termios.CLOCAL
    a[3] = 0
    a[4] = a[5] = termios.B115200
    a[6][termios.VMIN] = 0
    a[6][termios.VTIME] = 10
    termios.tcsetattr(fd, termios.TCSANOW, a)
    termios.tcflush(fd, termios.TCIOFLUSH)
    return fd

results = {}

def record(name, m0, m1, extra=None):
    dt = (m1["ms"] - m0["ms"]) / 1e3
    dj = m1["j"] - m0["j"]
    w = dj / dt if dt > 0 else 0
    results[name] = {"seconds": round(dt, 3), "joules": round(dj, 3),
                     "watts_avg": round(w, 4),
                     "w_inst_start": m0["w"], "w_inst_end": m1["w"]}
    if extra: results[name].update(extra)
    print(f"WINDOW {name}: {dt:.1f} s, {dj:.1f} J, {w:.4f} W avg "
          f"(inst {m0['w']:.3f}->{m1['w']:.3f})", flush=True)

# ---- idle ----
print("idle window...", flush=True)
m0 = meter(); time.sleep(IDLE_S); m1 = meter()
record("idle", m0, m1)

# ---- RUN: accel + sw ----
fd = open_serial(DEV)
time.sleep(0.3)
os.write(fd, f"RUN {RUN_PASSES}\n".encode())
buf = b""
marks = {}
deadline = time.time() + 600
while time.time() < deadline:
    c = os.read(fd, 256)
    if not c:
        time.sleep(0.005); continue
    buf += c
    done = False
    while b"\n" in buf:
        line, buf = buf.split(b"\n", 1)
        t = line.decode(errors="replace").strip()
        print("board:", t, flush=True)
        if t.startswith("MARK "):
            marks[t.split()[1]] = meter()
        if t == "DONE":
            done = True
    if done: break
record("accel_cpu_fed", marks["ACCEL_START"], marks["ACCEL_END"],
       {"passes": RUN_PASSES})
record("sw_soft_cpu", marks["SW_START"], marks["SW_END"],
       {"passes": RUN_PASSES})

# ---- SRUN: streamed tier2 ----
os.write(fd, f"SRUN {SRUN_PASSES}\n".encode())
marks = {}
deadline = time.time() + 300
while time.time() < deadline:
    c = os.read(fd, 256)
    if not c:
        time.sleep(0.005); continue
    buf += c
    done = False
    while b"\n" in buf:
        line, buf = buf.split(b"\n", 1)
        t = line.decode(errors="replace").strip()
        print("board:", t, flush=True)
        if t.startswith("MARK "):
            marks[t.split()[1]] = meter()
        if t == "DONE":
            done = True
    if done: break
record("stream_tier2", marks["STREAM_START"], marks["STREAM_END"],
      {"passes": SRUN_PASSES})

# ---- deltas ----
base = results["idle"]["watts_avg"]
for k in ("accel_cpu_fed", "sw_soft_cpu", "stream_tier2"):
    results[k]["delta_w_vs_idle"] = round(results[k]["watts_avg"] - base, 4)

out = os.path.expanduser("~/tc-energy-campaign.json")
json.dump(results, open(out, "w"), indent=2)
print("WROTE", out, flush=True)
print("CAMPAIGN_DONE", flush=True)
