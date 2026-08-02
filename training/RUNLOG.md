# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss |
| 2026-07-31 ~22:47 | smoke_train | seq1024 b2 a8 | 13.89→3.6 (D3 loop proven); blackout #1 |
| 2026-08-01 02:10–07:31 | warm-up | 124.2 M-tok wikitext-103 | **D3: eval loss 3.474**; blackout #2 survived |
| 2026-08-01 ~10:05–14:10 | d4 sst2 (runs 1+2) | logit-KD; +attn-KD in r2 | teacher 94.38; student **91.17 → 91.40 (r2)** — **BAR MET** (96.8% of teacher) |
| 2026-08-01 ~13:5x | mnli teacher ft | 1 ep | zero-shot 35.48 → **88.21%** |
| 2026-08-01 15:35–19:45 | mnli distill run 1 | 2 ep b12 | 81.94% (92.9% of teacher) — bar missed |
| 2026-08-01 19:55–0x:xx | mnli distill run 2 | 3 ep fresh, b12→OOM→b10; blackouts #4, #5 mid-run, step-accurate resumes worked | **82.77%** (93.8% of teacher) — bar (83.8%) missed by 1.0 pt; 3rd epoch bought +0.8 |
| 2026-08-02 01:40 | **mnli distill run 3 (RUNNING)** | + attention-relation KD, 3 ep, b8, ~12 h | next lever per plan; if short: warm-up top-up 100 M tokens, then α/T sweep |

## D4 scoreboard

| Task | FT teacher | Ternary student | Ratio | Bar (≥95%) |
|---|---|---|---|---|
| SST-2 | 94.38% | **91.40%** | 96.8% | ✅ MET |
| MNLI | 88.21% | 82.77% (run 2) | 93.8% | ⏳ run 3 in flight |

Trend: 81.94 → 82.77 with +1 epoch. Gap analysis unchanged: 3-way
entailment from a 100 M-token warm-up (paper: 10 B) is base-knowledge
limited; if attn-KD run 3 lands short of the bar, the warm-up top-up is
the root-cause lever, not more distillation epochs.

## Infrastructure note (2026-08-01 night)

APC Back-UPS BX750MI + `tools/fort-ups-setup.sh` deployed: on-battery →
40 s grace → suspend-to-RAM → RTC self-wake every 8 min → auto-resume on
mains. Blackouts should now cost ~0 s of training (post-reboot for full
NVIDIA S3 support). Blackout counter this project: 5.

## D5 cross-reference (feat/d5-arty, PR #15)

56/56 single-tile layers + all 7 projection shapes of block 0 exact-match
on Arty silicon. `training/D5-SILICON.md`.
