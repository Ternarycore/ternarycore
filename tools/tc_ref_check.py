#!/usr/bin/env python3
"""tc_ref_check.py -- is the golden model actually the model?

tc_ref.py agreeing with itself in float and int mode proves only that it is
self-consistent. RoPE rotating the wrong way, or GQA mapping head h to the
wrong KV head, would leave both modes agreeing beautifully on the wrong
answer. The only real check is against the model as PyTorch runs it.

  python tools/tc_ref_check.py --ckpt ~/tc-ckpt/warmup-final.pt

Prints, per position, the max absolute logit difference and whether the
argmax agrees. float mode should sit inside bf16 noise; int mode's gap is
the honest price of the board's arithmetic.
"""
import argparse, os, sys
import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "training"))
sys.path.insert(0, os.path.dirname(__file__))

import tc_ref


def torch_logits(ckpt, ids, device="cuda"):
    import torch, bitlinear
    from transformers import AutoModelForCausalLM
    from surgery import build_student
    m = AutoModelForCausalLM.from_pretrained(tc_ref.TEACHER, dtype=torch.float32)
    m = build_student(m).to(device).eval()
    sd = torch.load(ckpt, map_location="cpu", weights_only=False)
    missing, unexpected = m.load_state_dict(sd, strict=False)
    if missing or unexpected:
        print(f"  state_dict: {len(missing)} missing, {len(unexpected)} unexpected")
        for k in list(missing)[:4] + list(unexpected)[:4]:
            print(f"    {k}")
    bitlinear.QUANT["enabled"] = True
    with torch.no_grad():
        out = m(torch.tensor([ids], device=device)).logits[0]
    return out.float().cpu().numpy()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ckpt", default=tc_ref.CKPT)
    ap.add_argument("--cache", default=tc_ref.CACHE)
    ap.add_argument("--prompt", default="The capital of France is")
    ap.add_argument("--blocks", type=int, default=tc_ref.NB)
    a = ap.parse_args()

    from transformers import AutoTokenizer
    tk = AutoTokenizer.from_pretrained(tc_ref.TEACHER)
    ids = tk(a.prompt).input_ids
    print(f"prompt {a.prompt!r} -> {len(ids)} tokens")

    print("running PyTorch student (fp32 shadow, quant on)...", flush=True)
    ref = torch_logits(a.ckpt, ids)

    for mode in ("float", "int"):
        r = tc_ref.Ref(cache=a.cache, mode=mode, nblocks=a.blocks)
        r.reset()
        print(f"\n{mode}:")
        for i, t in enumerate(ids):
            lg = r.forward(t, i)
            d = np.abs(lg - ref[i])
            rel = d.max() / max(np.abs(ref[i]).max(), 1e-9)
            same = int(np.argmax(lg)) == int(np.argmax(ref[i]))
            print(f"  pos {i}: max|dlogit| {d.max():8.4f}  rel {rel:7.4f}  "
                  f"argmax {'agree' if same else 'DIFFER'}  "
                  f"top1 {tk.decode([int(np.argmax(lg))])!r} vs "
                  f"{tk.decode([int(np.argmax(ref[i]))])!r}")


if __name__ == "__main__":
    main()
