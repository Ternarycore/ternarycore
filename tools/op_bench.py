#!/usr/bin/env python3
"""op_bench.py -- time every non-matrix operator on the soft CPU.

The token budget was assembled from numbers taken by hand, one at a time,
which is how it ended up with no line at all for the activation quantizer
and an estimate for RoPE. This runs the whole table in one pass so the
budget can be rebuilt from measurement instead of memory.

  python tools/op_bench.py --dev /dev/ttyUSB1

Repetitions auto-scale, so an operator costing two cycles an element and
one costing ninety both run long enough for UART latency to vanish into
the noise. The last column converts cycles per element into milliseconds
per token using how many elements each operator actually sees across 28
blocks -- which is the only number that decides anything.
"""
import argparse, os, sys, termios, time

CLK = 81.25e6          # ui_clk, same clock the array and pager run on
H, INTER, NH, NKV, HD, NB, CTX = 1024, 3072, 16, 8, 128, 28, 512

# Elements each operator sees per token, across all 28 blocks.
#   quant   block input (1024) + o_proj input (2048) + down_proj input (3072)
#           + q/k/v head-wise (2048+1024+1024)  -> 10240 per block
#   rope    q (2048) + k (1024)
#   sumsq   two block norms + two SubLN + 24 head norms
#   softmax 16 heads x CTX scores
#   silu    the MLP gate, 3072 wide
PER_TOKEN = {
    0:  ("copy",         NB * H),
    1:  ("rmsnorm",      NB * H),
    2:  ("softmax naive", NB * NH * CTX),
    3:  ("silu",         NB * INTER),
    4:  ("softmax recip", NB * NH * CTX),
    5:  ("softmax defer", NB * NH * CTX),
    6:  ("softmax table", NB * NH * CTX),
    7:  ("silu table",   NB * INTER),
    8:  ("scalar MAC",   NB * 2 * NH * HD * CTX),
    9:  ("quantize 64b", NB * 11264),
    12: ("quantize 32b", NB * 11264),
    10: ("rope 64b",     NB * (NH + NKV) * HD),
    13: ("rope 32b",     NB * (NH + NKV) * HD),
    11: ("sumsq 64b",    NB * 10240),
    14: ("sumsq 32b",    NB * 10240),
    15: ("quant DDR hot",  NB * 11264),
    16: ("quant DDR cold", NB * 11264),
    17: ("rope DDR hot",   NB * 3072),
    18: ("rope DDR cold",  NB * 3072),
    19: ("sumsq DDR hot",  NB * 10240),
    20: ("sumsq DDR cold", NB * 10240),
}


def open_serial(dev):
    fd = os.open(dev, os.O_RDWR | os.O_NOCTTY)
    t = termios.tcgetattr(fd)
    t[0] = t[1] = t[3] = 0
    t[2] = termios.CS8 | termios.CREAD | termios.CLOCAL | termios.B115200
    t[4] = t[5] = termios.B115200
    t[6][termios.VMIN], t[6][termios.VTIME] = 0, 5
    termios.tcsetattr(fd, termios.TCSANOW, t)
    termios.tcflush(fd, termios.TCIOFLUSH)
    return fd


class Board:
    def __init__(self, fd):
        self.fd, self.buf = fd, b""

    def send(self, s):
        os.write(self.fd, s.encode() if isinstance(s, str) else s)

    def lines(self, until, timeout=120):
        """Yield (timestamp, line) until `until` is seen."""
        t0 = time.time()
        while True:
            i = self.buf.find(b"\n")
            if i < 0:
                if time.time() - t0 > timeout:
                    raise TimeoutError(f"waiting for {until!r}: {self.buf[-120:]!r}")
                d = os.read(self.fd, 4096)
                if d:
                    self.buf += d
                continue
            line = self.buf[:i].decode("utf8", "replace").strip()
            self.buf = self.buf[i + 1:]
            if line:
                yield time.time(), line
                if until in line:
                    return

    def bench(self, op, reps, n):
        self.send(f"BENCH {op} {reps} {n}\n")
        t_start = t_end = None
        for ts, line in self.lines("OK B"):
            if "BENCH_START" in line:
                t_start = ts
            elif "BENCH_END" in line:
                t_end = ts
        if t_start is None or t_end is None:
            raise RuntimeError(f"op {op}: no marks")
        return t_end - t_start


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--n", type=int, default=1024)
    ap.add_argument("--target", type=float, default=1.5,
                    help="seconds each operator should run for")
    ap.add_argument("--ops", default="0,1,2,3,4,5,6,7,8,9,10,11")
    a = ap.parse_args()

    b = Board(open_serial(a.dev))
    b.send("PING\n")
    for _, line in b.lines("PONG"):
        pass

    print(f"n={a.n}, clock {CLK/1e6:.2f} MHz, {NB} blocks, context {CTX}\n")
    print(f"{'op':>3} {'name':<16} {'cyc/elem':>9} {'ms/token':>9}  per-token elements")
    total = 0.0
    for op in [int(x) for x in a.ops.split(",")]:
        name, elems = PER_TOKEN.get(op, (f"op{op}", 0))
        probe = b.bench(op, 20, a.n)                  # cheap first pass
        reps = max(20, min(200000, int(20 * a.target / max(probe, 1e-4))))
        dt = b.bench(op, reps, a.n)
        cyc = dt * CLK / (reps * a.n)
        ms = cyc * elems / CLK * 1e3
        print(f"{op:>3} {name:<16} {cyc:>9.2f} {ms:>9.1f}  {elems:>10,}",
              flush=True)
    print("\nNote: ops 2-6 and 3/7 are alternatives, not additive. "
          "The budget takes the table-driven ones.")


if __name__ == "__main__":
    main()
