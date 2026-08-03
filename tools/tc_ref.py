#!/usr/bin/env python3
"""tc_ref.py -- the golden model for TernaryCore inference.

Mirrors in NumPy exactly what the board will compute: ternary weights times
int8 activations, accumulated in int32 by the array, with the surrounding
operators quantized the way the soft CPU will quantize them. Nothing goes
into firmware until it has been proved here first.

Scope, stated plainly: every *vector* operation is bit-identical to the
hardware's -- the int8 quantizers, the int32 accumulators, the 7-bit softmax
probabilities, the int8 KV cache. Per-tensor *scalar* rescales are float64
here. That isolates the risk that actually matters (does quantization destroy
the model?) from a firmware detail with a known fix (more fractional bits).

Modes:
  --mode float   every op in float64: the ceiling this arithmetic aims at
  --mode int     every op as the board will do it
Running both on the same prompt says what the board's arithmetic costs.

  python tc_ref.py --build                  # quantize the checkpoint once
  python tc_ref.py --mode int --prompt "The capital of France is"
  python tc_ref.py --compare                # int vs float vs PyTorch bf16
"""
import argparse, json, os, sys, time
import numpy as np

CKPT  = os.path.expanduser("~/tc-ckpt/d4-student-sst2-r2.pt")
CACHE = os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz")
TEACHER = "Qwen/Qwen3-0.6B"

H, NH, NKV, HD, INTER, NB = 1024, 16, 8, 128, 3072, 28
EPS, THETA, VOCAB = 1e-6, 1e6, 151936
NREP = NH // NKV
SCALE = HD ** -0.5

PROJ = ["q_proj", "k_proj", "v_proj", "o_proj",
        "gate_proj", "up_proj", "down_proj"]
SUBLN = {"o_proj", "down_proj"}          # nn.Sequential(RMSNorm, BitLinear)


# ---------------------------------------------------------------- quantizers

def absmean_ternary(w):
    """BitNet b1.58, exactly as training/bitlinear.py does it."""
    s = max(float(np.abs(w).mean()), 1e-8)
    return np.clip(np.rint(w / s), -1, 1).astype(np.int8), s


def quant_a(t):
    """Per-token absmax int8, exactly as training/bitlinear.py does it."""
    s = max(float(np.abs(t).max()), 1e-5) / 127.0
    return np.clip(np.rint(t / s), -128, 127).astype(np.int8), s


def rmsnorm(x, g):
    return (x / np.sqrt((x * x).mean() + EPS)) * g


# ------------------------------------------------------------------- weights

def build_cache(ckpt=CKPT, out=CACHE):
    """Quantize once, to .npz, so every later run starts in two seconds."""
    import torch
    print(f"loading {ckpt}", flush=True)
    d = torch.load(ckpt, map_location="cpu", weights_only=False)
    f = lambda k: d[k].float().numpy()

    blob = {"embed": f("model.embed_tokens.weight").astype(np.float32),
            "final_norm": f("model.norm.weight").astype(np.float32)}
    for b in range(NB):
        p = f"model.layers.{b}."
        for name in PROJ:
            key = p + ("self_attn." if name[0] in "qkvo" else "mlp.") + name
            key += ".1.weight" if name in SUBLN else ".weight"
            q, s = absmean_ternary(f(key))
            blob[f"{b}.{name}.w"] = q
            blob[f"{b}.{name}.s"] = np.float32(s)
            if name in SUBLN:
                sub = key.replace(".1.weight", ".0.weight")
                blob[f"{b}.{name}.subln"] = f(sub).astype(np.float32)
        for extra, key in (("q_norm", "self_attn.q_norm"),
                           ("k_norm", "self_attn.k_norm"),
                           ("in_norm", "input_layernorm"),
                           ("post_norm", "post_attention_layernorm")):
            blob[f"{b}.{extra}"] = f(p + key + ".weight").astype(np.float32)
        print(f"  block {b} quantized", end="\r", flush=True)
    print(f"\nwriting {out}", flush=True)
    np.savez(out, **blob)
    print(f"done, {os.path.getsize(out) / 1e6:.0f} MB", flush=True)


