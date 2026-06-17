#!/usr/bin/env python3
"""
Quantization search — find optimal config for ternarycore BitNet pipeline.

Explores the full quantization space and finds Pareto-optimal configurations
(tradeoff between accuracy and memory). Reports the Pareto frontier.

Search dimensions:
  Q_WIDTH:          [2, 3, 4, 8]        — activation bit width
  act_method:       [absmax, p99, p95]  — clipping method
  weight_method:    [mean_abs, median_abs, mse_opt] — ternarization
  scale_fmt:        [Q15, FP8_E5M2, INT8] — scale format
  scale_gran:       [per_channel, per_tensor] — scale sharing
  act_gran:         [per_tensor, per_channel] — activation quantization granularity
"""

import math
import itertools
import torch
from transformers import AutoModel

MODEL_ID = "HuggingFaceTB/SmolVLM-256M-Instruct"
LAYER_IDX = 0

# ── Search space ──────────────────────────────────────────────────

SEARCH_SPACE = {
    "Q_WIDTH":       [2, 3, 4, 8],
    "act_method":    ["absmax", "p99", "p95"],
    "weight_method": ["mean_abs", "median_abs", "mse_opt"],
    "scale_fmt":     ["Q15", "FP8_E5M2", "INT8"],
    "scale_gran":    ["per_channel", "per_tensor"],
    "act_gran":      ["per_tensor", "per_channel"],
}

# ── Quantization methods ─────────────────────────────────────────

def quantize_acts(acts: torch.Tensor, q_width: int,
                  method: str = "absmax",
                  granularity: str = "per_tensor") -> torch.Tensor:
    """Quantize activations using various methods."""
    q_max = (1 << (q_width - 1)) - 1

    if granularity == "per_tensor":
        groups = [acts]
    else:
        groups = acts.unsqueeze(0)  # per-channel = per-element

    result = torch.zeros_like(acts, dtype=torch.float32)

    for group in groups:
        if method == "absmax":
            scale = group.abs().max().clamp(min=1)
        elif method.startswith("p"):
            pct = int(method[1:])
            scale = group.abs().quantile(pct / 100.0).clamp(min=1)
        else:
            scale = group.abs().max().clamp(min=1)

        # Software quantizer: q = round(clip(x * Q_MAX / scale, -Q_MAX, Q_MAX))
        inv = scale.item()  # absmax value
        q = torch.clamp(torch.round(group.float() * q_max / inv), -q_max, q_max)
        result = q.to(acts.dtype)

    return result


def ternarize_weights(w: torch.Tensor, method: str = "mean_abs"):
    """Ternarize weights using various strategies."""
    if method == "mean_abs":
        gamma = w.abs().mean(dim=1, keepdim=True).clamp(min=1e-8)
    elif method == "median_abs":
        gamma = w.abs().median(dim=1, keepdim=True).values.clamp(min=1e-8)
    elif method == "mse_opt":
        # Per-channel MSE-optimal threshold search
        flat = w.view(w.shape[0], -1)
        best_gamma = torch.zeros(w.shape[0], 1)
        for i in range(w.shape[0]):
            vals = flat[i].abs()
            best_mse = float('inf')
            best_t = vals.mean().item()
            # Sample thresholds around mean
            for mult in [0.5, 0.7, 1.0, 1.3, 1.5]:
                t = vals.mean().item() * mult
                if t < 1e-8: continue
                w_t = torch.clamp(torch.round(flat[i] / t), -1, 1)
                mse = ((flat[i].float() - w_t.float() * t) ** 2).mean().item()
                if mse < best_mse:
                    best_mse = mse
                    best_t = t
            best_gamma[i] = best_t
        gamma = best_gamma.clamp(min=1e-8)
    else:
        gamma = w.abs().mean(dim=1, keepdim=True).clamp(min=1e-8)

    w_t = torch.clamp(torch.round(w / gamma), -1, 1)
    alpha = gamma * math.sqrt(w.shape[1])
    return w_t, alpha.squeeze()


def encode_scale(alpha_val: float, fmt: str) -> float:
    """Encode a scale value into a format and decode back."""
    if fmt == "Q15":
        q15 = int(alpha_val * 32768)
        if q15 > 65535: q15 = 65535
        if q15 < 0: q15 = 0
        return q15 / 32768.0

    elif fmt == "FP8_E5M2":
        if abs(alpha_val) < 1e-10: return 0.0
        s = 0
        v = alpha_val
        if v < 0: s = 1; v = -v
        e = int(math.floor(math.log2(v))) if v > 0 else -14
        m = int(round((v / 2**e - 1) * 4)) if v > 0 else 0
        if e > 15: e = 15; m = 3
        if m > 3: m = 3; e += 1
        if e > 15: e = 15; m = 3
        if e < -14: e = 0; m = 0
        fp8 = (s << 7) | ((e + 15) << 2) | (m & 3)
        # Decode
        if fp8 == 0: return 0.0
        de = (fp8 >> 2) & 0x1F
        dm = fp8 & 0x3
        base = 32768 | (dm << 13)
        if de >= 15:
            q15 = base << (de - 15)
        elif de == 0:
            q15 = (dm << 13) >> 14
        else:
            q15 = base >> (15 - de)
        return min(q15, 65535) / 32768.0

    elif fmt == "INT8":
        i8 = int(round(alpha_val * 127))
        if i8 > 127: i8 = 127
        if i8 < 0: i8 = 0
        return i8 / 127.0

    return alpha_val


