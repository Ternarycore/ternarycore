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

One thing this found on its first run: layers with more than 1024 outputs
cannot be paged straight from the export. The packed layout is
addr = k*GROUPS + g with GROUPS = out/4, and the array addresses exactly
1024 columns, so it expects GROUPS = 256. q_proj (2048) and gate/up
(3072) therefore need splitting into 1024-output slices and re-packing.
o_proj is fine at 1024 outputs despite reading 2048, because a depth
split is the segment case stage 2 already covers.
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
    m = float(np.abs(v).max())
    if m == 0:
        return np.zeros(len(v), dtype=np.int32), 1.0
    return (np.clip(np.rint(np.asarray(v, dtype=np.float64) * (Q15 / m)),
                    -Q15, Q15).astype(np.int32), m / Q15)


def pack_slice(W):
    """(1024 out, 1024 in) ternary -> the array's own packed layout.

    addr = k*GROUPS + g with GROUPS = 256, four codes per byte LSB-first,
    00 = 0, 01 = +1, 10 = -1. The export packs whole layers with
    GROUPS = out/4, which only matches the array when out is 1024.
    """
    out, inf = W.shape
    assert out == 1024, out
    codes = np.where(W.T == 1, 1, np.where(W.T == -1, 2, 0)).astype(np.uint8)
    codes = codes.reshape(inf, out // 4, 4)
    packed = (codes[:, :, 0] | (codes[:, :, 1] << 2)
              | (codes[:, :, 2] << 4) | (codes[:, :, 3] << 6))
    return packed.astype(np.uint8).tobytes()


def load_bytes(b, blob, ddr_off=0):
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
    return np.abs(a - bv).max() / max(np.abs(bv).max(), 1e-30)


def report(name, got, want, tol):
    r = rel(got, want)
    ok = r <= tol
    print(f"    {name:<26} rel {r:9.6f}  {'ok' if ok else 'DIFFERS'}")
    return ok


def project(b, W, aq, tag):
    """Run W @ aq on the board, slicing outputs to the array's 1024."""
    out, inf = W.shape
    got = np.zeros(out, dtype=np.int64)
    for c in range(0, out, 1024):
        sub = W[c:c + 1024]
        for s in range(inf // 1024):
            load_bytes(b, pack_slice(sub[:, s * 1024:(s + 1) * 1024]))
            loadb(b, 3, aq[s * 1024:(s + 1) * 1024])
            b.send(f"PROJ 3 4 16 {s}\n")
            b.until("OK PJ")
        got[c:c + 1024] = dumpi32(b, 4, 1024)
    return got


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--block", type=int, default=0)
    ap.add_argument("--pos", type=int, default=0)
    a = ap.parse_args()

    z = np.load(a.cache)
    man = json.load(open(os.path.join(a.export, "manifest.json")))
    blk = a.block
    b = Board(a.dev)
    b.sync()
    print(f"stage 9: attention sub-block, block {blk}\n")

    rng = np.random.default_rng(1000 + blk)
    x = rng.standard_normal(H) * 3.0
    x[rng.integers(0, H, 8)] *= 40.0
    ok = True
    accs = {}

    gain = z[f"{blk}.in_norm"].astype(np.float64)
    xi, _ = q15v(x)
    gi, _ = q15v(gain)
    b.loadv(0, xi)
    b.loadv(1, gi)
    b.send(f"NQ 0 1 2 {H}\n")
    b.until("OK NQ")
    aq = b.dumpr(2, H)
    want_a, _ = tc_ref.quant_a(tc_ref.rmsnorm(xi.astype(np.float64),
                                              gi.astype(np.float64)))
    print("  input_layernorm -> int8")
    ok &= report("activations", aq, want_a, 0.0)

    for name, outf in (("k_proj", 1024), ("v_proj", 1024), ("q_proj", 2048)):
        key = f"{blk}.self_attn.{name}"
        W = unpack(os.path.join(a.export, man["layers"][key]["file"]), outf, H)
        print(f"  {name} {outf}x{H}")
        got = project(b, W, aq, name)
        want = W.astype(np.int32) @ aq.astype(np.int32)
        ok &= report("accumulators", got, want, 0.0)
        accs[name] = got

    # --- QK-norm + RoPE ------------------------------------------------
    # The first stage whose output another stage consumes as a scale.
    # RMSNorm cancels the projection's own factor, so what has to survive
    # the handoff is the per-head maximum and sum of squares the board
    # reports -- those alone let the host rebuild the true magnitude that
    # softmax needs.
    cos, sin = tc_ref.rope_tables(a.pos)
    ci = np.clip(np.rint(cos[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(sin[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
    b.loadv(2, np.concatenate([ci, si]))

    for name, nh in (("q", NH), ("k", NKV)):
        acc = accs[f"{name}_proj"]
        gq = z[f"{blk}.{name}_norm"].astype(np.float64)
        gqi, _ = q15v(gq)
        b.loadv(0, acc.astype(np.int32))
        b.loadv(1, gqi)
        b.send(f"QKN 0 1 2 3 4 {nh} {HD}\n")
        b.until("OK QK")
        got = b.dumpr(3, nh * HD)

        cosf = np.concatenate([ci, ci]).astype(np.float64) / 32768.0
        sinf = np.concatenate([si, si]).astype(np.float64) / 32768.0
        want = np.zeros(nh * HD, dtype=np.int8)
        for h in range(nh):
            t = tc_ref.rmsnorm(acc[h * HD:(h + 1) * HD].astype(np.float64),
                               gqi.astype(np.float64))
            want[h * HD:(h + 1) * HD], _ = tc_ref.quant_a(
                tc_ref.rope(t, cosf, sinf))
        d = got.astype(int) - want.astype(int)
        nz, worst = int(np.count_nonzero(d)), int(np.abs(d).max())
        print(f"  {name}_norm + RoPE, {nh} heads")
        print(f"    {'int8 out':<26} {nz}/{nh*HD} differ, max |d| {worst}, "
              f"mean {d.mean():+.4f}")
        ok &= worst <= 1 and abs(d.mean()) < 0.02

    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
