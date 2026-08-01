#!/usr/bin/env python3
"""D4 generalized: GLUE task distillation (SST-2, MNLI) with optional
MiniLM-style attention-relation KD (last decoder layer).

  --task sst2|mnli  --stage ft|distill|promote  [--attn_kd] [--epochs N] [--lr X]

ft      -> ~/tc-ckpt/teacher-<task>.pt
distill -> ~/tc-ckpt/d4-student-<task><-r2 if attn_kd>.pt  (from warmup-final.pt)
promote -> recover: teacher-<task>-ckpt.pt (periodic save) -> teacher-<task>.pt + eval

Post-OOM fixes: eval uses B=4 for mnli + empty_cache; weights are saved
BEFORE the final eval so an eval crash can never lose a trained model.
"""
import argparse, os, time
import torch
import torch.nn.functional as F
from transformers import AutoModelForCausalLM, AutoTokenizer
from datasets import load_dataset
import bitlinear
from surgery import build_student, TEACHER

CKPT = os.path.expanduser("~/tc-ckpt")

TASKS = {
    "sst2": dict(
        load=("glue", "sst2"), val="validation", maxlen=128,
        labels=[" negative", " positive"],
        prompt=lambda r: f"Review: {r['sentence'].strip()}\nSentiment:"),
    "mnli": dict(
        load=("glue", "mnli"), val="validation_matched", maxlen=192,
        labels=[" yes", " maybe", " no"],   # entailment / neutral / contradiction
        prompt=lambda r: (f"Premise: {r['premise'].strip()}\n"
                          f"Hypothesis: {r['hypothesis'].strip()}\nAnswer:")),
}

p = argparse.ArgumentParser()
p.add_argument("--task", required=True, choices=list(TASKS))
p.add_argument("--stage", required=True, choices=["ft", "distill", "promote"])
p.add_argument("--attn_kd", action="store_true")
p.add_argument("--epochs", type=int, default=0)
p.add_argument("--lr", type=float, default=0.0)
p.add_argument("--batch", type=int, default=0)
p.add_argument("--temp", type=float, default=2.0)
p.add_argument("--alpha", type=float, default=0.5)
p.add_argument("--beta", type=float, default=1.0)   # attn-KD weight
args = p.parse_args()
T_ = TASKS[args.task]

tok = AutoTokenizer.from_pretrained(TEACHER)
if tok.pad_token is None:
    tok.pad_token = tok.eos_token
LABEL_IDS = [tok(l, add_special_tokens=False).input_ids for l in T_["labels"]]
ATTN_IMPL = "eager" if args.attn_kd else "sdpa"


def encode(row, label=None):
    pids = tok(T_["prompt"](row), truncation=True,
               max_length=T_["maxlen"] - 6).input_ids
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
def accuracy(model):
    ds = load_dataset(*T_["load"], split=T_["val"])
    model.eval(); correct = 0
    torch.cuda.empty_cache()
    B = 4 if args.task == "mnli" else 16
    nl = len(T_["labels"])
    for i in range(0, len(ds), B):
        rows = ds.select(range(i, min(i + B, len(ds))))
        batch = [encode(r, c) for r in rows for c in range(nl)]
        ids, lab, att = collate(batch)
        out = model(ids, attention_mask=att).logits[:, :-1]
        tgt = lab[:, 1:]
        lp = -F.cross_entropy(out.reshape(-1, out.size(-1)),
                              tgt.reshape(-1).clamp(min=0),
                              reduction="none").view(tgt.shape)
        lp = (lp * (tgt != -100)).sum(-1).view(-1, nl)
        correct += (lp.argmax(-1).cpu() == torch.tensor(rows["label"])).sum().item()
    model.train()
    return correct / len(ds)


