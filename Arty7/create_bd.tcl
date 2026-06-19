# create_bd.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference
#
# Vivado block design for Arty A7-100T MicroBlaze + GEMM accelerator system.
#
# Usage: vivado -mode batch -source create_bd.tcl
#
# Block diagram components:
#   MicroBlaze (no FPU, no cache)     -- soft processor
#   AXI4-Lite Interconnect            -- 1 master, 4 slaves
#   axi_gemm_wrapper (GEMM IP)        -- at 0x44000000
#   weight_bram (Weight BRAM)         -- at 0x44010000
#   AXI UART16550                     -- at 0x40600000
#   AXI GPIO (LEDs)                   -- at 0x40000000

# ── Project Setup ─────────────────────────────────────────────────────────────
set part "xc7a100tcsg324-1"
set bd_name "arty_mb_gemm"

create_project -force ${bd_name} ${bd_name} -part ${part}
# board_part omitted: Digilent board files may not be installed in all Vivado setups.
# Part (xc7a100tcsg324-1) is set above; pin assignments are in the XDC constraints file.

# ── Source custom RTL IPs (packaged in ../ip/) ────────────────────────────────
set repo_root [file normalize [file join [file dirname [file normalize [info script]]] ..]]

set_property ip_repo_paths [list \
    [file join $repo_root ip axi_gemm_wrapper] \
    [file join $repo_root ip weight_bram] \
] [current_project]
update_ip_catalog

# ── Add top-level HDL sources ─────────────────────────────────────────────────
add_files -norecurse [file join $repo_root rtl ternary_gemm.v]
add_files -norecurse [file join $repo_root rtl ternary_dot.v]
add_files -norecurse [file join $repo_root rtl axi_gemm_wrapper.v]
add_files -norecurse [file join $repo_root rtl weight_bram.v]

# ── Add constraints ───────────────────────────────────────────────────────────
add_files -fileset constrs_1 [file join $repo_root constraints arty_a7_100t_mb.xdc]

# ── Create Block Design ───────────────────────────────────────────────────────
create_bd_design $bd_name

# ── Clock Wizard (100 MHz in → 100 MHz out) ───────────────────────────────────
# Created explicitly; without board_part, MicroBlaze automation does not
# auto-generate clock/reset infrastructure in Vivado 2025.2.
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ                  {100.000} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ    {100.000} \
    CONFIG.USE_LOCKED                    {true} \
    CONFIG.USE_RESET                     {false} \
] [get_bd_cells clk_wiz_0]

# External 100 MHz system clock port
create_bd_port -dir I -type clk -freq_hz 100000000 sys_clk
connect_bd_net [get_bd_ports sys_clk] [get_bd_pins clk_wiz_0/clk_in1]

# ── Processor System Reset ────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_100M
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
               [get_bd_pins rst_clk_wiz_100M/slowest_sync_clk]
connect_bd_net [get_bd_pins clk_wiz_0/locked] \
               [get_bd_pins rst_clk_wiz_100M/dcm_locked]

# Active-low reset from board button (BTN0 on Arty, mapped in XDC)
create_bd_port -dir I -type rst sys_rst_n
set_property CONFIG.POLARITY {ACTIVE_LOW} [get_bd_ports sys_rst_n]
connect_bd_net [get_bd_ports sys_rst_n] \
               [get_bd_pins rst_clk_wiz_100M/ext_reset_in]

# ── MicroBlaze ────────────────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0

# Minimal config: no FPU, no caches, barrel/div/mul/debug enabled
set_property -dict [list \
    CONFIG.C_USE_FPU      {0} \
    CONFIG.C_USE_ICACHE   {0} \
    CONFIG.C_USE_DCACHE   {0} \
    CONFIG.C_USE_MSR_INSTR  {1} \
    CONFIG.C_USE_PCMP_INSTR {1} \
    CONFIG.C_USE_BARREL   {1} \
    CONFIG.C_USE_DIV      {1} \
    CONFIG.C_USE_HW_MUL   {1} \
    CONFIG.C_DEBUG_ENABLED {1} \
] [get_bd_cells microblaze_0]

# Apply automation: creates 64 KB LMB BRAM, AXI peripheral interconnect,
# and wires clock/reset. Uses pre-existing clk_wiz_0 and rst_clk_wiz_100M.
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {
    local_mem    "64KB"
    ecc          "None"
    cache        "None"
    debug_module "Debug Only"
    axi_periph   "Enabled"
    axi_intc     "0"
    clk          "/clk_wiz_0/clk_out1 (100 MHz)"
} [get_bd_cells microblaze_0]

# ── AXI UART16550 ─────────────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
set_property -dict [list \
    CONFIG.C_S_AXI_ACLK_FREQ_HZ {100000000} \
] [get_bd_cells axi_uart16550_0]
# Note: baud rate (115200) is set in firmware via the UART divisor registers,
# not as an IP parameter on axi_uart16550.

# ── AXI GPIO (LEDs) ───────────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {4} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
] [get_bd_cells axi_gpio_0]

# ── GEMM Accelerator ──────────────────────────────────────────────────────────
# Reference custom IP packaged by ../ip/package_axi_gemm_wrapper.tcl
create_bd_cell -type ip -vlnv shepherdscientific.com:user:axi_gemm_wrapper:1.0 axi_gemm_wrapper_0
set_property -dict [list \
    CONFIG.DATA_WIDTH {8} \
    CONFIG.ACC_WIDTH {32} \
    CONFIG.ROWS {4} \
    CONFIG.COLS {4} \
    CONFIG.DEPTH {768} \
] [get_bd_cells axi_gemm_wrapper_0]

