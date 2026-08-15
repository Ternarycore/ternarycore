#!/usr/bin/env python3
"""Verify attention's Q.K^T on the ternary array (AMAC).

Layout: element i occupies eight consecutive weight words, w = 8i + b, whose
low 64 bits hold bit b of k_j[i] for the 64 columns. act_ram holds q[i]
written eight times; the feeder shifts by b and selects sign on b=7.

  LOADW 0 16384   bit-sliced K
  LOADA 128       Q
  SLOAD8          expand Q eight-fold into act_ram
  AMAC            run, read back 64 dot products
"""
import argparse, os, sys, termios, time
import numpy as np

ap = argparse.ArgumentParser()
ap.add_argument("--dev", default="/dev/ttyUSB1")
ap.add_argument("--seed", type=int, default=7)
a = ap.parse_args()
N, COLS = 128, 64

rng = np.random.default_rng(a.seed)
q = rng.integers(-128, 128, N).astype(np.int8)
k = rng.integers(-128, 128, (COLS, N)).astype(np.int8)
q[0], k[0, 0] = -128, -128          # plant the corner that broke the old negation
want = (q.astype(np.int64)[None, :] * k.astype(np.int64)).sum(1)

# bit-slice K: word 8i+b, bit j = bit b of k_j[i]
blob = bytearray(1024 * 16)
ku = k.astype(np.uint8)
for i in range(N):
    for b in range(8):
        bits = 0
        for j in range(COLS):
            if (ku[j, i] >> b) & 1:
                bits |= (1 << j)
        blob[(i * 8 + b) * 16:(i * 8 + b) * 16 + 8] = bits.to_bytes(8, "little")

fd = os.open(a.dev, os.O_RDWR | os.O_NOCTTY)
t = termios.tcgetattr(fd)
t[0] = t[1] = t[3] = 0
t[2] = termios.CS8 | termios.CREAD | termios.CLOCAL | termios.B115200
t[4] = t[5] = termios.B115200
t[6][termios.VMIN], t[6][termios.VTIME] = 0, 20
termios.tcsetattr(fd, termios.TCSANOW, t)
termios.tcflush(fd, termios.TCIOFLUSH)

def expect(tok, secs=60):
    buf, t0 = b"", time.time()
    while time.time() - t0 < secs:
        d = os.read(fd, 4096)
        if d: buf += d
        if tok in buf: return buf.decode("utf8", "replace")
    raise TimeoutError(f"waiting for {tok!r}, got {buf[-200:]!r}")

def send(s): os.write(fd, s if isinstance(s, bytes) else s.encode())

send("PING\n"); expect(b"PONG")
t0 = time.time()
send(f"LOADW 0 {len(blob)}\n"); time.sleep(0.3)
for i in range(0, len(blob), 4096):
    send(bytes(blob[i:i+4096])); time.sleep(0.02)
expect(b"OK W"); print(f"K bit-sliced and loaded, {len(blob)} B in {time.time()-t0:.1f}s")

send(f"LOADA {N}\n"); time.sleep(0.2)
send(q.tobytes()); expect(b"OK A")
send("SL8\n"); expect(b"OK SL8")
send("AMAC\n"); out = expect(b"OK AM")

cyc = int([l for l in out.splitlines() if l.startswith("ACYC")][0].split()[1])
got8 = [int(x) for x in
        [l for l in out.splitlines() if l.startswith("AOUT")][0].split()[1:]]
bchk = int([l for l in out.splitlines() if l.startswith("ACHK")][0].split()[1], 16)
hchk = sum(int(v) * (c + 1) for c, v in enumerate(want)) & 0xFFFFFFFF

print(f"cycles       {cyc}   ({cyc/1024:.2f} per MAC-slot, 8 slots per MAC)")
print(f"board  first8 {got8}")
print(f"host   first8 {want[:8].tolist()}")
print(f"checksum board 0x{bchk:08x}  host 0x{hchk:08x}")
ok = (got8 == want[:8].tolist()) and (bchk == hchk)
print("AMAC EXACT" if ok else "AMAC MISMATCH")
sys.exit(0 if ok else 1)
