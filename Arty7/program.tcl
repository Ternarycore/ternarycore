# program.tcl -- xsdb: load a bitstream, download an ELF, run. Lives in the
# repo rather than /tmp, which every blackout wipes.
#   xsdb Arty7/program.tcl <bitstream> <elf>
set bit [lindex $argv 0]
set elf [lindex $argv 1]
connect
puts "PROG $bit"
fpga -file $bit
after 4000
targets
targets -set -filter {name =~ "*MicroBlaze*#0*"}
rst -processor
after 500
dow $elf
puts "ELF DOWNLOADED"
con
after 2000
puts "CORE RUNNING"
disconnect
exit
