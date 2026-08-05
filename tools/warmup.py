#!/usr/bin/env python3
"""warmup.py -- D3: quantization-aware continual pre-training.

    python tools/warmup.py
    python tools/warmup.py --resume ~/tc-run/warmup --tokens 2e9

D2 handed over a ternary student at 837,074 summary perplexity against a
full-precision ceiling of 209.6 and a teacher at 8.205. Nothing about
that is a surprise: BitNet has never worked without training through the
quantizer. This is that training.

Straight-through means the forward pass sees {-1,0,+1} and the backward
pass updates a full-precision shadow weight, so the model learns weights
that are *good after rounding* rather than weights that round badly. The
shadow weights are what gets checkpointed; the exporter snaps them the
same way BitLinear does, so what is measured here is what ships.

Loss is half language modelling and half distillation from the
unquantized teacher. The KD half is nearly free -- the teacher is 0.6 B
and already on the card -- and it gives the student a dense target at
every position instead of one-hot, which is the whole reason the
BitNet-distillation recipe converges faster than plain continual
pre-training.

Sequence length is 512 because the board's KV cache is KV_MAXP 512. That
is not a memory compromise, it is the deployment context: training on
longer sequences would teach the model to use positions the accelerator
cannot hold.

Memory discipline, because this shares a card with an inference server:
bf16 shadow weights, 8-bit AdamW, gradient checkpointing, micro-batch 1
with accumulation. If the card frees up, raise --micro; nothing else
needs to change and the effective batch stays the same.

Everything is resumable. One card means a crash costs days, so the step
counter, optimizer state and data cursor all go in the checkpoint, and
every eval point is appended to curve.jsonl rather than overwritten.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import math
import os
import sys
import time

import signal

import torch
import torch.nn.functional as F

#  fort shuts down cleanly when the UPS signals, which means SIGTERM
#  arrives with time to spare rather than the power simply going. Two
#  outages in an hour each cost every step since the last eval; catching
#  the signal costs one checkpoint write and loses nothing.
STOP = False


def _stop(sig, frame):
    global STOP
    STOP = True
    print("  SIGTERM: finishing this step, then checkpointing", flush=True)

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from bitnet_surgery import convert, set_quant, ppl


def stream_blocks(tok, seq, skip, corpus):
    """Endless 512-token blocks. Documents are packed, not padded.

    Padding a 0.6 B warm-up would waste a third of the run on <pad>, and
    the model never sees padding at inference either.
    """
    from datasets import load_dataset
    ds = load_dataset(corpus, name="sample-10BT", split="train",
                      streaming=True)
    buf, seen = [], 0
    while True:
        for rec in ds:
            ids = tok(rec["text"], add_special_tokens=False).input_ids
            buf.extend(ids + [tok.eos_token_id])
            while len(buf) >= seq:
                blk, buf = buf[:seq], buf[seq:]
                seen += 1
                if seen > skip:
                    yield torch.tensor(blk, dtype=torch.long)
        #  sample-10BT is 10 B tokens; a 2 B run never reaches here, but
        #  a longer one should wrap rather than stop.


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ckpt", default=os.path.expanduser("~/tc-ckpt/student-L28-seq-subln"))
    ap.add_argument("--arch", default=os.path.expanduser("~/tc-ckpt/student-L28-seq"))
    ap.add_argument("--teacher", default="Qwen/Qwen3-0.6B")
    ap.add_argument("--out", default=os.path.expanduser("~/tc-run/warmup"))
    ap.add_argument("--corpus", default="HuggingFaceFW/fineweb-edu")
    ap.add_argument("--tokens", type=float, default=1e9)
    ap.add_argument("--seq", type=int, default=512)
    ap.add_argument("--micro", type=int, default=1)
    ap.add_argument("--accum", type=int, default=32)
    ap.add_argument("--lr", type=float, default=1e-4)
    ap.add_argument("--warmup-steps", type=int, default=200)
    ap.add_argument("--kd", type=float, default=0.5)
    ap.add_argument("--eval-every", type=int, default=500)
    ap.add_argument("--evaln", type=int, default=100)
    ap.add_argument("--resume", action="store_true")
    ap.add_argument("--no-kd", action="store_true")
    ap.add_argument("--device", default="cuda")
    a = ap.parse_args()

    from transformers import AutoModelForCausalLM, AutoTokenizer
    from datasets import load_dataset
    import bitsandbytes as bnb

    dev = a.device if torch.cuda.is_available() else "cpu"
    os.makedirs(a.out, exist_ok=True)
    tok = AutoTokenizer.from_pretrained(a.teacher)

    #  The checkpoint was saved from a converted model, so build the same
    #  structure before loading it -- convert() is what makes the keys
    #  line up, and load_state_dict is strict on purpose.
    m = AutoModelForCausalLM.from_pretrained(a.arch, dtype=torch.float32)
    convert(m)
    sd = torch.load(os.path.join(a.ckpt, "pytorch_model.bin"),
                    weights_only=True, map_location="cpu")
    m.load_state_dict(sd, strict=True)
    m = m.to(dev, dtype=torch.bfloat16)
    set_quant(m, True)
    m.gradient_checkpointing_enable()
    m.config.use_cache = False
    m.train()

    t = None
    if not a.no_kd:
        t = AutoModelForCausalLM.from_pretrained(
            a.teacher, dtype=torch.bfloat16).to(dev).eval()
        for p in t.parameters():
            p.requires_grad_(False)

    opt = bnb.optim.AdamW8bit([p for p in m.parameters() if p.requires_grad],
                              lr=a.lr, betas=(0.9, 0.95), weight_decay=0.01)

    tok_per_step = a.micro * a.accum * a.seq
    total_steps = int(a.tokens / tok_per_step)
    step, done_tokens = 0, 0
    curve = os.path.join(a.out, "curve.jsonl")
    ck = os.path.join(a.out, "last.pt")
    if a.resume and os.path.exists(ck):
        st = torch.load(ck, weights_only=False, map_location="cpu")
        m.load_state_dict(st["model"])
        opt.load_state_dict(st["opt"])
        step, done_tokens = st["step"], st["tokens"]
        print(f"  resumed at step {step}, {done_tokens/1e6:.1f} M tokens")

    def lr_at(s):
        if s < a.warmup_steps:
            return a.lr * (s + 1) / a.warmup_steps
        p = (s - a.warmup_steps) / max(1, total_steps - a.warmup_steps)
        return a.lr * (0.1 + 0.9 * 0.5 * (1 + math.cos(math.pi * min(p, 1.0))))

    val = load_dataset("knkarthick/dialogsum", split="validation")
    src = stream_blocks(tok, a.seq, done_tokens // a.seq, a.corpus)

    print(f"  W1.58 A8 warm-up: {a.tokens/1e9:.2f} B tokens, seq {a.seq}, "
          f"{tok_per_step} tokens/step, {total_steps} steps")
    print(f"  loss = {1-a.kd:.2f} LM + {a.kd:.2f} KD"
          if not a.no_kd else "  loss = LM only")
    print(f"  starting perplexity is 837074.5; the ceiling is 209.6\n")

    signal.signal(signal.SIGTERM, _stop)
    signal.signal(signal.SIGINT, _stop)
    base_tok, base_step, last_lm = done_tokens, step, 0.0
    t0, lm_run, kd_run = time.time(), 0.0, 0.0
    while step < total_steps:
        for g in opt.param_groups:
            g["lr"] = lr_at(step)
        opt.zero_grad(set_to_none=True)
        for _ in range(a.accum):
            ids = torch.stack([next(src) for _ in range(a.micro)]).to(dev)
            #  Both halves of the loss come off one log-softmax. The
            #  vocabulary is 151936, so every full-precision copy of the
            #  logits is 311 MB at seq 512 and the naive spelling wanted
            #  five of them. LM is a gather rather than a reshape, and
            #  the KD term is cross-entropy to the teacher's
            #  distribution -- which differs from KL by the teacher's own
            #  entropy, a constant the student has no gradient through,
            #  so it is the same update for one fewer softmax.
            out = m(ids).logits
            ls = F.log_softmax(out.float(), -1)
            lm = -ls[:, :-1].gather(-1, ids[:, 1:, None]).mean()
            loss = lm
            kd = torch.zeros((), device=dev)
            if t is not None:
                with torch.no_grad():
                    pt = F.softmax(t(ids).logits.float(), -1).bfloat16()
                kd = -(ls * pt).sum(-1).mean()
                loss = (1 - a.kd) * lm + a.kd * kd
            (loss / a.accum).backward()
            lm_run += lm.item() / a.accum
            kd_run += float(kd) / a.accum
            del out, loss
        torch.nn.utils.clip_grad_norm_(m.parameters(), 1.0)
        opt.step()
        step += 1
        done_tokens += tok_per_step

        if step % 20 == 0:
            el = time.time() - t0
            print(f"  step {step:>6}/{total_steps}  {done_tokens/1e6:8.1f} M tok"
                  f"  lm {lm_run/20:6.3f}  kd {kd_run/20:6.3f}"
                  f"  lr {lr_at(step):.2e}  {(done_tokens-base_tok)/el/1e3:6.1f} k tok/s"
                  f"  eta {(total_steps-step)*el/max(1,step-base_step)/3600:5.1f} h", flush=True)
            last_lm = lm_run / 20
            lm_run = kd_run = 0.0

        if STOP:
            torch.save(dict(model=m.state_dict(), opt=opt.state_dict(),
                            step=step, tokens=done_tokens), ck)
            print(f"  checkpointed at step {step}, "
                  f"{done_tokens/1e6:.1f} M tokens -- resume with --resume",
                  flush=True)
            return

        if step % a.eval_every == 0 or step == total_steps:
            m.eval()
            m.config.use_cache = True
            with torch.no_grad():
                p = ppl(m, tok, val, a.evaln, dev)
            m.config.use_cache = False
            m.train()
            rec = dict(step=step, tokens=done_tokens, ppl=p,
                       lm=last_lm, hours=(time.time() - t0) / 3600)
            with open(curve, "a") as f:
                f.write(json.dumps(rec) + "\n")
            print(f"  === eval  step {step}  {done_tokens/1e6:.0f} M tokens"
                  f"  summary ppl {p:.3f}", flush=True)
            torch.save(dict(model=m.state_dict(), opt=opt.state_dict(),
                            step=step, tokens=done_tokens), ck)
            torch.save(m.state_dict(),
                       os.path.join(a.out, f"step{step:07d}.pt"))

    print(f"\n  done: {done_tokens/1e9:.2f} B tokens in "
          f"{(time.time()-t0)/3600:.1f} h")
    print(f"  curve in {curve}")


if __name__ == "__main__":
    main()
