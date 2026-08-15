#!/usr/bin/env python3
"""Convert 2B4T/BitNet checkpoints into TernaryCore packed layer artifacts.

The importer deliberately keeps checkpoint loading separate from hardware
layout conversion.  It accepts a NumPy ``.npz`` for reproducible/offline
use, and optionally Hugging Face ``.safetensors`` files when the optional
``safetensors`` package is installed.  Two-bit encoding is 00=0, 01=+1,
10=-1, four output weights per byte, matching ``weight_bram128``.
"""
import argparse
import json
import os

import numpy as np


def ternarize(weight):
    weight = np.asarray(weight, dtype=np.float32)
    if weight.ndim != 2:
        raise ValueError("only rank-2 projection tensors can be imported")
    vals = np.unique(weight)
    if np.all(np.isin(vals, (-1.0, 0.0, 1.0))):
        scale = 1.0
        tern = weight.astype(np.int8)
    else:
        scale = float(np.mean(np.abs(weight))) or 1e-8
        tern = np.clip(np.rint(weight / scale), -1, 1).astype(np.int8)
    return tern, scale


def pack(weight):
    tern, scale = ternarize(weight)
    out_dim, depth = tern.shape
    pad = (-out_dim) % 4
    t = tern.T
    if pad:
        t = np.pad(t, ((0, 0), (0, pad)))
    codes = np.where(t == 1, 1, np.where(t == -1, 2, 0)).astype(np.uint8)
    p = (codes.reshape(depth, -1, 4) *
         np.array([1, 4, 16, 64], dtype=np.uint8)).sum(axis=2)
    return p, scale, float(np.mean(tern == 0))


def load(path):
    if path.endswith(".npz"):
        data = np.load(path)
        return {k: data[k] for k in data.files if data[k].ndim == 2}
    try:
        from safetensors import safe_open
    except ImportError as e:
        raise SystemExit("install safetensors to import .safetensors files") from e
    with safe_open(path, framework="numpy") as f:
        return {k: f.get_tensor(k) for k in f.keys()
                if len(f.get_slice(k).get_shape()) == 2}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("checkpoint")
    ap.add_argument("outdir")
    ap.add_argument("--limit", type=int, default=0,
                    help="import at most this many tensors (0 = all)")
    args = ap.parse_args()
    tensors = load(args.checkpoint)
    os.makedirs(os.path.join(args.outdir, "layers"), exist_ok=True)
    manifest = {"format": "ternarycore-2b4t-v1", "layout":
                "addr=k*ceil(out/4)+g, 00=0 01=+1 10=-1",
                "source": os.path.basename(args.checkpoint), "layers": {}}
    for i, (name, weight) in enumerate(sorted(tensors.items())):
        if args.limit and i >= args.limit:
            break
        packed, scale, zero_frac = pack(weight)
        safe_name = name.replace("/", "_").replace(".", "_") + ".bin"
        path = os.path.join(args.outdir, "layers", safe_name)
        packed.tofile(path)
        manifest["layers"][name] = {"shape": list(weight.shape), "scale": scale,
                                     "zero_frac": zero_frac,
                                     "packed_bytes": int(packed.nbytes),
                                     "file": os.path.relpath(path, args.outdir)}
    manifest["n_layers"] = len(manifest["layers"])
    manifest["packed_total_bytes"] = sum(x["packed_bytes"]
                                         for x in manifest["layers"].values())
    with open(os.path.join(args.outdir, "manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)
        f.write("\n")
    print(f"imported {manifest['n_layers']} layers, "
          f"{manifest['packed_total_bytes'] / 1e6:.2f} MB packed")


if __name__ == "__main__":
    main()
