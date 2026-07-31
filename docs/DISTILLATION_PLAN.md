# Distilled Model Plan — TernaryCore's Own Small BitNet

> **Goal:** produce our own ~0.6–1 B-parameter ternary (W1.58, A8) checkpoint
> — distilled from an open full-precision teacher on a single RTX 5070 Ti —
> that drops unmodified into the Arty `LOADM` pipeline (see
> `docs/DESKTOP_INFERENCE_PLAN.md`). The closed loop: **a model we made,
> running on hardware we made.**
>
> **Recipe basis:** *BitNet Distillation* (Wu et al., arXiv:2510.13998) —
> SubLN insertion → continual pre-training warm-up → dual distillation
> (logit KD + MiniLM-style attention-relation KD). This is
> fine-tuning-scale compute, not pretraining-scale; that is what makes a
> single 16 GB card viable.
>
> **Independence:** nothing in the hardware roadmap or P1 paper gates on
> this plan. `1bitLLM/bitnet_b1_58-large` remains the model of record until
> our checkpoint beats it at its job.

---

## 1. Design constraints the hardware imposes on the model

The model is not free-form — it must be a good citizen of the accelerator
and the board:

| Constraint | Source | Consequence for model choice |
|---|---|---|
| ≤ ~700 M params (~175 MB packed) | 256 MB DDR3 minus KV/heap | Student in the 0.6–1 B class; 1 B is borderline — 0.6 B is the safe first target |
| Hidden dims multiple of 64 | COLS=64 array tiling | Prefer architectures with 1024/1536/2048-class hidden sizes (all ÷64) |
| Weight layers ternary, activations int8 | ternary datapath + absmax quant | W1.58A8 QAT with straight-through estimator, per the BitNet recipe |
| Attention/norms in software | MicroBlaze / int8 path | Vanilla attention + RMSNorm + RoPE only — no exotic ops (no MLA, no sliding-window tricks) in v1 |
| Tokenizer on desktop | desktop-inference plan | Any HF-standard tokenizer is fine |

**Teacher shortlist (open weights, permissive license, sane architecture):**
Qwen3-0.6B / Qwen3-1.7B (Apache-2.0) are the paper's own demonstration
targets and the default choice; Llama-3.2-1B is the fallback if Qwen's
architecture fights the SubLN surgery. Decide in Phase D1 after a
layer-shape audit — the student inherits the teacher's architecture, so the
teacher must already satisfy the table above.

## 2. Compute reality on one RTX 5070 Ti (16 GB)

- **Fits:** 0.6 B student in bf16 + 8-bit optimizer + gradient checkpointing
  leaves headroom for the teacher run in eval mode (or cached teacher
  logits — see D4). A 1.7 B student is possible only with aggressive
  checkpointing and offload; treat it as the stretch goal, not the plan.
- **Warm-up throughput estimate:** ~10–15 k tok/s for 0.6 B at seq 2048 →
  **1 B tokens ≈ 1–2 days** of continuous GPU. The paper's warm-up is ~10 B
  tokens; on one card that is ~2 weeks of wall-clock. We start at 1–2 B
  tokens and scale only if evals demand it — warm-up exists to let the
  ternarized weights settle, and diminishing returns arrive early at this
  model scale.
- **Distillation stage:** task-data scale (millions–tens of millions of
  tokens) → hours per run. This is where iteration happens, so cheap runs
  here is exactly the right shape.
- **What is out of reach:** a general-purpose chat model pretrained from
  scratch. Not attempted. The product is a *task-specialized* small ternary
  model — the paper shows task-specific distillation is precisely where
  ternary students recover teacher-level accuracy.

**Task target for v1 (pick one, do it well):** instruction-following on a
narrow domain we can demo on the Arty — e.g. FPGA/EE Q&A, or
text-classification/summarization of a public benchmark (the paper uses
classification + summarization; matching it gives us a published baseline to
compare against). Decision point at D1 with evals chosen *before* training.

## 3. Phases

### D0 — Rig + reproducibility floor *(days)*

- Environment on the 5070 Ti box: PyTorch nightly-stable for Blackwell,
  `transformers`, `lm-eval-harness`, W&B or plain CSV logging; pin
  everything in a `requirements.txt` in-repo.
- Reproduce **inference** of `1bitLLM/bitnet_b1_58-large` and the teacher;
  run the chosen evals on both. These numbers are the floor and the ceiling
  of the whole effort, measured before any training.
- Extend `tools/prep_bitnet_layer.py` into `tools/export_checkpoint.py`:
  any HF ternary checkpoint → absmean ternarize → 2-bit pack → `LOADM`
  binary + NumPy reference. Test it on bitnet_b1_58-large (already proven
  at layer level).

**Exit:** eval table (teacher / 1bitLLM baseline) committed; export tool
round-trips a full model.

### D1 — Teacher audit + task lock *(days, overlaps D0)*

