#!/usr/bin/env python3
"""
Benchmark: SmolVLM-256M through ternarycore pipeline with multiple configs.

Configurations:
  INT8  (Q_WIDTH=8):  default, clip [-127,127], Q15 alpha scales
  INT4  (Q_WIDTH=4):  2× density, clip [-7,+7], Q15 alpha scales
  INT4+FP8:           INT4 activations + FP8 E5M2 alpha scales

Metrics per config:
  - Cosine similarity vs float reference
  - Mean squared error (MSE)
  - Memory: weight storage (bits per param)
  - Cycle estimate for pipeline: VECTOR_LEN=576 (SmolVLM hidden dim)
"""

import math
import time
import torch
from transformers import AutoModel

MODEL_ID = "HuggingFaceTB/SmolVLM-256M-Instruct"
LAYERS_TO_TEST = 3   # first N layers

# ── BitNet ternary quantization ───────────────────────────────────

def ternarize(w: torch.Tensor):
    """Return (w_ternary, alpha) per BitNet b1.58."""
    gamma = w.abs().mean(dim=1, keepdim=True).clamp(min=1e-8)
    w_t = torch.clamp(torch.round(w / gamma), -1, 1)
    alpha = gamma * math.sqrt(w.shape[1])
    return w_t, alpha.squeeze()

# ── Activation quantization ───────────────────────────────────────

def quantize_acts(acts: torch.Tensor, q_width: int) -> torch.Tensor:
    """Simulate activation_quant in software."""
    q_max = (1 << (q_width - 1)) - 1
    absmax = acts.abs().max().clamp(min=1)
    inv = round(2**15 * q_max / absmax.item())
    return torch.clamp(torch.round(acts.float() * inv / 2**15),
                       -q_max, q_max).to(acts.dtype)

# ── FP8 encoding ──────────────────────────────────────────────────

def fp8_encode(value: float) -> int:
    """Encode a float to FP8 E5M2."""
    if value == 0:
        return 0
    sign = 0
    if value < 0:
        sign = 1
        value = -value
    exp = int(math.floor(math.log2(value)))
    mant = int(round((value / 2**exp - 1) * 4))  # 2 mantissa bits
    # Clamp
    if exp > 15: exp = 15; mant = 3
    if exp < -14: exp = 0; mant = 0
    if mant > 3: mant = 3; exp += 1
    if exp < 0:
        # Subnormal
        exp = 0
        mant = int(round(value / 2**-14 * 4))
    return (sign << 7) | ((exp + 15) << 2) | mant

def alphas_to_fp8(alphas: torch.Tensor) -> torch.Tensor:
    """Convert alpha scales to FP8 E5M2 and decode back for comparison."""
    fp8_vals = []
    for a in alphas:
        # Alpha is a scale factor, encode in Q15 units
        q15_val = int(a.item() * 32768)
        # Convert to float
        float_val = q15_val / 32768.0
        fp8_vals.append(fp8_encode(float_val))
    return torch.tensor(fp8_vals)

def fp8_decode(fp8_val: int) -> float:
    """Decode FP8 E5M2 to float (software model of fp8_to_q15)."""
    if fp8_val == 0:
        return 0.0
    exp = (fp8_val >> 2) & 0x1F
    mant = fp8_val & 0x3
    # fp8_to_q15 output: unsigned Q15
    base = 32768 | (mant << 13)
    if exp >= 15:
        q15 = base << (exp - 15)
    elif exp == 0:
        q15 = (mant << 13) >> 14
    else:
        q15 = base >> (15 - exp)
    # Saturate to 16-bit
    q15 = min(q15, 65535)
    return q15 / 32768.0

# ── Software pipeline simulation ──────────────────────────────────

def bitnet_gemm_sw(acts: torch.Tensor, weights: torch.Tensor,
                   alphas: torch.Tensor, q_width: int,
                   use_fp8_alphas: bool = False) -> torch.Tensor:
    """
    Simulate the ternarycore pipeline in software.
    acts: [VECTOR_LEN] int8 activations
    weights: [COLS, VECTOR_LEN] ternary {-1,0,+1}
    alphas: [COLS] scale values
    """
    # Quantize activations
    q_acts = quantize_acts(acts, q_width)

    # Dot product
    dot = q_acts.float() @ weights.float().T  # [COLS]

    # Scale by alpha
    if use_fp8_alphas:
        alphas_decoded = torch.tensor([fp8_decode(a) for a in alphas])
        result = dot * alphas_decoded
    else:
        result = dot * alphas.float()

    return result


