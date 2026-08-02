# create_bd_ddr.tcl — Phase 2: MicroBlaze + DDR3 (MIG) + Tier-2 streaming GEMM.
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
#
# Uses the Digilent Arty A7-100 board files (clone of Digilent/vivado-boards
# expected at $HOME/board-files/vivado-boards). MIG is configured entirely by
# the board preset; the whole system runs on the MIG ui_clk (83.333 MHz).
# MicroBlaze gains 16 KB I/D caches over DDR (0x80000000, 256 MB).
# Peripherals: UART16550, GPIO, weight_bram128 (0x44100000),
# axi_gemm_stream (0x44200000). Legacy COLS=4 wrapper dropped.
#
# Usage: vivado -mode batch -source create_bd_ddr.tcl

set_param board.repoPaths [list [file join $::env(HOME) board-files vivado-boards new board_files]]

set part "xc7a100tcsg324-1"
set bd_name "arty_ddr"

create_project -force ${bd_name} ${bd_name} -part ${part}
set_property board_part digilentinc.com:arty-a7-100:part0:1.1 [current_project]

set repo_root [file normalize [file join [file dirname [file normalize [info script]]] ..]]

set_property ip_repo_paths [list \
    [file join $repo_root ip weight_bram128] \
    [file join $repo_root ip axi_gemm_stream] \
] [current_project]
update_ip_catalog

add_files -fileset constrs_1 [file join $repo_root constraints arty_ddr.xdc]

create_bd_design $bd_name

# ── MIG DDR3 via board preset ──────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
apply_bd_automation -rule xilinx.com:bd_rule:mig_7series \
    -config { Board_Interface {ddr3_sdram} } [get_bd_cells mig_7series_0]

# Board reset + sys clock to MIG (automation usually handles; be explicit if not)
if {[llength [get_bd_ports -quiet sys_rst*]] == 0 && [llength [get_bd_ports -quiet reset*]] == 0} {
    catch { apply_board_connection -board_interface "reset" -ip_intf "mig_7series_0/SYS_RST" -diagram $bd_name }
}

# ── MicroBlaze (cached) ──────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
set_property -dict [list \
    CONFIG.C_USE_FPU      {0} \
    CONFIG.C_USE_MSR_INSTR  {1} \
    CONFIG.C_USE_PCMP_INSTR {1} \
    CONFIG.C_USE_BARREL   {1} \
    CONFIG.C_USE_DIV      {1} \
    CONFIG.C_USE_HW_MUL   {1} \
    CONFIG.C_DEBUG_ENABLED {1} \
] [get_bd_cells microblaze_0]

apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {
    local_mem    "64KB"
    ecc          "None"
    cache        "16KB"
    debug_module "Debug Only"
    axi_periph   "Enabled"
    axi_intc     "0"
    clk          "/mig_7series_0/ui_clk (83 MHz)"
} [get_bd_cells microblaze_0]

# Cached AXI → MIG
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
    Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} \
    Master {/microblaze_0 (Cached)} Slave {/mig_7series_0/S_AXI} \
    ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0} } \
    [get_bd_intf_pins mig_7series_0/S_AXI]

# ── Peripherals ───────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
set_property CONFIG.C_S_AXI_ACLK_FREQ_HZ {83333333} [get_bd_cells axi_uart16550_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property -dict [list CONFIG.C_GPIO_WIDTH {4} CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000}] [get_bd_cells axi_gpio_0]

create_bd_cell -type ip -vlnv shepherdscientific.com:user:weight_bram128:1.0 weight_bram_0
set_property CONFIG.ADDR_WIDTH {18} [get_bd_cells weight_bram_0]

create_bd_cell -type ip -vlnv shepherdscientific.com:user:axi_gemm_stream:1.0 axi_gemm_stream_0

foreach slave {axi_uart16550_0/S_AXI axi_gpio_0/S_AXI weight_bram_0/s_axi axi_gemm_stream_0/s_axi} {
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config [list \
        Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} \
        Master {/microblaze_0 (Periph)} Slave "/$slave" \
        ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}] \
        [get_bd_intf_pins $slave]
}

# stream ↔ weight BRAM 128b read port
connect_bd_net [get_bd_pins axi_gemm_stream_0/w_word_addr] [get_bd_pins weight_bram_0/w_word_addr]
connect_bd_net [get_bd_pins axi_gemm_stream_0/w_word]      [get_bd_pins weight_bram_0/w_word]

# ── Address map ───────────────────────────────────────────────────
assign_bd_address
set_property offset 0x40000000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gpio_0_Reg}]
set_property range  64K        [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gpio_0_Reg}]
set_property offset 0x40600000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_uart16550_0_Reg}]
set_property range  64K        [get_bd_addr_segs {microblaze_0/Data/SEG_axi_uart16550_0_Reg}]
set_property offset 0x44100000 [get_bd_addr_segs {microblaze_0/Data/SEG_weight_bram_0_reg0}]
set_property range  256K       [get_bd_addr_segs {microblaze_0/Data/SEG_weight_bram_0_reg0}]
set_property offset 0x44200000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gemm_stream_0_reg0}]

# ── External ports ────────────────────────────────────────────────
make_bd_intf_pins_external [get_bd_intf_pins axi_uart16550_0/UART]
make_bd_pins_external [get_bd_pins axi_gpio_0/gpio_io_o]

validate_bd_design
save_bd_design

make_wrapper -files [get_files ${bd_name}.bd] -top
add_files -norecurse [file join [file dirname [get_files ${bd_name}.bd]] hdl ${bd_name}_wrapper.v]
update_compile_order -fileset sources_1

puts "Phase-2 block design created: ${bd_name}.bd"
puts "  DDR3 (MIG):        0x80000000  (256 MB, cached)"
puts "  Weight BRAM128:    0x44100000"
puts "  Streaming GEMM:    0x44200000"
puts "  UART/GPIO:         0x40600000 / 0x40000000  (ui_clk 83.333 MHz — DLL=45)"
