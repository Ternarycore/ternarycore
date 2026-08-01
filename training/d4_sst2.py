#!/usr/bin/env python3
"""D4 task distillation on SST-2 (per D1-decision.md).

Stages:
  --stage ft       fine-tune the FP teacher on SST-2   -> ~/tc-ckpt/teacher-sst2.pt
  --stage distill  distill into the warmed-up ternary student
                   (CE + logit-KD from the task teacher) -> ~/tc-ckpt/d4-student-sst2.pt

Classification is generative: 'Review: <s>\nSentiment:' -> ' positive'/' negative',
scored by candidate log-likelihood, so the same LM path deploys to the Arty.
Run 1 uses logit KD only; attention-relation KD is the run-2 option.
"""
import argparse, os, time
import torch
import torch.nn.functional as F
from transformers import AutoModelForCausalLM, AutoTokenizer
from datasets import load_dataset
import bitlinear
from surgery import build_student, TEACHER

CKPT = os.path.expanduser("~/tc-ckpt")
LABELS = [" negative", " positive"]
PROMPT = "Review: {s}\nSentiment:"
MAXLEN = 128

p = argparse.ArgumentParser()
p.add_argument("--stage", required=True, choices=["ft", "distill"])
p.add_argument("--epochs", type=int, default=0)  # 0 = stage default
p.add_argument("--lr", type=float, default=0.0)
p.add_argument("--temp", type=float, default=2.0)
p.add_argument("--alpha", type=float, default=0.5)  # CE weight; (1-a)=KD
args = p.parse_args()

tok = AutoTokenizer.from_pretrained(TEACHER)
if tok.pad_token is None:
    tok.pad_token = tok.eos_token
LABEL_IDS = [tok(l, add_special_tokens=False).input_ids for l in LABELS]


def encode(sentence, label=None):
    pids = tok(PROMPT.format(s=sentence.strip()), truncation=True,
               max_length=MAXLEN - 4).input_ids
    if label is None:
        return pids
    lids = LABEL_IDS[label]
    return pids + lids, [-100] * len(pids) + lids


def collate(batch):
    maxlen = max(len(x) for x, _ in batch)
    pad = tok.pad_token_id
    ids = torch.full((len(batch), maxlen), pad, dtype=torch.long)
    lab = torch.full((len(batch), maxlen), -100, dtype=torch.long)
    att = torch.zeros((len(batch), maxlen), dtype=torch.long)
    for i, (x, y) in enumerate(batch):
        ids[i, :len(x)] = torch.tensor(x); lab[i, :len(y)] = torch.tensor(y)
        att[i, :len(x)] = 1
    return ids.cuda(), lab.cuda(), att.cuda()


@torch.no_grad()
def accuracy(model, split="validation", limit=None):
    ds = load_dataset("glue", "sst2", split=split)
    if limit: ds = ds.select(range(limit))
    model.eval(); correct = 0
    B = 16
    for i in range(0, len(ds), B):
        rows = ds.select(range(i, min(i + B, len(ds))))
        batch = []
        for r in rows:
            for c in range(len(LABELS)):
                batch.append(encode(r["sentence"], c))
        ids, lab, att = collate(batch)
        out = model(ids, attention_mask=att).logits[:, :-1]
        tgt = lab[:, 1:]
        lp = -F.cross_entropy(out.reshape(-1, out.size(-1)), tgt.reshape(-1).clamp(min=0),
                              reduction="none").view(tgt.shape)
        lp = (lp * (tgt != -100)).sum(-1).view(-1, len(LABELS))
        pred = lp.argmax(-1).cpu()
        gold = torch.tensor(rows["label"])
        correct += (pred == gold).sum().item()
    model.train()
    return correct / len(ds)


def train_loop(model, teacher, epochs, lr, tag):
    import bitsandbytes as bnb
    ds = load_dataset("glue", "sst2", split="train").shuffle(seed=0)
    data = [encode(r["sentence"], r["label"]) for r in ds]
    opt = bnb.optim.AdamW8bit(model.parameters(), lr=lr, weight_decay=0.01)
    steps = (len(data) // 16) * epochs
    sched = torch.optim.lr_scheduler.CosineAnnealingLR(opt, T_max=steps)
    t0, step = time.time(), 0
    for ep in range(epochs):
        for i in range(0, len(data) - 16, 16):
            ids, lab, att = collate(data[i:i + 16])
            out = model(ids, attention_mask=att).logits[:, :-1]
            tgt = lab[:, 1:]
            mask = tgt != -100
            ce = F.cross_entropy(out[mask], tgt[mask])
            loss = ce
            if teacher is not None:
                with torch.no_grad():
                    tl = teacher(ids, attention_mask=att).logits[:, :-1][mask]
                T = args.temp
                kd = F.kl_div(F.log_softmax(out[mask] / T, -1),
                              F.softmax(tl / T, -1), reduction="batchmean") * T * T
                loss = args.alpha * ce + (1 - args.alpha) * kd
            opt.zero_grad(set_to_none=True); loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            opt.step(); sched.step(); step += 1
            if step % 100 == 0:
                print(f"MARK {tag} ep{ep} step {step}/{steps} loss {loss.item():.4f} "
                      f"({(time.time()-t0)/step:.2f}s/step)", flush=True)
            if step % 1000 == 0:
                torch.save(model.state_dict(), os.path.join(CKPT, f"{tag}-ckpt.pt"))


if args.stage == "ft":
    model = AutoModelForCausalLM.from_pretrained(TEACHER, dtype=torch.bfloat16).cuda()
    print(f"[d4-ft] teacher zero-shot dev acc: {accuracy(model):.4f}", flush=True)
    train_loop(model, None, args.epochs or 1, args.lr or 2e-5, "teacher-sst2")
    acc = accuracy(model)
    print(f"[d4-ft] teacher fine-tuned dev acc: {acc:.4f}", flush=True)
    torch.save(model.state_dict(), os.path.join(CKPT, "teacher-sst2.pt"))
    print("[d4-ft] DONE", flush=True)

elif args.stage == "distill":
    teacher = AutoModelForCausalLM.from_pretrained(TEACHER, dtype=torch.bfloat16).cuda()
    teacher.load_state_dict(torch.load(os.path.join(CKPT, "teacher-sst2.pt"),
                                       map_location="cuda"))
    teacher.eval()
    student = AutoModelForCausalLM.from_pretrained(TEACHER, dtype=torch.bfloat16).cuda()
    student = build_student(student)
    student.load_state_dict(torch.load(os.path.join(CKPT, "warmup-final.pt"),
                                       map_location="cuda"))
    bitlinear.QUANT["enabled"] = True
    student.gradient_checkpointing_enable()
    print(f"[d4] ternary student PRE-distill dev acc: {accuracy(student):.4f}", flush=True)
    train_loop(student, teacher, args.epochs or 2, args.lr or 5e-5, "d4-student")
    acc = accuracy(student)
    print(f"[d4] ternary student POST-distill dev acc: {acc:.4f}", flush=True)
    torch.save(student.state_dict(), os.path.join(CKPT, "d4-student-sst2.pt"))
    print("[d4] DONE", flush=True)
""""""
