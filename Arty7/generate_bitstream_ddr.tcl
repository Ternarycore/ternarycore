# generate_bitstream.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference
#
# Generates bitstream for the Arty A7-100T MicroBlaze + GEMM design.
# Prerequisite: Run create_bd.tcl first.
#
# Usage: vivado -mode batch -source generate_bitstream.tcl

set part "xc7a100tcsg324-1"
set bd_name "arty_ddr"
set top "${bd_name}_wrapper"

set repo_root [file normalize [file join [file dirname [file normalize [info script]]] ..]]

# ── Re-open project (assumes create_bd.tcl already ran) ───────────────────────
if {[get_projects -quiet] eq ""} {
    open_project ${bd_name}/${bd_name}.xpr
}

# ── Synthesis ─────────────────────────────────────────────────────────────────
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Check synthesis warnings for latches
set synth_log [get_property LOG [get_runs synth_1]]
if {[regexp {Latch} $synth_log]} {
    puts "WARNING: Latches inferred in synthesis! Check synthesis log."
}

# Check timing estimate post-synthesis
set wns_synth [get_property STATS.WNS [get_runs synth_1]]
puts "Post-synthesis WNS: ${wns_synth} ns"
if {${wns_synth} < 0.0} {
    puts "WARNING: Negative post-synthesis WNS. Timing may fail after implementation."
}

# ── Implementation ────────────────────────────────────────────────────────────
set_property strategy Performance_Explore [get_runs impl_1]
reset_run impl_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1

# ── Check Results ─────────────────────────────────────────────────────────────
set wns [get_property STATS.WNS [get_runs impl_1]]
set whs [get_property STATS.WHS [get_runs impl_1]]
set tns [get_property STATS.TNS [get_runs impl_1]]

puts "Timing summary:"
puts "  WNS: ${wns} ns (must be >= 0)"
puts "  WHS: ${whs} ns (must be >= 0)"
puts "  TNS: ${tns} ns"

if {${wns} < 0.0 || ${whs} < 0.0} {
    puts "ERROR: Timing closure FAILED at 100 MHz."
    # Generate timing report for debug
    open_run impl_1
    report_timing_summary -file ${bd_name}_timing.rpt
    report_utilization -file ${bd_name}_utilization.rpt
    close_project
    exit 1
}

# ── Utilization ───────────────────────────────────────────────────────────────
open_run impl_1
report_utilization -file ${bd_name}_utilization.rpt

# Check LUT utilization against 63,400 limit (100% of Artix-7 100T)
set luts [get_property SLICE.LUTS [get_design]]
puts "LUT utilization: ${luts} / 63400"
if {${luts} > 63400} {
    puts "ERROR: LUT utilization ${luts} exceeds 63,400 budget."
    close_project
    exit 1
}

# ── Generate Bitstream ────────────────────────────────────────────────────────
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

set bitstream [file join [get_property DIRECTORY [get_runs impl_1]] ${top}.bit]
if {[file exists $bitstream]} {
    puts "Bitstream: ${bitstream}"
    puts "SUCCESS: Timing closed at 100 MHz, LUTs within budget."
} else {
    puts "ERROR: Bitstream not found at expected path: ${bitstream}"
    close_project
    exit 1
}

close_project
