# run_tier1.tcl -- program bitstream, download ELF, run. Use with xsdb.
set bit  [lindex $argv 0]
set elf  [lindex $argv 1]

connect
puts "Programming FPGA: $bit"
fpga -file $bit
after 3000
targets
targets -set -filter {name =~ "*MicroBlaze*#0*"}
puts "Target: [targets -filter {name =~ \"*MicroBlaze*#0*\"}]"
rst -processor
dow $elf
puts "ELF downloaded, starting core."
con
after 2000
puts "Core running."
disconnect
