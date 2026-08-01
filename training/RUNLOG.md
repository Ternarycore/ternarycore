# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~23:40 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss — init saved |
| 2026-07-31 23:43 | smoke_train 400st | seq1024 b2 a8 lr1e-4 | loss 13.89→3.6–4.0 by step 280 (4.6 M tok, ~5.9 k tok/s, 9.3 GB VRAM). Died silently ~step 285 (no OOM/traceback — detach fragility suspected). **D3 loop proven.** |
| 2026-08-01 00:1x | warmup_train 100M tok | wikitext-103, seq1024 b2 a8 lr2e-4 cos+100warm, resume smoke-last | launched — see ~/tc-warmup.log |
