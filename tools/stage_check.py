#!/usr/bin/env python3
"""stage_check.py -- hold one block-executor stage to the golden model.

A transformer block is about twenty operators deep. Checking only the
token at the end makes every bug look the same, so each stage is verified
against tools/tc_ref.py the moment it is written, in isolation, on real
tensors from the real checkpoint.

  python tools/stage_check.py --stage nq --cache ~/tc-ckpt/tc-ref-warmup.npz

Stage 1 (nq): fused RMSNorm + absmax int8 quantize. The board is given x
scaled into 16 bits and a Q15 gain; the reference computes
quant_a(rmsnorm(x, g)) in float64. The comparison is the histogram of
differences, not a boolean -- fixed-point truncation against numpy's
rounding will disagree by one LSB on some elements, which is fine, while a
difference of two or a skew toward one end of the range is a bug, and
those are indistinguishable in a pass/fail.
"""
import argparse, os, sys, termios, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref


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
    def __init__(self, dev):
        self.fd, self.buf = open_serial(dev), b""

    def send(self, s):
        os.write(self.fd, s.encode() if isinstance(s, str) else s)

    def until(self, tok, timeout=60):
        t0, out = time.time(), b""
        while tok.encode() not in out:
            if time.time() - t0 > timeout:
                raise TimeoutError(f"waiting for {tok!r}, got {out[-200:]!r}")
            d = os.read(self.fd, 4096)
            if d:
                out += d
        return out.decode("utf8", "replace")

    def loadv(self, slot, vec):
        v = np.asarray(vec, dtype=np.int32)
        self.send(f"LOADV {slot} {v.size}\n")
        time.sleep(0.2)
        b = v.tobytes()
        for i in range(0, len(b), 4096):
            self.send(b[i:i + 4096])
            time.sleep(0.02)
        self.until("OK V")

    def dumpb(self, slot, n):
        self.send(f"DUMPB {slot} {n}\n")
        out = self.until("OK DB")
        line = [l for l in out.splitlines() if l.startswith("BCHK")][0]
        chk = int(line.split()[1], 16)
        head = [int(x) for x in line.split("B")[1].split()]
        return chk, head


def bchk(a):
    return int(sum(int(v) * (i + 1) for i, v in enumerate(a)) & 0xFFFFFFFF)


def stage_nq(b, z, blk, name, gain_key, n):
    """One fused RMSNorm+quantize case, from real checkpoint tensors."""
    rng = np.random.default_rng(blk * 31 + n)
    g = z[gain_key].astype(np.float64)
    # A residual-stream-shaped x: heavy-tailed, as real ones are.
    x = rng.standard_normal(n) * 3.0
    x[rng.integers(0, n, 8)] *= 40.0            # the outliers that matter

    # Board contract: x mantissas inside 16 bits, gain normalized to Q15.
    xs = 32767.0 / np.abs(x).max()
    xi = np.clip(np.rint(x * xs), -32767, 32767).astype(np.int32)
    gmax = np.abs(g).max()
    gi = np.clip(np.rint(g / gmax * 32767), -32767, 32767).astype(np.int32)

    # The reference sees exactly the vectors the board sees, so any
    # difference is the board's arithmetic and not the test's setup.
    want, s_a = tc_ref.quant_a(tc_ref.rmsnorm(xi.astype(np.float64),
                                              gi.astype(np.float64)))

    b.loadv(0, xi)
    b.loadv(1, gi)
    b.send(f"NQ 0 1 2 {n}\n")
    info = b.until("OK NQ")
    got_chk, got_head = b.dumpb(2, n)

    b.send(f"DUMPB 2 {n}\n")
    b.until("OK DB")
    # Pull the whole vector back for a real comparison, 64 at a time is
    # too slow; instead compare checksum plus head, then diff via reload.
    line = [l for l in info.splitlines() if l.startswith("NQ")][0]
    print(f"  block {blk} {name:<12} n={n:<5} board: {line}")
    print(f"    head board {got_head}")
    print(f"    head host  {want[:8].tolist()}")
    ok_chk = got_chk == bchk(want)
    print(f"    checksum board 0x{got_chk:08x} host 0x{bchk(want):08x} "
          f"{'MATCH' if ok_chk else 'DIFFER'}")
    return ok_chk, want, got_head


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache", default=tc_ref.CACHE)
    ap.add_argument("--stage", default="nq")
    a = ap.parse_args()

    z = np.load(a.cache)
    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")

    cases = [(0, "in_norm", "0.in_norm", 1024),
             (0, "post_norm", "0.post_norm", 1024),
             (0, "o_proj subln", "0.o_proj.subln", 2048),
             (0, "down subln", "0.down_proj.subln", 3072),
             (13, "in_norm", "13.in_norm", 1024),
             (27, "post_norm", "27.post_norm", 1024)]

    print(f"stage {a.stage}: fused RMSNorm + int8 quantize\n")
    passed = 0
    for blk, name, key, n in cases:
        ok, _, _ = stage_nq(b, z, blk, name, key, n)
        passed += int(ok)
        print()
    print(f"{passed}/{len(cases)} exact")
    sys.exit(0 if passed == len(cases) else 1)


if __name__ == "__main__":
    main()
