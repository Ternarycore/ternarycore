# Distillation for Hardware People — A Beginner's Guide

> Companion to `docs/DISTILLATION_PLAN.md`. That document says *what* we're
> doing; this one explains what any of it *means*. You've brought up silicon
> that three simulators said was fine — training a model is easier than that.
> It's one loop, run many times, on one machine you already own.

---

## 1. The whole idea in three paragraphs

A neural network is a giant pile of numbers called **weights** — the same
numbers you've been packing into BRAM, just before anyone rounded them to
−1/0/+1. "Training" means starting with weights that produce garbage and
nudging them, millions of times, until they produce something useful. That's
it. Everything else is vocabulary.

**Distillation** is training with a cheat code. Instead of teaching a model
from raw text alone, you sit a small **student** model next to a big,
already-trained **teacher** model, show them both the same text, and nudge
the student's weights toward *whatever the teacher does*. The student doesn't
just learn "the next word is 'cat'" — it learns the teacher's full opinion
("80% cat, 15% dog, 5% ferret"), which carries far more information per
example. That's why a small model distilled from a good teacher beats the
same small model trained alone.

Our twist: while the student learns, we force its weights to live in
{−1, 0, +1} — the same ternary constraint your MAC cells implement. The
student learns *around* the constraint, so by the end, snapping every weight
to a trit costs almost nothing in accuracy. The result is a checkpoint that
is native food for TernaryCore. The teacher stays full-precision the whole
time; only the student is ternary.

## 2. The words you'll keep hearing

| Word | What it actually means |
|---|---|
| **Checkpoint** | The weights, saved to disk. `bitnet_b1_58-large` is a checkpoint. Your output is a checkpoint. |
| **Token** | ~¾ of a word. Models read and write tokens. "1 B tokens of training" = the model has read ~750 M words. |
| **Loss** | One number measuring how wrong the model currently is. Training = making this number go down. You will stare at this curve a lot. |
| **Backpropagation** | The algorithm that answers "which direction should I nudge each weight to reduce the loss?" You never implement it; PyTorch does it when you call `.backward()`. |
| **Learning rate (LR)** | Nudge size. Too big → model explodes (loss shoots up). Too small → nothing happens. Recipes (like the BitNet paper's) tell you what to use. |
| **Batch** | How many text snippets you process per nudge. Bigger = smoother but more VRAM. |
| **Epoch / steps** | One pass over the data / one nudge. Mostly you count tokens instead. |
| **VRAM** | The GPU's 16 GB. The hard wall. Weights + gradients + optimizer state must all fit. |
| **Fine-tuning** | Training that *starts from* a good checkpoint instead of random numbers. Everything we do is fine-tuning-scale. |
| **Pretraining** | Training from scratch on trillions of tokens. Costs millions of dollars. **We never do this.** |
| **QAT** (quantization-aware training) | Training while the quantization (our ternary snap) is applied, so the model adapts to it — instead of quantizing after training and hoping. |
| **STE** (straight-through estimator) | The one weird trick that makes QAT work: forward pass uses the snapped ternary weights, but the nudges are applied to a hidden full-precision "shadow copy". Rounding has no useful gradient, so we pretend it isn't there. The shadow weights drift; the snap follows. |
| **Perplexity** | Eval score for "how surprised is the model by real text". Lower = better. |
| **Eval / benchmark** | A fixed test set (multiple-choice questions, summaries to write) that gives a score. Our success bar is a score, decided before training. |
| **SubLN** | An extra normalization layer the BitNet papers insert before projections. Ternary weights make activation magnitudes jumpy; SubLN calms them. It's ~20 lines of model surgery. |
| **KD (knowledge distillation)** | The teacher-student copying described above. "Logit KD" = copy the teacher's word-probabilities. "Attention-relation KD" = also copy *where the teacher looks* in the sentence. We use both, per the paper. |
| **Unsloth** | A library that makes fine-tuning faster and lighter on VRAM. You already installed it on fort. Useful for the FP sanity fine-tune (D2); our custom ternary QAT (D3/D4) will be plain PyTorch/HF because Unsloth doesn't know about trits. |

## 3. What "doing training" physically looks like

Demystified: you write (or adapt) one Python script containing a loop —

```
for batch in data:
    out    = student(batch)          # forward: like your testbench stimulus
    loss   = wrongness(out, teacher) # compare: like checking against NumPy
    loss.backward()                  # PyTorch computes all the nudges
    optimizer.step()                 # apply the nudges
```

— then you run it and **walk away**. The GPU chugs for hours or days. Your
job is the same as watching a Vivado build: check the loss curve now and
then, make sure it's trending down, kill it if it explodes, and keep
checkpoints so a crash doesn't cost the run. The skill is not in the loop —
it's in what you feed it and how you measure it, which is exactly the
discipline you already have from hardware verification: reference outputs,
exact comparisons, one variable at a time.

## 4. The plan's phases, retold in plain language

- **D0 — set up the kitchen, taste the existing dishes.** Install the
  tools, load the models everyone else made, and *measure* them on the
  tests we'll use. No training. This gives us the floor (the existing
  1bitLLM model) and the ceiling (the teacher). If we can't reproduce
  published numbers, we stop and fix that first — same rule as a hardware
  smoke test before a benchmark.
