#!/usr/bin/env python3
"""Find hardware-friendly int8 activation scales from calibration data.

For every channel (or group of channels), choose a clipping threshold from a
small percentile grid and minimize mean-square error after symmetric int8
quantization.  The output JSON is intentionally model-independent so it can
be consumed by firmware/image builders without importing PyTorch.

Input is an ``.npy`` array shaped ``[..., channels]`` or an ``.npz`` with
``--key``.  The last dimension is calibrated independently.
"""
import argparse
import json

import numpy as np


def calibrate(x, group_size=1, percentiles=(99.0, 99.5, 99.9, 99.99, 100.0)):
    x = np.asarray(x, dtype=np.float32)
    if x.ndim < 2:
        raise ValueError("calibration data must have at least two dimensions")
    channels = x.shape[-1]
    if channels % group_size:
        raise ValueError("last dimension must be divisible by group_size")
    flat = x.reshape(-1, channels)
    groups = flat.reshape(flat.shape[0], channels // group_size, group_size)
    scales = np.empty(groups.shape[1], dtype=np.float32)
    errors = np.empty_like(scales)
    chosen = np.empty_like(scales)
    for g in range(groups.shape[1]):
        values = groups[:, g, :].reshape(-1)
        candidates = np.percentile(np.abs(values), percentiles)
        candidates = np.unique(np.maximum(candidates, 1e-8))
        best = None
        for clip in candidates:
            q = np.clip(np.rint(values / clip * 127), -127, 127)
            recon = q * (clip / 127)
            mse = float(np.mean((recon - values) ** 2))
            if best is None or mse < best[0]:
                best = mse, float(clip)
        errors[g], chosen[g] = best
        scales[g] = chosen[g] / 127
    return dict(channels=channels, group_size=group_size,
                scales=scales.tolist(), clip_max=chosen.tolist(),
                mse=errors.tolist(), percentile_grid=list(percentiles))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("input")
    ap.add_argument("output")
    ap.add_argument("--key", default="activations")
    ap.add_argument("--group-size", type=int, default=1)
    args = ap.parse_args()
    loaded = np.load(args.input)
    x = loaded[args.key] if isinstance(loaded, np.lib.npyio.NpzFile) else loaded
    result = calibrate(x, args.group_size)
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2)
        f.write("\n")
    print(f"wrote {args.output}: {result['channels']} channels, "
          f"{len(result['scales'])} groups")


if __name__ == "__main__":
    main()
