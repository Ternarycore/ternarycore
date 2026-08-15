#!/usr/bin/env python3
"""distil.py -- D4: the task, from a teacher that can actually do it.

    python tools/distil.py --student ~/tc-run/warmup/last.pt
    python tools/distil.py --alpha 0.3 --temp 2.0 --epochs 3

D3 restores general language modelling under the quantizer on web text.
It does not teach summarization, and the DialogSum perplexity it reports
along the way is measured on a prompt the stock teacher could not even
follow. This is where the task arrives.

The teacher is ~/tc-ckpt/teacher-sft, not Qwen3-0.6B. That distinction is
the whole reason this step exists in the shape it does: on the bare
"<dialogue>\\nSummary:" cue the stock model scores ROUGE-L 10.07 and
writes "Please write a summary of the memo in a formal, concise, and
professional manner" every single time. Distillation copies whatever the
teacher does, so distilling from it would have taught the student to ask
for a summary instead of writing one, and every loss curve would have
looked healthy while it happened. tools/sft_teacher.py fixed that: 35.16
ROUGE-L on the same cue, which is the number this student is chasing.

Loss is a blend on the summary tokens only:

    alpha * CE(student, reference) + (1 - alpha) * T^2 * KL(teacher || student)

The T^2 is the usual Hinton scaling -- soft targets shrink the gradient by
1/T^2 and without it the temperature silently doubles as a learning-rate
knob. The dialogue is prompt, not target: teaching the student to predict
it is teaching the wrong job on four fifths of the tokens.

The student is the ternary one, quantizers live, straight-through. What
trains is the shadow weight and what the loss sees is {-1,0,+1}, so the
model learns weights that are good *after* rounding. The exporter snaps
them the same way BitLinear does, which is what makes the eval number and
the board number the same number.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import math
import os
import signal
import sys
import time

import torch
import torch.nn.functional as F

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from bitnet_surgery import convert, set_quant

STOP = False


def _stop(sig, frame):
    global STOP
    STOP = True
    print("  SIGTERM: finishing this step, then checkpointing", flush=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arch", default=os.path.expanduser("~/tc-ckpt/student-L28-seq"))
    ap.add_argument("--student", default=os.path.expanduser("~/tc-run/warmup/last.pt"))
    ap.add_argument("--teacher", default=os.path.expanduser("~/tc-ckpt/teacher-sft"))
    ap.add_argument("--tok", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--out", default=os.path.expanduser("~/tc-run/distil"))
    ap.add_argument("--epochs", type=int, default=3)
    ap.add_argument("--accum", type=int, default=16)
    ap.add_argument("--lr", type=float, default=2e-5)
    ap.add_argument("--warmup-steps", type=int, default=50)
    ap.add_argument("--alpha", type=float, default=0.3,
                    help="weight on the hard reference; 1-alpha goes to KD")
    ap.add_argument("--temp", type=float, default=2.0)
    ap.add_argument("--maxlen", type=int, default=512)
    ap.add_argument("--evaln", type=int, default=200)
    ap.add_argument("--eval-every", type=int, default=150)
    ap.add_argument("--resume", action="store_true")
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset
    import bitsandbytes as bnb

    signal.signal(signal.SIGTERM, _stop)
    signal.signal(signal.SIGINT, _stop)
    dev = a.device if torch.cuda.is_available() else "cpu"
    os.makedirs(a.out, exist_ok=True)
    tk = AutoTokenizer.from_pretrained(a.tok)

    s = AutoModelForCausalLM.from_pretrained(a.arch, dtype=torch.float32)
    convert(s)
    sd = torch.load(a.student, weights_only=False, map_location="cpu")
    s.load_state_dict(sd.get("model", sd), strict=True)
    s = s.to(dev, dtype=torch.bfloat16)
    set_quant(s, True)
    s.gradient_checkpointing_enable()
    s.config.use_cache = False
    s.train()

    t = AutoModelForCausalLM.from_pretrained(
        a.teacher, dtype=torch.bfloat16).to(dev).eval()
    for p in t.parameters():
        p.requires_grad_(False)

    tr = load_dataset("knkarthick/dialogsum", split="train")
    va = load_dataset("knkarthick/dialogsum", split="validation")

    def pack(d, x):
        pre = tk(f"{d}\nSummary:", add_special_tokens=False).input_ids
        full = tk(f"{d}\nSummary: {x}", add_special_tokens=False).input_ids
        full = full + [tk.eos_token_id]
        return (torch.tensor(full), len(pre)) if len(full) <= a.maxlen else None

    train = [z for z in (pack(d, x) for d, x in
                         zip(tr["dialogue"], tr["summary"])) if z]
    val = [z for z in (pack(d, x) for d, x in
                       zip(va["dialogue"][:a.evaln], va["summary"][:a.evaln]))
           if z]
    print(f"  {len(train)} train, {len(val)} val")
    print(f"  teacher {a.teacher}")
    print(f"  loss = {a.alpha:.2f} CE + {1-a.alpha:.2f} KD at T={a.temp}\n")

    opt = bnb.optim.AdamW8bit(s.parameters(), lr=a.lr, betas=(0.9, 0.95),
                              weight_decay=0.01)
    total = a.epochs * len(train) // a.accum
    step, ep0 = 0, 0
    ck = os.path.join(a.out, "last.pt")
    curve = os.path.join(a.out, "curve.jsonl")
    if a.resume and os.path.exists(ck):
        st = torch.load(ck, weights_only=False, map_location="cpu")
        s.load_state_dict(st["model"])
        opt.load_state_dict(st["opt"])
        step, ep0 = st["step"], st["epoch"]
        print(f"  resumed at step {step}, epoch {ep0}")

    def lr_at(n):
        if n < a.warmup_steps:
            return a.lr * (n + 1) / a.warmup_steps
        p = (n - a.warmup_steps) / max(1, total - a.warmup_steps)
        return a.lr * (0.1 + 0.9 * 0.5 * (1 + math.cos(math.pi * min(p, 1.0))))

    def losses(ids, k):
        """(CE, KD) on the summary tokens. One log-softmax, two readers."""
        ids = ids.unsqueeze(0).to(dev)
        #  Keep the raw logits: temperature scales logits, not log-probs,
        #  and log_softmax(log_softmax(x)/T) is a different function that
        #  happens to run without complaining.
        lg = s(ids).logits[:, k - 1:-1].float()
        tgt = ids[:, k:]
        ce = -F.log_softmax(lg, -1).gather(-1, tgt.unsqueeze(-1)).mean()
        with torch.no_grad():
            pt = F.softmax(t(ids).logits[:, k - 1:-1].float() / a.temp, -1)
        #  KL(teacher || student) up to the teacher's own entropy, which
        #  the student has no gradient through. T^2 restores the gradient
        #  scale soft targets divide away.
        kd = -(pt * F.log_softmax(lg / a.temp, -1)).sum(-1).mean() * a.temp ** 2
        return ce, kd

    def val_ppl():
        s.eval()
        n, tot = 0, 0.0
        with torch.no_grad():
            for ids, k in val:
                ce, _ = losses(ids, k)
                tot += float(ce) * (len(ids) - k)
                n += len(ids) - k
        s.train()
        return math.exp(tot / n)

    print(f"  validation summary perplexity before D4: {val_ppl():.3f}\n")
    g = torch.Generator().manual_seed(0)
    t0, rc, rk = time.time(), 0.0, 0.0
    for ep in range(ep0, a.epochs):
        order = torch.randperm(len(train), generator=g).tolist()
        for n in range(0, len(order) - a.accum + 1, a.accum):
            for j in order[n:n + a.accum]:
                ids, k = train[j]
                ce, kd = losses(ids, k)
                ((a.alpha * ce + (1 - a.alpha) * kd) / a.accum).backward()
                rc += float(ce) / a.accum
                rk += float(kd) / a.accum
            torch.nn.utils.clip_grad_norm_(s.parameters(), 1.0)
            for pg in opt.param_groups:
                pg["lr"] = lr_at(step)
            opt.step()
            opt.zero_grad(set_to_none=True)
            step += 1
            if step % 25 == 0:
                el = time.time() - t0
                print(f"  ep {ep} step {step:>5}/{total}  ce {rc/25:6.3f}"
                      f"  kd {rk/25:7.3f}  lr {lr_at(step):.2e}"
                      f"  eta {(total-step)*el/max(1,step)/60:5.1f} min",
                      flush=True)
                rc = rk = 0.0
            if step % a.eval_every == 0 or step == total or STOP:
                p = val_ppl()
                with open(curve, "a") as f:
                    f.write(json.dumps(dict(step=step, epoch=ep, ppl=p,
                                            hours=(time.time()-t0)/3600)) + "\n")
                print(f"  === step {step}  validation summary ppl {p:.3f}",
                      flush=True)
                torch.save(dict(model=s.state_dict(), opt=opt.state_dict(),
                                step=step, epoch=ep), ck)
                torch.save(s.state_dict(),
                           os.path.join(a.out, f"step{step:06d}.pt"))
                if STOP:
                    print(f"  checkpointed at step {step} -- --resume")
                    return

    print(f"\n  wrote {a.out}")
    print(f"  now: python tools/eval_rouge.py --arch {a.arch} \\")
    print(f"         --state {ck} --quant --n 200")
    print(f"  the bar is ROUGE-L within 5% of the teacher's 35.16, so 33.4.")


if __name__ == "__main__":
    main()
