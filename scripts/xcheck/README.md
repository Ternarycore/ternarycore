# OOC area cross-check: ternary_dot vs INT8

Reproducible area comparison of the multiplier-free ternary streaming dot product
against an INT8 dot product of the same shape. Both sources are here and both
toolchains are shown, so the whole table is checkable by anyone.

## Sources
- `ternary_dot_nodebug.v` — debug-free derivative of `rtl/ternary_dot.v` (the five
  exported debug ports and all `(* mark_debug / keep / dont_touch *)` attributes
  removed; functionally identical, verified against the same testbenches).
- `int8_dot.v` — INT8 dot product of the same shape: the baseline and the denominator.

## Single-driver fix (important)

`rtl/ternary_dot.v` previously drove `acc_out` and `vector_done_delayed` from **two**
clocked always blocks each (a redundant reset in the main block, plus the output/delay
blocks that fully own them). Multiple drivers on one register: the synthesiser arbitrates
the conflict however it likes, which is why stripping the `keep`/`dont_touch` attributes
made the LUT count collapse instead of settle. The redundant resets have been removed —
one driver per register, zero multiple-driver warnings — with no behavioural change
(dot and GEMM testbenches still pass, bit-for-bit). Found by Dmitrii Vasilev (Trinity S3AI).

## Results (single-driver source)

| top | tool | LUT | FF | CARRY4 | DSP |
|---|---|---|---|---|---|
| ternary_dot_nodebug | Vivado 2025.2 (OOC, -max_dsp 0) | 141 | 114 | 12 | 0 |
| int8_dot | Vivado 2025.2 (OOC, -max_dsp 0) | 223 | 114 | 24 | 0 |
| ternary_dot_nodebug | Yosys 0.67+ (-nodsp -noiopad -flatten) | 120 | 114 | 14 | 0 |
| int8_dot | Yosys 0.67+ (-nodsp -noiopad -flatten) | 269 | 114 | 16 | 0 |

## Reading the numbers

- **FF agrees to the unit across designs and tools: 114** (acc, result_latch, acc_out at
  32 bits + count at 16 + two flags). CARRY4 is 12–24 depending on tool/design.
- **The LUT count is mapper-dependent — quote the ratio with its synthesizer:**
  - Vivado: 223 / 141 = **1.58x**
  - Yosys:  269 / 120 = **2.24x**
  Same direction; the magnitude is how each mapper packs this shape.
- Do **not** use the earlier 22 / 38 LUT figures: those were the two tools arbitrating the
  multiple-driver defect differently, not an area result. The fixed source above supersedes them.

## Run
```
vivado -mode batch -source synth_ooc.tcl
```

Independent Yosys / open-flow cross-check and the multiple-driver finding: Dmitrii Vasilev (Trinity S3AI).

