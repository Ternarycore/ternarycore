# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss — init saved |
| 2026-07-31 ~22:47 | smoke_train 400st | seq1024 b2 a8 lr1e-4 | loss 13.89→3.6–4.0 by step 280 (4.6 M tok, ~5.9 k tok/s, 9.3 GB VRAM). Killed at ~step 285 by site blackout. **D3 loop proven.** |
| 2026-08-01 00:14 | warmup attempt 1 | wikitext-103, naive tokenizer | stalled >1 h in single 500 MB-string tokenizer call. |
| 2026-08-01 ~02:00 | warmup attempts 2–3 | — | never ran the fixed code: the `pkill -f` in the fix-deploy command matched its own wrapper shell and died before `git pull`, so both relaunches executed the stale naive script — the second reached **58 GB RSS** before being killed manually. Postmortem: (a) never put `pkill` in the same command as a relaunch whose text matches the pattern; (b) always verify a deployed-fix marker (`grep` a new string) before relaunching. |
| 2026-08-01 ~02:10 | **warmup attempt 4 (running)** | batched tokenizer; 124.2 M-token corpus; seq1024 b2 a8 lr2e-4 cos; resume smoke-last | tokenization 40 s (vs ∞). 6103 steps × 16384 tok; step-0 loss 4.24 (continuity from smoke ✓); **5.4 k tok/s, 9.3 GB VRAM, ETA ~5.2 h** → warmup-final.pt |