# ── Weight BRAM ───────────────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv shepherdscientific.com:user:weight_bram:1.0 weight_bram_0
set_property -dict [list \
    CONFIG.ADDR_WIDTH {18} \
    CONFIG.DATA_WIDTH {8} \
] [get_bd_cells weight_bram_0]

# ── AXI Peripheral Interconnect (1 master → 4 slaves) ────────────────────────
# MicroBlaze automation may or may not create microblaze_0_axi_periph depending
# on Vivado version and board_part availability.  We handle both cases explicitly.
if {[llength [get_bd_cells -quiet microblaze_0_axi_periph]] == 0} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 \
        microblaze_0_axi_periph
    # Connect MicroBlaze peripheral AXI master → interconnect slave port
    connect_bd_intf_net [get_bd_intf_pins microblaze_0/M_AXI_DP] \
        [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
    # Interconnect global clock/reset
    connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
        [get_bd_pins microblaze_0_axi_periph/ACLK] \
        [get_bd_pins microblaze_0_axi_periph/S00_ACLK]
    connect_bd_net [get_bd_pins rst_clk_wiz_100M/interconnect_aresetn] \
        [get_bd_pins microblaze_0_axi_periph/ARESETN]
    connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] \
        [get_bd_pins microblaze_0_axi_periph/S00_ARESETN]
}

# Expand to 4 master ports
set_property CONFIG.NUM_MI {4} [get_bd_cells microblaze_0_axi_periph]

# Wire master port clocks and resets
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
    [get_bd_pins microblaze_0_axi_periph/M00_ACLK] \
    [get_bd_pins microblaze_0_axi_periph/M01_ACLK] \
    [get_bd_pins microblaze_0_axi_periph/M02_ACLK] \
    [get_bd_pins microblaze_0_axi_periph/M03_ACLK]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] \
    [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] \
    [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] \
    [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] \
    [get_bd_pins microblaze_0_axi_periph/M03_ARESETN]

# ── Connect AXI slaves ────────────────────────────────────────────────────────
connect_bd_intf_net [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] \
    [get_bd_intf_pins axi_gpio_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI] \
    [get_bd_intf_pins axi_uart16550_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI] \
    [get_bd_intf_pins axi_gemm_wrapper_0/s_axi]
connect_bd_intf_net [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] \
    [get_bd_intf_pins weight_bram_0/s_axi]

# ── Peripheral clocks and resets ──────────────────────────────────────────────
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
    [get_bd_pins axi_gpio_0/s_axi_aclk] \
    [get_bd_pins axi_uart16550_0/s_axi_aclk] \
    [get_bd_pins axi_gemm_wrapper_0/s_axi_aclk] \
    [get_bd_pins weight_bram_0/clk]
connect_bd_net [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] \
    [get_bd_pins axi_gpio_0/s_axi_aresetn] \
    [get_bd_pins axi_uart16550_0/s_axi_aresetn] \
    [get_bd_pins axi_gemm_wrapper_0/s_axi_aresetn] \
    [get_bd_pins weight_bram_0/rst_n]

# ── Assign AXI Address Map ────────────────────────────────────────────────────
# Default addresses are auto-assigned; reassign to the desired fixed map.
assign_bd_address -target_address_space /microblaze_0/Data \
    [get_bd_addr_segs axi_gemm_wrapper_0/s_axi/reg0]

assign_bd_address -target_address_space /microblaze_0/Data \
    [get_bd_addr_segs weight_bram_0/s_axi/reg0]

assign_bd_address -target_address_space /microblaze_0/Data \
    [get_bd_addr_segs axi_uart16550_0/S_AXI/Reg]

assign_bd_address -target_address_space /microblaze_0/Data \
    [get_bd_addr_segs axi_gpio_0/S_AXI/Reg]

set_property offset 0x40000000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gpio_0_Reg}]
set_property range  64K        [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gpio_0_Reg}]

set_property offset 0x40600000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_uart16550_0_Reg}]
set_property range  64K        [get_bd_addr_segs {microblaze_0/Data/SEG_axi_uart16550_0_Reg}]

set_property offset 0x44000000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gemm_wrapper_0_reg0}]
set_property range  64K        [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gemm_wrapper_0_reg0}]

set_property offset 0x44100000 [get_bd_addr_segs {microblaze_0/Data/SEG_weight_bram_0_reg0}]
set_property range  256K       [get_bd_addr_segs {microblaze_0/Data/SEG_weight_bram_0_reg0}]

# ── Connect weight_bram read port to axi_gemm_wrapper ─────────────────────────
# weight_byte and weight_addr are exposed as simple ports.
# For now, firmware manages this via memory-mapped registers; direct wiring
# can be added in a future optimization phase.

# ── Create external ports for board pins ──────────────────────────────────────
# UART
make_bd_intf_pins_external [get_bd_intf_pins axi_uart16550_0/UART]
# GPIO LEDs
make_bd_pins_external [get_bd_pins axi_gpio_0/gpio_io_o]

# ── Validate and save ─────────────────────────────────────────────────────────
validate_bd_design
save_bd_design

# ── Generate HDL wrapper ──────────────────────────────────────────────────────
make_wrapper -files [get_files ${bd_name}.bd] -top
add_files -norecurse [file join [file dirname [get_files ${bd_name}.bd]] hdl ${bd_name}_wrapper.v]
update_compile_order -fileset sources_1

puts "Block design created: ${bd_name}.bd"
puts "Address map:"
puts "  GPIO (LEDs):      0x40000000"
puts "  AXI UART16550:     0x40600000"
puts "  GEMM Accelerator:  0x44000000"
puts "  Weight BRAM:       0x44100000  (256K, ADDR_WIDTH=18)"

close_project
