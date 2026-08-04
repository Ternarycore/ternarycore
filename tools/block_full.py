#!/usr/bin/env python3
"""block_full.py -- one complete transformer block, against tc_ref.

Fifteen weight pages and twenty-odd operators, and one comparison that
matters: the block's output residual against the reference's, from the
same input.

  python tools/block_full.py --block 0

Everything before this verified operators. A block is mostly handoffs, so
this verifies something different. The two residual adds have never run
at all -- they are the only points where a magnitude from one stage is
added to a magnitude from another, and therefore the last place two
self-consistent scales can disagree.

Position 0 on purpose: attention with history is proven separately at four
positions, and keeping it trivial here focuses a six-minute run on the
half that has never run end to end.
"""
import argparse, json, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board
from stage2_check import unpack, loadb
from block_check import (q15v, pack_slice, load_bytes, dumpi32, blockfloat,
                         H, NH, NKV, HD, Q15, BIAS)

INTER = 3072


PAGEB = 256 * 1024
DDR = {"on": False, "blk": 0, "map": {}, "slot": 0}


def ddr_page(b, name, c, s):
    """Page a DDR-resident weight page, by two independent derivations.

    The table lookup and the positional rule blk*15 + slot are derived
    from different things -- one from build_ddr_image.py's record of what
    it wrote, one from the order project() asks. A lookup alone would
    agree with an image built in the wrong order; the rule alone would
    agree with a table built in the wrong order. Requiring both is what
    makes a page landing one slot out a failure rather than a plausible
    wrong answer.
    """
    off = DDR["map"][(DDR["blk"], name, c, s)]
    want = (DDR["blk"] * 15 + DDR["slot"]) * PAGEB
    if off != want:
        sys.exit(f"page order: {name} slice {c} seg {s} is at {off}, "
                 f"but it is request {DDR['slot']} of block {DDR['blk']} "
                 f"which the index rule puts at {want}")
    DDR["slot"] += 1
    b.send(f"PAGEDMA {off}\n")
    b.until("OK PD")


def preload(b, blk, image):
    """Push one block's fifteen pages into DDR over UART.

    Only for testing the resident path before the Ethernet loader is
    available -- 15 pages is six minutes, 420 would be three hours, which
    is the entire reason eth_load.py exists.
    """
    with open(image, "rb") as f:
        for slot in range(15):
            off = (blk * 15 + slot) * PAGEB
            f.seek(off)
            blob = f.read(PAGEB)
            t0 = time.time()
            b.send(f"LOADM {off} {len(blob)}\n")
            time.sleep(0.3)
            for i in range(0, len(blob), 4096):
                b.send(blob[i:i + 4096])
                time.sleep(0.012)
            b.until("OK M")
            print(f"    preload slot {slot:2d} -> off {off:9d}  "
                  f"{time.time()-t0:5.1f}s", flush=True)


