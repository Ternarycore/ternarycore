# Simulation Guide — Mac Mini

Everything you need to run TernaryCore simulations on your Mac. No FPGA hardware required.

---

## A Note on Verilog vs VHDL

This project uses **Verilog** (specifically SystemVerilog-compatible Verilog). VHDL and Verilog are both hardware description languages — same job, completely different syntax. Verilog is C-like and is the dominant language in the FPGA/ASIC industry. VHDL is Ada-like and is common in European aerospace. The tools and commands in this guide are all Verilog-specific.

If you learned VHDL first — from a book whose accompanying CD-ROM has been lost to entropy, say — the mental model transfers directly even though the syntax looks unrecognisable. Both languages describe concurrent hardware behaviour, both have a simulation/synthesis split, and both will let you write things that simulate perfectly and then behave unexpectedly on a real device.

### Simulation ≠ synthesis: the gap that bites everyone

This is worth stating plainly before you run a single test:

**A design that passes every simulation does not necessarily work on hardware.** The simulator is a software model of what your HDL *means*. The synthesiser is a compiler that maps that HDL onto physical LUTs, flip-flops, carry chains, and block RAM. These are different jobs, and the gap between them has specific failure modes:

| Issue | In simulation | On FPGA |
|---|---|---|
| Unintended latch | Often masked — simulator just holds the value | Synthesises a real latch; prone to timing violations |
| X/Z propagation | Simulator faithfully propagates unknowns | No such thing — hardware is always 0 or 1 |
| Non-blocking assignment races | May be hidden by simulator delta-cycle ordering | Can cause hold-time violations or metastability |
| Timing (setup/hold) | Simulator ignores propagation delay by default | Violating setup/hold corrupts flip-flop state |
| Initialisation | `initial` blocks run in simulation | `initial` blocks are ignored by most synthesisers |

The Arty A7 is the next step precisely to expose this gap. Passing `make all` cleanly is the simulation gate. Timing closure in Vivado — and a working UART readback — is the hardware gate. Both matter.

---

## 1. Install the Tools (one-time)

Open Terminal on your Mac Mini and run:

```bash
brew install icarus-verilog gtkwave
```

That installs two tools:

| Tool | Command | What it does |
|------|---------|-------------|
| Icarus Verilog | `iverilog` | Compiles your Verilog into a simulation executable |
| GTKWave | `gtkwave` | Opens waveform files so you can see signals over time |

Verify both installed correctly:

```bash
iverilog -V   # should print: Icarus Verilog version 12.x
gtkwave --version
```

---

## 2. Clone the Repo

```bash
git clone https://github.com/shepherdscientific/ternarycore.git
cd ternarycore
```

---

## 3. Run Your First Simulation: `ternary_mac`

The `ternary_mac` module is the atomic building block — one ternary multiply-accumulate cell. Its testbench is already written and ready to run.

```bash
cd sim
make tb_ternary_mac
```

You should see output like this in your terminal:

```
--- TernaryCore MAC Testbench ---
PASS: act=10  w=01  acc_in=0   => acc_out=10
PASS: act=25  w=01  acc_in=10  => acc_out=35
PASS: act=10  w=10  acc_in=35  => acc_out=25
PASS: act=25  w=10  acc_in=25  => acc_out=0
PASS: act=99  w=00  acc_in=42  => acc_out=42
PASS: act=127 w=00  acc_in=0   => acc_out=0
PASS: act=-5  w=01  acc_in=0   => acc_out=-5
PASS: act=-5  w=10  acc_in=0   => acc_out=5
--- 0 error(s) ---
ALL TESTS PASSED
```

### ✅ Success Criteria: ternary_mac

| Test | Weight | What it proves |
|------|--------|---------------|
| `act=10, w=+1` → `acc=10` | +1 | Activation passes through unchanged |
| `act=10, w=-1` → `acc=-10` | -1 | Activation is negated correctly |
| `act=99, w=0`  → `acc=42` (unchanged) | 0 | Zero weight produces no contribution |
| `act=-5, w=+1` → `acc=-5` | +1 | Signed (negative) activations work |
| `act=-5, w=-1` → `acc=+5` | -1 | Negating a negative gives positive |
| Accumulation chain | all | Running accumulator adds correctly |

**All 8 tests must pass before proceeding. Zero errors = success.**

---

## 4. View the Waveform in GTKWave

The simulation writes a `.vcd` waveform file. To open it:

```bash
make waves_mac
```

GTKWave opens. To view signals:

1. In the left panel ("SST"), expand `tb_ternary_mac`
2. Double-click signals to add them to the wave view: `clk`, `valid_in`, `activation`, `weight_enc`, `acc_in`, `acc_out`
3. Press **Ctrl+Shift+F** (or zoom buttons) to fit all signals in view

What you should see:
- `clk` — regular square wave (clock, 10ns period)
- `valid_in` — pulses high once per test case
- `acc_out` — steps up/down one clock after each valid pulse
- `valid_out` — follows `valid_in` by one clock cycle (pipeline register delay)

If `acc_out` ever stays flat when you expect it to change, or jumps to an unexpected value, that points to the line in the RTL to investigate.

---

## 5. Cross-Verify with Python

The simulation output is the ground truth, but it's worth confirming with a Python reference — especially before claiming results publicly.

Create `sim/verify/verify_mac.py`:

