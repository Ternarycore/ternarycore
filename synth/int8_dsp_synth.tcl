# INT8 baseline with DSP48 mapping forced (use_dsp attribute) — OOC.
set part xc7a100tcsg324-1
read_verilog synth/int8_dot_dsp.v
read_verilog rtl/int8_gemm.v
synth_design -top int8_gemm -part $part -mode out_of_context -generic COLS=64 -generic DEPTH=768
create_clock -period 10.000 -name clk [get_ports clk]
report_utilization -file synth/int8_gemm64_dsp_util.rpt
report_timing_summary -file synth/int8_gemm64_dsp_timing.rpt
puts "=== INT8_GEMM DSP-FORCED COLS=64 DEPTH=768 ==="
puts "  LUT  : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LUT}]]"
puts "  FF   : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == FLOP_LATCH}]]"
puts "  DSP48: [llength [get_cells -hier -filter {REF_NAME =~ DSP48*}]]"
puts "INT8_DSP_SYNTH_DONE"
