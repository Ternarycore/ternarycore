#!/usr/bin/env python3
"""prune_reconstruct.py -- D2 step 2: put back what slicing took away.

    python tools/prune_reconstruct.py --ckpt ~/tc-ckpt/student-L18
    python tools/prune_reconstruct.py --calib 128 --ridge 1e-2

tools/prune_student.py cut the teacher to the board's shape and the
result scored 1.567e9 summary perplexity against the teacher's 8.205.
The decomposition said where it went: layers alone cost 28444, so the
head and channel cuts cost another four and a half orders of magnitude
on top of that.

That is not a selection problem, it is a scale problem. o_proj sums over
sixteen query heads and now gets eight. down_proj sums over 3072 MLP
channels and now gets 2048. Slicing the weight matrix keeps the surviving
terms at their original coefficients, so the sum is systematically short,
and every downstream RMSNorm gain was fitted to the full one. Over
eighteen layers that compounds into noise.

The fix is the reconstruction step every structured-pruning recipe has
and this project skipped: do not slice the matrix, *refit* it. Solve

    W_new = argmin || W X_kept - Y_full ||

where X_kept is what the surviving channels actually produce and Y_full
is what the layer used to output. The surviving coefficients move to
cover for the missing ones. It is a linear least squares in 1024 or 2048
dimensions, solved from normal equations accumulated over calibration
tokens, so memory is O(d^2) whatever the calibration size and the whole
thing is minutes on one card.

Two honest limits, stated because the numbers will show them:

  * This is local reconstruction: X and Y both come from the teacher's
    own activations. It cannot fix error that has already accumulated in
    the input by the time a deep layer sees it. The sequential version --
    feed the pruned model's hidden state, target the teacher's output --
    is strictly better and strictly more work, and is the next thing to
    try if this is not enough.
  * It cannot help the dropped layers at all. Removing a block is not a
    linear operation on anything. The 28444 that depth alone costs is
    what D3's warm-up is for.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os

import torch


def solve(A, B, ridge):
    """W = B A^-1, regularised. A is (d,d) Gram, B is (out,d) cross term."""
    d = A.shape[0]
    A = A + ridge * torch.eye(d, dtype=A.dtype, device=A.device) * \
        (A.diagonal().mean() + 1e-12)
    return torch.linalg.solve(A.T, B.T).T


def resid(W, A, B, C):
    """||W X^T - Y^T||^2 from the moments alone, so X and Y need not be kept.

    Expanding gives tr(W A W^T) - 2 <W, B> + C, where C = sum Y^2 is the
    term that makes this an actual residual rather than one up to an
    unknown constant. Without C the refit can print a negative number and
    nobody can tell whether it is good.
    """
    return float(((W @ A) * W).sum() - 2.0 * (W * B).sum() + C)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--teacher", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--ckpt", default=os.path.expanduser("~/tc-ckpt/student-L18"))
    ap.add_argument("--out", default="")
    ap.add_argument("--calib", type=int, default=128)
    ap.add_argument("--ridge", type=float, default=1e-2)
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()
    out = a.out or (a.ckpt + "-recon")

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset

    dev = a.device if torch.cuda.is_available() else "cpu"
    sel = json.load(open(os.path.join(a.ckpt, "prune.json")))
    keep_l = sel["kept_layers"]
    keep_h = {int(k): v for k, v in sel["kept_heads"].items()}
    keep_c = {int(k): v for k, v in sel["kept_channels"].items()}

    tok = AutoTokenizer.from_pretrained(a.teacher)
    t = AutoModelForCausalLM.from_pretrained(
        a.teacher, dtype=torch.float32).to(dev).eval()
    cfg = t.config
    HD, H = cfg.head_dim, cfg.hidden_size

    ds = load_dataset("knkarthick/dialogsum", split="train")
    texts = [f"{d}\nSummary: {s}" for d, s in
             zip(ds["dialogue"][:a.calib], ds["summary"][:a.calib])]
    print(f"reconstructing {len(keep_l)} layers on {len(texts)} examples, "
          f"ridge {a.ridge}")

    #  Index tensors are fixed for the whole run; building them per example
    #  per layer was 2300 pointless allocations.
    idx = {}
    for i in keep_l:
        idx[i] = (torch.tensor([h * HD + d for h in keep_h[i]
                                for d in range(HD)], device=dev),
                  torch.tensor(keep_c[i], device=dev))

    #  Normal equations, accumulated in float64 because these are sums of
    #  outer products over tens of thousands of tokens and float32 loses
    #  the tail of that quietly. C is the sum of squared targets, carried
    #  so resid() reports a residual and not a residual plus a constant.
    acc = {}
    for i in keep_l:
        dq, dc = len(keep_h[i]) * HD, len(keep_c[i])
        acc[i] = dict(
            Ao=torch.zeros(dq, dq, dtype=torch.float64, device=dev),
            Bo=torch.zeros(H, dq, dtype=torch.float64, device=dev),
            Co=0.0,
            Ad=torch.zeros(dc, dc, dtype=torch.float64, device=dev),
            Bd=torch.zeros(H, dc, dtype=torch.float64, device=dev),
            Cd=0.0)

    store, hooks = {}, []

    def o_hook(i):
        def f(mod, inp, o):
            store[("o", i)] = (inp[0].detach(), o.detach())
        return f

    def m_hook(i):
        def f(mod, inp, o):
            x = inp[0]
            store[("m", i)] = (
                (mod.act_fn(mod.gate_proj(x)) * mod.up_proj(x)).detach(),
                o.detach())
        return f

    for i in keep_l:
        b = t.model.layers[i]
        hooks.append(b.self_attn.o_proj.register_forward_hook(o_hook(i)))
        hooks.append(b.mlp.register_forward_hook(m_hook(i)))

    with torch.no_grad():
        for n, txt in enumerate(texts):
            ids = tok(txt, return_tensors="pt", truncation=True,
                      max_length=512).to(dev)
            t.model(**ids)   # skip lm_head: 512x151936 logits is 311 MB we never read
            for i in keep_l:
                hsel, csel = idx[i]
                for tag, sl, A, B, C in (("o", hsel, "Ao", "Bo", "Co"),
                                         ("m", csel, "Ad", "Bd", "Cd")):
                    X, Y = store[(tag, i)]
                    X = X.reshape(-1, X.shape[-1])[:, sl].double()
                    Y = Y.reshape(-1, Y.shape[-1]).double()
                    acc[i][A] += X.T @ X
                    acc[i][B] += Y.T @ X
                    acc[i][C] += float((Y * Y).sum())
            store.clear()
            if (n + 1) % 32 == 0:
                print(f"    {n+1}/{len(texts)}")
    for h in hooks:
        h.remove()
    del t
    torch.cuda.empty_cache() if dev.startswith("cuda") else None

    #  --- refit, and report how much better than slicing it is ---------
    #  Residuals are printed as a fraction of ||Y||^2, so 1.0 means the
    #  weights explain nothing and 0.0 means the layer is reproduced. That
    #  is readable across layers whose activations differ by decades.
    sd = torch.load(os.path.join(a.ckpt, "pytorch_model.bin"),
                    weights_only=True)
    print(f"\n  {'layer':>5}  {'o_proj  sliced -> refit':>26}"
          f"  {'down_proj  sliced -> refit':>28}")
    worst = 0.0
    for new, old in enumerate(keep_l):
        row = []
        for A, B, C, key in (("Ao", "Bo", "Co", "self_attn.o_proj.weight"),
                             ("Ad", "Bd", "Cd", "mlp.down_proj.weight")):
            Am, Bm, Cm = acc[old][A], acc[old][B], acc[old][C]
            W_old = sd[f"model.layers.{new}.{key}"].double().to(dev)
            W_new = solve(Am, Bm, a.ridge)
            r0 = resid(W_old, Am, Bm, Cm) / Cm
            r1 = resid(W_new, Am, Bm, Cm) / Cm
            worst = max(worst, r1)
            sd[f"model.layers.{new}.{key}"] = W_new.float().cpu()
            row.append(f"{r0:11.4f} -> {r1:9.4f}")
        print(f"  {new:>5}  {row[0]:>26}  {row[1]:>28}")
    print(f"\n  worst relative residual after refit: {worst:.4f}")

    os.makedirs(out, exist_ok=True)
    torch.save(sd, os.path.join(out, "pytorch_model.bin"))
    for f in ("config.json", "prune.json", "tokenizer.json",
              "tokenizer_config.json", "vocab.json", "merges.txt",
              "special_tokens_map.json", "added_tokens.json"):
        src = os.path.join(a.ckpt, f)
        if os.path.exists(src):
            open(os.path.join(out, f), "wb").write(open(src, "rb").read())

    #  Qwen3 carries a per-layer `layer_types` list that transformers
    #  validates against num_hidden_layers. A config copied from a
    #  28-layer teacher loads on nothing. Cheap to check, expensive to
    #  debug.
    cpath = os.path.join(out, "config.json")
    if os.path.exists(cpath):
        c = json.load(open(cpath))
        lt, nl = c.get("layer_types"), c.get("num_hidden_layers")
        if isinstance(lt, list) and nl and len(lt) != nl:
            c["layer_types"] = [lt[0]] * nl
            json.dump(c, open(cpath, "w"), indent=1)
            print(f"  fixed layer_types: {len(lt)} -> {nl}")

    print(f"\n  wrote {out}")
    print(f"  now: python tools/eval_ppl.py --model {out}")
    print(f"  the number to beat is 1567100006.5, and the number depth")
    print(f"  alone costs is 28443.9 -- if this lands near the second one")
    print(f"  the scale diagnosis was right.")


if __name__ == "__main__":
    main()
