#!/usr/bin/env python3
"""Prepare a REAL BitNet b1.58 weight slice for the Stage 1 streaming firmware.

Downloads a checkpoint (default 1bitLLM/bitnet_b1_58-large), takes a
768x768 slice of one projection matrix, absmean-ternarizes it (the standard
BitNet quantizer), packs it in the hardware layout (addr = k*GROUPS + g,
4 x 2-bit codes per byte, LSB-first), and emits:

  weights.bin   147,456 packed bytes
  acts.bin      768 int8 activations (deterministic test vector)
  expected.txt  768 reference outputs computed on the host

Usage: python3 prep_bitnet_layer.py [--model 1bitLLM/bitnet_b1_58-large]
         [--tensor model.layers.0.self_attn.q_proj.weight] [--outdir .]
Requires: pip install numpy safetensors huggingface_hub
"""
import argparse, os
import numpy as np

DEPTH, COLS, GROUPS = 768, 768, 192

def absmean_ternarize(W):
    gamma = np.mean(np.abs(W)) + 1e-8
    return np.clip(np.round(W / gamma), -1, 1).astype(np.int8)

def encode(t):  # {-1,0,1} -> 2-bit code
    return np.where(t == 1, 0x1, np.where(t == -1, 0x2, 0x0)).astype(np.uint8)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="1bitLLM/bitnet_b1_58-large")
    ap.add_argument("--tensor", default=None)
    ap.add_argument("--outdir", default=".")
    args = ap.parse_args()

    from huggingface_hub import hf_hub_download
    from safetensors import safe_open

    path = hf_hub_download(args.model, "model.safetensors")
    with safe_open(path, framework="numpy") as f:
        keys = list(f.keys())
        name = args.tensor
        if name is None:
            cands = [k for k in keys if "q_proj.weight" in k]
            name = sorted(cands)[0]
        W = f.get_tensor(name).astype(np.float32)
    print(f"tensor {name} shape {W.shape}")

    # torch Linear stores [out, in]; outputs[c] = sum_k act[k] * W[c, k]
    # hardware wants W_hw[k, c]: slice then transpose.
    Ws = W[:COLS, :DEPTH].T            # [DEPTH, COLS] = W_hw[k, c]
    T = absmean_ternarize(Ws)
    nz = np.count_nonzero(T)
    print(f"ternarized: +1={np.sum(T==1)} -1={np.sum(T==-1)} 0={T.size-nz} "
          f"({100*nz/T.size:.1f}% nonzero)")

    codes = encode(T)                  # [DEPTH, COLS]
    g = codes.reshape(DEPTH, GROUPS, 4)
    packed = (g[:, :, 0] | (g[:, :, 1] << 2) | (g[:, :, 2] << 4) | (g[:, :, 3] << 6)).astype(np.uint8)
    wbytes = packed.reshape(-1)        # addr = k*GROUPS + g  (row-major)
    assert wbytes.size == DEPTH * GROUPS

    acts = (((np.arange(DEPTH) % 7) - 3)).astype(np.int8)   # same vector as tier1_bare
    expected = (acts.astype(np.int64) @ T.astype(np.int64))  # [COLS]

    os.makedirs(args.outdir, exist_ok=True)
    open(os.path.join(args.outdir, "weights.bin"), "wb").write(wbytes.tobytes())
    open(os.path.join(args.outdir, "acts.bin"), "wb").write(acts.tobytes())
    open(os.path.join(args.outdir, "expected.txt"), "w").write(" ".join(map(str, expected.tolist())))
    print(f"wrote weights.bin ({wbytes.size} B), acts.bin (768 B), expected.txt")
    print("first 8 expected outputs:", expected[:8].tolist())

if __name__ == "__main__":
    main()
