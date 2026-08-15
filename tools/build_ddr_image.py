#!/usr/bin/env python3
"""build_ddr_image.py -- the whole model, pre-sliced into array pages.

The exporter packs each projection as one blob with GROUPS = out/4. The
array addresses exactly 1024 columns and wants GROUPS = 256, which is only
the same thing when out is 1024 -- true for k_proj, v_proj, o_proj and
down_proj, false for q_proj and both MLP up-legs. Every check so far has
re-sliced on the host at test time. The token loop cannot: re-packing
105 MB per token would cost more than the arithmetic.

So do it once, offline, in the exact order the block executor will ask for
the pages, and hand the board a flat image it can DMA from by index.

  python tools/build_ddr_image.py -o ~/tc-ddr

Emits weights.bin (105 MB, 420 pages of 256 KB), pages.json (the offset
table) and meta.npz (per-projection scales and the norm gains, which stay
float and are small enough to keep separate).

Page index is blk*15 + slot, with slot fixed by SLOTS below, so the
firmware needs a fifteen-entry table rather than a 420-entry one.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

H, INTER, NB = 1024, 2048, 28
PAGE = 256 * 1024

#            name         out    in    parent (as the manifest names it)
PROJS = (("q_proj",        H,  H,    "self_attn"),
         ("k_proj",        H,  H,    "self_attn"),
         ("v_proj",        H,  H,    "self_attn"),
         ("o_proj",        H,  H,    "self_attn"),
         ("gate_proj", INTER,  H,    "mlp"),
         ("up_proj",   INTER,  H,    "mlp"),
         ("down_proj",     H, INTER, "mlp"))

GAINS = ("in_norm", "post_norm", "q_norm", "k_norm",
         "o_proj.subln", "down_proj.subln")


def slots():
    """The fifteen pages of a block, in the order project() walks them.

    Output slice is the outer loop and depth segment the inner one, which
    is what block_full.py does: the accumulator holds one 1024-wide slice
    while the segments are summed into it.
    """
    out = []
    for name, o, i, _ in PROJS:
        for c in range(o // 1024):
            for s in range(i // 1024):
                out.append((name, c, s))
    return out


SLOTS = slots()


def pack_slice(W):
    """(1024 out, 1024 in) ternary -> the array's packed layout.

    addr = k*GROUPS + g with GROUPS = 256, four codes per byte LSB-first,
    00 = 0, 01 = +1, 10 = -1. Byte-for-byte what block_check.pack_slice
    produces; that one is what stage 9 verified on silicon.
    """
    o, i = W.shape
    assert o == 1024 and i == 1024, W.shape
    c = np.where(W.T == 1, 1, np.where(W.T == -1, 2, 0)).astype(np.uint8)
    c = c.reshape(i, o // 4, 4)
    return (c[:, :, 0] | (c[:, :, 1] << 2)
            | (c[:, :, 2] << 4) | (c[:, :, 3] << 6)).astype(np.uint8).tobytes()


def cross_check(z, export):
    """Prove the npz weights and the exported blobs are the same tensors.

    Only where out == 1024, because that is the only case the exporter's
    stride agrees with the array's. It is enough: the npz holds one array
    per projection, and if it matched the export for four of the seven it
    did not get the other three from somewhere else. Without this the image
    is trusted purely because it came out of a file with the right name.
    """
    from stage2_check import unpack
    man = json.load(open(os.path.join(export, "manifest.json")))
    n = 0
    for name, o, i, parent in PROJS:
        if o != 1024:
            continue
        for blk in (0, 13, 27):
            key = f"{blk}.{parent}.{name}"
            f = os.path.join(export, man["layers"][key]["file"])
            if not np.array_equal(unpack(f, o, i), z[f"{blk}.{name}.w"]):
                sys.exit(f"MISMATCH: {key} export != npz")
            n += 1
    print(f"  cross-check   {n} projections agree between export and npz")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--outdir", default=os.path.expanduser("~/tc-ddr"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--blocks", type=int, default=NB)
    a = ap.parse_args()

    os.makedirs(a.outdir, exist_ok=True)
    z = np.load(a.cache)
    print(f"{len(SLOTS)} pages per block, {a.blocks} blocks, "
          f"{len(SLOTS)*a.blocks*PAGE/1e6:.1f} MB\n")
    cross_check(z, a.export)

    t0, table, meta = time.time(), [], {}
    path = os.path.join(a.outdir, "weights.bin")
    with open(path, "wb") as f:
        for blk in range(a.blocks):
            W = {n: z[f"{blk}.{n}.w"] for n, _, _, _ in PROJS}
            for slot, (name, c, s) in enumerate(SLOTS):
                sub = W[name][c * 1024:(c + 1) * 1024,
                              s * 1024:(s + 1) * 1024]
                blob = pack_slice(sub)
                assert len(blob) == PAGE, len(blob)
                off = (blk * len(SLOTS) + slot) * PAGE
                assert f.tell() == off, (f.tell(), off)
                f.write(blob)
                table.append(dict(blk=blk, proj=name, out_slice=c, seg=s,
                                  slot=slot, off=off))
            for n, _, _, _ in PROJS:
                meta[f"{blk}.{n}.s"] = float(z[f"{blk}.{n}.s"])
            if blk % 7 == 0 or blk == a.blocks - 1:
                print(f"  block {blk:2d}/{a.blocks}  {f.tell()/1e6:6.1f} MB  "
                      f"{time.time()-t0:5.1f}s", flush=True)

    with open(os.path.join(a.outdir, "pages.json"), "w") as f:
        json.dump(dict(page_bytes=PAGE, slots_per_block=len(SLOTS),
                       n_blocks=a.blocks, n_pages=len(table),
                       index_rule="page = blk*slots_per_block + slot",
                       layout="addr=k*256+g, 4 codes/byte LSB-first, "
                              "00=0 01=+1 10=-1, 1024 out x 1024 in",
                       slot_order=[dict(proj=n, out_slice=c, seg=s)
                                   for n, c, s in SLOTS],
                       scales=meta, pages=table), f, indent=1)

    g = {f"{blk}.{k}": z[f"{blk}.{k}"] for blk in range(a.blocks) for k in GAINS}
    np.savez(os.path.join(a.outdir, "meta.npz"), **g)

    sz = os.path.getsize(path)
    print(f"\n  weights.bin   {sz/1e6:.1f} MB, {sz//PAGE} pages")
    print(f"  pages.json    {len(table)} entries")
    print(f"  meta.npz      {len(g)} gain vectors")
    print(f"  built in {time.time()-t0:.1f}s -> {a.outdir}")


if __name__ == "__main__":
    main()
