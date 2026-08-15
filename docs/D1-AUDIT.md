# D1 — teacher audit and task lock

`docs/DISTILLATION_PLAN.md` makes D1 a hard gate: no training until the
shapes clear the constraints. This is that gate, and it is reproducible —
`python tools/d1_audit.py` prints everything below from the shapes.

The plan's own constraints table is not the constraint. It asks for
hidden dims that are multiples of 64, which is the array's `COLS`
tiling. The real rule is that **both** dimensions of every projection
have to be whole 1024-tiles, because the array is 1024 wide and 1024 deep
and the exporter packs `GROUPS = out/4`. A shape can pass the table and
be unexportable. That is how a week went on `q_proj`.

## Verdict

**Qwen3-0.6B clears the gate.** Every projection tiles:

| layer | out | in | pages | re-pack at export? |
|---|---:|---:|---:|---|
| q_proj | 2048 | 1024 | 2 | **yes** — 2 slices |
| k_proj | 1024 | 1024 | 1 | no |
| v_proj | 1024 | 1024 | 1 | no |
| o_proj | 1024 | 2048 | 2 | no |
| gate_proj | 3072 | 1024 | 3 | **yes** — 3 slices |
| up_proj | 3072 | 1024 | 3 | **yes** — 3 slices |
| down_proj | 1024 | 3072 | 3 | no |

15 pages a block, 420 pages, 110.1 MB — which is exactly what is resident
in DDR today, so the audit is checked against a machine and not only
against arithmetic.

**The proposed student clears it too.** L18, H1024, I2048, 8q/8kv at
head_dim 128: 188.7 M ternary, 47.2 MB, 180 pages, and only `gate_proj`
and `up_proj` need re-packing. Predicted 1843 ms/token at context 512,
2.43× the current student.

Three shapes that look better and are unexportable are recorded in
`shape_budget.REJECTED` so nobody proposes them twice: H=768, intermediate
2560, and 4 kv heads at head_dim 128 — the standard modern GQA ratio,
which gives 512-wide `k_proj` and half a tile.

## What changes in the firmware

Not much, and all of it is arithmetic the exporter already does:

- **`SLOTS` goes from 15 to 10.** The firmware addresses a page as
  `blk*15 + slot`. 15 is not a constant of nature; it is the number of
  pages one block's seven projections need at the current shape.
  `tools/pages.json` carries the same number.
- **The image shrinks from 0x06900000 to 0x02D00000.** The current image
  fills its allocation exactly, which nobody has had headroom to notice.
- **`KV_MAXP` stays 512** and the cache shrinks from 29.4 MB to 18.9 MB,
  because it scales with depth.

Nothing in the datapath, the loader, the pager or the block driver
changes. A new student is a new `weights.bin`, a new `meta.bin` and one
constant.

## The finding that actually decides D2

The plan assumes the student **is** the teacher: insert SubLN, ternarize
in place, distil. That holds only if every tensor maps. At the proposed
shape it does not:

| | |
|---|---|
| embedding and tied lm_head | identical |
| every RMSNorm and SubLN gain | identical |
| k_proj, v_proj | identical, per surviving block |
| q_proj, o_proj | choose 8 of 16 query heads |
| gate, up, down | choose 2048 of 3072 MLP channels |
| the blocks themselves | choose 18 of 28 layers |

So the proposed student is a **structurally pruned** teacher, and D2
needs a head-, channel- and layer-selection step that arXiv:2510.13998
does not cover. The distillation after it is unchanged; the
initialisation is not. This is the decision D1 exists to force:

**Plan A — paper-faithful.** Student = teacher shape. SubLN surgery,
ternarize in place, distil. Lowest risk, matches the published recipe
step for step, and the board stays at 4640 ms/token.

**Plan B — shaped.** Prune to L18/I2048/8q first, then the same recipe.
2.43× on the board and 2.33× the warm-up tokens for the same GPU-hours —
which matters because `DISTILLATION_PLAN` already cut D3 from the paper's
10 B tokens to 1–2 B on the grounds that one card made it a fortnight. At
the smaller shape the same fortnight buys 4–5 B.

Plan B costs one step the paper does not describe, and structured pruning
followed by distillation is well-trodden ground elsewhere. The risk is
real and it is a training risk, not a hardware one — the hardware side of
Plan B is audited above and is smaller in every dimension.

## Task lock

**DialogSum**, dialogue summarization — the plan's second candidate and
the paper's other demonstrated task family. Measured under the teacher's
own tokenizer rather than assumed:

| split | n | dialogue mean | p95 | summary mean | input+summary ≤ 512 |
|---|---:|---:|---:|---:|---:|
| train | 12460 | 193.5 | 360 | 34.6 | **98.1%** |
| validation | 500 | 191.1 | 351 | 32.4 | 98.6% |
| test | 1500 | 198.3 | 363 | 27.8 | 98.4% |

The 512-position KV cache is the binding constraint on any summarization
corpus here, and it eliminates the obvious choices: CNN/DailyMail (which
is what the paper used), XSum, BillSum, Multi-News, arXiv and PubMed are
all too long. DialogSum fits 98% of examples with no truncation at all;
at 384 positions it still fits 92%.

It also replaces the demo. The current student is an SST-2 classifier, so
the only demonstration of *generation* is a classifier repeating one
word. A summarizer reads a paragraph and writes a sentence, which is the
same hardware claim in a form that survives being shown to someone.

**Licences.** DialogSum is permissive; SAMSum, the obvious alternative
with the same shape, is CC BY-NC-ND 4.0 — non-commercial and no
derivatives — which is incompatible with releasing distilled weights
alongside CERN-OHL-S hardware. The teacher, Qwen3-0.6B, is Apache-2.0.

## Success bar

Two gates, and the second one already exists.

1. **ROUGE-L on DialogSum test within 5% of the FP teacher**, measured on
   the same prompt format, teacher evaluated first so the number is a
   floor recorded before any training.
2. **The board reproduces the host reference exactly** — `bash
   tools/regress.sh` green, which already checks the resident image, the
   operators, a block at four positions, a generated sequence against the
   float64 model, and the image again afterwards.

The second gate is the one this project can already enforce and the one
that makes a model swap a low-risk operation rather than a week.

## Exit

The gate is passed for both shapes. What is not decided is Plan A against
Plan B, and that is a training-budget question rather than a hardware
one — the hardware answer is in the table above and it favours B by
2.43×.
