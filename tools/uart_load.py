#!/usr/bin/env python3
"""uart_load.py -- the slow way to fill DDR, so the fast way is optional.

eth_load.py puts 110 MB into DDR in under a minute and needs CAP_NET_RAW.
This does the same job down the serial line at 23 seconds a page, which
is 2.6 hours for the model. That is a bad trade in every respect except
one: it needs nothing but the cable that is already plugged in.

  python tools/uart_load.py                  # resume, load everything
  python tools/uart_load.py --start 0 --end 15

Resumable on purpose. 2.6 hours is long enough that losing power partway
is a real possibility rather than a hypothetical -- this project has had
six outages in a day -- and a loader that restarts from zero after two
hours is worse than no loader. Progress is written after every verified
page, so the worst an outage costs is the page in flight.

Verification is LOADM's byte sum. That sum is order-independent, which
made it useless for Ethernet where frames can land in the wrong place --
but bytes cannot reorder on a serial stream, and dropped or duplicated
bytes are the failure that actually happens here, which it does catch.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board

PAGE = 256 * 1024


def load_page(b, off, blob, tries=3):
    want = sum(blob) & 0xFFFFFFFF
    for attempt in range(tries):
        b.send(f"LOADM {off} {len(blob)}\n")
        time.sleep(0.3)
        for i in range(0, len(blob), 4096):
            b.send(blob[i:i + 4096])
            time.sleep(0.012)
        out = b.until("OK M", timeout=90)
        got = int([l for l in out.splitlines()
                   if l.startswith("OK M")][0].split()[2], 16)
        if got == want:
            return
        print(f"    page at {off}: sum {got:08x} want {want:08x}, "
              f"retry {attempt+1}/{tries}", flush=True)
        time.sleep(0.5)
    raise RuntimeError(f"page at {off} failed {tries} times")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--ddrdir", default=os.path.expanduser("~/tc-ddr"))
    ap.add_argument("--start", type=int, default=0)
    ap.add_argument("--end", type=int, default=0, help="0 = all")
    ap.add_argument("--fresh", action="store_true",
                    help="ignore saved progress")
    a = ap.parse_args()

    img = os.path.join(a.ddrdir, "weights.bin")
    prog = os.path.join(a.ddrdir, "uart_progress.json")
    npages = os.path.getsize(img) // PAGE
    end = a.end or npages
    start = a.start

    if not a.fresh and os.path.exists(prog):
        done = json.load(open(prog)).get("next", 0)
        if done > start:
            print(f"resuming at page {done} (saved progress)")
            start = done

    print(f"{img}: {npages} pages, loading {start}..{end-1} over UART")
    print(f"  about {(end-start)*23.1/60:.0f} minutes at 23 s a page\n")

    b = Board(a.dev)
    b.sync()
    t0 = time.time()
    with open(img, "rb") as f:
        for p in range(start, end):
            f.seek(p * PAGE)
            load_page(b, p * PAGE, f.read(PAGE))
            with open(prog, "w") as g:
                json.dump({"next": p + 1, "of": npages}, g)
            n = p - start + 1
            if p % 5 == 0 or p == end - 1:
                el = time.time() - t0
                print(f"  page {p:3d}/{end}  {n*PAGE/1e6:6.1f} MB  "
                      f"{el/60:5.1f} min  eta {(end-p-1)*el/n/60:5.1f} min",
                      flush=True)

    el = time.time() - t0
    print(f"\n{(end-start)*PAGE/1e6:.1f} MB in {el/60:.1f} min "
          f"({(end-start)*PAGE*8/el/1e6:.2f} Mbit/s)")


if __name__ == "__main__":
    main()
