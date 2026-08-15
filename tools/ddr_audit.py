#!/usr/bin/env python3
"""ddr_audit.py -- does DDR still hold what the file says it should?

eth_load verifies every transfer as it writes it. That is a check on the
wire: it says the bytes arrived. It says nothing about what is in memory
afterwards, and nothing in this project has ever asked.

A page that held its neighbour's bytes survived here for months because
of that gap. It was invisible for a specific reason: q_proj's first
output block is the only page in the image no test ever read, since the
block driver computed q and discarded it. This audit would have found it
in a few seconds, and it did not exist.

  python tools/ddr_audit.py                 # the whole weight image
  python tools/ddr_audit.py --pages 0,1,2   # just these
  python tools/ddr_audit.py --meta          # the block constants too

DSUM computes the same weighted sum eth_load reproduces in Python, over
DDR rather than over the wire. The weighting is not decoration: a plain
byte sum is order-blind, and one once reported a perfect match on a page
whose weights had been scrambled. Every word is multiplied by its own
address.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board
from eth_load import fw_checksum

PAGE = 262144
META_OFF = 0x07000000
META_STRIDE = 0x8000
NBLK = 28


def dsum(b, off, n):
    b.send(f"DSUM {off} {n}\n")
    out = b.until("OK DS", timeout=60)
    for line in out.splitlines():
        if line.startswith("DSUM "):
            return int(line.split()[1], 16)
    raise RuntimeError(f"no DSUM in {out!r}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--ddrdir", default=os.path.expanduser("~/tc-ddr"))
    ap.add_argument("--pages", default="",
                    help="comma-separated page numbers; default all")
    ap.add_argument("--meta", action="store_true",
                    help="also audit the block constants at 0x07000000")
    a = ap.parse_args()

    img = os.path.join(a.ddrdir, "weights.bin")
    size = os.path.getsize(img)
    npages = size // PAGE
    want_pages = ([int(t) for t in a.pages.split(",") if t.strip()]
                  or list(range(npages)))

    b = Board(a.dev)
    b.sync()
    print(f"auditing the resident image against {img}")
    print(f"  {npages} pages, {size/1e6:.1f} MB\n")

    bad, t0 = [], time.time()
    with open(img, "rb") as f:
        for pg in want_pages:
            off = pg * PAGE
            f.seek(off)
            want = fw_checksum(off, f.read(PAGE))
            got = dsum(b, off, PAGE)
            if got != want:
                bad.append((pg, got, want))
                print(f"  page {pg:4d} off 0x{off:08X}  "
                      f"board {got:08x}  file {want:08x}   MISMATCH",
                      flush=True)
            elif pg % 60 == 0:
                print(f"  page {pg:4d} ok   {time.time()-t0:5.1f} s",
                      flush=True)

    if a.meta:
        mb = os.path.join(a.ddrdir, "meta.bin")
        if os.path.exists(mb):
            print()
            with open(mb, "rb") as f:
                for blk in range(NBLK):
                    off = META_OFF + blk * META_STRIDE
                    f.seek(blk * META_STRIDE)
                    want = fw_checksum(off, f.read(META_STRIDE))
                    got = dsum(b, off, META_STRIDE)
                    if got != want:
                        bad.append((f"meta {blk}", got, want))
                        print(f"  meta block {blk:2d}  board {got:08x}  "
                              f"file {want:08x}   MISMATCH", flush=True)
            print(f"  {NBLK} constant records checked")
        else:
            print(f"\n  no {mb} -- skipping the constants")

    dt = time.time() - t0
    print(f"\n  {len(want_pages)} pages in {dt:.1f} s")
    if bad:
        print(f"  {len(bad)} MISMATCH -- reload with tools/eth_load.py "
              f"and audit again")
    else:
        print("  every page matches the file")
    print(f"\n{'PASS' if not bad else 'FAIL'}")
    sys.exit(0 if not bad else 1)


if __name__ == "__main__":
    main()