# ── Benchmark ─────────────────────────────────────────────────────

def benchmark():
    print(f"Loading {MODEL_ID}...")
    model = AutoModel.from_pretrained(MODEL_ID, torch_dtype=torch.float32)
    model.eval()

    configs = [
        ("INT8",  8, False),
        ("INT4",  4, False),
        ("INT4+FP8", 4, True),
    ]

    results = []

    for layer_idx in range(LAYERS_TO_TEST):
        print(f"\n─── Layer {layer_idx} ───")
        mlp = model.text_model.layers[layer_idx].mlp
        w_gate = mlp.gate_proj.weight.data  # [1536, 576]
        w_up = mlp.up_proj.weight.data

        # Random activations
        torch.manual_seed(layer_idx)
        acts = torch.randint(-50, 51, (w_gate.shape[1],), dtype=torch.int8)

        # Float reference
        float_gate = w_gate.float() @ acts.float()

        for name, q_width, use_fp8 in configs:
            # Ternary quantize weights
            w_t, alphas = ternarize(w_gate)

            if use_fp8:
                fp8_alphas = alphas_to_fp8(alphas)
                alphas_for_sim = fp8_alphas
            else:
                alphas_for_sim = alphas

            # Software pipeline
            t0 = time.time()
            result = bitnet_gemm_sw(acts, w_t, alphas_for_sim, q_width, use_fp8)
            dt = time.time() - t0

            # Metrics
            cos = torch.nn.functional.cosine_similarity(
                float_gate.unsqueeze(0), result.unsqueeze(0)).item()
            mse = ((float_gate - result) ** 2).mean().item()

            # Memory: weight bits per param
            bits_per_weight = 2  # ternary {-1,0,+1}
            act_bits = q_width
            alpha_bits = 16 if not use_fp8 else 8
            total_bits = bits_per_weight + act_bits + alpha_bits / w_gate.shape[1]

            # Cycle estimate (VLEN=128, VECTOR_LEN=576):
            # 5 iterations × 10 RVV instr per 16-element chunk
            # + decode overhead + alpha scale
            vlen = 128
            vec_size = vlen // 8  # 16 elements per vector (int8)
            n_vecs = math.ceil(w_gate.shape[1] / vec_size)  # 36 for 576
            cycles_per_col = n_vecs * 10  # 10 instr per vector
            total_cycles = cycles_per_col * w_gate.shape[0]  # 1536 cols
            if use_fp8:
                total_cycles += w_gate.shape[0]  # FP8 decode overhead

            results.append({
                "config": f"{name} (Q{q_width})",
                "layer": layer_idx,
                "cosine_sim": f"{cos:.4f}",
                "mse": f"{mse:.2f}",
                "act_bits": act_bits,
                "bits_per_param": f"{total_bits:.1f}",
                "cycles_est": f"{total_cycles:,}",
                "sim_time_us": f"{dt*1e6:.0f}",
            })

            print(f"  {name:10s} cos={cos:.4f} mse={mse:6.2f} "
                  f"bits/param={total_bits:.1f} cycles={total_cycles:,}")

    # ── Summary table ────────────────────────────────────────────
    print("\n\n─── SUMMARY ───")
    print(f"{'Config':14s} {'Cosine':8s} {'MSE':8s} {'Bits/Param':12s} {'Cycles':12s}")
    print("-" * 54)
    for r in results:
        if r["layer"] == 0:
            print(f"{r['config']:14s} {r['cosine_sim']:8s} {r['mse']:8s} "
                  f"{r['bits_per_param']:12s} {r['cycles_est']:12s}")

    # Average across layers
    print("\n  Averages:")
    for name, qw, fp8 in configs:
        cfg = f"{name} (Q{qw})"
        vals = [r for r in results if r["config"] == cfg]
        avg_cos = sum(float(r["cosine_sim"]) for r in vals) / len(vals)
        avg_mse = sum(float(r["mse"]) for r in vals) / len(vals)
        avg_bits = sum(float(r["bits_per_param"]) for r in vals) / len(vals)
        avg_cycles = sum(int(r["cycles_est"].replace(",","")) for r in vals) / len(vals)
        print(f"  {cfg:14s} cos={avg_cos:.4f} mse={avg_mse:6.2f} "
              f"bits/param={avg_bits:.1f} cycles={avg_cycles:,.0f}")

    print(f"\n  Float reference: {float_gate.shape[0]} outputs per layer")
    print(f"  Hidden dim: {w_gate.shape[1]}  |  FFN dim: {w_gate.shape[0]}")


if __name__ == "__main__":
    benchmark()