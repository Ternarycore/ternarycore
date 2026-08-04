#!/usr/bin/env python3
"""token_loop.py -- stage 10: twenty-eight blocks on silicon, one token out.

Everything before this verified a piece. This runs the whole model: embed
on the host, twenty-eight transformer blocks on the board reading
DDR-resident weights, then the final norm and the tied vocabulary
projection back on the host, and compares the next token against the
golden model's.

  python tools/token_loop.py --check          # one block, against tc_ref
  python tools/token_loop.py --prompt "The"   # a token

Position 0 only, deliberately. Attention over a single key is the value
vector itself, so the KV cache, softmax and P.V -- all verified
separately at four positions by block_multi.py -- contribute nothing at
the first token and would only add ways for this to fail at something
other than what it is testing. Generating a second token is the next
step, not this one.

The weights must already be resident: build_ddr_image.py writes the
image, eth_load.py puts it in DDR. Nothing here re-packs anything, and
the weight matrices are never loaded on the host at all -- Shaped below
carries the shape and raises if anything tries to read a coefficient,
so "DDR-resident" is enforced rather than intended.

Cost, honestly: about eleven seconds a block, and essentially none of it
is arithmetic. Fifteen pages at 0.81 ms is 12 ms; the rest is roughly
130 KB of operands and results crossing a 115200-baud serial line, 28
times. The firmware-side block driver is what turns that into about a
second. This is the milestone, not the machine.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from block_check import dumpi32, blockfloat, q15v, H, NH, NKV, HD, BIAS
from block_full import DDR, PAGEB, nq, project

INTER = 3072
NB = 28

#  the order build_ddr_image.py wrote them, which project() must match
PROJS = (("q_proj", 2048, H), ("k_proj", H, H), ("v_proj", H, H),
         ("o_proj", H, 2048), ("gate_proj", INTER, H), ("up_proj", INTER, H),
         ("down_proj", H, INTER))


class Shaped:
    """A weight matrix that knows its shape and refuses to be read.

    project() only touches coefficients when it has to pack a page on the
    host. In DDR mode it must not, and a stand-in that raises turns that
    from an intention into a guarantee -- otherwise the loop would
    silently keep working while quietly loading 110 MB per token.
    """

    def __init__(self, shape):
        self.shape = shape

    def __getitem__(self, k):
        raise RuntimeError("DDR mode read a weight coefficient on the host")


SHAPES = {n: Shaped((o, i)) for n, o, i in PROJS}


def run_block(b, z, blk, x):
    """One transformer block on the board, at position 0.

    The projections are issued in the image's order because ddr_page
    checks each request against the positional rule blk*15 + slot. q and
    k are computed and discarded here -- attention over one key is the
    value vector -- but they are still issued, so the page sequence is
    the real one and so is the cost.
    """
    DDR["blk"], DDR["slot"] = blk, 0

    def f(k):
        return z[f"{blk}.{k}"].astype(np.float64)

    def s(k):
        return float(z[f"{blk}.{k}.s"])

    aq, s_a, _ = nq(b, x, f("in_norm"), H)
    project(b, SHAPES["q_proj"], aq, "q_proj")
    project(b, SHAPES["k_proj"], aq, "k_proj")
    va = project(b, SHAPES["v_proj"], aq, "v_proj") * s("v_proj") * s_a

    attn = np.zeros(NH * HD)
    for hh in range(NH):
        kv = hh // (NH // NKV)
        attn[hh * HD:(hh + 1) * HD] = va[kv * HD:(kv + 1) * HD]

    oa, s_o, _ = nq(b, attn, f("o_proj.subln"), 2048)
    x1 = x + project(b, SHAPES["o_proj"], oa, "o_proj") * s("o_proj") * s_o

    ha, s_h, _ = nq(b, x1, f("post_norm"), H)
    g = project(b, SHAPES["gate_proj"], ha, "gate_proj")
    u = project(b, SHAPES["up_proj"], ha, "up_proj")
    gm, ge = blockfloat(s("gate_proj") * s_h)
    b.loadv(0, g.astype(np.int32))
    b.loadv(1, u.astype(np.int32))
    b.send(f"MLP 0 1 2 {gm} {ge + BIAS} {INTER}\n")
    b.until("OK MLP")
    m = dumpi32(b, 2, INTER).astype(np.float64)

    # No scale on m: RMSNorm cancels it, and nq's returned scale is
    # invariant to its input's magnitude. Getting this wrong is what made
    # the MLP contribute nothing while the block still reported a pass.
    da, s_d, _ = nq(b, m, f("down_proj.subln"), INTER)
    return x1 + project(b, SHAPES["down_proj"], da, "down_proj") \
        * s("down_proj") * s_d


def open_ddr(ddrdir, verbose=True):
    pg = json.load(open(os.path.join(ddrdir, "pages.json")))
    DDR["on"] = True
    DDR["map"] = {(e["blk"], e["proj"], e["out_slice"], e["seg"]): e["off"]
                  for e in pg["pages"]}
    if verbose:
        print(f"  DDR-resident weights: {pg['n_pages']} pages, "
              f"{pg['n_pages'] * PAGEB / 1e6:.1f} MB")
    return pg


def check(b, z, a):
    """run_block against tc_ref, on block_full.py's own test input.

    This file reimplements the block body rather than importing it, so
    the copy has to earn its trust: same seed, same reference, same
    acceptance. The version it was copied from passed three times with
    the MLP contributing nothing, so a threshold that only the attention
    half can satisfy is not good enough -- 0.005 is well below the 0.0283
    a dead MLP scores.
    """
    blk = a.block
    rng = np.random.default_rng(7000 + blk)
    x = rng.standard_normal(H) * 3.0
    x[rng.integers(0, H, 8)] *= 40.0

    r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=NB)
    r.reset()
    tc_ref.rope_tables(0)
    want = r.block(blk, x.copy(), 0, *tc_ref.rope_tables(0))

    t0 = time.time()
    got = run_block(b, z, blk, x)
    rel = np.abs(got - want).max() / max(np.abs(want).max(), 1e-30)
    print(f"  block {blk} vs golden model   rel {rel:.6f}   "
          f"{time.time()-t0:.1f}s")
    ok = rel < 0.005
    print(f"\n{'PASS' if ok else 'FAIL'}")
    return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--ddrdir", default=os.path.expanduser("~/tc-ddr"))
    ap.add_argument("--prompt", default="The")
    ap.add_argument("--block", type=int, default=0)
    ap.add_argument("--blocks", type=int, default=NB)
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--board", action="store_true",
                    help="all 28 blocks with TOK, instead of driving "
                         "them one operator at a time over the wire")
    ap.add_argument("--fab", type=int, default=1,
                    help="1 normalizes in fabric, 0 on the soft CPU")
    a = ap.parse_args()

    z = np.load(a.cache)
    b = Board(a.dev)
    b.sync()
    open_ddr(a.ddrdir)

    if a.check:
        sys.exit(0 if check(b, z, a) else 1)

    from transformers import AutoTokenizer
    tk = AutoTokenizer.from_pretrained(tc_ref.TEACHER)
    tok = tk.encode(a.prompt)[0]
    print(f"\nprompt {a.prompt!r} -> token {tok} "
          f"({tk.decode([tok])!r}), position 0\n")

    embed = z["embed"].astype(np.float64)
    x = embed[tok].copy()
    t0 = time.time()
    if a.board:
        # The whole stack on the board. What crosses the wire is the
        # embedding vector in, the hidden state out, and one block-float
        # scale -- which is the entire difference between 574.8 seconds
        # a token and one and a half.
        xi, xf = q15v(x)
        m, e = blockfloat(xf)
        b.loadv(0, xi.astype(np.int32))
        b.send(f"XSC {m} {e + BIAS}\n")
        b.until("OK XSC")
        b.send(f"TOK {a.blocks} {a.fab}\n")
        out = b.until("OK TOK", timeout=600)
        t = [l for l in out.splitlines() if l.startswith("TOK m")][0].split()
        om, oe = int(t[2], 16), int(t[4])
        x = dumpi32(b, 0, H).astype(np.float64) * om * (2.0 ** oe)
        print(f"  {a.blocks} blocks on the board   |x| "
              f"{np.abs(x).max():9.3f}   {time.time()-t0:6.2f}s", flush=True)
    else:
        for blk in range(a.blocks):
            x = run_block(b, z, blk, x)
            print(f"  block {blk:2d}/{a.blocks}   |x| "
                  f"{np.abs(x).max():9.3f}   {time.time()-t0:6.1f}s",
                  flush=True)

    xf = tc_ref.rmsnorm(x, z["final_norm"].astype(np.float64))
    logits = embed @ xf
    nxt = int(np.argmax(logits))

    # The reference runs the same twenty-eight blocks in float64 on the
    # host. Agreeing on the argmax is the claim; the logit error says how
    # much room there was to disagree.
    r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=a.blocks)
    r.reset()
    want = r.forward(tok, 0)
    wnxt = int(np.argmax(want))
    rel = np.abs(logits - want).max() / max(np.abs(want).max(), 1e-30)

    print(f"\n  board     token {nxt:6d}  {tk.decode([nxt])!r}")
    print(f"  reference token {wnxt:6d}  {tk.decode([wnxt])!r}")
    print(f"  logits rel {rel:.6f}")
    print(f"  top-5 board     {[int(i) for i in np.argsort(-logits)[:5]]}")
    print(f"  top-5 reference {[int(i) for i in np.argsort(-want)[:5]]}")
    print(f"\n  {time.time()-t0:.1f}s for {a.blocks} blocks")

    ok = nxt == wnxt
    print(f"\n{'PASS -- first token on silicon' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
