"""Do two back-to-back page loads within one operator both take effect?

q_proj's accumulator has its first 1024 outputs equal to its second 1024.
Either the second page load overwrites the first result, or the first
page load never happened and both runs used the same weights. Distinct
pages must give distinct results; that is the whole test.

Uses PAGEDMA, the verified pager, not the driver's page_load -- so if
these DIFFER the fault is in page_load, and if they are IDENTICAL it is
further down in the array readout and page_load is innocent.
"""
import sys, numpy as np
sys.path.insert(0,'tools')
from stage_check import Board
from block_check import dumpi32, loadb

b = Board('/dev/ttyUSB1'); b.sync()
rng = np.random.default_rng(11)
a = rng.integers(-128, 128, 1024).astype(np.int8)
loadb(b, 31, a)

res = {}
for tag, off in (("page0", 0), ("page1", 262144), ("page0 again", 0),
                 ("page2 (k_proj)", 524288)):
    b.send(f"PAGEDMA {off}\n"); b.until("OK PD", timeout=30)
    b.send("PJO 31 0 22 16 0\n"); b.until("OK PJO", timeout=30)
    res[tag] = dumpi32(b, 22, 1024).astype(np.int64)
    print(f"  {tag:<16} first 6 {res[tag][:6]}")

p0, p1 = res["page0"], res["page1"]
print(f"\n  page0 vs page1        max|d| {int(np.abs(p0-p1).max())}")
print(f"  page0 vs page0 again  max|d| "
      f"{int(np.abs(p0-res['page0 again']).max())}")
print(f"  page0 vs page2        max|d| "
      f"{int(np.abs(p0-res['page2 (k_proj)']).max())}")
print("\n  page0 vs page1 must be nonzero -- they are different weights.")
