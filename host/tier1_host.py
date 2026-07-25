#!/usr/bin/env python3
"""Host sender for the TernaryCore Stage 1 streaming firmware (tier1_host.c).

Usage:
  python3 tier1_host.py --dev /dev/ttyUSB1 --weights weights.bin \
                        --activations acts.bin [--expected expected.txt] \
                        [--passes 200] [--log /tmp/stage1.log]

weights.bin  : DEPTH*GROUPS packed bytes, addr = k*GROUPS + g (4 codes/byte)
acts.bin     : up to DEPTH int8 activation bytes
expected.txt : optional, 768 whitespace-separated ints (host-computed reference)

Stdlib only. Timestamps MARK lines; fabric = 100 MHz exactly.
"""
import argparse, os, sys, termios, time

F_CLK = 100e6

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

class Board:
    def __init__(self, fd, log):
        self.fd, self.log, self.buf = fd, log, b""
        self.marks, self.passes = {}, {}

    def send(self, s):
        os.write(self.fd, s.encode() if isinstance(s, str) else s)

    def read_line(self, timeout=30):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if b"\n" in self.buf:
                raw, self.buf = self.buf.split(b"\n", 1)
                line = raw.decode("ascii", "replace").strip()
                if not line:
                    continue
                t = time.monotonic()
                self.log.write("[%12.6f] %s\n" % (t, line))
                p = line.split()
                if p and p[0] == "MARK":
                    self.marks[p[1]] = t
                    if len(p) > 2 and p[2].isdigit():
                        self.passes[p[1]] = int(p[2])
                return line
            chunk = os.read(self.fd, 4096)
            if chunk:
                self.buf += chunk
        raise TimeoutError("no line from board")

    def expect(self, prefix, timeout=30):
        while True:
            l = self.read_line(timeout)
            if l.startswith(prefix):
                return l

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--weights", required=True)
    ap.add_argument("--activations", required=True)
    ap.add_argument("--expected")
    ap.add_argument("--passes", type=int, default=200)
    ap.add_argument("--log", default="/tmp/stage1.log")
    args = ap.parse_args()

    w = open(args.weights, "rb").read()
    a = open(args.activations, "rb").read()
    log = open(args.log, "a", buffering=1)
    log.write("=== stage1 host %s ===\n" % time.strftime("%F %T"))
    fd = open_serial(args.dev)
    b = Board(fd, log)

    b.send("\nPING\n")
    b.expect("PONG", timeout=10)
    print("board: PONG")

    t0 = time.monotonic()
    b.send("LOADW 0 %d\n" % len(w))
    b.send(w)
    r = b.expect("OK W", timeout=120)
    dt = time.monotonic() - t0
    want = "0x%08x" % (sum(w) & 0xFFFFFFFF)
    ok = r.split()[2] == want
    print("LOADW %d bytes in %.1fs, checksum %s (%s)" % (len(w), dt, r.split()[2], "match" if ok else "MISMATCH want " + want))
    if not ok:
        sys.exit(1)

    b.send("LOADA %d\n" % len(a))
    b.send(a)
    r = b.expect("OK A")
    want = "0x%08x" % (sum(a) & 0xFFFFFFFF)
    print("LOADA %d bytes, checksum %s" % (len(a), "match" if r.split()[2] == want else "MISMATCH"))

    b.send("RUN %d\n" % args.passes)
    outs = None
    while True:
        l = b.read_line(timeout=600)
        print("  " + l)
        if l.startswith("CHK"):
            outs = [int(x) for x in l.split("OUT")[1].strip().split(",")]
        if l.startswith("VERIFY FAIL") or l == "DONE":
            if l == "DONE":
                break
            sys.exit(2)

    if args.expected and outs:
        exp = [int(x) for x in open(args.expected).read().split()][:8]
        if outs[:8] == exp:
            print("HOST REFERENCE MATCH (first 8 outputs)")
        else:
            print("HOST REFERENCE MISMATCH: board %s vs host %s" % (outs[:8], exp))
            sys.exit(3)

    def phase(s, e):
        if s in b.marks and e in b.marks and b.passes.get(s):
            dt = b.marks[e] - b.marks[s]
            n = b.passes[s]
            return dt, dt / n, dt / n * F_CLK
        return None

    acc, sw = phase("ACCEL_START", "ACCEL_END"), phase("SW_START", "SW_END")
    if acc and sw:
        print("RESULT accel: %.4fs total, %.6f s/pass, %.0f cycles/pass" % acc)
        print("RESULT sw:    %.4fs total, %.6f s/pass, %.0f cycles/pass" % sw)
        print("RESULT speedup: %.2fx" % (sw[1] / acc[1]))
        log.write("RESULT speedup %.2fx (accel %.0f cyc, sw %.0f cyc)\n" % (sw[1]/acc[1], acc[2], sw[2]))

if __name__ == "__main__":
    main()
