# TRETS paper — raw synthesis and implementation evidence

Every number in Table 2 of the paper, with the report that produced it.
All runs: **Vivado 2025.2** (SW Build 6299465, 2025-11-14), part **xc7a100tcsg324-1**,
speed grade -1, 100 MHz (`create_clock -period 10.000`), host `fort-silicon`,
Ubuntu 24.04.4 LTS.

## `ooc/` — out-of-context synthesis (array rows)

| Paper row | LUT | FF | DSP48 | Latches | WNS | Report |
|---|---|---|---|---|---|---|
| Ternary MAC cell | 38 | 33 | 0 | 0 | --- | `ternary_mac_util.rpt`, `ternary_mac_timing.rpt` |
| `ternary_gemm` (64x768) | 8,775 | 7,296 | 0 | 0 | 6.04 ns | `ternary_gemm64_util.rpt`, `..._timing.rpt` |
| `int8_gemm` (64), Vivado default | 14,209 | 7,296 | 0 | 0 | 6.11 ns | `int8_gemm64_util.rpt`, `..._timing.rpt` |
| `int8_gemm` (64), `use_dsp` forced | 5,633 | 7,296 | 192 | 0 | 5.73 ns | `int8_gemm64_dsp_util.rpt`, `..._timing.rpt` |
| `ternary_gemm_stream` (feeder+array) | 8,816 | 9,374 | 0 | 0 | --- | `tier2_stream64_util.rpt` |

Also here, supporting contribution C1 (base-243 decoder):

| Unit | LUT | FF | DSP48 | Report |
|---|---|---|---|---|
| `trit_decode243` (one byte -> five trits) | 36 | 0 | 0 | `trit_decode243_util.rpt` |
| `weight_decode243_row` (COLS=64, combinational) | 462 | 0 | 0 | `decode243_row_util.rpt` |

### Note on the two LUT conventions

The `Slice LUTs*` line in `report_utilization` is a **slice-packed** count (a LUT6_2
occupies one site and is counted once). The paper quotes **LUT primitive instances**,
which is what `synth/tier2_baseline_synth.tcl` prints via
`llength [get_cells -hier -filter {PRIMITIVE_GROUP == LUT}]`. Both come from the same
`synth_design` invocation; FF, DSP48, latch and WNS are unaffected by packing and agree
exactly between the two. See `transcripts/` for the primitive counts.

## `soc/` — full implementations

| Paper row | LUT | FF | DSP48 | Latches | WNS | Report |
|---|---|---|---|---|---|---|
| Tier-1 SoC (CPU-fed) | 2,642 | 2,626 | 3 | 0 | +0.18 ns | `tier1_utilization_rebuilt.rpt` |
| Tier-2 SoC (streaming) | 9,739 | 10,121 | 3 | 0 | +0.14 ns | `tier2_utilization_rebuilt.rpt`, `tier2_timing_rebuilt.rpt` |

Both rebuilt 2026-09-30 from this tag. Tier-1 via `Arty7/build_all.sh`; Tier-2 via
`Arty7/build_tier2.sh`. Tier-2 closes timing with implementation strategy
`Performance_ExplorePostRoutePhysOpt`; the default `Performance_Explore` leaves it at
WNS -0.101 ns. `tier2_timing_summary_routed.rpt` is the pre-physopt report, kept so the
critical path is inspectable: `act_ram` (RAMB18E1) -> ternary select -> `acc_reg[31]`
in dot 62, 10 logic levels, 6 CARRY4 deep, 9.951 ns (logic 5.053, route 4.898).

## `transcripts/` — the Vivado batch logs behind the array rows

- `tc-p1-synth.log` — 2026-08-17 13:41. Rows 2, 3 and 5 of Table 2.
- `tc-p1-synth-dsp.log` — 2026-08-17 13:46. Row 4 (`use_dsp` forced).

## Reproducing

```bash
vivado -mode batch -source synth/tier2_baseline_synth.tcl   # rows 2, 3, 5
vivado -mode batch -source synth/int8_dsp_synth.tcl         # row 4
bash Arty7/build_all.sh                                     # Tier-1 SoC
bash Arty7/build_tier2.sh                                   # Tier-2 SoC
```

These reports are committed with `git add -f`: the repository `.gitignore` excludes
`*.rpt`, which is why the evidence behind the published table was previously absent from
the artifact.
