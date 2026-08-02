#!/usr/bin/env python3
"""Time the DDR3 -> weight-BRAM pagers on silicon.

A single 256 KB page now completes faster than one UART line, so absolute
timings are dominated by serial latency. Measure the SLOPE across page counts
instead: the fixed per-command overhead cancels and what is left is the real
per-page cost. PAGEDMA <off> <n> exists for exactly this.

Usage: python pager_bench.py [--dev /dev/ttyUSB1] [--uiclk 81.25e6]
"""
import argparse, time, serial

ap = argparse.ArgumentParser()
ap.add_argument("--dev", default="/dev/ttyUSB1")
ap.add_argument("--uiclk", type=float, default=81.25e6)
ap.add_argument("--counts", default="64,128,256,512")
a = ap.parse_args()

WORDS = 262144 // 4
s = serial.Serial(a.dev, 115200, timeout=60)
time.sleep(0.4)
s.reset_input_buffer()


def between(cmd, first, last):
    """ms between two MARK lines the board emits around the transfer."""
    s.write((cmd + "\n").encode())
    s.flush()
    buf, t0 = "", None
    while True:
        c = s.read(1).decode("utf8", "replace")
        if not c:
            raise TimeoutError(f"no response to {cmd!r}")
        buf += c
        if t0 is None and buf.endswith(first):
            t0 = time.time()
        if buf.endswith(last):
            return (time.time() - t0) * 1000


counts = [int(x) for x in a.counts.split(",")]
tot = {}
for n in counts:
    tot[n] = between(f"PAGEDMA 0 {n}", "MARK PAGEDMA_START", "MARK PAGEDMA_END")
    print(f"n={n:<5d} total {tot[n]:9.2f} ms", flush=True)

slopes = []
for lo, hi in zip(counts, counts[1:]):
    p = (tot[hi] - tot[lo]) / (hi - lo)
    slopes.append(p)
    print(f"slope {lo:4d}->{hi:<4d} {p:.4f} ms/page = "
          f"{p * 1e-3 * a.uiclk / WORDS:.2f} cycles/word")

mean = sum(slopes) / len(slopes)
cpu = between("PAGE 0", "MARK PAGE_START", "MARK PAGE_END")
print(f"\nPAGEDMA  {mean:.3f} ms/page  ({mean * 1e-3 * a.uiclk / WORDS:.2f} cycles/word)")
print(f"CPU PAGE {cpu:.3f} ms/page")
print(f"speedup  {cpu / mean:.1f}x")
print(f"implied  {1000 / (mean * 420):.2f} tok/s for a 110 MB model (420 pages/token)")
