# Out-of-context synth of PR#8 inference pipeline + FP8 decoder.
# Reports DSP/LUT/latch usage — the "does it survive silicon" check.
set part xc7a100tcsg324-1

read_verilog rtl/ternary_mac.v
read_verilog rtl/ternary_dot.v
read_verilog rtl/ternary_gemm.v
read_verilog rtl/activation_quant.v
read_verilog rtl/ternary_scale.v
read_verilog rtl/ternary_pipeline.v
synth_design -top ternary_pipeline -part $part -mode out_of_context \
    -generic VECTOR_LEN=768 -generic COLS=4
report_utilization -file synth/pr8_pipeline_util.rpt
puts "=== PIPELINE (ternary_pipeline, DEPTH=768, COLS=4) ==="
puts "DSP48  : [llength [get_cells -hier -filter {REF_NAME =~ DSP48*}]]"
puts "LATCH  : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LATCH}]]"
puts "LUT    : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LUT}]]"
puts "FLOP   : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == FLOP_LATCH}]]"

# FP8 decoder standalone (combinational)
read_verilog rtl/fp8_to_q15.v
synth_design -top fp8_to_q15 -part $part -mode out_of_context
puts "=== FP8_TO_Q15 ==="
puts "DSP48  : [llength [get_cells -hier -filter {REF_NAME =~ DSP48*}]]"
puts "LATCH  : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LATCH}]]"
puts "LUT    : [llength [get_cells -hier -filter {PRIMITIVE_GROUP == LUT}]]"

puts "SYNTH_CHECK_DONE"
