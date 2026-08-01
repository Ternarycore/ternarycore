# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss — init saved |
| 2026-07-31 ~22:47 | smoke_train 400st | seq1024 b2 a8 lr1e-4 | loss 13.89→3.6–4.0 by step 280 (4.6 M tok, ~5.9 k tok/s, 9.3 GB VRAM). Killed at ~step 285 by site blackout (fort lost power; UPS depleted). **D3 loop proven.** |
| 2026-08-01 00:14 | warmup_train 100M tok (attempt 1) | wikitext-103 seq1024 b2 a8 lr2e-4 | stalled >1 h in one-time tokenization — single 500 MB string through one tokenizer call is pathological. Killed; tokenizer path rewritten batched (20 k docs/call, Rust-parallel). |
| 2026-08-01 ~02:0x | warmup_train 100M tok (attempt 2) | same, batched tokenizer, resume from smoke-last | launched — see ~/tc-warmup.log |
