#!/usr/bin/env python3
"""d1_audit.py -- the D1 gate: does this shape fit the accelerator?

    python tools/d1_audit.py
    python tools/d1_audit.py --student 18,1024,2048,8,8,128

docs/DISTILLATION_PLAN.md makes D1 a hard gate -- no training until the
shapes clear the constraints -- and gives a table to check them against.
That table is not the constraint. It says "hidden dims multiple of 64",
which is the array's COLS tiling, and every projection this machine runs
needs both dimensions to be whole 1024-tiles. A shape can pass the table
and still be unexportable, which is how a week went on q_proj.

So this audits against tools/shape_budget.check, every projection of every
block, and then against the three things the plan's table never mentions:

  * the exporter packs GROUPS = out/4, which only lines up with the
    array's 1024 columns when out is exactly 1024. Every other layer has
    to be re-packed in 1024-output slices, and this says which.
  * page geometry. The firmware addresses a page as blk*SLOTS + slot,
    SLOTS is 15, and 15 is not a constant of nature -- it is the number
    of pages one block's seven projections need at the current shape.
  * DDR and the KV cache, which the shape moves in opposite directions.

And it reports the one thing that decides how D2 and D3 are built: which
teacher tensors map onto the student and which do not.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from shape_budget import check, predict, REF, TILE

PAGE_BYTES = 262144
DDR_TOTAL = 256 << 20
IMAGE_LIMIT = 0x06900000        # where build_ddr_meta says the image ends
KV_BASE = 0x08000000


def projections(s):
    """(name, out, in) for one block, in the order the pager lays them out."""
    qd, kvd, H, I = s["NH"] * s["HD"], s["NKV"] * s["HD"], s["H"], s["I"]
    return [("q_proj", qd, H), ("k_proj", kvd, H), ("v_proj", kvd, H),
            ("o_proj", H, qd), ("gate_proj", I, H), ("up_proj", I, H),
            ("down_proj", H, I)]


def audit(name, s, kvmax):
    print(f"\n{'='*74}\n  {name}")
    print(f"  L={s['L']}  H={s['H']}  I={s['I']}  "
          f"{s['NH']}q/{s['NKV']}kv x {s['HD']}\n")

    bad = check(s)
    if bad:
        for b in bad:
            print(f"    GATE FAILED: {b}")
        return None

    print(f"    {'layer':<11}{'out':>6}{'in':>6}   {'pages':>6}  "
          f"{'tiles ok':>9}  re-pack at export?")
    print("    " + "-" * 66)
    slots, params, needs_slice = 0, 0, []
    for pname, out, inf in projections(s):
        pages = (out // TILE) * (inf // TILE)
        slots += pages
        params += out * inf
        slice_ = out != TILE
        if slice_:
            needs_slice.append(f"{pname} ({out} outputs -> {out//TILE} slices)")
        print(f"    {pname:<11}{out:>6}{inf:>6}   {pages:>6}  "
              f"{'yes':>9}  {'YES' if slice_ else 'no'}")

    total_pages = slots * s["L"]
    tern = params * s["L"]
    mb = tern / 4 / 1e6
    print(f"    " + "-" * 66)
    print(f"    {'per block':<11}{'':>12}   {slots:>6} pages")
    print(f"\n    {tern/1e6:.1f} M ternary weights, {mb:.1f} MB packed, "
          f"{total_pages} pages")

    print(f"\n  page geometry")
    print(f"    SLOTS per block is {slots}, not 15." if slots != 15 else
          f"    SLOTS per block is 15, unchanged.")
    if slots != 15:
        print(f"    fw_exec's page = blk*15 + slot and tools/pages.json both")
        print(f"    hard-code 15. Both change with this shape.")

    print(f"\n  re-packing at export")
    if needs_slice:
        for n in needs_slice:
            print(f"    {n}")
        print(f"    (out == 1024 is the only case the exporter's "
              f"GROUPS = out/4 gets right)")
    else:
        print(f"    none -- every projection has exactly 1024 outputs")

    print(f"\n  DDR")
    img_end = total_pages * PAGE_BYTES
    kv = s["L"] * s["NKV"] * s["HD"] * kvmax * 2
    if img_end == IMAGE_LIMIT:
        verdict = "exactly fills"
    elif img_end < IMAGE_LIMIT:
        verdict = "fits inside"
    else:
        verdict = "OVERRUNS"
    print(f"    image ends at 0x{img_end:08X}  ({verdict} the "
          f"0x{IMAGE_LIMIT:08X} the meta record assumes)")
    print(f"    KV cache at {kvmax} positions: {kv/1e6:.1f} MB "
          f"(K and V), region starts 0x{KV_BASE:08X}")
    print(f"    embedding stays float on the host and is not in any of this")

    t, _, _ = predict(s, 512)
    tref, _, _ = predict(REF, 512)
    print(f"\n  predicted {t:.0f} ms/token at context 512   "
          f"({tref/t:.2f}x the current student)")
    return dict(slots=slots, pages=total_pages, tern=tern)


def mapping(t, s):
    print(f"\n{'='*74}\n  what carries over from the teacher\n")
    rows = [
        ("embedding + lm_head (tied)", t["H"] == s["H"], "identical"),
        ("every RMSNorm and SubLN gain", t["H"] == s["H"], "identical"),
        ("k_proj, v_proj", t["NKV"] * t["HD"] == s["NKV"] * s["HD"]
         and t["H"] == s["H"], "identical per surviving block"),
        ("q_proj, o_proj", t["NH"] == s["NH"],
         f"choose {s['NH']} of {t['NH']} query heads"),
        ("gate, up, down", t["I"] == s["I"],
         f"choose {s['I']} of {t['I']} MLP channels"),
        ("the blocks themselves", t["L"] == s["L"],
         f"choose {s['L']} of {t['L']} layers"),
    ]
    for name, ok, note in rows:
        print(f"    {'OK   ' if ok else 'PRUNE'}  {name:<30} {note}")

    if all(r[1] for r in rows):
        print(f"\n    Everything maps. This is the paper's recipe exactly:")
        print(f"    SubLN surgery on the teacher, ternarize in place.")
    else:
        print(f"\n    This student is not the teacher with SubLN inserted.")
        print(f"    It is a structurally pruned teacher, and D2 needs a")
        print(f"    pruning step -- head, channel and layer selection --")
        print(f"    that arXiv:2510.13998 does not cover. The distillation")
        print(f"    after it is unchanged; the initialisation is not.")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--student", default="18,1024,2048,8,8,128")
    ap.add_argument("--kvmax", type=int, default=512)
    a = ap.parse_args()
    keys = ["L", "H", "I", "NH", "NKV", "HD"]
    stu = dict(zip(keys, map(int, a.student.split(","))))

    print("D1 gate -- shapes against the accelerator, not against the plan's")
    print("constraints table. The array is 1024 wide and 1024 deep.")
    audit("teacher / current student -- Qwen3-0.6B shape", dict(REF), a.kvmax)
    audit("proposed student", stu, a.kvmax)
    mapping(dict(REF), stu)
    print()


if __name__ == "__main__":
    main()
