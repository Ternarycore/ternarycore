#!/usr/bin/env python3
"""
SmolVLM-256M → ternarycore weight converter.

Downloads SmolVLM-256M-Instruct, extracts linear layer weights,
applies BitNet b1.58 ternary quantization, packs into 2-bit format,
and generates test vectors for the ternarycore pipeline.

Usage:
  python3 convert_smolvlm.py                          # download + quantize + testbench
  python3 convert_smolvlm.py --weights-only            # just dump quantized weights
  python3 convert_smolvlm.py --no-download             # use cached model only
"""

import argparse
import json
import math
import os
import sys
from pathlib import Path

import torch
import torch.nn as nn
import onnx

# ── Config ────────────────────────────────────────────────────────
MODEL_ID = "HuggingFaceTB/SmolVLM-256M-Instruct"
TERNARYCORE_COLS = 4        # parallel dot units
TERNARYCORE_DEPTH = 4      # vector length per dot

# ── BitNet ternary quantization ────────────────────────────────────

def ternarize_weights(w: torch.Tensor) -> tuple[torch.Tensor, torch.Tensor]:
    """
    BitNet b1.58 ternary quantization:
      gamma = mean(|w|) per output channel
      w_hat = clamp(round(w / gamma), -1, +1)  (ste_round)
      alpha = gamma * sqrt(in_features)         # scale for matmul correctness

    Returns (w_ternary, alpha_scale)
    w_ternary: {-1, 0, +1} tensor
    alpha_scale: per-output-channel float scale
    """
    orig_shape = w.shape
    # Flatten to per-channel: weight is [out_features, in_features]
    if w.dim() == 2:
        out_dim, in_dim = w.shape
        flat = w
    elif w.dim() == 4:
        # Conv2D: [out, in, kH, kW] → view as [out, in*kH*kW]
        out_dim = w.shape[0]
        flat = w.view(out_dim, -1)
    else:
        return w, torch.ones(1)

    gamma = flat.abs().mean(dim=1, keepdim=True)  # per-channel
    gamma = gamma.clamp(min=1e-8)

    w_scaled = flat / gamma
    w_ternary = torch.clamp(torch.round(w_scaled), -1, 1)

    alpha = gamma * math.sqrt(flat.shape[1])
    return w_ternary.reshape(orig_shape), alpha.squeeze()


def pack_ternary_chunk(weights: list[int]) -> int:
    """Pack 4 ternary values into an 8-bit weight_enc word.
       Encoding: 00=0, 01=+1, 10=-1
       col order: col0=bits[1:0], col1=bits[3:2], etc."""
    packed = 0
    for i, w in enumerate(weights[:4]):
        enc = {0: 0, 1: 1, -1: 2}.get(int(w), 0)
        packed |= enc << (2 * i)
    return packed


# ── Model loading ─────────────────────────────────────────────────

def load_smolvlm(device: str = "cpu") -> tuple:
    """Load SmolVLM-256M-Instruct. Returns (model, processor)."""
    from transformers import AutoModel, AutoProcessor

    print(f"Loading {MODEL_ID} on {device}...")
    model = AutoModel.from_pretrained(
        MODEL_ID, torch_dtype=torch.float32, device_map=device
    )
    processor = AutoProcessor.from_pretrained(MODEL_ID)
    model.eval()
    return model, processor


# ── Weight extraction ─────────────────────────────────────────────

def extract_linear_weights(model, verbose: bool = True) -> list[dict]:
    """
    Walk the model, extract all nn.Linear weights.
    Returns list of {name, shape, weight, bias, alpha, w_ternary}.
    """
    layers = []
    for name, module in model.named_modules():
        if isinstance(module, nn.Linear):
            w = module.weight.data.cpu()
            tern, alpha = ternarize_weights(w)

            layers.append({
                "name": name,
                "shape": list(w.shape),
                "weight": w,
                "bias": module.bias.data.cpu() if module.bias is not None else None,
                "w_ternary": tern,
                "alpha": alpha,
            })

            if verbose:
                n_tern = (tern != 0).sum().item()
                total = tern.numel()
                shape_str = str(list(w.shape))
            print(f"  {name:60s} {shape_str:20s}  "
                      f"ternary={n_tern/total:.1%}  α={alpha[:3].tolist()}...")

    return layers


