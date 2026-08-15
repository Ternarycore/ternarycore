#!/usr/bin/env python3
"""sft_teacher.py -- give the teacher the task before asking it to teach.

    python tools/sft_teacher.py
    python tools/sft_teacher.py --epochs 3 --lr 2e-5

tools/eval_rouge.py established that Qwen3-0.6B scores ROUGE-L 10.07 on
DialogSum under the prompt this project actually uses, and inspection of
what it writes explains the number: it does not summarise. Given

    <dialogue>\\nSummary:

it continues the document, and what it continues with is an instruction
to somebody else -- "Please write a summary of the memo in a formal,
concise, and professional manner" -- identically on every example. Asked
through the chat template it manages 19.01, so the ability is in there;
the bare cue does not reach it.

That matters more for D4 than for the scoreboard. Distillation copies
whatever the teacher does, so distilling from this teacher on this prompt
would faithfully teach the student to ask for a summary instead of
writing one, and every number would look fine while it happened.

Two ways out. Switch to the chat template, which costs about thirty
tokens of scaffolding per example against a KV cache D1 already measured
as the binding constraint at 512 positions, and invalidates every
perplexity baseline in the repo. Or teach the teacher the short format.
This is the second: a short supervised fine-tune on DialogSum train,
loss on summary tokens only, so the model learns to produce a summary
after the cue rather than to predict the dialogue that preceded it.

The prompt is left exactly as it was. Every number this project has
recorded -- teacher 8.205, student 14.9, the whole warm-up curve -- was
measured under that format, and changing it to flatter a metric would
cost more than it bought.

Padding-free: micro-batch 1 with accumulation, because DialogSum examples
vary from 60 to 500 tokens and padding a third of the run to <pad> is a
worse trade than the kernel-launch overhead of a batch of one.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import math
import os
import signal
import time

import torch
import torch.nn.functional as F

STOP = False


def _stop(sig, frame):
    global STOP
    STOP = True
    print("  SIGTERM: finishing this step, then saving", flush=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--teacher", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--out", default=os.path.expanduser("~/tc-ckpt/teacher-sft"))
    ap.add_argument("--epochs", type=int, default=2)
    ap.add_argument("--accum", type=int, default=16)
    ap.add_argument("--lr", type=float, default=1e-5)
    ap.add_argument("--warmup-steps", type=int, default=50)
    ap.add_argument("--maxlen", type=int, default=512)
    ap.add_argument("--evaln", type=int, default=200)
    ap.add_argument("--eval-every", type=int, default=200)
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset
    import bitsandbytes as bnb

    signal.signal(signal.SIGTERM, _stop)
    signal.signal(signal.SIGINT, _stop)
    dev = a.device if torch.cuda.is_available() else "cpu"
    os.makedirs(a.out, exist_ok=True)
    tk = AutoTokenizer.from_pretrained(a.teacher)
    m = AutoModelForCausalLM.from_pretrained(
        a.teacher, dtype=torch.bfloat16).to(dev)
    m.gradient_checkpointing_enable()
    m.config.use_cache = False
    m.train()

    tr = load_dataset("knkarthick/dialogsum", split="train")
    va = load_dataset("knkarthick/dialogsum", split="validation")

    def pack(d, s):
        """ids, and where the summary starts. Loss goes on the summary."""
        pre = tk(f"{d}\nSummary:", add_special_tokens=False).input_ids
        full = tk(f"{d}\nSummary: {s}", add_special_tokens=False).input_ids
        full = full + [tk.eos_token_id]      # so it learns to stop
        if len(full) > a.maxlen:
            return None
        return torch.tensor(full), len(pre)

    train = [x for x in (pack(d, s) for d, s in
                         zip(tr["dialogue"], tr["summary"])) if x]
    val = [x for x in (pack(d, s) for d, s in
                       zip(va["dialogue"][:a.evaln], va["summary"][:a.evaln]))
           if x]
    print(f"  {len(train)} train, {len(val)} val "
          f"({len(tr)-len(train)} over {a.maxlen} tokens, dropped)")

    opt = bnb.optim.AdamW8bit(m.parameters(), lr=a.lr, betas=(0.9, 0.95),
                              weight_decay=0.01)
    total = a.epochs * len(train) // a.accum
    print(f"  {a.epochs} epochs, accum {a.accum}, {total} steps, lr {a.lr}\n")

    def lr_at(s):
        if s < a.warmup_steps:
            return a.lr * (s + 1) / a.warmup_steps
        p = (s - a.warmup_steps) / max(1, total - a.warmup_steps)
        return a.lr * (0.1 + 0.9 * 0.5 * (1 + math.cos(math.pi * min(p, 1.0))))

    def loss_of(ids, k):
        ids = ids.unsqueeze(0).to(dev)
        ls = F.log_softmax(m(ids).logits.float(), -1)
        #  Score the summary only. The dialogue is the prompt; teaching the
        #  model to predict it is teaching it the wrong job, and it is four
        #  fifths of the tokens.
        tgt = ids[:, k:]
        return -ls[:, k - 1:-1].gather(-1, tgt.unsqueeze(-1)).mean()

    def val_loss():
        m.eval()
        with torch.no_grad():
            v = sum(float(loss_of(i, k)) for i, k in val) / len(val)
        m.train()
        return v

    print(f"  validation summary loss before training: {val_loss():.4f}\n")
    g = torch.Generator().manual_seed(0)
    step, seen, t0, run = 0, 0, time.time(), 0.0
    hist = []
    for ep in range(a.epochs):
        order = torch.randperm(len(train), generator=g).tolist()
        for n in range(0, len(order) - a.accum + 1, a.accum):
            for j in order[n:n + a.accum]:
                ids, k = train[j]
                l = loss_of(ids, k)
                (l / a.accum).backward()
                run += float(l) / a.accum
            torch.nn.utils.clip_grad_norm_(m.parameters(), 1.0)
            for pg in opt.param_groups:
                pg["lr"] = lr_at(step)
            opt.step()
            opt.zero_grad(set_to_none=True)
            step += 1
            seen += a.accum
            if step % 25 == 0:
                el = time.time() - t0
                print(f"  epoch {ep} step {step:>5}/{total}  {seen} examples"
                      f"  loss {run/25:6.4f}  lr {lr_at(step):.2e}"
                      f"  eta {(total-step)*el/step/60:5.1f} min", flush=True)
                run = 0.0
            if step % a.eval_every == 0 or step == total or STOP:
                v = val_loss()
                hist.append(dict(step=step, examples=seen, val=v))
                print(f"  === step {step}  validation summary loss {v:.4f}",
                      flush=True)
                m.save_pretrained(a.out)
                tk.save_pretrained(a.out)
                json.dump(hist, open(os.path.join(a.out, "sft.json"), "w"),
                          indent=1)
                if STOP:
                    print(f"  saved to {a.out}")
                    return

    print(f"\n  wrote {a.out}")
    print(f"  now: python tools/eval_rouge.py --model {a.out}")
    print(f"  the number to beat is 10.07 on the bare cue, and 19.01 is")
    print(f"  what the same model manages through the chat template.")


if __name__ == "__main__":
    main()