# --------------------------------------------------------------------- model

class Ref:
    def __init__(self, cache=CACHE, mode="int", nblocks=NB, probs_bits=7):
        if not os.path.exists(cache):
            sys.exit(f"no {cache} -- run with --build first")
        self.z = np.load(cache)
        self.mode = mode
        self.nb = nblocks
        self.pmax = (1 << probs_bits) - 1
        self.embed = self.z["embed"]
        self.reset()

    def reset(self):
        self.kq = [[] for _ in range(self.nb)]   # int8 keys   per block
        self.ks = [[] for _ in range(self.nb)]   # their scales
        self.vq = [[] for _ in range(self.nb)]
        self.vs = [[] for _ in range(self.nb)]

    # --- one BitLinear ---------------------------------------------------
    def _lin(self, b, name, x, pre_a=None):
        """x float64 (in,). pre_a lets q/k/v share one quantization of the
        block input, exactly as three BitLinears on the same tensor do."""
        W = self.z[f"{b}.{name}.w"]
        s_w = float(self.z[f"{b}.{name}.s"])
        if name in SUBLN:
            x = rmsnorm(x, self.z[f"{b}.{name}.subln"])
        if self.mode == "float":
            return (W.astype(np.float64) @ x) * s_w
        a, s_a = pre_a if pre_a is not None else quant_a(x)
        acc = W.astype(np.int32) @ a.astype(np.int32)     # what the array does
        return acc.astype(np.float64) * s_w * s_a

    def _quant_block_input(self, x):
        return None if self.mode == "float" else quant_a(x)

    # --- attention -------------------------------------------------------
    def _attn(self, b, x, pos, cos, sin):
        pre = self._quant_block_input(x)
        q = self._lin(b, "q_proj", x, pre).reshape(NH, HD)
        k = self._lin(b, "k_proj", x, pre).reshape(NKV, HD)
        v = self._lin(b, "v_proj", x, pre).reshape(NKV, HD)

        gq, gk = self.z[f"{b}.q_norm"], self.z[f"{b}.k_norm"]
        q = rope(np.stack([rmsnorm(q[h], gq) for h in range(NH)]), cos, sin)
        k = rope(np.stack([rmsnorm(k[h], gk) for h in range(NKV)]), cos, sin)

        # append to the cache in the form attention will actually read
        for h in range(NKV):
            if self.mode == "float":
                self.kq[b].append(k[h]); self.ks[b].append(1.0)
                self.vq[b].append(v[h]); self.vs[b].append(1.0)
            else:
                ka, ks = quant_a(k[h]); self.kq[b].append(ka); self.ks[b].append(ks)
                va, vs = quant_a(v[h]); self.vq[b].append(va); self.vs[b].append(vs)
        T = pos + 1
        KQ = np.array(self.kq[b]).reshape(T, NKV, -1)
        KS = np.array(self.ks[b]).reshape(T, NKV)
        VQ = np.array(self.vq[b]).reshape(T, NKV, -1)
        VS = np.array(self.vs[b]).reshape(T, NKV)

        out = np.zeros((NH, HD))
        for h in range(NH):
            kv = h // NREP
            if self.mode == "float":
                sc = (KQ[:, kv, :] @ q[h]) * SCALE
                p = np.exp(sc - sc.max()); p /= p.sum()
                out[h] = p @ VQ[:, kv, :]
                continue
            qa, s_q = quant_a(q[h])
            dots = KQ[:, kv, :].astype(np.int32) @ qa.astype(np.int32)   # array
            sc = dots.astype(np.float64) * s_q * KS[:, kv] * SCALE
            e = np.exp(sc - sc.max())
            # Deferred normalization: quantize the *unnormalized* exponentials,
            # whose max is exactly full scale, and divide by their sum once at
            # the end. Fold each key's V scale in first, so a single int8 dot
            # serves every key -- the largest weight stays exact, and the ones
            # that round to zero were contributing nothing anyway.
            w = e * VS[:, kv]
            pi = np.rint(w / w.max() * self.pmax).astype(np.int16)
            num = VQ[:, kv, :].astype(np.int32).T @ pi.astype(np.int32)  # array
            den = float((e / w.max() * self.pmax).sum())
            out[h] = num.astype(np.float64) / den if den else 0.0
        return self._lin(b, "o_proj", out.reshape(NH * HD))

    # --- one block -------------------------------------------------------
    def block(self, b, x, pos, cos, sin):
        x = x + self._attn(b, rmsnorm(x, self.z[f"{b}.in_norm"]), pos, cos, sin)
        h = rmsnorm(x, self.z[f"{b}.post_norm"])
        pre = self._quant_block_input(h)
        g = self._lin(b, "gate_proj", h, pre)
        u = self._lin(b, "up_proj", h, pre)
        return x + self._lin(b, "down_proj", (g / (1.0 + np.exp(-g))) * u)

    def forward(self, tok, pos):
        x = self.embed[tok].astype(np.float64)
        cos, sin = rope_tables(pos)
        for b in range(self.nb):
            x = self.block(b, x, pos, cos, sin)
        x = rmsnorm(x, self.z["final_norm"])
        return self.embed.astype(np.float64) @ x        # lm_head, tied


