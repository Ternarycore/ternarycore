//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Mon Aug  3 14:19:51 2026
//Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
//Command     : generate_target arty_ddr.bd
//Design      : arty_ddr
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "arty_ddr,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=arty_ddr,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=29,numReposBlks=21,numNonXlnxBlks=2,numHierBlks=8,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "arty_ddr.hwdef" *) 
module arty_ddr
   (DDR3_0_addr,
    DDR3_0_ba,
    DDR3_0_cas_n,
    DDR3_0_ck_n,
    DDR3_0_ck_p,
    DDR3_0_cke,
    DDR3_0_cs_n,
    DDR3_0_dm,
    DDR3_0_dq,
    DDR3_0_dqs_n,
    DDR3_0_dqs_p,
    DDR3_0_odt,
    DDR3_0_ras_n,
    DDR3_0_reset_n,
    DDR3_0_we_n,
    UART_0_baudoutn,
    UART_0_ctsn,
    UART_0_dcdn,
    UART_0_ddis,
    UART_0_dsrn,
    UART_0_dtrn,
    UART_0_out1n,
    UART_0_out2n,
    UART_0_ri,
    UART_0_rtsn,
    UART_0_rxd,
    UART_0_rxrdyn,
    UART_0_txd,
    UART_0_txrdyn,
    eth_col,
    eth_crs,
    eth_mdio_mdc,
    eth_mdio_mdio_i,
    eth_mdio_mdio_o,
    eth_mdio_mdio_t,
    eth_ref_clk,
    eth_rstn,
    eth_rx_clk,
    eth_rx_dv,
    eth_rxd,
    eth_rxerr,
    eth_tx_clk,
    eth_tx_en,
    eth_txd,
    gpio_io_o_0,
    sys_clk,
    sys_rst_n);
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 ADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DDR3_0, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) output [13:0]DDR3_0_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 BA" *) output [2:0]DDR3_0_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 CAS_N" *) output DDR3_0_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 CK_N" *) output [0:0]DDR3_0_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 CK_P" *) output [0:0]DDR3_0_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 CKE" *) output [0:0]DDR3_0_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 CS_N" *) output [0:0]DDR3_0_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 DM" *) output [1:0]DDR3_0_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 DQ" *) inout [15:0]DDR3_0_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 DQS_N" *) inout [1:0]DDR3_0_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 DQS_P" *) inout [1:0]DDR3_0_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 ODT" *) output [0:0]DDR3_0_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 RAS_N" *) output DDR3_0_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 RESET_N" *) output DDR3_0_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3_0 WE_N" *) output DDR3_0_we_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 BAUDOUTn" *) (* X_INTERFACE_MODE = "Master" *) output UART_0_baudoutn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 CTSn" *) input UART_0_ctsn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 DCDn" *) input UART_0_dcdn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 DDIS" *) output UART_0_ddis;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 DSRn" *) input UART_0_dsrn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 DTRn" *) output UART_0_dtrn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 OUT1n" *) output UART_0_out1n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 OUT2n" *) output UART_0_out2n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 RI" *) input UART_0_ri;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 RTSn" *) output UART_0_rtsn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 RxD" *) input UART_0_rxd;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 RXRDYn" *) output UART_0_rxrdyn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 TxD" *) output UART_0_txd;
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART_0 TXRDYn" *) output UART_0_txrdyn;
  input eth_col;
  input eth_crs;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 eth_mdio MDC" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME eth_mdio, CAN_DEBUG false" *) output eth_mdio_mdc;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 eth_mdio MDIO_I" *) input eth_mdio_mdio_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 eth_mdio MDIO_O" *) output eth_mdio_mdio_o;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mdio:1.0 eth_mdio MDIO_T" *) output eth_mdio_mdio_t;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ETH_REF_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ETH_REF_CLK, CLK_DOMAIN /clk_eth_clk_out1, FREQ_HZ 25003953, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output eth_ref_clk;
  output eth_rstn;
  input eth_rx_clk;
  input eth_rx_dv;
  input [3:0]eth_rxd;
  input eth_rxerr;
  input eth_tx_clk;
  output eth_tx_en;
  output [3:0]eth_txd;
  output [3:0]gpio_io_o_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SYS_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SYS_CLK, CLK_DOMAIN arty_ddr_sys_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input sys_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SYS_RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SYS_RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input sys_rst_n;

  wire [0:31]Conn1_ABUS;
  wire Conn1_ADDRSTROBE;
  wire [0:3]Conn1_BE;
  wire Conn1_CE;
  wire [0:31]Conn1_READDBUS;
  wire Conn1_READSTROBE;
  wire Conn1_READY;
  wire Conn1_UE;
  wire Conn1_WAIT;
  wire [0:31]Conn1_WRITEDBUS;
  wire Conn1_WRITESTROBE;
  wire [0:31]Conn_ABUS;
  wire Conn_ADDRSTROBE;
  wire [0:3]Conn_BE;
  wire Conn_CE;
  wire [0:31]Conn_READDBUS;
  wire Conn_READSTROBE;
  wire Conn_READY;
  wire Conn_UE;
  wire Conn_WAIT;
  wire [0:31]Conn_WRITEDBUS;
  wire Conn_WRITESTROBE;
  wire [13:0]DDR3_0_addr;
  wire [2:0]DDR3_0_ba;
  wire DDR3_0_cas_n;
  wire [0:0]DDR3_0_ck_n;
  wire [0:0]DDR3_0_ck_p;
  wire [0:0]DDR3_0_cke;
  wire [0:0]DDR3_0_cs_n;
  wire [1:0]DDR3_0_dm;
  wire [15:0]DDR3_0_dq;
  wire [1:0]DDR3_0_dqs_n;
  wire [1:0]DDR3_0_dqs_p;
  wire [0:0]DDR3_0_odt;
  wire DDR3_0_ras_n;
  wire DDR3_0_reset_n;
  wire DDR3_0_we_n;
  wire UART_0_baudoutn;
  wire UART_0_ctsn;
  wire UART_0_dcdn;
  wire UART_0_ddis;
  wire UART_0_dsrn;
  wire UART_0_dtrn;
  wire UART_0_out1n;
  wire UART_0_out2n;
  wire UART_0_ri;
  wire UART_0_rtsn;
  wire UART_0_rxd;
  wire UART_0_rxrdyn;
  wire UART_0_txd;
  wire UART_0_txrdyn;
  wire [31:0]axi_cdma_0_M_AXI_ARADDR;
  wire [1:0]axi_cdma_0_M_AXI_ARBURST;
  wire [3:0]axi_cdma_0_M_AXI_ARCACHE;
  wire [7:0]axi_cdma_0_M_AXI_ARLEN;
  wire [2:0]axi_cdma_0_M_AXI_ARPROT;
  wire axi_cdma_0_M_AXI_ARREADY;
  wire [2:0]axi_cdma_0_M_AXI_ARSIZE;
  wire axi_cdma_0_M_AXI_ARVALID;
  wire [31:0]axi_cdma_0_M_AXI_AWADDR;
  wire [1:0]axi_cdma_0_M_AXI_AWBURST;
  wire [3:0]axi_cdma_0_M_AXI_AWCACHE;
  wire [7:0]axi_cdma_0_M_AXI_AWLEN;
  wire [2:0]axi_cdma_0_M_AXI_AWPROT;
  wire axi_cdma_0_M_AXI_AWREADY;
  wire [2:0]axi_cdma_0_M_AXI_AWSIZE;
  wire axi_cdma_0_M_AXI_AWVALID;
  wire axi_cdma_0_M_AXI_BREADY;
  wire [1:0]axi_cdma_0_M_AXI_BRESP;
  wire axi_cdma_0_M_AXI_BVALID;
  wire [31:0]axi_cdma_0_M_AXI_RDATA;
  wire axi_cdma_0_M_AXI_RLAST;
  wire axi_cdma_0_M_AXI_RREADY;
  wire [1:0]axi_cdma_0_M_AXI_RRESP;
  wire axi_cdma_0_M_AXI_RVALID;
  wire [31:0]axi_cdma_0_M_AXI_WDATA;
  wire axi_cdma_0_M_AXI_WLAST;
  wire axi_cdma_0_M_AXI_WREADY;
  wire [3:0]axi_cdma_0_M_AXI_WSTRB;
  wire axi_cdma_0_M_AXI_WVALID;
  wire [13:0]axi_gemm_stream_0_w_word_addr;
  wire [27:0]axi_smc_M00_AXI_ARADDR;
  wire [1:0]axi_smc_M00_AXI_ARBURST;
  wire [3:0]axi_smc_M00_AXI_ARCACHE;
  wire [7:0]axi_smc_M00_AXI_ARLEN;
  wire [0:0]axi_smc_M00_AXI_ARLOCK;
  wire [2:0]axi_smc_M00_AXI_ARPROT;
  wire [3:0]axi_smc_M00_AXI_ARQOS;
  wire axi_smc_M00_AXI_ARREADY;
  wire [2:0]axi_smc_M00_AXI_ARSIZE;
  wire axi_smc_M00_AXI_ARVALID;
  wire [27:0]axi_smc_M00_AXI_AWADDR;
  wire [1:0]axi_smc_M00_AXI_AWBURST;
  wire [3:0]axi_smc_M00_AXI_AWCACHE;
  wire [7:0]axi_smc_M00_AXI_AWLEN;
  wire [0:0]axi_smc_M00_AXI_AWLOCK;
  wire [2:0]axi_smc_M00_AXI_AWPROT;
  wire [3:0]axi_smc_M00_AXI_AWQOS;
  wire axi_smc_M00_AXI_AWREADY;
  wire [2:0]axi_smc_M00_AXI_AWSIZE;
  wire axi_smc_M00_AXI_AWVALID;
  wire axi_smc_M00_AXI_BREADY;
  wire [1:0]axi_smc_M00_AXI_BRESP;
  wire axi_smc_M00_AXI_BVALID;
  wire [127:0]axi_smc_M00_AXI_RDATA;
  wire axi_smc_M00_AXI_RLAST;
  wire axi_smc_M00_AXI_RREADY;
  wire [1:0]axi_smc_M00_AXI_RRESP;
  wire axi_smc_M00_AXI_RVALID;
  wire [127:0]axi_smc_M00_AXI_WDATA;
  wire axi_smc_M00_AXI_WLAST;
  wire axi_smc_M00_AXI_WREADY;
  wire [15:0]axi_smc_M00_AXI_WSTRB;
  wire axi_smc_M00_AXI_WVALID;
  wire [17:0]bram_ic_M00_AXI_ARADDR;
  wire [1:0]bram_ic_M00_AXI_ARBURST;
  wire [3:0]bram_ic_M00_AXI_ARCACHE;
  wire [7:0]bram_ic_M00_AXI_ARLEN;
  wire [0:0]bram_ic_M00_AXI_ARLOCK;
  wire [2:0]bram_ic_M00_AXI_ARPROT;
  wire [3:0]bram_ic_M00_AXI_ARQOS;
  wire bram_ic_M00_AXI_ARREADY;
  wire [2:0]bram_ic_M00_AXI_ARSIZE;
  wire bram_ic_M00_AXI_ARVALID;
  wire [17:0]bram_ic_M00_AXI_AWADDR;
  wire [1:0]bram_ic_M00_AXI_AWBURST;
  wire [3:0]bram_ic_M00_AXI_AWCACHE;
  wire [7:0]bram_ic_M00_AXI_AWLEN;
  wire [0:0]bram_ic_M00_AXI_AWLOCK;
  wire [2:0]bram_ic_M00_AXI_AWPROT;
  wire [3:0]bram_ic_M00_AXI_AWQOS;
  wire bram_ic_M00_AXI_AWREADY;
  wire [2:0]bram_ic_M00_AXI_AWSIZE;
  wire bram_ic_M00_AXI_AWVALID;
  wire bram_ic_M00_AXI_BREADY;
  wire [1:0]bram_ic_M00_AXI_BRESP;
  wire bram_ic_M00_AXI_BVALID;
  wire [31:0]bram_ic_M00_AXI_RDATA;
  wire bram_ic_M00_AXI_RLAST;
  wire bram_ic_M00_AXI_RREADY;
  wire [1:0]bram_ic_M00_AXI_RRESP;
  wire bram_ic_M00_AXI_RVALID;
  wire [31:0]bram_ic_M00_AXI_WDATA;
  wire bram_ic_M00_AXI_WLAST;
  wire bram_ic_M00_AXI_WREADY;
  wire [3:0]bram_ic_M00_AXI_WSTRB;
  wire bram_ic_M00_AXI_WVALID;
  wire [31:0]cdma_ic_M00_AXI_ARADDR;
  wire [1:0]cdma_ic_M00_AXI_ARBURST;
  wire [3:0]cdma_ic_M00_AXI_ARCACHE;
  wire [2:0]cdma_ic_M00_AXI_ARID;
  wire [7:0]cdma_ic_M00_AXI_ARLEN;
  wire [0:0]cdma_ic_M00_AXI_ARLOCK;
  wire [2:0]cdma_ic_M00_AXI_ARPROT;
  wire [3:0]cdma_ic_M00_AXI_ARQOS;
  wire cdma_ic_M00_AXI_ARREADY;
  wire [2:0]cdma_ic_M00_AXI_ARSIZE;
  wire [113:0]cdma_ic_M00_AXI_ARUSER;
  wire cdma_ic_M00_AXI_ARVALID;
  wire [31:0]cdma_ic_M00_AXI_AWADDR;
  wire [1:0]cdma_ic_M00_AXI_AWBURST;
  wire [3:0]cdma_ic_M00_AXI_AWCACHE;
  wire [2:0]cdma_ic_M00_AXI_AWID;
  wire [7:0]cdma_ic_M00_AXI_AWLEN;
  wire [0:0]cdma_ic_M00_AXI_AWLOCK;
  wire [2:0]cdma_ic_M00_AXI_AWPROT;
  wire [3:0]cdma_ic_M00_AXI_AWQOS;
  wire cdma_ic_M00_AXI_AWREADY;
  wire [2:0]cdma_ic_M00_AXI_AWSIZE;
  wire [113:0]cdma_ic_M00_AXI_AWUSER;
  wire cdma_ic_M00_AXI_AWVALID;
  wire [2:0]cdma_ic_M00_AXI_BID;
  wire cdma_ic_M00_AXI_BREADY;
  wire [1:0]cdma_ic_M00_AXI_BRESP;
  wire [113:0]cdma_ic_M00_AXI_BUSER;
  wire cdma_ic_M00_AXI_BVALID;
  wire [127:0]cdma_ic_M00_AXI_RDATA;
  wire [2:0]cdma_ic_M00_AXI_RID;
  wire cdma_ic_M00_AXI_RLAST;
  wire cdma_ic_M00_AXI_RREADY;
  wire [1:0]cdma_ic_M00_AXI_RRESP;
  wire [13:0]cdma_ic_M00_AXI_RUSER;
  wire cdma_ic_M00_AXI_RVALID;
  wire [127:0]cdma_ic_M00_AXI_WDATA;
  wire cdma_ic_M00_AXI_WLAST;
  wire cdma_ic_M00_AXI_WREADY;
  wire [15:0]cdma_ic_M00_AXI_WSTRB;
  wire [13:0]cdma_ic_M00_AXI_WUSER;
  wire cdma_ic_M00_AXI_WVALID;
  wire [31:0]cdma_ic_M01_AXI_ARADDR;
  wire [1:0]cdma_ic_M01_AXI_ARBURST;
  wire [3:0]cdma_ic_M01_AXI_ARCACHE;
  wire [2:0]cdma_ic_M01_AXI_ARID;
  wire [7:0]cdma_ic_M01_AXI_ARLEN;
  wire [0:0]cdma_ic_M01_AXI_ARLOCK;
  wire [2:0]cdma_ic_M01_AXI_ARPROT;
  wire [3:0]cdma_ic_M01_AXI_ARQOS;
  wire cdma_ic_M01_AXI_ARREADY;
  wire [2:0]cdma_ic_M01_AXI_ARSIZE;
  wire [113:0]cdma_ic_M01_AXI_ARUSER;
  wire cdma_ic_M01_AXI_ARVALID;
  wire [31:0]cdma_ic_M01_AXI_AWADDR;
  wire [1:0]cdma_ic_M01_AXI_AWBURST;
  wire [3:0]cdma_ic_M01_AXI_AWCACHE;
  wire [2:0]cdma_ic_M01_AXI_AWID;
  wire [7:0]cdma_ic_M01_AXI_AWLEN;
  wire [0:0]cdma_ic_M01_AXI_AWLOCK;
  wire [2:0]cdma_ic_M01_AXI_AWPROT;
  wire [3:0]cdma_ic_M01_AXI_AWQOS;
  wire cdma_ic_M01_AXI_AWREADY;
  wire [2:0]cdma_ic_M01_AXI_AWSIZE;
  wire [113:0]cdma_ic_M01_AXI_AWUSER;
  wire cdma_ic_M01_AXI_AWVALID;
  wire [2:0]cdma_ic_M01_AXI_BID;
  wire cdma_ic_M01_AXI_BREADY;
  wire [1:0]cdma_ic_M01_AXI_BRESP;
  wire [113:0]cdma_ic_M01_AXI_BUSER;
  wire cdma_ic_M01_AXI_BVALID;
  wire [127:0]cdma_ic_M01_AXI_RDATA;
  wire [2:0]cdma_ic_M01_AXI_RID;
  wire cdma_ic_M01_AXI_RLAST;
  wire cdma_ic_M01_AXI_RREADY;
  wire [1:0]cdma_ic_M01_AXI_RRESP;
  wire [13:0]cdma_ic_M01_AXI_RUSER;
  wire cdma_ic_M01_AXI_RVALID;
  wire [127:0]cdma_ic_M01_AXI_WDATA;
  wire cdma_ic_M01_AXI_WLAST;
  wire cdma_ic_M01_AXI_WREADY;
  wire [15:0]cdma_ic_M01_AXI_WSTRB;
  wire [13:0]cdma_ic_M01_AXI_WUSER;
  wire cdma_ic_M01_AXI_WVALID;
  wire [0:31]dlmb_cntlr_BRAM_PORT_ADDR;
  wire dlmb_cntlr_BRAM_PORT_CLK;
  wire [0:31]dlmb_cntlr_BRAM_PORT_DIN;
  wire [31:0]dlmb_cntlr_BRAM_PORT_DOUT;
  wire dlmb_cntlr_BRAM_PORT_EN;
  wire dlmb_cntlr_BRAM_PORT_RST;
  wire [0:3]dlmb_cntlr_BRAM_PORT_WE;
  wire eth_col;
  wire eth_crs;
  wire eth_mdio_mdc;
  wire eth_mdio_mdio_i;
  wire eth_mdio_mdio_o;
  wire eth_mdio_mdio_t;
  wire eth_ref_clk;
  wire eth_rstn;
  wire eth_rx_clk;
  wire eth_rx_dv;
  wire [3:0]eth_rxd;
  wire eth_rxerr;
  wire eth_tx_clk;
  wire eth_tx_en;
  wire [3:0]eth_txd;
  wire [3:0]gpio_io_o_0;
  wire [0:31]ilmb_cntlr_BRAM_PORT_ADDR;
  wire ilmb_cntlr_BRAM_PORT_CLK;
  wire [0:31]ilmb_cntlr_BRAM_PORT_DIN;
  wire [31:0]ilmb_cntlr_BRAM_PORT_DOUT;
  wire ilmb_cntlr_BRAM_PORT_EN;
  wire ilmb_cntlr_BRAM_PORT_RST;
  wire [0:3]ilmb_cntlr_BRAM_PORT_WE;
  wire mdm_1_Debug_SYS_Rst;
  wire mdm_1_MBDEBUG_0_CAPTURE;
  wire mdm_1_MBDEBUG_0_CLK;
  wire mdm_1_MBDEBUG_0_DISABLE;
  wire [0:7]mdm_1_MBDEBUG_0_REG_EN;
  wire mdm_1_MBDEBUG_0_RST;
  wire mdm_1_MBDEBUG_0_SHIFT;
  wire mdm_1_MBDEBUG_0_TDI;
  wire mdm_1_MBDEBUG_0_TDO;
  wire mdm_1_MBDEBUG_0_UPDATE;
  wire [0:31]microblaze_0_DLMB_ABUS;
  wire microblaze_0_DLMB_ADDRSTROBE;
  wire [0:3]microblaze_0_DLMB_BE;
  wire microblaze_0_DLMB_CE;
  wire [0:31]microblaze_0_DLMB_READDBUS;
  wire microblaze_0_DLMB_READSTROBE;
  wire microblaze_0_DLMB_READY;
  wire microblaze_0_DLMB_UE;
  wire microblaze_0_DLMB_WAIT;
  wire [0:31]microblaze_0_DLMB_WRITEDBUS;
  wire microblaze_0_DLMB_WRITESTROBE;
  wire [0:31]microblaze_0_ILMB_ABUS;
  wire microblaze_0_ILMB_ADDRSTROBE;
  wire microblaze_0_ILMB_CE;
  wire [0:31]microblaze_0_ILMB_READDBUS;
  wire microblaze_0_ILMB_READSTROBE;
  wire microblaze_0_ILMB_READY;
  wire microblaze_0_ILMB_UE;
  wire microblaze_0_ILMB_WAIT;
  wire [31:0]microblaze_0_M_AXI_DC_ARADDR;
  wire [1:0]microblaze_0_M_AXI_DC_ARBURST;
  wire [3:0]microblaze_0_M_AXI_DC_ARCACHE;
  wire [7:0]microblaze_0_M_AXI_DC_ARLEN;
  wire microblaze_0_M_AXI_DC_ARLOCK;
  wire [2:0]microblaze_0_M_AXI_DC_ARPROT;
  wire [3:0]microblaze_0_M_AXI_DC_ARQOS;
  wire microblaze_0_M_AXI_DC_ARREADY;
  wire [2:0]microblaze_0_M_AXI_DC_ARSIZE;
  wire microblaze_0_M_AXI_DC_ARVALID;
  wire [31:0]microblaze_0_M_AXI_DC_AWADDR;
  wire [1:0]microblaze_0_M_AXI_DC_AWBURST;
  wire [3:0]microblaze_0_M_AXI_DC_AWCACHE;
  wire [7:0]microblaze_0_M_AXI_DC_AWLEN;
  wire microblaze_0_M_AXI_DC_AWLOCK;
  wire [2:0]microblaze_0_M_AXI_DC_AWPROT;
  wire [3:0]microblaze_0_M_AXI_DC_AWQOS;
  wire microblaze_0_M_AXI_DC_AWREADY;
  wire [2:0]microblaze_0_M_AXI_DC_AWSIZE;
  wire microblaze_0_M_AXI_DC_AWVALID;
  wire microblaze_0_M_AXI_DC_BREADY;
  wire [1:0]microblaze_0_M_AXI_DC_BRESP;
  wire microblaze_0_M_AXI_DC_BVALID;
  wire [31:0]microblaze_0_M_AXI_DC_RDATA;
  wire microblaze_0_M_AXI_DC_RLAST;
  wire microblaze_0_M_AXI_DC_RREADY;
  wire [1:0]microblaze_0_M_AXI_DC_RRESP;
  wire microblaze_0_M_AXI_DC_RVALID;
  wire [31:0]microblaze_0_M_AXI_DC_WDATA;
  wire microblaze_0_M_AXI_DC_WLAST;
  wire microblaze_0_M_AXI_DC_WREADY;
  wire [3:0]microblaze_0_M_AXI_DC_WSTRB;
  wire microblaze_0_M_AXI_DC_WVALID;
  wire [31:0]microblaze_0_M_AXI_DP_ARADDR;
  wire [2:0]microblaze_0_M_AXI_DP_ARPROT;
  wire [0:0]microblaze_0_M_AXI_DP_ARREADY;
  wire microblaze_0_M_AXI_DP_ARVALID;
  wire [31:0]microblaze_0_M_AXI_DP_AWADDR;
  wire [2:0]microblaze_0_M_AXI_DP_AWPROT;
  wire [0:0]microblaze_0_M_AXI_DP_AWREADY;
  wire microblaze_0_M_AXI_DP_AWVALID;
  wire microblaze_0_M_AXI_DP_BREADY;
  wire [1:0]microblaze_0_M_AXI_DP_BRESP;
  wire [0:0]microblaze_0_M_AXI_DP_BVALID;
  wire [31:0]microblaze_0_M_AXI_DP_RDATA;
  wire microblaze_0_M_AXI_DP_RREADY;
  wire [1:0]microblaze_0_M_AXI_DP_RRESP;
  wire [0:0]microblaze_0_M_AXI_DP_RVALID;
  wire [31:0]microblaze_0_M_AXI_DP_WDATA;
  wire [0:0]microblaze_0_M_AXI_DP_WREADY;
  wire [3:0]microblaze_0_M_AXI_DP_WSTRB;
  wire microblaze_0_M_AXI_DP_WVALID;
  wire [31:0]microblaze_0_M_AXI_IC_ARADDR;
  wire [1:0]microblaze_0_M_AXI_IC_ARBURST;
  wire [3:0]microblaze_0_M_AXI_IC_ARCACHE;
  wire [7:0]microblaze_0_M_AXI_IC_ARLEN;
  wire microblaze_0_M_AXI_IC_ARLOCK;
  wire [2:0]microblaze_0_M_AXI_IC_ARPROT;
  wire [3:0]microblaze_0_M_AXI_IC_ARQOS;
  wire microblaze_0_M_AXI_IC_ARREADY;
  wire [2:0]microblaze_0_M_AXI_IC_ARSIZE;
  wire microblaze_0_M_AXI_IC_ARVALID;
  wire [31:0]microblaze_0_M_AXI_IC_RDATA;
  wire microblaze_0_M_AXI_IC_RLAST;
  wire microblaze_0_M_AXI_IC_RREADY;
  wire [1:0]microblaze_0_M_AXI_IC_RRESP;
  wire microblaze_0_M_AXI_IC_RVALID;
  wire mig_7series_0_mmcm_locked;
  wire mig_7series_0_ui_addn_clk_0;
  wire mig_7series_0_ui_clk;
  wire mig_7series_0_ui_clk_sync_rst;
  wire [31:0]periph_M00_AXI_ARADDR;
  wire periph_M00_AXI_ARREADY;
  wire periph_M00_AXI_ARVALID;
  wire [31:0]periph_M00_AXI_AWADDR;
  wire periph_M00_AXI_AWREADY;
  wire periph_M00_AXI_AWVALID;
  wire periph_M00_AXI_BREADY;
  wire [1:0]periph_M00_AXI_BRESP;
  wire periph_M00_AXI_BVALID;
  wire [31:0]periph_M00_AXI_RDATA;
  wire periph_M00_AXI_RREADY;
  wire [1:0]periph_M00_AXI_RRESP;
  wire periph_M00_AXI_RVALID;
  wire [31:0]periph_M00_AXI_WDATA;
  wire periph_M00_AXI_WREADY;
  wire [3:0]periph_M00_AXI_WSTRB;
  wire periph_M00_AXI_WVALID;
  wire [31:0]periph_M01_AXI_ARADDR;
  wire periph_M01_AXI_ARREADY;
  wire periph_M01_AXI_ARVALID;
  wire [31:0]periph_M01_AXI_AWADDR;
  wire periph_M01_AXI_AWREADY;
  wire periph_M01_AXI_AWVALID;
  wire periph_M01_AXI_BREADY;
  wire [1:0]periph_M01_AXI_BRESP;
  wire periph_M01_AXI_BVALID;
  wire [31:0]periph_M01_AXI_RDATA;
  wire periph_M01_AXI_RREADY;
  wire [1:0]periph_M01_AXI_RRESP;
  wire periph_M01_AXI_RVALID;
  wire [31:0]periph_M01_AXI_WDATA;
  wire periph_M01_AXI_WREADY;
  wire [3:0]periph_M01_AXI_WSTRB;
  wire periph_M01_AXI_WVALID;
  wire [31:0]periph_M02_AXI_ARADDR;
  wire [2:0]periph_M02_AXI_ARPROT;
  wire periph_M02_AXI_ARREADY;
  wire periph_M02_AXI_ARVALID;
  wire [31:0]periph_M02_AXI_AWADDR;
  wire [2:0]periph_M02_AXI_AWPROT;
  wire periph_M02_AXI_AWREADY;
  wire periph_M02_AXI_AWVALID;
  wire periph_M02_AXI_BREADY;
  wire [1:0]periph_M02_AXI_BRESP;
  wire periph_M02_AXI_BVALID;
  wire [31:0]periph_M02_AXI_RDATA;
  wire periph_M02_AXI_RREADY;
  wire [1:0]periph_M02_AXI_RRESP;
  wire periph_M02_AXI_RVALID;
  wire [31:0]periph_M02_AXI_WDATA;
  wire periph_M02_AXI_WREADY;
  wire [3:0]periph_M02_AXI_WSTRB;
  wire periph_M02_AXI_WVALID;
  wire [31:0]periph_M03_AXI_ARADDR;
  wire [2:0]periph_M03_AXI_ARPROT;
  wire periph_M03_AXI_ARREADY;
  wire periph_M03_AXI_ARVALID;
  wire [31:0]periph_M03_AXI_AWADDR;
  wire [2:0]periph_M03_AXI_AWPROT;
  wire periph_M03_AXI_AWREADY;
  wire periph_M03_AXI_AWVALID;
  wire periph_M03_AXI_BREADY;
  wire [1:0]periph_M03_AXI_BRESP;
  wire periph_M03_AXI_BVALID;
  wire [31:0]periph_M03_AXI_RDATA;
  wire periph_M03_AXI_RREADY;
  wire [1:0]periph_M03_AXI_RRESP;
  wire periph_M03_AXI_RVALID;
  wire [31:0]periph_M03_AXI_WDATA;
  wire periph_M03_AXI_WREADY;
  wire [3:0]periph_M03_AXI_WSTRB;
  wire periph_M03_AXI_WVALID;
  wire [31:0]periph_M04_AXI_ARADDR;
  wire periph_M04_AXI_ARREADY;
  wire periph_M04_AXI_ARVALID;
  wire [31:0]periph_M04_AXI_AWADDR;
  wire periph_M04_AXI_AWREADY;
  wire periph_M04_AXI_AWVALID;
  wire periph_M04_AXI_BREADY;
  wire [1:0]periph_M04_AXI_BRESP;
  wire periph_M04_AXI_BVALID;
  wire [31:0]periph_M04_AXI_RDATA;
  wire periph_M04_AXI_RREADY;
  wire [1:0]periph_M04_AXI_RRESP;
  wire periph_M04_AXI_RVALID;
  wire [31:0]periph_M04_AXI_WDATA;
  wire periph_M04_AXI_WREADY;
  wire periph_M04_AXI_WVALID;
  wire [31:0]periph_M05_AXI_ARADDR;
  wire periph_M05_AXI_ARREADY;
  wire periph_M05_AXI_ARVALID;
  wire [31:0]periph_M05_AXI_AWADDR;
  wire periph_M05_AXI_AWREADY;
  wire periph_M05_AXI_AWVALID;
  wire periph_M05_AXI_BREADY;
  wire [1:0]periph_M05_AXI_BRESP;
  wire periph_M05_AXI_BVALID;
  wire [31:0]periph_M05_AXI_RDATA;
  wire periph_M05_AXI_RREADY;
  wire [1:0]periph_M05_AXI_RRESP;
  wire periph_M05_AXI_RVALID;
  wire [31:0]periph_M05_AXI_WDATA;
  wire periph_M05_AXI_WREADY;
  wire [3:0]periph_M05_AXI_WSTRB;
  wire periph_M05_AXI_WVALID;
  wire [0:0]rst_inv_Res;
  wire [0:0]rst_ui_bus_struct_reset;
  wire rst_ui_mb_reset;
  wire [0:0]rst_ui_peripheral_aresetn;
  wire sys_clk;
  wire sys_rst_n;
  wire [127:0]weight_bram_0_w_word;

  arty_ddr_axi_cdma_0_0 axi_cdma_0
       (.m_axi_aclk(mig_7series_0_ui_clk),
        .m_axi_araddr(axi_cdma_0_M_AXI_ARADDR),
        .m_axi_arburst(axi_cdma_0_M_AXI_ARBURST),
        .m_axi_arcache(axi_cdma_0_M_AXI_ARCACHE),
        .m_axi_arlen(axi_cdma_0_M_AXI_ARLEN),
        .m_axi_arprot(axi_cdma_0_M_AXI_ARPROT),
        .m_axi_arready(axi_cdma_0_M_AXI_ARREADY),
        .m_axi_arsize(axi_cdma_0_M_AXI_ARSIZE),
        .m_axi_arvalid(axi_cdma_0_M_AXI_ARVALID),
        .m_axi_awaddr(axi_cdma_0_M_AXI_AWADDR),
        .m_axi_awburst(axi_cdma_0_M_AXI_AWBURST),
        .m_axi_awcache(axi_cdma_0_M_AXI_AWCACHE),
        .m_axi_awlen(axi_cdma_0_M_AXI_AWLEN),
        .m_axi_awprot(axi_cdma_0_M_AXI_AWPROT),
        .m_axi_awready(axi_cdma_0_M_AXI_AWREADY),
        .m_axi_awsize(axi_cdma_0_M_AXI_AWSIZE),
        .m_axi_awvalid(axi_cdma_0_M_AXI_AWVALID),
        .m_axi_bready(axi_cdma_0_M_AXI_BREADY),
        .m_axi_bresp(axi_cdma_0_M_AXI_BRESP),
        .m_axi_bvalid(axi_cdma_0_M_AXI_BVALID),
        .m_axi_rdata(axi_cdma_0_M_AXI_RDATA),
        .m_axi_rlast(axi_cdma_0_M_AXI_RLAST),
        .m_axi_rready(axi_cdma_0_M_AXI_RREADY),
        .m_axi_rresp(axi_cdma_0_M_AXI_RRESP),
        .m_axi_rvalid(axi_cdma_0_M_AXI_RVALID),
        .m_axi_wdata(axi_cdma_0_M_AXI_WDATA),
        .m_axi_wlast(axi_cdma_0_M_AXI_WLAST),
        .m_axi_wready(axi_cdma_0_M_AXI_WREADY),
        .m_axi_wstrb(axi_cdma_0_M_AXI_WSTRB),
        .m_axi_wvalid(axi_cdma_0_M_AXI_WVALID),
        .s_axi_lite_aclk(mig_7series_0_ui_clk),
        .s_axi_lite_araddr(periph_M04_AXI_ARADDR[5:0]),
        .s_axi_lite_aresetn(rst_ui_peripheral_aresetn),
        .s_axi_lite_arready(periph_M04_AXI_ARREADY),
        .s_axi_lite_arvalid(periph_M04_AXI_ARVALID),
        .s_axi_lite_awaddr(periph_M04_AXI_AWADDR[5:0]),
        .s_axi_lite_awready(periph_M04_AXI_AWREADY),
        .s_axi_lite_awvalid(periph_M04_AXI_AWVALID),
        .s_axi_lite_bready(periph_M04_AXI_BREADY),
        .s_axi_lite_bresp(periph_M04_AXI_BRESP),
        .s_axi_lite_bvalid(periph_M04_AXI_BVALID),
        .s_axi_lite_rdata(periph_M04_AXI_RDATA),
        .s_axi_lite_rready(periph_M04_AXI_RREADY),
        .s_axi_lite_rresp(periph_M04_AXI_RRESP),
        .s_axi_lite_rvalid(periph_M04_AXI_RVALID),
        .s_axi_lite_wdata(periph_M04_AXI_WDATA),
        .s_axi_lite_wready(periph_M04_AXI_WREADY),
        .s_axi_lite_wvalid(periph_M04_AXI_WVALID));
  arty_ddr_axi_ethernetlite_0_0 axi_ethernetlite_0
       (.phy_col(eth_col),
        .phy_crs(eth_crs),
        .phy_dv(eth_rx_dv),
        .phy_mdc(eth_mdio_mdc),
        .phy_mdio_i(eth_mdio_mdio_i),
        .phy_mdio_o(eth_mdio_mdio_o),
        .phy_mdio_t(eth_mdio_mdio_t),
        .phy_rst_n(eth_rstn),
        .phy_rx_clk(eth_rx_clk),
        .phy_rx_data(eth_rxd),
        .phy_rx_er(eth_rxerr),
        .phy_tx_clk(eth_tx_clk),
        .phy_tx_data(eth_txd),
        .phy_tx_en(eth_tx_en),
        .s_axi_aclk(mig_7series_0_ui_clk),
        .s_axi_araddr(periph_M05_AXI_ARADDR[12:0]),
        .s_axi_aresetn(rst_ui_peripheral_aresetn),
        .s_axi_arready(periph_M05_AXI_ARREADY),
        .s_axi_arvalid(periph_M05_AXI_ARVALID),
        .s_axi_awaddr(periph_M05_AXI_AWADDR[12:0]),
        .s_axi_awready(periph_M05_AXI_AWREADY),
        .s_axi_awvalid(periph_M05_AXI_AWVALID),
        .s_axi_bready(periph_M05_AXI_BREADY),
        .s_axi_bresp(periph_M05_AXI_BRESP),
        .s_axi_bvalid(periph_M05_AXI_BVALID),
        .s_axi_rdata(periph_M05_AXI_RDATA),
        .s_axi_rready(periph_M05_AXI_RREADY),
        .s_axi_rresp(periph_M05_AXI_RRESP),
        .s_axi_rvalid(periph_M05_AXI_RVALID),
        .s_axi_wdata(periph_M05_AXI_WDATA),
        .s_axi_wready(periph_M05_AXI_WREADY),
        .s_axi_wstrb(periph_M05_AXI_WSTRB),
        .s_axi_wvalid(periph_M05_AXI_WVALID));
  arty_ddr_axi_gemm_stream_0_0 axi_gemm_stream_0
       (.clk(mig_7series_0_ui_clk),
        .rst_n(rst_ui_peripheral_aresetn),
        .s_axi_araddr(periph_M03_AXI_ARADDR[7:0]),
        .s_axi_arprot(periph_M03_AXI_ARPROT),
        .s_axi_arready(periph_M03_AXI_ARREADY),
        .s_axi_arvalid(periph_M03_AXI_ARVALID),
        .s_axi_awaddr(periph_M03_AXI_AWADDR[7:0]),
        .s_axi_awprot(periph_M03_AXI_AWPROT),
        .s_axi_awready(periph_M03_AXI_AWREADY),
        .s_axi_awvalid(periph_M03_AXI_AWVALID),
        .s_axi_bready(periph_M03_AXI_BREADY),
        .s_axi_bresp(periph_M03_AXI_BRESP),
        .s_axi_bvalid(periph_M03_AXI_BVALID),
        .s_axi_rdata(periph_M03_AXI_RDATA),
        .s_axi_rready(periph_M03_AXI_RREADY),
        .s_axi_rresp(periph_M03_AXI_RRESP),
        .s_axi_rvalid(periph_M03_AXI_RVALID),
        .s_axi_wdata(periph_M03_AXI_WDATA),
        .s_axi_wready(periph_M03_AXI_WREADY),
        .s_axi_wstrb(periph_M03_AXI_WSTRB),
        .s_axi_wvalid(periph_M03_AXI_WVALID),
        .w_word(weight_bram_0_w_word),
        .w_word_addr(axi_gemm_stream_0_w_word_addr));
  arty_ddr_axi_gpio_0_0 axi_gpio_0
       (.gpio_io_o(gpio_io_o_0),
        .s_axi_aclk(mig_7series_0_ui_clk),
        .s_axi_araddr(periph_M01_AXI_ARADDR[8:0]),
        .s_axi_aresetn(rst_ui_peripheral_aresetn),
        .s_axi_arready(periph_M01_AXI_ARREADY),
        .s_axi_arvalid(periph_M01_AXI_ARVALID),
        .s_axi_awaddr(periph_M01_AXI_AWADDR[8:0]),
        .s_axi_awready(periph_M01_AXI_AWREADY),
        .s_axi_awvalid(periph_M01_AXI_AWVALID),
        .s_axi_bready(periph_M01_AXI_BREADY),
        .s_axi_bresp(periph_M01_AXI_BRESP),
        .s_axi_bvalid(periph_M01_AXI_BVALID),
        .s_axi_rdata(periph_M01_AXI_RDATA),
        .s_axi_rready(periph_M01_AXI_RREADY),
        .s_axi_rresp(periph_M01_AXI_RRESP),
        .s_axi_rvalid(periph_M01_AXI_RVALID),
        .s_axi_wdata(periph_M01_AXI_WDATA),
        .s_axi_wready(periph_M01_AXI_WREADY),
        .s_axi_wstrb(periph_M01_AXI_WSTRB),
        .s_axi_wvalid(periph_M01_AXI_WVALID));
  arty_ddr_axi_smc_0 axi_smc
       (.M00_AXI_araddr(axi_smc_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_smc_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_smc_M00_AXI_ARCACHE),
        .M00_AXI_arlen(axi_smc_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_smc_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_smc_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_smc_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_smc_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_smc_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(axi_smc_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_smc_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_smc_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_smc_M00_AXI_AWCACHE),
        .M00_AXI_awlen(axi_smc_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_smc_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_smc_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_smc_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_smc_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_smc_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(axi_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_smc_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_smc_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_smc_M00_AXI_RDATA),
        .M00_AXI_rlast(axi_smc_M00_AXI_RLAST),
        .M00_AXI_rready(axi_smc_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_smc_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_smc_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_smc_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_smc_M00_AXI_WLAST),
        .M00_AXI_wready(axi_smc_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_smc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_smc_M00_AXI_WVALID),
        .S00_AXI_araddr(microblaze_0_M_AXI_IC_ARADDR),
        .S00_AXI_arburst(microblaze_0_M_AXI_IC_ARBURST),
        .S00_AXI_arcache(microblaze_0_M_AXI_IC_ARCACHE),
        .S00_AXI_arlen(microblaze_0_M_AXI_IC_ARLEN),
        .S00_AXI_arlock(microblaze_0_M_AXI_IC_ARLOCK),
        .S00_AXI_arprot(microblaze_0_M_AXI_IC_ARPROT),
        .S00_AXI_arqos(microblaze_0_M_AXI_IC_ARQOS),
        .S00_AXI_arready(microblaze_0_M_AXI_IC_ARREADY),
        .S00_AXI_arsize(microblaze_0_M_AXI_IC_ARSIZE),
        .S00_AXI_arvalid(microblaze_0_M_AXI_IC_ARVALID),
        .S00_AXI_rdata(microblaze_0_M_AXI_IC_RDATA),
        .S00_AXI_rlast(microblaze_0_M_AXI_IC_RLAST),
        .S00_AXI_rready(microblaze_0_M_AXI_IC_RREADY),
        .S00_AXI_rresp(microblaze_0_M_AXI_IC_RRESP),
        .S00_AXI_rvalid(microblaze_0_M_AXI_IC_RVALID),
        .S01_AXI_araddr(microblaze_0_M_AXI_DC_ARADDR),
        .S01_AXI_arburst(microblaze_0_M_AXI_DC_ARBURST),
        .S01_AXI_arcache(microblaze_0_M_AXI_DC_ARCACHE),
        .S01_AXI_arlen(microblaze_0_M_AXI_DC_ARLEN),
        .S01_AXI_arlock(microblaze_0_M_AXI_DC_ARLOCK),
        .S01_AXI_arprot(microblaze_0_M_AXI_DC_ARPROT),
        .S01_AXI_arqos(microblaze_0_M_AXI_DC_ARQOS),
        .S01_AXI_arready(microblaze_0_M_AXI_DC_ARREADY),
        .S01_AXI_arsize(microblaze_0_M_AXI_DC_ARSIZE),
        .S01_AXI_arvalid(microblaze_0_M_AXI_DC_ARVALID),
        .S01_AXI_awaddr(microblaze_0_M_AXI_DC_AWADDR),
        .S01_AXI_awburst(microblaze_0_M_AXI_DC_AWBURST),
        .S01_AXI_awcache(microblaze_0_M_AXI_DC_AWCACHE),
        .S01_AXI_awlen(microblaze_0_M_AXI_DC_AWLEN),
        .S01_AXI_awlock(microblaze_0_M_AXI_DC_AWLOCK),
        .S01_AXI_awprot(microblaze_0_M_AXI_DC_AWPROT),
        .S01_AXI_awqos(microblaze_0_M_AXI_DC_AWQOS),
        .S01_AXI_awready(microblaze_0_M_AXI_DC_AWREADY),
        .S01_AXI_awsize(microblaze_0_M_AXI_DC_AWSIZE),
        .S01_AXI_awvalid(microblaze_0_M_AXI_DC_AWVALID),
        .S01_AXI_bready(microblaze_0_M_AXI_DC_BREADY),
        .S01_AXI_bresp(microblaze_0_M_AXI_DC_BRESP),
        .S01_AXI_bvalid(microblaze_0_M_AXI_DC_BVALID),
        .S01_AXI_rdata(microblaze_0_M_AXI_DC_RDATA),
        .S01_AXI_rlast(microblaze_0_M_AXI_DC_RLAST),
        .S01_AXI_rready(microblaze_0_M_AXI_DC_RREADY),
        .S01_AXI_rresp(microblaze_0_M_AXI_DC_RRESP),
        .S01_AXI_rvalid(microblaze_0_M_AXI_DC_RVALID),
        .S01_AXI_wdata(microblaze_0_M_AXI_DC_WDATA),
        .S01_AXI_wlast(microblaze_0_M_AXI_DC_WLAST),
        .S01_AXI_wready(microblaze_0_M_AXI_DC_WREADY),
        .S01_AXI_wstrb(microblaze_0_M_AXI_DC_WSTRB),
        .S01_AXI_wvalid(microblaze_0_M_AXI_DC_WVALID),
        .S02_AXI_araddr(cdma_ic_M00_AXI_ARADDR),
        .S02_AXI_arburst(cdma_ic_M00_AXI_ARBURST),
        .S02_AXI_arcache(cdma_ic_M00_AXI_ARCACHE),
        .S02_AXI_arid(cdma_ic_M00_AXI_ARID),
        .S02_AXI_arlen(cdma_ic_M00_AXI_ARLEN),
        .S02_AXI_arlock(cdma_ic_M00_AXI_ARLOCK),
        .S02_AXI_arprot(cdma_ic_M00_AXI_ARPROT),
        .S02_AXI_arqos(cdma_ic_M00_AXI_ARQOS),
        .S02_AXI_arready(cdma_ic_M00_AXI_ARREADY),
        .S02_AXI_arsize(cdma_ic_M00_AXI_ARSIZE),
        .S02_AXI_aruser(cdma_ic_M00_AXI_ARUSER),
        .S02_AXI_arvalid(cdma_ic_M00_AXI_ARVALID),
        .S02_AXI_awaddr(cdma_ic_M00_AXI_AWADDR),
        .S02_AXI_awburst(cdma_ic_M00_AXI_AWBURST),
        .S02_AXI_awcache(cdma_ic_M00_AXI_AWCACHE),
        .S02_AXI_awid(cdma_ic_M00_AXI_AWID),
        .S02_AXI_awlen(cdma_ic_M00_AXI_AWLEN),
        .S02_AXI_awlock(cdma_ic_M00_AXI_AWLOCK),
        .S02_AXI_awprot(cdma_ic_M00_AXI_AWPROT),
        .S02_AXI_awqos(cdma_ic_M00_AXI_AWQOS),
        .S02_AXI_awready(cdma_ic_M00_AXI_AWREADY),
        .S02_AXI_awsize(cdma_ic_M00_AXI_AWSIZE),
        .S02_AXI_awuser(cdma_ic_M00_AXI_AWUSER),
        .S02_AXI_awvalid(cdma_ic_M00_AXI_AWVALID),
        .S02_AXI_bid(cdma_ic_M00_AXI_BID),
        .S02_AXI_bready(cdma_ic_M00_AXI_BREADY),
        .S02_AXI_bresp(cdma_ic_M00_AXI_BRESP),
        .S02_AXI_buser(cdma_ic_M00_AXI_BUSER),
        .S02_AXI_bvalid(cdma_ic_M00_AXI_BVALID),
        .S02_AXI_rdata(cdma_ic_M00_AXI_RDATA),
        .S02_AXI_rid(cdma_ic_M00_AXI_RID),
        .S02_AXI_rlast(cdma_ic_M00_AXI_RLAST),
        .S02_AXI_rready(cdma_ic_M00_AXI_RREADY),
        .S02_AXI_rresp(cdma_ic_M00_AXI_RRESP),
        .S02_AXI_ruser(cdma_ic_M00_AXI_RUSER),
        .S02_AXI_rvalid(cdma_ic_M00_AXI_RVALID),
        .S02_AXI_wdata(cdma_ic_M00_AXI_WDATA),
        .S02_AXI_wlast(cdma_ic_M00_AXI_WLAST),
        .S02_AXI_wready(cdma_ic_M00_AXI_WREADY),
        .S02_AXI_wstrb(cdma_ic_M00_AXI_WSTRB),
        .S02_AXI_wuser(cdma_ic_M00_AXI_WUSER),
        .S02_AXI_wvalid(cdma_ic_M00_AXI_WVALID),
        .aclk(mig_7series_0_ui_clk),
        .aresetn(rst_ui_peripheral_aresetn));
  arty_ddr_axi_uart16550_0_0 axi_uart16550_0
       (.baudoutn(UART_0_baudoutn),
        .ctsn(UART_0_ctsn),
        .dcdn(UART_0_dcdn),
        .ddis(UART_0_ddis),
        .dsrn(UART_0_dsrn),
        .dtrn(UART_0_dtrn),
        .freeze(1'b0),
        .out1n(UART_0_out1n),
        .out2n(UART_0_out2n),
        .rin(UART_0_ri),
        .rtsn(UART_0_rtsn),
        .rxrdyn(UART_0_rxrdyn),
        .s_axi_aclk(mig_7series_0_ui_clk),
        .s_axi_araddr(periph_M00_AXI_ARADDR[12:0]),
        .s_axi_aresetn(rst_ui_peripheral_aresetn),
        .s_axi_arready(periph_M00_AXI_ARREADY),
        .s_axi_arvalid(periph_M00_AXI_ARVALID),
        .s_axi_awaddr(periph_M00_AXI_AWADDR[12:0]),
        .s_axi_awready(periph_M00_AXI_AWREADY),
        .s_axi_awvalid(periph_M00_AXI_AWVALID),
        .s_axi_bready(periph_M00_AXI_BREADY),
        .s_axi_bresp(periph_M00_AXI_BRESP),
        .s_axi_bvalid(periph_M00_AXI_BVALID),
        .s_axi_rdata(periph_M00_AXI_RDATA),
        .s_axi_rready(periph_M00_AXI_RREADY),
        .s_axi_rresp(periph_M00_AXI_RRESP),
        .s_axi_rvalid(periph_M00_AXI_RVALID),
        .s_axi_wdata(periph_M00_AXI_WDATA),
        .s_axi_wready(periph_M00_AXI_WREADY),
        .s_axi_wstrb(periph_M00_AXI_WSTRB),
        .s_axi_wvalid(periph_M00_AXI_WVALID),
        .sin(UART_0_rxd),
        .sout(UART_0_txd),
        .txrdyn(UART_0_txrdyn));
  arty_ddr_bram_ic_0 bram_ic
       (.M00_AXI_araddr(bram_ic_M00_AXI_ARADDR),
        .M00_AXI_arburst(bram_ic_M00_AXI_ARBURST),
        .M00_AXI_arcache(bram_ic_M00_AXI_ARCACHE),
        .M00_AXI_arlen(bram_ic_M00_AXI_ARLEN),
        .M00_AXI_arlock(bram_ic_M00_AXI_ARLOCK),
        .M00_AXI_arprot(bram_ic_M00_AXI_ARPROT),
        .M00_AXI_arqos(bram_ic_M00_AXI_ARQOS),
        .M00_AXI_arready(bram_ic_M00_AXI_ARREADY),
        .M00_AXI_arsize(bram_ic_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(bram_ic_M00_AXI_ARVALID),
        .M00_AXI_awaddr(bram_ic_M00_AXI_AWADDR),
        .M00_AXI_awburst(bram_ic_M00_AXI_AWBURST),
        .M00_AXI_awcache(bram_ic_M00_AXI_AWCACHE),
        .M00_AXI_awlen(bram_ic_M00_AXI_AWLEN),
        .M00_AXI_awlock(bram_ic_M00_AXI_AWLOCK),
        .M00_AXI_awprot(bram_ic_M00_AXI_AWPROT),
        .M00_AXI_awqos(bram_ic_M00_AXI_AWQOS),
        .M00_AXI_awready(bram_ic_M00_AXI_AWREADY),
        .M00_AXI_awsize(bram_ic_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(bram_ic_M00_AXI_AWVALID),
        .M00_AXI_bready(bram_ic_M00_AXI_BREADY),
        .M00_AXI_bresp(bram_ic_M00_AXI_BRESP),
        .M00_AXI_bvalid(bram_ic_M00_AXI_BVALID),
        .M00_AXI_rdata(bram_ic_M00_AXI_RDATA),
        .M00_AXI_rlast(bram_ic_M00_AXI_RLAST),
        .M00_AXI_rready(bram_ic_M00_AXI_RREADY),
        .M00_AXI_rresp(bram_ic_M00_AXI_RRESP),
        .M00_AXI_rvalid(bram_ic_M00_AXI_RVALID),
        .M00_AXI_wdata(bram_ic_M00_AXI_WDATA),
        .M00_AXI_wlast(bram_ic_M00_AXI_WLAST),
        .M00_AXI_wready(bram_ic_M00_AXI_WREADY),
        .M00_AXI_wstrb(bram_ic_M00_AXI_WSTRB),
        .M00_AXI_wvalid(bram_ic_M00_AXI_WVALID),
        .S00_AXI_araddr(periph_M02_AXI_ARADDR),
        .S00_AXI_arprot(periph_M02_AXI_ARPROT),
        .S00_AXI_arready(periph_M02_AXI_ARREADY),
        .S00_AXI_arvalid(periph_M02_AXI_ARVALID),
        .S00_AXI_awaddr(periph_M02_AXI_AWADDR),
        .S00_AXI_awprot(periph_M02_AXI_AWPROT),
        .S00_AXI_awready(periph_M02_AXI_AWREADY),
        .S00_AXI_awvalid(periph_M02_AXI_AWVALID),
        .S00_AXI_bready(periph_M02_AXI_BREADY),
        .S00_AXI_bresp(periph_M02_AXI_BRESP),
        .S00_AXI_bvalid(periph_M02_AXI_BVALID),
        .S00_AXI_rdata(periph_M02_AXI_RDATA),
        .S00_AXI_rready(periph_M02_AXI_RREADY),
        .S00_AXI_rresp(periph_M02_AXI_RRESP),
        .S00_AXI_rvalid(periph_M02_AXI_RVALID),
        .S00_AXI_wdata(periph_M02_AXI_WDATA),
        .S00_AXI_wready(periph_M02_AXI_WREADY),
        .S00_AXI_wstrb(periph_M02_AXI_WSTRB),
        .S00_AXI_wvalid(periph_M02_AXI_WVALID),
        .S01_AXI_araddr(cdma_ic_M01_AXI_ARADDR),
        .S01_AXI_arburst(cdma_ic_M01_AXI_ARBURST),
        .S01_AXI_arcache(cdma_ic_M01_AXI_ARCACHE),
        .S01_AXI_arid(cdma_ic_M01_AXI_ARID),
        .S01_AXI_arlen(cdma_ic_M01_AXI_ARLEN),
        .S01_AXI_arlock(cdma_ic_M01_AXI_ARLOCK),
        .S01_AXI_arprot(cdma_ic_M01_AXI_ARPROT),
        .S01_AXI_arqos(cdma_ic_M01_AXI_ARQOS),
        .S01_AXI_arready(cdma_ic_M01_AXI_ARREADY),
        .S01_AXI_arsize(cdma_ic_M01_AXI_ARSIZE),
        .S01_AXI_aruser(cdma_ic_M01_AXI_ARUSER),
        .S01_AXI_arvalid(cdma_ic_M01_AXI_ARVALID),
        .S01_AXI_awaddr(cdma_ic_M01_AXI_AWADDR),
        .S01_AXI_awburst(cdma_ic_M01_AXI_AWBURST),
        .S01_AXI_awcache(cdma_ic_M01_AXI_AWCACHE),
        .S01_AXI_awid(cdma_ic_M01_AXI_AWID),
        .S01_AXI_awlen(cdma_ic_M01_AXI_AWLEN),
        .S01_AXI_awlock(cdma_ic_M01_AXI_AWLOCK),
        .S01_AXI_awprot(cdma_ic_M01_AXI_AWPROT),
        .S01_AXI_awqos(cdma_ic_M01_AXI_AWQOS),
        .S01_AXI_awready(cdma_ic_M01_AXI_AWREADY),
        .S01_AXI_awsize(cdma_ic_M01_AXI_AWSIZE),
        .S01_AXI_awuser(cdma_ic_M01_AXI_AWUSER),
        .S01_AXI_awvalid(cdma_ic_M01_AXI_AWVALID),
        .S01_AXI_bid(cdma_ic_M01_AXI_BID),
        .S01_AXI_bready(cdma_ic_M01_AXI_BREADY),
        .S01_AXI_bresp(cdma_ic_M01_AXI_BRESP),
        .S01_AXI_buser(cdma_ic_M01_AXI_BUSER),
        .S01_AXI_bvalid(cdma_ic_M01_AXI_BVALID),
        .S01_AXI_rdata(cdma_ic_M01_AXI_RDATA),
        .S01_AXI_rid(cdma_ic_M01_AXI_RID),
        .S01_AXI_rlast(cdma_ic_M01_AXI_RLAST),
        .S01_AXI_rready(cdma_ic_M01_AXI_RREADY),
        .S01_AXI_rresp(cdma_ic_M01_AXI_RRESP),
        .S01_AXI_ruser(cdma_ic_M01_AXI_RUSER),
        .S01_AXI_rvalid(cdma_ic_M01_AXI_RVALID),
        .S01_AXI_wdata(cdma_ic_M01_AXI_WDATA),
        .S01_AXI_wlast(cdma_ic_M01_AXI_WLAST),
        .S01_AXI_wready(cdma_ic_M01_AXI_WREADY),
        .S01_AXI_wstrb(cdma_ic_M01_AXI_WSTRB),
        .S01_AXI_wuser(cdma_ic_M01_AXI_WUSER),
        .S01_AXI_wvalid(cdma_ic_M01_AXI_WVALID),
        .aclk(mig_7series_0_ui_clk),
        .aresetn(rst_ui_peripheral_aresetn));
  arty_ddr_cdma_ic_0 cdma_ic
       (.M00_AXI_araddr(cdma_ic_M00_AXI_ARADDR),
        .M00_AXI_arburst(cdma_ic_M00_AXI_ARBURST),
        .M00_AXI_arcache(cdma_ic_M00_AXI_ARCACHE),
        .M00_AXI_arid(cdma_ic_M00_AXI_ARID),
        .M00_AXI_arlen(cdma_ic_M00_AXI_ARLEN),
        .M00_AXI_arlock(cdma_ic_M00_AXI_ARLOCK),
        .M00_AXI_arprot(cdma_ic_M00_AXI_ARPROT),
        .M00_AXI_arqos(cdma_ic_M00_AXI_ARQOS),
        .M00_AXI_arready(cdma_ic_M00_AXI_ARREADY),
        .M00_AXI_arsize(cdma_ic_M00_AXI_ARSIZE),
        .M00_AXI_aruser(cdma_ic_M00_AXI_ARUSER),
        .M00_AXI_arvalid(cdma_ic_M00_AXI_ARVALID),
        .M00_AXI_awaddr(cdma_ic_M00_AXI_AWADDR),
        .M00_AXI_awburst(cdma_ic_M00_AXI_AWBURST),
        .M00_AXI_awcache(cdma_ic_M00_AXI_AWCACHE),
        .M00_AXI_awid(cdma_ic_M00_AXI_AWID),
        .M00_AXI_awlen(cdma_ic_M00_AXI_AWLEN),
        .M00_AXI_awlock(cdma_ic_M00_AXI_AWLOCK),
        .M00_AXI_awprot(cdma_ic_M00_AXI_AWPROT),
        .M00_AXI_awqos(cdma_ic_M00_AXI_AWQOS),
        .M00_AXI_awready(cdma_ic_M00_AXI_AWREADY),
        .M00_AXI_awsize(cdma_ic_M00_AXI_AWSIZE),
        .M00_AXI_awuser(cdma_ic_M00_AXI_AWUSER),
        .M00_AXI_awvalid(cdma_ic_M00_AXI_AWVALID),
        .M00_AXI_bid(cdma_ic_M00_AXI_BID),
        .M00_AXI_bready(cdma_ic_M00_AXI_BREADY),
        .M00_AXI_bresp(cdma_ic_M00_AXI_BRESP),
        .M00_AXI_buser(cdma_ic_M00_AXI_BUSER),
        .M00_AXI_bvalid(cdma_ic_M00_AXI_BVALID),
        .M00_AXI_rdata(cdma_ic_M00_AXI_RDATA),
        .M00_AXI_rid(cdma_ic_M00_AXI_RID),
        .M00_AXI_rlast(cdma_ic_M00_AXI_RLAST),
        .M00_AXI_rready(cdma_ic_M00_AXI_RREADY),
        .M00_AXI_rresp(cdma_ic_M00_AXI_RRESP),
        .M00_AXI_ruser(cdma_ic_M00_AXI_RUSER),
        .M00_AXI_rvalid(cdma_ic_M00_AXI_RVALID),
        .M00_AXI_wdata(cdma_ic_M00_AXI_WDATA),
        .M00_AXI_wlast(cdma_ic_M00_AXI_WLAST),
        .M00_AXI_wready(cdma_ic_M00_AXI_WREADY),
        .M00_AXI_wstrb(cdma_ic_M00_AXI_WSTRB),
        .M00_AXI_wuser(cdma_ic_M00_AXI_WUSER),
        .M00_AXI_wvalid(cdma_ic_M00_AXI_WVALID),
        .M01_AXI_araddr(cdma_ic_M01_AXI_ARADDR),
        .M01_AXI_arburst(cdma_ic_M01_AXI_ARBURST),
        .M01_AXI_arcache(cdma_ic_M01_AXI_ARCACHE),
        .M01_AXI_arid(cdma_ic_M01_AXI_ARID),
        .M01_AXI_arlen(cdma_ic_M01_AXI_ARLEN),
        .M01_AXI_arlock(cdma_ic_M01_AXI_ARLOCK),
        .M01_AXI_arprot(cdma_ic_M01_AXI_ARPROT),
        .M01_AXI_arqos(cdma_ic_M01_AXI_ARQOS),
        .M01_AXI_arready(cdma_ic_M01_AXI_ARREADY),
        .M01_AXI_arsize(cdma_ic_M01_AXI_ARSIZE),
        .M01_AXI_aruser(cdma_ic_M01_AXI_ARUSER),
        .M01_AXI_arvalid(cdma_ic_M01_AXI_ARVALID),
        .M01_AXI_awaddr(cdma_ic_M01_AXI_AWADDR),
        .M01_AXI_awburst(cdma_ic_M01_AXI_AWBURST),
        .M01_AXI_awcache(cdma_ic_M01_AXI_AWCACHE),
        .M01_AXI_awid(cdma_ic_M01_AXI_AWID),
        .M01_AXI_awlen(cdma_ic_M01_AXI_AWLEN),
        .M01_AXI_awlock(cdma_ic_M01_AXI_AWLOCK),
        .M01_AXI_awprot(cdma_ic_M01_AXI_AWPROT),
        .M01_AXI_awqos(cdma_ic_M01_AXI_AWQOS),
        .M01_AXI_awready(cdma_ic_M01_AXI_AWREADY),
        .M01_AXI_awsize(cdma_ic_M01_AXI_AWSIZE),
        .M01_AXI_awuser(cdma_ic_M01_AXI_AWUSER),
        .M01_AXI_awvalid(cdma_ic_M01_AXI_AWVALID),
        .M01_AXI_bid(cdma_ic_M01_AXI_BID),
        .M01_AXI_bready(cdma_ic_M01_AXI_BREADY),
        .M01_AXI_bresp(cdma_ic_M01_AXI_BRESP),
        .M01_AXI_buser(cdma_ic_M01_AXI_BUSER),
        .M01_AXI_bvalid(cdma_ic_M01_AXI_BVALID),
        .M01_AXI_rdata(cdma_ic_M01_AXI_RDATA),
        .M01_AXI_rid(cdma_ic_M01_AXI_RID),
        .M01_AXI_rlast(cdma_ic_M01_AXI_RLAST),
        .M01_AXI_rready(cdma_ic_M01_AXI_RREADY),
        .M01_AXI_rresp(cdma_ic_M01_AXI_RRESP),
        .M01_AXI_ruser(cdma_ic_M01_AXI_RUSER),
        .M01_AXI_rvalid(cdma_ic_M01_AXI_RVALID),
        .M01_AXI_wdata(cdma_ic_M01_AXI_WDATA),
        .M01_AXI_wlast(cdma_ic_M01_AXI_WLAST),
        .M01_AXI_wready(cdma_ic_M01_AXI_WREADY),
        .M01_AXI_wstrb(cdma_ic_M01_AXI_WSTRB),
        .M01_AXI_wuser(cdma_ic_M01_AXI_WUSER),
        .M01_AXI_wvalid(cdma_ic_M01_AXI_WVALID),
        .S00_AXI_araddr(axi_cdma_0_M_AXI_ARADDR),
        .S00_AXI_arburst(axi_cdma_0_M_AXI_ARBURST),
        .S00_AXI_arcache(axi_cdma_0_M_AXI_ARCACHE),
        .S00_AXI_arlen(axi_cdma_0_M_AXI_ARLEN),
        .S00_AXI_arlock(1'b0),
        .S00_AXI_arprot(axi_cdma_0_M_AXI_ARPROT),
        .S00_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arready(axi_cdma_0_M_AXI_ARREADY),
        .S00_AXI_arsize(axi_cdma_0_M_AXI_ARSIZE),
        .S00_AXI_arvalid(axi_cdma_0_M_AXI_ARVALID),
        .S00_AXI_awaddr(axi_cdma_0_M_AXI_AWADDR),
        .S00_AXI_awburst(axi_cdma_0_M_AXI_AWBURST),
        .S00_AXI_awcache(axi_cdma_0_M_AXI_AWCACHE),
        .S00_AXI_awlen(axi_cdma_0_M_AXI_AWLEN),
        .S00_AXI_awlock(1'b0),
        .S00_AXI_awprot(axi_cdma_0_M_AXI_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(axi_cdma_0_M_AXI_AWREADY),
        .S00_AXI_awsize(axi_cdma_0_M_AXI_AWSIZE),
        .S00_AXI_awvalid(axi_cdma_0_M_AXI_AWVALID),
        .S00_AXI_bready(axi_cdma_0_M_AXI_BREADY),
        .S00_AXI_bresp(axi_cdma_0_M_AXI_BRESP),
        .S00_AXI_bvalid(axi_cdma_0_M_AXI_BVALID),
        .S00_AXI_rdata(axi_cdma_0_M_AXI_RDATA),
        .S00_AXI_rlast(axi_cdma_0_M_AXI_RLAST),
        .S00_AXI_rready(axi_cdma_0_M_AXI_RREADY),
        .S00_AXI_rresp(axi_cdma_0_M_AXI_RRESP),
        .S00_AXI_rvalid(axi_cdma_0_M_AXI_RVALID),
        .S00_AXI_wdata(axi_cdma_0_M_AXI_WDATA),
        .S00_AXI_wlast(axi_cdma_0_M_AXI_WLAST),
        .S00_AXI_wready(axi_cdma_0_M_AXI_WREADY),
        .S00_AXI_wstrb(axi_cdma_0_M_AXI_WSTRB),
        .S00_AXI_wvalid(axi_cdma_0_M_AXI_WVALID),
        .aclk(mig_7series_0_ui_clk),
        .aresetn(rst_ui_peripheral_aresetn));
  arty_ddr_clk_eth_0 clk_eth
       (.clk_in1(mig_7series_0_ui_clk),
        .clk_out1(eth_ref_clk));
  (* BMM_INFO_ADDRESS_SPACE = "byte  0x00000000 32 > arty_ddr lmb_bram" *) 
  (* KEEP_HIERARCHY = "YES" *) 
  arty_ddr_dlmb_cntlr_0 dlmb_cntlr
       (.BRAM_Addr_A(dlmb_cntlr_BRAM_PORT_ADDR),
        .BRAM_Clk_A(dlmb_cntlr_BRAM_PORT_CLK),
        .BRAM_Din_A({dlmb_cntlr_BRAM_PORT_DOUT[31],dlmb_cntlr_BRAM_PORT_DOUT[30],dlmb_cntlr_BRAM_PORT_DOUT[29],dlmb_cntlr_BRAM_PORT_DOUT[28],dlmb_cntlr_BRAM_PORT_DOUT[27],dlmb_cntlr_BRAM_PORT_DOUT[26],dlmb_cntlr_BRAM_PORT_DOUT[25],dlmb_cntlr_BRAM_PORT_DOUT[24],dlmb_cntlr_BRAM_PORT_DOUT[23],dlmb_cntlr_BRAM_PORT_DOUT[22],dlmb_cntlr_BRAM_PORT_DOUT[21],dlmb_cntlr_BRAM_PORT_DOUT[20],dlmb_cntlr_BRAM_PORT_DOUT[19],dlmb_cntlr_BRAM_PORT_DOUT[18],dlmb_cntlr_BRAM_PORT_DOUT[17],dlmb_cntlr_BRAM_PORT_DOUT[16],dlmb_cntlr_BRAM_PORT_DOUT[15],dlmb_cntlr_BRAM_PORT_DOUT[14],dlmb_cntlr_BRAM_PORT_DOUT[13],dlmb_cntlr_BRAM_PORT_DOUT[12],dlmb_cntlr_BRAM_PORT_DOUT[11],dlmb_cntlr_BRAM_PORT_DOUT[10],dlmb_cntlr_BRAM_PORT_DOUT[9],dlmb_cntlr_BRAM_PORT_DOUT[8],dlmb_cntlr_BRAM_PORT_DOUT[7],dlmb_cntlr_BRAM_PORT_DOUT[6],dlmb_cntlr_BRAM_PORT_DOUT[5],dlmb_cntlr_BRAM_PORT_DOUT[4],dlmb_cntlr_BRAM_PORT_DOUT[3],dlmb_cntlr_BRAM_PORT_DOUT[2],dlmb_cntlr_BRAM_PORT_DOUT[1],dlmb_cntlr_BRAM_PORT_DOUT[0]}),
        .BRAM_Dout_A(dlmb_cntlr_BRAM_PORT_DIN),
        .BRAM_EN_A(dlmb_cntlr_BRAM_PORT_EN),
        .BRAM_Rst_A(dlmb_cntlr_BRAM_PORT_RST),
        .BRAM_WEN_A(dlmb_cntlr_BRAM_PORT_WE),
        .LMB_ABus(Conn_ABUS),
        .LMB_AddrStrobe(Conn_ADDRSTROBE),
        .LMB_BE(Conn_BE),
        .LMB_Clk(mig_7series_0_ui_clk),
        .LMB_ReadStrobe(Conn_READSTROBE),
        .LMB_Rst(rst_ui_bus_struct_reset),
        .LMB_WriteDBus(Conn_WRITEDBUS),
        .LMB_WriteStrobe(Conn_WRITESTROBE),
        .Sl_CE(Conn_CE),
        .Sl_DBus(Conn_READDBUS),
        .Sl_Ready(Conn_READY),
        .Sl_UE(Conn_UE),
        .Sl_Wait(Conn_WAIT));
  arty_ddr_dlmb_v10_0 dlmb_v10
       (.LMB_ABus(Conn_ABUS),
        .LMB_AddrStrobe(Conn_ADDRSTROBE),
        .LMB_BE(Conn_BE),
        .LMB_CE(microblaze_0_DLMB_CE),
        .LMB_Clk(mig_7series_0_ui_clk),
        .LMB_ReadDBus(microblaze_0_DLMB_READDBUS),
        .LMB_ReadStrobe(Conn_READSTROBE),
        .LMB_Ready(microblaze_0_DLMB_READY),
        .LMB_UE(microblaze_0_DLMB_UE),
        .LMB_Wait(microblaze_0_DLMB_WAIT),
        .LMB_WriteDBus(Conn_WRITEDBUS),
        .LMB_WriteStrobe(Conn_WRITESTROBE),
        .M_ABus(microblaze_0_DLMB_ABUS),
        .M_AddrStrobe(microblaze_0_DLMB_ADDRSTROBE),
        .M_BE(microblaze_0_DLMB_BE),
        .M_DBus(microblaze_0_DLMB_WRITEDBUS),
        .M_ReadStrobe(microblaze_0_DLMB_READSTROBE),
        .M_WriteStrobe(microblaze_0_DLMB_WRITESTROBE),
        .SYS_Rst(rst_ui_bus_struct_reset),
        .Sl_CE(Conn_CE),
        .Sl_DBus(Conn_READDBUS),
        .Sl_Ready(Conn_READY),
        .Sl_UE(Conn_UE),
        .Sl_Wait(Conn_WAIT));
  arty_ddr_ilmb_cntlr_0 ilmb_cntlr
       (.BRAM_Addr_A(ilmb_cntlr_BRAM_PORT_ADDR),
        .BRAM_Clk_A(ilmb_cntlr_BRAM_PORT_CLK),
        .BRAM_Din_A({ilmb_cntlr_BRAM_PORT_DOUT[31],ilmb_cntlr_BRAM_PORT_DOUT[30],ilmb_cntlr_BRAM_PORT_DOUT[29],ilmb_cntlr_BRAM_PORT_DOUT[28],ilmb_cntlr_BRAM_PORT_DOUT[27],ilmb_cntlr_BRAM_PORT_DOUT[26],ilmb_cntlr_BRAM_PORT_DOUT[25],ilmb_cntlr_BRAM_PORT_DOUT[24],ilmb_cntlr_BRAM_PORT_DOUT[23],ilmb_cntlr_BRAM_PORT_DOUT[22],ilmb_cntlr_BRAM_PORT_DOUT[21],ilmb_cntlr_BRAM_PORT_DOUT[20],ilmb_cntlr_BRAM_PORT_DOUT[19],ilmb_cntlr_BRAM_PORT_DOUT[18],ilmb_cntlr_BRAM_PORT_DOUT[17],ilmb_cntlr_BRAM_PORT_DOUT[16],ilmb_cntlr_BRAM_PORT_DOUT[15],ilmb_cntlr_BRAM_PORT_DOUT[14],ilmb_cntlr_BRAM_PORT_DOUT[13],ilmb_cntlr_BRAM_PORT_DOUT[12],ilmb_cntlr_BRAM_PORT_DOUT[11],ilmb_cntlr_BRAM_PORT_DOUT[10],ilmb_cntlr_BRAM_PORT_DOUT[9],ilmb_cntlr_BRAM_PORT_DOUT[8],ilmb_cntlr_BRAM_PORT_DOUT[7],ilmb_cntlr_BRAM_PORT_DOUT[6],ilmb_cntlr_BRAM_PORT_DOUT[5],ilmb_cntlr_BRAM_PORT_DOUT[4],ilmb_cntlr_BRAM_PORT_DOUT[3],ilmb_cntlr_BRAM_PORT_DOUT[2],ilmb_cntlr_BRAM_PORT_DOUT[1],ilmb_cntlr_BRAM_PORT_DOUT[0]}),
        .BRAM_Dout_A(ilmb_cntlr_BRAM_PORT_DIN),
        .BRAM_EN_A(ilmb_cntlr_BRAM_PORT_EN),
        .BRAM_Rst_A(ilmb_cntlr_BRAM_PORT_RST),
        .BRAM_WEN_A(ilmb_cntlr_BRAM_PORT_WE),
        .LMB_ABus(Conn1_ABUS),
        .LMB_AddrStrobe(Conn1_ADDRSTROBE),
        .LMB_BE(Conn1_BE),
        .LMB_Clk(mig_7series_0_ui_clk),
        .LMB_ReadStrobe(Conn1_READSTROBE),
        .LMB_Rst(rst_ui_bus_struct_reset),
        .LMB_WriteDBus(Conn1_WRITEDBUS),
        .LMB_WriteStrobe(Conn1_WRITESTROBE),
        .Sl_CE(Conn1_CE),
        .Sl_DBus(Conn1_READDBUS),
        .Sl_Ready(Conn1_READY),
        .Sl_UE(Conn1_UE),
        .Sl_Wait(Conn1_WAIT));
  arty_ddr_ilmb_v10_0 ilmb_v10
       (.LMB_ABus(Conn1_ABUS),
        .LMB_AddrStrobe(Conn1_ADDRSTROBE),
        .LMB_BE(Conn1_BE),
        .LMB_CE(microblaze_0_ILMB_CE),
        .LMB_Clk(mig_7series_0_ui_clk),
        .LMB_ReadDBus(microblaze_0_ILMB_READDBUS),
        .LMB_ReadStrobe(Conn1_READSTROBE),
        .LMB_Ready(microblaze_0_ILMB_READY),
        .LMB_UE(microblaze_0_ILMB_UE),
        .LMB_Wait(microblaze_0_ILMB_WAIT),
        .LMB_WriteDBus(Conn1_WRITEDBUS),
        .LMB_WriteStrobe(Conn1_WRITESTROBE),
        .M_ABus(microblaze_0_ILMB_ABUS),
        .M_AddrStrobe(microblaze_0_ILMB_ADDRSTROBE),
        .M_BE({1'b0,1'b0,1'b0,1'b0}),
        .M_DBus({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_ReadStrobe(microblaze_0_ILMB_READSTROBE),
        .M_WriteStrobe(1'b0),
        .SYS_Rst(rst_ui_bus_struct_reset),
        .Sl_CE(Conn1_CE),
        .Sl_DBus(Conn1_READDBUS),
        .Sl_Ready(Conn1_READY),
        .Sl_UE(Conn1_UE),
        .Sl_Wait(Conn1_WAIT));
  arty_ddr_lmb_bram_0 lmb_bram
       (.addra({dlmb_cntlr_BRAM_PORT_ADDR[0],dlmb_cntlr_BRAM_PORT_ADDR[1],dlmb_cntlr_BRAM_PORT_ADDR[2],dlmb_cntlr_BRAM_PORT_ADDR[3],dlmb_cntlr_BRAM_PORT_ADDR[4],dlmb_cntlr_BRAM_PORT_ADDR[5],dlmb_cntlr_BRAM_PORT_ADDR[6],dlmb_cntlr_BRAM_PORT_ADDR[7],dlmb_cntlr_BRAM_PORT_ADDR[8],dlmb_cntlr_BRAM_PORT_ADDR[9],dlmb_cntlr_BRAM_PORT_ADDR[10],dlmb_cntlr_BRAM_PORT_ADDR[11],dlmb_cntlr_BRAM_PORT_ADDR[12],dlmb_cntlr_BRAM_PORT_ADDR[13],dlmb_cntlr_BRAM_PORT_ADDR[14],dlmb_cntlr_BRAM_PORT_ADDR[15],dlmb_cntlr_BRAM_PORT_ADDR[16],dlmb_cntlr_BRAM_PORT_ADDR[17],dlmb_cntlr_BRAM_PORT_ADDR[18],dlmb_cntlr_BRAM_PORT_ADDR[19],dlmb_cntlr_BRAM_PORT_ADDR[20],dlmb_cntlr_BRAM_PORT_ADDR[21],dlmb_cntlr_BRAM_PORT_ADDR[22],dlmb_cntlr_BRAM_PORT_ADDR[23],dlmb_cntlr_BRAM_PORT_ADDR[24],dlmb_cntlr_BRAM_PORT_ADDR[25],dlmb_cntlr_BRAM_PORT_ADDR[26],dlmb_cntlr_BRAM_PORT_ADDR[27],dlmb_cntlr_BRAM_PORT_ADDR[28],dlmb_cntlr_BRAM_PORT_ADDR[29],dlmb_cntlr_BRAM_PORT_ADDR[30],dlmb_cntlr_BRAM_PORT_ADDR[31]}),
        .addrb({ilmb_cntlr_BRAM_PORT_ADDR[0],ilmb_cntlr_BRAM_PORT_ADDR[1],ilmb_cntlr_BRAM_PORT_ADDR[2],ilmb_cntlr_BRAM_PORT_ADDR[3],ilmb_cntlr_BRAM_PORT_ADDR[4],ilmb_cntlr_BRAM_PORT_ADDR[5],ilmb_cntlr_BRAM_PORT_ADDR[6],ilmb_cntlr_BRAM_PORT_ADDR[7],ilmb_cntlr_BRAM_PORT_ADDR[8],ilmb_cntlr_BRAM_PORT_ADDR[9],ilmb_cntlr_BRAM_PORT_ADDR[10],ilmb_cntlr_BRAM_PORT_ADDR[11],ilmb_cntlr_BRAM_PORT_ADDR[12],ilmb_cntlr_BRAM_PORT_ADDR[13],ilmb_cntlr_BRAM_PORT_ADDR[14],ilmb_cntlr_BRAM_PORT_ADDR[15],ilmb_cntlr_BRAM_PORT_ADDR[16],ilmb_cntlr_BRAM_PORT_ADDR[17],ilmb_cntlr_BRAM_PORT_ADDR[18],ilmb_cntlr_BRAM_PORT_ADDR[19],ilmb_cntlr_BRAM_PORT_ADDR[20],ilmb_cntlr_BRAM_PORT_ADDR[21],ilmb_cntlr_BRAM_PORT_ADDR[22],ilmb_cntlr_BRAM_PORT_ADDR[23],ilmb_cntlr_BRAM_PORT_ADDR[24],ilmb_cntlr_BRAM_PORT_ADDR[25],ilmb_cntlr_BRAM_PORT_ADDR[26],ilmb_cntlr_BRAM_PORT_ADDR[27],ilmb_cntlr_BRAM_PORT_ADDR[28],ilmb_cntlr_BRAM_PORT_ADDR[29],ilmb_cntlr_BRAM_PORT_ADDR[30],ilmb_cntlr_BRAM_PORT_ADDR[31]}),
        .clka(dlmb_cntlr_BRAM_PORT_CLK),
        .clkb(ilmb_cntlr_BRAM_PORT_CLK),
        .dina({dlmb_cntlr_BRAM_PORT_DIN[0],dlmb_cntlr_BRAM_PORT_DIN[1],dlmb_cntlr_BRAM_PORT_DIN[2],dlmb_cntlr_BRAM_PORT_DIN[3],dlmb_cntlr_BRAM_PORT_DIN[4],dlmb_cntlr_BRAM_PORT_DIN[5],dlmb_cntlr_BRAM_PORT_DIN[6],dlmb_cntlr_BRAM_PORT_DIN[7],dlmb_cntlr_BRAM_PORT_DIN[8],dlmb_cntlr_BRAM_PORT_DIN[9],dlmb_cntlr_BRAM_PORT_DIN[10],dlmb_cntlr_BRAM_PORT_DIN[11],dlmb_cntlr_BRAM_PORT_DIN[12],dlmb_cntlr_BRAM_PORT_DIN[13],dlmb_cntlr_BRAM_PORT_DIN[14],dlmb_cntlr_BRAM_PORT_DIN[15],dlmb_cntlr_BRAM_PORT_DIN[16],dlmb_cntlr_BRAM_PORT_DIN[17],dlmb_cntlr_BRAM_PORT_DIN[18],dlmb_cntlr_BRAM_PORT_DIN[19],dlmb_cntlr_BRAM_PORT_DIN[20],dlmb_cntlr_BRAM_PORT_DIN[21],dlmb_cntlr_BRAM_PORT_DIN[22],dlmb_cntlr_BRAM_PORT_DIN[23],dlmb_cntlr_BRAM_PORT_DIN[24],dlmb_cntlr_BRAM_PORT_DIN[25],dlmb_cntlr_BRAM_PORT_DIN[26],dlmb_cntlr_BRAM_PORT_DIN[27],dlmb_cntlr_BRAM_PORT_DIN[28],dlmb_cntlr_BRAM_PORT_DIN[29],dlmb_cntlr_BRAM_PORT_DIN[30],dlmb_cntlr_BRAM_PORT_DIN[31]}),
        .dinb({ilmb_cntlr_BRAM_PORT_DIN[0],ilmb_cntlr_BRAM_PORT_DIN[1],ilmb_cntlr_BRAM_PORT_DIN[2],ilmb_cntlr_BRAM_PORT_DIN[3],ilmb_cntlr_BRAM_PORT_DIN[4],ilmb_cntlr_BRAM_PORT_DIN[5],ilmb_cntlr_BRAM_PORT_DIN[6],ilmb_cntlr_BRAM_PORT_DIN[7],ilmb_cntlr_BRAM_PORT_DIN[8],ilmb_cntlr_BRAM_PORT_DIN[9],ilmb_cntlr_BRAM_PORT_DIN[10],ilmb_cntlr_BRAM_PORT_DIN[11],ilmb_cntlr_BRAM_PORT_DIN[12],ilmb_cntlr_BRAM_PORT_DIN[13],ilmb_cntlr_BRAM_PORT_DIN[14],ilmb_cntlr_BRAM_PORT_DIN[15],ilmb_cntlr_BRAM_PORT_DIN[16],ilmb_cntlr_BRAM_PORT_DIN[17],ilmb_cntlr_BRAM_PORT_DIN[18],ilmb_cntlr_BRAM_PORT_DIN[19],ilmb_cntlr_BRAM_PORT_DIN[20],ilmb_cntlr_BRAM_PORT_DIN[21],ilmb_cntlr_BRAM_PORT_DIN[22],ilmb_cntlr_BRAM_PORT_DIN[23],ilmb_cntlr_BRAM_PORT_DIN[24],ilmb_cntlr_BRAM_PORT_DIN[25],ilmb_cntlr_BRAM_PORT_DIN[26],ilmb_cntlr_BRAM_PORT_DIN[27],ilmb_cntlr_BRAM_PORT_DIN[28],ilmb_cntlr_BRAM_PORT_DIN[29],ilmb_cntlr_BRAM_PORT_DIN[30],ilmb_cntlr_BRAM_PORT_DIN[31]}),
        .douta(dlmb_cntlr_BRAM_PORT_DOUT),
        .doutb(ilmb_cntlr_BRAM_PORT_DOUT),
        .ena(dlmb_cntlr_BRAM_PORT_EN),
        .enb(ilmb_cntlr_BRAM_PORT_EN),
        .rsta(dlmb_cntlr_BRAM_PORT_RST),
        .rstb(ilmb_cntlr_BRAM_PORT_RST),
        .wea({dlmb_cntlr_BRAM_PORT_WE[0],dlmb_cntlr_BRAM_PORT_WE[1],dlmb_cntlr_BRAM_PORT_WE[2],dlmb_cntlr_BRAM_PORT_WE[3]}),
        .web({ilmb_cntlr_BRAM_PORT_WE[0],ilmb_cntlr_BRAM_PORT_WE[1],ilmb_cntlr_BRAM_PORT_WE[2],ilmb_cntlr_BRAM_PORT_WE[3]}));
  arty_ddr_mdm_1_0 mdm_1
       (.Dbg_Capture_0(mdm_1_MBDEBUG_0_CAPTURE),
        .Dbg_Clk_0(mdm_1_MBDEBUG_0_CLK),
        .Dbg_Disable_0(mdm_1_MBDEBUG_0_DISABLE),
        .Dbg_Reg_En_0(mdm_1_MBDEBUG_0_REG_EN),
        .Dbg_Rst_0(mdm_1_MBDEBUG_0_RST),
        .Dbg_Shift_0(mdm_1_MBDEBUG_0_SHIFT),
        .Dbg_TDI_0(mdm_1_MBDEBUG_0_TDI),
        .Dbg_TDO_0(mdm_1_MBDEBUG_0_TDO),
        .Dbg_Update_0(mdm_1_MBDEBUG_0_UPDATE),
        .Debug_SYS_Rst(mdm_1_Debug_SYS_Rst));
  (* BMM_INFO_PROCESSOR = "microblaze-le > arty_ddr dlmb_cntlr" *) 
  (* KEEP_HIERARCHY = "YES" *) 
  arty_ddr_microblaze_0_0 microblaze_0
       (.Byte_Enable(microblaze_0_DLMB_BE),
        .Clk(mig_7series_0_ui_clk),
        .DCE(microblaze_0_DLMB_CE),
        .DReady(microblaze_0_DLMB_READY),
        .DUE(microblaze_0_DLMB_UE),
        .DWait(microblaze_0_DLMB_WAIT),
        .D_AS(microblaze_0_DLMB_ADDRSTROBE),
        .Data_Addr(microblaze_0_DLMB_ABUS),
        .Data_Read(microblaze_0_DLMB_READDBUS),
        .Data_Write(microblaze_0_DLMB_WRITEDBUS),
        .Dbg_Capture(mdm_1_MBDEBUG_0_CAPTURE),
        .Dbg_Clk(mdm_1_MBDEBUG_0_CLK),
        .Dbg_Disable(mdm_1_MBDEBUG_0_DISABLE),
        .Dbg_Reg_En(mdm_1_MBDEBUG_0_REG_EN),
        .Dbg_Shift(mdm_1_MBDEBUG_0_SHIFT),
        .Dbg_TDI(mdm_1_MBDEBUG_0_TDI),
        .Dbg_TDO(mdm_1_MBDEBUG_0_TDO),
        .Dbg_Update(mdm_1_MBDEBUG_0_UPDATE),
        .Debug_Rst(mdm_1_MBDEBUG_0_RST),
        .ICE(microblaze_0_ILMB_CE),
        .IFetch(microblaze_0_ILMB_READSTROBE),
        .IReady(microblaze_0_ILMB_READY),
        .IUE(microblaze_0_ILMB_UE),
        .IWAIT(microblaze_0_ILMB_WAIT),
        .I_AS(microblaze_0_ILMB_ADDRSTROBE),
        .Instr(microblaze_0_ILMB_READDBUS),
        .Instr_Addr(microblaze_0_ILMB_ABUS),
        .Interrupt(1'b0),
        .Interrupt_Address({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .M_AXI_DC_ARADDR(microblaze_0_M_AXI_DC_ARADDR),
        .M_AXI_DC_ARBURST(microblaze_0_M_AXI_DC_ARBURST),
        .M_AXI_DC_ARCACHE(microblaze_0_M_AXI_DC_ARCACHE),
        .M_AXI_DC_ARLEN(microblaze_0_M_AXI_DC_ARLEN),
        .M_AXI_DC_ARLOCK(microblaze_0_M_AXI_DC_ARLOCK),
        .M_AXI_DC_ARPROT(microblaze_0_M_AXI_DC_ARPROT),
        .M_AXI_DC_ARQOS(microblaze_0_M_AXI_DC_ARQOS),
        .M_AXI_DC_ARREADY(microblaze_0_M_AXI_DC_ARREADY),
        .M_AXI_DC_ARSIZE(microblaze_0_M_AXI_DC_ARSIZE),
        .M_AXI_DC_ARVALID(microblaze_0_M_AXI_DC_ARVALID),
        .M_AXI_DC_AWADDR(microblaze_0_M_AXI_DC_AWADDR),
        .M_AXI_DC_AWBURST(microblaze_0_M_AXI_DC_AWBURST),
        .M_AXI_DC_AWCACHE(microblaze_0_M_AXI_DC_AWCACHE),
        .M_AXI_DC_AWLEN(microblaze_0_M_AXI_DC_AWLEN),
        .M_AXI_DC_AWLOCK(microblaze_0_M_AXI_DC_AWLOCK),
        .M_AXI_DC_AWPROT(microblaze_0_M_AXI_DC_AWPROT),
        .M_AXI_DC_AWQOS(microblaze_0_M_AXI_DC_AWQOS),
        .M_AXI_DC_AWREADY(microblaze_0_M_AXI_DC_AWREADY),
        .M_AXI_DC_AWSIZE(microblaze_0_M_AXI_DC_AWSIZE),
        .M_AXI_DC_AWVALID(microblaze_0_M_AXI_DC_AWVALID),
        .M_AXI_DC_BID(1'b0),
        .M_AXI_DC_BREADY(microblaze_0_M_AXI_DC_BREADY),
        .M_AXI_DC_BRESP(microblaze_0_M_AXI_DC_BRESP),
        .M_AXI_DC_BVALID(microblaze_0_M_AXI_DC_BVALID),
        .M_AXI_DC_RDATA(microblaze_0_M_AXI_DC_RDATA),
        .M_AXI_DC_RID(1'b0),
        .M_AXI_DC_RLAST(microblaze_0_M_AXI_DC_RLAST),
        .M_AXI_DC_RREADY(microblaze_0_M_AXI_DC_RREADY),
        .M_AXI_DC_RRESP(microblaze_0_M_AXI_DC_RRESP),
        .M_AXI_DC_RVALID(microblaze_0_M_AXI_DC_RVALID),
        .M_AXI_DC_WDATA(microblaze_0_M_AXI_DC_WDATA),
        .M_AXI_DC_WLAST(microblaze_0_M_AXI_DC_WLAST),
        .M_AXI_DC_WREADY(microblaze_0_M_AXI_DC_WREADY),
        .M_AXI_DC_WSTRB(microblaze_0_M_AXI_DC_WSTRB),
        .M_AXI_DC_WVALID(microblaze_0_M_AXI_DC_WVALID),
        .M_AXI_DP_ARADDR(microblaze_0_M_AXI_DP_ARADDR),
        .M_AXI_DP_ARPROT(microblaze_0_M_AXI_DP_ARPROT),
        .M_AXI_DP_ARREADY(microblaze_0_M_AXI_DP_ARREADY),
        .M_AXI_DP_ARVALID(microblaze_0_M_AXI_DP_ARVALID),
        .M_AXI_DP_AWADDR(microblaze_0_M_AXI_DP_AWADDR),
        .M_AXI_DP_AWPROT(microblaze_0_M_AXI_DP_AWPROT),
        .M_AXI_DP_AWREADY(microblaze_0_M_AXI_DP_AWREADY),
        .M_AXI_DP_AWVALID(microblaze_0_M_AXI_DP_AWVALID),
        .M_AXI_DP_BREADY(microblaze_0_M_AXI_DP_BREADY),
        .M_AXI_DP_BRESP(microblaze_0_M_AXI_DP_BRESP),
        .M_AXI_DP_BVALID(microblaze_0_M_AXI_DP_BVALID),
        .M_AXI_DP_RDATA(microblaze_0_M_AXI_DP_RDATA),
        .M_AXI_DP_RREADY(microblaze_0_M_AXI_DP_RREADY),
        .M_AXI_DP_RRESP(microblaze_0_M_AXI_DP_RRESP),
        .M_AXI_DP_RVALID(microblaze_0_M_AXI_DP_RVALID),
        .M_AXI_DP_WDATA(microblaze_0_M_AXI_DP_WDATA),
        .M_AXI_DP_WREADY(microblaze_0_M_AXI_DP_WREADY),
        .M_AXI_DP_WSTRB(microblaze_0_M_AXI_DP_WSTRB),
        .M_AXI_DP_WVALID(microblaze_0_M_AXI_DP_WVALID),
        .M_AXI_IC_ARADDR(microblaze_0_M_AXI_IC_ARADDR),
        .M_AXI_IC_ARBURST(microblaze_0_M_AXI_IC_ARBURST),
        .M_AXI_IC_ARCACHE(microblaze_0_M_AXI_IC_ARCACHE),
        .M_AXI_IC_ARLEN(microblaze_0_M_AXI_IC_ARLEN),
        .M_AXI_IC_ARLOCK(microblaze_0_M_AXI_IC_ARLOCK),
        .M_AXI_IC_ARPROT(microblaze_0_M_AXI_IC_ARPROT),
        .M_AXI_IC_ARQOS(microblaze_0_M_AXI_IC_ARQOS),
        .M_AXI_IC_ARREADY(microblaze_0_M_AXI_IC_ARREADY),
        .M_AXI_IC_ARSIZE(microblaze_0_M_AXI_IC_ARSIZE),
        .M_AXI_IC_ARVALID(microblaze_0_M_AXI_IC_ARVALID),
        .M_AXI_IC_AWREADY(1'b0),
        .M_AXI_IC_BID(1'b0),
        .M_AXI_IC_BRESP({1'b0,1'b0}),
        .M_AXI_IC_BVALID(1'b0),
        .M_AXI_IC_RDATA(microblaze_0_M_AXI_IC_RDATA),
        .M_AXI_IC_RID(1'b0),
        .M_AXI_IC_RLAST(microblaze_0_M_AXI_IC_RLAST),
        .M_AXI_IC_RREADY(microblaze_0_M_AXI_IC_RREADY),
        .M_AXI_IC_RRESP(microblaze_0_M_AXI_IC_RRESP),
        .M_AXI_IC_RVALID(microblaze_0_M_AXI_IC_RVALID),
        .M_AXI_IC_WREADY(1'b0),
        .Read_Strobe(microblaze_0_DLMB_READSTROBE),
        .Reset(rst_ui_mb_reset),
        .Write_Strobe(microblaze_0_DLMB_WRITESTROBE));
  arty_ddr_mig_7series_0_0 mig_7series_0
       (.aresetn(rst_ui_peripheral_aresetn),
        .clk_ref_i(mig_7series_0_ui_addn_clk_0),
        .ddr3_addr(DDR3_0_addr),
        .ddr3_ba(DDR3_0_ba),
        .ddr3_cas_n(DDR3_0_cas_n),
        .ddr3_ck_n(DDR3_0_ck_n),
        .ddr3_ck_p(DDR3_0_ck_p),
        .ddr3_cke(DDR3_0_cke),
        .ddr3_cs_n(DDR3_0_cs_n),
        .ddr3_dm(DDR3_0_dm),
        .ddr3_dq(DDR3_0_dq),
        .ddr3_dqs_n(DDR3_0_dqs_n),
        .ddr3_dqs_p(DDR3_0_dqs_p),
        .ddr3_odt(DDR3_0_odt),
        .ddr3_ras_n(DDR3_0_ras_n),
        .ddr3_reset_n(DDR3_0_reset_n),
        .ddr3_we_n(DDR3_0_we_n),
        .mmcm_locked(mig_7series_0_mmcm_locked),
        .s_axi_araddr(axi_smc_M00_AXI_ARADDR),
        .s_axi_arburst(axi_smc_M00_AXI_ARBURST),
        .s_axi_arcache(axi_smc_M00_AXI_ARCACHE),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen(axi_smc_M00_AXI_ARLEN),
        .s_axi_arlock(axi_smc_M00_AXI_ARLOCK),
        .s_axi_arprot(axi_smc_M00_AXI_ARPROT),
        .s_axi_arqos(axi_smc_M00_AXI_ARQOS),
        .s_axi_arready(axi_smc_M00_AXI_ARREADY),
        .s_axi_arsize(axi_smc_M00_AXI_ARSIZE),
        .s_axi_arvalid(axi_smc_M00_AXI_ARVALID),
        .s_axi_awaddr(axi_smc_M00_AXI_AWADDR),
        .s_axi_awburst(axi_smc_M00_AXI_AWBURST),
        .s_axi_awcache(axi_smc_M00_AXI_AWCACHE),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen(axi_smc_M00_AXI_AWLEN),
        .s_axi_awlock(axi_smc_M00_AXI_AWLOCK),
        .s_axi_awprot(axi_smc_M00_AXI_AWPROT),
        .s_axi_awqos(axi_smc_M00_AXI_AWQOS),
        .s_axi_awready(axi_smc_M00_AXI_AWREADY),
        .s_axi_awsize(axi_smc_M00_AXI_AWSIZE),
        .s_axi_awvalid(axi_smc_M00_AXI_AWVALID),
        .s_axi_bready(axi_smc_M00_AXI_BREADY),
        .s_axi_bresp(axi_smc_M00_AXI_BRESP),
        .s_axi_bvalid(axi_smc_M00_AXI_BVALID),
        .s_axi_rdata(axi_smc_M00_AXI_RDATA),
        .s_axi_rlast(axi_smc_M00_AXI_RLAST),
        .s_axi_rready(axi_smc_M00_AXI_RREADY),
        .s_axi_rresp(axi_smc_M00_AXI_RRESP),
        .s_axi_rvalid(axi_smc_M00_AXI_RVALID),
        .s_axi_wdata(axi_smc_M00_AXI_WDATA),
        .s_axi_wlast(axi_smc_M00_AXI_WLAST),
        .s_axi_wready(axi_smc_M00_AXI_WREADY),
        .s_axi_wstrb(axi_smc_M00_AXI_WSTRB),
        .s_axi_wvalid(axi_smc_M00_AXI_WVALID),
        .sys_clk_i(sys_clk),
        .sys_rst(sys_rst_n),
        .ui_addn_clk_0(mig_7series_0_ui_addn_clk_0),
        .ui_clk(mig_7series_0_ui_clk),
        .ui_clk_sync_rst(mig_7series_0_ui_clk_sync_rst));
  arty_ddr_periph_0 periph
       (.ACLK(mig_7series_0_ui_clk),
        .ARESETN(rst_ui_peripheral_aresetn),
        .M00_ACLK(mig_7series_0_ui_clk),
        .M00_ARESETN(rst_ui_peripheral_aresetn),
        .M00_AXI_araddr(periph_M00_AXI_ARADDR),
        .M00_AXI_arready(periph_M00_AXI_ARREADY),
        .M00_AXI_arvalid(periph_M00_AXI_ARVALID),
        .M00_AXI_awaddr(periph_M00_AXI_AWADDR),
        .M00_AXI_awready(periph_M00_AXI_AWREADY),
        .M00_AXI_awvalid(periph_M00_AXI_AWVALID),
        .M00_AXI_bready(periph_M00_AXI_BREADY),
        .M00_AXI_bresp(periph_M00_AXI_BRESP),
        .M00_AXI_bvalid(periph_M00_AXI_BVALID),
        .M00_AXI_rdata(periph_M00_AXI_RDATA),
        .M00_AXI_rready(periph_M00_AXI_RREADY),
        .M00_AXI_rresp(periph_M00_AXI_RRESP),
        .M00_AXI_rvalid(periph_M00_AXI_RVALID),
        .M00_AXI_wdata(periph_M00_AXI_WDATA),
        .M00_AXI_wready(periph_M00_AXI_WREADY),
        .M00_AXI_wstrb(periph_M00_AXI_WSTRB),
        .M00_AXI_wvalid(periph_M00_AXI_WVALID),
        .M01_ACLK(mig_7series_0_ui_clk),
        .M01_ARESETN(rst_ui_peripheral_aresetn),
        .M01_AXI_araddr(periph_M01_AXI_ARADDR),
        .M01_AXI_arready(periph_M01_AXI_ARREADY),
        .M01_AXI_arvalid(periph_M01_AXI_ARVALID),
        .M01_AXI_awaddr(periph_M01_AXI_AWADDR),
        .M01_AXI_awready(periph_M01_AXI_AWREADY),
        .M01_AXI_awvalid(periph_M01_AXI_AWVALID),
        .M01_AXI_bready(periph_M01_AXI_BREADY),
        .M01_AXI_bresp(periph_M01_AXI_BRESP),
        .M01_AXI_bvalid(periph_M01_AXI_BVALID),
        .M01_AXI_rdata(periph_M01_AXI_RDATA),
        .M01_AXI_rready(periph_M01_AXI_RREADY),
        .M01_AXI_rresp(periph_M01_AXI_RRESP),
        .M01_AXI_rvalid(periph_M01_AXI_RVALID),
        .M01_AXI_wdata(periph_M01_AXI_WDATA),
        .M01_AXI_wready(periph_M01_AXI_WREADY),
        .M01_AXI_wstrb(periph_M01_AXI_WSTRB),
        .M01_AXI_wvalid(periph_M01_AXI_WVALID),
        .M02_ACLK(mig_7series_0_ui_clk),
        .M02_ARESETN(rst_ui_peripheral_aresetn),
        .M02_AXI_araddr(periph_M02_AXI_ARADDR),
        .M02_AXI_arprot(periph_M02_AXI_ARPROT),
        .M02_AXI_arready(periph_M02_AXI_ARREADY),
        .M02_AXI_arvalid(periph_M02_AXI_ARVALID),
        .M02_AXI_awaddr(periph_M02_AXI_AWADDR),
        .M02_AXI_awprot(periph_M02_AXI_AWPROT),
        .M02_AXI_awready(periph_M02_AXI_AWREADY),
        .M02_AXI_awvalid(periph_M02_AXI_AWVALID),
        .M02_AXI_bready(periph_M02_AXI_BREADY),
        .M02_AXI_bresp(periph_M02_AXI_BRESP),
        .M02_AXI_bvalid(periph_M02_AXI_BVALID),
        .M02_AXI_rdata(periph_M02_AXI_RDATA),
        .M02_AXI_rready(periph_M02_AXI_RREADY),
        .M02_AXI_rresp(periph_M02_AXI_RRESP),
        .M02_AXI_rvalid(periph_M02_AXI_RVALID),
        .M02_AXI_wdata(periph_M02_AXI_WDATA),
        .M02_AXI_wready(periph_M02_AXI_WREADY),
        .M02_AXI_wstrb(periph_M02_AXI_WSTRB),
        .M02_AXI_wvalid(periph_M02_AXI_WVALID),
        .M03_ACLK(mig_7series_0_ui_clk),
        .M03_ARESETN(rst_ui_peripheral_aresetn),
        .M03_AXI_araddr(periph_M03_AXI_ARADDR),
        .M03_AXI_arprot(periph_M03_AXI_ARPROT),
        .M03_AXI_arready(periph_M03_AXI_ARREADY),
        .M03_AXI_arvalid(periph_M03_AXI_ARVALID),
        .M03_AXI_awaddr(periph_M03_AXI_AWADDR),
        .M03_AXI_awprot(periph_M03_AXI_AWPROT),
        .M03_AXI_awready(periph_M03_AXI_AWREADY),
        .M03_AXI_awvalid(periph_M03_AXI_AWVALID),
        .M03_AXI_bready(periph_M03_AXI_BREADY),
        .M03_AXI_bresp(periph_M03_AXI_BRESP),
        .M03_AXI_bvalid(periph_M03_AXI_BVALID),
        .M03_AXI_rdata(periph_M03_AXI_RDATA),
        .M03_AXI_rready(periph_M03_AXI_RREADY),
        .M03_AXI_rresp(periph_M03_AXI_RRESP),
        .M03_AXI_rvalid(periph_M03_AXI_RVALID),
        .M03_AXI_wdata(periph_M03_AXI_WDATA),
        .M03_AXI_wready(periph_M03_AXI_WREADY),
        .M03_AXI_wstrb(periph_M03_AXI_WSTRB),
        .M03_AXI_wvalid(periph_M03_AXI_WVALID),
        .M04_ACLK(mig_7series_0_ui_clk),
        .M04_ARESETN(rst_ui_peripheral_aresetn),
        .M04_AXI_araddr(periph_M04_AXI_ARADDR),
        .M04_AXI_arready(periph_M04_AXI_ARREADY),
        .M04_AXI_arvalid(periph_M04_AXI_ARVALID),
        .M04_AXI_awaddr(periph_M04_AXI_AWADDR),
        .M04_AXI_awready(periph_M04_AXI_AWREADY),
        .M04_AXI_awvalid(periph_M04_AXI_AWVALID),
        .M04_AXI_bready(periph_M04_AXI_BREADY),
        .M04_AXI_bresp(periph_M04_AXI_BRESP),
        .M04_AXI_bvalid(periph_M04_AXI_BVALID),
        .M04_AXI_rdata(periph_M04_AXI_RDATA),
        .M04_AXI_rready(periph_M04_AXI_RREADY),
        .M04_AXI_rresp(periph_M04_AXI_RRESP),
        .M04_AXI_rvalid(periph_M04_AXI_RVALID),
        .M04_AXI_wdata(periph_M04_AXI_WDATA),
        .M04_AXI_wready(periph_M04_AXI_WREADY),
        .M04_AXI_wvalid(periph_M04_AXI_WVALID),
        .M05_ACLK(mig_7series_0_ui_clk),
        .M05_ARESETN(rst_ui_peripheral_aresetn),
        .M05_AXI_araddr(periph_M05_AXI_ARADDR),
        .M05_AXI_arready(periph_M05_AXI_ARREADY),
        .M05_AXI_arvalid(periph_M05_AXI_ARVALID),
        .M05_AXI_awaddr(periph_M05_AXI_AWADDR),
        .M05_AXI_awready(periph_M05_AXI_AWREADY),
        .M05_AXI_awvalid(periph_M05_AXI_AWVALID),
        .M05_AXI_bready(periph_M05_AXI_BREADY),
        .M05_AXI_bresp(periph_M05_AXI_BRESP),
        .M05_AXI_bvalid(periph_M05_AXI_BVALID),
        .M05_AXI_rdata(periph_M05_AXI_RDATA),
        .M05_AXI_rready(periph_M05_AXI_RREADY),
        .M05_AXI_rresp(periph_M05_AXI_RRESP),
        .M05_AXI_rvalid(periph_M05_AXI_RVALID),
        .M05_AXI_wdata(periph_M05_AXI_WDATA),
        .M05_AXI_wready(periph_M05_AXI_WREADY),
        .M05_AXI_wstrb(periph_M05_AXI_WSTRB),
        .M05_AXI_wvalid(periph_M05_AXI_WVALID),
        .S00_ACLK(mig_7series_0_ui_clk),
        .S00_ARESETN(rst_ui_peripheral_aresetn),
        .S00_AXI_araddr(microblaze_0_M_AXI_DP_ARADDR),
        .S00_AXI_arprot(microblaze_0_M_AXI_DP_ARPROT),
        .S00_AXI_arready(microblaze_0_M_AXI_DP_ARREADY),
        .S00_AXI_arvalid(microblaze_0_M_AXI_DP_ARVALID),
        .S00_AXI_awaddr(microblaze_0_M_AXI_DP_AWADDR),
        .S00_AXI_awprot(microblaze_0_M_AXI_DP_AWPROT),
        .S00_AXI_awready(microblaze_0_M_AXI_DP_AWREADY),
        .S00_AXI_awvalid(microblaze_0_M_AXI_DP_AWVALID),
        .S00_AXI_bready(microblaze_0_M_AXI_DP_BREADY),
        .S00_AXI_bresp(microblaze_0_M_AXI_DP_BRESP),
        .S00_AXI_bvalid(microblaze_0_M_AXI_DP_BVALID),
        .S00_AXI_rdata(microblaze_0_M_AXI_DP_RDATA),
        .S00_AXI_rready(microblaze_0_M_AXI_DP_RREADY),
        .S00_AXI_rresp(microblaze_0_M_AXI_DP_RRESP),
        .S00_AXI_rvalid(microblaze_0_M_AXI_DP_RVALID),
        .S00_AXI_wdata(microblaze_0_M_AXI_DP_WDATA),
        .S00_AXI_wready(microblaze_0_M_AXI_DP_WREADY),
        .S00_AXI_wstrb(microblaze_0_M_AXI_DP_WSTRB),
        .S00_AXI_wvalid(microblaze_0_M_AXI_DP_WVALID));
  arty_ddr_rst_inv_0 rst_inv
       (.Op1(mig_7series_0_ui_clk_sync_rst),
        .Res(rst_inv_Res));
  arty_ddr_rst_ui_0 rst_ui
       (.aux_reset_in(1'b1),
        .bus_struct_reset(rst_ui_bus_struct_reset),
        .dcm_locked(mig_7series_0_mmcm_locked),
        .ext_reset_in(rst_inv_Res),
        .mb_debug_sys_rst(mdm_1_Debug_SYS_Rst),
        .mb_reset(rst_ui_mb_reset),
        .peripheral_aresetn(rst_ui_peripheral_aresetn),
        .slowest_sync_clk(mig_7series_0_ui_clk));
  arty_ddr_weight_bram_0_0 weight_bram_0
       (.clk(mig_7series_0_ui_clk),
        .rst_n(rst_ui_peripheral_aresetn),
        .s_axi_araddr(bram_ic_M00_AXI_ARADDR),
        .s_axi_arburst(bram_ic_M00_AXI_ARBURST),
        .s_axi_arcache(bram_ic_M00_AXI_ARCACHE),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen(bram_ic_M00_AXI_ARLEN),
        .s_axi_arlock(bram_ic_M00_AXI_ARLOCK),
        .s_axi_arprot(bram_ic_M00_AXI_ARPROT),
        .s_axi_arqos(bram_ic_M00_AXI_ARQOS),
        .s_axi_arready(bram_ic_M00_AXI_ARREADY),
        .s_axi_arsize(bram_ic_M00_AXI_ARSIZE),
        .s_axi_arvalid(bram_ic_M00_AXI_ARVALID),
        .s_axi_awaddr(bram_ic_M00_AXI_AWADDR),
        .s_axi_awburst(bram_ic_M00_AXI_AWBURST),
        .s_axi_awcache(bram_ic_M00_AXI_AWCACHE),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen(bram_ic_M00_AXI_AWLEN),
        .s_axi_awlock(bram_ic_M00_AXI_AWLOCK),
        .s_axi_awprot(bram_ic_M00_AXI_AWPROT),
        .s_axi_awqos(bram_ic_M00_AXI_AWQOS),
        .s_axi_awready(bram_ic_M00_AXI_AWREADY),
        .s_axi_awsize(bram_ic_M00_AXI_AWSIZE),
        .s_axi_awvalid(bram_ic_M00_AXI_AWVALID),
        .s_axi_bready(bram_ic_M00_AXI_BREADY),
        .s_axi_bresp(bram_ic_M00_AXI_BRESP),
        .s_axi_bvalid(bram_ic_M00_AXI_BVALID),
        .s_axi_rdata(bram_ic_M00_AXI_RDATA),
        .s_axi_rlast(bram_ic_M00_AXI_RLAST),
        .s_axi_rready(bram_ic_M00_AXI_RREADY),
        .s_axi_rresp(bram_ic_M00_AXI_RRESP),
        .s_axi_rvalid(bram_ic_M00_AXI_RVALID),
        .s_axi_wdata(bram_ic_M00_AXI_WDATA),
        .s_axi_wlast(bram_ic_M00_AXI_WLAST),
        .s_axi_wready(bram_ic_M00_AXI_WREADY),
        .s_axi_wstrb(bram_ic_M00_AXI_WSTRB),
        .s_axi_wvalid(bram_ic_M00_AXI_WVALID),
        .w_word(weight_bram_0_w_word),
        .w_word_addr(axi_gemm_stream_0_w_word_addr));
endmodule

module arty_ddr_periph_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arready,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awready,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    M01_ACLK,
    M01_ARESETN,
    M01_AXI_araddr,
    M01_AXI_arready,
    M01_AXI_arvalid,
    M01_AXI_awaddr,
    M01_AXI_awready,
    M01_AXI_awvalid,
    M01_AXI_bready,
    M01_AXI_bresp,
    M01_AXI_bvalid,
    M01_AXI_rdata,
    M01_AXI_rready,
    M01_AXI_rresp,
    M01_AXI_rvalid,
    M01_AXI_wdata,
    M01_AXI_wready,
    M01_AXI_wstrb,
    M01_AXI_wvalid,
    M02_ACLK,
    M02_ARESETN,
    M02_AXI_araddr,
    M02_AXI_arprot,
    M02_AXI_arready,
    M02_AXI_arvalid,
    M02_AXI_awaddr,
    M02_AXI_awprot,
    M02_AXI_awready,
    M02_AXI_awvalid,
    M02_AXI_bready,
    M02_AXI_bresp,
    M02_AXI_bvalid,
    M02_AXI_rdata,
    M02_AXI_rready,
    M02_AXI_rresp,
    M02_AXI_rvalid,
    M02_AXI_wdata,
    M02_AXI_wready,
    M02_AXI_wstrb,
    M02_AXI_wvalid,
    M03_ACLK,
    M03_ARESETN,
    M03_AXI_araddr,
    M03_AXI_arprot,
    M03_AXI_arready,
    M03_AXI_arvalid,
    M03_AXI_awaddr,
    M03_AXI_awprot,
    M03_AXI_awready,
    M03_AXI_awvalid,
    M03_AXI_bready,
    M03_AXI_bresp,
    M03_AXI_bvalid,
    M03_AXI_rdata,
    M03_AXI_rready,
    M03_AXI_rresp,
    M03_AXI_rvalid,
    M03_AXI_wdata,
    M03_AXI_wready,
    M03_AXI_wstrb,
    M03_AXI_wvalid,
    M04_ACLK,
    M04_ARESETN,
    M04_AXI_araddr,
    M04_AXI_arready,
    M04_AXI_arvalid,
    M04_AXI_awaddr,
    M04_AXI_awready,
    M04_AXI_awvalid,
    M04_AXI_bready,
    M04_AXI_bresp,
    M04_AXI_bvalid,
    M04_AXI_rdata,
    M04_AXI_rready,
    M04_AXI_rresp,
    M04_AXI_rvalid,
    M04_AXI_wdata,
    M04_AXI_wready,
    M04_AXI_wvalid,
    M05_ACLK,
    M05_ARESETN,
    M05_AXI_araddr,
    M05_AXI_arready,
    M05_AXI_arvalid,
    M05_AXI_awaddr,
    M05_AXI_awready,
    M05_AXI_awvalid,
    M05_AXI_bready,
    M05_AXI_bresp,
    M05_AXI_bvalid,
    M05_AXI_rdata,
    M05_AXI_rready,
    M05_AXI_rresp,
    M05_AXI_rvalid,
    M05_AXI_wdata,
    M05_AXI_wready,
    M05_AXI_wstrb,
    M05_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arprot,
    S00_AXI_arready,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awprot,
    S00_AXI_awready,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [31:0]M00_AXI_araddr;
  input M00_AXI_arready;
  output M00_AXI_arvalid;
  output [31:0]M00_AXI_awaddr;
  input M00_AXI_awready;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  input M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input M01_ACLK;
  input M01_ARESETN;
  output [31:0]M01_AXI_araddr;
  input M01_AXI_arready;
  output M01_AXI_arvalid;
  output [31:0]M01_AXI_awaddr;
  input M01_AXI_awready;
  output M01_AXI_awvalid;
  output M01_AXI_bready;
  input [1:0]M01_AXI_bresp;
  input M01_AXI_bvalid;
  input [31:0]M01_AXI_rdata;
  output M01_AXI_rready;
  input [1:0]M01_AXI_rresp;
  input M01_AXI_rvalid;
  output [31:0]M01_AXI_wdata;
  input M01_AXI_wready;
  output [3:0]M01_AXI_wstrb;
  output M01_AXI_wvalid;
  input M02_ACLK;
  input M02_ARESETN;
  output [31:0]M02_AXI_araddr;
  output [2:0]M02_AXI_arprot;
  input M02_AXI_arready;
  output M02_AXI_arvalid;
  output [31:0]M02_AXI_awaddr;
  output [2:0]M02_AXI_awprot;
  input M02_AXI_awready;
  output M02_AXI_awvalid;
  output M02_AXI_bready;
  input [1:0]M02_AXI_bresp;
  input M02_AXI_bvalid;
  input [31:0]M02_AXI_rdata;
  output M02_AXI_rready;
  input [1:0]M02_AXI_rresp;
  input M02_AXI_rvalid;
  output [31:0]M02_AXI_wdata;
  input M02_AXI_wready;
  output [3:0]M02_AXI_wstrb;
  output M02_AXI_wvalid;
  input M03_ACLK;
  input M03_ARESETN;
  output [31:0]M03_AXI_araddr;
  output [2:0]M03_AXI_arprot;
  input M03_AXI_arready;
  output M03_AXI_arvalid;
  output [31:0]M03_AXI_awaddr;
  output [2:0]M03_AXI_awprot;
  input M03_AXI_awready;
  output M03_AXI_awvalid;
  output M03_AXI_bready;
  input [1:0]M03_AXI_bresp;
  input M03_AXI_bvalid;
  input [31:0]M03_AXI_rdata;
  output M03_AXI_rready;
  input [1:0]M03_AXI_rresp;
  input M03_AXI_rvalid;
  output [31:0]M03_AXI_wdata;
  input M03_AXI_wready;
  output [3:0]M03_AXI_wstrb;
  output M03_AXI_wvalid;
  input M04_ACLK;
  input M04_ARESETN;
  output [31:0]M04_AXI_araddr;
  input M04_AXI_arready;
  output M04_AXI_arvalid;
  output [31:0]M04_AXI_awaddr;
  input M04_AXI_awready;
  output M04_AXI_awvalid;
  output M04_AXI_bready;
  input [1:0]M04_AXI_bresp;
  input M04_AXI_bvalid;
  input [31:0]M04_AXI_rdata;
  output M04_AXI_rready;
  input [1:0]M04_AXI_rresp;
  input M04_AXI_rvalid;
  output [31:0]M04_AXI_wdata;
  input M04_AXI_wready;
  output M04_AXI_wvalid;
  input M05_ACLK;
  input M05_ARESETN;
  output [31:0]M05_AXI_araddr;
  input M05_AXI_arready;
  output M05_AXI_arvalid;
  output [31:0]M05_AXI_awaddr;
  input M05_AXI_awready;
  output M05_AXI_awvalid;
  output M05_AXI_bready;
  input [1:0]M05_AXI_bresp;
  input M05_AXI_bvalid;
  input [31:0]M05_AXI_rdata;
  output M05_AXI_rready;
  input [1:0]M05_AXI_rresp;
  input M05_AXI_rvalid;
  output [31:0]M05_AXI_wdata;
  input M05_AXI_wready;
  output [3:0]M05_AXI_wstrb;
  output M05_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [31:0]S00_AXI_araddr;
  input [2:0]S00_AXI_arprot;
  output [0:0]S00_AXI_arready;
  input [0:0]S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [2:0]S00_AXI_awprot;
  output [0:0]S00_AXI_awready;
  input [0:0]S00_AXI_awvalid;
  input [0:0]S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output [0:0]S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  input [0:0]S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output [0:0]S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  output [0:0]S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input [0:0]S00_AXI_wvalid;

  wire ACLK;
  wire ARESETN;
  wire [31:0]M00_AXI_araddr;
  wire M00_AXI_arready;
  wire M00_AXI_arvalid;
  wire [31:0]M00_AXI_awaddr;
  wire M00_AXI_awready;
  wire M00_AXI_awvalid;
  wire M00_AXI_bready;
  wire [1:0]M00_AXI_bresp;
  wire M00_AXI_bvalid;
  wire [31:0]M00_AXI_rdata;
  wire M00_AXI_rready;
  wire [1:0]M00_AXI_rresp;
  wire M00_AXI_rvalid;
  wire [31:0]M00_AXI_wdata;
  wire M00_AXI_wready;
  wire [3:0]M00_AXI_wstrb;
  wire M00_AXI_wvalid;
  wire [31:0]M01_AXI_araddr;
  wire M01_AXI_arready;
  wire M01_AXI_arvalid;
  wire [31:0]M01_AXI_awaddr;
  wire M01_AXI_awready;
  wire M01_AXI_awvalid;
  wire M01_AXI_bready;
  wire [1:0]M01_AXI_bresp;
  wire M01_AXI_bvalid;
  wire [31:0]M01_AXI_rdata;
  wire M01_AXI_rready;
  wire [1:0]M01_AXI_rresp;
  wire M01_AXI_rvalid;
  wire [31:0]M01_AXI_wdata;
  wire M01_AXI_wready;
  wire [3:0]M01_AXI_wstrb;
  wire M01_AXI_wvalid;
  wire [31:0]M02_AXI_araddr;
  wire [2:0]M02_AXI_arprot;
  wire M02_AXI_arready;
  wire M02_AXI_arvalid;
  wire [31:0]M02_AXI_awaddr;
  wire [2:0]M02_AXI_awprot;
  wire M02_AXI_awready;
  wire M02_AXI_awvalid;
  wire M02_AXI_bready;
  wire [1:0]M02_AXI_bresp;
  wire M02_AXI_bvalid;
  wire [31:0]M02_AXI_rdata;
  wire M02_AXI_rready;
  wire [1:0]M02_AXI_rresp;
  wire M02_AXI_rvalid;
  wire [31:0]M02_AXI_wdata;
  wire M02_AXI_wready;
  wire [3:0]M02_AXI_wstrb;
  wire M02_AXI_wvalid;
  wire [31:0]M03_AXI_araddr;
  wire [2:0]M03_AXI_arprot;
  wire M03_AXI_arready;
  wire M03_AXI_arvalid;
  wire [31:0]M03_AXI_awaddr;
  wire [2:0]M03_AXI_awprot;
  wire M03_AXI_awready;
  wire M03_AXI_awvalid;
  wire M03_AXI_bready;
  wire [1:0]M03_AXI_bresp;
  wire M03_AXI_bvalid;
  wire [31:0]M03_AXI_rdata;
  wire M03_AXI_rready;
  wire [1:0]M03_AXI_rresp;
  wire M03_AXI_rvalid;
  wire [31:0]M03_AXI_wdata;
  wire M03_AXI_wready;
  wire [3:0]M03_AXI_wstrb;
  wire M03_AXI_wvalid;
  wire [31:0]M04_AXI_araddr;
  wire M04_AXI_arready;
  wire M04_AXI_arvalid;
  wire [31:0]M04_AXI_awaddr;
  wire M04_AXI_awready;
  wire M04_AXI_awvalid;
  wire M04_AXI_bready;
  wire [1:0]M04_AXI_bresp;
  wire M04_AXI_bvalid;
  wire [31:0]M04_AXI_rdata;
  wire M04_AXI_rready;
  wire [1:0]M04_AXI_rresp;
  wire M04_AXI_rvalid;
  wire [31:0]M04_AXI_wdata;
  wire M04_AXI_wready;
  wire M04_AXI_wvalid;
  wire [31:0]M05_AXI_araddr;
  wire M05_AXI_arready;
  wire M05_AXI_arvalid;
  wire [31:0]M05_AXI_awaddr;
  wire M05_AXI_awready;
  wire M05_AXI_awvalid;
  wire M05_AXI_bready;
  wire [1:0]M05_AXI_bresp;
  wire M05_AXI_bvalid;
  wire [31:0]M05_AXI_rdata;
  wire M05_AXI_rready;
  wire [1:0]M05_AXI_rresp;
  wire M05_AXI_rvalid;
  wire [31:0]M05_AXI_wdata;
  wire M05_AXI_wready;
  wire [3:0]M05_AXI_wstrb;
  wire M05_AXI_wvalid;
  wire [31:0]S00_AXI_araddr;
  wire [2:0]S00_AXI_arprot;
  wire [0:0]S00_AXI_arready;
  wire [0:0]S00_AXI_arvalid;
  wire [31:0]S00_AXI_awaddr;
  wire [2:0]S00_AXI_awprot;
  wire [0:0]S00_AXI_awready;
  wire [0:0]S00_AXI_awvalid;
  wire [0:0]S00_AXI_bready;
  wire [1:0]S00_AXI_bresp;
  wire [0:0]S00_AXI_bvalid;
  wire [31:0]S00_AXI_rdata;
  wire [0:0]S00_AXI_rready;
  wire [1:0]S00_AXI_rresp;
  wire [0:0]S00_AXI_rvalid;
  wire [31:0]S00_AXI_wdata;
  wire [0:0]S00_AXI_wready;
  wire [3:0]S00_AXI_wstrb;
  wire [0:0]S00_AXI_wvalid;
  wire [31:0]s00_couplers_to_xbar_ARADDR;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire [0:0]s00_couplers_to_xbar_ARVALID;
  wire [31:0]s00_couplers_to_xbar_AWADDR;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire [0:0]s00_couplers_to_xbar_AWVALID;
  wire [0:0]s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [31:0]s00_couplers_to_xbar_RDATA;
  wire [0:0]s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [31:0]s00_couplers_to_xbar_WDATA;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [3:0]s00_couplers_to_xbar_WSTRB;
  wire [0:0]s00_couplers_to_xbar_WVALID;
  wire [31:0]xbar_to_m00_couplers_ARADDR;
  wire xbar_to_m00_couplers_ARREADY;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [31:0]xbar_to_m00_couplers_AWADDR;
  wire xbar_to_m00_couplers_AWREADY;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire xbar_to_m00_couplers_BVALID;
  wire [31:0]xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire xbar_to_m00_couplers_RVALID;
  wire [31:0]xbar_to_m00_couplers_WDATA;
  wire xbar_to_m00_couplers_WREADY;
  wire [3:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;
  wire [63:32]xbar_to_m01_couplers_ARADDR;
  wire xbar_to_m01_couplers_ARREADY;
  wire [1:1]xbar_to_m01_couplers_ARVALID;
  wire [63:32]xbar_to_m01_couplers_AWADDR;
  wire xbar_to_m01_couplers_AWREADY;
  wire [1:1]xbar_to_m01_couplers_AWVALID;
  wire [1:1]xbar_to_m01_couplers_BREADY;
  wire [1:0]xbar_to_m01_couplers_BRESP;
  wire xbar_to_m01_couplers_BVALID;
  wire [31:0]xbar_to_m01_couplers_RDATA;
  wire [1:1]xbar_to_m01_couplers_RREADY;
  wire [1:0]xbar_to_m01_couplers_RRESP;
  wire xbar_to_m01_couplers_RVALID;
  wire [63:32]xbar_to_m01_couplers_WDATA;
  wire xbar_to_m01_couplers_WREADY;
  wire [7:4]xbar_to_m01_couplers_WSTRB;
  wire [1:1]xbar_to_m01_couplers_WVALID;
  wire [95:64]xbar_to_m02_couplers_ARADDR;
  wire [8:6]xbar_to_m02_couplers_ARPROT;
  wire xbar_to_m02_couplers_ARREADY;
  wire [2:2]xbar_to_m02_couplers_ARVALID;
  wire [95:64]xbar_to_m02_couplers_AWADDR;
  wire [8:6]xbar_to_m02_couplers_AWPROT;
  wire xbar_to_m02_couplers_AWREADY;
  wire [2:2]xbar_to_m02_couplers_AWVALID;
  wire [2:2]xbar_to_m02_couplers_BREADY;
  wire [1:0]xbar_to_m02_couplers_BRESP;
  wire xbar_to_m02_couplers_BVALID;
  wire [31:0]xbar_to_m02_couplers_RDATA;
  wire [2:2]xbar_to_m02_couplers_RREADY;
  wire [1:0]xbar_to_m02_couplers_RRESP;
  wire xbar_to_m02_couplers_RVALID;
  wire [95:64]xbar_to_m02_couplers_WDATA;
  wire xbar_to_m02_couplers_WREADY;
  wire [11:8]xbar_to_m02_couplers_WSTRB;
  wire [2:2]xbar_to_m02_couplers_WVALID;
  wire [127:96]xbar_to_m03_couplers_ARADDR;
  wire [11:9]xbar_to_m03_couplers_ARPROT;
  wire xbar_to_m03_couplers_ARREADY;
  wire [3:3]xbar_to_m03_couplers_ARVALID;
  wire [127:96]xbar_to_m03_couplers_AWADDR;
  wire [11:9]xbar_to_m03_couplers_AWPROT;
  wire xbar_to_m03_couplers_AWREADY;
  wire [3:3]xbar_to_m03_couplers_AWVALID;
  wire [3:3]xbar_to_m03_couplers_BREADY;
  wire [1:0]xbar_to_m03_couplers_BRESP;
  wire xbar_to_m03_couplers_BVALID;
  wire [31:0]xbar_to_m03_couplers_RDATA;
  wire [3:3]xbar_to_m03_couplers_RREADY;
  wire [1:0]xbar_to_m03_couplers_RRESP;
  wire xbar_to_m03_couplers_RVALID;
  wire [127:96]xbar_to_m03_couplers_WDATA;
  wire xbar_to_m03_couplers_WREADY;
  wire [15:12]xbar_to_m03_couplers_WSTRB;
  wire [3:3]xbar_to_m03_couplers_WVALID;
  wire [159:128]xbar_to_m04_couplers_ARADDR;
  wire xbar_to_m04_couplers_ARREADY;
  wire [4:4]xbar_to_m04_couplers_ARVALID;
  wire [159:128]xbar_to_m04_couplers_AWADDR;
  wire xbar_to_m04_couplers_AWREADY;
  wire [4:4]xbar_to_m04_couplers_AWVALID;
  wire [4:4]xbar_to_m04_couplers_BREADY;
  wire [1:0]xbar_to_m04_couplers_BRESP;
  wire xbar_to_m04_couplers_BVALID;
  wire [31:0]xbar_to_m04_couplers_RDATA;
  wire [4:4]xbar_to_m04_couplers_RREADY;
  wire [1:0]xbar_to_m04_couplers_RRESP;
  wire xbar_to_m04_couplers_RVALID;
  wire [159:128]xbar_to_m04_couplers_WDATA;
  wire xbar_to_m04_couplers_WREADY;
  wire [4:4]xbar_to_m04_couplers_WVALID;
  wire [191:160]xbar_to_m05_couplers_ARADDR;
  wire xbar_to_m05_couplers_ARREADY;
  wire [5:5]xbar_to_m05_couplers_ARVALID;
  wire [191:160]xbar_to_m05_couplers_AWADDR;
  wire xbar_to_m05_couplers_AWREADY;
  wire [5:5]xbar_to_m05_couplers_AWVALID;
  wire [5:5]xbar_to_m05_couplers_BREADY;
  wire [1:0]xbar_to_m05_couplers_BRESP;
  wire xbar_to_m05_couplers_BVALID;
  wire [31:0]xbar_to_m05_couplers_RDATA;
  wire [5:5]xbar_to_m05_couplers_RREADY;
  wire [1:0]xbar_to_m05_couplers_RRESP;
  wire xbar_to_m05_couplers_RVALID;
  wire [191:160]xbar_to_m05_couplers_WDATA;
  wire xbar_to_m05_couplers_WREADY;
  wire [23:20]xbar_to_m05_couplers_WSTRB;
  wire [5:5]xbar_to_m05_couplers_WVALID;
  wire [17:0]NLW_xbar_m_axi_arprot_UNCONNECTED;
  wire [17:0]NLW_xbar_m_axi_awprot_UNCONNECTED;
  wire [23:0]NLW_xbar_m_axi_wstrb_UNCONNECTED;

  m00_couplers_imp_1HS22CB m00_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(M00_AXI_araddr),
        .M_AXI_arready(M00_AXI_arready),
        .M_AXI_arvalid(M00_AXI_arvalid),
        .M_AXI_awaddr(M00_AXI_awaddr),
        .M_AXI_awready(M00_AXI_awready),
        .M_AXI_awvalid(M00_AXI_awvalid),
        .M_AXI_bready(M00_AXI_bready),
        .M_AXI_bresp(M00_AXI_bresp),
        .M_AXI_bvalid(M00_AXI_bvalid),
        .M_AXI_rdata(M00_AXI_rdata),
        .M_AXI_rready(M00_AXI_rready),
        .M_AXI_rresp(M00_AXI_rresp),
        .M_AXI_rvalid(M00_AXI_rvalid),
        .M_AXI_wdata(M00_AXI_wdata),
        .M_AXI_wready(M00_AXI_wready),
        .M_AXI_wstrb(M00_AXI_wstrb),
        .M_AXI_wvalid(M00_AXI_wvalid),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  m01_couplers_imp_CWJKJE m01_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(M01_AXI_araddr),
        .M_AXI_arready(M01_AXI_arready),
        .M_AXI_arvalid(M01_AXI_arvalid),
        .M_AXI_awaddr(M01_AXI_awaddr),
        .M_AXI_awready(M01_AXI_awready),
        .M_AXI_awvalid(M01_AXI_awvalid),
        .M_AXI_bready(M01_AXI_bready),
        .M_AXI_bresp(M01_AXI_bresp),
        .M_AXI_bvalid(M01_AXI_bvalid),
        .M_AXI_rdata(M01_AXI_rdata),
        .M_AXI_rready(M01_AXI_rready),
        .M_AXI_rresp(M01_AXI_rresp),
        .M_AXI_rvalid(M01_AXI_rvalid),
        .M_AXI_wdata(M01_AXI_wdata),
        .M_AXI_wready(M01_AXI_wready),
        .M_AXI_wstrb(M01_AXI_wstrb),
        .M_AXI_wvalid(M01_AXI_wvalid),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(xbar_to_m01_couplers_ARADDR),
        .S_AXI_arready(xbar_to_m01_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m01_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m01_couplers_AWADDR),
        .S_AXI_awready(xbar_to_m01_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m01_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m01_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m01_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m01_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m01_couplers_RDATA),
        .S_AXI_rready(xbar_to_m01_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m01_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m01_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m01_couplers_WDATA),
        .S_AXI_wready(xbar_to_m01_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m01_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m01_couplers_WVALID));
  m02_couplers_imp_1IE2SPK m02_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(M02_AXI_araddr),
        .M_AXI_arprot(M02_AXI_arprot),
        .M_AXI_arready(M02_AXI_arready),
        .M_AXI_arvalid(M02_AXI_arvalid),
        .M_AXI_awaddr(M02_AXI_awaddr),
        .M_AXI_awprot(M02_AXI_awprot),
        .M_AXI_awready(M02_AXI_awready),
        .M_AXI_awvalid(M02_AXI_awvalid),
        .M_AXI_bready(M02_AXI_bready),
        .M_AXI_bresp(M02_AXI_bresp),
        .M_AXI_bvalid(M02_AXI_bvalid),
        .M_AXI_rdata(M02_AXI_rdata),
        .M_AXI_rready(M02_AXI_rready),
        .M_AXI_rresp(M02_AXI_rresp),
        .M_AXI_rvalid(M02_AXI_rvalid),
        .M_AXI_wdata(M02_AXI_wdata),
        .M_AXI_wready(M02_AXI_wready),
        .M_AXI_wstrb(M02_AXI_wstrb),
        .M_AXI_wvalid(M02_AXI_wvalid),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(xbar_to_m02_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m02_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m02_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m02_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m02_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m02_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m02_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m02_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m02_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m02_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m02_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m02_couplers_RDATA),
        .S_AXI_rready(xbar_to_m02_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m02_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m02_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m02_couplers_WDATA),
        .S_AXI_wready(xbar_to_m02_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m02_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m02_couplers_WVALID));
  m03_couplers_imp_C0V3UH m03_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(M03_AXI_araddr),
        .M_AXI_arprot(M03_AXI_arprot),
        .M_AXI_arready(M03_AXI_arready),
        .M_AXI_arvalid(M03_AXI_arvalid),
        .M_AXI_awaddr(M03_AXI_awaddr),
        .M_AXI_awprot(M03_AXI_awprot),
        .M_AXI_awready(M03_AXI_awready),
        .M_AXI_awvalid(M03_AXI_awvalid),
        .M_AXI_bready(M03_AXI_bready),
        .M_AXI_bresp(M03_AXI_bresp),
        .M_AXI_bvalid(M03_AXI_bvalid),
        .M_AXI_rdata(M03_AXI_rdata),
        .M_AXI_rready(M03_AXI_rready),
        .M_AXI_rresp(M03_AXI_rresp),
        .M_AXI_rvalid(M03_AXI_rvalid),
        .M_AXI_wdata(M03_AXI_wdata),
        .M_AXI_wready(M03_AXI_wready),
        .M_AXI_wstrb(M03_AXI_wstrb),
        .M_AXI_wvalid(M03_AXI_wvalid),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(xbar_to_m03_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m03_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m03_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m03_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m03_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m03_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m03_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m03_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m03_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m03_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m03_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m03_couplers_RDATA),
        .S_AXI_rready(xbar_to_m03_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m03_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m03_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m03_couplers_WDATA),
        .S_AXI_wready(xbar_to_m03_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m03_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m03_couplers_WVALID));
  m04_couplers_imp_1K6JZA5 m04_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(M04_AXI_araddr),
        .M_AXI_arready(M04_AXI_arready),
        .M_AXI_arvalid(M04_AXI_arvalid),
        .M_AXI_awaddr(M04_AXI_awaddr),
        .M_AXI_awready(M04_AXI_awready),
        .M_AXI_awvalid(M04_AXI_awvalid),
        .M_AXI_bready(M04_AXI_bready),
        .M_AXI_bresp(M04_AXI_bresp),
        .M_AXI_bvalid(M04_AXI_bvalid),
        .M_AXI_rdata(M04_AXI_rdata),
        .M_AXI_rready(M04_AXI_rready),
        .M_AXI_rresp(M04_AXI_rresp),
        .M_AXI_rvalid(M04_AXI_rvalid),
        .M_AXI_wdata(M04_AXI_wdata),
        .M_AXI_wready(M04_AXI_wready),
        .M_AXI_wvalid(M04_AXI_wvalid),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(xbar_to_m04_couplers_ARADDR),
        .S_AXI_arready(xbar_to_m04_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m04_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m04_couplers_AWADDR),
        .S_AXI_awready(xbar_to_m04_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m04_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m04_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m04_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m04_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m04_couplers_RDATA),
        .S_AXI_rready(xbar_to_m04_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m04_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m04_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m04_couplers_WDATA),
        .S_AXI_wready(xbar_to_m04_couplers_WREADY),
        .S_AXI_wvalid(xbar_to_m04_couplers_WVALID));
  m05_couplers_imp_AB75BW m05_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(M05_AXI_araddr),
        .M_AXI_arready(M05_AXI_arready),
        .M_AXI_arvalid(M05_AXI_arvalid),
        .M_AXI_awaddr(M05_AXI_awaddr),
        .M_AXI_awready(M05_AXI_awready),
        .M_AXI_awvalid(M05_AXI_awvalid),
        .M_AXI_bready(M05_AXI_bready),
        .M_AXI_bresp(M05_AXI_bresp),
        .M_AXI_bvalid(M05_AXI_bvalid),
        .M_AXI_rdata(M05_AXI_rdata),
        .M_AXI_rready(M05_AXI_rready),
        .M_AXI_rresp(M05_AXI_rresp),
        .M_AXI_rvalid(M05_AXI_rvalid),
        .M_AXI_wdata(M05_AXI_wdata),
        .M_AXI_wready(M05_AXI_wready),
        .M_AXI_wstrb(M05_AXI_wstrb),
        .M_AXI_wvalid(M05_AXI_wvalid),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(xbar_to_m05_couplers_ARADDR),
        .S_AXI_arready(xbar_to_m05_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m05_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m05_couplers_AWADDR),
        .S_AXI_awready(xbar_to_m05_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m05_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m05_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m05_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m05_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m05_couplers_RDATA),
        .S_AXI_rready(xbar_to_m05_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m05_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m05_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m05_couplers_WDATA),
        .S_AXI_wready(xbar_to_m05_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m05_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m05_couplers_WVALID));
  s00_couplers_imp_FSNFVD s00_couplers
       (.M_ACLK(ACLK),
        .M_ARESETN(ARESETN),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(ACLK),
        .S_ARESETN(ARESETN),
        .S_AXI_araddr(S00_AXI_araddr),
        .S_AXI_arprot(S00_AXI_arprot),
        .S_AXI_arready(S00_AXI_arready),
        .S_AXI_arvalid(S00_AXI_arvalid),
        .S_AXI_awaddr(S00_AXI_awaddr),
        .S_AXI_awprot(S00_AXI_awprot),
        .S_AXI_awready(S00_AXI_awready),
        .S_AXI_awvalid(S00_AXI_awvalid),
        .S_AXI_bready(S00_AXI_bready),
        .S_AXI_bresp(S00_AXI_bresp),
        .S_AXI_bvalid(S00_AXI_bvalid),
        .S_AXI_rdata(S00_AXI_rdata),
        .S_AXI_rready(S00_AXI_rready),
        .S_AXI_rresp(S00_AXI_rresp),
        .S_AXI_rvalid(S00_AXI_rvalid),
        .S_AXI_wdata(S00_AXI_wdata),
        .S_AXI_wready(S00_AXI_wready),
        .S_AXI_wstrb(S00_AXI_wstrb),
        .S_AXI_wvalid(S00_AXI_wvalid));
  arty_ddr_periph_imp_xbar_0 xbar
       (.aclk(ACLK),
        .aresetn(ARESETN),
        .m_axi_araddr({xbar_to_m05_couplers_ARADDR,xbar_to_m04_couplers_ARADDR,xbar_to_m03_couplers_ARADDR,xbar_to_m02_couplers_ARADDR,xbar_to_m01_couplers_ARADDR,xbar_to_m00_couplers_ARADDR}),
        .m_axi_arprot({xbar_to_m03_couplers_ARPROT,xbar_to_m02_couplers_ARPROT,NLW_xbar_m_axi_arprot_UNCONNECTED[5:0]}),
        .m_axi_arready({xbar_to_m05_couplers_ARREADY,xbar_to_m04_couplers_ARREADY,xbar_to_m03_couplers_ARREADY,xbar_to_m02_couplers_ARREADY,xbar_to_m01_couplers_ARREADY,xbar_to_m00_couplers_ARREADY}),
        .m_axi_arvalid({xbar_to_m05_couplers_ARVALID,xbar_to_m04_couplers_ARVALID,xbar_to_m03_couplers_ARVALID,xbar_to_m02_couplers_ARVALID,xbar_to_m01_couplers_ARVALID,xbar_to_m00_couplers_ARVALID}),
        .m_axi_awaddr({xbar_to_m05_couplers_AWADDR,xbar_to_m04_couplers_AWADDR,xbar_to_m03_couplers_AWADDR,xbar_to_m02_couplers_AWADDR,xbar_to_m01_couplers_AWADDR,xbar_to_m00_couplers_AWADDR}),
        .m_axi_awprot({xbar_to_m03_couplers_AWPROT,xbar_to_m02_couplers_AWPROT,NLW_xbar_m_axi_awprot_UNCONNECTED[5:0]}),
        .m_axi_awready({xbar_to_m05_couplers_AWREADY,xbar_to_m04_couplers_AWREADY,xbar_to_m03_couplers_AWREADY,xbar_to_m02_couplers_AWREADY,xbar_to_m01_couplers_AWREADY,xbar_to_m00_couplers_AWREADY}),
        .m_axi_awvalid({xbar_to_m05_couplers_AWVALID,xbar_to_m04_couplers_AWVALID,xbar_to_m03_couplers_AWVALID,xbar_to_m02_couplers_AWVALID,xbar_to_m01_couplers_AWVALID,xbar_to_m00_couplers_AWVALID}),
        .m_axi_bready({xbar_to_m05_couplers_BREADY,xbar_to_m04_couplers_BREADY,xbar_to_m03_couplers_BREADY,xbar_to_m02_couplers_BREADY,xbar_to_m01_couplers_BREADY,xbar_to_m00_couplers_BREADY}),
        .m_axi_bresp({xbar_to_m05_couplers_BRESP,xbar_to_m04_couplers_BRESP,xbar_to_m03_couplers_BRESP,xbar_to_m02_couplers_BRESP,xbar_to_m01_couplers_BRESP,xbar_to_m00_couplers_BRESP}),
        .m_axi_bvalid({xbar_to_m05_couplers_BVALID,xbar_to_m04_couplers_BVALID,xbar_to_m03_couplers_BVALID,xbar_to_m02_couplers_BVALID,xbar_to_m01_couplers_BVALID,xbar_to_m00_couplers_BVALID}),
        .m_axi_rdata({xbar_to_m05_couplers_RDATA,xbar_to_m04_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m00_couplers_RDATA}),
        .m_axi_rready({xbar_to_m05_couplers_RREADY,xbar_to_m04_couplers_RREADY,xbar_to_m03_couplers_RREADY,xbar_to_m02_couplers_RREADY,xbar_to_m01_couplers_RREADY,xbar_to_m00_couplers_RREADY}),
        .m_axi_rresp({xbar_to_m05_couplers_RRESP,xbar_to_m04_couplers_RRESP,xbar_to_m03_couplers_RRESP,xbar_to_m02_couplers_RRESP,xbar_to_m01_couplers_RRESP,xbar_to_m00_couplers_RRESP}),
        .m_axi_rvalid({xbar_to_m05_couplers_RVALID,xbar_to_m04_couplers_RVALID,xbar_to_m03_couplers_RVALID,xbar_to_m02_couplers_RVALID,xbar_to_m01_couplers_RVALID,xbar_to_m00_couplers_RVALID}),
        .m_axi_wdata({xbar_to_m05_couplers_WDATA,xbar_to_m04_couplers_WDATA,xbar_to_m03_couplers_WDATA,xbar_to_m02_couplers_WDATA,xbar_to_m01_couplers_WDATA,xbar_to_m00_couplers_WDATA}),
        .m_axi_wready({xbar_to_m05_couplers_WREADY,xbar_to_m04_couplers_WREADY,xbar_to_m03_couplers_WREADY,xbar_to_m02_couplers_WREADY,xbar_to_m01_couplers_WREADY,xbar_to_m00_couplers_WREADY}),
        .m_axi_wstrb({xbar_to_m05_couplers_WSTRB,NLW_xbar_m_axi_wstrb_UNCONNECTED[19:16],xbar_to_m03_couplers_WSTRB,xbar_to_m02_couplers_WSTRB,xbar_to_m01_couplers_WSTRB,xbar_to_m00_couplers_WSTRB}),
        .m_axi_wvalid({xbar_to_m05_couplers_WVALID,xbar_to_m04_couplers_WVALID,xbar_to_m03_couplers_WVALID,xbar_to_m02_couplers_WVALID,xbar_to_m01_couplers_WVALID,xbar_to_m00_couplers_WVALID}),
        .s_axi_araddr(s00_couplers_to_xbar_ARADDR),
        .s_axi_arprot(s00_couplers_to_xbar_ARPROT),
        .s_axi_arready(s00_couplers_to_xbar_ARREADY),
        .s_axi_arvalid(s00_couplers_to_xbar_ARVALID),
        .s_axi_awaddr(s00_couplers_to_xbar_AWADDR),
        .s_axi_awprot(s00_couplers_to_xbar_AWPROT),
        .s_axi_awready(s00_couplers_to_xbar_AWREADY),
        .s_axi_awvalid(s00_couplers_to_xbar_AWVALID),
        .s_axi_bready(s00_couplers_to_xbar_BREADY),
        .s_axi_bresp(s00_couplers_to_xbar_BRESP),
        .s_axi_bvalid(s00_couplers_to_xbar_BVALID),
        .s_axi_rdata(s00_couplers_to_xbar_RDATA),
        .s_axi_rready(s00_couplers_to_xbar_RREADY),
        .s_axi_rresp(s00_couplers_to_xbar_RRESP),
        .s_axi_rvalid(s00_couplers_to_xbar_RVALID),
        .s_axi_wdata(s00_couplers_to_xbar_WDATA),
        .s_axi_wready(s00_couplers_to_xbar_WREADY),
        .s_axi_wstrb(s00_couplers_to_xbar_WSTRB),
        .s_axi_wvalid(s00_couplers_to_xbar_WVALID));
endmodule

module m00_couplers_imp_1HS22CB
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire M_AXI_awvalid;
  wire M_AXI_bready;
  wire M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire [3:0]M_AXI_wstrb;
  wire M_AXI_wvalid;
  wire S_AXI_arready;
  wire S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arvalid = S_AXI_arvalid;
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awvalid = S_AXI_awvalid;
  assign M_AXI_bready = S_AXI_bready;
  assign M_AXI_rready = S_AXI_rready;
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wstrb = S_AXI_wstrb[3:0];
  assign M_AXI_wvalid = S_AXI_wvalid;
  assign S_AXI_arready = M_AXI_arready;
  assign S_AXI_awready = M_AXI_awready;
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid;
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid;
  assign S_AXI_wready = M_AXI_wready;
endmodule

module m01_couplers_imp_CWJKJE
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire M_AXI_awvalid;
  wire M_AXI_bready;
  wire M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire [3:0]M_AXI_wstrb;
  wire M_AXI_wvalid;
  wire S_AXI_arready;
  wire S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arvalid = S_AXI_arvalid;
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awvalid = S_AXI_awvalid;
  assign M_AXI_bready = S_AXI_bready;
  assign M_AXI_rready = S_AXI_rready;
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wstrb = S_AXI_wstrb[3:0];
  assign M_AXI_wvalid = S_AXI_wvalid;
  assign S_AXI_arready = M_AXI_arready;
  assign S_AXI_awready = M_AXI_awready;
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid;
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid;
  assign S_AXI_wready = M_AXI_wready;
endmodule

module m02_couplers_imp_1IE2SPK
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire [2:0]M_AXI_arprot;
  wire M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire [2:0]M_AXI_awprot;
  wire M_AXI_awvalid;
  wire M_AXI_bready;
  wire M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire [3:0]M_AXI_wstrb;
  wire M_AXI_wvalid;
  wire S_AXI_arready;
  wire S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arprot = S_AXI_arprot[2:0];
  assign M_AXI_arvalid = S_AXI_arvalid;
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awprot = S_AXI_awprot[2:0];
  assign M_AXI_awvalid = S_AXI_awvalid;
  assign M_AXI_bready = S_AXI_bready;
  assign M_AXI_rready = S_AXI_rready;
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wstrb = S_AXI_wstrb[3:0];
  assign M_AXI_wvalid = S_AXI_wvalid;
  assign S_AXI_arready = M_AXI_arready;
  assign S_AXI_awready = M_AXI_awready;
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid;
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid;
  assign S_AXI_wready = M_AXI_wready;
endmodule

module m03_couplers_imp_C0V3UH
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire [2:0]M_AXI_arprot;
  wire M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire [2:0]M_AXI_awprot;
  wire M_AXI_awvalid;
  wire M_AXI_bready;
  wire M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire [3:0]M_AXI_wstrb;
  wire M_AXI_wvalid;
  wire S_AXI_arready;
  wire S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arprot = S_AXI_arprot[2:0];
  assign M_AXI_arvalid = S_AXI_arvalid;
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awprot = S_AXI_awprot[2:0];
  assign M_AXI_awvalid = S_AXI_awvalid;
  assign M_AXI_bready = S_AXI_bready;
  assign M_AXI_rready = S_AXI_rready;
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wstrb = S_AXI_wstrb[3:0];
  assign M_AXI_wvalid = S_AXI_wvalid;
  assign S_AXI_arready = M_AXI_arready;
  assign S_AXI_awready = M_AXI_awready;
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid;
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid;
  assign S_AXI_wready = M_AXI_wready;
endmodule

module m04_couplers_imp_1K6JZA5
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire M_AXI_awvalid;
  wire M_AXI_bready;
  wire M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire M_AXI_wvalid;
  wire S_AXI_arready;
  wire S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arvalid = S_AXI_arvalid;
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awvalid = S_AXI_awvalid;
  assign M_AXI_bready = S_AXI_bready;
  assign M_AXI_rready = S_AXI_rready;
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wvalid = S_AXI_wvalid;
  assign S_AXI_arready = M_AXI_arready;
  assign S_AXI_awready = M_AXI_awready;
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid;
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid;
  assign S_AXI_wready = M_AXI_wready;
endmodule

module m05_couplers_imp_AB75BW
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire M_AXI_awvalid;
  wire M_AXI_bready;
  wire M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire [3:0]M_AXI_wstrb;
  wire M_AXI_wvalid;
  wire S_AXI_arready;
  wire S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arvalid = S_AXI_arvalid;
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awvalid = S_AXI_awvalid;
  assign M_AXI_bready = S_AXI_bready;
  assign M_AXI_rready = S_AXI_rready;
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wstrb = S_AXI_wstrb[3:0];
  assign M_AXI_wvalid = S_AXI_wvalid;
  assign S_AXI_arready = M_AXI_arready;
  assign S_AXI_awready = M_AXI_awready;
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid;
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid;
  assign S_AXI_wready = M_AXI_wready;
endmodule

module s00_couplers_imp_FSNFVD
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [31:0]M_AXI_araddr;
  wire [2:0]M_AXI_arprot;
  wire [0:0]M_AXI_arvalid;
  wire [31:0]M_AXI_awaddr;
  wire [2:0]M_AXI_awprot;
  wire [0:0]M_AXI_awvalid;
  wire [0:0]M_AXI_bready;
  wire [0:0]M_AXI_rready;
  wire [31:0]M_AXI_wdata;
  wire [3:0]M_AXI_wstrb;
  wire [0:0]M_AXI_wvalid;
  wire [0:0]S_AXI_arready;
  wire [0:0]S_AXI_awready;
  wire [1:0]S_AXI_bresp;
  wire [0:0]S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire [1:0]S_AXI_rresp;
  wire [0:0]S_AXI_rvalid;
  wire [0:0]S_AXI_wready;

  assign M_AXI_araddr = S_AXI_araddr[31:0];
  assign M_AXI_arprot = S_AXI_arprot[2:0];
  assign M_AXI_arvalid = S_AXI_arvalid[0];
  assign M_AXI_awaddr = S_AXI_awaddr[31:0];
  assign M_AXI_awprot = S_AXI_awprot[2:0];
  assign M_AXI_awvalid = S_AXI_awvalid[0];
  assign M_AXI_bready = S_AXI_bready[0];
  assign M_AXI_rready = S_AXI_rready[0];
  assign M_AXI_wdata = S_AXI_wdata[31:0];
  assign M_AXI_wstrb = S_AXI_wstrb[3:0];
  assign M_AXI_wvalid = S_AXI_wvalid[0];
  assign S_AXI_arready = M_AXI_arready[0];
  assign S_AXI_awready = M_AXI_awready[0];
  assign S_AXI_bresp = M_AXI_bresp[1:0];
  assign S_AXI_bvalid = M_AXI_bvalid[0];
  assign S_AXI_rdata = M_AXI_rdata[31:0];
  assign S_AXI_rresp = M_AXI_rresp[1:0];
  assign S_AXI_rvalid = M_AXI_rvalid[0];
  assign S_AXI_wready = M_AXI_wready[0];
endmodule
