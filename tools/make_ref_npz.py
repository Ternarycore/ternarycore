#!/usr/bin/env python3
"""make_ref_npz.py -- a trained student, in the form the image builder wants.

    python tools/make_ref_npz.py --state ~/tc-run/distil/last.pt \\
        --out ~/tc-ckpt/tc-ref-d4.npz

build_ddr_image.py reads one npz holding, per block, the ternary weights,
their absmean scales, and the six gains that stay float. That npz was
produced for the SST-2 student by a path that no longer applies, so this
rebuilds it straight from a D4 checkpoint.

The quantiser is the same three lines as export_checkpoint.py and
bitnet_surgery.BitLinear -- s = mean(|W|), clip(round(W/s), -1, 1) -- and
that is the point. Three places in this repo round the same weights and
they have to agree exactly, or the model that was trained is not the model
that gets packed. build_ddr_image cross-checks this npz against the
exporter's blobs for every projection whose output is 1024 wide, which at
this shape is five of the seven.

The six gains are the ones the datapath carries:

    in_norm, post_norm, q_norm, k_norm, o_proj.subln, down_proj.subln

and the last two exist only because D2's SubLN surgery put them there.
They are read from `<proj>.0.weight`, the norm half of the Sequential
that bitnet_surgery builds, while the matrix comes from `.1.weight`.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os

import numpy as np
import torch

#  (npz name, state-dict suffix). o_proj and down_proj carry a SubLN, so
#  their matrix is the .1 of a Sequential; the other five are plain.
PROJ = (("q_proj", "self_attn.q_proj.weight"),
        ("k_proj", "self_attn.k_proj.weight"),
        ("v_proj", "self_attn.v_proj.weight"),
        ("o_proj", "self_attn.o_proj.1.weight"),
        ("gate_proj", "mlp.gate_proj.weight"),
        ("up_proj", "mlp.up_proj.weight"),
        ("down_proj", "mlp.down_proj.1.weight"))

GAIN = (("in_norm", "input_layernorm.weight"),
        ("post_norm", "post_attention_layernorm.weight"),
        ("q_norm", "self_attn.q_norm.weight"),
        ("k_norm", "self_attn.k_norm.weight"),
        ("o_proj.subln", "self_attn.o_proj.0.weight"),
        ("down_proj.subln", "mlp.down_proj.0.weight"))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--state", default=os.path.expanduser("~/tc-run/distil/last.pt"))
    ap.add_argument("--out", default=os.path.expanduser("~/tc-ckpt/tc-ref-d4.npz"))
    ap.add_argument("--blocks", type=int, default=28)
    a = ap.parse_args()

    sd = torch.load(a.state, map_location="cpu", weights_only=False)
    sd = sd.get("model", sd)

    z, zf = {}, []
    for blk in range(a.blocks):
        p = f"model.layers.{blk}."
        for name, suffix in PROJ:
            w = sd[p + suffix].float().numpy()
            s = float(np.abs(w).mean()) or 1e-8
            t = np.clip(np.round(w / s), -1, 1).astype(np.int8)
            z[f"{blk}.{name}.w"] = t
            z[f"{blk}.{name}.s"] = np.float32(s)
            zf.append(float((t == 0).mean()))
        for name, suffix in GAIN:
            z[f"{blk}.{name}"] = sd[p + suffix].float().numpy()

    np.savez(a.out, **z)
    n = sum(v.size for k, v in z.items() if k.count(".") == 1)
    print(f"  {a.blocks} blocks, {len(PROJ)} projections each")
    print(f"  {n/1e6:.1f} M ternary weights, {n/4/1e6:.1f} MB once packed")
    print(f"  zero fraction  min {min(zf):.3f}  mean {sum(zf)/len(zf):.3f}"
          f"  max {max(zf):.3f}")
    print(f"  wrote {a.out}  ({os.path.getsize(a.out)/1e6:.1f} MB)")
    print(f"\n  next: python tools/build_ddr_image.py --cache {a.out} \\")
    print(f"          --export ~/tc-export-d4 -o ~/tc-ddr-d4")


if __name__ == "__main__":
    main()
