#!/usr/bin/env python3
"""patch_block_ddr.py -- run the block from DDR-resident weights.

Until now every check has packed a weight page on the host and pushed it
down the serial line immediately before using it. The token loop cannot:
110 MB of re-packing and 25 seconds a page is three hours per token. The
weights have to be resident in DDR and paged in by DMA from an offset.

That is a different failure surface. Host-pushed pages are correct by
construction -- they were packed from the matrix a line earlier. Resident
pages are correct only if build_ddr_image.py laid them out in exactly the
order project() walks them, and nothing has ever tested that. A page one
slot out gives a plausible-looking wrong answer, not a crash.

So --ddr looks each page up in pages.json by (block, projection, output
slice, depth segment) and asserts the offset also equals the positional
rule blk*15 + slot. Two independent derivations of the same number: the
lookup would happily agree with an image built in the wrong order, and
the positional rule would happily agree with a table built in the wrong
order, but they cannot both be wrong the same way.

  python tools/patch_block_ddr.py
  python tools/block_full.py --ddr --preload      # UART, ~6 min for 15 pages
  python tools/block_full.py --ddr                # already resident

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "block_full.py")
s = open(p).read()

if "DDR-resident" in s:
    sys.exit("already patched")

OLD_PROJ = '''def project(b, W, aq):
    """W @ aq on the board: 1024-output slices, depth segments accumulated."""
    out, inf = W.shape
    got = np.zeros(out, dtype=np.int64)
    for c in range(0, out, 1024):
        sub = W[c:c + 1024]
        for s in range(inf // 1024):
            load_bytes(b, pack_slice(sub[:, s * 1024:(s + 1) * 1024]))
            loadb(b, 3, aq[s * 1024:(s + 1) * 1024])
            b.send(f"PROJ 3 4 16 {s}\\n")
            b.until("OK PJ")
        got[c:c + 1024] = dumpi32(b, 4, 1024)
    return got'''

NEW_PROJ = '''PAGEB = 256 * 1024
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
    b.send(f"PAGEDMA {off}\\n")
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
            b.send(f"LOADM {off} {len(blob)}\\n")
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
            b.send(f"PROJ 3 4 16 {s}\\n")
            b.until("OK PJ")
        got[c:c + 1024] = dumpi32(b, 4, 1024)
    return got'''

OLD_ARGS = '''    ap.add_argument("--block", type=int, default=0)'''
NEW_ARGS = '''    ap.add_argument("--block", type=int, default=0)
    ap.add_argument("--ddr", action="store_true",
                    help="page weights from DDR rather than pushing them")
    ap.add_argument("--preload", action="store_true",
                    help="with --ddr: push this block's pages over UART first")
    ap.add_argument("--ddrdir", default=os.path.expanduser("~/tc-ddr"))'''

OLD_BOARD = '''    b = Board(a.dev)
    b.sync()
    print(f"stage 9: one complete block, block {blk}\\n")'''
NEW_BOARD = '''    b = Board(a.dev)
    b.sync()
    print(f"stage 9: one complete block, block {blk}\\n")

    if a.ddr:
        pg = json.load(open(os.path.join(a.ddrdir, "pages.json")))
        DDR["on"], DDR["blk"] = True, blk
        DDR["map"] = {(e["blk"], e["proj"], e["out_slice"], e["seg"]): e["off"]
                      for e in pg["pages"]}
        print(f"  DDR-resident weights, {pg['n_pages']} pages in the image")
        if a.preload:
            preload(b, blk, os.path.join(a.ddrdir, "weights.bin"))'''

CALLS = (
    ('project(b, W["q_proj"], aq)', 'project(b, W["q_proj"], aq, "q_proj")'),
    ('project(b, W["k_proj"], aq)', 'project(b, W["k_proj"], aq, "k_proj")'),
    ('project(b, W["v_proj"], aq)', 'project(b, W["v_proj"], aq, "v_proj")'),
    ('project(b, W["o_proj"], oa)', 'project(b, W["o_proj"], oa, "o_proj")'),
    ('project(b, W["gate_proj"], ha)',
     'project(b, W["gate_proj"], ha, "gate_proj")'),
    ('project(b, W["up_proj"], ha)',
     'project(b, W["up_proj"], ha, "up_proj")'),
    ('project(b, W["down_proj"], da)',
     'project(b, W["down_proj"], da, "down_proj")'),
)

for old, new in ((OLD_PROJ, NEW_PROJ), (OLD_ARGS, NEW_ARGS),
                 (OLD_BOARD, NEW_BOARD)) + CALLS:
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:150]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("block_full.py: --ddr / --preload added, 7 call sites named")
