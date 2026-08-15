#!/usr/bin/env python3
"""prune_student.py -- D2 step 1: cut the teacher down to the board's shape.

    python tools/prune_student.py --out ~/tc-ckpt/student-L18
    python tools/prune_student.py --calib 128 --dry-run

D1 chose L18 H1024 I2048 8q/8kv and found the consequence: that student is
not the teacher with SubLN inserted, it is a structurally pruned teacher.
arXiv:2510.13998 starts after this step. This is the step.

Three selections, and each one is measured on calibration data rather
than assumed:

**Layers, 18 of 28.** A block whose output points the same way as its
input is not doing much. Importance is 1 - cos(hidden_in, hidden_out),
averaged over the calibration set, which is the angular criterion from
the depth-pruning literature. The first and last blocks are kept
unconditionally -- every result in that literature says the ends carry
embedding and readout structure the middle does not, and 18 of 28 is not
aggressive enough to be worth arguing about.

**Query heads, 8 of 16.** The teacher is 16 q over 8 kv, so each kv head
serves exactly two query heads. Keeping one of each pair takes the model
to 8q/8kv without touching k_proj or v_proj at all, and without changing
which kv head any surviving query attends to. That is why the audit says
k and v transfer verbatim. Within a pair the head with the larger mean
output norm survives.

**MLP channels, 2048 of 3072.** Importance is the mean magnitude of
act_fn(gate(x)) * up(x) per channel -- what the channel actually
contributes to down_proj, not what its weights look like. gate and up are
sliced by row and down by column, which keeps them consistent by
construction.

Nothing here is trained. The point is to produce the initialisation D2's
SubLN surgery and D3's warm-up start from, and to record the damage
before either -- because "the pruned model scored X" is the only number
that says whether the warm-up recovered anything.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys

import torch


def calibrate(model, tok, texts, device):
    """Per-layer, per-head and per-channel importance in one pass each."""
    cfg = model.config
    L, NH, NKV = cfg.num_hidden_layers, cfg.num_attention_heads, \
        cfg.num_key_value_heads
    HD, I = cfg.head_dim, cfg.intermediate_size
    layer_sim = torch.zeros(L, dtype=torch.float64)
    head_norm = torch.zeros(L, NH, dtype=torch.float64)
    chan_act = torch.zeros(L, I, dtype=torch.float64)
    n = 0

    blocks = model.model.layers
    hooks, store = [], {}

    def mlp_hook(i):
        def f(mod, inp, out):
            x = inp[0]
            g = mod.act_fn(mod.gate_proj(x)) * mod.up_proj(x)
            chan_act[i] += g.abs().mean(dim=(0, 1)).double().cpu()
        return f

    def attn_hook(i):
        def f(mod, inp, out):
            #  o_proj's input is the concatenated heads, so its norm per
            #  head slice is what each head hands downstream.
            store[i] = inp[0].detach()
        return f

    for i, b in enumerate(blocks):
        hooks.append(b.mlp.register_forward_hook(mlp_hook(i)))
        hooks.append(b.self_attn.o_proj.register_forward_hook(attn_hook(i)))

    with torch.no_grad():
        for t in texts:
            ids = tok(t, return_tensors="pt", truncation=True,
                      max_length=512).to(device)
            out = model(**ids, output_hidden_states=True)
            hs = out.hidden_states                    # L+1 tensors
            for i in range(L):
                a, b_ = hs[i].double(), hs[i + 1].double()
                cs = torch.nn.functional.cosine_similarity(
                    a, b_, dim=-1).mean().cpu()
                layer_sim[i] += cs
                v = store[i]                          # (1, T, NH*HD)
                v = v.view(v.shape[0], v.shape[1], NH, HD)
                head_norm[i] += v.norm(dim=-1).mean(dim=(0, 1)).double().cpu()
            n += 1

    for h in hooks:
        h.remove()
    return layer_sim / n, head_norm / n, chan_act / n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--teacher", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--out", default=os.path.expanduser("~/tc-ckpt/student-L18"))
    ap.add_argument("--layers", type=int, default=18)
    ap.add_argument("--inter", type=int, default=2048)
    ap.add_argument("--calib", type=int, default=64)
    ap.add_argument("--device", default="cuda")
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset

    dev = a.device if torch.cuda.is_available() else "cpu"
    print(f"loading {a.teacher} onto {dev}")
    tok = AutoTokenizer.from_pretrained(a.teacher)
    model = AutoModelForCausalLM.from_pretrained(
        a.teacher, torch_dtype=torch.float32).to(dev).eval()
    cfg = model.config
    L, NH, NKV, HD, I, H = (cfg.num_hidden_layers, cfg.num_attention_heads,
                            cfg.num_key_value_heads, cfg.head_dim,
                            cfg.intermediate_size, cfg.hidden_size)
    assert NH == 2 * NKV, f"expected 2 query heads per kv head, got {NH}/{NKV}"

    ds = load_dataset("knkarthick/dialogsum", split="train")
    texts = [f"{d}\nSummary: {s}" for d, s in
             zip(ds["dialogue"][:a.calib], ds["summary"][:a.calib])]
    print(f"calibrating on {len(texts)} DialogSum examples")
    sim, hnorm, cact = calibrate(model, tok, texts, dev)

    #  --- layers ------------------------------------------------------
    imp = 1.0 - sim                       # bigger = the block changes more
    order = torch.argsort(imp, descending=True).tolist()
    keep_l = sorted(set([0, L - 1]) |
                    set([i for i in order if i not in (0, L - 1)][:a.layers - 2]))
    dropped = [i for i in range(L) if i not in keep_l]
    print(f"\n  layers kept  {keep_l}")
    print(f"  layers dropped {dropped}")
    print(f"  (1 - cos of the dropped blocks: "
          f"{', '.join(f'{imp[i]:.4f}' for i in dropped[:6])}"
          f"{' ...' if len(dropped) > 6 else ''})")

    #  --- query heads: one of each kv pair ----------------------------
    keep_h = {}
    for i in keep_l:
        sel = []
        for g in range(NKV):
            pair = (2 * g, 2 * g + 1)
            sel.append(pair[0] if hnorm[i, pair[0]] >= hnorm[i, pair[1]]
                       else pair[1])
        keep_h[i] = sel
    ex = keep_l[0]
    print(f"\n  query heads, one per kv group; block {ex} keeps {keep_h[ex]}")
    print(f"  k_proj and v_proj are untouched by construction")

    #  --- MLP channels ------------------------------------------------
    keep_c = {i: torch.argsort(cact[i], descending=True)[:a.inter].sort()
              .values.tolist() for i in keep_l}
    kept_mass = float(cact[ex][keep_c[ex]].sum() / cact[ex].sum())
    print(f"\n  MLP channels {a.inter} of {I}; block {ex} keeps "
          f"{kept_mass*100:.1f}% of the activation mass")

    if a.dry_run:
        print("\n  --dry-run: nothing written")
        return

    #  --- build the student -------------------------------------------
    sd, src = {}, model.state_dict()
    for k in ("model.embed_tokens.weight", "model.norm.weight"):
        sd[k] = src[k].cpu().clone()
    qd = len(keep_h[ex]) * HD
    for new, old in enumerate(keep_l):
        p, q = f"model.layers.{new}.", f"model.layers.{old}."
        hsel = torch.tensor([h * HD + d for h in keep_h[old]
                             for d in range(HD)])
        csel = torch.tensor(keep_c[old])
        sd[p + "self_attn.q_proj.weight"] = src[q + "self_attn.q_proj.weight"][hsel].cpu().clone()
        sd[p + "self_attn.o_proj.weight"] = src[q + "self_attn.o_proj.weight"][:, hsel].cpu().clone()
        for nm in ("k_proj", "v_proj"):
            sd[p + f"self_attn.{nm}.weight"] = src[q + f"self_attn.{nm}.weight"].cpu().clone()
        for nm in ("q_norm", "k_norm"):
            kk = q + f"self_attn.{nm}.weight"
            if kk in src:
                sd[p + f"self_attn.{nm}.weight"] = src[kk].cpu().clone()
        sd[p + "mlp.gate_proj.weight"] = src[q + "mlp.gate_proj.weight"][csel].cpu().clone()
        sd[p + "mlp.up_proj.weight"] = src[q + "mlp.up_proj.weight"][csel].cpu().clone()
        sd[p + "mlp.down_proj.weight"] = src[q + "mlp.down_proj.weight"][:, csel].cpu().clone()
        for nm in ("input_layernorm", "post_attention_layernorm"):
            sd[p + f"{nm}.weight"] = src[q + f"{nm}.weight"].cpu().clone()

    new_cfg = cfg.to_dict()
    new_cfg.update(num_hidden_layers=a.layers, intermediate_size=a.inter,
                   num_attention_heads=len(keep_h[ex]),
                   num_key_value_heads=cfg.num_key_value_heads)
    #  Qwen3 carries a per-layer list that transformers validates against
    #  the depth. Copying it verbatim gives a config that loads on nothing.
    for key in ("layer_types",):
        v = new_cfg.get(key)
        if isinstance(v, list) and len(v) == L:
            new_cfg[key] = [v[i] for i in keep_l]
    os.makedirs(a.out, exist_ok=True)
    torch.save(sd, os.path.join(a.out, "pytorch_model.bin"))
    json.dump(new_cfg, open(os.path.join(a.out, "config.json"), "w"), indent=1)
    json.dump({"kept_layers": keep_l, "dropped_layers": dropped,
               "kept_heads": {str(k): v for k, v in keep_h.items()},
               "kept_channels": {str(k): v for k, v in keep_c.items()},
               "calib_examples": len(texts), "teacher": a.teacher},
              open(os.path.join(a.out, "prune.json"), "w"))
    tok.save_pretrained(a.out)

    tern = sum(v.numel() for k, v in sd.items()
               if any(x in k for x in ("q_proj", "k_proj", "v_proj", "o_proj",
                                       "gate_proj", "up_proj", "down_proj")))
    print(f"\n  wrote {a.out}")
    print(f"  {tern/1e6:.1f} M projection weights "
          f"({tern/4/1e6:.1f} MB once ternary), "
          f"{sum(v.numel() for v in sd.values())/1e6:.1f} M total")
    print(f"\n  next: evaluate this before any training. The number it")
    print(f"  scores now is what D3's warm-up has to beat.")


if __name__ == "__main__":
    main()