def project(b, W, aq, name=None):
    """W @ aq on the board: 1024-output slices, depth segments accumulated."""
    out, inf = W.shape
    got = np.zeros(out, dtype=np.int64)
    for c in range(0, out, 1024):
        sub = W[c:c + 1024]
        for s in range(inf // 1024):
            if DDR["on"]:
                ddr_page(b, name, c // 1024, s)
            else:
                load_bytes(b, pack_slice(sub[:, s * 1024:(s + 1) * 1024]))
            loadb(b, 3, aq[s * 1024:(s + 1) * 1024])
            b.send(f"PROJ 3 4 16 {s}\n")
            b.until("OK PJ")
        got[c:c + 1024] = dumpi32(b, 4, 1024)
    return got


def nq(b, x, gain, n):
    """Fused RMSNorm+quantize; returns int8 and the true output scale."""
    xi, xf = q15v(x)
    gi, _ = q15v(gain)
    gmax = float(np.abs(gain).max())
    b.loadv(0, xi)
    b.loadv(1, gi)
    b.send(f"NQ 0 1 2 {n}\n")
    out = b.until("OK NQ")
    t = [l for l in out.splitlines() if l.startswith("NQ ")][0].split()
    mx, ss, xs = int(t[2]), int(t[4], 16), int(t[6])
    a = b.dumpr(2, n)
    rms = np.sqrt(ss * (4.0 ** xs) / n)
    return a, (gmax * mx / (Q15 * 127.0 * rms) if rms > 0 else 0.0), xi


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--block", type=int, default=0)
    ap.add_argument("--ddr", action="store_true",
                    help="page weights from DDR rather than pushing them")
    ap.add_argument("--preload", action="store_true",
                    help="with --ddr: push this block's pages over UART first")
    ap.add_argument("--ddrdir", default=os.path.expanduser("~/tc-ddr"))
    a = ap.parse_args()

    z = np.load(a.cache)
    man = json.load(open(os.path.join(a.export, "manifest.json")))
    blk = a.block
    W = {}
    for n, o, i in (("self_attn.q_proj", 2048, H), ("self_attn.k_proj", H, H),
                    ("self_attn.v_proj", H, H), ("self_attn.o_proj", H, 2048),
                    ("mlp.gate_proj", INTER, H), ("mlp.up_proj", INTER, H),
                    ("mlp.down_proj", H, INTER)):
        W[n.split(".")[-1]] = unpack(
            os.path.join(a.export, man["layers"][f"{blk}.{n}"]["file"]), o, i)

    b = Board(a.dev)
    b.sync()
    print(f"stage 9: one complete block, block {blk}\n")

    if a.ddr:
        pg = json.load(open(os.path.join(a.ddrdir, "pages.json")))
        DDR["on"], DDR["blk"] = True, blk
        DDR["map"] = {(e["blk"], e["proj"], e["out_slice"], e["seg"]): e["off"]
                      for e in pg["pages"]}
        print(f"  DDR-resident weights, {pg['n_pages']} pages in the image")
        if a.preload:
            preload(b, blk, os.path.join(a.ddrdir, "weights.bin"))
    t0 = time.time()

    rng = np.random.default_rng(7000 + blk)
    x = rng.standard_normal(H) * 3.0
    x[rng.integers(0, H, 8)] *= 40.0

    # ---- reference: the same block in tc_ref, on the same input ---------
    r = tc_ref.Ref(cache=a.cache, mode="int", nblocks=28)
    r.reset()
    cos, sin = tc_ref.rope_tables(0)
    want = r.block(blk, x.copy(), 0, cos, sin)

    # ---- attention half --------------------------------------------------
    h1 = tc_ref.rmsnorm(x, z[f"{blk}.in_norm"].astype(np.float64))
    aq, s_a, _ = nq(b, x, z[f"{blk}.in_norm"].astype(np.float64), H)
    qa = project(b, W["q_proj"], aq, "q_proj") * float(z[f"{blk}.q_proj.s"]) * s_a
    ka = project(b, W["k_proj"], aq, "k_proj") * float(z[f"{blk}.k_proj.s"]) * s_a
    va = project(b, W["v_proj"], aq, "v_proj") * float(z[f"{blk}.v_proj.s"]) * s_a
    print(f"  q/k/v projections            {time.time()-t0:5.1f}s")

    # attention at position 0 collapses to the value vector itself
    gq = z[f"{blk}.q_norm"].astype(np.float64)
    gk = z[f"{blk}.k_norm"].astype(np.float64)
    attn = np.zeros(NH * HD)
    for hh in range(NH):
        attn[hh * HD:(hh + 1) * HD] = va[(hh // (NH // NKV)) * HD:
                                         (hh // (NH // NKV) + 1) * HD]

    # ---- o_proj + residual ------------------------------------------------
    oa, s_o, _ = nq(b, attn, z[f"{blk}.o_proj.subln"].astype(np.float64), 2048)
    o = project(b, W["o_proj"], oa, "o_proj") * float(z[f"{blk}.o_proj.s"]) * s_o
    x1 = x + o
    print(f"  o_proj + residual            {time.time()-t0:5.1f}s")

    # ---- MLP half ---------------------------------------------------------
    ha, s_h, _ = nq(b, x1, z[f"{blk}.post_norm"].astype(np.float64), H)
    g = project(b, W["gate_proj"], ha, "gate_proj")
    u = project(b, W["up_proj"], ha, "up_proj")
    s_g = float(z[f"{blk}.gate_proj.s"]) * s_h
    gm, ge = blockfloat(s_g)
    b.loadv(0, g.astype(np.int32))
    b.loadv(1, u.astype(np.int32))
    b.send(f"MLP 0 1 2 {gm} {ge + BIAS} {INTER}\n")
    mo = b.until("OK MLP")
    mtok = [l for l in mo.splitlines() if l.startswith("MLP ")][0].split()
    su_, ss_, sm_ = int(mtok[4]), int(mtok[6]), int(mtok[8])
    m = dumpi32(b, 2, INTER).astype(np.float64)
    print(f"  gate/up + SiLU               {time.time()-t0:5.1f}s")

    da, s_d, _ = nq(b, m, z[f"{blk}.down_proj.subln"].astype(np.float64), INTER)
    # m carries an arbitrary global scale, and everything downstream is
    # invariant to it except this one multiply into the residual.
    #
    # Analytically, from the shifts cmd_mlp reports:
    #   o[i] = silu(x) * up[i] * 65536 * 2^-(ss + su + sm)
    # so s_u * 2^(ss+su+sm) / 65536 recovers true magnitude. sa is absent
    # because it is spent normalizing the table index, not the result.
    #
    # The reference-derived value below is kept only to check this one.
    # It was what the block used to run on, and it is the single number in
    # the block that the token loop could not have obtained -- it would
    # have failed at the last step with everything before it working.
    s_u = float(z[f"{blk}.up_proj.s"]) * s_h
    s_m = s_u * (2.0 ** (ss_ + su_ + sm_)) / 65536.0

    gt = g.astype(np.float64) * s_g
    ut = u.astype(np.float64) * s_u
    mt = (gt / (1.0 + np.exp(-gt))) * ut
    s_ref = float(np.abs(mt).max()) / max(float(np.abs(m).max()), 1e-30)
    print(f"  MLP out scale   analytic {s_m:.6e}   reference {s_ref:.6e}"
          f"   ratio {s_m / s_ref:.6f}")
    # No s_m here, and that is the whole point. nq's scale is invariant
    # to its input's magnitude -- q15v normalizes by max|x|, so the
    # returned gmax*mx*max|x| / (Q15^2 * 127 * rms(x)) has the input's
    # magnitude in both numerator and denominator. Feed it m or s_m*m and
    # it answers the same, because RMSNorm cancels global gain and SiLU
    # has already been paid for upstream.
    #
    # Multiplying by s_m = 3.3e-05 therefore scaled the MLP's entire
    # contribution to the residual out of existence: |d| = 0.0000 against
    # a reference contribution of 4.86, with |x1| = 171.8.
    d = project(b, W["down_proj"], da, "down_proj") * float(z[f"{blk}.down_proj.s"]) \
        * s_d
    x2 = x1 + d
    print(f"  down_proj + residual         {time.time()-t0:5.1f}s")

    r_out = np.abs(x2 - want).max() / max(np.abs(want).max(), 1e-30)
    print(f"\n  block output vs golden model  rel {r_out:.6f}")

    # Is this comparison actually sensitive to the MLP's output scale?
    # Switching s_m from reference-derived to analytic moved rel by
    # nothing, to six decimals. Either it is right or the metric cannot
    # see it, and those want opposite responses. rel is a max over the
    # vector and the input carries eight deliberate 40x spikes, so the
    # max may well sit where the MLP contributes nothing.
    print(f"    |x1| {np.abs(x1).max():10.3f}   |d| {np.abs(d).max():10.3f}"
          f"   ratio {np.abs(d).max()/max(np.abs(x1).max(), 1e-30):.4f}")
    rk = {}
    for k in (0.25, 0.5, 1.0, 2.0, 4.0):
        rk[k] = np.abs(x1 + d * k - want).max() / max(np.abs(want).max(), 1e-30)
        print(f"    MLP x{k:<5g}  rel {rk[k]:.6f}")
    sens = min(rk[0.25], rk[4.0]) / max(r_out, 1e-30)
    print(f"    sensitivity {sens:6.1f}x")

    # Two conditions, because the threshold alone passed a block whose
    # MLP contributed nothing at all. rel is measured against |x1| = 171.8
    # and the MLP contributes 4.86, so an absent MLP reads as 0.0283 --
    # comfortably under 0.05. Three runs printed that as a PASS.
    #
    # Requiring the error to move when the MLP's contribution moves is
    # what makes this check able to fail.
    ok = r_out < 0.05 and sens > 5.0
    if not ok and r_out < 0.05:
        print("\n  FAIL: the block agrees with the reference but the "
              "comparison cannot see the MLP -- that is not a pass")
    print(f"\n{'PASS' if ok else 'FAIL'}  ({time.time()-t0:.0f}s)")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
