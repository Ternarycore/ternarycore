#!/usr/bin/env python3
"""prune_seq.py -- D2 step 3: reconstruct along the student's own trajectory.

    python tools/prune_seq.py --ckpt ~/tc-ckpt/student-L18
    python tools/prune_seq.py --full --calib 512

tools/prune_reconstruct.py refit o_proj and down_proj against the
teacher's activations on both sides, and that took the summary
perplexity from 1.567e9 to 8.12e4 -- nineteen thousand times better, and
proof that the damage was scale and not selection. It stopped short of
what depth alone costs, and its own docstring named the reason:

    "This is local reconstruction: X and Y both come from the teacher's
    own activations. It cannot fix error that has already accumulated in
    the input by the time a deep layer sees it."

This is the version that can. One change, and it is the whole idea:

    X comes from the student, Y still comes from the teacher.

So layer 9 is not fitted to reproduce the teacher's layer 9 given the
teacher's inputs -- it is fitted to reproduce the teacher's layer 9 given
the inputs the *pruned* model will actually hand it, drift and all. Each
layer absorbs the error the layers before it introduced, including the
error from blocks that are not there any more. That is why this beats
depth-only pruning rather than merely approaching it.

It only works in order, because the student's hidden state at layer j
depends on the refit at every layer before it. So the two models walk
forward together: the teacher through all 28 of its blocks, the student
through its 18, and at each block the student keeps, we solve, write the
answer back, and only then step the student's hidden state through the
layer we just fixed. Two cached activation streams, a few layers of work
per step -- not eighteen forward passes.

The teacher walks its own trajectory throughout, including the ten blocks
the student does not have. It has to: the target is what the *unpruned*
model computes, and the dropped blocks are part of how it got there.

**--full** refits all seven projections instead of the two that lost a
summation dimension. o_proj and down_proj are the ones slicing broke, but
every projection in the block is being fed a drifted input, and a matrix
fitted to the drift it will actually see beats the teacher's matrix
fitted to a hidden state this model no longer produces. Order matters
inside the block too: q/k/v are fitted first because their input does not
depend on anything else in the block, then o_proj against the attention
output the new q/k/v produce, then gate/up, then down_proj against the
gate*up the new gate/up produce. Four solves in dependency order, each
one seeing the corrected version of what came before.

What none of this can do is recover the dropped blocks themselves.
Nothing linear can. That gap is D3's warm-up and always was.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os

import torch


def solve(A, B, ridge):
    """W = B A^-1, regularised. A is (d,d) Gram, B is (out,d) cross term.

    On the host, deliberately. These are at most 2048x2048 in float64 --
    a fraction of a second either way -- and cuSOLVER wants a workspace
    it cannot always get when something else owns most of the card. A
    factorisation that fails at example 400 of 512 is a bad trade for a
    few milliseconds.
    """
    dev, d = B.device, A.shape[0]
    A = A.cpu()
    A = A + ridge * torch.eye(d, dtype=A.dtype) * (A.diagonal().mean() + 1e-12)
    return torch.linalg.solve(A.T, B.cpu().T).T.to(dev)


def resid(W, A, B, C):
    """||W X^T - Y^T||^2 from the moments alone, relative to ||Y||^2."""
    return float(((W @ A) * W).sum() - 2.0 * (W * B).sum() + C) / C


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--teacher", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--ckpt", default=os.path.expanduser("~/tc-ckpt/student-L18"))
    ap.add_argument("--out", default="")
    ap.add_argument("--calib", type=int, default=128)
    ap.add_argument("--ridge", type=float, default=1e-2)
    ap.add_argument("--maxlen", type=int, default=512)
    ap.add_argument("--full", action="store_true",
                    help="refit all seven projections, not just o and down")
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()
    out = a.out or (a.ckpt + ("-seqfull" if a.full else "-seq"))

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset

    dev = a.device if torch.cuda.is_available() else "cpu"
    sel = json.load(open(os.path.join(a.ckpt, "prune.json")))
    keep_l = sel["kept_layers"]
    keep_h = {int(k): v for k, v in sel["kept_heads"].items()}
    keep_c = {int(k): v for k, v in sel["kept_channels"].items()}

    #  The teacher lives on the host and visits the card one block at a
    #  time. Both models resident is 4 GB, which is more than there is
    #  when something else owns most of the device -- and the teacher is
    #  only ever used one layer deep, so keeping all 28 there buys
    #  nothing. A block is 21 MB; the copy is lost in the forward pass.
    tok = AutoTokenizer.from_pretrained(a.teacher)
    t = AutoModelForCausalLM.from_pretrained(
        a.teacher, dtype=torch.float32).eval()
    s = AutoModelForCausalLM.from_pretrained(
        a.ckpt, dtype=torch.float32).to(dev).eval()
    HD = t.config.head_dim
    assert s.config.num_hidden_layers == len(keep_l)

    ds = load_dataset("knkarthick/dialogsum", split="train")
    texts = [f"{d}\nSummary: {x}" for d, x in
             zip(ds["dialogue"][:a.calib], ds["summary"][:a.calib])]

    #  Both towers start from the same tokens. The embeddings are shared
    #  verbatim -- prune_student copied them -- so the two streams begin
    #  identical and diverge only through the pruning, which is exactly
    #  the divergence we are here to fit against.
    ids, G, S = [], [], []
    t.model.embed_tokens.to(dev)
    with torch.no_grad():
        for txt in texts:
            e = tok(txt, return_tensors="pt", truncation=True,
                    max_length=a.maxlen).input_ids.to(dev)
            ids.append(e.cpu())
            h = t.model.embed_tokens(e)
            G.append(h.cpu())
            S.append(h.cpu())
    t.model.embed_tokens.to("cpu")
    ntok = sum(int(e.shape[1]) for e in ids)
    print(f"sequential reconstruction{' (all projections)' if a.full else ''}: "
          f"{len(keep_l)} kept of {t.config.num_hidden_layers}, "
          f"{len(texts)} examples, {ntok} tokens, ridge {a.ridge}")

    #  Rotary tables are cheap to rebuild and expensive to keep: caching
    #  them for every example put tens of megabytes on the card for no
    #  reason. Both models share head_dim and theta, so one table serves.
    rot = t.model.rotary_emb.to(dev)

    def step(layer, h, k):
        p = torch.arange(h.shape[1], device=h.device).unsqueeze(0)
        c, sn = rot(h, p)
        o = layer(h, attention_mask=None, position_ids=p,
                  position_embeddings=(c, sn))
        return o[0] if isinstance(o, tuple) else o

    grab = {}

    def h_in(key):
        def f(mod, inp, o):
            grab[key] = inp[0].detach()
        return f

    def h_out(key):
        def f(mod, inp, o):
            grab[key] = o.detach()
        return f

    def h_mid(key):
        def f(mod, inp, o):
            x = inp[0]
            grab[key] = (mod.act_fn(mod.gate_proj(x)) * mod.up_proj(x)).detach()
        return f

    def plan(name, tl, sl, hsel, csel):
        """(x-source hook, [(student weight, teacher source, target rows)])

        One Gram matrix per sub-pass, shared by every target fitted from
        the same input -- q, k and v all read the same normalised hidden
        state, so they cost one accumulation between them.
        """
        if name == "qkv":
            return (h_in("X"), sl.self_attn.q_proj, [
                ("q_proj", sl.self_attn.q_proj, tl.self_attn.q_proj, hsel),
                ("k_proj", sl.self_attn.k_proj, tl.self_attn.k_proj, None),
                ("v_proj", sl.self_attn.v_proj, tl.self_attn.v_proj, None)])
        if name == "o":
            return (h_in("X"), sl.self_attn.o_proj, [
                ("o_proj", sl.self_attn.o_proj, tl.self_attn.o_proj, None)])
        if name == "gateup":
            return (h_in("X"), sl.mlp.gate_proj, [
                ("gate_proj", sl.mlp.gate_proj, tl.mlp.gate_proj, csel),
                ("up_proj", sl.mlp.up_proj, tl.mlp.up_proj, csel)])
        return (h_mid("X"), sl.mlp, [
            ("down_proj", sl.mlp.down_proj, tl.mlp, None)])

    passes = ["qkv", "o", "gateup", "down"] if a.full else ["o", "down"]
    print(f"\n  {'blk':>3}  {'projection':<10}  {'sliced':>9} -> {'refit':>8}"
          f"   {'':2}{'gain':>6}")
    j, worst = 0, 0.0
    with torch.no_grad():
        for ti in range(t.config.num_hidden_layers):
            tl = t.model.layers[ti].to(dev)
            if ti not in keep_l:
                for k in range(len(ids)):
                    G[k] = step(tl, G[k].to(dev), k)   # teacher walks it anyway
                    G[k] = G[k].cpu()
                t.model.layers[ti].to("cpu")
                continue
            sl = s.model.layers[j]
            hsel = torch.tensor([h * HD + d for h in keep_h[ti]
                                 for d in range(HD)], device=dev)
            csel = torch.tensor(keep_c[ti], device=dev)

            for pname in passes:
                xhook, xmod, targets = plan(pname, tl, sl, hsel, csel)
                hk = [xmod.register_forward_hook(xhook)]
                for nm, _, tmod, _ in targets:
                    hk.append(tmod.register_forward_hook(h_out("Y_" + nm)))

                A, acc = None, {}
                for k in range(len(ids)):
                    step(tl, G[k].to(dev), k)
                    step(sl, S[k].to(dev), k)
                    x = grab["X"].reshape(-1, grab["X"].shape[-1]).double()
                    if A is None:
                        A = torch.zeros(x.shape[1], x.shape[1],
                                        dtype=torch.float64, device=dev)
                    A += x.T @ x
                    for nm, _, _, rows in targets:
                        y = grab["Y_" + nm]
                        y = y.reshape(-1, y.shape[-1])
                        if rows is not None:
                            y = y[:, rows]
                        y = y.double()
                        if nm not in acc:
                            acc[nm] = [torch.zeros(y.shape[1], x.shape[1],
                                                   dtype=torch.float64,
                                                   device=dev), 0.0]
                        acc[nm][0] += y.T @ x
                        acc[nm][1] += float((y * y).sum())
                    grab.clear()
                for hh in hk:
                    hh.remove()

                for nm, smod, _, _ in targets:
                    B, C = acc[nm]
                    W0 = smod.weight.data.double()
                    W1 = solve(A, B, a.ridge)
                    r0, r1 = resid(W0, A, B, C), resid(W1, A, B, C)
                    #  Ridge can, on a projection the slice already
                    #  reproduced, make things very slightly worse.
                    #  Never ship a step backwards.
                    if r1 < r0:
                        smod.weight.data.copy_(W1.float())
                    else:
                        r1 = r0
                    worst = max(worst, r1)
                    print(f"  {j:>3}  {nm:<10}  {r0:9.4f} -> {r1:8.4f}"
                          f"   {r0/max(r1,1e-12):>7.1f}x")

            #  Only now do the two hidden states move through the block.
            for k in range(len(ids)):
                G[k] = step(tl, G[k].to(dev), k).cpu()
                S[k] = step(sl, S[k].to(dev), k).cpu()
            t.model.layers[ti].to("cpu")
            j += 1

    print(f"\n  worst relative residual: {worst:.4f}")

    os.makedirs(out, exist_ok=True)
    torch.save(s.state_dict(), os.path.join(out, "pytorch_model.bin"))
    for f in ("config.json", "prune.json", "tokenizer.json",
              "tokenizer_config.json", "vocab.json", "merges.txt",
              "special_tokens_map.json", "added_tokens.json",
              "chat_template.jinja"):
        src = os.path.join(a.ckpt, f)
        if os.path.exists(src):
            open(os.path.join(out, f), "wb").write(open(src, "rb").read())
    print(f"  wrote {out}")
    print(f"  now: python tools/eval_ppl.py --model {out}")
    print(f"  teacher 8.2, naive slice 1.567e9, depth alone 28443.9,")
    print(f"  local reconstruction 81173.6, sequential o+down 3855.4.")


if __name__ == "__main__":
    main()
