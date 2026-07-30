# Tier-2 vs INT8 baseline — OOC synth on the Arty part for LUT/DSP/Fmax.
set part xc7a100tcsg324-1
proc rpt {name} {
    puts "=== $name ==="
    puts "  LUT  : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LUT}]]"
    puts "  FF   : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == FLOP_LATCH}]]"
    puts "  DSP48: [llength [get_cells -hier -filter {REF_NAME =~ DSP48*}]]"
    puts "  LATCH: [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LATCH}]]"
}
read_verilog rtl/ternary_mac.v
read_verilog rtl/ternary_dot.v
read_verilog rtl/ternary_gemm.v
synth_design -top ternary_gemm -part $part -mode out_of_context -generic COLS=64 -generic DEPTH=768
create_clock -period 10.000 -name clk [get_ports clk]
report_utilization -file synth/ternary_gemm64_util.rpt
report_timing_summary -file synth/ternary_gemm64_timing.rpt
rpt "TERNARY_GEMM COLS=64 DEPTH=768 (LUT-only)"

read_verilog rtl/int8_dot.v
read_verilog rtl/int8_gemm.v
synth_design -top int8_gemm -part $part -mode out_of_context -generic COLS=64 -generic DEPTH=768
create_clock -period 10.000 -name clk [get_ports clk]
report_utilization -file synth/int8_gemm64_util.rpt
report_timing_summary -file synth/int8_gemm64_timing.rpt
rpt "INT8_GEMM COLS=64 DEPTH=768 (DSP48 baseline)"

read_verilog rtl/ternary_gemm_stream.v
synth_design -top ternary_gemm_stream -part $part -mode out_of_context -generic COLS=64 -generic DEPTH=768
create_clock -period 10.000 -name clk [get_ports clk]
report_utilization -file synth/tier2_stream64_util.rpt
rpt "TERNARY_GEMM_STREAM COLS=64 (feeder+array)"
puts "TIER2_SYNTH_DONE"
