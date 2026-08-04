#!/usr/bin/env python3
"""block_multi.py -- the attention half at several positions.

Position 0 proves the operators connect and little else: with one key the
probability is 1.0 by construction, so softmax and P.V do no work. This
builds real history and checks attention where it has a distribution to
get wrong.

  python tools/block_multi.py --npos 4

Loop order is what makes it affordable. Weights are identical across
positions, so each projection is paged in once and every position runs
through it -- four page loads for four positions instead of sixteen.
"""
import argparse, json, os, sys, time
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import tc_ref
from stage_check import Board
from stage2_check import unpack, loadb, PAGE
from block_check import (q15v, pack_slice, load_bytes, dumpi32, blockfloat,
                         H, NH, NKV, HD, Q15, BIAS)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--export",
                    default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--block", type=int, default=0)
    ap.add_argument("--npos", type=int, default=4)
    a = ap.parse_args()

    z = np.load(a.cache)
    man = json.load(open(os.path.join(a.export, "manifest.json")))
    blk, npos = a.block, a.npos
    b = Board(a.dev)
    b.sync()
    print(f"stage 9: attention at {npos} positions, block {blk}\n")
    ok = True

    # --- one int8 activation per position --------------------------------
    gain = z[f"{blk}.in_norm"].astype(np.float64)
    gi, _ = q15v(gain)
    acts = []
    for p in range(npos):
        rng = np.random.default_rng(500 + p)
        x = rng.standard_normal(H) * 3.0
        x[rng.integers(0, H, 8)] *= 40.0
        xi, _ = q15v(x)
        b.loadv(0, xi)
        b.loadv(1, gi)
        b.send(f"NQ 0 1 2 {H}\n")
        b.until("OK NQ")
        aq = b.dumpr(2, H)
        want, _ = tc_ref.quant_a(tc_ref.rmsnorm(xi.astype(np.float64),
                                                gi.astype(np.float64)))
        if not np.array_equal(aq, want):
            print(f"  position {p}: activations differ"); ok = False
        acts.append(aq)
    print(f"  input_layernorm x{npos}          all exact")

    # --- one page load per projection, every position through it ---------
    accs = {n: [None] * npos for n in ("q_proj", "k_proj", "v_proj")}
    for name, outf in (("k_proj", 1024), ("v_proj", 1024), ("q_proj", 2048)):
        key = f"{blk}.self_attn.{name}"
        W = unpack(os.path.join(a.export, man["layers"][key]["file"]), outf, H)
        t0 = time.time()
        for c in range(0, outf, 1024):
            load_bytes(b, pack_slice(W[c:c + 1024]))
            for p in range(npos):
                loadb(b, 3, acts[p])
                b.send("PROJ 3 4 16 0\n")
                b.until("OK PJ")
                got = dumpi32(b, 4, 1024)
                if accs[name][p] is None:
                    accs[name][p] = np.zeros(outf, dtype=np.int64)
                accs[name][p][c:c + 1024] = got
        bad = sum(int(not np.array_equal(
            accs[name][p], W.astype(np.int32) @ acts[p].astype(np.int32)))
            for p in range(npos))
        print(f"  {name:<10} {outf:>4}x{H}  {outf//1024} page(s), "
              f"{time.time()-t0:5.1f}s   {npos-bad}/{npos} exact")
        ok &= bad == 0

    # --- QK-norm, RoPE, V quantize, cache write, per position ------------
    ones = np.full(HD, Q15, dtype=np.int32)
    kref, vref, qref, qq_all = {}, {}, {}, {}
    for p in range(npos):
        cos, sin = tc_ref.rope_tables(p)
        ci = np.clip(np.rint(cos[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
        si = np.clip(np.rint(sin[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
        cosf = np.concatenate([ci, ci]).astype(np.float64) / 32768.0
        sinf = np.concatenate([si, si]).astype(np.float64) / 32768.0
        b.loadv(2, np.concatenate([ci, si]))

        out = {}
        for name, nh in (("q", NH), ("k", NKV)):
            acc = accs[f"{name}_proj"][p]
            gq, _ = q15v(z[f"{blk}.{name}_norm"].astype(np.float64))
            b.loadv(0, acc.astype(np.int32))
            b.loadv(1, gq)
            b.send(f"QKN 0 1 2 3 4 {nh} {HD}\n")
            b.until("OK QK")
            out[name] = b.dumpr(3, nh * HD)
            ref = np.concatenate([tc_ref.rope(tc_ref.rmsnorm(
                acc[i * HD:(i + 1) * HD].astype(np.float64),
                gq.astype(np.float64)), cosf, sinf) for i in range(nh)])
            (qref if name == "q" else kref)[p] = ref
            if name == "k":
                kq = out["k"]
        qq_all[p] = out["q"]

        # V: per-head absmax via QKN with unit gain and identity rotation
        b.loadv(1, ones)
        b.loadv(2, np.concatenate([np.full(HD // 2, Q15, dtype=np.int32),
                                   np.zeros(HD // 2, dtype=np.int32)]))
        b.loadv(0, accs["v_proj"][p].astype(np.int32))
        b.send(f"QKN 0 1 2 5 6 {NKV} {HD}\n")
        b.until("OK QK")
        vq = b.dumpr(5, NKV * HD)
        vref[p] = accs["v_proj"][p].astype(np.float64)

        sc = np.zeros(NKV * 4, dtype=np.int32)
        for h in range(NKV):
            _, sk = tc_ref.quant_a(kref[p][h * HD:(h + 1) * HD])
            _, sv = tc_ref.quant_a(vref[p][h * HD:(h + 1) * HD])
            km, ke = blockfloat(sk); vm, ve = blockfloat(sv)
            sc[h * 4:h * 4 + 4] = [km, ke, vm, ve]
        loadb(b, 7, kq)
        loadb(b, 8, vq)
        b.loadv(9, sc)
        b.send(f"KVW {blk} {p} 7 8 9 {NKV} {HD}\n")
        b.until("OK KVW")
    print(f"  QK-norm/RoPE/V x{npos}          cache written")

    # --- attention at the last position, with real history ---------------
    pos = npos - 1
    worst_p, worst_o = 0, 0.0
    for h in range(NH):
        kv = h // (NH // NKV)
        qh = qq_all[pos][h * HD:(h + 1) * HD]
        loadb(b, 10, qh)
        b.send(f"QKD {blk} {kv} {pos} 10 11\n")
        b.until("OK QKD")
        dots = dumpi32(b, 11, pos + 1)

        _, sq = tc_ref.quant_a(qref[pos][h * HD:(h + 1) * HD])
        qm, qe = blockfloat(sq)
        b.send(f"SM {blk} {kv} {pos} 11 {qm} {qe + BIAS} 12 13\n")
        b.until("OK SM")
        pr = b.dumpr(12, pos + 1)
        so = dumpi32(b, 13, 4)
        b.send(f"PV {blk} {kv} {pos} 12 14\n")
        b.until("OK PV")
        num = dumpi32(b, 14, HD)

        # reference: the same deferred-normalization form, on the same ints
        K = np.stack([tc_ref.quant_a(kref[p][kv * HD:(kv + 1) * HD])[0]
                      for p in range(npos)])
        ks = np.array([tc_ref.quant_a(kref[p][kv * HD:(kv + 1) * HD])[1]
                       for p in range(npos)])
        V = np.stack([tc_ref.quant_a(vref[p][kv * HD:(kv + 1) * HD])[0]
                      for p in range(npos)])
        vs = np.array([tc_ref.quant_a(vref[p][kv * HD:(kv + 1) * HD])[1]
                       for p in range(npos)])
        want_dots = K.astype(np.int32) @ qh.astype(np.int32)
        if not np.array_equal(dots, want_dots):
            print(f"    head {h}: dots differ"); ok = False
        sc_r = want_dots.astype(np.float64) * sq * ks * (HD ** -0.5)
        e = np.exp(sc_r - sc_r.max())
        w = e * vs
        pi = np.rint(w / w.max() * 127).astype(int)
        worst_p = max(worst_p, int(np.abs(pr.astype(int) - pi).max()))

        got_o = num.astype(np.float64) * int(so[0]) * (2.0 ** int(so[1])) \
            / max(127.0 * int(so[2]) / 65536.0, 1e-30)
        want_o = (pi @ V.astype(np.float64)) * w.max() / (127.0 * e.sum())
        worst_o = max(worst_o, float(np.abs(got_o - want_o).max()
                                     / max(np.abs(want_o).max(), 1e-30)))

    print(f"  attention at position {pos}, {pos+1} keys, {NH} heads")
    print(f"    probabilities              max |d| {worst_p}")
    print(f"    head output                rel {worst_o:.6f}")
    ok &= worst_p <= 1 and worst_o < 0.02
    print(f"\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
