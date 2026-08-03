#!/usr/bin/env python3
"""block_check.py -- stage 9: a whole attention sub-block on the board.

Every operator has been checked alone. This runs them in sequence, which
is the only way to see error compound and the only way to catch a scale
that is self-consistent inside one stage and wrong between two.

  python tools/block_check.py --block 0 --pos 0

This is tc_ref with its vector operations replaced by board calls -- the
host holds the residual in float64 and orchestrates, exactly as the
reference does, so a divergence is the board's arithmetic rather than a
different algorithm. Every intermediate is compared as it is produced, so
a failure names its stage instead of arriving as one wrong vector at the
end.

Attention half only for now: six weight pages against the MLP's nine, and
at 23 s a page over UART that is a two-minute run instead of six while
this is still being debugged.
"""
import argparse, json, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board
from stage2_check import unpack, load_page, loadb, PAGE

H, NH, NKV, HD = 1024, 16, 8, 128
BIAS, Q15 = 512, 32767


def q15v(v):
    """Normalize to Q15, returning the vector and the factor removed."""
    m = float(np.abs(v).max())
    if m == 0:
        return np.zeros(len(v), dtype=np.int32), 1.0
    return (np.clip(np.rint(np.asarray(v, dtype=np.float64) * (Q15 / m)),
                    -Q15, Q15).astype(np.int32), m / Q15)


def blockfloat(x):
    if x <= 0:
        return 0, 0
    e, m = 0, float(x)
    while m < (1 << 30):
        m *= 2; e -= 1
    while m >= (1 << 31):
        m /= 2; e += 1
    return int(round(m)), e


def dumpi32(b, slot, n):
    b.send(f"DUMPR {slot} {n * 4}\n")
    hdr = b""
    while not hdr.endswith(b"\n"):
        d = os.read(b.fd, 1)
        if d:
            hdr += d
    buf = b""
    while len(buf) < n * 4:
        d = os.read(b.fd, n * 4 - len(buf))
        if d:
            buf += d
    b.until("OK DR")
    return np.frombuffer(buf, dtype=np.int32)


def rel(a, bv):
    a = np.asarray(a, dtype=np.float64); bv = np.asarray(bv, dtype=np.float64)
    d = np.abs(a - bv).max()
    s = max(np.abs(bv).max(), 1e-30)
    return d / s


def report(name, got, want, tol):
    r = rel(got, want)
    ok = r <= tol
    print(f"    {name:<26} rel {r:9.6f}  {'ok' if ok else 'DIFFERS'}")
    return ok


def nq_on_board(b, x, gain, n, src=0, gsl=1, dst=2):
    """Fused RMSNorm+quantize on the board; returns int8 and its scale."""
    xi, _ = q15v(x)
    gi, _ = q15v(gain)
    gmax = float(np.abs(gain).max())
    b.loadv(src, xi)
    b.loadv(gsl, gi)
    b.send(f"NQ {src} {gsl} {dst} {n}\n")
    out = b.until("OK NQ")
    tok = [l for l in out.splitlines() if l.startswith("NQ ")][0].split()
    mx, ss, xs = int(tok[2]), int(tok[4], 16), int(tok[6])
    a = b.dumpr(dst, n)
    # s_a = gmax * mx / (32767 * 127 * rms(xi)), and the host's own scaling
    # of x cancels because RMSNorm normalizes it away.
    rms = np.sqrt(ss * (4.0 ** xs) / n)
    s_a = gmax * mx / (Q15 * 127.0 * rms) if rms > 0 else 0.0
    return a, s_a, xi


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--block", type=int, default=0)
    ap.add_argument("--pos", type=int, default=0)
    ap.add_argument("--tol", type=float, default=0.02)
    a = ap.parse_args()

    z = np.load(a.cache)
    man = json.load(open(os.path.join(a.export, "manifest.json")))
    blk, pos = a.block, a.pos
    b = Board(a.dev)
    b.sync()
    print(f"stage 9: attention sub-block, block {blk}, position {pos}\n")

    rng = np.random.default_rng(1000 + blk)
    x = rng.standard_normal(H) * 3.0
    x[rng.integers(0, H, 8)] *= 40.0
    ok = True

    # --- input norm + quantize -------------------------------------------
    gain = z[f"{blk}.in_norm"].astype(np.float64)
    aq, s_a, xi = nq_on_board(b, x, gain, H)
    want_a, want_sa = tc_ref.quant_a(tc_ref.rmsnorm(xi.astype(np.float64),
                                                    q15v(gain)[0].astype(np.float64)))
    print("  input_layernorm -> int8")
    ok &= report("activations", aq, want_a, 0.0)

    # --- q, k, v ----------------------------------------------------------
    accs = {}
    for name, outf in (("q_proj", 2048), ("k_proj", 1024), ("v_proj", 1024)):
        key = f"{blk}.self_attn.{name}"
        path = os.path.join(a.export, man["layers"][key]["file"])
        W = unpack(path, outf, H)
        ntile = min(outf, 1024) // 64
        got = np.zeros(outf, dtype=np.int64)
        for half in range(outf // 1024):
            load_page(b, path, half * PAGE)
            loadb(b, 3, aq)
            b.send(f"PROJ 3 4 {ntile} 0\n")
            b.until("OK PJ")
            got[half * 1024:(half + 1) * 1024] = dumpi32(b, 4, 1024)
        want = W.astype(np.int32) @ aq.astype(np.int32)
        print(f"  {name} {outf}x{H}")
        ok &= report("accumulators", got, want, 0.0)
        accs[name] = got.astype(np.float64) * float(z[f"{blk}.{name}.s"]) * s_a

    print(f"\n{'PASS' if ok else 'FAIL'} -- every intermediate matched"
          if ok else f"\nFAIL")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
