# create_bd_ddr.tcl — Phase 2: MicroBlaze + DDR3 (MIG) + Tier-2 streaming GEMM.
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
#
# Deterministic construction — no bd_automation rules. MIG is configured from
# the Digilent Arty A7-100 mig.prj (board-files clone at ~/board-files); the
# MicroBlaze subsystem (LMB, MDM, caches, interconnects, resets) is built
# explicitly. Whole system runs on the MIG ui_clk (~81.25 MHz).
#
#   DDR3 (cached):     0x80000000  256 MB
#   Weight BRAM128:    0x44100000
#   Streaming GEMM:    0x44200000
#   UART16550 / GPIO:  0x40600000 / 0x40000000   (UART DLL = 44 @ 81.25 MHz)
#
# Usage: vivado -mode batch -source create_bd_ddr.tcl

set part "xc7a100tcsg324-1"
set bd_name "arty_ddr"
set migprj [file join $::env(HOME) board-files vivado-boards new board_files arty-a7-100 E.0 1.1 mig.prj]
if {![file exists $migprj]} { error "mig.prj not found: $migprj" }

create_project -force ${bd_name} ${bd_name} -part ${part}

set repo_root [file normalize [file join [file dirname [file normalize [info script]]] ..]]
set_property ip_repo_paths [list \
    [file join $repo_root ip weight_bram128] \
    [file join $repo_root ip axi_gemm_stream] \
] [current_project]
update_ip_catalog

add_files -fileset constrs_1 [file join $repo_root constraints arty_ddr.xdc]

create_bd_design $bd_name

# ── MIG from Digilent project file ──────────────────────────────────
file copy -force $migprj [file join [pwd] ${bd_name} mig_a.prj]
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
set_property CONFIG.XML_INPUT_FILE [file normalize [file join [pwd] ${bd_name} mig_a.prj]] \
    [get_bd_cells mig_7series_0]

# External DDR3 interface + board clock/reset
make_bd_intf_pins_external [get_bd_intf_pins mig_7series_0/DDR3]
create_bd_port -dir I -type clk -freq_hz 100000000 sys_clk
connect_bd_net [get_bd_ports sys_clk] [get_bd_pins mig_7series_0/sys_clk_i]
create_bd_port -dir I -type rst sys_rst_n
set_property CONFIG.POLARITY {ACTIVE_LOW} [get_bd_ports sys_rst_n]
connect_bd_net [get_bd_ports sys_rst_n] [get_bd_pins mig_7series_0/sys_rst]
if {[llength [get_bd_pins -quiet mig_7series_0/device_temp_i]]} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 temp_zero
    set_property -dict [list CONFIG.CONST_WIDTH {12} CONFIG.CONST_VAL {0}] [get_bd_cells temp_zero]
    connect_bd_net [get_bd_pins temp_zero/dout] [get_bd_pins mig_7series_0/device_temp_i]
}

create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_ref
set_property -dict [list CONFIG.PRIM_IN_FREQ {100.000} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false}] [get_bd_cells clk_ref]
connect_bd_net [get_bd_ports sys_clk] [get_bd_pins clk_ref/clk_in1]
connect_bd_net [get_bd_pins clk_ref/clk_out1] [get_bd_pins mig_7series_0/clk_ref_i]

set UICLK [get_bd_pins mig_7series_0/ui_clk]

# ── Reset infrastructure on ui_clk ───────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ui
connect_bd_net $UICLK [get_bd_pins rst_ui/slowest_sync_clk]
connect_bd_net [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_ui/dcm_locked]
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 rst_inv
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not}] [get_bd_cells rst_inv]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins rst_inv/Op1]
connect_bd_net [get_bd_pins rst_inv/Res] [get_bd_pins rst_ui/ext_reset_in]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] [get_bd_pins mig_7series_0/aresetn]

# ── MicroBlaze + LMB + MDM (explicit) ────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
set_property -dict [list \
    CONFIG.C_USE_FPU {0} CONFIG.C_USE_MSR_INSTR {1} CONFIG.C_USE_PCMP_INSTR {1} \
    CONFIG.C_USE_BARREL {1} CONFIG.C_USE_DIV {1} CONFIG.C_USE_HW_MUL {1} \
    CONFIG.C_DEBUG_ENABLED {1} CONFIG.C_D_AXI {1} \
    CONFIG.C_USE_ICACHE {1} CONFIG.C_USE_DCACHE {1} \
    CONFIG.C_CACHE_BYTE_SIZE {16384} CONFIG.C_DCACHE_BYTE_SIZE {16384} \
    CONFIG.C_ICACHE_BASEADDR {0x80000000} CONFIG.C_ICACHE_HIGHADDR {0x8FFFFFFF} \
    CONFIG.C_DCACHE_BASEADDR {0x80000000} CONFIG.C_DCACHE_HIGHADDR {0x8FFFFFFF} \
    CONFIG.C_ICACHE_ALWAYS_USED {1} CONFIG.C_DCACHE_ALWAYS_USED {1} \
] [get_bd_cells microblaze_0]
connect_bd_net $UICLK [get_bd_pins microblaze_0/Clk]

