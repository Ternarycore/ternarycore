#!/usr/bin/env python3
"""
Full SmolVLM BitNet: ternarize vision encoder + connector + text decoder + INT4 embedding.

Converts all layers to low-precision:
  - Linear: ternary {-1,0,+1} with per-channel alpha (BitNet b1.58)
  - Conv2d:  ternary {-1,0,+1} with per-channel alpha (for vision patch embed)
  - Embedding: INT4 symmetric (range [-7,+7]) or FP4 E2M1
  - LayerNorm/Bias: FP32 (negligible params)

Usage:
  uv run python tools/bitnet_full.py                    # convert and profile
  uv run python tools/bitnet_full.py --train             # train on image captioning
  uv run python tools/bitnet_full.py --eval --image test.jpg
"""
import argparse, math, torch, torch.nn as nn
import torch.nn.functional as F
from transformers import AutoModel, AutoProcessor

MODEL_ID = "HuggingFaceTB/SmolVLM-256M-Instruct"

# ── BitNet modules ───────────────────────────────────────────────

class BitNetLinear(nn.Module):
    """Linear with ternary weights + STE."""
    def __init__(self, in_f, out_f, bias=True):
        super().__init__()
        self.weight = nn.Parameter(torch.empty(out_f, in_f))
        self.gamma = nn.Parameter(torch.ones(out_f))
        self.bias = nn.Parameter(torch.zeros(out_f)) if bias else None
        nn.init.kaiming_uniform_(self.weight, a=math.sqrt(5))
        self.gamma.data = self.weight.abs().mean(dim=1).clamp(min=1e-8)

    def ternarize(self):
        g = self.weight.abs().mean(dim=1, keepdim=True).clamp(min=1e-8)
        wt = torch.clamp(torch.round(self.weight / g), -1, 1)
        return self.weight + (wt - self.weight).detach()

    def forward(self, x):
        wt = self.ternarize()
        alpha = self.gamma.unsqueeze(1) * math.sqrt(self.weight.shape[1])
        return F.linear(x, wt * alpha, self.bias)


class BitNetConv2d(nn.Module):
    """Conv2d with ternary weights + STE."""
    def __init__(self, in_ch, out_ch, kernel_size, stride=1, padding=0, bias=True):
        super().__init__()
        self.kernel_size = kernel_size if isinstance(kernel_size, tuple) else (kernel_size, kernel_size)
        self.stride = stride; self.padding = padding
        self.weight = nn.Parameter(torch.empty(out_ch, in_ch, *self.kernel_size))
        self.gamma = nn.Parameter(torch.ones(out_ch))
        self.bias = nn.Parameter(torch.zeros(out_ch)) if bias else None
        nn.init.kaiming_uniform_(self.weight, a=math.sqrt(5))
        self.gamma.data = self.weight.abs().mean(dim=(1,2,3), keepdim=True).clamp(min=1e-8).squeeze()

    def ternarize(self):
        g = self.weight.abs().mean(dim=(1,2,3), keepdim=True).clamp(min=1e-8)
        wt = torch.clamp(torch.round(self.weight / g), -1, 1)
        return self.weight + (wt - self.weight).detach()

    def forward(self, x):
        wt = self.ternarize()
        alpha = self.gamma.view(-1,1,1,1) * math.sqrt(self.weight.shape[1] * self.weight.shape[2] * self.weight.shape[3])
        return F.conv2d(x, wt * alpha, self.bias, self.stride, self.padding)


class BitNetEmbedding(nn.Module):
    """Embedding with INT4 or FP4 quantization.
    
    INT4: symmetric, range [-7, +7], scale = max(|w|) / 7 per row
    FP4:  E2M1 format (1s, 2e bias=1, 1m), range [-6, +6]
    """
    def __init__(self, num_embeddings, embedding_dim, qfmt="int4"):
        super().__init__()
        self.num_embeddings = num_embeddings
        self.embedding_dim = embedding_dim
        self.qfmt = qfmt
        self.weight = nn.Parameter(torch.empty(num_embeddings, embedding_dim))
        nn.init.normal_(self.weight, std=0.02)

    def quantize_int4(self):
        scale = self.weight.abs().max(dim=1, keepdim=True).values.clamp(min=1e-8) / 7
        q = torch.clamp(torch.round(self.weight / scale), -7, 7)
        return self.weight + (q * scale - self.weight).detach()

    def quantize_fp4(self, w=None):
        """FP4 E2M1: sign(1), exp(2,bias=1), mant(1) → value = (-1)^s * 2^(e-1) * (1 + m/2)"""
        if w is None: w = self.weight
        sgn = w.sign(); aw = w.abs() + 1e-10
        # Manual FP4 encode: find closest FP4 value
        fp4_vals = torch.tensor([0, 0.5, 1, 1.5, 2, 3, 4, 6,
                                 -0, -0.5, -1, -1.5, -2, -3, -4, -6])
        # Find closest for each element
        q = torch.zeros_like(aw)
        for fv in fp4_vals[fp4_vals >= 0]:
            mask = (aw - fv).abs() < (aw - q).abs()
            q[mask] = fv
        q = q * sgn
        return self.weight + (q - self.weight).detach()

    def forward(self, x):
        if self.qfmt == "int4":
            wq = self.quantize_int4()
        else:
            wq = self.quantize_fp4()
        return F.embedding(x, wq)


