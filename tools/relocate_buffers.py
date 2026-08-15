"""Move the benchmark scratch buffers out of local memory into DDR.

The MicroBlaze's LMB is 64 KB and holds code, data and bss together. With
stage 3 linked it stood at 65,372 of 65,536 -- 164 bytes clear, and five
stages still to write.

These four buffers are 13 KB of that and none is on a hot path: bench_buf,
bench_out and bench_i8 exist only for the BENCH command, and sw_out is the
software reference cmd_run compares the array against, run once per
verification rather than once per token. Moving them to DDR costs those
paths some cache misses and buys back the room the executor needs.

exp_lut and silu_lut stay in LMB deliberately -- those are read once per
element of every softmax and SiLU in every block, which is exactly what
single-cycle memory is for, and the DDR benchmark measured what moving a
hot vector out costs even with the cache on.

Addresses sit at 224 MB, clear of the weights at 0, the 110 MB model, and
the scratch vectors at 208 MB. Idempotent; safe to run twice.
"""
p = "tools/make_ddr_fw.py"
s = open(p).read()

MOVES = [
    ("static int bench_buf[BN];",
     "static int * const bench_buf = (int *)(DDR_BASE + 0x0E000000u);"),
    ("static int bench_out[BN];",
     "static int * const bench_out = (int *)(DDR_BASE + 0x0E010000u);"),
    ("static signed char bench_i8[BN];",
     "static signed char * const bench_i8 = "
     "(signed char *)(DDR_BASE + 0x0E020000u);"),
    ("static long sw_out[COLS_TOTAL];",
     "static long * const sw_out = (long *)(DDR_BASE + 0x0E030000u);"),
]

block = "\n# Buffers that do not belong in 64 KB of local memory.\n"
for old, new in MOVES:
    block += f"s = s.replace({old!r},\n              {new!r}, 1)\n"

anchor = 's = s.replace("Tier2 streaming firmware READY"'
assert anchor in s
if "do not belong in 64 KB" not in s:
    s = s.replace(anchor, block + "\n" + anchor, 1)
    open(p, "w").write(s)
print("relocated" if "do not belong in 64 KB" in s else "MISS")