- Layer-shape audit of Qwen3-0.6B vs the hardware-constraints table.
- Lock the v1 task + eval suite + success bar (e.g. "≥95% of teacher
  accuracy on the chosen task", the paper's headline result shape).
- License check for redistribution of the distilled weights (Apache-2.0
  teacher → we can publish the student under a permissive license alongside
  the CERN-OHL-S hardware).

**Exit:** one page in-repo: teacher, task, evals, bar. No training yet.

### D2 — SubLN surgery + FP sanity *(days)*

- Insert SubLN (pre-projection normalization) into the teacher architecture
  per the paper; brief FP16 fine-tune to confirm the surgery didn't lobotomize
  the model (evals within noise of the unmodified teacher).
- This modified-but-still-FP model is the initialization for D3.

**Exit:** SubLN model ≈ teacher on evals; checkpoint saved.

### D3 — Continual pre-training warm-up (W1.58A8 QAT) *(1–2 weeks GPU time)*

- Ternarize weight layers with absmean + straight-through estimator;
  int8 activations; train on general corpus (FineWeb-Edu subset or the
  paper's mix) for **1–2 B tokens** first.
- Eval every ~250 M tokens; the curve tells us whether to extend toward the
  paper's 10 B. Checkpoint discipline: keep every eval point; training on
  one card means a crash costs days.
- VRAM playbook if 0.6 B is tight: 8-bit AdamW → gradient checkpointing →
  shorter seq (1024) → micro-batch 1 + accumulation, in that order.

**Exit:** warmed-up ternary student whose perplexity has plateaued;
gap-to-teacher measured and logged.

### D4 — Dual distillation on the task *(days per run; the iteration loop)*

- Logit KD (KL at temperature) + MiniLM-style attention-relation KD from the
  FP teacher, on task data. If teacher+student don't fit VRAM together,
  precompute and cache teacher logits/relations to disk (the task corpus is
  small — this is cheap and makes runs teacher-free).
- Iterate: loss weights, temperature, data mix. Each run is hours, so this
  is where the 5070 Ti earns its keep.
- **Success bar from D1** decides when to stop.

**Exit:** ternary student hits the bar on held-out evals; final checkpoint
frozen and pushed to HF under the TernaryCore org.

### D5 — Onto the silicon *(days; joins the desktop-inference plan)*

- `tools/export_checkpoint.py` on the final student → `LOADM` image.
- Layer-level exact-match verification on the Arty (same Stage-1 discipline:
  board vs NumPy on every weight matrix of a block).
- End-to-end: the desktop-inference pipeline (its Phase 4/5) generating
  tokens **from our own model**. Measure tok/s and — with the shunt —
  energy/token on both bitnet_b1_58-large and ours.

**Exit:** the demo: our distilled model, our datapath, our board, tokens on
the desktop. Article-06 and the thesis's closed-loop chapter.

## 4. Schedule

```
D0 rig ─┬─► D2 SubLN ─► D3 warm-up ─► D4 distill ─► D5 silicon
D1 audit┘   (days)       (1–2 wk GPU)   (days/run,     (days)
(days)                                   1–2 wk iter)
```

**Calendar estimate: 4–6 weeks part-time**, dominated by D3 GPU-hours (which
run unattended) and D4 iteration. Fully parallel to the desktop-inference
hardware phases — different machine, different bottleneck. D5 needs the
hardware plan through its Phase 2 (DDR3) at minimum, which the hardware
track will reach in a similar timeframe.

| Milestone | Publishable artifact |
|---|---|
| D0/D1 | Reading-list payoff: reproduction of published BitNet evals (blog-worthy on its own) |
| D3 | Warm-up curves: how fast ternary students settle at 0.6 B (data nobody shows for small models) |
| D4 | The checkpoint on HF + eval table vs teacher + vs 1bitLLM baseline |
| D5 | Closed-loop demo video; thesis chapter; Article-06 |

## 5. Risks

| # | Risk | Mitigation |
|---|---|---|
| 1 | STE/QAT instability at 0.6 B | Paper's LR schedule as starting point; warm-up from SubLN-FP init (never from scratch); frequent checkpoints |
| 2 | 16 GB VRAM wall | 0.6 B first (not 1.7 B); 8-bit optimizer; cached teacher outputs in D4 |
| 3 | Warm-up needs the full 10 B tokens | Accept the ~2-week GPU run — it is unattended; or rent a single cloud GPU-week for D3 only (~$50–100) and keep D4 iteration local |
| 4 | Student misses the bar on the chosen task | Task was chosen to match the paper's demonstrated wins (classification/summarization); fall back to the easier of the two |
| 5 | Teacher architecture fights the accelerator (odd head dims, fused ops) | D1 audit is a hard gate — no training until shapes clear the constraints table |
| 6 | Scope creep toward "general chat model" | The plan's one-task rule; general capability is explicitly a non-goal for v1 |

## 6. Non-goals (v1)

- No from-scratch pretraining; no >1 B students; no general-purpose chat.
- No multi-GPU or cluster dependency — the whole recipe must run on the one
  5070 Ti (with at most one rented GPU-week as a pressure valve).
- No new hardware ops for the model's sake — the model bends to the
  datapath, not the reverse (that discipline is the thesis).

---

*TernaryCore — CERN-OHL-S v2 (hardware); distilled weights to be released
under a permissive license alongside. Companion to
`docs/DESKTOP_INFERENCE_PLAN.md`; recipe per arXiv:2510.13998 (in the
reading-list downloads). Drafted 2026-07-31.*
