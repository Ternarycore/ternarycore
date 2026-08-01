# Training run log

| When (UTC) | Run | Config | Result |
|---|---|---|---|
| 2026-07-31 ~22:45 | surgery.py | Qwen3-0.6B → SubLN+BitLinear | teacher 3.318 / student-FP 6.903 / ternary 14.238 eval loss — init saved |
| 2026-07-31 ~22:47 | smoke_train 400st | seq1024 b2 a8 lr1e-4 | loss 13.89→3.6–4.0 by step 280 (4.6 M tok, ~5.9 k tok/s, 9.3 GB VRAM). Killed at ~step 285 by site blackout. **D3 loop proven.** |
| 2026-08-01 00:14 | warmup attempt 1 | wikitext-103, naive tokenizer | stalled >1 h in single 500 MB-string tokenizer call. |
| 2026-08-01 ~02:00 | warmup attempts 2–3 | — | never ran the fixed code: `pkill -f` in the fix-deploy command matched its own wrapper shell and died before `git pull`; both relaunches executed the stale naive script, one reaching 58 GB RSS before manual kill. Postmortem: never combine pkill with a relaunch matching the pattern; verify a deployed-fix marker before relaunching. |
| 2026-08-01 02:10 | **warmup attempt 4 (running)** | batched tokenizer; 124.2 M-token corpus; seq1024 b2 a8 lr2e-4 cos; resume smoke-last | tokenization 40 s. Step 4100/6103 (67%) @ 05:47 UTC, **train loss 2.6–3.1** (teacher eval ref 3.32), 9.3 GB VRAM. Cumulative 3.8 k tok/s — a transient CPU-load spike (host load avg peaked ~36, cause unidentified; cleared) slowed steps ~04:45–06:40 local; instantaneous pace recovered. Alternating ckpts healthy (warmup-a/b @ 250-step cadence). Projected finish 07:00–08:00 UTC → warmup-final.pt + eval loss. |