# ── Bits per param calculator ────────────────────────────────────

def bits_per_param(q_width: int, scale_fmt: str, scale_gran: str,
                   out_dim: int) -> float:
    """Calculate effective bits per parameter."""
    weight_bits = 2  # ternary {-1, 0, +1} = 2 bits
    act_bits = q_width

    # Scale bits (amortized over out_dim output channels)
    scale_bits = {"Q15": 16, "FP8_E5M2": 8, "INT8": 8}[scale_fmt]

    if scale_gran == "per_channel":
        # 1 scale per output channel
        scale_amortized = scale_bits / 1  # per output channel weight group
    else:
        scale_amortized = scale_bits / out_dim  # 1 scale shared across all

    return weight_bits + act_bits / 576 + scale_amortized


# ── Evaluation ───────────────────────────────────────────────────

def evaluate_config(model, acts, w, config: dict) -> dict:
    """Evaluate one quantization configuration."""
    qw = config["Q_WIDTH"]
    in_dim = w.shape[1]
    out_dim = w.shape[0]

    # Float reference
    float_ref = w.float() @ acts.float()

    # Quantize
    qa = quantize_acts(acts, qw, config["act_method"], config["act_gran"])
    w_t, alphas = ternarize_weights(w, config["weight_method"])

    # Dot product
    dot = qa.float() @ w_t.float().T

    # Scale
    if config["scale_gran"] == "per_channel":
        decoded_alphas = torch.tensor([encode_scale(a.item(), config["scale_fmt"])
                                       for a in alphas])
    else:
        avg_alpha = alphas.mean()
        decoded_alpha = encode_scale(avg_alpha.item(), config["scale_fmt"])
        decoded_alphas = torch.full_like(alphas, decoded_alpha)

    result = dot * decoded_alphas

    # Metrics
    cos = torch.nn.functional.cosine_similarity(
        float_ref.unsqueeze(0), result.unsqueeze(0)).item()
    bpp = bits_per_param(qw, config["scale_fmt"], config["scale_gran"], out_dim)

    return {"cos": cos, "bpp": bpp, **config}


# ── Pareto frontier ──────────────────────────────────────────────

def pareto_frontier(results):
    """Find Pareto-optimal configs (minimize bpp, maximize cos)."""
    pareto = []
    for r in results:
        dominated = False
        for o in results:
            if (o["bpp"] <= r["bpp"] and o["cos"] >= r["cos"] and
                (o["bpp"] < r["bpp"] or o["cos"] > r["cos"])):
                dominated = True
                break
        if not dominated:
            pareto.append(r)
    return sorted(pareto, key=lambda x: x["bpp"])


# ── Main ─────────────────────────────────────────────────────────

def main():
    print(f"Loading {MODEL_ID}...")
    model = AutoModel.from_pretrained(MODEL_ID, dtype=torch.float32)
    model.eval()

    w = model.text_model.layers[LAYER_IDX].mlp.gate_proj.weight.data
    torch.manual_seed(42)
    acts = torch.randint(-50, 51, (w.shape[1],), dtype=torch.int8)

    keys = list(SEARCH_SPACE.keys())
    values = list(SEARCH_SPACE.values())
    total = 1
    for v in values: total *= len(v)
    print(f"Search space: {total} configurations")

    results = []
    for i, combo in enumerate(itertools.product(*values)):
        config = dict(zip(keys, combo))
        r = evaluate_config(model, acts, w, config)
        results.append(r)

        if (i + 1) % 100 == 0:
            print(f"  {i+1}/{total} evaluated...")

    # Pareto frontier
    pareto = pareto_frontier(results)

    print(f"\n─── Pareto frontier ({len(pareto)} optimal configs) ───")
    print(f"{'BPP':>6} {'Cos':>6} {'Qw':>3} {'Act':>10} {'Wt':>12} {'Scale':>12} {'S.gran':>12} {'A.gran':>12}")
    print("-" * 75)
    for r in pareto:
        print(f"{r['bpp']:6.1f} {r['cos']:6.4f} {r['Q_WIDTH']:3d} "
              f"{r['act_method']:>10} {r['weight_method']:>12} "
              f"{r['scale_fmt']:>12} {r['scale_gran']:>12} {r['act_gran']:>12}")

    print(f"\n─── Best per Q_WIDTH ───")
    for qw in [2, 3, 4, 8]:
        best = max([r for r in pareto if r["Q_WIDTH"] == qw] or [],
                   key=lambda x: x["cos"], default=None)
        if best:
            print(f"  Q{qw}: cos={best['cos']:.4f} bpp={best['bpp']:.1f} "
                  f"act={best['act_method']} wt={best['weight_method']} "
                  f"scale={best['scale_fmt']}")

    # Best overall
    best_high = max(pareto, key=lambda x: x["cos"])
    best_eff = max(pareto, key=lambda x: x["cos"] / x["bpp"])
    print(f"\nBest accuracy:  Q{best_high['Q_WIDTH']} cos={best_high['cos']:.4f} bpp={best_high['bpp']:.1f}")
    print(f"Best efficiency: Q{best_eff['Q_WIDTH']} cos={best_eff['cos']:.4f} bpp={best_eff['bpp']:.1f}")


if __name__ == "__main__":
    main()