# ── Test vector generation ────────────────────────────────────────

def generate_test_vectors(layers: list[dict], depth: int = 4, cols: int = 4) -> list[dict]:
    """Generate test vectors for ternarycore pipeline from real weights."""
    tests = []
    for layer in layers:
        w = layer["w_ternary"]
        if w.dim() != 2:
            continue
        out_dim, in_dim = w.shape

        # Take first depth x cols block of weights
        if in_dim < depth or out_dim < cols:
            continue

        w_block = w[:cols, :depth]  # [cols, depth]

        # Generate random int8 activations
        acts = torch.randint(-50, 51, (depth,), dtype=torch.int8).tolist()

        # Compute expected: each col = sum(act * weight) over depth
        expected = []
        for c in range(cols):
            dot = sum(acts[k] * int(w_block[c, k]) for k in range(depth))
            expected.append(dot)

        # Pack weights into weight_enc format
        w_per_row = []
        for k in range(depth):
            col_weights = [int(w_block[c, k]) for c in range(cols)]
            w_per_row.append(pack_ternary_chunk(col_weights))

        tests.append({
            "name": layer["name"],
            "activations": acts,
            "weights_packed": w_per_row,
            "expected": expected,
            "alphas": layer["alpha"][:cols].tolist(),
        })

    return tests


# ── CLI ───────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="SmolVLM → ternarycore converter")
    parser.add_argument("--weights-only", action="store_true",
                        help="Only dump quantized weights, no testbench")
    parser.add_argument("--no-download", action="store_true",
                        help="Use cached model, don't download")
    parser.add_argument("--output-dir", "-o", type=Path, default=Path("smolvlm_out"),
                        help="Output directory")
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)

    # Load
    model, processor = load_smolvlm()

    # Extract + ternary-quantize
    print("\nExtracting linear layers and applying BitNet ternary quantization...")
    layers = extract_linear_weights(model)

    # Dump weight stats
    stats = []
    for l in layers:
        stats.append({
            "name": l["name"],
            "shape": l["shape"],
            "ternary_density": float((l["w_ternary"] != 0).sum() / l["w_ternary"].numel()),
            "alpha_min": float(l["alpha"].min()),
            "alpha_max": float(l["alpha"].max()),
        })

    stats_path = args.output_dir / "weight_stats.json"
    with open(stats_path, "w") as f:
        json.dump(stats, f, indent=2)
    print(f"\nWeight stats → {stats_path}")

    if args.weights_only:
        return

    # Generate test vectors
    print("\nGenerating ternarycore test vectors...")
    tests = generate_test_vectors(layers)

    tb_path = args.output_dir / "tb_smolvlm.v"
    with open(tb_path, "w") as f:
        f.write("// Auto-generated from SmolVLM-256M weights\n")
        f.write("// Usage: cd sim && iverilog -g2012 -o tb_smolvlm \\\n")
        f.write("//   ../rtl/activation_quant.v ../rtl/ternary_dot.v \\\n")
        f.write("//   ../rtl/ternary_gemm.v ../rtl/ternary_scale.v \\\n")
        f.write("//   ../rtl/ternary_pipeline.v tb_smolvlm.v && vvp tb_smolvlm\n\n")

    json_path = args.output_dir / "test_vectors.json"
    with open(json_path, "w") as f:
        json.dump(tests, f, indent=2, default=str)

    print(f"  Test vectors  → {json_path}  ({len(tests)} layers)")
    print(f"  Verilog TB    → {tb_path}")
    print(f"\nTotal linear layers quantized: {len(layers)}")
    print(f"Total parameters: {sum(l['w_ternary'].numel() for l in layers):,}")
    print(f"  of which ternary: {sum((l['w_ternary'] != 0).sum().item() for l in layers):,}")


if __name__ == "__main__":
    main()