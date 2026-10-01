# Tier-2 SoC — implementation directive sweep

Vivado 2025.2, xc7a100tcsg324-1, 100 MHz, built from tag `v1.0.1-trets`.
Same synthesised netlist throughout; only the implementation strategy changes.
Vivado exposes no placer seed, so this sweeps place / phys_opt / route directives
via the built-in implementation strategies.

| Strategy | WNS (ns) | TNS (ns) | WHS (ns) | Meets 100 MHz |
|---|---:|---:|---:|---|
| Performance_ExplorePostRoutePhysOpt | **+0.137** | 0.000 | +0.052 | **yes** |
| Performance_Explore | -0.101 | -0.310 | +0.052 | no |
| Performance_RefinePlacement | -0.124 | -0.219 | +0.013 | no |
| Performance_NetDelay_high | -0.133 | -0.444 | +0.023 | no |
| Performance_Retiming | -0.234 | -2.057 | +0.013 | no |
| Performance_ExtraTimingOpt | -0.351 | -13.364 | +0.014 | no |

## Reading

One directive of six closes timing. The spread is 488 ps, from -0.351 to +0.137 ns.
Closure depends specifically on **post-route physical optimisation**, not on placement
variation: the four directives that stop at routing all land between -0.10 and -0.35 ns.

The two strategies that try hardest at the timing-optimisation stage, Performance_Retiming
and Performance_ExtraTimingOpt, do the worst. The critical path is the 32-bit accumulator
carry chain (`act_ram` RAMB18E1 -> ternary select -> `acc_reg[31]` in dot 62; 10 logic
levels, 6 CARRY4 deep, 9.951 ns with 4.898 ns of routing), and aggressive retiming across
a long carry chain is counterproductive here.

`Arty7/generate_bitstream.tcl` therefore pins Performance_ExplorePostRoutePhysOpt, so the
closing result is what a rebuild from this tag reproduces.

## Honest statement of the margin

The Tier-2 SoC meets timing at 100 MHz with +0.137 ns of slack under the pinned strategy.
That margin is not robust across implementation directives, and the design should not be
described as having comfortable headroom at 100 MHz. A faster target would need the
accumulator path pipelined rather than a different directive.
