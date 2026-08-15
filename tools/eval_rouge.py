#!/usr/bin/env python3
"""eval_rouge.py -- the success bar D1 wrote down and nobody has measured.

    python tools/eval_rouge.py --model Qwen/Qwen3-0.6B          # the floor
    python tools/eval_rouge.py --model ~/tc-ckpt/student-L28-seq
    python tools/eval_rouge.py --arch ~/tc-ckpt/student-L28-seq \\
        --state ~/tc-run/warmup/last.pt --quant

D1's exit criterion is "ROUGE-L on DialogSum test within 5% of the FP
teacher, measured on the same prompt format, teacher evaluated first so
the number is a floor recorded before any training". Everything since has
been scored on summary-token perplexity, which is the right thing to
watch during training and the wrong thing to ship against: perplexity
asks whether the model finds the reference summary likely, and the bar
asks whether the summary it actually writes is any good. A model can be
fluent and wrong.

So this generates. Greedy, deterministic, same prompt as eval_ppl.py --
"<dialogue>\\nSummary:" -- and the continuation is cut at the first blank
line, because a base model asked to summarize will happily invent the
next turn of the conversation and that is not part of the summary.

Three things it will not do:

  * It will not pick a favourable prompt. The format is the one the
    perplexity numbers were measured under and the one D4 will train on.
    Changing it later invalidates every number in the repo.
  * It will not sample. Temperature would make the score a distribution
    and the bar a coin flip.
  * It will not use the test split for anything but this. Validation is
    where the training loop looks.

--quant scores the ternary forward path rather than the shadow weights,
which is what the board runs. Without it you are measuring a model that
does not exist on any hardware here.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys

import torch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def clean(text):
    """First paragraph only, whitespace normalised."""
    for stop in ("\n\n", "\n#", "\nPerson", "\n1)", "\n-"):
        i = text.find(stop)
        if i > 0:
            text = text[:i]
    return " ".join(text.split())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="")
    ap.add_argument("--arch", default="",
                    help="architecture dir when --state is a converted ckpt")
    ap.add_argument("--state", default="",
                    help="a .pt from bitnet_surgery or warmup")
    ap.add_argument("--tok", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--split", default="test")
    ap.add_argument("--n", type=int, default=200)
    ap.add_argument("--maxnew", type=int, default=64)
    ap.add_argument("--quant", action="store_true")
    ap.add_argument("--chat", action="store_true",
                    help="ask via the chat template instead of a bare cue")
    ap.add_argument("--out", default="")
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset
    from rouge_score import rouge_scorer
    from bitnet_surgery import convert, set_quant

    dev = a.device if torch.cuda.is_available() else "cpu"
    tk = AutoTokenizer.from_pretrained(a.tok)

    src = a.model or a.arch
    m = AutoModelForCausalLM.from_pretrained(src, dtype=torch.float32)
    if a.state:
        convert(m)
        sd = torch.load(a.state, weights_only=False, map_location="cpu")
        m.load_state_dict(sd.get("model", sd), strict=True)
    m = m.to(dev).eval()
    if a.quant:
        set_quant(m, True)
    label = a.state or src

    ds = load_dataset("knkarthick/dialogsum", split=a.split)
    sc = rouge_scorer.RougeScorer(["rouge1", "rouge2", "rougeL"],
                                  use_stemmer=True)
    tot = {k: 0.0 for k in ("rouge1", "rouge2", "rougeL")}
    n, skipped, samples = 0, 0, []

    with torch.no_grad():
        for d, ref in zip(ds["dialogue"][:a.n], ds["summary"][:a.n]):
            #  A base model given "<dialogue>\nSummary:" does not
            #  summarise; it continues the document, and what it continues
            #  with is usually an instruction to somebody else to write a
            #  summary. The chat template is how you actually ask.
            if a.chat:
                msg = [{"role": "user", "content":
                        "Summarise the following dialogue in one short "
                        "paragraph.\n\n" + d}]
                txt = tk.apply_chat_template(msg, tokenize=False,
                                             add_generation_prompt=True,
                                             enable_thinking=False)
                ids = tk(txt, return_tensors="pt",
                         add_special_tokens=False).input_ids
            else:
                ids = tk(f"{d}\nSummary:", return_tensors="pt").input_ids
            if ids.shape[1] + a.maxnew > 512:
                skipped += 1
                continue
            out = m.generate(ids.to(dev), max_new_tokens=a.maxnew,
                             do_sample=False,
                             pad_token_id=tk.eos_token_id)
            hyp = clean(tk.decode(out[0, ids.shape[1]:],
                                  skip_special_tokens=True))
            s = sc.score(ref, hyp)
            for k in tot:
                tot[k] += s[k].fmeasure
            n += 1
            if len(samples) < 3:
                samples.append(dict(ref=ref, hyp=hyp,
                                    rougeL=s["rougeL"].fmeasure))

    print(f"\n  {label}{'  (ternary forward)' if a.quant else ''}")
    print(f"  DialogSum {a.split}, {n} generated, {skipped} too long "
          f"for 512 with {a.maxnew} new tokens")
    for k in ("rouge1", "rouge2", "rougeL"):
        print(f"  {k:<8} {tot[k]/n*100:7.3f}")
    print()
    for s in samples:
        print(f"  ref  {s['ref'][:96]}")
        print(f"  hyp  {s['hyp'][:96]}")
        print(f"       rouge-L {s['rougeL']*100:.1f}\n")

    if a.out:
        json.dump(dict(model=label, split=a.split, n=n, quant=a.quant,
                       **{k: tot[k] / n for k in tot}),
                  open(a.out, "w"), indent=1)
        print(f"  wrote {a.out}")


if __name__ == "__main__":
    main()
