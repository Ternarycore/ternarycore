"""Compare the board's dot products against the keys the board cached.

The multi-position run flagged every head's dots as differing while the
probabilities matched exactly and the head outputs came within 0.008.
That combination does not describe a broken dot product -- it describes a
reference built from different operands.

tc_ref.quant_a on the float tensor gives the reference's keys; the cache
holds the board's, and the two differ by up to one LSB, which is stage
3's measured floor. Feeding one set to the reference and another to the
hardware guarantees a mismatch that means nothing.

Idempotent; safe to run twice.
"""
p = "tools/block_multi.py"
s = open(p).read()

if "kq_all[p] = kq" not in s:
    s = s.replace("    kref, vref, qref, qq_all = {}, {}, {}, {}",
                  "    kref, vref, qref, qq_all = {}, {}, {}, {}\n"
                  "    kq_all, vq_all = {}, {}", 1)
    s = s.replace('        qq_all[p] = out["q"]',
                  '        qq_all[p] = out["q"]\n        kq_all[p] = kq', 1)
    s = s.replace('        vref[p] = accs["v_proj"][p].astype(np.float64)',
                  '        vref[p] = accs["v_proj"][p].astype(np.float64)\n'
                  '        vq_all[p] = vq', 1)
    s = s.replace(
        """        K = np.stack([tc_ref.quant_a(kref[p][kv * HD:(kv + 1) * HD])[0]
                      for p in range(npos)])""",
        """        K = np.stack([kq_all[p].reshape(NKV, HD)[kv]
                      for p in range(npos)])""", 1)
    s = s.replace(
        """        V = np.stack([tc_ref.quant_a(vref[p][kv * HD:(kv + 1) * HD])[0]
                      for p in range(npos)])""",
        """        V = np.stack([vq_all[p].reshape(NKV, HD)[kv]
                      for p in range(npos)])""", 1)
    open(p, "w").write(s)
print("patched" if "kq_all[p] = kq" in s else "MISS")
