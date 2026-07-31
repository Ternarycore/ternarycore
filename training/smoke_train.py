#!/usr/bin/env python3
"""Smoke QAT warm-up: prove the D3 training loop end-to-end on the 5070 Ti.
NOT the real warm-up — short, wikitext-2, just enough to see loss descend.

Usage: python smoke_train.py [--steps 300] [--seq 512] [--batch 1]
                             [--accum 16] [--lr 1e-4] [--init ~/tc-ckpt/student-init.pt]
"""
import argparse, os, time
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from datasets import load_dataset
import bitlinear
from surgery import build_student, eval_loss, TEACHER

p = argparse.ArgumentParser()
p.add_argument("--steps", type=int, default=300)
p.add_argument("--seq", type=int, default=512)
p.add_argument("--batch", type=int, default=1)
p.add_argument("--accum", type=int, default=16)
p.add_argument("--lr", type=float, default=1e-4)
p.add_argument("--init", default=os.path.expanduser("~/tc-ckpt/student-init.pt"))
args = p.parse_args()

tok = AutoTokenizer.from_pretrained(TEACHER)
model = AutoModelForCausalLM.from_pretrained(TEACHER, dtype=torch.bfloat16).cuda()
model = build_student(model)
if os.path.exists(args.init):
    model.load_state_dict(torch.load(args.init, map_location="cuda"))
    print(f"[smoke] loaded {args.init}", flush=True)
model.gradient_checkpointing_enable()
model.train()
bitlinear.QUANT["enabled"] = True

text = "\n\n".join(load_dataset("wikitext", "wikitext-2-raw-v1", split="train")["text"])
ids = tok(text, return_tensors="pt").input_ids[0]
print(f"[smoke] corpus tokens: {ids.numel()/1e6:.1f} M", flush=True)

try:
    import bitsandbytes as bnb
    opt = bnb.optim.AdamW8bit(model.parameters(), lr=args.lr, weight_decay=0.01)
    print("[smoke] AdamW8bit", flush=True)
except Exception as e:
    opt = torch.optim.AdamW(model.parameters(), lr=args.lr, weight_decay=0.01)
    print(f"[smoke] fp AdamW (bnb unavailable: {e})", flush=True)
sched = torch.optim.lr_scheduler.CosineAnnealingLR(opt, T_max=args.steps)

def batch_at(step):
    span = args.seq * args.batch
    start = (step * span) % (ids.numel() - span - 1)
    x = ids[start:start + span].view(args.batch, args.seq).cuda()
    return x

t0 = time.time()
for step in range(args.steps):
    opt.zero_grad(set_to_none=True)
    for a in range(args.accum):
        x = batch_at(step * args.accum + a)
        loss = model(x, labels=x).loss / args.accum
        loss.backward()
    torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
    opt.step(); sched.step()
    if step % 10 == 0 or step == args.steps - 1:
        toks = (step + 1) * args.accum * args.batch * args.seq
        print(f"MARK step {step} loss {loss.item()*args.accum:.4f} "
              f"toks {toks/1e6:.2f}M elapsed {time.time()-t0:.0f}s", flush=True)
    if step and step % 100 == 0:
        torch.save(model.state_dict(), os.path.expanduser("~/tc-ckpt/smoke-last.pt"))

torch.save(model.state_dict(), os.path.expanduser("~/tc-ckpt/smoke-final.pt"))
print(f"[smoke] final eval loss: {eval_loss(model, tok, seq=args.seq):.4f}", flush=True)
print("[smoke] DONE", flush=True)
