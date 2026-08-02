#!/usr/bin/env python3
import subprocess
import sys
import os

VLEN = 8

class LCG:
    def __init__(self, seed):
        self.state = seed & 0xFFFFFFFF

    def next(self):
        self.state = (self.state * 1103515245 + 12345) & 0xFFFFFFFF
        return self.state

    def rand_act(self):
        return (self.next() % 256) - 128

    def rand_wenc(self):
        return self.next() % 3

def decode_weight(enc):
    if enc == 0b01: return 1
    if enc == 0b10: return -1
    return 0

def plain_dot(acts, wenc):
    return sum(a * decode_weight(w) for a, w in zip(acts, wenc))

def activation_quant(x):
    inv = 41615
    q = (x * inv + (1 << 14)) >> 15
    return max(-127, min(127, q))

def quant_dot(acts, wenc):
    return sum(activation_quant(a) * decode_weight(w) for a, w in zip(acts, wenc))

def scale_q15(acc, alpha=32768):
    prod = acc * alpha
    trunc = prod & 0x7FFF
    return (prod >> 15) + (1 if trunc else 0)

def run_binary(path, seed):
    r = subprocess.run([path, str(seed)], capture_output=True, text=True, timeout=10)
    for line in r.stdout.strip().split("\n"):
        if line.startswith("RESULT:"):
            return [int(x) for x in line.split()[1:]]
    raise RuntimeError(f"No RESULT line: {r.stdout}")

def main():
    script_dir = os.path.dirname(__file__) or "."
    verilator_bin = os.path.join(script_dir, "..", "obj_dir_dot_diff", "sim_dot_diff_verilator")
    device_bin = os.path.join(script_dir, "..", "build", "device_diff")

    for p, n in [(verilator_bin, "Verilator"), (device_bin, "Device")]:
        if not os.path.exists(p):
            print(f"ERROR: {n} binary not found at {p}")
            sys.exit(1)

    n_trials = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
    errors = 0
    mismatches = 0

    seed = 42

    for trial in range(n_trials):
        lcg = LCG(seed)

        acts = []
        wenc = []
        for i in range(2 * VLEN):
            acts.append(lcg.rand_act())
            wenc.append(lcg.rand_wenc())

        # NOTE: act/wenc must be generated ALTERNATING per-element to match
        # the C++ pattern (each act consumes one lcg call, each wenc one call).
        # The loop above does exactly that -- one act then one wenc per iteration.
        # This matches verilator_dot_diff.c and device_diff.c.

        py_plain = [plain_dot(acts[:VLEN], wenc[:VLEN]),
                    plain_dot(acts[VLEN:], wenc[VLEN:])]

        py_quant = [quant_dot(acts[:VLEN], wenc[:VLEN]),
                    quant_dot(acts[VLEN:], wenc[VLEN:])]

        py_scaled = [scale_q15(py_quant[0]), scale_q15(py_quant[1])]

        try:
            v = run_binary(verilator_bin, seed)
            d = run_binary(device_bin, seed)
        except Exception as e:
            print(f"Trial {trial} (seed={seed}): {e}")
            errors += 1
            seed = lcg.next()
            continue

        if len(v) != 2 or len(d) != 4:
            print(f"Trial {trial} (seed={seed}): unexpected output v={v} d={d}")
            errors += 1
            seed = lcg.next()
            continue

        v0, v1 = v
        d_rd0, d_s0, d_rd1, d_s1 = d

        ok = True

        if v0 != py_plain[0]:
            mismatches += 1; ok = False
            print(f"MISMATCH trial {trial} (seed={seed}): vec0 RTL plain dot")
            print(f"  RTL={v0} Python(plain)={py_plain[0]}")

        if v1 != py_plain[1]:
            mismatches += 1; ok = False
            print(f"MISMATCH trial {trial} (seed={seed}): vec1 RTL plain dot")
            print(f"  RTL={v1} Python(plain)={py_plain[1]}")

        if d_rd0 != py_quant[0]:
            mismatches += 1; ok = False
            print(f"MISMATCH trial {trial} (seed={seed}): vec0 device quant dot")
            print(f"  Device(rd0)={d_rd0} Python(quant)={py_quant[0]}")

        if d_rd1 != py_quant[1]:
            mismatches += 1; ok = False
            print(f"MISMATCH trial {trial} (seed={seed}): vec1 device quant dot")
            print(f"  Device(rd1)={d_rd1} Python(quant)={py_quant[1]}")

        if d_s0 != py_scaled[0]:
            mismatches += 1; ok = False
            print(f"MISMATCH trial {trial} (seed={seed}): vec0 scaled")
            print(f"  Device(scaled0)={d_s0} Python(scaled)={py_scaled[0]}")

        if d_s1 != py_scaled[1]:
            mismatches += 1; ok = False
            print(f"MISMATCH trial {trial} (seed={seed}): vec1 scaled")
            print(f"  Device(scaled1)={d_s1} Python(scaled)={py_scaled[1]}")

        seed = lcg.next()

    print(f"\n--- N={n_trials} errors={errors} mismatches={mismatches} ---")
    return 1 if (errors or mismatches) else 0

if __name__ == "__main__":
    sys.exit(main())
