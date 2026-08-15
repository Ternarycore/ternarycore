#!/usr/bin/env python3
"""Bulk-load a file into the board's DDR3 over raw Ethernet.

Frame seq n carries bytes [n*chunk : (n+1)*chunk] and the board writes them to
DDR_BASE + off + n*chunk, so frames may arrive in any order and a failed page
can be retried without re-sending the model.

Pair with the board's ETHLOAD <off> <count> <chunk>; the reported byte
checksum uses LOADM's convention, so the fast path can be checked against the
slow one.  sudo python3 eth_load.py --iface enp10s0 --file page.bin
"""
import argparse, socket, struct, sys, time

ap = argparse.ArgumentParser()
ap.add_argument("--iface", required=True)
ap.add_argument("--dst", default="02:54:43:00:00:01")
ap.add_argument("--file", required=True)
ap.add_argument("--chunk", type=int, default=1024)
ap.add_argument("--gap", type=float, default=0.0,
                help="seconds between frames; raise if the board drops any")
a = ap.parse_args()

ETH_TYPE = 0x88B5
dst = bytes(int(x, 16) for x in a.dst.split(":"))
data = open(a.file, "rb").read()
n = (len(data) + a.chunk - 1) // a.chunk

s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
s.bind((a.iface, 0))
src = s.getsockname()[4][:6]

t0 = time.time()
for seq in range(n):
    body = data[seq * a.chunk:(seq + 1) * a.chunk]
    frame = (dst + src + struct.pack("!H", ETH_TYPE)
             + struct.pack("!IH", seq, len(body)) + body)
    if len(frame) < 60:
        frame += b"\x00" * (60 - len(frame))
    s.send(frame)
    if a.gap:
        time.sleep(a.gap)
dt = time.time() - t0

print(f"sent {n} frames, {len(data)} bytes in {dt:.2f}s "
      f"= {len(data)/dt/1e6:.1f} MB/s")
import struct as _s
words = _s.unpack("<%dI" % (len(data)//4), data[:len(data)//4*4])
chk = sum(w * (i + 1) for i, w in enumerate(words)) & 0xFFFFFFFF
print(f"host checksum 0x{chk:08x}  (position-weighted)")
print(f"board command: ETHLOAD <off> {n} {a.chunk}")
