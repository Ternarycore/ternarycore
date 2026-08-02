# eth_dma_block.tcl — sourced by create_bd_ddr.tcl before the address map.
# Adds: AXI CDMA (DDR→weight-BRAM hardware pager) + AXI EthernetLite (MII,
# DP83848 PHY) + 25 MHz PHY reference clock.
#
# Address-space hygiene (build-9 lesson): the CDMA gets PRIVATE crossbars —
# cdma_ic fans its one master out to {DDR via axi_smc, weight_bram via
# bram_ic}; bram_ic merges {periph M02, cdma_ic M01} in front of the BRAM.
# The MicroBlaze cached ports never gain visibility of the peripherals.
# SPDX-License-Identifier: CERN-OHL-S-2.0

# ── grow the fabrics ─────────────────────────────────────────────
set_property CONFIG.NUM_SI {3} [get_bd_cells axi_smc]
set_property CONFIG.NUM_MI {6} [get_bd_cells periph]
connect_bd_net $UICLK [get_bd_pins periph/M04_ACLK] [get_bd_pins periph/M05_ACLK]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] \
    [get_bd_pins periph/M04_ARESETN] [get_bd_pins periph/M05_ARESETN]

# ── CDMA with private routing ───────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0
set_property CONFIG.C_INCLUDE_SG {0} [get_bd_cells axi_cdma_0]
connect_bd_intf_net [get_bd_intf_pins periph/M04_AXI] [get_bd_intf_pins axi_cdma_0/S_AXI_LITE]
connect_bd_net $UICLK [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_cdma_0/m_axi_aclk]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 cdma_ic
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] [get_bd_cells cdma_ic]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 bram_ic
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1}] [get_bd_cells bram_ic]

foreach {cell pins} {
    cdma_ic {ACLK S00_ACLK M00_ACLK M01_ACLK}
    bram_ic {ACLK S00_ACLK S01_ACLK M00_ACLK}
} {
    foreach p $pins { connect_bd_net $UICLK [get_bd_pins $cell/$p] }
}
foreach {cell pins} {
    cdma_ic {ARESETN S00_ARESETN M00_ARESETN M01_ARESETN}
    bram_ic {ARESETN S00_ARESETN S01_ARESETN M00_ARESETN}
} {
    foreach p $pins { connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] [get_bd_pins $cell/$p] }
}

# rewire weight_bram behind bram_ic
delete_bd_objs [get_bd_intf_nets -of [get_bd_intf_pins weight_bram_0/s_axi]]
connect_bd_intf_net [get_bd_intf_pins periph/M02_AXI] [get_bd_intf_pins bram_ic/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins bram_ic/M00_AXI] [get_bd_intf_pins weight_bram_0/s_axi]

connect_bd_intf_net [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins cdma_ic/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins cdma_ic/M00_AXI] [get_bd_intf_pins axi_smc/S02_AXI]
connect_bd_intf_net [get_bd_intf_pins cdma_ic/M01_AXI] [get_bd_intf_pins bram_ic/S01_AXI]

# ── EthernetLite (MII to the DP83848) ─────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0
set_property -dict [list CONFIG.C_INCLUDE_MDIO {1} CONFIG.C_TX_PING_PONG {1} \
    CONFIG.C_RX_PING_PONG {1}] [get_bd_cells axi_ethernetlite_0]
connect_bd_intf_net [get_bd_intf_pins periph/M05_AXI] [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
connect_bd_net $UICLK [get_bd_pins axi_ethernetlite_0/s_axi_aclk]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 eth_mdio
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite_0/MDIO] [get_bd_intf_ports eth_mdio]

foreach {dir width port pin} {
    I 1 eth_tx_clk  phy_tx_clk
    I 1 eth_rx_clk  phy_rx_clk
    I 1 eth_crs     phy_crs
    I 1 eth_col     phy_col
    I 1 eth_rx_dv   phy_dv
    I 4 eth_rxd     phy_rx_data
    I 1 eth_rxerr   phy_rx_er
    O 1 eth_tx_en   phy_tx_en
    O 4 eth_txd     phy_tx_data
    O 1 eth_rstn    phy_rst_n
} {
    if {$width == 1} {
        create_bd_port -dir $dir $port
    } else {
        create_bd_port -dir $dir -from [expr {$width-1}] -to 0 $port
    }
    connect_bd_net [get_bd_ports $port] [get_bd_pins axi_ethernetlite_0/$pin]
}

create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_eth
set_property -dict [list CONFIG.PRIM_IN_FREQ {81.250} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.000} \
    CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false}] [get_bd_cells clk_eth]
connect_bd_net $UICLK [get_bd_pins clk_eth/clk_in1]
create_bd_port -dir O -type clk eth_ref_clk
connect_bd_net [get_bd_ports eth_ref_clk] [get_bd_pins clk_eth/clk_out1]

puts "eth_dma_block: CDMA behind private crossbars, EthernetLite @ M05, 25 MHz ref"
