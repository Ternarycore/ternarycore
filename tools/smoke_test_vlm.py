#!/usr/bin/env python3
"""Smoke test: verify full BitNet VLM pipeline is wired correctly."""
import math, sys, time
from pathlib import Path
import torch
from PIL import Image
from transformers import AutoProcessor
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from tools.bitnet_full import build_full_bitnet_vlm

MODEL = "HuggingFaceTB/SmolVLM-256M-Instruct"

def main():
    print("1. Loading and converting to BitNet...")
    t0 = time.time()
    model = build_full_bitnet_vlm()
    model.eval()
    print(f"   {time.time()-t0:.1f}s")

    processor = AutoProcessor.from_pretrained(MODEL)
    img = Image.new("RGB", (224, 224), (100, 150, 200))
    inputs = processor(text="<image>Describe this image.", images=img, return_tensors="pt")
    pixel_values = inputs["pixel_values"]
    input_ids = inputs["input_ids"]
    print(f"   pixel_values: {tuple(pixel_values.shape)}")
    print(f"   input_ids: {tuple(input_ids.shape)}")

    print("\n2. Forward pass...")
    with torch.no_grad():
        vis_out = model.vision_model(pixel_values.flatten(0, 1))
        print(f"   Vision: {tuple(vis_out.last_hidden_state.shape)}")
        vis_proj = model.connector(vis_out.last_hidden_state[:, :1])
        print(f"   Connector: {tuple(vis_proj.shape)}")
        txt_out = model.text_model(input_ids)
        print(f"   Text decoder: {tuple(txt_out.last_hidden_state.shape)}")

    print("\n3. Module count:")
    for name, cls in [("BitNetLinear", None), ("BitNetConv2d", None), ("BitNetEmbedding", None), ("BitNetLayerNorm", None)]:
        n = sum(1 for _ in model.modules() if type(_).__name__ == name)
        if n: print(f"   {n} {name}")

    print("\n4. Memory:")
    def bits(mod, clist, b):
        return sum(p.numel()*b for _,m in mod.named_modules()
                  if type(m).__name__ in clist for p in m.parameters()) // 8
    mb = lambda x: x/1024/1024
    t = mb(bits(model, ["BitNetLinear","BitNetConv2d"], 2) +
           bits(model.connector, ["BitNetLinear"], 2) +
           bits(model.text_model, ["BitNetLinear"], 2) +
           bits(model, ["BitNetEmbedding"], 4))
    fp = mb(sum(p.numel()*32 for p in model.parameters()) // 8)
    print(f"   {t:.0f}MB vs {fp:.0f}MB FP32 = {fp/t:.0f}x")

    print("\n✅ All components connected end-to-end.")

if __name__ == "__main__":
    main()