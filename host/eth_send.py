#!/usr/bin/env python3
"""Send raw test frames to the Arty's EthernetLite. No IP stack: the board
talks to exactly one host over a direct link, so a custom EtherType with a
sequence number is enough.

Frame: [0..5] dst MAC  [6..11] src MAC  [12..13] 0x88B5
       [14..17] seq BE  [18..19] payload len BE  [20..] payload

Needs root for AF_PACKET.  sudo python3 eth_send.py --iface enp10s0
"""
import argparse, socket, struct, sys

ap = argparse.ArgumentParser()
ap.add_argument("--iface", required=True)
ap.add_argument("--dst", default="02:54:43:00:00:01", help="board MAC")
ap.add_argument("--count", type=int, default=1)
ap.add_argument("--payload", type=int, default=64)
ap.add_argument("--seq0", type=int, default=0)
a = ap.parse_args()

ETH_TYPE = 0x88B5
dst = bytes(int(x, 16) for x in a.dst.split(":"))

s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
s.bind((a.iface, 0))
src = s.getsockname()[4][:6]

sent = 0
for i in range(a.count):
    seq = a.seq0 + i
    body = bytes((seq + j) & 0xFF for j in range(a.payload))
    frame = dst + src + struct.pack("!H", ETH_TYPE) + struct.pack("!IH", seq, len(body)) + body
    if len(frame) < 60:
        frame += b"\x00" * (60 - len(frame))   # pad to the 60-byte minimum
    s.send(frame)
    sent += 1

print(f"sent {sent} frame(s) on {a.iface}, src {src.hex(':')} -> dst {a.dst}, "
      f"ethertype 0x{ETH_TYPE:04X}, payload {a.payload} B")
