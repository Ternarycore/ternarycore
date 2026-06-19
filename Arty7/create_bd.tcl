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

# ── MicroBlaze ────────────────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {
    presets "Local Memory: 64KB"
} [get_bd_cells microblaze_0]

# Disable FPU and caches (minimal MicroBlaze)
set_property -dict [list \
    CONFIG.C_USE_FPU {0} \
    CONFIG.C_USE_ICACHE {0} \
    CONFIG.C_USE_DCACHE {0} \
    CONFIG.C_USE_MSR_INSTR {1} \
    CONFIG.C_USE_PCMP_INSTR {1} \
    CONFIG.C_USE_BARREL {1} \
    CONFIG.C_USE_DIV {1} \
    CONFIG.C_USE_HW_MUL {1} \
    CONFIG.C_DEBUG_ENABLED {1} \
] [get_bd_cells microblaze_0]

# ── Clock and Reset ───────────────────────────────────────────────────────────
# MicroBlaze automation creates clk_wiz and rst_clk_wiz already.
# Configure the clock wizard for 100 MHz from external 100 MHz clock.
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {100.000} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
] [get_bd_cells clk_wiz_0]

# ── AXI UART16550 ─────────────────────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
set_property -dict [list \
    CONFIG.C_S_AXI_ACLK_FREQ_HZ {100000000} \
    CONFIG.C_BAUDRATE {115200} \
] [get_bd_cells axi_uart16550_0]

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

# ── AXI Interconnect (1 master, 4 slaves) ─────────────────────────────────────
# MicroBlaze automation creates microblaze_0_axi_periph (AXI4-Lite interconnect).
# We need to add our peripherals as slaves on this interconnect.
# The automation connects the MicroBlaze M_AXI_DP to the interconnect.
# We connect the interconnect to each peripheral's S_AXI port.

# ── Connect additional AXI slaves ─────────────────────────────────────────────
# Connect axi_gemm_wrapper (slave) to the AXI interconnect
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
    Master "/microblaze_0 (Peripheral)"
    Clk "/clk_wiz_0 (100 MHz)"
} [get_bd_intf_pins axi_gemm_wrapper_0/s_axi]

# Connect weight_bram (slave) to the AXI interconnect
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
    Master "/microblaze_0 (Peripheral)"
    Clk "/clk_wiz_0 (100 MHz)"
} [get_bd_intf_pins weight_bram_0/s_axi]

# Connect UART (slave) to the AXI interconnect
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
    Master "/microblaze_0 (Peripheral)"
    Clk "/clk_wiz_0 (100 MHz)"
} [get_bd_intf_pins axi_uart16550_0/S_AXI]

# Connect GPIO (slave) to the AXI interconnect
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
    Master "/microblaze_0 (Peripheral)"
    Clk "/clk_wiz_0 (100 MHz)"
} [get_bd_intf_pins axi_gpio_0/S_AXI]

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

set_property offset 0x44010000 [get_bd_addr_segs {microblaze_0/Data/SEG_weight_bram_0_reg0}]
set_property range  1M         [get_bd_addr_segs {microblaze_0/Data/SEG_weight_bram_0_reg0}]

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
puts "  Weight BRAM:       0x44010000"

close_project
