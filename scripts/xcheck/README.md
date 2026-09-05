# OOC area cross-check: ternary_dot vs INT8

`ternary_dot_nodebug.v` is a debug-free derivative of `rtl/ternary_dot.v`:
the five exported debug ports and all `(* mark_debug / keep / dont_touch *)`
attributes have been removed, so no synthesis-preservation artifacts inflate
the area. Functionally identical streaming ternary dot product.

Purpose: reproducible, tool-neutral area comparison against an INT8 dot
product of the same shape. Run the identical source through Vivado (script
below) and Yosys (`-nodsp`) and compare.

## Vivado 2025.2, xc7a100tcsg324-1, OOC, -max_dsp 0

| top | LUT | FF | CARRY4 | DSP |
|---|---|---|---|---|
| ternary_dot (this file, debug-free) | 38 | 17 | 4 | 0 |
| rtl/ternary_mac.v (single MAC cell)  | 38 | 33 | 8 | 0 |
| int8_dot (same shape)                | 223 | 114 | 24 | 0 |

Note: raw synthesis of the instrumented `rtl/ternary_dot.v` (debug ports +
attributes) is dominated by preserved debug logic and is NOT an area figure --
in Vivado the preservation is attribute-driven, in Yosys it is port-driven.
Strip both, as here, before comparing.

## Run
```
vivado -mode batch -source synth_ooc.tcl
```

