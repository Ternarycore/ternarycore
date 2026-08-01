# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss — init saved |
| 2026-07-31 ~22:47 | smoke_train 400st | seq1024 b2 a8 lr1e-4 | 13.89→3.6–4.0 by step 280 (~5.9 k tok/s). Killed by blackout #1. **D3 loop proven.** |
| 2026-08-01 00:14–02:00 | warmup attempts 1–3 | — | tokenizer stall + pkill-footgun postmortems (see file history). |
| 2026-08-01 02:10–07:31 | warmup attempts 4–5 | 124.2 M-tok wikitext-103, resume across blackout #2 | **D3 COMPLETE: final eval loss 3.474** (teacher 3.318 / FP-SubLN 6.903 / pre-warm-up 14.238). ~4.5 h effective GPU. LR-schedule resume bug noted for next run. |
| 2026-08-01 ~10:05–11:15 | **d4_sst2.py ft + distill** | teacher FT: 1 ep, lr 2e-5, 4209 steps @0.09 s/step. Distill: 2 ep, 8418 steps @0.16 s/step, CE+logit-KD T=2 α=0.5, ternary QUANT on | **D4 SST-2 COMPLETE — see below** |

## D4 SST-2 — FINAL RESULT (2026-08-01 ~11:15 UTC)

| Model | SST-2 dev accuracy |
|---|---|
| FP teacher, zero-shot | 75.57% |
| FP teacher, task fine-tuned | 94.38% |
| Ternary student (post-warm-up), pre-distill | 60.67% |
| **Ternary student, post-distill** | **91.17%** |

**Success bar (D1-decision.md): ≥95% of the fine-tuned teacher = ≥89.66%.**
**Achieved: 91.17% = 96.6% of teacher — BAR MET on the first run**, logit-KD
only (no attention-relation KD yet), ~70 min total GPU for both stages.
Checkpoints: `teacher-sst2.pt`, `d4-student-sst2.pt`.

Upside still on the table for run 2 (optional): attention-relation KD,
LR-schedule fix, longer distill, α/T sweep — target 92–93%.

### The complete closed loop, measured in one 13-hour window

Qwen3-0.6B (FP teacher) → SubLN surgery → 100 M-token QAT warm-up
(eval loss 14.24→3.47) → SST-2 logit distillation → **596 M-param ternary
{−1,0,+1} model at 91.2% SST-2**, produced entirely on one locally owned
RTX 5070 Ti through two mains blackouts. Every weight in every projection
is a trit — native food for the TernaryCore datapath.

**Next:** (a) optional run 2 for +1–2 pts; (b) MNLI second task per D1;
(c) D5 export path: `export_checkpoint.py` (extend prep_bitnet_layer.py to
1024-dim layers) + DEPTH=1024 bitstream rebuild — converges with the
Tier-2-on-silicon hardware milestone.