- **D1 — pick the recipe and the exam.** Choose the teacher model, check
  its layer shapes fit the accelerator (your constraint table), and decide
  what the final model is *for* — before spending a GPU-hour. Deciding the
  eval before training is the ML version of writing the testbench before
  the RTL.
- **D2 — minor surgery.** Insert SubLN into the teacher's architecture, do
  a short ordinary fine-tune (this is where Unsloth shines), and confirm
  the patient survived: scores unchanged. Still full-precision.
- **D3 — let it get used to ternary.** Turn on the ternary snap (QAT with
  STE) and train on ordinary text for 1–2 B tokens. The loss jumps when the
  snap turns on, then recovers as the model adapts. This is the long
  unattended GPU run — kick it off and go do MIG bring-up.
- **D4 — the actual distillation.** Teacher and student side by side on the
  chosen task; copy probabilities and attention patterns. Runs take hours,
  so this is the tinkering phase — the fun one.
- **D5 — onto the board.** Export the checkpoint with our packing tool,
  verify layer-by-layer on the Arty exactly like Stage-1, then generate
  tokens from *our* model. Closed loop.

## 5. Getting started on fort tonight (this IS D0)

Everything below is copy-paste-able and safe — no training, just setup and
inference. The GPU work is light; it can run while Vivado builds.

```bash
# 0. sanity: GPU visible?
nvidia-smi        # expect: RTX 5070 Ti, 16 GB, some idle wattage

# 1. a clean environment for the training track (separate from unsloth's)
python3 -m venv ~/tc-train && source ~/tc-train/bin/activate
pip install --upgrade pip
pip install torch --index-url https://download.pytorch.org/whl/cu128   # Blackwell needs cu128
pip install transformers accelerate datasets safetensors sentencepiece
pip install lm-eval bitsandbytes

# 2. does PyTorch see the card?
python -c "import torch; print(torch.cuda.get_device_name(0), torch.cuda.is_available())"

# 3. taste dish #1: the existing ternary model (the floor)
python - <<'EOF'
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
m = "1bitLLM/bitnet_b1_58-large"          # already cached on fort from Stage-1
tok = AutoTokenizer.from_pretrained(m)
model = AutoModelForCausalLM.from_pretrained(m, torch_dtype=torch.float16).cuda()
x = tok("The key idea of ternary computing is", return_tensors="pt").to("cuda")
print(tok.decode(model.generate(**x, max_new_tokens=40)[0]))
EOF

# 4. taste dish #2: the teacher candidate (the ceiling)
#    swap the model id in the same snippet for: Qwen/Qwen3-0.6B

# 5. first eval numbers (quick versions — ~minutes each)
lm_eval --model hf --model_args pretrained=1bitLLM/bitnet_b1_58-large,dtype=float16 \
        --tasks arc_easy,hellaswag --limit 200 --device cuda:0
lm_eval --model hf --model_args pretrained=Qwen/Qwen3-0.6B,dtype=float16 \
        --tasks arc_easy,hellaswag --limit 200 --device cuda:0
```

When both eval commands print score tables, **D0 is essentially done** —
commit the numbers to the repo and you have your floor and ceiling. If
anything version-fights (Blackwell + PyTorch can be finicky), that's normal
yak-shaving, not a sign you're out of your depth.

**What NOT to do yet:** no training scripts, no datasets, no LR choices.
D1 (picking the task and auditing Qwen's shapes) is a reading-and-deciding
phase — good laptop work, no GPU needed.

## 6. Learning while the GPU chugs

You don't need to understand backprop's calculus to run this plan, same as
you didn't need transistor physics to close timing. But two resources map
almost 1:1 onto what you'll be doing, in order of payoff:

1. **Karpathy, *Neural Networks: Zero to Hero*** (free videos) — he builds
   the training loop from scratch on screen. Watch the first two parts and
   §3 above stops being magic. The GPT video is optional dessert.
2. **d2l.ai** — the attention/transformer chapters you were already going to
   read; now also skim the "fine-tuning" chapter.
3. The **BitNet Distillation paper** (in your reading-list downloads) —
   reread it *after* Karpathy part 1. It will feel 10× shorter.

## 7. Kickoff brief for the new fort session

Paste this into the fresh Claude session on fort-silicon:

> We're starting phase D0 of TernaryCore's distillation plan
> (`docs/DISTILLATION_PLAN.md` in Ternarycore/ternarycore, beginner guide in
> `docs/DISTILLATION_GUIDE.md`). This machine has the RTX 5070 Ti and a
> working CUDA driver; Unsloth is installed in a separate env. Tasks, in
> order: (1) create the `~/tc-train` venv per the guide §5 and install the
> pinned stack (torch cu128, transformers, accelerate, datasets, lm-eval,
> bitsandbytes); (2) verify CUDA; (3) run inference sanity on
> `1bitLLM/bitnet_b1_58-large` (cached) and `Qwen/Qwen3-0.6B`; (4) run the
> two quick lm-eval commands and save both score tables; (5) write
> `training/requirements.txt` and `training/D0-results.md` with the numbers
> and exact versions, and commit to a `feat/distillation` branch. Do NOT
> start any training. If PyTorch/Blackwell versions fight, resolve with
> pinned nightlies and record what worked.

That brief keeps the new session scoped to D0 — cheap, safe, and finished in
an evening — while this session keeps driving the hardware track.

---

*TernaryCore — companion to `docs/DISTILLATION_PLAN.md`. If a term isn't in
the glossary and a step isn't in §5, it isn't needed yet.*
