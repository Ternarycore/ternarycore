"""Make stage7_check test the reported scalars rather than a reconstruction.

The original compared a reconstructed sum against 1.0 -- but the
reconstruction divided by the same quantities it was supposed to be
checking, so several different wrong answers would still land on 1.0.

The board reports wmax and the sum of exponentials so the per-head divide
can happen downstream. Those two numbers are the whole interface, and
comparing them against the reference directly is simpler and stronger.

Idempotent; safe to run twice.
"""
p = "tools/stage7_check.py"
s = open(p).read()

old = """    # The scalars must close the normalization: sum of weights is one.
    wsum = float(np.sum(got.astype(np.float64)))
    denom = 127.0 * sume / 65536.0
    total = wsum * wmax * (2.0 ** vemax) / max(denom, 1e-30) if sume else 0.0
    # equivalently sum_j p_j -- reconstruct it directly
    recon = (got.astype(np.float64) * wmax * (2.0 ** vemax)) / \\
            (wmax * (2.0 ** vemax) / 1.0)
    recon = got.astype(np.float64) / PMAX * w.max() / (e.sum() * 1.0)
    ssum = float(recon.sum())

    print(f"  {name:<22} n={npos:<4} diff {nz}/{npos}, max |d| {worst}, "
          f"mean {d.mean():+.3f}   sum p = {ssum:.4f}")
    return worst <= 1 and abs(ssum - 1.0) < 0.02"""

new = """    # The two reported scalars are what closes the normalization
    # downstream, so check them against the reference directly rather than
    # reconstructing something that happens to come out near 1.0.
    got_wmax = wmax * (2.0 ** vemax)
    got_sume = sume / 65536.0
    rel_w = abs(got_wmax - w.max()) / w.max()
    rel_s = abs(got_sume - e.sum()) / e.sum()

    print(f"  {name:<22} n={npos:<4} diff {nz}/{npos}, max |d| {worst}, "
          f"mean {d.mean():+.3f}   wmax {rel_w*100:5.2f}%  sum-exp "
          f"{rel_s*100:5.2f}%")
    return worst <= 1 and rel_w < 0.01 and rel_s < 0.01"""

if "reported scalars are what closes" not in s:
    assert old in s, "anchor missing"
    s = s.replace(old, new, 1)
    open(p, "w").write(s)
print("patched" if "reported scalars are what closes" in s else "MISS")
