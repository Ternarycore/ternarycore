#!/usr/bin/env python3
"""eth_load.py -- bulk weights into the Arty's DDR over raw Ethernet.

UART moves a 256 KB weight page in about 25 seconds. The token loop needs
420 of them resident, which is just under three hours -- and DDR does not
survive reprogramming the FPGA, so it would be three hours at the start of
every session. The board's EthernetLite is 100 Mbit and the firmware's
ETHLOAD has been sitting there unexercised since phase 3, waiting for a
sender. This is the sender.

  sudo python tools/eth_load.py --selftest
  sudo python tools/eth_load.py --image ~/tc-ddr/weights.bin

Raw AF_PACKET with EtherType 0x88B5, so no IP stack is involved and the
board needs no address configuration -- it programs its own MAC into the
EmacLite address filter and we send straight to it.

Frame layout, which the firmware parses out of aligned 32-bit reads because
AXI4-Lite has no unaligned access:

    [0:6]   destination MAC        [6:12]  source MAC
    [12:14] 0x88B5                 [14:18] sequence number, big-endian
    [18:20] payload length, BE     [20:]   payload

Frame seq n lands at DDR_BASE + off + n*chunk, so frames are position-
addressed rather than streamed: order does not matter and a page can be
retried on its own. The verification is the firmware's own checksum, which
weights each word by its DDR address -- a plain byte sum is order-blind and
once matched perfectly on thoroughly scrambled memory.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import socket
import struct
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board

ETYPE = 0x88B5
BOARD_MAC = bytes.fromhex("025443000001")
CHUNK = 1024                  # divides a 256 KB page exactly 256 times
PAGE = 256 * 1024


def open_sock(ifname):
    s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(ETYPE))
    s.bind((ifname, 0))
    return s, s.getsockname()[4][:6]


def fw_checksum(off, blob):
    """The firmware's weighted sum, reproduced exactly.

    sum += w * (((dst + i) >> 2) + 1) over 32-bit words, truncated to 32
    bits at every step. Each product is masked before accumulating: the
    index fits in 25 bits and the word in 32, so a uint64 holds one product
    but not their sum.
    """
    a = np.frombuffer(blob, dtype="<u4").astype(np.uint64)
    idx = np.uint64(off >> 2) + np.uint64(1) + np.arange(a.size, dtype=np.uint64)
    return int(((a * idx) & np.uint64(0xFFFFFFFF)).sum() % (1 << 32))


def build_frames(off, blob, src, chunk=CHUNK):
    hdr = BOARD_MAC + src + struct.pack("!H", ETYPE)
    n = (len(blob) + chunk - 1) // chunk
    return [hdr + struct.pack("!IH", q, len(blob[q * chunk:(q + 1) * chunk]))
            + blob[q * chunk:(q + 1) * chunk] for q in range(n)], n


def send_region(b, sock, src, off, blob, chunk=CHUNK, gap=0.0, tries=3):
    """One ETHLOAD transfer, retried whole on any mismatch.

    The board only starts listening after it prints MARK ETHLOAD_START and
    gives up after roughly 60 ms of silence, so the frames have to follow
    the handshake immediately and cannot stall in the middle.
    """
    frames, n = build_frames(off, blob, src, chunk)
    want = fw_checksum(off, blob)
    for attempt in range(tries):
        b.send(f"ETHLOAD {off} {n} {chunk}\n")
        b.until("MARK ETHLOAD_START", timeout=10)
        t0 = time.time()
        if gap:
            for f in frames:
                sock.send(f)
                time.sleep(gap)
        else:
            for f in frames:
                sock.send(f)
        out = b.until("OK E", timeout=30)
        dt = time.time() - t0
        line = [l for l in out.splitlines() if l.startswith("OK E")][0].split()
        got_sum, got_n = int(line[2], 16), int(line[4])
        if got_n == n and got_sum == want:
            return dt, len(blob) * 8 / dt / 1e6
        if attempt == tries - 1:
            raise RuntimeError(
                f"off {off}: {got_n}/{n} frames, checksum {got_sum:08x} "
                f"want {want:08x} after {tries} tries")
        print(f"    retry {attempt+1}: {got_n}/{n} frames, "
              f"checksum {'ok' if got_sum == want else 'BAD'}", flush=True)
        time.sleep(0.3)


def selftest(b, sock, src, args):
    """One page, at the offset the first real weight page will occupy.

    Random data on purpose: the checksum is weighted by address, so a
    constant or a ramp can hide a frame landing one slot out, and this
    transfer is the only thing standing between here and trusting 105 MB
    of it.
    """
    rng = np.random.default_rng(11)
    print(f"selftest: {PAGE // 1024} KB to DDR offset 0, chunk {args.chunk}\n")
    dt = None
    for trial in range(2):
        blob = rng.integers(0, 256, PAGE, dtype=np.uint8).tobytes()
        dt, mbps = send_region(b, sock, src, 0, blob, args.chunk, args.gap)
        print(f"  trial {trial}   {dt*1000:7.1f} ms   {mbps:6.1f} Mbit/s   "
              f"{PAGE/dt/1e6:5.1f} MB/s", flush=True)
    full = 420 * PAGE
    print(f"\n  420 pages ({full/1e6:.0f} MB) would take "
          f"{full/(PAGE/dt):.0f} s at this rate")
    print("  (UART, for comparison: about 10500 s)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--iface", default="enp10s0")
    ap.add_argument("--chunk", type=int, default=CHUNK)
    ap.add_argument("--gap", type=float, default=0.0,
                    help="inter-frame delay in seconds; 0 lets Python pace it")
    ap.add_argument("--selftest", action="store_true")
    ap.add_argument("--image", help="packed weight image to load at offset 0")
    ap.add_argument("--limit", type=int, default=0,
                    help="stop after this many pages (0 = all)")
    a = ap.parse_args()

    if a.chunk % 4:
        sys.exit("chunk must be a multiple of 4: the copy loop steps by words")

    sock, src = open_sock(a.iface)
    print(f"{a.iface} {src.hex(':')} -> {BOARD_MAC.hex(':')}  "
          f"ethertype 0x{ETYPE:04X}", flush=True)
    b = Board(a.dev)
    b.sync()

    if a.selftest:
        selftest(b, sock, src, a)
        return

    if not a.image:
        sys.exit("nothing to do: pass --selftest or --image")

    size = os.path.getsize(a.image)
    npages = size // PAGE
    if a.limit:
        npages = min(npages, a.limit)
    print(f"{a.image}: {size/1e6:.1f} MB, {npages} pages\n")
    t0, done = time.time(), 0
    with open(a.image, "rb") as f:
        for p in range(npages):
            blob = f.read(PAGE)
            send_region(b, sock, src, p * PAGE, blob, a.chunk, a.gap)
            done += len(blob)
            if p % 20 == 0 or p == npages - 1:
                el = time.time() - t0
                print(f"  page {p:3d}/{npages}  {done/1e6:6.1f} MB  "
                      f"{done*8/el/1e6:6.1f} Mbit/s  "
                      f"eta {(npages-p-1)*el/(p+1):5.0f}s", flush=True)
    el = time.time() - t0
    print(f"\n{done/1e6:.1f} MB in {el:.1f} s -- {done*8/el/1e6:.1f} Mbit/s")


if __name__ == "__main__":
    main()
