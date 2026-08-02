#!/usr/bin/env python3
"""D2 surgery: Qwen3 -> ternary student.

- Replaces all 7 per-layer projections (q/k/v/o/gate/up/down) with BitLinear.
- Inserts SubLN (RMSNorm) before the two output projections (o_proj,
  down_proj), per BitNet / BitNet-Distillation.
- Embeddings, lm_head (tied), and existing norms stay full-precision.

Run standalone to build the student, report eval loss in three modes
(teacher / student-FP / student-ternary) and save the init checkpoint.
"""
import torch
import torch.nn as nn
from transformers import AutoModelForCausalLM, AutoTokenizer
from transformers.models.qwen3.modeling_qwen3 import Qwen3RMSNorm
import bitlinear
from bitlinear import BitLinear

TEACHER = "Qwen/Qwen3-0.6B"
PROJS_ATTN = ["q_proj", "k_proj", "v_proj", "o_proj"]
PROJS_MLP = ["gate_proj", "up_proj", "down_proj"]
SUBLN_BEFORE = {"o_proj", "down_proj"}


def _to_bit(linear: nn.Linear) -> BitLinear:
    bl = BitLinear(linear.in_features, linear.out_features,
                   bias=linear.bias is not None,
                   dtype=linear.weight.dtype, device=linear.weight.device)
    with torch.no_grad():
        bl.weight.copy_(linear.weight)
        if linear.bias is not None:
            bl.bias.copy_(linear.bias)
    return bl


def build_student(model):
    """In-place surgery on a loaded Qwen3 model. Returns the model."""
    eps = model.config.rms_norm_eps
    for layer in model.model.layers:
        for holder, names in ((layer.self_attn, PROJS_ATTN), (layer.mlp, PROJS_MLP)):
            for name in names:
                lin = getattr(holder, name)
                bl = _to_bit(lin)
                if name in SUBLN_BEFORE:
                    norm = Qwen3RMSNorm(lin.in_features, eps=eps).to(
                        dtype=lin.weight.dtype, device=lin.weight.device)
                    setattr(holder, name, nn.Sequential(norm, bl))
                else:
                    setattr(holder, name, bl)
    return model


@torch.no_grad()
def eval_loss(model, tok, device="cuda", seq=1024, n_chunks=8):
    from datasets import load_dataset
    text = "\n\n".join(load_dataset("wikitext", "wikitext-2-raw-v1",
                                     split="test")["text"])
    ids = tok(text, return_tensors="pt").input_ids[0][: seq * n_chunks]
    model.eval()
    tot, n = 0.0, 0
    for i in range(0, ids.numel() - seq, seq):
        chunk = ids[i:i + seq].unsqueeze(0).to(device)
        out = model(chunk, labels=chunk)
        tot += out.loss.item(); n += 1
    return tot / max(n, 1)


if __name__ == "__main__":
    import os
    os.makedirs(os.path.expanduser("~/tc-ckpt"), exist_ok=True)
    tok = AutoTokenizer.from_pretrained(TEACHER)
    model = AutoModelForCausalLM.from_pretrained(
        TEACHER, dtype=torch.bfloat16).cuda()
    print(f"[surgery] teacher eval loss: {eval_loss(model, tok):.4f}", flush=True)
    model = build_student(model)
    bitlinear.QUANT["enabled"] = False
    print(f"[surgery] student FP (SubLN inserted): {eval_loss(model, tok):.4f}", flush=True)
    bitlinear.QUANT["enabled"] = True
    print(f"[surgery] student TERNARY (pre-warm-up): {eval_loss(model, tok):.4f}", flush=True)
    path = os.path.expanduser("~/tc-ckpt/student-init.pt")
    torch.save(model.state_dict(), path)
    print(f"[surgery] saved {path}", flush=True)
