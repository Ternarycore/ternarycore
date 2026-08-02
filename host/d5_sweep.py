#!/usr/bin/env python3
"""D5 sweep: verify every single-tile-addressable projection (k_proj, v_proj
of all 28 blocks = 56 layers, 1024x1024) of the exported student against the
board, exact-match, via the Stage-1 UART protocol.

Usage: python d5_sweep.py [--export ~/tc-export/d4-student-sst2-r2]
                          [--dev /dev/ttyUSB1] [--passes 2]
"""
import argparse, os, subprocess, sys, time
import numpy as np
import shutil

ap = argparse.ArgumentParser()
ap.add_argument("--export", default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
ap.add_argument("--dev", default="/dev/ttyUSB1")
ap.add_argument("--passes", type=int, default=2)
ap.add_argument("--host-script", default=os.path.expanduser(
    "~/hwsw/tcore/tc-arty/host/tier1_host.py"))
args = ap.parse_args()

EXP = args.export
ref = np.load(os.path.join(EXP, "reference.npz"))
work = os.path.join(EXP, "sweep-work")
os.makedirs(work, exist_ok=True)

results, t0 = [], time.time()
for b in range(28):
    for p in ("k", "v"):
        name = f"{b}.self_attn.{p}_proj"
        t = ref[name].astype(np.int32)
        rng = np.random.default_rng(1000 * b + (0 if p == "k" else 1))
        a = rng.integers(-8, 8, 1024).astype(np.int8)
        e = t @ a.astype(np.int32)
        open(os.path.join(work, "acts.bin"), "wb").write(a.tobytes())
        open(os.path.join(work, "expected.txt"), "w").write(" ".join(map(str, e)))
        shutil.copy(os.path.join(EXP, "layers", name.replace(".", "_") + ".bin"),
                    os.path.join(work, "weights.bin"))
        os.sync()
        r = subprocess.run(
            [sys.executable, args.host_script, "--dev", args.dev,
             "--weights", os.path.join(work, "weights.bin"),
             "--activations", os.path.join(work, "acts.bin"),
             "--expected", os.path.join(work, "expected.txt"),
             "--passes", str(args.passes)],
            capture_output=True, text=True, timeout=300)
        out = r.stdout
        ok = ("VERIFY PASS" in out) and ("HOST REFERENCE MATCH" in out)
        results.append((name, ok))
        print(f"SWEEP {name}: {'EXACT-MATCH' if ok else 'FAIL'} "
              f"({time.time()-t0:.0f}s elapsed)", flush=True)
        if not ok:
            print(out[-800:], flush=True)

good = sum(1 for _, ok in results if ok)
print(f"SWEEP COMPLETE: {good}/{len(results)} layers exact-match "
      f"in {(time.time()-t0)/60:.1f} min", flush=True)
""""""
