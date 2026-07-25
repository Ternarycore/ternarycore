# The Simulator Is Polite. The Silicon Is Not.

**TernaryCore's first real benchmark: a BitNet-shaped ternary GEMM, run with
and without the accelerator on the same chip — and the three bugs that stood
in the way.**

*July 25, 2026 — Arty A7-100T (Artix-7 xc7a100t), Vivado 2025.2*

---

In [the last write-up](article-02.md) we proved a single ternary MAC on real
silicon: one button press, one `(-5) × (-1) + 10 = 15`, one green LED. Nice.
But a single MAC is a party trick. The claim TernaryCore actually makes is
bigger: put a CPU and a ternary accelerator on the *same* fabric, run the
*same* BitNet-shaped workload through both, and let the silicon say which
arithmetic wins.

Today the silicon answered:

```
TernaryCore Tier 1 Benchmark (bare-metal)
Initializing weights (256 KB BRAM)...
Verifying accel vs software (1 pass each)...
Verification PASS
Output checksum: 0xfffff600  out[0..3]=5,0,-5,5

RESULT accel: 5,319,845 cycles/pass   (53.2 ms)
RESULT sw:   19,519,460 cycles/pass  (195.2 ms)
RESULT speedup: 3.67x
```

A 768→768 ternary projection — the shape of a BitNet b1.58 weight layer —
executed 200 times through the accelerator and 10 times in pure C on the
same MicroBlaze, on the same 100 MHz clock, against the same weights, with
element-by-element equivalence checked before a single cycle was counted.

**3.67× is not the headline.** The headline is what the number is made of.
But first, the story of how we got a number at all — because the first run
printed 512 mismatches, every accelerator output read zero, and every one of
our 86 simulation tests was green while it happened.

---

## The system

The Tier 1 design (branch `feat/bitnet-accelerator`) is the full Track A
stack from [ROADMAP.md](ROADMAP.md):

- **MicroBlaze** soft CPU (no caches, no FPU) with 64 KB local BRAM
- **AXI4-Lite interconnect** to UART16550, GPIO, and two custom IPs:
- **`axi_gemm_wrapper`** — the ternary GEMM array (4 columns × depth 768)
  behind memory-mapped registers: stream a weight byte + an activation per
  element, poll `DONE`, read four accumulators
- **`weight_bram`** — 256 KB of packed ternary weights, 4 per byte

Timing closed at 100 MHz with **0 DSP slices**. The multiplication in this
machine is a 2-bit mux deciding add, subtract, or skip.

## Run 1: all zeros

First flash, first run:

```
MISMATCH col 0: accel=0 sw=5
MISMATCH col 2: accel=0 sw=-5
...
FAIL: 512 output mismatch(es)
```

Every column where the software reference expected ±5, the accelerator said
0. The 256 columns that "passed" were the ones where the answer happened to
be zero. The accelerator was contributing nothing — while 86/86 simulation
tests passed on the same RTL.

What followed was a debugging session conducted entirely over JTAG and UART,
and it peeled back **three separate bugs**, each one a member of a class the
simulator is structurally incapable of catching.

### Bug 1 — the firmware pointed at unmapped memory

`tier1_bench.c` defined the weight BRAM at `0x44010000`. The block design
maps it at `0x44100000`. The firmware address is exactly one byte past the
end of the GEMM wrapper's 64 KB window — unmapped space. Simulation never
noticed because the testbenches drive the RTL directly and never exercise
the block design's address map. *The address map is part of the design. Test
it as one.*

### Bug 2 — valid_out was a level pretending to be a pulse

`ternary_dot` sets `vector_done` on the last element and holds it until the
next vector begins. When a testbench streams elements back-to-back, the next
vector begins one cycle later, and `vector_done` looks exactly like the
one-cycle pulse the documentation promises. When a *CPU* feeds elements over
AXI — tens of idle cycles between writes — `valid_out` stays high across the
whole gap. The wrapper latched results on `valid_out`'s *level*, so it
re-latched every idle cycle; and because the done-flag set had priority over
the CTRL-write clear, `DONE` could never be cleared again. The fix latches
on the rising *edge* (one cycle after it, when the result has settled). The
new regression, `tb_axi_gemm_gaps.v`, drives the wrapper with
MicroBlaze-like 20-cycle gaps — it fails on the old RTL and passes on the
fix. *Your testbench's timing habits are assumptions. Someone else's master
will break them.*

