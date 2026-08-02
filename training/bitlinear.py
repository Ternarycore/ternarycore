"""BitLinear: W1.58A8 quantization-aware linear layer (BitNet b1.58 recipe).

Forward uses ternary weights (absmean) and int8 activations (per-token
absmax); gradients flow to the full-precision shadow weights via the
straight-through estimator (STE). Toggle QUANT['enabled']=False for
full-precision sanity (D2 parity checks).
"""
import torch
import torch.nn as nn
import torch.nn.functional as F

QUANT = {"enabled": True}


def absmean_ternary(w: torch.Tensor) -> torch.Tensor:
    """BitNet b1.58: scale by mean(|W|), round to {-1,0,+1}, rescale."""
    s = w.abs().mean().clamp(min=1e-8)
    return (w / s).round().clamp(-1, 1) * s


def int8_activations(x: torch.Tensor) -> torch.Tensor:
    """Per-token absmax int8 quant, dequantized back to input dtype."""
    s = x.abs().amax(dim=-1, keepdim=True).clamp(min=1e-5) / 127.0
    return (x / s).round().clamp(-128, 127) * s


class BitLinear(nn.Linear):
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        w = self.weight
        if QUANT["enabled"]:
            wq = absmean_ternary(w)
            w = w + (wq - w).detach()          # STE: forward wq, grad -> w
            xq = int8_activations(x)
            x = x + (xq - x).detach()          # STE for activations
        return F.linear(x, w, self.bias)


@torch.no_grad()
def export_ternary(linear: BitLinear):
    """Return (ternary int8 matrix in {-1,0,1}, scale) for LOADM export."""
    w = linear.weight.float()
    s = w.abs().mean().clamp(min=1e-8)
    return (w / s).round().clamp(-1, 1).to(torch.int8), s.item()
