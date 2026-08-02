
# ── Tier-2: streaming GEMM (inserted by build_tier2.sh) ──────────────────
create_bd_cell -type ip -vlnv shepherdscientific.com:user:axi_gemm_stream:1.0 axi_gemm_stream_0
connect_bd_intf_net [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] \
    [get_bd_intf_pins axi_gemm_stream_0/s_axi]
connect_bd_net [get_bd_pins axi_gemm_stream_0/clk]   [get_bd_pins weight_bram_0/clk]
connect_bd_net [get_bd_pins axi_gemm_stream_0/rst_n] [get_bd_pins weight_bram_0/rst_n]
connect_bd_net [get_bd_pins axi_gemm_stream_0/w_word_addr] \
    [get_bd_pins weight_bram_0/w_word_addr]
connect_bd_net [get_bd_pins axi_gemm_stream_0/w_word] \
    [get_bd_pins weight_bram_0/w_word]
assign_bd_address -target_address_space /microblaze_0/Data \
    [get_bd_addr_segs axi_gemm_stream_0/s_axi/reg0]
set_property offset 0x44200000 [get_bd_addr_segs {microblaze_0/Data/SEG_axi_gemm_stream_0_reg0}]
puts "  Streaming GEMM:    0x44200000  (Tier-2, COLS=64)"
