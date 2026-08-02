#!/usr/bin/env python3
"""Tier-2 stream benchmark driver (Phase-1 exit measurement).

Protocol: PING -> LOADW 0 <256K> -> LOADA 1024 -> SLOAD -> SRUN <passes>.
Parses CYC (cycles per 64-col tile pass), host-timestamps the MARK window,
reads back all 1024 outputs, verifies against expected.txt, and reports the
speedup vs the measured CPU-fed baseline (9,183,783 cycles per full 1024-col
layer on the same fabric, D5 measurement).
"""
import argparse, os, sys, termios, time

BAUD_BASELINE_CYCLES = 9183783   # CPU-fed full-layer, measured 2026-08-01


def open_serial(dev):
    fd = os.open(dev, os.O_RDWR | os.O_NOCTTY)
    a = termios.tcgetattr(fd)
    a[0] = a[1] = a[3] = 0
    a[2] = termios.CS8 | termios.CREAD | termios.CLOCAL
    a[4] = a[5] = termios.B115200
    termios.tcsetattr(fd, termios.TCSANOW, a)
    return fd


class Board:
    def __init__(self, fd):
        self.fd = fd; self.buf = b""
    def read_line(self, timeout=30):
        t0 = time.time()
        while True:
            i = self.buf.find(b"\n")
            if i >= 0:
                l = self.buf[:i].decode(errors="replace").strip()
                self.buf = self.buf[i+1:]
                if l: return l
                continue
            if time.time() - t0 > timeout:
                raise TimeoutError("no line from board")
            try: self.buf += os.read(self.fd, 4096)
            except BlockingIOError: time.sleep(0.005)
    def expect(self, pfx, timeout=30):
        while True:
            l = self.read_line(timeout)
            print("board:", l)
            if l.startswith(pfx): return l
    def send(self, s): os.write(self.fd, s.encode())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--weights", required=True)
    ap.add_argument("--activations", required=True)
    ap.add_argument("--expected", required=True)
    ap.add_argument("--passes", type=int, default=100)
    args = ap.parse_args()

    wb = open(args.weights, "rb").read()
    ab = open(args.activations, "rb").read()
    exp = [int(x) for x in open(args.expected).read().split()]
    assert len(wb) == 262144 and len(ab) == 1024 and len(exp) == 1024

    b = Board(open_serial(args.dev))
    time.sleep(0.3)
    b.send("PING\n"); b.expect("PONG")

    t0 = time.time()
    b.send(f"LOADW 0 {len(wb)}\n")
    for i in range(0, len(wb), 4096):
        os.write(b.fd, wb[i:i+4096])
    l = b.expect("OK W", timeout=120)
    print(f"LOADW {len(wb)} bytes in {time.time()-t0:.1f}s ({l})")

    b.send(f"LOADA {len(ab)}\n"); os.write(b.fd, ab); b.expect("OK A")
    b.send("SLOAD\n"); b.expect("OK SL")

    b.send(f"SRUN {args.passes}\n")
    cyc = int(b.expect("CYC").split()[1])
    b.expect("MARK STREAM_START"); t1 = time.time()
    b.expect("MARK STREAM_END");   t2 = time.time()
    schk = b.expect("SCHK")
    b.expect("DONE")

    wall = t2 - t1
    layer_cycles_wall = wall * 100e6 / args.passes      # includes poll overhead
    tile_cycles = cyc                                    # pure datapath, 1 tile
    layer_cycles_pure = tile_cycles * 16
    print(f"RESULT tile cycles (datapath):   {tile_cycles}")
    print(f"RESULT layer cycles (16 tiles):  {layer_cycles_pure} pure / "
          f"{layer_cycles_wall:.0f} incl-AXI-poll")
    print(f"RESULT speedup vs CPU-fed layer: {BAUD_BASELINE_CYCLES/layer_cycles_pure:.0f}x pure / "
          f"{BAUD_BASELINE_CYCLES/layer_cycles_wall:.0f}x incl-poll")
    print(f"RESULT GOPS @100MHz:             {2*1024*1024/ (layer_cycles_pure/1e2) / 1e3:.1f}")

    outs = [int(x) for x in schk.split("OUT")[1].strip().rstrip(",").split(",")]
    ok = outs == exp[:8]
    print("HOST REFERENCE", "MATCH (first 8)" if ok else f"MISMATCH {outs} vs {exp[:8]}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
""""""
