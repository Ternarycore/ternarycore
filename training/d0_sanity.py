#!/usr/bin/env python3
"""D0 sanity: load a causal LM, generate a few tokens, report speed.
Usage: python d0_sanity.py <hf-model-id-or-local-path>
Note: 1bitLLM checkpoints need the patched local copy + transformers==4.40.2
(see D0-results.md).
"""
import sys, time, torch
from transformers import AutoModelForCausalLM, AutoTokenizer

mid = sys.argv[1] if len(sys.argv) > 1 else "1bitLLM/bitnet_b1_58-large"
print(f"== {mid} ==", flush=True)
tok = AutoTokenizer.from_pretrained(mid, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(
    mid, torch_dtype=torch.float16, trust_remote_code=True).cuda()
model.eval()
n_params = sum(p.numel() for p in model.parameters())
print(f"params: {n_params/1e6:.1f} M  vram: {torch.cuda.memory_allocated()/1e9:.2f} GB")
x = tok("The key idea of ternary computing is", return_tensors="pt").to("cuda")
with torch.no_grad():
    model.generate(**x, max_new_tokens=8)          # warm-up
    torch.cuda.synchronize(); t0 = time.time()
    out = model.generate(**x, max_new_tokens=64, do_sample=False)
    torch.cuda.synchronize(); dt = time.time() - t0
new = out.shape[1] - x["input_ids"].shape[1]
print(tok.decode(out[0], skip_special_tokens=True))
print(f"[{new} tokens in {dt:.2f}s = {new/dt:.1f} tok/s on GPU]")
