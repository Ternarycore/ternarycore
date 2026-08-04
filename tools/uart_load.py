#!/usr/bin/env python3
"""uart_load.py -- the slow way to fill DDR, so the fast way is optional.

eth_load.py puts 110 MB into DDR in under a minute and needs CAP_NET_RAW.
This does the same job down the serial line at 23 seconds a page, which
is 2.6 hours for the model. That is a bad trade in every respect except
one: it needs nothing but the cable that is already plugged in.

  python tools/uart_load.py                  # resume, load everything
  python tools/uart_load.py --start 0 --end 15

Resumable, but not naively. The progress file records what the *host
sent*; DDR records what *survived*. Those agree until power is lost, and
power is exactly when the file gets trusted -- a blackout takes the FPGA
bitstream with it, so the board returns reprogrammed and empty while the
file still says two hundred pages are resident. Resuming there would
leave everything below it as garbage, and every check downstream would
be measuring noise while reporting numbers.

So ddr_probe() looks at DDR instead of at the record: page 0 into the
array, a known activation through it, compared against the same product
computed on the host. Two seconds, and it settles the question the
progress file cannot.

Per-page verification is LOADM's byte sum. That sum is order-independent,
which made it useless for Ethernet where a frame can land in the wrong
page -- but bytes cannot reorder on a serial stream, and dropped or
duplicated bytes are the failure that actually happens here.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stage_check import Board
from stage2_check import loadb
from block_check import dumpi32

PAGE = 256 * 1024


def unpack_page(blob):
    """One packed page back to (1024 out, 1024 in) ternary.

    The exact inverse of build_ddr_image.pack_slice: addr = k*256 + g,
    four codes per byte LSB-first, 00 = 0, 01 = +1, 10 = -1.
    """
    raw = np.frombuffer(blob, dtype=np.uint8).reshape(1024, 256)
    codes = np.stack([(raw >> (2 * s)) & 3 for s in range(4)], axis=2)
    w = np.where(codes == 1, 1, np.where(codes == 2, -1, 0)).astype(np.int8)
    return w.reshape(1024, 1024).T


def ddr_probe(b, img, page=0):
    """Does DDR still hold what the progress file claims?

    Page it into the array and multiply a known activation through it.
    Anything short of an exact match means the contents are not what was
    written -- which after a blackout they will not be, because losing
    power takes the bitstream and the DDR controller with it.
    """
    with open(img, "rb") as f:
        f.seek(page * PAGE)
        W = unpack_page(f.read(PAGE))
    rng = np.random.default_rng(4242)
    a = rng.integers(-128, 128, 1024).astype(np.int8)

    b.send(f"PAGEDMA {page * PAGE}\n")
    b.until("OK PD")
    loadb(b, 3, a)
    b.send("PROJ 3 4 16 0\n")
    b.until("OK PJ")
    got = dumpi32(b, 4, 1024).astype(np.int64)
    want = W.astype(np.int32) @ a.astype(np.int32)
    bad = int(np.count_nonzero(got - want))
    return bad == 0, bad


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
    ap.add_argument("--no-probe", action="store_true",
                    help="resume without checking DDR actually survived")
    a = ap.parse_args()

    img = os.path.join(a.ddrdir, "weights.bin")
    prog = os.path.join(a.ddrdir, "uart_progress.json")
    npages = os.path.getsize(img) // PAGE
    end = a.end or npages
    start = a.start

    if not a.fresh and os.path.exists(prog):
        done = json.load(open(prog)).get("next", 0)
        if done > start:
            start = done

    b = Board(a.dev)
    b.sync()

    if start > 0 and not a.no_probe:
        print(f"progress file says {start} pages resident -- probing DDR",
              flush=True)
        ok, bad = ddr_probe(b, img)
        if ok:
            print(f"  page 0 verifies exactly, resuming at {start}\n")
        else:
            print(f"  page 0 is wrong in {bad}/1024 outputs: DDR did not "
                  f"survive.\n  The progress file records what was sent, not "
                  f"what is there.\n  Restarting from page 0.\n")
            start = 0

    print(f"{img}: {npages} pages, loading {start}..{end-1} over UART")
    print(f"  about {(end-start)*23.1/60:.0f} minutes at 23 s a page\n")

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
