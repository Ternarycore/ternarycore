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
from block_check import dumpi32, blockfloat, q15v, H, BIAS

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
    if len(ids) > 1:
        print(f"note: {a.prompt!r} is {len(ids)} tokens and only the first "
              f"is used -- position 0 only, see the module docstring\n")
    tok = ids[0]

    b = Board(a.dev)
    b.sync()
    preflight(b)

    embed = z["embed"].astype(np.float64)
    x = embed[tok].copy()

    xi, xf = q15v(x)
    m, e = blockfloat(xf)
    b.loadv(0, xi.astype(np.int32))
    b.send(f"XSC {m} {e + BIAS}\n")
    b.until("OK XSC")

    t0 = time.time()
    b.send(f"TOK {a.blocks} {fab}\n")
    out = b.until("OK TOK", timeout=600)
    board_s = time.time() - t0
    t = [l for l in out.splitlines() if l.startswith("TOK m")][0].split()
    om, oe = int(t[2], 16), int(t[4])
    x = dumpi32(b, 0, H).astype(np.float64) * om * (2.0 ** oe)

    logits = embed @ tc_ref.rmsnorm(x, z["final_norm"].astype(np.float64))
    order = np.argsort(-logits)
    total = time.time() - t0

    print(f"  {a.prompt!r} -> token {tok} ({tk.decode([tok])!r})\n")
    for i, ix in enumerate(order[:a.top]):
        print(f"    {i + 1:2d}. {tk.decode([int(ix)])!r:<24} "
              f"{logits[ix]:10.4f}")
    print(f"\n  next token   {tk.decode([int(order[0])])!r}")
    print(f"  {a.blocks} blocks on the board   {board_s:.2f} s"
          f"   ({board_s / a.blocks * 1000:.0f} ms/block, "
          f"normalizer {'in fabric' if fab else 'on the CPU'})")
    print(f"  total incl. the wire and the host's lm_head   {total:.2f} s")

    if a.compare:
        r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=a.blocks)
        r.reset()
        want = r.forward(tok, 0)
        rel = np.abs(logits - want).max() / max(np.abs(want).max(), 1e-30)
        agree = int(np.argmax(want)) == int(order[0])
        print(f"\n  float64 reference on the host: "
              f"{tk.decode([int(np.argmax(want))])!r}")
        print(f"  logits rel {rel:.6f}   argmax "
              f"{'agrees' if agree else 'DIFFERS'}")
        sys.exit(0 if agree else 1)


if __name__ == "__main__":
    main()
