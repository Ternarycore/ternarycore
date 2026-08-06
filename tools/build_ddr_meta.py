#!/usr/bin/env python3
"""build_ddr_meta.py -- the block's constants, resident in DDR.

A token today costs 574.8 seconds, of which 0.75 is the board computing.
The rest is 162 KB per block crossing a 115200-baud line, 28 times. A
quarter of that traffic is norm gains: the host re-uploads the same
constant vectors on every nq call, on every block, on every token.

They are constants. They belong in DDR, next to the weights.

  python tools/build_ddr_meta.py -o ~/tc-ddr

Emits meta.bin -- 28 records of 32 KB at DDR offset 0x07000000, which is
the gap between the weight image ending at 110.1 MB and the KV cache
starting at 128 MB.

Gains are Q15 normalized by their own maximum, exactly as q15v does on
the host, because that is what cmd_nq's 16x16 products assume. The
maximum itself is kept separately as block-float: nq's output scale is
gmax * mx / (Q15 * 127 * rms), so the firmware needs the magnitude the
normalization divided out.

Projection scales are block-float too. Every scale in this design is
either cancelled by an RMSNorm or carried as a (mantissa, exponent)
pair; there is no floating-point unit on this CPU and there never will
be one.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import struct
import sys

import numpy as np

Q15 = 32767
STRIDE = 0x8000          # 32 KB per block, 28 blocks = 896 KB
META_OFF = 0x07000000    # between the weight image and the KV cache

#        name             elements   byte offset in the record
GAINS = (("in_norm",        1024,     0x0000),
         ("post_norm",      1024,     0x1000),
         ("q_norm",          128,     0x2000),
         ("k_norm",          128,     0x2200),
         ("o_proj.subln",   1024,     0x2400),
         ("down_proj.subln", 2048,    0x3400))

SCALES_OFF = 0x7400      # 7 projections x (mantissa u32, exp i32)
GMAX_OFF = 0x7440        # 6 gains x (mantissa u32, exp i32)

PROJS = ("q_proj", "k_proj", "v_proj", "o_proj",
         "gate_proj", "up_proj", "down_proj")


def blockfloat(x):
    """Positive float -> (mantissa in [2^30, 2^31), exponent), as sc_norm.

    The same normalization the firmware's scalar helpers assume on entry.
    sc_mul and sc_div were both fixed once for taking normalized inputs
    on faith; handing them a denormal from here would reopen that.
    """
    if x <= 0:
        return 0, 0
    e, m = 0, float(x)
    while m < (1 << 30):
        m *= 2
        e -= 1
    while m >= (1 << 31):
        m /= 2
        e += 1
    return int(round(m)), e


def q15v(v):
    """Normalize to Q15 by the vector's own maximum. Returns (int32, max)."""
    m = float(np.abs(v).max())
    if m == 0:
        return np.zeros(len(v), dtype=np.int32), 1.0
    return (np.clip(np.rint(np.asarray(v, dtype=np.float64) * (Q15 / m)),
                    -Q15, Q15).astype(np.int32), m)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--outdir", default=os.path.expanduser("~/tc-ddr"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--blocks", type=int, default=28)
    a = ap.parse_args()

    z = np.load(a.cache)
    os.makedirs(a.outdir, exist_ok=True)
    path = os.path.join(a.outdir, "meta.bin")

    with open(path, "wb") as f:
        for blk in range(a.blocks):
            rec = bytearray(STRIDE)

            for name, n, off in GAINS:
                g = z[f"{blk}.{name}"].astype(np.float64)
                if g.size != n:
                    sys.exit(f"{blk}.{name}: {g.size} elements, expected {n}")
                gi, _ = q15v(g)
                rec[off:off + n * 4] = gi.astype("<i4").tobytes()

            for i, p in enumerate(PROJS):
                m, e = blockfloat(float(z[f"{blk}.{p}.s"]))
                struct.pack_into("<Ii", rec, SCALES_OFF + i * 8, m, e)

            for i, (name, _, _) in enumerate(GAINS):
                gmax = float(np.abs(z[f"{blk}.{name}"]).max())
                m, e = blockfloat(gmax)
                struct.pack_into("<Ii", rec, GMAX_OFF + i * 8, m, e)

            assert len(rec) == STRIDE
            f.write(rec)

    sz = os.path.getsize(path)
    print(f"  meta.bin      {sz/1024:.0f} KB, {a.blocks} records "
          f"of {STRIDE//1024} KB")
    print(f"  DDR offset    0x{META_OFF:08X} .. 0x{META_OFF+sz:08X}")
    print(f"  record        gains to 0x{GAINS[-1][2] + GAINS[-1][1]*4:04X}, "
          f"scales at 0x{SCALES_OFF:04X}, gmax at 0x{GMAX_OFF:04X}")
    print(f"  headroom      weight image ends at 0x{110100480:08X}, "
          f"KV cache starts at 0x08000000")

    # Read one record back and check it against the checkpoint, because a
    # layout this positional is exactly the kind that agrees with itself.
    with open(path, "rb") as f:
        f.seek(13 * STRIDE)
        rec = f.read(STRIDE)
    for name, n, off in GAINS:
        got = np.frombuffer(rec, dtype="<i4", count=n, offset=off)
        want, _ = q15v(z[f"13.{name}"].astype(np.float64))
        if not np.array_equal(got, want):
            sys.exit(f"readback mismatch: 13.{name}")
    for i, p in enumerate(PROJS):
        m, e = struct.unpack_from("<Ii", rec, SCALES_OFF + i * 8)
        if abs(m * (2.0 ** e) / float(z[f"13.{p}.s"]) - 1.0) > 1e-9:
            sys.exit(f"readback mismatch: 13.{p}.s")
    print("  readback      block 13 verifies, gains and scales")


if __name__ == "__main__":
    main()