### Bug 3 — multi-driven registers, or: how acc_out became a constant

The deepest one. `ternary_dot.v` reset `acc_out` in its main always block
*and* drove it from a second always block — a leftover from ILA debug
instrumentation. Two drivers for one register. Icarus Verilog shrugs and
simulates something reasonable. Vivado synthesis (`Synth 8-6858`: *"connected
to at least one constant driver which has been preserved, other driver is
ignored"*) resolved the conflict by **tying `acc_out` to zero in silicon**.
Every ACC read, in every bitstream ever built from this RTL, was reading a
constant. The same collision killed `vector_done_delayed`, which quietly
locked the accelerator's accept-condition after its first vector — the
benchmark hang that followed the first two fixes.

Our own [SIMULATION_GUIDE.md](../SIMULATION_GUIDE.md) has a section called
"Simulation ≠ synthesis: the gap that bites everyone." It was written before
this happened. The gap read it and bit anyway. *Treat every CRITICAL WARNING
in a synthesis log as an error until proven cosmetic.*

## Methodology worth stealing

Two constraints shaped the bring-up, and both turned into features:

**No BSP.** Vitis platform generation is a swamp when you're iterating fast,
and the block design had no hardware timer for `XTime` anyway. So the
benchmark firmware (`tier1_bare.c`) is fully bare-metal: its own UART16550
driver, direct register I/O, 23 KB, compiles with one `mb-gcc` line.

**No timer — no problem.** The firmware prints `MARK` lines; a host-side
script timestamps them as they arrive over UART. The fabric clock is exactly
100 MHz, so wall-clock seconds convert to cycles losslessly. Phases run for
seconds; serial latency jitter is microseconds. Free, honest timing.

Isolation between "firmware bug" and "hardware bug" came from `xsdb` pokes:
halt the core, drive a full 768-element vector into the GEMM registers by
hand over JTAG, read back. When a hand-driven vector also returns zeros, you
stop re-reading your C code and start reading synthesis warnings.

## What 3.67× is made of

Per pass, the accelerator path costs 5.32 M cycles. The ternary array's
actual compute — 768 elements × 192 column groups, one element per cycle —
needs only ~147 K of them. **97% of the accelerator's time is the soft CPU
hand-feeding it**: every element takes one AXI read (weight byte) plus two
AXI writes (weight code, activation), ≈12 cycles of bus overhead each, ~442 K
AXI transactions per pass. The array sits at ~3% utilization and *still*
beats the same CPU doing the math itself by 3.67×.

That makes this measurement two proofs in one:

1. **The arithmetic works.** Multiplier-free ternary MACs, verified
   element-by-element against software on real silicon, at scale (589,824
   MACs per pass), with 0 DSPs.
2. **The bottleneck is exactly where the roadmap said it was.** The path to
   the [40 GOPS target](ROADMAP.md) is not more math — it's feeding: DMA
   from BRAM/DDR instead of CPU-paced register writes, and widening past 4
   exposed columns. The CPU should orchestrate, not chaperone every byte.

## Next

- **Real weights** ([HOST_STREAMING.md](HOST_STREAMING.md), Stage 1): a
  UART `LOADW/LOADA/RUN` protocol so the same benchmark runs an actual
  `bitnet_b1_58` checkpoint layer instead of a synthetic pattern. Days, not
  weeks.
- **Tier 2**: DMA weight feed + wider result interface — turn 3% array
  utilization into a headline number.
- **Model-level tokens/sec** belongs on a board whose memory can feed it
  (Zynq / Kria / Alveo U50 — the bandwidth math is in HOST_STREAMING.md).
  The Arty stays what it proved itself to be today: the cleanest possible
  A/B between binary and ternary compute on identical silicon.

The repository is open. The simulator is validated. And now the silicon
agrees with it — for reasons we can defend line by line.

---

*RTL, firmware, testbenches, and the debug trail are on the
[`feat/bitnet-accelerator`](https://github.com/Ternarycore/ternarycore/tree/feat/bitnet-accelerator)
branch. Fixes landed in `82e4948` (edge-detect latch) and `8336bc7`
(multi-driven registers); the gap-injection regression is
`tb/tb_axi_gemm_gaps.v`.*
