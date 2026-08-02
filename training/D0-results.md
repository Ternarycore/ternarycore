# D0 results — floor & ceiling (2026-07-31, fort-silicon)

## Environment

- RTX 5070 Ti 16 GB, driver 595.84 · torch 2.11.0+cu128 · lm-eval 0.4.12
- transformers: **5.14.1** for Qwen3 · **4.40.2 (pinned)** for the 1bitLLM
  checkpoint (see loading notes below)
- venv: `~/tc-train` (kept at transformers 4.57 line for future work;
  re-pin 4.40.2 to re-run the floor eval)

## Scores (arc_easy + hellaswag, 0-shot, limit 200 — QUICK numbers, full runs later)

| Model | arc_easy acc / acc_norm | hellaswag acc / acc_norm | GPU sanity |
|---|---|---|---|
| **Floor:** 1bitLLM/bitnet_b1_58-large (ternary, 729 M) | 0.505 / 0.480 | 0.425 / 0.520 | coherent, 31.9 tok/s (eager, no cache) |
| **Ceiling:** Qwen/Qwen3-0.6B (FP16, 596 M) | 0.595 / 0.575 | 0.435 / 0.525 | coherent, 141.5 tok/s |

Sanity checks vs published: bitnet_b1_58-large paper reports ~51.8 arc_easy —
our 50.5 ±3.5 matches. The floor→ceiling gap at this size is ~9 pts on
arc_easy and ~0 on hellaswag — encouraging context for D1: a well-distilled
ternary 0.6B has a realistic shot at the ceiling on a narrow task.

## Loading the 1bitLLM checkpoint in 2026 (the archaeology, so nobody repeats it)

The HF repo `1bitLLM/bitnet_b1_58-large` ships **no modeling code** (config
declares `BitnetForCausalLM`, no auto_map). Vanilla transformers silently
falls back to Llama, **drops the SubLN weights** (`ffn_layernorm`,
`inner_attn_ln` → UNEXPECTED) and produces garbage that scores at chance.
Any eval of this checkpoint that doesn't check generation quality first is
measuring noise — good cautionary tale for the paper's verification theme.

Working recipe (lives at `~/models/bitnet-large-fixed` on fort):

1. Symlink the cached snapshot into a local dir; copy (not link) the configs.
2. Graft `modeling_bitnet.py`, `configuration_bitnet.py`,
   `tokenization_bitnet.py`, `utils_quant.py` from the sibling
   `1bitLLM/bitnet_b1_58-3B` repo (only repo that has them).
3. Patch `config.json`: add `auto_map` → the grafted classes.
4. Patch `tokenizer_config.json`: `tokenizer_class: LlamaTokenizerFast`.
5. `sed -i '/from flash_attn/d'` + `pass` in the emptied `if` (kills the
   hard flash-attn import check); force default RoPE branch.
6. **Pin `transformers==4.40.2`** — the code is 4.40-era; 4.57 and 5.x both
   break on cache/tied-weights APIs even with shims.
7. lm-eval 0.4.12 needs a one-line patch: only pass `gguf_file` kwarg when
   set (old model classes reject the kwarg).
8. Eval with `attn_implementation=eager,trust_remote_code=True`.

## D0 exit criteria — status

- [x] CUDA + Blackwell stack working (torch 2.11.0+cu128)
- [x] Floor measured, matches published within noise
- [x] Ceiling measured (Qwen3-0.6B healthy out of the box)
- [x] requirements captured (`requirements-frozen.txt`)
- [ ] Full (no-limit) eval runs — defer to D1 once task suite is locked

**Next: D1** — teacher layer-shape audit vs the hardware constraints table,
task + eval-suite + success-bar decision (one page, no GPU needed).
