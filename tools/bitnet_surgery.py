#!/usr/bin/env python3
"""bitnet_surgery.py -- D2's last step: SubLN in, and paid for on the way in.

    python tools/bitnet_surgery.py --ckpt ~/tc-ckpt/student-L28-seq
    python tools/bitnet_surgery.py --calib 512 --no-refit   # what it costs unpaid

DISTILLATION_PLAN's D2 is "insert SubLN per the paper, brief FP fine-tune
to confirm the surgery didn't lobotomize the model". The fine-tune is
avoidable. SubLN divides a projection's input by its own RMS, and the
projection that follows is a matrix we already know how to refit -- so
insert the norm and solve the same least squares D2's reconstruction
used, with the normalised activation as X and the pre-surgery output as
Y. The surgery pays for itself in one pass instead of a training run.

Where the norm goes is not a judgement call here. build_ddr_image.py
carries exactly six per-block gains,

    in_norm, post_norm, q_norm, k_norm, o_proj.subln, down_proj.subln

so the board expects SubLN on o_proj and down_proj and nowhere else. That
is also where it belongs: those two are the sub-layer output projections,
and the other five are already fed by input_layernorm or
post_attention_layernorm. The datapath settled the architecture question
before anyone had to have an opinion about it.

The refit cannot be exact and the residual says how close it gets. SubLN
scales each token by 1/rms(x), which varies token to token, while the
correction available is one fixed matrix. If the RMS were constant across
tokens the refit would be exact; the printed residual is the fraction of
the layer's output the varying part accounts for.

This file also carries BitLinear, which D3 trains: absmean ternary
weights and per-token int8 activations, straight-through on both. The
weight quantiser is character-for-character the one in
export_checkpoint.py -- s = mean(|W|), clip(round(W/s), -1, 1) -- because
a student trained against a different rounding rule than the exporter
applies is a student that changes when you ship it.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import math
import os

import torch
import torch.nn as nn
import torch.nn.functional as F


def ternarize(w):
    """The exporter's quantiser, exactly. Returns the dequantised weight."""
    s = w.abs().mean().clamp(min=1e-8)
    return torch.clamp(torch.round(w / s), -1, 1) * s


def act8(x):
    """Per-token absmax int8, the activation format the board consumes."""
    s = 127.0 / x.abs().amax(dim=-1, keepdim=True).clamp(min=1e-5)
    return torch.clamp(torch.round(x * s), -128, 127) / s


class SubLN(nn.Module):
    """RMSNorm with a learnable gain, Qwen3's semantics and epsilon."""

    def __init__(self, d, eps=1e-6):
        super().__init__()
        self.weight = nn.Parameter(torch.ones(d))
        self.eps = eps

    def forward(self, x):
        v = x.float()
        v = v * torch.rsqrt(v.pow(2).mean(-1, keepdim=True) + self.eps)
        return (v * self.weight.float()).to(x.dtype)


class BitLinear(nn.Linear):
    """W1.58 A8 with straight-through estimators on both sides.

    `quant` is a flag rather than a subclass so the same object can be
    evaluated in full precision and in ternary without rebuilding the
    model -- which is the only way the two numbers are comparable.
    """

    quant = False

    def forward(self, x):
        if not self.quant:
            return F.linear(x, self.weight, self.bias)
        w = self.weight
        w = w + (ternarize(w) - w).detach()
        x = x + (act8(x) - x).detach()
        return F.linear(x, w, self.bias)


def as_bitlinear(lin):
    b = BitLinear(lin.in_features, lin.out_features,
                  bias=lin.bias is not None, device=lin.weight.device,
                  dtype=lin.weight.dtype)
    b.weight.data.copy_(lin.weight.data)
    if lin.bias is not None:
        b.bias.data.copy_(lin.bias.data)
    return b


#  The two that get a norm, and the five that do not.
SUBLN = (("self_attn", "o_proj"), ("mlp", "down_proj"))
PLAIN = (("self_attn", "q_proj"), ("self_attn", "k_proj"),
         ("self_attn", "v_proj"), ("mlp", "gate_proj"), ("mlp", "up_proj"))


def convert(model):
    """Every projection becomes a BitLinear; two of them gain a SubLN."""
    for blk in model.model.layers:
        for parent, name in PLAIN:
            p = getattr(blk, parent)
            setattr(p, name, as_bitlinear(getattr(p, name)))
        for parent, name in SUBLN:
            p = getattr(blk, parent)
            lin = getattr(p, name)
            setattr(p, name, nn.Sequential(
                SubLN(lin.in_features).to(lin.weight.device),
                as_bitlinear(lin)))
    return model


def set_quant(model, on):
    for m in model.modules():
        if isinstance(m, BitLinear):
            m.quant = on


def ppl(model, tk, ds, n, dev):
    """eval_ppl.py's protocol, inlined so a converted model can be scored.

    Summary tokens only. Whole-sequence perplexity on DialogSum is
    dominated by the dialogue, which neither model is asked to produce,
    and it flatters everything here by an order of magnitude.
    """
    nll, ntok = 0.0, 0
    with torch.no_grad():
        for d, s in zip(ds["dialogue"][:n], ds["summary"][:n]):
            pre = tk(f"{d}\nSummary:", return_tensors="pt").input_ids
            full = tk(f"{d}\nSummary: {s}", return_tensors="pt").input_ids
            if full.shape[1] > 512:
                continue
            ids = full.to(dev)
            lg = model(ids).logits[0, :-1].float()
            tgt = ids[0, 1:]
            k = pre.shape[1] - 1
            nll += F.cross_entropy(lg[k:], tgt[k:], reduction="sum").item()
            ntok += tgt[k:].numel()
    return math.exp(nll / ntok)