def rope_tables(pos):
    inv = 1.0 / (THETA ** (np.arange(0, HD, 2, dtype=np.float64) / HD))
    f = pos * inv
    return np.concatenate([np.cos(f)] * 2), np.concatenate([np.sin(f)] * 2)


def rope(t, cos, sin):
    half = t.shape[-1] // 2
    rot = np.concatenate([-t[..., half:], t[..., :half]], axis=-1)
    return t * cos + rot * sin


# ---------------------------------------------------------------------- main

def generate(ref, ids, n_new, tok=None):
    ref.reset()
    out = list(ids)
    logits = None
    for i, t in enumerate(out):
        logits = ref.forward(t, i)
    for _ in range(n_new):
        nxt = int(np.argmax(logits))
        out.append(nxt)
        if tok is not None:
            print(tok.decode([nxt]), end="", flush=True)
        logits = ref.forward(nxt, len(out) - 1)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--build", action="store_true")
    ap.add_argument("--mode", default="int", choices=["int", "float"])
    ap.add_argument("--prompt", default="The capital of France is")
    ap.add_argument("--new", type=int, default=12)
    ap.add_argument("--blocks", type=int, default=NB)
    ap.add_argument("--probs-bits", type=int, default=7)
    ap.add_argument("--compare", action="store_true")
    a = ap.parse_args()

    if a.build:
        build_cache(); return

    from transformers import AutoTokenizer
    tk = AutoTokenizer.from_pretrained(TEACHER)
    ids = tk(a.prompt).input_ids

    if a.compare:
        for m in ("float", "int"):
            r = Ref(mode=m, nblocks=a.blocks, probs_bits=a.probs_bits)
            t0 = time.time()
            r.reset()
            lg = None
            for i, t in enumerate(ids):
                lg = r.forward(t, i)
            top = np.argsort(lg)[::-1][:5]
            print(f"{m:>5}  {time.time()-t0:6.1f}s  top5 "
                  f"{[tk.decode([int(t)]) for t in top]}")
            print(f"        logits[:6] {np.round(lg[:6], 3)}")
        return

    r = Ref(mode=a.mode, nblocks=a.blocks, probs_bits=a.probs_bits)
    print(f"[{a.mode}] {a.prompt}", end="", flush=True)
    generate(r, ids, a.new, tok=tk)
    print()


if __name__ == "__main__":
    main()
