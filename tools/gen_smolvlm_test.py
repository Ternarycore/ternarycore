#!/usr/bin/env python3
"""
Generate a Verilator C++ test for running a real SmolVLM layer
through the ternarycore pipeline.
"""
import torch
from transformers import AutoModel

# Load model
model = AutoModel.from_pretrained(
    'HuggingFaceTB/SmolVLM-256M-Instruct', dtype=torch.float32
)
model.eval()

# Extract first layer's gate_proj weights
w = model.text_model.layers[0].mlp.gate_proj.weight.data  # [1536, 576]

# BitNet ternary quantization
gamma = w.abs().mean(dim=1, keepdim=True).clamp(min=1e-8)
w_t = torch.clamp(torch.round(w / gamma), -1, 1)
alpha = (gamma * (w.shape[1] ** 0.5)).squeeze()

# Generate random activations
acts = torch.randint(-50, 51, (576,), dtype=torch.int8)

# Format as C++ array
acts_str = ", ".join(str(int(a)) for a in acts)

# Pick first 4 rows for the 4x4 pipeline test
cols = 4
depth = 4
w_block = w_t[:cols, :depth]  # [4, 4]
a_block = acts[:depth]        # [4]

# Compute expected: scaled dot product
expected = []
for c in range(cols):
    dot = int(sum(int(a_block[k]) * int(w_block[c, k]) for k in range(depth)))
    expected.append(dot)

# Pack each depth row into weight_enc
def pack(row_weights):
    packed = 0
    for i, w in enumerate(row_weights):
        enc = {0: 0, 1: 1, -1: 2}.get(int(w), 0)
        packed |= enc << (2 * i)
    return packed

weight_rows = []
for k in range(depth):
    weight_rows.append(pack([int(w_block[c, k]) for c in range(cols)]))

# Alpha scales (Q15)
alphas = [int(alpha[c].item() * 32768) for c in range(cols)]

print(f"// SmolVLM layer 0 gate_proj test ({w.shape[0]}x{w.shape[1]})")
print(f"// Ternary density: {(w_t != 0).sum().item() / w_t.numel():.1%}")
print(f"int8_t acts[{depth}] = {{{acts_str}}};")
print(f"int w_packed = {weight_rows[0]};  // same for all k (simplified)")
print(f"// Alpha (Q15): {[f'0x{a:04X}' for a in alphas]}")
print(f"// Expected: {expected}")
print(f"// Alphas: {alphas}")

# Output C++ source
print()
print("#include <verilated.h>")
print('#include "Vternary_pipeline.h"')
print("#include <cstdio>")
print("#include <cstdint>")
print("#include <cmath>")
print()
print("int main() {")
print("    Vternary_pipeline* dut = new Vternary_pipeline;")
print(f"    int8_t acts[{depth}] = {{{acts_str}}};")
print(f"    int w_packed = {weight_rows[0]};")
print(f"    uint64_t alpha_packed = 0;")
for c in range(cols):
    print(f"    alpha_packed |= (uint64_t){alphas[c]} << ({c} * 16);")
print(f"    int inv = round(32768.0 * 127.0 / 50.0);  // absmax=50")
print()
print("    dut->rst_n = 0;")
print("    for (int i = 0; i < 4; i++) { dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval(); }")
print("    dut->rst_n = 1;")
print()
print("    for (int i = 0; i < 4; i++) {")
print("        dut->valid_in = 1; dut->activation = acts[i]; dut->inv = inv;")
print("        dut->weight_enc = w_packed; dut->alpha = alpha_packed;")
print("        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();")
print("    }")
print()
print("    dut->valid_in = 0;")
print("    int32_t results[4] = {0};")
print("    int errors = 0;")
print("    for (int i = 0; i < 15; i++) {")
print("        dut->clk = 0; dut->eval(); dut->clk = 1; dut->eval();")
print("        if (dut->valid_out)")
print("            for (int c = 0; c < 4; c++)")
print("                results[c] = (int32_t)dut->result.at(c);")
print("    }")
print(f"    int expected[4] = {{{expected[0]}, {expected[1]}, {expected[2]}, {expected[3]}}};")
print("    for (int c = 0; c < 4; c++) {")
print("        printf(\"col %d: HW=%d SW=%d %s\\n\", c, results[c], expected[c],")
print("               results[c] == expected[c] ? \"OK\" : \"MISMATCH\");")
print("        if (results[c] != expected[c]) errors++;")
print("    }")
print("    printf(\"--- %d error(s) ---\\n\", errors);")
print("    delete dut;")
print("    return errors ? 1 : 0;")
print("}")