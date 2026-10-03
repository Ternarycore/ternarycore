# ternary_dot vs int8_dot — 20-seed open-flow sweep (2026-10-01)

## Inputs
- Sources: `Ternarycore/ternarycore` branch `debug/arty7`, commit
  `25358a240381378d86d0f157e67aa1319040d784`, `scripts/xcheck/`.
  - `src/ternary_dot_nodebug.v` sha256 `2cf468b8157b38b54f55094d5246828224ab466bde99874e89d645a5ec6b6f3e`
  - `src/int8_dot.v`            sha256 `8896463390d724ece22c59edf3ae5f7dc941f73eb87c92ffd5c9499937018c0c`
- Synthesis: Yosys 0.67+post (git sha1 b8e7da6f40ae8f552c116bf6c359b07c6533e159),
  `synth_xilinx -family xc7 -nodsp -noiopad -flatten`.
- Place and route: nextpnr-xilinx 0.9.2-107-g7037c948, `--freq 100 --placer heap
  --router router2 --timing-allow-fail --seed 1..20`.
- Constraints: `ternary.xdc` is the 2026-09-06 `route.xdc` unchanged (46 synthetic
  LVCMOS33 pins, 10 ns `create_clock`). `int8.xdc` is reconstructed: the same pins
  for the shared ports, `weight[1:0]` on the `weight_enc[1:0]` pins, `weight[7:2]`
  on G13 G15 G16 G17 G18 G20. The original int8 XDC is only in the 2026-09-06
  e-mail attachment.
- Parts: `xc7a200tfbg484-2` and `xc7a100tfgg484-3` chipdbs.

## Results
Yosys synthesis: ternary 120 LUT2–6 + 137 INV; int8 269 LUT2–6 + 129 INV.
These match the `scripts/xcheck/README.md` rows.

| part | design | SLICE_LUTX | FF | CARRY4 | Fmax min / median / max (MHz) | ≥100 MHz |
|---|---|---|---|---|---|---|
| xc7a200tfbg484-2 | ternary | 321 (all 20 seeds) | 114 | 14 | 164.15 / 187.16 / 200.40 | 20/20 |
| xc7a200tfbg484-2 | int8    | 471 (all 20 seeds) | 114 | 16 | 192.75 / 212.53 / 224.16 | 20/20 |
| xc7a100tfgg484-3 | ternary | 321 (all 20 seeds) | 114 | 14 | 162.10 / 173.12 / 199.32 | 20/20 |
| xc7a100tfgg484-3 | int8    | 471 (all 20 seeds) | 114 | 16 | 198.49 / 211.35 / 231.16 | 20/20 |

Per-seed values are in `sweep_a200t.csv` and `sweep_a100t_fgg484-3.csv`. Logs are in `runs/`.

## The 71.28 MHz figure: reproduced, and caused by the pinout
The 2026-09-06 letter reported ternary 71.28 MHz (0.4 ns logic + 13.6 ns route) at seed 1.
That run used a different XDC from `ternary.xdc` above. Its zip (`../sent-2026-09-06/`) holds
`ternary_dot_full_valid_pins.xdc`: clk on R4 (LVCMOS15), inputs along column A, and the 33
outputs along rows AA/AB. With that XDC and today's netlist, seed 1 reproduces exactly: 71.28 MHz,
0.4 + 13.6 ns. The path crosses the die three times (tile x 14 -> 247 -> 13 -> 197).

`pinout-0906/` holds the sweep with that XDC on xc7a200tfbg484-2:
- 10 seeds completed (1-3 and 5-11; seed 4 did not finish under machine load).
- Ternary Fmax min / median / max: 62.68 / 71.42 / 76.75 MHz. 0/10 meet 100 MHz.
- Every seed has 0.4 ns of logic, with 12.6-15.5 ns of routing.
- Area is 321 / 114 / 14 on every seed, the same as with the compact pinout.

So I/O placement, not seed and not datapath depth, sets the period of the stand-alone unit.
An earlier draft of this README said the figure "does not reproduce". That was wrong: the
compact-pinout runs had been compared against a spread-pinout result.

## The xcheck unit is not the tag unit
`src/ternary_dot_nodebug.v` (debug/arty7 @ 25358a24) negates in 8 bits. As a result,
-1 x (-128) = -128 (should be +128). `conformance/tb_edge.v` fails exactly those two vectors on it
(`tb_edge.out`). The tag v1.0.1-trets `rtl/ternary_weight.v` negates in DATA_WIDTH+1 bits and
passes (`tb_edge_tag.out`). `weight_enc = 2'b11` decodes as -1 in both and is undocumented. The
"FAIL" for it in the bench is against an arbitrary 0 reference.

`tag-rtl/` is the tag `ternary_dot.v` + `ternary_weight.v`, unmodified, under `xcheck_top.v`.
That wrapper only leaves the debug outputs unconnected. Tag sources are in
`../tag-v1.0.1-trets/rtl/`; ternary_dot.v sha256 is `322b4433ccb355c3487b47b94b974dfd14c101d44cb7c33c402296f93803535f`.

Results:
- Yosys: LUT2 64 + LUT3 1 + LUT4 14 + LUT5 49 = 128, INV 137, CARRY4 15, FF 114.
- nextpnr (compact pinout, xc7a200tfbg484-2): 331 SLICE_LUTX / 114 FF / 15 CARRY4 on every seed.
  Over seeds 1-20, Fmax is 178.00 / 194.34 / 221.58 MHz (min / median / max), and all 20 meet
  100 MHz. Per-seed values are in `tag-rtl/sweep_a200t_tag_compact.csv`. The worst path is the
  32-bit accumulator carry chain on 19 of 20 seeds; on seed 7 it is the `valid_out` output path. (An earlier version of this line covered seeds 1-6 only.)
- The tag `rtl/int8_dot.v` differs from `src/int8_dot.v` only by a comment.

Ratios on the tag RTL: 269/128 = 2.10x (Yosys synthesis), 471/331 = 1.42x (post-route).

**What counts as a LUT.** The Yosys ratio above is LUT2-LUT6 only. Yosys emits `INV`
as its own cell type; Vivado has no such primitive and an inverter lands in a LUT1,
inside the LUT count. Counting INV as a LUT -- the like-for-like comparison against a
Vivado number -- gives 398/265 = 1.50x on the tag unit and 398/257 = 1.55x on the
branch unit. The ternary design carries more inverters than the int8 one (137 vs 129),
so excluding them flatters it. Quote 2.10x only with the cell classes attached.

Speed estimates are nextpnr's timing model on synthetic pins, not Vivado signoff and
not silicon.

---

## Note added on integration

The three Yosys logs (`ternary.yosys.log`, `int8.yosys.log`, `tag-rtl/yosys.log`) were
zero bytes as first supplied: those runs used `yosys -q ... > file.log`, and `-q`
suppresses exactly the output being redirected. They were re-run on 2026-10-02 with
`-l <log>` instead, same Yosys build (0.67+post, b8e7da6f), same working directories,
same relative source paths. The re-run reproduces all three netlists byte for byte
against the hashes in `INPUTS.sha256`, and its `.stat` files are byte-identical to the
ones already in this bundle -- verified here against the committed copies before these
logs were added. The logs now present are those re-run logs; the only difference from
the original runs is the absolute output path on line 9 of each.

`YOSYS-LOGS.md` is the contributor's note, mapping each log to the empty file it
replaces. Logs by D. Vasilev.

With these in place, "regenerate from the yosys log" in `INPUTS.sha256` is true as
written.
