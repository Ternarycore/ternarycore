#!/usr/bin/env python3
"""ternary.py -- run the model on the board.

    python tools/ternary.py "The"
    python tools/ternary.py "The movie was" --top 10
    python tools/ternary.py "The" --cpu        # soft-CPU normalizer

The twenty-eight transformer blocks run on the Arty, reading their 110 MB
of ternary weights out of DDR. The host does three things and no others:
turn the prompt into a token, look up its embedding, and turn the final
hidden state back into logits through the tied embedding table. What
crosses the serial line is one vector each way and one block-float scale.

What this does NOT do yet, stated plainly because the number below looks
like generation and is not: it predicts ONE token, at position 0. The
board's attention path -- KV cache, softmax, P.V -- is verified at four
positions by block_multi.py but is not yet wired into the block driver,
and at position 0 attention over a single key collapses to the value
vector, so none of it is exercised here. A second token needs that work.

Prerequisites, checked before anything is run:
  * the board is programmed and responding on --dev
  * the weight image is resident in DDR (eth_load.py put it there)
  * the block constants are resident (build_ddr_meta.py)

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from block_check import dumpi32, blockfloat, q15v, H, BIAS, Q15

NB = 28


def preflight(b):
    """Refuse to produce a confident wrong answer on an empty board.

    The failure this guards against is specific and has happened: DDR
    holding nothing, every projection returning zeros, and the loop
    reporting a token anyway -- argmax of a constant vector is still a
    token, and it looks exactly like an answer.
    """
    b.send("MREAD 0 0 0\n")
    out = b.until("OK MR", timeout=10)
    if "gmax" not in out:
        raise SystemExit("board did not answer MREAD -- is it programmed?")
    if "gmax 0x00000000" in out:
        raise SystemExit("block constants missing from DDR: "
                         "run tools/build_ddr_meta.py and reload them")
    b.send("PAGEDMA 0\n")
    b.until("OK PD", timeout=20)
    b.send("PROJ 3 4 16 0\n")
    o = b.until("OK PJ", timeout=30)
    if " PCHK 0\n" in o or "PCHK 0 " in o:
        raise SystemExit("page 0 computed zero -- the weight image is not "
                         "in DDR. Run tools/eth_load.py.")


def rope_slot(pos):
    """The rotation for this position: 64 cosines then 64 sines, Q15.

    512 bytes a token, and the same for all twenty-eight blocks, so the
    host sends it rather than the board holding a 512-entry table. That
    table is a better idea and can wait until something is measured to
    want it.
    """
    cos, sin = tc_ref.rope_tables(pos)
    ci = np.clip(np.rint(cos[:64] * 32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(sin[:64] * 32768), -Q15, Q15).astype(np.int32)
    return np.concatenate([ci, si])


def step(b, x, pos, nblocks, fab):
    """One position through all the blocks. Returns the hidden state.

    Everything the board needs that changes with position goes in first:
    the rotation into slot 16, the position itself, and the input vector
    with its block-float scale. Then one command runs twenty-eight
    blocks and one vector comes back.
    """
    b.loadv(16, rope_slot(pos))
    b.send(f"POS {pos}\n"); b.until("OK POS")
    xi, xf = q15v(x)
    m, e = blockfloat(xf)
    b.loadv(0, xi.astype(np.int32))
    b.send(f"XSC {m} {e + BIAS}\n"); b.until("OK XSC")
    b.send(f"TOK {nblocks} {fab}\n")
    out = b.until("OK TOK", timeout=600)
    t = [l for l in out.splitlines() if l.startswith("TOK m")][0].split()
    om, oe = int(t[2], 16), int(t[4])
    return dumpi32(b, 0, H).astype(np.float64) * om * (2.0 ** oe)


def main():
    ap = argparse.ArgumentParser(
        description="run the ternary model on the Arty A7-100T")
    ap.add_argument("prompt", nargs="?", default="The")
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--top", type=int, default=5)
    ap.add_argument("--cpu", action="store_true",
                    help="normalize on the soft CPU instead of in fabric")
    ap.add_argument("--blocks", type=int, default=NB)
    ap.add_argument("-n", "--tokens", type=int, default=1,
                    help="how many tokens to generate after the prompt")
    ap.add_argument("--compare", action="store_true",
                    help="also run the float64 reference and report the gap")
    a = ap.parse_args()

    fab = 0 if a.cpu else 1
    z = np.load(a.cache)
    from transformers import AutoTokenizer
    tk = AutoTokenizer.from_pretrained(tc_ref.TEACHER)

    ids = tk.encode(a.prompt)
    if not ids:
        raise SystemExit("empty prompt")

    b = Board(a.dev)
    b.sync()
    preflight(b)

    embed = z["embed"].astype(np.float64)
    gf = z["final_norm"].astype(np.float64)

    # Prefill every prompt token, then generate. Each position writes the
    # KV cache on the board as it goes, so the sequence has to run in
    # order from 0 -- which it does, because that is also the only order
    # a language model can be evaluated in.
    t0 = time.time()
    out_ids, pos = [], 0
    for tid in ids:
        h = step(b, embed[tid].copy(), pos, a.blocks, fab)
        pos += 1
    for _ in range(max(1, a.tokens)):
        logits = embed @ tc_ref.rmsnorm(h, gf)
        nxt = int(np.argmax(logits))
        out_ids.append(nxt)
        if pos >= 511:
            break
        h = step(b, embed[nxt].copy(), pos, a.blocks, fab)
        pos += 1
    board_s = total = time.time() - t0
    order = np.argsort(-logits)

    print(f"  {a.prompt!r} -> {len(ids)} token"
          f"{'s' if len(ids) != 1 else ''}, then {len(out_ids)} generated\n")
    print(f"    {a.prompt}{tk.decode(out_ids)}\n")
    for i, ix in enumerate(order[:a.top]):
        print(f"    {i + 1:2d}. {tk.decode([int(ix)])!r:<24} "
              f"{logits[ix]:10.4f}")
    print(f"\n  generated    {tk.decode(out_ids)!r}")
    npos = len(ids) + len(out_ids) - 1
    print(f"  {npos} position{'s' if npos != 1 else ''} x {a.blocks} blocks"
          f"   {board_s:.2f} s   ({board_s / max(npos,1):.2f} s/token, "
          f"normalizer {'in fabric' if fab else 'on the CPU'})")

    if a.compare:
        r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=a.blocks)
        # generate() returns the prompt followed by what it produced,
        # so the comparison is against its tail.
        want = list(tc_ref.generate(r, list(ids), len(out_ids)))[len(ids):]
        agree = want == out_ids
        print(f"\n  float64 reference on the host: {tk.decode(want)!r}")
        print(f"  token ids  board {out_ids}")
        print(f"             host  {want}")
        print(f"  {'AGREE' if agree else 'DIFFER'}")
        sys.exit(0 if agree else 1)


if __name__ == "__main__":
    main()
