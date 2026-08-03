// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Mon Aug  3 14:22:16 2026
// Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_axi_ethernetlite_0_0/arty_ddr_axi_ethernetlite_0_0_stub.v
// Design      : arty_ddr_axi_ethernetlite_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "arty_ddr_axi_ethernetlite_0_0,axi_ethernetlite,{}" *) (* core_generation_info = "arty_ddr_axi_ethernetlite_0_0,axi_ethernetlite,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=axi_ethernetlite,x_ipVersion=3.0,x_ipCoreRevision=36,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=artix7,C_SELECT_XPM=1,C_INSTANCE=axi_ethernetlite_inst,C_S_AXI_ACLK_PERIOD_PS=12308,C_S_AXI_ADDR_WIDTH=13,C_S_AXI_DATA_WIDTH=32,C_S_AXI_ID_WIDTH=1,C_S_AXI_PROTOCOL=AXI4LITE,C_INCLUDE_MDIO=1,C_INCLUDE_INTERNAL_LOOPBACK=0,C_INCLUDE_GLOBAL_BUFFERS=1,C_DUPLEX=1,C_TX_PING_PONG=1,C_RX_PING_PONG=1}" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* x_core_info = "axi_ethernetlite,Vivado 2025.2" *) 
module arty_ddr_axi_ethernetlite_0_0(s_axi_aclk, s_axi_aresetn, ip2intc_irpt, 
  s_axi_awaddr, s_axi_awvalid, s_axi_awready, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, 
  s_axi_wready, s_axi_bresp, s_axi_bvalid, s_axi_bready, s_axi_araddr, s_axi_arvalid, 
  s_axi_arready, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready, phy_tx_clk, phy_rx_clk, 
  phy_crs, phy_dv, phy_rx_data, phy_col, phy_rx_er, phy_rst_n, phy_tx_en, phy_tx_data, phy_mdio_i, 
  phy_mdio_o, phy_mdio_t, phy_mdc)
/* synthesis syn_black_box black_box_pad_pin="s_axi_aresetn,ip2intc_irpt,s_axi_awaddr[12:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[12:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,phy_tx_clk,phy_rx_clk,phy_crs,phy_dv,phy_rx_data[3:0],phy_col,phy_rx_er,phy_rst_n,phy_tx_en,phy_tx_data[3:0],phy_mdio_i,phy_mdio_o,phy_mdio_t,phy_mdc" */
/* synthesis syn_force_seq_prim="s_axi_aclk" */;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *) (* x_interface_mode = "slave s_axi_aclk" *) (* x_interface_parameter = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0" *) input s_axi_aclk /* synthesis syn_isclock = 1 */;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *) (* x_interface_mode = "slave s_axi_aresetn" *) (* x_interface_parameter = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *) (* x_interface_mode = "master interrupt" *) (* x_interface_parameter = "XIL_INTERFACENAME interrupt, SUGGESTED_PRIORITY HIGH, SENSITIVITY EDGE_RISING, PortWidth 1" *) output ip2intc_irpt;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *) (* x_interface_mode = "slave S_AXI" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXI, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 81247969, ID_WIDTH 0, ADDR_WIDTH 13, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [12:0]s_axi_awaddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input s_axi_awvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output s_axi_awready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input [31:0]s_axi_wdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input [3:0]s_axi_wstrb;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input s_axi_wvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output s_axi_wready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output s_axi_bvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input s_axi_bready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input [12:0]s_axi_araddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input s_axi_arvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output s_axi_arready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output [31:0]s_axi_rdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output s_axi_rvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input s_axi_rready;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII TX_CLK" *) (* x_interface_mode = "master MII" *) (* x_interface_parameter = "XIL_INTERFACENAME MII, BOARD.ASSOCIATED_PARAM MII_BOARD_INTERFACE" *) input phy_tx_clk;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII RX_CLK" *) input phy_rx_clk;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII CRS" *) input phy_crs;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII RX_DV" *) input phy_dv;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII RXD" *) input [3:0]phy_rx_data;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII COL" *) input phy_col;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII RX_ER" *) input phy_rx_er;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII RST_N" *) output phy_rst_n;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII TX_EN" *) output phy_tx_en;
  (* x_interface_info = "xilinx.com:interface:mii:1.0 MII TXD" *) output [3:0]phy_tx_data;
  (* x_interface_info = "xilinx.com:interface:mdio:1.0 MDIO MDIO_I" *) (* x_interface_mode = "master MDIO" *) (* x_interface_parameter = "XIL_INTERFACENAME MDIO, BOARD.ASSOCIATED_PARAM MDIO_BOARD_INTERFACE, CAN_DEBUG false" *) input phy_mdio_i;
  (* x_interface_info = "xilinx.com:interface:mdio:1.0 MDIO MDIO_O" *) output phy_mdio_o;
  (* x_interface_info = "xilinx.com:interface:mdio:1.0 MDIO MDIO_T" *) output phy_mdio_t;
  (* x_interface_info = "xilinx.com:interface:mdio:1.0 MDIO MDC" *) output phy_mdc;
endmodule
