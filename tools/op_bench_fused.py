#!/usr/bin/env python3
"""op_bench_fused.py -- the token budget, from the operators that run it.

The old budget came from BENCH, whose operators are micro-loops written
beside the real ones. They drifted. bench_sumsq plus bench_quant totalled
183.1 ms a token; nq_core, which is those two fused and is what actually
runs, measured 488. Everything else in that table was built the same way,
so nothing in it could be trusted just because it said "measured".

This measures the handlers themselves. OPB repeats a real command with
the UART muted, so the operator's own report never lands in the timing,
and the host differences two repetition counts so the serial round trip
subtracts out. What is left is the operator.

  python tools/op_bench_fused.py --dev /dev/ttyUSB1
  python tools/op_bench_fused.py --rows NQD,SM --target 3.0

Every row is a real invocation at a real size, with the count per token
taken from the block structure rather than assumed:

    28 blocks, 1024 hidden, 16 q-heads over 8 kv-heads, head_dim 128,
    MLP intermediate 3072, context 512, and 15 weight pages a block --
    2 + 1 + 1 + 2 + 3 + 3 + 3 for q, k, v, o, gate, up, down.

Two honest caveats, both in the output.

Repetition sees drifting data where a handler transforms its input in
place. Every loop here is fixed-trip with no data-dependent branch beyond
a max comparison, so cycles per element do not move with the values --
but that is a property of today's operators, not a law.

The attention rows run against whatever the KV cache currently holds.
Their cost is trip counts over 512 positions, which is real; the numbers
in it are not.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board

NB, H, INTER, NH, NKV, HD, CTX = 28, 1024, 3072, 16, 8, 128, 512
POS = CTX - 1
BIAS = 512

#  label, command, calls per block, what it is
#
#  Sizes are the real ones. NQD's gain index picks the length: 0 in_norm
#  and post_norm at 1024, 4 o_proj.subln at 2048, 5 down_proj.subln at
#  3072. QKN runs once over all 16 q-heads and once over all 8 kv-heads.
#  The attention three run per q-head. PJO is one 1024-deep slice giving
#  1024 outputs, and there are 15 of them because there are 15 pages.
ROWS = [
    ("NQD n=1024", f"NQD 0 0 2 0 {H}", 2,
     "RMSNorm + absmax int8, fused, on the CPU"),
    ("NQD n=2048", "NQD 0 4 2 0 2048", 1,
     "same, o_proj SubLN"),
    ("NQD n=3072", f"NQD 0 5 2 0 {INTER}", 1,
     "same, down_proj SubLN"),
    ("NQF n=1024", f"NQF 0 0 3 0 {H}", 2,
     "the same operator in fabric"),
    ("NQF n=2048", "NQF 0 4 3 0 2048", 1,
     "the same operator in fabric"),
    ("NQF n=3072", f"NQF 0 5 3 0 {INTER}", 1,
     "the same operator in fabric"),
    ("QKN q  x16", f"QKN 0 1 2 3 4 {NH} {HD}", 1,
     "QK-norm + RoPE + quantize, fused, 16 heads"),
    ("QKN k  x8", f"QKN 0 1 2 5 6 {NKV} {HD}", 1,
     "the same, 8 kv-heads"),
    ("KVW", f"KVW 0 {POS} 7 8 9 {NKV} {HD}", 1,
     "bit-slice and append K and V"),
    ("QKD pos=511", f"QKD 0 0 {POS} 10 11", NH,
     "Q.K^T on the array, 512 keys"),
    ("SM  pos=511", f"SM 0 0 {POS} 11 1073741824 {BIAS} 12 13", NH,
     "softmax, table-driven, over 512 scores"),
    ("PV  pos=511", f"PV 0 0 {POS} 12 14", NH,
     "P.V on the array, 512 keys"),
    ("MLP n=3072", f"MLP 0 1 2 1073741824 {BIAS} {INTER}", 1,
     "SiLU + the gate product"),
    ("PJO", "PJO 5 0 6 16 0", 15,
     "1024 x 1024 ternary MACs on the array"),
    ("PAGEDMA", "PAGEDMA 0", 15,
     "one 256 KB weight page, DDR to BRAM"),
]


def slope(b, cmd, r1, r2, timeout=600):
    """Two repetition counts, one difference. The fixed cost cancels."""
    ts = []
    for r in (r1, r2):
        t0 = time.time()
        b.send(f"OPB {r} {cmd}\n")
        out = b.until("OK OPB", timeout=timeout)
        ts.append(time.time() - t0)
        if "ERR" in out:
            raise RuntimeError(f"{cmd}: {out.strip()}")
    return (ts[1] - ts[0]) / (r2 - r1), ts


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--target", type=float, default=2.0,
                    help="seconds the long run should take")
    ap.add_argument("--rows", default="",
                    help="comma-separated label prefixes; default all")
    a = ap.parse_args()

    want = [w.strip() for w in a.rows.split(",") if w.strip()]
    rows = [r for r in ROWS
            if not want or any(r[0].startswith(w) for w in want)]

    b = Board(a.dev)
    b.sync()
    print(f"fused operator budget -- {NB} blocks, context {CTX}, "
          f"{H} hidden, {NH}/{NKV} heads x {HD}\n")
    print(f"{'operator':<13} {'ms/call':>9} {'calls/tok':>10} "
          f"{'ms/token':>9}   what it is")
    print("-" * 86)

    total, results = 0.0, []
    for label, cmd, per_blk, what in rows:
        # Probe with the total, not the slope. A 2-vs-6 difference is
        # a few milliseconds of UART noise wide, and one unlucky sign
        # flip asks for 20000 repetitions of a 3 ms operator. Dividing
        # the whole run by its repetitions includes the fixed cost, so
        # it over-estimates per call and can only ask for too few.
        _, ts = slope(b, cmd, 4, 12)
        one = max(ts[1] / 12.0, 1e-5)
        reps = max(4, min(20000, int(a.target / one)))
        ms, _ = slope(b, cmd, reps, 3 * reps)
        ms *= 1000.0
        n = per_blk * NB
        tok = ms * n
        # the fabric normalizer is an alternative to the CPU one, not an
        # addition to it, so it is shown and not summed
        if not label.startswith("NQF"):
            total += tok
        results.append((label, ms, n, tok, what))
        print(f"{label:<13} {ms:>9.3f} {n:>10d} {tok:>9.1f}   {what}",
              flush=True)

    print("-" * 86)
    print(f"{'total':<13} {'':>9} {'':>10} {total:>9.1f}   "
          f"= {1000.0 / total:.2f} tok/s" if total else "")

    fab = sum(r[3] for r in results if r[0].startswith("NQF"))
    cpu = sum(r[3] for r in results if r[0].startswith("NQD"))
    if fab and cpu:
        print(f"\nwith the fabric normalizer instead of the CPU one: "
              f"{total - cpu + fab:.1f} ms "
              f"= {1000.0 / (total - cpu + fab):.2f} tok/s")

    print("\nCaveats, so they travel with the numbers:")
    print("  * repeated calls see drifting data where a handler works in")
    print("    place; every loop here is fixed-trip, which is why that is")
    print("    allowed, and it stops being allowed the moment one is not.")
    print("  * QKD/SM/PV run over whatever the KV cache holds. The trip")
    print("    counts over 512 positions are real; the values are not.")


if __name__ == "__main__":
    main()
