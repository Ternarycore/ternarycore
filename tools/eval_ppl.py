#!/usr/bin/env python3
"""eval_ppl.py -- what a checkpoint scores, before anyone trains it.

    python tools/eval_ppl.py --model ~/tc-ckpt/student-L18
    python tools/eval_ppl.py --model Qwen/Qwen3-0.6B --split test

D3 evaluates every ~250 M tokens and the curve is what decides whether to
extend the warm-up. A curve needs a zero: the pruned student's score
before any training, and the teacher's score as the ceiling. Both are
this, on held-out DialogSum in the format the task will use.

Perplexity over the summary tokens only. Perplexity over the whole
sequence is dominated by the dialogue, which neither model is being asked
to produce, and would move for reasons that have nothing to do with the
task.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse, math, os, torch


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default=os.path.expanduser("~/tc-ckpt/student-L18"))
    ap.add_argument("--tok", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--split", default="validation")
    ap.add_argument("--n", type=int, default=200)
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset

    dev = a.device if torch.cuda.is_available() else "cpu"
    tk = AutoTokenizer.from_pretrained(a.tok)
    m = AutoModelForCausalLM.from_pretrained(
        a.model, dtype=torch.float32).to(dev).eval()
    ds = load_dataset("knkarthick/dialogsum", split=a.split)

    nll, ntok, skipped = 0.0, 0, 0
    with torch.no_grad():
        for d, s in zip(ds["dialogue"][:a.n], ds["summary"][:a.n]):
            pre = tk(f"{d}\nSummary:", return_tensors="pt").input_ids
            full = tk(f"{d}\nSummary: {s}", return_tensors="pt").input_ids
            if full.shape[1] > 512:
                skipped += 1
                continue
            ids = full.to(dev)
            logits = m(ids).logits[0, :-1].float()
            tgt = ids[0, 1:]
            k = pre.shape[1] - 1          # score the summary only
            lp = torch.nn.functional.cross_entropy(
                logits[k:], tgt[k:], reduction="sum")
            nll += lp.item(); ntok += tgt[k:].numel()

    print(f"\n  {a.model}")
    print(f"  DialogSum {a.split}, {a.n - skipped} examples "
          f"({skipped} over 512 tokens, skipped)")
    print(f"  summary-only perplexity  {math.exp(nll/ntok):8.3f}   "
          f"({ntok} tokens)\n")


if __name__ == "__main__":
    main()
