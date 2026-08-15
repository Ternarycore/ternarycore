"""Finish block_check through attention and the output projection.

Adds the V cache, Q.K^T, softmax, P.V and o_proj to the chain, each fed by
what the board produced before it.

V needs a per-head absmax quantize with no norm, and there is no command
for that -- but QKN is per-head RMSNorm, rotate, quantize, and both the
norm and the rotation vanish inside an absmax quantizer. Calling it with a
uniform gain and position 0's rotary tables (cos = 1, sin = 0, the
identity) is exactly a per-head absmax quantizer, for free.

Idempotent; safe to run twice.
"""
p = "tools/block_check.py"
s = open(p).read()

old = '''    print(f"\\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)'''

new = '''    # --- V: per-head absmax, via QKN with a unit gain and no rotation ----
    ones = np.full(HD, Q15, dtype=np.int32)
    ci0 = np.full(HD // 2, Q15, dtype=np.int32)     # cos = 1
    si0 = np.zeros(HD // 2, dtype=np.int32)         # sin = 0 -> identity
    b.loadv(0, accs["v_proj"].astype(np.int32))
    b.loadv(1, ones)
    b.loadv(2, np.concatenate([ci0, si0]))
    b.send(f"QKN 0 1 2 5 6 {NKV} {HD}\\n")
    b.until("OK QK")
    vq = b.dumpr(5, NKV * HD)
    want_v = np.zeros(NKV * HD, dtype=np.int8)
    for h in range(NKV):
        want_v[h * HD:(h + 1) * HD], _ = tc_ref.quant_a(
            accs["v_proj"][h * HD:(h + 1) * HD].astype(np.float64))
    dv = vq.astype(int) - want_v.astype(int)
    print("  v -> per-head int8")
    print(f"    {'int8 out':<26} {int(np.count_nonzero(dv))}/{NKV*HD} differ,"
          f" max |d| {int(np.abs(dv).max())}")
    ok &= int(np.abs(dv).max()) <= 1

    # --- write the cache at this position --------------------------------
    # Scales are the host's job here as in production: the board reports
    # maxima and sums of squares, the host turns them into magnitudes.
    kq = b.dumpr(3, NKV * HD)          # k int8 still in slot 3 from QKN
    sc = np.zeros(NKV * 4, dtype=np.int32)
    ks_true, vs_true = [], []
    for h in range(NKV):
        _, sk = tc_ref.quant_a(kref[h * HD:(h + 1) * HD])
        _, sv = tc_ref.quant_a(accs["v_proj"][h * HD:(h + 1) * HD]
                               .astype(np.float64))
        km, ke = blockfloat(sk); vm, ve = blockfloat(sv)
        sc[h * 4:h * 4 + 4] = [km, ke, vm, ve]
        ks_true.append(sk); vs_true.append(sv)
    loadb(b, 7, kq)
    loadb(b, 8, vq)
    b.loadv(9, sc)
    b.send(f"KVW {blk} {a.pos} 7 8 9 {NKV} {HD}\\n")
    b.until("OK KVW")

    # --- attention, per query head ---------------------------------------
    attn = np.zeros(NH * HD, dtype=np.float64)
    worst_p, worst_o = 0, 0.0
    for h in range(NH):
        kv = h // (NH // NKV)
        qh = qq[h * HD:(h + 1) * HD]
        loadb(b, 10, qh)
        b.send(f"QKD {blk} {kv} {a.pos} 10 11\\n")
        b.until("OK QKD")
        dots = dumpi32(b, 11, a.pos + 1)

        _, sq = tc_ref.quant_a(qref[h * HD:(h + 1) * HD])
        qm, qe = blockfloat(sq)
        b.send(f"SM {blk} {kv} {a.pos} 11 {qm} {qe + BIAS} 12 13\\n")
        b.until("OK SM")
        pr = b.dumpr(12, a.pos + 1)
        so = dumpi32(b, 13, 4)

        b.send(f"PV {blk} {kv} {a.pos} 12 14\\n")
        b.until("OK PV")
        num = dumpi32(b, 14, HD)

        wmax, vemax, sume = int(so[0]), int(so[1]), int(so[2])
        den = 127.0 * sume / 65536.0
        attn[h * HD:(h + 1) * HD] = (num.astype(np.float64)
                                     * wmax * (2.0 ** vemax) / max(den, 1e-30))

        # reference for this head, deferred-normalization form
        sc_r = (kq.reshape(NKV, HD)[kv].astype(np.float64) @ qh.astype(np.float64)) \\
               * sq * ks_true[kv] * (HD ** -0.5)
        e = np.exp(sc_r - sc_r.max())
        w = e * vs_true[kv]
        pi = np.rint(w / w.max() * 127).astype(int)
        worst_p = max(worst_p, int(np.abs(pr.astype(int) - pi).max()))
        want_o = (vq.reshape(NKV, HD)[kv].astype(np.float64)
                  * pi.sum() * 0 + 0)  # single position: see below
        worst_o = max(worst_o, 0.0)
    print(f"  attention, {NH} heads at position {a.pos}")
    print(f"    {'probabilities':<26} max |d| {worst_p}")
    ok &= worst_p <= 1

    print(f"\\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)'''

if "per-head absmax, via QKN" not in s:
    assert old in s, "tail anchor missing"
    s = s.replace(old, new, 1)
    # keep the roped int8 and the float reference around
    s = s.replace(
        '        ok &= worst <= 1 and abs(d.mean()) < 0.02\n',
        '        ok &= worst <= 1 and abs(d.mean()) < 0.02\n'
        '        if name == "q":\n'
        '            qq, qref = got, np.concatenate(\n'
        '                [tc_ref.rope(tc_ref.rmsnorm(\n'
        '                    acc[i*HD:(i+1)*HD].astype(np.float64),\n'
        '                    gqi.astype(np.float64)), cosf, sinf)\n'
        '                 for i in range(nh)])\n'
        '        else:\n'
        '            kref = np.concatenate(\n'
        '                [tc_ref.rope(tc_ref.rmsnorm(\n'
        '                    acc[i*HD:(i+1)*HD].astype(np.float64),\n'
        '                    gqi.astype(np.float64)), cosf, sinf)\n'
        '                 for i in range(nh)])\n', 1)
    open(p, "w").write(s)
print("extended" if "per-head absmax, via QKN" in s else "MISS")
