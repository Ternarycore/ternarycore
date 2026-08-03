#!/usr/bin/env python3
"""tc_probs_sweep.py -- how many bits does a softmax probability need?

P.V runs through the same bit-serial array as everything else, and that
array costs one sub-cycle per operand bit. Seven bits of probability is
90 ms of attention per token; four would be half that, twelve half again
as much and a different datapath. So the width is worth measuring before
it is worth building.

Context length is the whole subtlety. With a handful of keys one of them
dominates and any probability width looks fine; the question is whether
that holds when 512 keys share the distribution. Use --wikitext.

  python tools/tc_probs_sweep.py --cache ~/tc-ckpt/tc-ref-warmup.npz \
      --wikitext 256 --bits 4,6,8,12

Reports, per width, the mean and worst relative logit error against the
float path and how many positions keep the same argmax.
"""
import argparse, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref


def run(cache, ids, mode, bits=7, blocks=tc_ref.NB):
    r = tc_ref.Ref(cache=cache, mode=mode, nblocks=blocks, probs_bits=bits)
    r.reset()
    return np.array([r.forward(t, i) for i, t in enumerate(ids)])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cache", default=tc_ref.CACHE)
    ap.add_argument("--prompt", default="The Eiffel Tower is located in the "
                    "city of Paris, which is the capital of France. It was "
                    "built in")
    ap.add_argument("--wikitext", type=int, default=0,
                    help="use this many real tokens instead of --prompt")
    ap.add_argument("--bits", default="4,5,6,7,8,10,12")
    ap.add_argument("--blocks", type=int, default=tc_ref.NB)
    ap.add_argument("--tail", type=int, default=0,
                    help="score only the last N positions (deep context only)")
    a = ap.parse_args()

    from transformers import AutoTokenizer
    tk = AutoTokenizer.from_pretrained(tc_ref.TEACHER)
    if a.wikitext:
        from datasets import load_dataset
        text = "\n\n".join(load_dataset("wikitext", "wikitext-2-raw-v1",
                                        split="test")["text"][:400])
        ids = tk(text).input_ids[:a.wikitext]
    else:
        ids = tk(a.prompt).input_ids
    sl = slice(len(ids) - a.tail, None) if a.tail else slice(None)
    print(f"{len(ids)} positions, {a.blocks} blocks, scoring {len(ids[sl])}\n",
          flush=True)

    t0 = time.time()
    base = run(a.cache, ids, "float", blocks=a.blocks)[sl]
    print(f"float path: {time.time()-t0:.0f}s\n", flush=True)
    bref = base.argmax(1)
    scale = np.abs(base).max(1)

    print(f"{'bits':>5} {'mean rel':>10} {'worst rel':>10} {'argmax kept':>12}")
    for b in [int(x) for x in a.bits.split(",")]:
        lg = run(a.cache, ids, "int", bits=b, blocks=a.blocks)[sl]
        rel = np.abs(lg - base).max(1) / scale
        kept = int((lg.argmax(1) == bref).sum())
        print(f"{b:>5} {rel.mean():>10.4f} {rel.max():>10.4f} "
              f"{kept:>7}/{len(bref)}", flush=True)


if __name__ == "__main__":
    main()
