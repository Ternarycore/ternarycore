#!/usr/bin/env python3
"""stage3_check.py -- QK-norm and rotary embedding against the reference.

The board is given int32 accumulators shaped like a real projection's
output and returns int8 ready for the attention dot. The reference does
rmsnorm, rotate, quantize in float64.

  python tools/stage3_check.py --cache ~/tc-ckpt/tc-ref-warmup.npz

The reference is handed the *quantized* gain and the *quantized* cos and
sin. Comparing against exact trigonometry would measure Q15's resolution
instead of the board's arithmetic; those are different questions and only
the second one is a bug.

Position 0 is included deliberately. cos is all ones and sin all zeros
there, so the rotation is the identity and anything that differs is the
norm's doing -- which separates two suspects that are otherwise tangled
together.
"""
import argparse, os, sys
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board

HD, NH, NKV = 128, 16, 8


def q15(v):
    return np.clip(np.rint(np.asarray(v, dtype=np.float64) * 32768),
                   -32767, 32767).astype(np.int32)


def rope_tables_q15(pos):
    cos, sin = tc_ref.rope_tables(pos)          # length HD, halves duplicated
    return q15(cos[:HD // 2]), q15(sin[:HD // 2])


def run_case(b, z, blk, which, nh, pos):
    key = f"{blk}.{which}_norm"
    g = z[key].astype(np.float64)
    gi = np.clip(np.rint(g / np.abs(g).max() * 32767),
                 -32767, 32767).astype(np.int32)

    rng = np.random.default_rng(blk * 101 + nh + pos)
    # Accumulator-shaped: a 1024-deep ternary dot of int8 activations.
    acc = rng.integers(-40000, 40000, nh * HD).astype(np.int32)
    acc[rng.integers(0, nh * HD, 4)] = 130048   # the worst case the array can emit

    ci, si = rope_tables_q15(pos)
    cs = np.concatenate([ci, si]).astype(np.int32)

    b.loadv(0, acc)
    b.loadv(1, gi)
    b.loadv(2, cs)
    b.send(f"QKN 0 1 2 3 4 {nh} {HD}\n")
    b.until("OK QK")
    got = b.dumpr(3, nh * HD)

    # Reference on the identical integers, including the quantized angles.
    cosf = np.concatenate([ci, ci]).astype(np.float64) / 32768.0
    sinf = np.concatenate([si, si]).astype(np.float64) / 32768.0
    want = np.zeros(nh * HD, dtype=np.int8)
    for h in range(nh):
        t = tc_ref.rmsnorm(acc[h * HD:(h + 1) * HD].astype(np.float64),
                           gi.astype(np.float64))
        t = tc_ref.rope(t, cosf, sinf)
        want[h * HD:(h + 1) * HD], _ = tc_ref.quant_a(t)

    d = got.astype(int) - want.astype(int)
    nz = int(np.count_nonzero(d))
    print(f"  block {blk:2d} {which}_norm  {nh} heads  pos {pos:<4} "
          f"diff {nz}/{nh*HD}, max |d| {int(np.abs(d).max())}, "
          f"mean {d.mean():+.4f}")
    return int(np.abs(d).max()) <= 1 and abs(d.mean()) < 0.01


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache", default=tc_ref.CACHE)
    a = ap.parse_args()

    z = np.load(a.cache)
    b = Board(a.dev)
    b.send("PING\n")
    b.until("PONG")

    print("stage 3: QK-norm + RoPE\n")
    cases = [(0, "q", NH, 0),       # identity rotation: isolates the norm
             (0, "q", NH, 1),
             (0, "k", NKV, 1),
             (0, "q", NH, 137),
             (13, "q", NH, 511),
             (27, "k", NKV, 511)]
    ok = sum(int(run_case(b, z, *c)) for c in cases)
    # Bit-exact is not reachable here and that is a measured fact, not a
    # concession: three rounded shifts at 127/32767 LSB per unit predict
    # about 8 flipped roundings per 2048, and 3-10 is what appears. Closing
    # the gap needs 64-bit RoPE, which benchmarked 6x slower. The criterion
    # is therefore one LSB with no bias -- which still fails loudly on the
    # kind of systematic error stage 1 had.
    print(f"\n{ok}/{len(cases)} at the arithmetic floor (<=1 LSB, no bias)")
    sys.exit(0 if ok == len(cases) else 1)


if __name__ == "__main__":
    main()
