-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Mon Aug  3 14:22:16 2026
-- Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_axi_ethernetlite_0_0/arty_ddr_axi_ethernetlite_0_0_stub.vhdl
-- Design      : arty_ddr_axi_ethernetlite_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arty_ddr_axi_ethernetlite_0_0 is
  Port ( 
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    ip2intc_irpt : out STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    phy_tx_clk : in STD_LOGIC;
    phy_rx_clk : in STD_LOGIC;
    phy_crs : in STD_LOGIC;
    phy_dv : in STD_LOGIC;
    phy_rx_data : in STD_LOGIC_VECTOR ( 3 downto 0 );
    phy_col : in STD_LOGIC;
    phy_rx_er : in STD_LOGIC;
    phy_rst_n : out STD_LOGIC;
    phy_tx_en : out STD_LOGIC;
    phy_tx_data : out STD_LOGIC_VECTOR ( 3 downto 0 );
    phy_mdio_i : in STD_LOGIC;
    phy_mdio_o : out STD_LOGIC;
    phy_mdio_t : out STD_LOGIC;
    phy_mdc : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of arty_ddr_axi_ethernetlite_0_0 : entity is "arty_ddr_axi_ethernetlite_0_0,axi_ethernetlite,{}";
  attribute core_generation_info : string;
  attribute core_generation_info of arty_ddr_axi_ethernetlite_0_0 : entity is "arty_ddr_axi_ethernetlite_0_0,axi_ethernetlite,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=axi_ethernetlite,x_ipVersion=3.0,x_ipCoreRevision=36,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=artix7,C_SELECT_XPM=1,C_INSTANCE=axi_ethernetlite_inst,C_S_AXI_ACLK_PERIOD_PS=12308,C_S_AXI_ADDR_WIDTH=13,C_S_AXI_DATA_WIDTH=32,C_S_AXI_ID_WIDTH=1,C_S_AXI_PROTOCOL=AXI4LITE,C_INCLUDE_MDIO=1,C_INCLUDE_INTERNAL_LOOPBACK=0,C_INCLUDE_GLOBAL_BUFFERS=1,C_DUPLEX=1,C_TX_PING_PONG=1,C_RX_PING_PONG=1}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of arty_ddr_axi_ethernetlite_0_0 : entity is "yes";
end arty_ddr_axi_ethernetlite_0_0;

architecture stub of arty_ddr_axi_ethernetlite_0_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "s_axi_aclk,s_axi_aresetn,ip2intc_irpt,s_axi_awaddr[12:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[12:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,phy_tx_clk,phy_rx_clk,phy_crs,phy_dv,phy_rx_data[3:0],phy_col,phy_rx_er,phy_rst_n,phy_tx_en,phy_tx_data[3:0],phy_mdio_i,phy_mdio_o,phy_mdio_t,phy_mdc";
  attribute x_interface_info : string;
  attribute x_interface_info of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  attribute x_interface_mode : string;
  attribute x_interface_mode of s_axi_aclk : signal is "slave s_axi_aclk";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of s_axi_aclk : signal is "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0";
  attribute x_interface_info of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 s_axi_aresetn RST";
  attribute x_interface_mode of s_axi_aresetn : signal is "slave s_axi_aresetn";
  attribute x_interface_parameter of s_axi_aresetn : signal is "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of ip2intc_irpt : signal is "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT";
  attribute x_interface_mode of ip2intc_irpt : signal is "master interrupt";
  attribute x_interface_parameter of ip2intc_irpt : signal is "XIL_INTERFACENAME interrupt, SUGGESTED_PRIORITY HIGH, SENSITIVITY EDGE_RISING, PortWidth 1";
  attribute x_interface_info of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  attribute x_interface_mode of s_axi_awaddr : signal is "slave S_AXI";
  attribute x_interface_parameter of s_axi_awaddr : signal is "XIL_INTERFACENAME S_AXI, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 81247969, ID_WIDTH 0, ADDR_WIDTH 13, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  attribute x_interface_info of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
  attribute x_interface_info of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  attribute x_interface_info of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
  attribute x_interface_info of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  attribute x_interface_info of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  attribute x_interface_info of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
  attribute x_interface_info of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  attribute x_interface_info of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  attribute x_interface_info of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  attribute x_interface_info of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  attribute x_interface_info of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  attribute x_interface_info of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  attribute x_interface_info of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  attribute x_interface_info of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  attribute x_interface_info of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  attribute x_interface_info of phy_tx_clk : signal is "xilinx.com:interface:mii:1.0 MII TX_CLK";
  attribute x_interface_mode of phy_tx_clk : signal is "master MII";
  attribute x_interface_parameter of phy_tx_clk : signal is "XIL_INTERFACENAME MII, BOARD.ASSOCIATED_PARAM MII_BOARD_INTERFACE";
  attribute x_interface_info of phy_rx_clk : signal is "xilinx.com:interface:mii:1.0 MII RX_CLK";
  attribute x_interface_info of phy_crs : signal is "xilinx.com:interface:mii:1.0 MII CRS";
  attribute x_interface_info of phy_dv : signal is "xilinx.com:interface:mii:1.0 MII RX_DV";
  attribute x_interface_info of phy_rx_data : signal is "xilinx.com:interface:mii:1.0 MII RXD";
  attribute x_interface_info of phy_col : signal is "xilinx.com:interface:mii:1.0 MII COL";
  attribute x_interface_info of phy_rx_er : signal is "xilinx.com:interface:mii:1.0 MII RX_ER";
  attribute x_interface_info of phy_rst_n : signal is "xilinx.com:interface:mii:1.0 MII RST_N";
  attribute x_interface_info of phy_tx_en : signal is "xilinx.com:interface:mii:1.0 MII TX_EN";
  attribute x_interface_info of phy_tx_data : signal is "xilinx.com:interface:mii:1.0 MII TXD";
  attribute x_interface_info of phy_mdio_i : signal is "xilinx.com:interface:mdio:1.0 MDIO MDIO_I";
  attribute x_interface_mode of phy_mdio_i : signal is "master MDIO";
  attribute x_interface_parameter of phy_mdio_i : signal is "XIL_INTERFACENAME MDIO, BOARD.ASSOCIATED_PARAM MDIO_BOARD_INTERFACE, CAN_DEBUG false";
  attribute x_interface_info of phy_mdio_o : signal is "xilinx.com:interface:mdio:1.0 MDIO MDIO_O";
  attribute x_interface_info of phy_mdio_t : signal is "xilinx.com:interface:mdio:1.0 MDIO MDIO_T";
  attribute x_interface_info of phy_mdc : signal is "xilinx.com:interface:mdio:1.0 MDIO MDC";
  attribute x_core_info : string;
  attribute x_core_info of stub : architecture is "axi_ethernetlite,Vivado 2025.2";
begin
end;
