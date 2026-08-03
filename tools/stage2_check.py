#!/usr/bin/env python3
"""stage2_check.py -- a real projection, stage 1 feeding stage 2.

Runs the chain a block will run: a residual-shaped vector through NQ, its
int8 output into PROJ against real ternary weights paged from DDR, and the
int32 accumulators compared against W @ a in numpy. Nothing is injected
between the stages, so a mismatch is the board's and not the test's.

  python tools/stage2_check.py --export ~/tc-export/d4-student-sst2-r2

The 2048-deep o_proj case matters most. The array is 1024 deep, so that
projection is two weight pages accumulated in software, and a suite that
covers only 1024-deep layers passes while the real block is wrong on two
of its seven.
"""
import argparse, json, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board

PAGE = 262144


def load_page(b, path, byte_off=0, nbytes=PAGE, ddr_off=0):
    """UART one 256 KB page of packed weights into DDR, then DMA it in."""
    blob = open(path, "rb").read()[byte_off:byte_off + nbytes]
    t0 = time.time()
    b.send(f"LOADM {ddr_off} {len(blob)}\n")
    time.sleep(0.3)
    for i in range(0, len(blob), 4096):
        b.send(blob[i:i + 4096])
        time.sleep(0.012)
    b.until("OK M")
    b.send(f"PAGEDMA {ddr_off}\n")
    b.until("OK PD")
    return time.time() - t0


def unpack(path, out_features, in_features):
    """addr = k*GROUPS + g, four codes per byte LSB-first, 00=0 01=+1 10=-1."""
    raw = np.frombuffer(open(path, "rb").read(), dtype=np.uint8)
    codes = np.stack([(raw >> (2 * s)) & 3 for s in range(4)], axis=1)
    w = np.where(codes == 1, 1, np.where(codes == 2, -1, 0)).astype(np.int8)
    return w.reshape(in_features, out_features).T          # (out, in)


def loadb(b, slot, vec):
    v = np.asarray(vec, dtype=np.int8)
    b.send(f"LOADB {slot} {v.size}\n")
    time.sleep(0.2)
    b.send(v.tobytes())
    b.until("OK B")


def run_case(b, z, exp, blk, name, gain_key, in_f, out_f):
    man = json.load(open(os.path.join(exp, "manifest.json")))
    key = f"{blk}.{name}"
    path = os.path.join(exp, man["layers"][key]["file"])
    W = unpack(path, out_f, in_f)
    assert W.shape == (out_f, in_f), W.shape

    rng = np.random.default_rng(blk * 977 + out_f)
    x = rng.standard_normal(in_f) * 3.0
    x[rng.integers(0, in_f, 8)] *= 40.0
    xi = np.clip(np.rint(x * (32767.0 / np.abs(x).max())),
                 -32767, 32767).astype(np.int32)
    g = z[gain_key].astype(np.float64)
    gi = np.clip(np.rint(g / np.abs(g).max() * 32767),
                 -32767, 32767).astype(np.int32)

    b.loadv(0, xi)
    b.loadv(1, gi)
    b.send(f"NQ 0 1 2 {in_f}\n")
    b.until("OK NQ")
    a = b.dumpr(2, in_f)                       # the int8 the board will use

    want, _ = tc_ref.quant_a(tc_ref.rmsnorm(xi.astype(np.float64),
                                            gi.astype(np.float64)))
    if not np.array_equal(a, want):
        print(f"  {key}: stage 1 differs on "
              f"{int(np.count_nonzero(a - want))} elements")
        return False

    segs, ntile = in_f // 1024, out_f // 64
    print(f"  {key:<28} {out_f}x{in_f}  {segs} seg x {ntile} tile", flush=True)

    tload = 0.0
    for s in range(segs):
        tload += load_page(b, path, s * PAGE)
        loadb(b, 3, a[s * 1024:(s + 1) * 1024])
        b.send(f"PROJ 3 4 {ntile} {s}\n")
        out = b.until("OK PJ")

    acc = W.astype(np.int32) @ a.astype(np.int32)
    line = [l for l in out.splitlines() if l.startswith("PCHK")][0]
    pchk = int(line.split()[1], 16)
    host = int(sum(int(v) * (i + 1) for i, v in enumerate(acc)) & 0xFFFFFFFF)
    ok = pchk == host
    print(f"    weights {tload:.1f}s   {line}")
    print(f"    checksum board 0x{pchk:08x} host 0x{host:08x} "
          f"{'MATCH' if ok else 'DIFFER'}")
    return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    a = ap.parse_args()

    z = np.load(a.cache)
    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")

    print("stage 2: NQ -> PROJ, real ternary weights\n")
    cases = [(0, "self_attn.k_proj", "0.in_norm", 1024, 1024),
             (0, "self_attn.v_proj", "0.in_norm", 1024, 1024),
             (13, "self_attn.k_proj", "13.in_norm", 1024, 1024),
             (0, "self_attn.o_proj", "0.o_proj.subln", 2048, 1024)]
    ok = sum(int(run_case(b, z, a.export, *c)) for c in cases)
    print(f"\n{ok}/{len(cases)} exact")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
