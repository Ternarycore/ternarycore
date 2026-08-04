#!/usr/bin/env python3
"""patch_eth_offset.py -- let eth_load put an image somewhere other than 0.

The weight image starts at DDR offset 0 and is a whole number of 256 KB
pages, so eth_load assumed both. meta.bin is neither: it goes to
0x07000000, in the gap between the weight image and the KV cache, and
896 KB is three and a half pages.

Both assumptions were silent. `size // PAGE` on a 3.5-page file loads
three pages and drops the rest without a word, which is the failure this
project keeps meeting -- not a crash, just less than you asked for, and
a checksum that verifies exactly the part that got sent.

  python tools/patch_eth_offset.py
  python3-netraw tools/eth_load.py --image ~/tc-ddr/meta.bin --at 0x07000000
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "eth_load.py")
s = open(p).read()

if "--at" in s:
    sys.exit("already patched")

OLD_ARG = '''    ap.add_argument("--limit", type=int, default=0,
                    help="stop after this many pages (0 = all)")'''
NEW_ARG = '''    ap.add_argument("--limit", type=int, default=0,
                    help="stop after this many pages (0 = all)")
    ap.add_argument("--at", default="0",
                    help="DDR byte offset for the start of the image")'''

OLD_LOOP = '''    size = os.path.getsize(a.image)
    npages = size // PAGE
    if a.limit:
        npages = min(npages, a.limit)
    print(f"{a.image}: {size/1e6:.1f} MB, {npages} pages\\n")
    t0, done = time.time(), 0
    with open(a.image, "rb") as f:
        for p in range(npages):
            blob = f.read(PAGE)
            send_region(b, sock, src, p * PAGE, blob, a.chunk, a.gap)'''

NEW_LOOP = '''    size = os.path.getsize(a.image)
    base = int(a.at, 0)
    # Round up, not down. Truncating division on an image that is not a
    # whole number of pages loads the whole pages and silently drops the
    # tail, and every checksum still matches because they only cover what
    # was sent.
    npages = (size + PAGE - 1) // PAGE
    if a.limit:
        npages = min(npages, a.limit)
    print(f"{a.image}: {size/1e6:.1f} MB, {npages} pages "
          f"at DDR 0x{base:08X}\\n")
    t0, done = time.time(), 0
    with open(a.image, "rb") as f:
        for p in range(npages):
            blob = f.read(PAGE)
            if not blob:
                break
            send_region(b, sock, src, base + p * PAGE, blob, a.chunk, a.gap)'''

for old, new in ((OLD_ARG, NEW_ARG), (OLD_LOOP, NEW_LOOP)):
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:160]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("eth_load.py: --at added, partial final page no longer dropped")