# ── Model conversion ─────────────────────────────────────────────

def convert_module(module, qfmt="int4", prefix=""):
    """Recursively convert nn.Linear, nn.Conv2d, nn.Embedding to BitNet versions."""
    for name, child in list(module.named_children()):
        full_name = f"{prefix}.{name}" if prefix else name
        new_child = None

        if isinstance(child, nn.Linear):
            bn = BitNetLinear(child.in_features, child.out_features, child.bias is not None)
            with torch.no_grad():
                bn.weight.copy_(child.weight)
                if child.bias is not None: bn.bias.copy_(child.bias)
            new_child = bn

        elif isinstance(child, nn.Conv2d):
            bn = BitNetConv2d(child.in_channels, child.out_channels, child.kernel_size,
                              child.stride, child.padding, child.bias is not None)
            with torch.no_grad():
                bn.weight.copy_(child.weight)
                if child.bias is not None: bn.bias.copy_(child.bias)
            new_child = bn

        elif isinstance(child, nn.Embedding):
            be = BitNetEmbedding(child.num_embeddings, child.embedding_dim, qfmt)
            with torch.no_grad():
                be.weight.copy_(child.weight)
            new_child = be

        if new_child is not None:
            setattr(module, name, new_child)
            print(f"  Converted {full_name}: {type(child).__name__} → {type(new_child).__name__}")
        else:
            convert_module(child, qfmt, full_name)

    return module


def build_full_bitnet_vlm(qfmt="int4"):
    """Load SmolVLM and convert all components to BitNet."""
    print(f"Loading {MODEL_ID}...")
    model = AutoModel.from_pretrained(MODEL_ID, dtype=torch.float32)
    model.eval()

    print("\nConverting vision encoder...")
    convert_module(model.vision_model, qfmt, "vision")

    print("\nConverting connector...")
    convert_module(model.connector, qfmt, "connector")

    print("\nConverting text decoder...")
    convert_module(model.text_model, qfmt, "text")

    # Total params
    def count(prefix, mod):
        total = sum(p.numel() for p in mod.parameters())
        bitnet = sum(p.numel() for p in mod.parameters()
                     if hasattr(p, 'requires_grad') and p.requires_grad)
        print(f"  {prefix}: {total/1e6:.1f}M params")
        return total

    print("\n─── Parameter summary ───")
    total = 0
    for name, mod in [("vision", model.vision_model), ("connector", model.connector),
                       ("text", model.text_model)]:
        total += count(name, mod)
    print(f"  Total: {total/1e6:.1f}M")

    # Memory estimate
    vis_p = sum(p.numel() for p in model.vision_model.parameters()) * 2  # FP16
    conn_p = sum(p.numel() for p in model.connector.parameters()) * 2     # FP16
    def _sum(mod, cls, bits):
        t = 0
        for _, m in mod.named_modules():
            if isinstance(m, cls):
                for pp in m.parameters(): t += pp.numel() * bits // 8
        return t
    txt_p = _sum(model.text_model, BitNetLinear, 2)
    txt_fp = sum(pp.numel() for pp in model.text_model.parameters()) * 4 - txt_p * 4
    embed_p = _sum(model, BitNetEmbedding, 4)

    total_mb = (vis_p + conn_p + txt_p + txt_fp + embed_p) / 1024 / 1024
    print(f"  Est memory: {total_mb:.0f}MB (vs {total*4/1024/1024:.0f}MB FP32)")

    return model


# ── CLI ──────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--qfmt", default="int4", choices=["int4", "fp4"])
    parser.add_argument("--profile", action="store_true", default=True)
    parser.add_argument("--train", action="store_true")
    parser.add_argument("--epochs", type=int, default=3)
    args = parser.parse_args()

    model = build_full_bitnet_vlm(args.qfmt)

    if args.train:
        print("\nTraining not yet implemented for full VLM.")
        print("Use tools/train_bitnet.py for text-decoder-only training.")

    # Quick sanity check: verify everything is BitNet
    n_bitnet = sum(1 for _, m in model.named_modules() if isinstance(m, (BitNetLinear, BitNetConv2d, BitNetEmbedding)))
    print(f"\nBitNet modules: {n_bitnet}")
    print(f"Ready for training: uv run python tools/train_bitnet.py --full-model")


if __name__ == "__main__":
    main()