def train_loop(model, teacher, epochs, lr, bsz, tag):
    import bitsandbytes as bnb
    ds = load_dataset(*T_["load"], split="train").shuffle(seed=0)
    data = [encode(r, r["label"]) for r in ds]
    opt = bnb.optim.AdamW8bit(model.parameters(), lr=lr, weight_decay=0.01)
    steps = (len(data) // bsz) * epochs
    sched = torch.optim.lr_scheduler.CosineAnnealingLR(opt, T_max=steps)
    t0, step = time.time(), 0
    for ep in range(epochs):
        for i in range(0, len(data) - bsz, bsz):
            ids, lab, att = collate(data[i:i + bsz])
            s_out = model(ids, attention_mask=att,
                          output_attentions=args.attn_kd)
            out = s_out.logits[:, :-1]
            tgt = lab[:, 1:]
            mask = tgt != -100
            ce = F.cross_entropy(out[mask], tgt[mask])
            loss = ce
            if teacher is not None:
                with torch.no_grad():
                    t_out = teacher(ids, attention_mask=att,
                                    output_attentions=args.attn_kd)
                Tk = args.temp
                kd = F.kl_div(F.log_softmax(out[mask] / Tk, -1),
                              F.softmax(t_out.logits[:, :-1][mask] / Tk, -1),
                              reduction="batchmean") * Tk * Tk
                loss = args.alpha * ce + (1 - args.alpha) * kd
                if args.attn_kd:
                    sa = s_out.attentions[-1].clamp_min(1e-9)
                    ta = t_out.attentions[-1].clamp_min(1e-9)
                    rel = (ta * (ta.log() - sa.log())).sum(-1)   # [B,H,L]
                    qm = att[:, None, :].float()
                    loss = loss + args.beta * (rel * qm).sum() / qm.sum() / rel.size(1)
            opt.zero_grad(set_to_none=True); loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            opt.step(); sched.step(); step += 1
            if step % 200 == 0:
                print(f"MARK {tag} ep{ep} step {step}/{steps} loss {loss.item():.4f} "
                      f"({(time.time()-t0)/step:.2f}s/step)", flush=True)
            if step % 2000 == 0:
                torch.save(model.state_dict(), os.path.join(CKPT, f"{tag}-ckpt.pt"))


if args.stage == "ft":
    model = AutoModelForCausalLM.from_pretrained(
        TEACHER, dtype=torch.bfloat16, attn_implementation="sdpa").cuda()
    print(f"[{args.task}-ft] teacher zero-shot: {accuracy(model):.4f}", flush=True)
    train_loop(model, None, args.epochs or 1, args.lr or 2e-5,
               args.batch or 16, f"teacher-{args.task}")
    torch.save(model.state_dict(), os.path.join(CKPT, f"teacher-{args.task}.pt"))
    print(f"[{args.task}-ft] teacher fine-tuned: {accuracy(model):.4f}", flush=True)
    print(f"[{args.task}-ft] DONE", flush=True)

elif args.stage == "promote":
    model = AutoModelForCausalLM.from_pretrained(
        TEACHER, dtype=torch.bfloat16, attn_implementation="sdpa").cuda()
    src = os.path.join(CKPT, f"teacher-{args.task}-ckpt.pt")
    model.load_state_dict(torch.load(src, map_location="cuda"))
    torch.save(model.state_dict(), os.path.join(CKPT, f"teacher-{args.task}.pt"))
    print(f"[{args.task}-promote] recovered {src}", flush=True)
    print(f"[{args.task}-ft] teacher fine-tuned: {accuracy(model):.4f}", flush=True)
    print(f"[{args.task}-promote] DONE", flush=True)

else:
    teacher = AutoModelForCausalLM.from_pretrained(
        TEACHER, dtype=torch.bfloat16, attn_implementation=ATTN_IMPL).cuda()
    teacher.load_state_dict(torch.load(
        os.path.join(CKPT, f"teacher-{args.task}.pt"), map_location="cuda"))
    teacher.eval()
    student = AutoModelForCausalLM.from_pretrained(
        TEACHER, dtype=torch.bfloat16, attn_implementation=ATTN_IMPL).cuda()
    student = build_student(student)
    student.load_state_dict(torch.load(
        os.path.join(CKPT, "warmup-final.pt"), map_location="cuda"))
    bitlinear.QUANT["enabled"] = True
    student.gradient_checkpointing_enable()
    print(f"[{args.task}] student PRE-distill: {accuracy(student):.4f}", flush=True)
    suffix = "-r2" if args.attn_kd else ""
    train_loop(student, teacher, args.epochs or 2, args.lr or 5e-5,
               args.batch or (8 if args.attn_kd else 16), f"d4-{args.task}{suffix}")
    torch.save(student.state_dict(),
               os.path.join(CKPT, f"d4-student-{args.task}{suffix}.pt"))
    print(f"[{args.task}] student POST-distill{suffix}: {accuracy(student):.4f}", flush=True)
    print(f"[{args.task}] DONE", flush=True)
