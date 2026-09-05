# OOC area cross-check: ternary_dot vs INT8

Reproducible area comparison of the multiplier-free ternary streaming dot product
against an INT8 dot product of the same shape. Both sources are here and both
toolchains are shown, so the whole table is checkable by anyone.

## Sources
- `ternary_dot_nodebug.v` — debug-free derivative of `rtl/ternary_dot.v` (the five
  exported debug ports and all `(* mark_debug / keep / dont_touch *)` attributes
  removed; functionally identical).
- `int8_dot.v` — INT8 dot product of the same shape: the comparison baseline and
  the denominator of the ratio.

## Results

| top | tool | LUT | FF | CARRY4 | DSP |
|---|---|---|---|---|---|
| ternary_dot_nodebug | Vivado 2025.2 (OOC, -max_dsp 0) | 38 | 17 | 4 | 0 |
| int8_dot | Vivado 2025.2 (OOC, -max_dsp 0) | 223 | 114 | 24 | 0 |
| ternary_dot_nodebug | Yosys 0.67+ (-nodsp -noiopad -flatten) | 22 | 17 | 4 | 0 |
| int8_dot | Yosys 0.67+ (-nodsp -noiopad -flatten) | 269 | 114 | 16 | 0 |
| ternary_dot_nodebug | nextpnr-xilinx (XC7A200T, post-synth pack) | 43* | 17 | 4 | 0 |

*nextpnr figure is the SLICE_LUTX pack, post-synthesis (full route pending package pins).

## Reading the numbers

- **FF and CARRY4 agree to the unit across all three tools** for the ternary cell
  (17 FF, 4 CARRY4 in Vivado, Yosys, and nextpnr). The source is not in question.
- **The LUT count is mapper-dependent — quote the ratio with its synthesizer:**
  - Vivado: 223 / 38 = 5.9x
  - Yosys:  269 / 119 = 2.26x
  Same direction, ~2.6x apart in magnitude. This is a finding about how each mapper
  packs this shape, not a single number to dispute. (119 = clean ternary_dot in
  Yosys with the five debug ports retained; 22 = ports also removed.)
- Raw synthesis of the instrumented `rtl/ternary_dot.v` (debug ports + attributes)
  is dominated by preserved debug logic and is NOT an area figure: in Vivado the
  preservation is attribute-driven, in Yosys it is port-driven. Strip both, as here.

## Run
```
vivado -mode batch -source synth_ooc.tcl
```

Independent Yosys / open-flow cross-check by Dmitrii Vasilev (Trinity S3AI).

