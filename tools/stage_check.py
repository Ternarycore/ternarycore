#!/usr/bin/env python3
"""stage_check.py -- hold one block-executor stage to the golden model.

A transformer block is about twenty operators deep. Checking only the
token at the end makes every bug look the same, so each stage is verified
against tools/tc_ref.py the moment it is written, in isolation, on real
tensors from the real checkpoint.

  python tools/stage_check.py --cache ~/tc-ckpt/tc-ref-warmup.npz

Stage 1 (nq): fused RMSNorm + absmax int8 quantize. The board is given x
scaled into 16 bits and a Q15 gain; the reference computes
quant_a(rmsnorm(x, g)) in float64 on the identical integer inputs, so any
difference is the board's arithmetic rather than the test's setup.

The report is a difference histogram, not a boolean. Fixed-point rounding
against numpy's will disagree by one LSB on some elements, which is fine;
a difference of two, or a mean that is not near zero, is a bug. Those are
indistinguishable in a pass/fail and obvious in a mean.
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

    def sync(self, tries=8):
        """Handshake that tolerates a board still coming out of reset.

        xsdb can still be releasing the core when a check opens the port,
        so a single PING gets swallowed and the PONG that arrives belongs
        to the previous firmware -- after which every subsequent command
        is lost. Retry until the board genuinely answers.
        """
        for _ in range(tries):
            termios.tcflush(self.fd, termios.TCIOFLUSH)
            self.buf = b""
            self.send("PING\n")
            try:
                self.until("PONG", timeout=3)
                return
            except TimeoutError:
                time.sleep(1)
        raise TimeoutError("board never answered PING")

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
        tok = line.split()          # BCHK <hex> B v0 v1 ...  -- by token, not
        return int(tok[1], 16), [int(v) for v in tok[3:]]   # by split("B")

    def dumpr(self, slot, n):
        """Whole vector, raw. The payload can hold any byte including
        newline, so count bytes rather than read lines."""
        self.send(f"DUMPR {slot} {n}\n")
        hdr = b""
        while not hdr.endswith(b"\n"):
            d = os.read(self.fd, 1)
            if d:
                hdr += d
        buf = b""
        while len(buf) < n:
            d = os.read(self.fd, n - len(buf))
            if d:
                buf += d
        self.until("OK DR")
        return np.frombuffer(buf, dtype=np.int8)


def bchk(a):
    return int(sum(int(v) * (i + 1) for i, v in enumerate(a)) & 0xFFFFFFFF)


def stage_nq(b, z, blk, name, gain_key, n):
    """One fused RMSNorm+quantize case, from real checkpoint tensors."""
    rng = np.random.default_rng(blk * 31 + n)
    g = z[gain_key].astype(np.float64)
    x = rng.standard_normal(n) * 3.0
    x[rng.integers(0, n, 8)] *= 40.0            # the outliers that matter

    # Board contract: x mantissas inside 16 bits, gain normalized to Q15.
    xi = np.clip(np.rint(x * (32767.0 / np.abs(x).max())),
                 -32767, 32767).astype(np.int32)
    gi = np.clip(np.rint(g / np.abs(g).max() * 32767),
                 -32767, 32767).astype(np.int32)

    # The reference sees exactly the integers the board sees.
    want, _ = tc_ref.quant_a(tc_ref.rmsnorm(xi.astype(np.float64),
                                            gi.astype(np.float64)))

    b.loadv(0, xi)
    b.loadv(1, gi)
    b.send(f"NQ 0 1 2 {n}\n")
    info = b.until("OK NQ")
    got_chk, got_head = b.dumpb(2, n)
    got = b.dumpr(2, n)

    line = [l for l in info.splitlines() if l.startswith("NQ")][0]
    d = got.astype(int) - want.astype(int)
    nz = int(np.count_nonzero(d))
    print(f"  block {blk} {name:<13} n={n:<5} {line}")
    print(f"    board {got_head}")
    print(f"    host  {want[:8].tolist()}")
    print(f"    diff  {nz}/{n} differ, max |d| {int(np.abs(d).max())}, "
          f"mean {d.mean():+.4f}")
    ok = got_chk == bchk(want)
    print(f"    checksum board 0x{got_chk:08x} host 0x{bchk(want):08x} "
          f"{'MATCH' if ok else 'DIFFER'}")
    return ok, nz, d


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache", default=tc_ref.CACHE)
    a = ap.parse_args()

    z = np.load(a.cache)
    b = Board(a.dev)
    b.sync()

    cases = [(0, "in_norm", "0.in_norm", 1024),
             (0, "post_norm", "0.post_norm", 1024),
             (0, "o_proj subln", "0.o_proj.subln", 2048),
             (0, "down subln", "0.down_proj.subln", 3072),
             (13, "in_norm", "13.in_norm", 1024),
             (27, "post_norm", "27.post_norm", 1024)]

    print("stage nq: fused RMSNorm + int8 quantize\n")
    exact = worst = 0
    for blk, name, key, n in cases:
        ok, nz, d = stage_nq(b, z, blk, name, key, n)
        exact += int(ok)
        worst = max(worst, int(np.abs(d).max()))
        print()
    print(f"{exact}/{len(cases)} bit-exact, worst element difference {worst}")
    sys.exit(0 if worst <= 1 else 1)


if __name__ == "__main__":
    main()
