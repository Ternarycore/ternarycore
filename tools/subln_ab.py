#!/usr/bin/env python3
"""Is SubLN earning its keep? Ternarize with and without it, same student.

SubLN costs 14x in full precision -- it divides each token by its own RMS
and a fixed matrix cannot fully absorb a per-token scale. The paper says
it pays that back under quantization, by bounding the activation range
int8 has to cover. That is a claim, and this measures it.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import os, sys, torch
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__))))
from bitnet_surgery import as_bitlinear, set_quant, ppl, PLAIN, SUBLN
from transformers import AutoModelForCausalLM, AutoTokenizer
from datasets import load_dataset

CK = os.path.expanduser("~/tc-ckpt/student-L28-seq")
dev = "cuda" if torch.cuda.is_available() else "cpu"
tk = AutoTokenizer.from_pretrained("Qwen/Qwen3-0.6B")
val = load_dataset("knkarthick/dialogsum", split="validation")
m = AutoModelForCausalLM.from_pretrained(CK, dtype=torch.float32).to(dev).eval()
for blk in m.model.layers:
    for parent, name in PLAIN + SUBLN:
        p = getattr(blk, parent)
        setattr(p, name, as_bitlinear(getattr(p, name)))
print(f"  no SubLN, full precision     {ppl(m, tk, val, 200, dev):12.3f}")
set_quant(m, True)
print(f"  no SubLN, W1.58 A8           {ppl(m, tk, val, 200, dev):12.3f}")
print(f"  (with SubLN those were 209.643 and 837074.493)")
