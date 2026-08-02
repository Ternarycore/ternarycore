# D1 — Teacher audit & task lock (2026-07-31, autonomous overnight decision)

> Decided per plan §D1. User can veto/amend in the morning — nothing below
> is expensive to change yet.

## Teacher: Qwen/Qwen3-0.6B — PASSES the hardware audit

| Constraint | Requirement | Qwen3-0.6B | Verdict |
|---|---|---|---|
| Params (packed ≤ ~175 MB) | ≤ ~700 M | 596 M (proj ≈ 440 M ternary → ~110 MB packed; embeddings FP/int8, tied) | ✅ |
| hidden_size ÷ 64 | yes | 1024 = 16×64 | ✅ |
| FFN dim ÷ 64 | yes | 3072 = 48×64 | ✅ |
| Attn inner dim ÷ 64 | yes | 16 heads × 128 = 2048 = 32×64 (GQA 8 KV heads) | ✅ |
| Vanilla ops only | attn + RMSNorm + RoPE | standard Qwen3 (adds q/k norm — RMSNorm, fine) | ✅ |
| License | permissive | Apache-2.0 | ✅ |

28 layers × 7 projections = 196 ternary GEMMs, every one tile-able by the
COLS=64 array. `head_dim=128` and GQA change nothing for the weight-layer
datapath (activation-domain concerns only).

## Task lock (v1)

- **Primary: text classification** — SST-2 (binary sentiment) + MNLI
  (3-class entailment), i.e. the BitNet-Distillation paper's own GLUE picks,
  giving us published numbers to compare against directly.
- **Stretch: summarization** — CNN/DailyMail, ROUGE-L, only after both
  classification bars are met.
- **Success bar: student ≥ 95% of the task-fine-tuned FP teacher's accuracy**
  on SST-2 and MNLI (matched eval prompts, 0-shot classification head style
  per the paper).
- Rationale: matching the paper isolates "did our pipeline work" from "is
  our task too hard"; a bespoke FPGA/EE-QA model is deferred to v2 where it
  becomes a demo asset rather than a validation risk.

## Eval discipline

- Floor/ceiling D0 numbers recorded in `D0-results.md` (limit-200); full
  runs get frozen the first time a training claim depends on them.
- Every training run logs: config hash, dataset + token count, wall-clock,
  final eval — appended to `training/RUNLOG.md`.

## D1 exit

- [x] Teacher audited against constraints table — pass
- [x] Task + evals + success bar locked
- [x] License check (Apache-2.0 teacher → permissive student release OK)
- Next: D2 surgery (see `surgery.py`) → smoke run → real D3 warm-up decision
  in the morning.
