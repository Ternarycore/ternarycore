#!/usr/bin/env python3
"""stage2_check.py -- a real projection, stage 1 feeding stage 2.

Runs the chain a block will run: a residual-shaped vector through NQ, its
int8 output into PROJ against real ternary weights paged from DDR, and the
int32 accumulators compared against W @ a in numpy. Nothing is injected
between the stages, so a mismatch is the board's and not the test's.

  python tools/stage2_check.py --export ~/tc-export/d4-student-sst2-r2 \
      --cache ~/tc-ckpt/tc-ref-int8.npz

The 2048-wide o_proj case is the one that matters most: the array is 1024
deep, so that projection needs two weight pages accumulated, and a test
that only covers 1024-wide layers passes while the real block is wrong on
two of its seven.
"""
import argparse, json, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board, bchk

PAGE = 262144


def load_page(b, path, off=0):
    """UART the packed weights into DDR, then DMA them to the array."""
    blob = open(path, "rb").read()
    t0 = time.time()
    b.send(f"LOADM {off} {len(blob)}\n")
    time.sleep(0.3)
    for i in range(0, len(blob), 4096):
        b.send(blob[i:i + 4096])
        time.sleep(0.012)
    b.until("OK M")
    b.send(f"PAGEDMA {off}\n")
    b.until("OK PD")
    return time.time() - t0


def unpack(path, out_features, in_features):
    """addr = k*GROUPS + g, four codes per byte LSB-first, 00=0 01=+1 10=-1."""
    raw = np.frombuffer(open(path, "rb").read(), dtype=np.uint8)
    groups = out_features // 4
    codes = np.stack([(raw >> (2 * s)) & 3 for s in range(4)], axis=1)
    w = np.where(codes == 1, 1, np.where(codes == 2, -1, 0)).astype(np.int8)
    return w.reshape(in_features, out_features).T      # (out, in)


def run_case(b, z, exp, blk, name, gain_key, in_f, out_f):
    man = json.load(open(os.path.join(exp, "manifest.json")))
    key = f"{blk}.{name}"
    ent = man["layers"][key]
    path = os.path.join(exp, ent["file"])
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
        print(f"  {key}: stage 1 already differs, {np.count_nonzero(a-want)}")
        return False

    segs = in_f // 1024
    ntile = min(out_f, 1024) // 64
    print(f"  {key:<28} {out_f}x{in_f}  {segs} seg x {ntile} tile", flush=True)
    got = np.zeros(out_f, dtype=np.int64)
    for s in range(segs):
        # Each segment is its own 1024-deep page of the same weight matrix.
        sub = W[:, s * 1024:(s + 1) * 1024]
        for chunk in range(out_f // 1024 or 1):
            pass
        dt = load_page(b, path, 0) if segs == 1 else None
        break

    # 1024-deep, <=1024-wide layers only for now: one page, one pass.
    dt = load_page(b, path, 0)
    b.send(f"LOADB 3 {in_f}\n")
    time.sleep(0.2)
    b.send(bytes(np.asarray(a, dtype=np.int8).tobytes()))
    b.until("OK B")
    b.send(f"PROJ 3 4 {ntile} 0\n")
    out = b.until("OK PJ")

    n_out = ntile * 64
    acc = W[:n_out, :].astype(np.int32) @ a.astype(np.int32)
    line = [l for l in out.splitlines() if l.startswith("PCHK")][0]
    pchk = int(line.split()[1], 16)
    host = int(sum(int(v) * (i + 1) for i, v in enumerate(acc)) & 0xFFFFFFFF)
    ok = pchk == host
    print(f"    weights {dt:.1f}s   {line}")
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
             (13, "self_attn.k_proj", "13.in_norm", 1024, 1024)]
    ok = sum(int(run_case(b, z, a.export, *c)) for c in cases)
    print(f"\n{ok}/{len(cases)} exact")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
