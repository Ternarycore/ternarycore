# OOC area cross-check, DSP inference disabled (matches Yosys -nodsp intent).
# Usage: vivado -mode batch -source synth_ooc.tcl
proc rep {top} {
    synth_design -top $top -part xc7a100tcsg324-1 -mode out_of_context -max_dsp 0
    set lut [llength [get_cells -hierarchical -quiet -filter {REF_NAME =~ LUT*}]]
    set ff  [llength [get_cells -hierarchical -quiet -filter {REF_NAME =~ FD*}]]
    set c4  [llength [get_cells -hierarchical -quiet -filter {REF_NAME =~ CARRY4*}]]
    set dsp [llength [get_cells -hierarchical -quiet -filter {REF_NAME =~ DSP48*}]]
    puts "XRESULT $top lut=$lut ff=$ff carry4=$c4 dsp=$dsp"
}
read_verilog ternary_dot_nodebug.v ; rep ternary_dot ; close_design

