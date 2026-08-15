"""Extend block_check through QK-norm and RoPE.

The first stage whose output the next one consumes as a scale rather than
a value. Every operator here is individually verified; what is not yet
proven is that they hand each other numbers in the units the receiver
expects, and that is precisely what a per-operator test cannot show.

Feeds QKN the accumulators the board itself produced, not synthetic ones.

Idempotent; safe to run twice.
"""
p = "tools/block_check.py"
s = open(p).read()

old = '''    print(f"\\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)'''

new = '''    # --- QK-norm + RoPE ------------------------------------------------
    # The first stage whose output another stage consumes as a scale.
    # RMSNorm cancels the projection's own factor, so what has to survive
    # the handoff is the per-head maximum and sum of squares the board
    # reports -- those alone let the host rebuild the true magnitude that
    # softmax needs.
    cos, sin = tc_ref.rope_tables(a.pos)
    ci = np.clip(np.rint(cos[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(sin[:HD // 2] * 32768), -Q15, Q15).astype(np.int32)
    b.loadv(2, np.concatenate([ci, si]))

    for name, nh in (("q", NH), ("k", NKV)):
        acc = accs[f"{name}_proj"]
        gq = z[f"{blk}.{name}_norm"].astype(np.float64)
        gqi, _ = q15v(gq)
        b.loadv(0, acc.astype(np.int32))
        b.loadv(1, gqi)
        b.send(f"QKN 0 1 2 3 4 {nh} {HD}\\n")
        b.until("OK QK")
        got = b.dumpr(3, nh * HD)

        cosf = np.concatenate([ci, ci]).astype(np.float64) / 32768.0
        sinf = np.concatenate([si, si]).astype(np.float64) / 32768.0
        want = np.zeros(nh * HD, dtype=np.int8)
        for h in range(nh):
            t = tc_ref.rmsnorm(acc[h * HD:(h + 1) * HD].astype(np.float64),
                               gqi.astype(np.float64))
            want[h * HD:(h + 1) * HD], _ = tc_ref.quant_a(
                tc_ref.rope(t, cosf, sinf))
        d = got.astype(int) - want.astype(int)
        nz, worst = int(np.count_nonzero(d)), int(np.abs(d).max())
        print(f"  {name}_norm + RoPE, {nh} heads")
        print(f"    {'int8 out':<26} {nz}/{nh*HD} differ, max |d| {worst}, "
              f"mean {d.mean():+.4f}")
        ok &= worst <= 1 and abs(d.mean()) < 0.02

    print(f"\\n{'PASS' if ok else 'FAIL'}")
    sys.exit(0 if ok else 1)'''

if "QK-norm + RoPE" not in s:
    assert old in s, "tail anchor missing"
    s = s.replace(old, new, 1)
    s = s.replace(
        '        ok &= report("accumulators", got, want, 0.0)\n',
        '        ok &= report("accumulators", got, want, 0.0)\n'
        '        accs[name] = got\n', 1)
    s = s.replace("    ok = True\n", "    ok = True\n    accs = {}\n", 1)
    s = s.replace('    ap.add_argument("--block", type=int, default=0)',
                  '    ap.add_argument("--block", type=int, default=0)\n'
                  '    ap.add_argument("--pos", type=int, default=0)', 1)
    open(p, "w").write(s)
print("extended" if "QK-norm + RoPE" in s else "MISS")
