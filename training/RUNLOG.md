# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss — init saved |
| 2026-07-31 ~22:47 | smoke_train 400st | seq1024 b2 a8 lr1e-4 | loss 13.89→3.6–4.0 by step 280 (4.6 M tok, ~5.9 k tok/s). Killed at ~step 285 by blackout #1. **D3 loop proven.** |
| 2026-08-01 00:14 | warmup attempt 1 | naive tokenizer | stalled >1 h in single 500 MB-string tokenizer call. |
| 2026-08-01 ~02:00 | warmup attempts 2–3 | — | ran stale code (pkill-footgun killed the deploy before git pull); one reached 58 GB RSS. Postmortems in this file's history. |
| 2026-08-01 02:10–06:55 | warmup attempt 4 | batched tokenizer; 124.2 M-tok corpus; seq1024 b2 a8 lr2e-4 cos; resume smoke-last | ran to step ~4275; transient host-load spike (~36) slowed 2 h; **killed by blackout #2**; alternating ckpt @4250 survived (~7 min lost). |
| 2026-08-01 07:06–07:31 | warmup attempt 5 (resume) | auto-resume warmup-a @4250 | ran 4250→6103 at 5.9 k tok/s. **DONE.** |

## D3 warm-up — FINAL RESULT (2026-08-01 07:31 UTC)

| Model state | wikitext eval loss |
|---|---|
| FP teacher (Qwen3-0.6B) | 3.318 |
| Student, FP after SubLN surgery (untrained) | 6.903 |
| Student, ternary snap, pre-warm-up | 14.238 |
| **Student, ternary, after 100 M-token warm-up** | **3.474** |

**The ternary student sits 0.16 nats above its FP teacher** after a 100 M-token
warm-up (~4.5 h effective GPU on one RTX 5070 Ti, ~$0 marginal cost, two
blackouts survived). 97.7% of the surgery+ternarization damage recovered.
Checkpoint: `~/tc-ckpt/warmup-final.pt`.

*Known imperfection: the resume at step 4250 restarted the LR schedule, so
the run ended at lr≈1.6e-4 instead of a decayed tail — the final number
likely slightly understates achievable quality. Fix scheduler resume
(offset by start_step) before any run whose numbers get published.*

**Next: D4 task distillation** (SST-2 + MNLI, logit + attention-relation KD
from the task-fine-tuned teacher, per D1-decision.md). Warm-up curves and
this table are article-05 material.