def solve(A, B, ridge):
    dev, d = B.device, A.shape[0]
    A = A.cpu()
    A = A + ridge * torch.eye(d, dtype=A.dtype) * (A.diagonal().mean() + 1e-12)
    return torch.linalg.solve(A.T, B.cpu().T).T.to(dev)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ckpt", default=os.path.expanduser("~/tc-ckpt/student-L28-seq"))
    ap.add_argument("--out", default="")
    ap.add_argument("--teacher", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--calib", type=int, default=256)
    ap.add_argument("--ridge", type=float, default=1e-2)
    ap.add_argument("--evaln", type=int, default=200)
    ap.add_argument("--no-refit", action="store_true")
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()
    out = a.out or (a.ckpt + "-subln")

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset

    dev = a.device if torch.cuda.is_available() else "cpu"
    tk = AutoTokenizer.from_pretrained(a.teacher)
    m = AutoModelForCausalLM.from_pretrained(
        a.ckpt, dtype=torch.float32).to(dev).eval()
    val = load_dataset("knkarthick/dialogsum", split="validation")
    tr = load_dataset("knkarthick/dialogsum", split="train")

    base = ppl(m, tk, val, a.evaln, dev)
    print(f"  before surgery                     {base:12.3f}")

    #  Targets first: what each of the two projections outputs today, on
    #  the model's own trajectory, before anything is inserted.
    texts = [f"{d}\nSummary: {s}" for d, s in
             zip(tr["dialogue"][:a.calib], tr["summary"][:a.calib])]
    L = m.config.num_hidden_layers
    acc, grab = {}, {}

    def h_in(k):
        def f(mod, i, o):
            grab[("x", k)] = i[0].detach()
        return f

    def h_out(k):
        def f(mod, i, o):
            grab[("y", k)] = o.detach()
        return f

    if not a.no_refit:
        hk = []
        for i, blk in enumerate(m.model.layers):
            for parent, name in SUBLN:
                mod = getattr(getattr(blk, parent), name)
                hk.append(mod.register_forward_hook(h_in((i, name))))
                hk.append(mod.register_forward_hook(h_out((i, name))))
        print(f"  accumulating on {len(texts)} examples")
        with torch.no_grad():
            for n, txt in enumerate(texts):
                e = tk(txt, return_tensors="pt", truncation=True,
                       max_length=512).input_ids.to(dev)
                m.model(e)
                for i in range(L):
                    for _, name in SUBLN:
                        x, y = grab[("x", (i, name))], grab[("y", (i, name))]
                        #  X is what the projection will see *after* the
                        #  norm, so normalise here with gain 1 -- the same
                        #  thing SubLN will do at inference.
                        x = x.reshape(-1, x.shape[-1]).float()
                        x = x * torch.rsqrt(x.pow(2).mean(-1, keepdim=True)
                                            + 1e-6)
                        x = x.double()
                        y = y.reshape(-1, y.shape[-1]).double()
                        k = (i, name)
                        if k not in acc:
                            acc[k] = [torch.zeros(x.shape[1], x.shape[1],
                                                  dtype=torch.float64,
                                                  device=dev),
                                      torch.zeros(y.shape[1], x.shape[1],
                                                  dtype=torch.float64,
                                                  device=dev), 0.0]
                        acc[k][0] += x.T @ x
                        acc[k][1] += y.T @ x
                        acc[k][2] += float((y * y).sum())
                grab.clear()
                if (n + 1) % 64 == 0:
                    print(f"    {n+1}/{len(texts)}")
        for h in hk:
            h.remove()

    convert(m)

    if not a.no_refit:
        worst, tot = 0.0, 0.0
        for i, blk in enumerate(m.model.layers):
            for parent, name in SUBLN:
                A, B, C = acc[(i, name)]
                lin = getattr(getattr(blk, parent), name)[1]
                W = solve(A, B, a.ridge)
                r = float(((W @ A) * W).sum() - 2 * (W * B).sum() + C) / C
                lin.weight.data.copy_(W.float())
                worst = max(worst, r); tot += r
        print(f"  refit residual: worst {worst:.4f}, "
              f"mean {tot/(2*L):.4f}  (0 = SubLN absorbed exactly)")

    fp = ppl(m, tk, val, a.evaln, dev)
    set_quant(m, True)
    tern = ppl(m, tk, val, a.evaln, dev)
    set_quant(m, False)

    print(f"  after SubLN, full precision        {fp:12.3f}")
    print(f"  after SubLN, W1.58 A8, untrained   {tern:12.3f}")
    print(f"  (teacher 8.205)")

    os.makedirs(out, exist_ok=True)
    torch.save(m.state_dict(), os.path.join(out, "pytorch_model.bin"))
    for f in ("config.json", "prune.json", "tokenizer.json",
              "tokenizer_config.json", "vocab.json", "merges.txt",
              "special_tokens_map.json", "added_tokens.json",
              "chat_template.jinja"):
        src = os.path.join(a.ckpt, f)
        if os.path.exists(src):
            open(os.path.join(out, f), "wb").write(open(src, "rb").read())
    json.dump(dict(subln=[f"{p}.{n}" for p, n in SUBLN],
                   plain=[f"{p}.{n}" for p, n in PLAIN],
                   refit=not a.no_refit, calib=a.calib, ridge=a.ridge,
                   ppl_before=base, ppl_fp=fp, ppl_ternary=tern),
              open(os.path.join(out, "surgery.json"), "w"), indent=1)
    print(f"\n  wrote {out}")
    print(f"  the ternary number is what D3's warm-up starts from and the")
    print(f"  full-precision one is the ceiling it is trying to get back to.")


if __name__ == "__main__":
    main()
