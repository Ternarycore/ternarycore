#!/usr/bin/env python3
"""D3 warm-up (overnight scale): QAT on wikitext-103, resumable.

- Pre-tokenizes the corpus once to ~/tc-data/wt103.pt (batched fast-tokenizer
  path; the naive single-string call stalls for hours).
- Alternating crash-safe checkpoints (warmup-a.pt / warmup-b.pt) + step file.
- Resumes from the newest of: warmup ckpts, smoke-last.pt, student-init.pt.

Usage: python warmup_train.py [--tokens 100000000] [--seq 1024] [--batch 2]
                              [--accum 8] [--lr 2e-4]
"""
import argparse, os, time, glob
import numpy as np
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
import bitlinear
from surgery import build_student, eval_loss, TEACHER

p = argparse.ArgumentParser()
p.add_argument("--tokens", type=float, default=100e6)
p.add_argument("--seq", type=int, default=1024)
p.add_argument("--batch", type=int, default=2)
p.add_argument("--accum", type=int, default=8)
p.add_argument("--lr", type=float, default=2e-4)
args = p.parse_args()

CKPT = os.path.expanduser("~/tc-ckpt")
DATA = os.path.expanduser("~/tc-data")
os.makedirs(CKPT, exist_ok=True); os.makedirs(DATA, exist_ok=True)

tok = AutoTokenizer.from_pretrained(TEACHER)

ids_path = os.path.join(DATA, "wt103.pt")
if os.path.exists(ids_path):
    ids = torch.load(ids_path)
else:
    from datasets import load_dataset
    print("[warmup] tokenizing wikitext-103 (batched, one-time)...", flush=True)
    texts = [t for t in load_dataset("wikitext", "wikitext-103-raw-v1",
                                      split="train")["text"] if t.strip()]
    parts, B = [], 20000
    t0 = time.time()
    for i in range(0, len(texts), B):
        enc = tok(texts[i:i + B], add_special_tokens=False)["input_ids"]
        parts.append(np.concatenate([np.asarray(s, dtype=np.int32)
                                     for s in enc if s]))
        if (i // B) % 10 == 0:
            print(f"[warmup] tokenized {i}/{len(texts)} docs "
                  f"({time.time()-t0:.0f}s)", flush=True)
    ids = torch.from_numpy(np.concatenate(parts))
    torch.save(ids, ids_path)
print(f"[warmup] corpus: {ids.numel()/1e6:.1f} M tokens", flush=True)

model = AutoModelForCausalLM.from_pretrained(TEACHER, dtype=torch.bfloat16).cuda()
model = build_student(model)

start_step = 0
stepf = os.path.join(CKPT, "warmup-step.txt")
cands = sorted(glob.glob(os.path.join(CKPT, "warmup-[ab].pt")),
               key=os.path.getmtime, reverse=True)
for c in cands + [os.path.join(CKPT, "smoke-last.pt"),
                  os.path.join(CKPT, "student-init.pt")]:
    if os.path.exists(c):
        try:
            model.load_state_dict(torch.load(c, map_location="cuda"))
            if "warmup-" in c and os.path.exists(stepf):
                start_step = int(open(stepf).read().strip())
            print(f"[warmup] resumed from {c} (step {start_step})", flush=True)
            break
        except Exception as e:
            print(f"[warmup] {c} unusable ({e}); trying next", flush=True)

model.gradient_checkpointing_enable(); model.train()
bitlinear.QUANT["enabled"] = True

tok_per_step = args.accum * args.batch * args.seq
total_steps = int(args.tokens // tok_per_step)
import bitsandbytes as bnb
opt = bnb.optim.AdamW8bit(model.parameters(), lr=args.lr, weight_decay=0.01)
warm = 100
import math
sched = torch.optim.lr_scheduler.LambdaLR(
    opt, lambda s: min((s + 1) / warm, 1.0) * 0.5 *
    (1 + math.cos(min(s, total_steps) / total_steps * math.pi)))

print(f"[warmup] {total_steps} steps x {tok_per_step} tok "
      f"({args.tokens/1e6:.0f} M target), resuming at {start_step}", flush=True)

span = args.seq * args.batch
limit = ids.numel() - span - 1
t0, flip = time.time(), 0
for step in range(start_step, total_steps):
    opt.zero_grad(set_to_none=True)
    loss_acc = 0.0
    for a in range(args.accum):
        s = ((step * args.accum + a) * span) % limit
        x = ids[s:s + span].to(torch.long).view(args.batch, args.seq).cuda()
        loss = model(x, labels=x).loss / args.accum
        loss.backward(); loss_acc += loss.item()
    torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
    opt.step(); sched.step()
    if step % 25 == 0:
        done = (step - start_step + 1) * tok_per_step
        rate = done / max(time.time() - t0, 1)
        print(f"MARK step {step}/{total_steps} loss {loss_acc:.4f} "
              f"lr {sched.get_last_lr()[0]:.2e} tok/s {rate:.0f} "
              f"eta_h {(total_steps-step)*tok_per_step/rate/3600:.1f}", flush=True)
    if step and step % 250 == 0:
        pth = os.path.join(CKPT, f"warmup-{'ab'[flip]}.pt"); flip ^= 1
        torch.save(model.state_dict(), pth)
        open(stepf, "w").write(str(step))
        print(f"[warmup] ckpt {pth} @ step {step}", flush=True)

torch.save(model.state_dict(), os.path.join(CKPT, "warmup-final.pt"))
open(stepf, "w").write(str(total_steps))
print(f"[warmup] final eval loss: {eval_loss(model, tok):.4f}", flush=True)
print("[warmup] DONE", flush=True)
