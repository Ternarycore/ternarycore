"""tokcurve.py -- what a token costs on the board, against context length.

ternary.py reports 4.63 s/token, and that number mixes three things: the
twenty-eight blocks, the prefill, and roughly a kilobyte each way over a
115200-baud line. TOK is the board alone, so timing it directly at
several positions separates them and shows how the cost grows.

Six of the nine operators in a block do not depend on position and three
do -- Q.K^T, softmax and P.V all walk 0..pos. The slope is those three.

  python tools/tokcurve.py
"""
import sys, time
import numpy as np
sys.path.insert(0,'tools')
import tc_ref
from stage_check import Board
from block_check import dumpi32, blockfloat, q15v, H, BIAS, Q15

def rope_slot(pos):
    c, s = tc_ref.rope_tables(pos)
    ci = np.clip(np.rint(c[:64]*32768), -Q15, Q15).astype(np.int32)
    si = np.clip(np.rint(s[:64]*32768), -Q15, Q15).astype(np.int32)
    return np.concatenate([ci, si])

b = Board('/dev/ttyUSB1'); b.sync()
rng = np.random.default_rng(7000)
x = rng.standard_normal(H)*3.0; x[rng.integers(0,H,8)] *= 40.0
xi, xf = q15v(x); m, e = blockfloat(xf)

print("twenty-eight blocks on the board, by position\n")
print(f"  {'pos':>4} {'s/token':>9} {'ms/block':>9} {'vs pos 0':>9}")
print("  " + "-"*36)
base = None
for pos in (0, 1, 15, 63, 127, 255, 511):
    b.loadv(16, rope_slot(pos))
    b.send(f"POS {pos}\n"); b.until("OK POS")
    b.loadv(0, xi.astype(np.int32))
    b.send(f"XSC {m} {e+BIAS}\n"); b.until("OK XSC")
    t0 = time.time()
    b.send("TOK 28 1\n"); b.until("OK TOK", timeout=600)
    dt = time.time() - t0
    if base is None: base = dt
    print(f"  {pos:>4} {dt:>9.3f} {dt/28*1000:>9.1f} {dt/base:>8.2f}x",
          flush=True)

print("\n  the wire is not in these numbers: TOK is one command in and")
print("  one 'OK TOK' out. ternary.py's per-token figure adds a 4 KB")
print("  vector each way plus the rotation, at 115200 baud.")
