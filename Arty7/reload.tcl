# reload.tcl -- download firmware without reprogramming the FPGA.
#
#   xsdb Arty7/reload.tcl <elf>
#
# program.tcl calls "fpga -file", which reconfigures the device and takes
# the DDR3 controller down with it. That costs the entire weight image:
# 110 MB, which is 2.6 hours over UART. Every firmware iteration would
# pay it.
#
# Nothing about a firmware change requires reconfiguring the fabric. The
# ELF lives in LMB block RAM, written over the debug bridge, and
# "rst -processor" resets the MicroBlaze alone -- the MIG keeps running
# and DDR keeps its contents. So this is the same download without the
# part that throws the model away.
#
# Use program.tcl when the bitstream itself changed. Use this otherwise,
# and check the weights survived by running a block against the golden
# model rather than assuming they did.
#
# SPDX-License-Identifier: CERN-OHL-S-2.0
set elf [lindex $argv 0]
connect
targets -set -filter {name =~ "*MicroBlaze*#0*"}
rst -processor
after 500
dow $elf
puts "ELF DOWNLOADED (fabric untouched, DDR preserved)"
con
after 2000
puts "CORE RUNNING"
disconnect
exit
