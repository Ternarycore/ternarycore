#!/usr/bin/env python3
"""D5 tiling: verify NON-square projections (q/o/gate/up/down) on the board
by host-side tiling — zero firmware changes. The board stays a 1024x1024
single-tile engine; the host splits big matrices into tiles:

  out > 1024  -> column tiles, run per tile, concatenate
  in  > 1024  -> depth chunks, run per chunk with the acts slice, SUM host-side

Verifies all 7 projections of one block against reference.npz, exact-match.
Usage: python tile_verify.py [--block 0] [--export ...] [--dev /dev/ttyUSB1]
"""
import argparse, os, subprocess, sys, tempfile, time
import numpy as np

ap = argparse.ArgumentParser()
ap.add_argument("--block", type=int, default=0)
ap.add_argument("--export", default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
ap.add_argument("--dev", default="/dev/ttyUSB1")
ap.add_argument("--host-script", default=os.path.expanduser(
    "~/hwsw/tcore/tc-arty/host/tier1_host.py"))
args = ap.parse_args()

TILE = 1024
ref = np.load(os.path.join(args.export, "reference.npz"))


def pack(tern):  # [out<=1024, in=1024] -> firmware layout GROUPS=256
    codes = np.where(tern == 0, 0, np.where(tern == 1, 1, 2)).astype(np.uint8)
    t = codes.T
    g = t.reshape(t.shape[0], -1, 4)
    return (g[:, :, 0] | (g[:, :, 1] << 2) | (g[:, :, 2] << 4) |
            (g[:, :, 3] << 6)).astype(np.uint8)


def run_tile(tern, a):  # tern [1024,1024], a int8[1024] -> int32[1024]
    with tempfile.TemporaryDirectory() as d:
        e = tern.astype(np.int32) @ a.astype(np.int32)
        open(os.path.join(d, "w.bin"), "wb").write(pack(tern).tobytes())
        open(os.path.join(d, "a.bin"), "wb").write(a.tobytes())
        open(os.path.join(d, "e.txt"), "w").write(" ".join(map(str, e)))
        r = subprocess.run([sys.executable, args.host_script, "--dev", args.dev,
                            "--weights", os.path.join(d, "w.bin"),
                            "--activations", os.path.join(d, "a.bin"),
                            "--expected", os.path.join(d, "e.txt"),
                            "--passes", "1"],
                           capture_output=True, text=True, timeout=300)
        assert "HOST REFERENCE MATCH" in r.stdout, r.stdout[-600:]
        return e   # board == host reference (asserted), use it for assembly


b = args.block
names = [f"{b}.self_attn.{p}_proj" for p in "qkvo"] + \
        [f"{b}.mlp.{p}_proj" for p in ("gate", "up", "down")]
t0 = time.time()
for name in names:
    t = ref[name].astype(np.int8)
    out_d, in_d = t.shape
    rng = np.random.default_rng(hash(name) % 2**31)
    a = rng.integers(-8, 8, in_d).astype(np.int8)
    result = np.zeros(out_d, np.int64)
    tiles = 0
    for ct in range(0, out_d, TILE):          # column tiles
        acc = np.zeros(min(TILE, out_d - ct), np.int64)
        for dc in range(0, in_d, TILE):       # depth chunks
            acc += run_tile(t[ct:ct + TILE, dc:dc + TILE], a[dc:dc + TILE])
            tiles += 1
        result[ct:ct + TILE] = acc
    expect = t.astype(np.int32) @ a.astype(np.int32)
    ok = np.array_equal(result, expect.astype(np.int64))
    print(f"TILED {name} [{out_d}x{in_d}] {tiles} tiles: "
          f"{'EXACT-MATCH' if ok else 'FAIL'} ({time.time()-t0:.0f}s)", flush=True)
    if not ok:
        sys.exit(1)
print(f"TILED BLOCK {b} COMPLETE: all 7 projections exact via host tiling "
      f"({(time.time()-t0)/60:.1f} min)", flush=True)
""""""