```python
# verify_mac.py
# Computes expected ternary MAC outputs for the same test vectors
# as tb_ternary_mac.v. Output should match simulation exactly.

def ternary_mac(activation: int, weight_enc: int, acc_in: int,
                data_width: int = 8) -> int:
    """Python reference implementation of ternary_mac.
    weight_enc: 0b00=zero, 0b01=+1, 0b10=-1
    activation: signed int, data_width bits
    """
    # Clip to signed data_width range
    act = activation
    if weight_enc == 0b00:
        weighted = 0
    elif weight_enc == 0b01:
        weighted = act
    else:  # 0b10
        weighted = -act
    return acc_in + weighted


test_vectors = [
    # (activation, weight_enc, acc_in, expected_acc_out)
    (10,    0b01, 0,   10),
    (25,    0b01, 10,  35),
    (10,    0b10, 35,  25),
    (25,    0b10, 25,  0),
    (99,    0b00, 42,  42),
    (127,   0b00, 0,   0),
    (-5,    0b01, 0,   -5),
    (-5,    0b10, 0,   5),
]

errors = 0
for act, wenc, acc_in, expected in test_vectors:
    result = ternary_mac(act, wenc, acc_in)
    status = "PASS" if result == expected else "FAIL"
    if result != expected:
        errors += 1
    print(f"{status}: act={act:4d} w={wenc:02b} acc_in={acc_in:4d} "
          f"=> {result} (expected {expected})")

print(f"\n--- {errors} error(s) ---")
if errors == 0:
    print("ALL TESTS PASSED")
```

Run it:

```bash
python3 sim/verify/verify_mac.py
```

The output should match the Verilog simulation line-for-line. If it doesn't, the Python reference is wrong — not necessarily the hardware.

---

## 6. What's Next: `ternary_dot`

Once `ternary_mac` passes, the next module to implement is `ternary_dot` — a 64-element vector dot product built from 64 `ternary_mac` cells in series.

### ✅ Success Criteria: ternary_dot

- Run `make tb_ternary_dot`
- Zero errors in the terminal output
- Python reference (`verify_dot.py`) computes the same dot product as the simulation for 10 random test vectors
- GTKWave waveform shows `acc_out` reaching the correct final value after exactly 64 clock cycles (one per element)

### Template for `verify_dot.py`

```python
import random

def ternary_dot(activations: list, weights_enc: list) -> int:
    """Reference dot product of two vectors.
    activations: list of signed ints
    weights_enc: list of 2-bit ternary codes
    """
    acc = 0
    for act, wenc in zip(activations, weights_enc):
        if wenc == 0b00:
            pass          # zero
        elif wenc == 0b01:
            acc += act    # +1
        else:
            acc -= act    # -1
    return acc

random.seed(42)
for trial in range(10):
    acts  = [random.randint(-128, 127) for _ in range(64)]
    wencs = [random.choice([0b00, 0b01, 0b10]) for _ in range(64)]
    result = ternary_dot(acts, wencs)
    print(f"Trial {trial:2d}: dot product = {result}")
    # Compare against your Verilog simulation output
```

---

## 7. Troubleshooting

### `iverilog: command not found`
```bash
brew install icarus-verilog
# If brew itself is missing:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### `gtkwave: command not found` or GTKWave won't launch
```bash
brew install --cask gtkwave
# Note: --cask for the GUI app version on newer macOS
```

### `make tb_ternary_mac` says "No rule to make target"
Make sure you're in the `sim/` directory, not the repo root:
```bash
cd sim && make tb_ternary_mac
```

### Simulation compiles but prints wrong values
1. Check the waveform in GTKWave — is `valid_in` pulsing at the right time?
2. Check `rst_n` — it must go high before any `valid_in` pulse
3. Look at `acc_in` — are you passing the previous `acc_out` correctly?

### `FAIL` on a signed activation test
Signed values in Verilog need careful handling. In the testbench, `8'hFB` is the 2's-complement encoding of `-5`. If you're writing new test vectors, use `$signed()` when printing or comparing.

### `.vcd` file is empty or GTKWave shows nothing
The `$dumpfile` and `$dumpvars` lines in the testbench must run before any simulation activity. Check that they appear inside an `initial begin` block that fires at time 0.

---

## 8. Quick Reference Card

```bash
# Install tools (one-time)
brew install icarus-verilog gtkwave

# Clone
git clone https://github.com/shepherdscientific/ternarycore && cd ternarycore

# Run MAC simulation
cd sim && make tb_ternary_mac

# Open waveform
make waves_mac

# Cross-verify with Python
python3 verify/verify_mac.py

# Run all simulations (once more modules exist)
make all
```

---

## Phase 1 Completion Checklist

Before moving to real hardware (Arty A7-100T), all of the following must be true:

- [ ] `tb_ternary_mac` — **8/8 tests pass**, 0 errors
- [ ] `verify_mac.py` — Python output matches simulation exactly
- [ ] `tb_ternary_dot` — dot product correct for 10 random vectors
- [ ] `verify_dot.py` — Python reference matches simulation
- [ ] `tb_ternary_gemm` — 4×4 matrix multiply matches NumPy output
- [ ] GTKWave waveforms reviewed — no unexpected glitches or X states
- [ ] Screenshot of passing terminal output saved to `results/`

When this checklist is complete: **you have your Crowd Supply prototype.**
