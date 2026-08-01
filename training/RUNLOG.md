# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss |
| 2026-07-31 ~22:47 | smoke_train | seq1024 b2 a8 | 13.89→3.6 (D3 loop proven); blackout #1 |
| 2026-08-01 02:10–07:31 | warm-up (2 attempts + resume) | 124.2 M-tok wikitext-103 | **D3: eval loss 3.474** (vs teacher 3.318); blackout #2 survived |
| 2026-08-01 ~10:05–11:15 | d4_sst2 ft+distill | logit-KD T=2 α=0.5 | teacher 75.57→94.38; **student 60.67→91.17 — SST-2 BAR MET** |
| 2026-08-01 ~13:30–14:10 | d4_glue sst2 r2 | + attention-relation KD | **91.40%** (96.8% of teacher) — r2 is the release ckpt |
| 2026-08-01 ~13:5x | d4_glue mnli ft | 1 ep | teacher zero-shot 35.48 → fine-tuned **88.21%** (OOM-in-eval postmortem: save-before-eval fix; ckpt recovery via promote stage) |
| 2026-08-01 15:35–19:45 | d4_glue mnli distill (run 1) | 2 ep, b12, logit-KD; blackout #3 mid-run, warm-resume | **student 35.15 → 81.94%** = 92.9% of teacher. **Bar (≥83.8%) MISSED by 1.9 pts → iteration triggered** |
| 2026-08-01 19:5x | **mnli distill run 2 (RUNNING)** | 3 ep fresh (98,175 steps, ~5.7 h), logit-KD | overnight; step-accurate blackout resume active |

## D4 scoreboard

| Task | FT teacher | Ternary student | Ratio | Bar (≥95%) |
|---|---|---|---|---|
| SST-2 | 94.38% | **91.40%** | 96.8% | ✅ MET |
| MNLI (run 1) | 88.21% | 81.94% | 92.9% | ❌ → run 2 in flight |

Analysis of the MNLI miss: 3-way entailment starts from chance (35%) unlike
SST-2 (61%), and 2 epochs after a 100 M-token warm-up (paper uses 10 B) is
likely undertrained — loss was still improving at cutoff. Run 2 = 3 epochs,
single clean schedule. Candidates if still short: attention-relation KD,
longer warm-up top-up, α/T sweep.

## D5 cross-reference (branch feat/d5-arty, PR #15)

Silicon verification of the SST-2 student: **56/56 single-tile layers
exact-match** (22.3 min sweep) + **all 7 projection shapes of block 0 exact
via host tiling** (column tiles + depth-chunk accumulation, 5.9 min) — all
196 projections of the model computable on the Arty. `training/D5-SILICON.md`.
