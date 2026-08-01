#!/usr/bin/env python3
"""D5 export: trained ternary student checkpoint -> packed LOADM artifacts.

For every BitLinear projection in the SubLN student: absmean-snap the shadow
weights to {-1,0,+1}, record the per-layer scale, and pack 2-bit codes
(00=0, 01=+1, 10=-1) four-per-byte along the output dimension — the same
layout prep_bitnet_layer.py proved on Arty silicon at 768 dims, generalized
to arbitrary [out,in].

Usage: python export_checkpoint.py <state_dict.pt> <outdir>
Emits: layers/<name>.bin, manifest.json (shapes, scales, zero-fractions,
packed layout addr = k*GROUPS + g with k over in-dim), reference.npz.
"""
import json, os, sys
import numpy as np
import torch

sd_path, outdir = sys.argv[1], sys.argv[2]
os.makedirs(os.path.join(outdir, "layers"), exist_ok=True)
sd = torch.load(sd_path, map_location="cpu")

PROJ_KEYS = ("q_proj", "k_proj", "v_proj", "o_proj",
             "gate_proj", "up_proj", "down_proj")


def pack(tern):  # tern: [out, in] int8 in {-1,0,1}
    codes = np.where(tern == 0, 0, np.where(tern == 1, 1, 2)).astype(np.uint8)
    t = codes.T                      # [in, out] — k rows over depth
    out_dim = t.shape[1]
    pad = (-out_dim) % 4
    if pad:
        t = np.concatenate([t, np.zeros((t.shape[0], pad), np.uint8)], 1)
    g = t.reshape(t.shape[0], -1, 4)
    return (g[:, :, 0] | (g[:, :, 1] << 2) |
            (g[:, :, 2] << 4) | (g[:, :, 3] << 6)).astype(np.uint8)


manifest, ref, total = {}, {}, 0
for key, w in sd.items():
    if not key.endswith(".weight"):
        continue
    base = key.rsplit(".", 2)[0] if key.endswith((".0.weight", ".1.weight")) else key[:-7]
    name = base.split("model.layers.")[-1] if "model.layers." in key else None
    if key.endswith(".0.weight"):
        continue  # SubLN norm weights stay FP (activation domain)
    if not any(pk in key for pk in PROJ_KEYS):
        continue
    W = w.float().numpy()
    s = float(np.abs(W).mean()) or 1e-8
    tern = np.clip(np.round(W / s), -1, 1).astype(np.int8)
    packed = pack(tern)
    fname = name.replace(".", "_") + ".bin"
    packed.tofile(os.path.join(outdir, "layers", fname))
    manifest[name] = dict(shape=list(W.shape), scale=s, file=f"layers/{fname}",
                          zero_frac=round(float((tern == 0).mean()), 4),
                          packed_bytes=int(packed.nbytes))
    ref[name] = tern
    total += packed.nbytes

with open(os.path.join(outdir, "manifest.json"), "w") as f:
    json.dump(dict(source=os.path.basename(sd_path), layout="addr=k*GROUPS+g, "
                   "4 codes/byte LSB-first, codes 00=0 01=+1 10=-1",
                   n_layers=len(manifest), packed_total_bytes=total,
                   layers=manifest), f, indent=1)
np.savez_compressed(os.path.join(outdir, "reference.npz"), **ref)
zs = [m["zero_frac"] for m in manifest.values()]
print(f"[export] {len(manifest)} projections, {total/1e6:.1f} MB packed, "
      f"zero-frac min/mean/max {min(zs):.3f}/{sum(zs)/len(zs):.3f}/{max(zs):.3f}")
print(f"[export] wrote {outdir}/manifest.json + layers/ + reference.npz")
""""""