foreach b {dlmb ilmb} {
    create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ${b}_v10
    create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ${b}_cntlr
    connect_bd_net $UICLK [get_bd_pins ${b}_v10/LMB_Clk]
    connect_bd_net $UICLK [get_bd_pins ${b}_cntlr/LMB_Clk]
    connect_bd_net [get_bd_pins rst_ui/bus_struct_reset] [get_bd_pins ${b}_v10/SYS_Rst]
    connect_bd_net [get_bd_pins rst_ui/bus_struct_reset] [get_bd_pins ${b}_cntlr/LMB_Rst]
    connect_bd_intf_net [get_bd_intf_pins ${b}_v10/LMB_Sl_0] [get_bd_intf_pins ${b}_cntlr/SLMB]
}
connect_bd_intf_net [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
connect_bd_intf_net [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]

create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.use_bram_block {BRAM_Controller}] \
    [get_bd_cells lmb_bram]
connect_bd_intf_net [get_bd_intf_pins dlmb_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins ilmb_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1
connect_bd_intf_net [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
connect_bd_net [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_ui/mb_debug_sys_rst]
connect_bd_net [get_bd_pins rst_ui/mb_reset] [get_bd_pins microblaze_0/Reset]

# ── Cached AXI → MIG via SmartConnect ─────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1}] [get_bd_cells axi_smc]
connect_bd_intf_net [get_bd_intf_pins microblaze_0/M_AXI_IC] [get_bd_intf_pins axi_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins microblaze_0/M_AXI_DC] [get_bd_intf_pins axi_smc/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
connect_bd_net $UICLK [get_bd_pins axi_smc/aclk]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] [get_bd_pins axi_smc/aresetn]

# ── Peripheral interconnect (M_AXI_DP → 4 slaves) ─────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 periph
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {4}] [get_bd_cells periph]
connect_bd_intf_net [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins periph/S00_AXI]
connect_bd_net $UICLK [get_bd_pins periph/ACLK] [get_bd_pins periph/S00_ACLK] \
    [get_bd_pins periph/M00_ACLK] [get_bd_pins periph/M01_ACLK] \
    [get_bd_pins periph/M02_ACLK] [get_bd_pins periph/M03_ACLK]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] \
    [get_bd_pins periph/ARESETN] [get_bd_pins periph/S00_ARESETN] \
    [get_bd_pins periph/M00_ARESETN] [get_bd_pins periph/M01_ARESETN] \
    [get_bd_pins periph/M02_ARESETN] [get_bd_pins periph/M03_ARESETN]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
set_property CONFIG.C_S_AXI_ACLK_FREQ_HZ {81250000} [get_bd_cells axi_uart16550_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property -dict [list CONFIG.C_GPIO_WIDTH {4} CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_0]
create_bd_cell -type ip -vlnv shepherdscientific.com:user:weight_bram128:1.0 weight_bram_0
create_bd_cell -type ip -vlnv shepherdscientific.com:user:axi_gemm_stream:1.0 axi_gemm_stream_0

connect_bd_intf_net [get_bd_intf_pins periph/M00_AXI] [get_bd_intf_pins axi_uart16550_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins periph/M01_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins periph/M02_AXI] [get_bd_intf_pins weight_bram_0/s_axi]
connect_bd_intf_net [get_bd_intf_pins periph/M03_AXI] [get_bd_intf_pins axi_gemm_stream_0/s_axi]

connect_bd_net $UICLK [get_bd_pins axi_uart16550_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] \
    [get_bd_pins weight_bram_0/clk] [get_bd_pins axi_gemm_stream_0/clk]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] \
    [get_bd_pins axi_uart16550_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] \
    [get_bd_pins weight_bram_0/rst_n] [get_bd_pins axi_gemm_stream_0/rst_n]

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

make_bd_intf_pins_external [get_bd_intf_pins axi_uart16550_0/UART]
make_bd_pins_external [get_bd_pins axi_gpio_0/gpio_io_o]

validate_bd_design
save_bd_design

make_wrapper -files [get_files ${bd_name}.bd] -top
add_files -norecurse [file join [file dirname [get_files ${bd_name}.bd]] hdl ${bd_name}_wrapper.v]
update_compile_order -fileset sources_1

puts "Phase-2 block design created: ${bd_name}.bd (ui_clk ~81.25 MHz, UART DLL=44)"
