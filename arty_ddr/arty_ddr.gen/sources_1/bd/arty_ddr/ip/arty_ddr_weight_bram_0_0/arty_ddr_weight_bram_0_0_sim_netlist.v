// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Mon Aug  3 14:21:32 2026
// Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_weight_bram_0_0/arty_ddr_weight_bram_0_0_sim_netlist.v
// Design      : arty_ddr_weight_bram_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "arty_ddr_weight_bram_0_0,weight_bram128,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "package_project" *) 
(* X_CORE_INFO = "weight_bram128,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module arty_ddr_weight_bram_0_0
   (clk,
    rst_n,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    w_word_addr,
    w_word);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF s_axi, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWID" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 81247969, ID_WIDTH 4, ADDR_WIDTH 18, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [3:0]s_axi_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *) input [17:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWLEN" *) input [7:0]s_axi_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWSIZE" *) input [2:0]s_axi_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWBURST" *) input [1:0]s_axi_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWLOCK" *) input s_axi_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWCACHE" *) input [3:0]s_axi_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWPROT" *) input [2:0]s_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWQOS" *) input [3:0]s_axi_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WLAST" *) input s_axi_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BID" *) output [3:0]s_axi_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARID" *) input [3:0]s_axi_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARADDR" *) input [17:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARLEN" *) input [7:0]s_axi_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARSIZE" *) input [2:0]s_axi_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARBURST" *) input [1:0]s_axi_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARLOCK" *) input s_axi_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARCACHE" *) input [3:0]s_axi_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARPROT" *) input [2:0]s_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARQOS" *) input [3:0]s_axi_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RID" *) output [3:0]s_axi_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RLAST" *) output s_axi_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *) input s_axi_rready;
  input [13:0]w_word_addr;
  output [127:0]w_word;

  wire \<const0> ;
  wire \<const1> ;
  wire clk;
  wire rst_n;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [17:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire [127:0]w_word;
  wire [13:0]w_word_addr;

  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rdata[31] = \<const1> ;
  assign s_axi_rdata[30] = \<const1> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const1> ;
  assign s_axi_rdata[27] = \<const1> ;
  assign s_axi_rdata[26] = \<const1> ;
  assign s_axi_rdata[25] = \<const1> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const1> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const1> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const1> ;
  assign s_axi_rdata[18] = \<const1> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const1> ;
  assign s_axi_rdata[15] = \<const1> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const1> ;
  assign s_axi_rdata[12] = \<const1> ;
  assign s_axi_rdata[11] = \<const1> ;
  assign s_axi_rdata[10] = \<const1> ;
  assign s_axi_rdata[9] = \<const1> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const1> ;
  assign s_axi_rdata[6] = \<const1> ;
  assign s_axi_rdata[5] = \<const1> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const1> ;
  assign s_axi_rdata[2] = \<const1> ;
  assign s_axi_rdata[1] = \<const1> ;
  assign s_axi_rdata[0] = \<const1> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  arty_ddr_weight_bram_0_0_weight_bram128 inst
       (.clk(clk),
        .rst_n(rst_n),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid_reg_0(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .w_word(w_word),
        .w_word_addr(w_word_addr));
endmodule

(* ORIG_REF_NAME = "weight_bram128" *) 
module arty_ddr_weight_bram_0_0_weight_bram128
   (s_axi_wready,
    s_axi_awready,
    w_word,
    s_axi_bid,
    s_axi_rid,
    s_axi_rlast,
    s_axi_rvalid_reg_0,
    s_axi_arready,
    s_axi_bvalid,
    s_axi_arlen,
    clk,
    w_word_addr,
    s_axi_wdata,
    s_axi_awburst,
    s_axi_awsize,
    s_axi_awid,
    s_axi_arid,
    s_axi_arvalid,
    s_axi_rready,
    rst_n,
    s_axi_awvalid,
    s_axi_wvalid,
    s_axi_bready,
    s_axi_wlast,
    s_axi_awaddr,
    s_axi_wstrb);
  output s_axi_wready;
  output s_axi_awready;
  output [127:0]w_word;
  output [3:0]s_axi_bid;
  output [3:0]s_axi_rid;
  output s_axi_rlast;
  output s_axi_rvalid_reg_0;
  output s_axi_arready;
  output s_axi_bvalid;
  input [7:0]s_axi_arlen;
  input clk;
  input [13:0]w_word_addr;
  input [31:0]s_axi_wdata;
  input [1:0]s_axi_awburst;
  input [2:0]s_axi_awsize;
  input [3:0]s_axi_awid;
  input [3:0]s_axi_arid;
  input s_axi_arvalid;
  input s_axi_rready;
  input rst_n;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input s_axi_bready;
  input s_axi_wlast;
  input [17:0]s_axi_awaddr;
  input [3:0]s_axi_wstrb;

  wire [5:0]A;
  wire \FSM_onehot_wstate[0]_i_1_n_0 ;
  wire \FSM_onehot_wstate_reg_n_0_[2] ;
  wire bram_reg_0_3_i_1_n_0;
  wire bram_reg_12_1_i_1_n_0;
  wire bram_reg_14_3_i_1_n_0;
  wire bram_reg_15_3_i_1_n_0;
  wire bram_reg_2_1_i_1_n_0;
  wire bram_reg_4_3_i_1_n_0;
  wire bram_reg_7_1_i_1_n_0;
  wire bram_reg_9_3_i_1_n_0;
  wire clk;
  wire i__carry__0_i_3_n_0;
  wire i__carry__0_i_4_n_0;
  wire i__carry__0_i_5_n_0;
  wire i__carry__0_i_6_n_0;
  wire i__carry__0_i_7_n_0;
  wire i__carry_i_10_n_0;
  wire i__carry_i_11_n_0;
  wire i__carry_i_5_n_0;
  wire i__carry_i_6_n_0;
  wire i__carry_i_7_n_0;
  wire i__carry_i_8_n_0;
  wire i__carry_i_9_n_0;
  wire [17:0]in5;
  wire [3:0]p_0_in;
  wire [3:2]p_0_in__0;
  wire \p_0_out_inferred__0/i__carry__0_n_2 ;
  wire \p_0_out_inferred__0/i__carry__0_n_3 ;
  wire \p_0_out_inferred__0/i__carry__0_n_5 ;
  wire \p_0_out_inferred__0/i__carry__0_n_6 ;
  wire \p_0_out_inferred__0/i__carry__0_n_7 ;
  wire \p_0_out_inferred__0/i__carry_n_0 ;
  wire \p_0_out_inferred__0/i__carry_n_1 ;
  wire \p_0_out_inferred__0/i__carry_n_2 ;
  wire \p_0_out_inferred__0/i__carry_n_3 ;
  wire \p_0_out_inferred__0/i__carry_n_4 ;
  wire \p_0_out_inferred__0/i__carry_n_5 ;
  wire \p_0_out_inferred__0/i__carry_n_6 ;
  wire \p_0_out_inferred__0/i__carry_n_7 ;
  wire p_10_in;
  wire p_11_in;
  wire p_12_in;
  wire p_13_in;
  wire p_14_in;
  wire p_1_in;
  wire p_2_in;
  wire p_3_in;
  wire p_4_in;
  wire p_5_in;
  wire p_6_in;
  wire p_7_in;
  wire p_8_in;
  wire p_9_in;
  wire \rbeats[0]_i_1_n_0 ;
  wire \rbeats[0]_i_2_n_0 ;
  wire \rbeats[7]_i_1_n_0 ;
  wire [7:0]rbeats_reg;
  wire \rid_r[3]_i_2_n_0 ;
  wire rst_n;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire s_axi_arready_INST_0_i_1_n_0;
  wire s_axi_arvalid;
  wire [17:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire s_axi_bvalid_i_1_n_0;
  wire s_axi_bvalid_i_2_n_0;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid0;
  wire s_axi_rvalid_i_1_n_0;
  wire s_axi_rvalid_i_2_n_0;
  wire s_axi_rvalid_reg_0;
  wire [31:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire [127:0]w_word;
  wire [13:0]w_word_addr;
  wire [0:0]waddr;
  wire \waddr[0]_i_1_n_0 ;
  wire \waddr[10]_i_1_n_0 ;
  wire \waddr[10]_rep_i_1__0_n_0 ;
  wire \waddr[10]_rep_i_1__1_n_0 ;
  wire \waddr[10]_rep_i_1__2_n_0 ;
  wire \waddr[10]_rep_i_1__3_n_0 ;
  wire \waddr[10]_rep_i_1__4_n_0 ;
  wire \waddr[10]_rep_i_1__5_n_0 ;
  wire \waddr[10]_rep_i_1_n_0 ;
  wire \waddr[11]_i_1_n_0 ;
  wire \waddr[11]_rep_i_1__0_n_0 ;
  wire \waddr[11]_rep_i_1__1_n_0 ;
  wire \waddr[11]_rep_i_1__2_n_0 ;
  wire \waddr[11]_rep_i_1__3_n_0 ;
  wire \waddr[11]_rep_i_1__4_n_0 ;
  wire \waddr[11]_rep_i_1__5_n_0 ;
  wire \waddr[11]_rep_i_1_n_0 ;
  wire \waddr[12]_i_1_n_0 ;
  wire \waddr[12]_rep_i_1__0_n_0 ;
  wire \waddr[12]_rep_i_1__1_n_0 ;
  wire \waddr[12]_rep_i_1__2_n_0 ;
  wire \waddr[12]_rep_i_1__3_n_0 ;
  wire \waddr[12]_rep_i_1__4_n_0 ;
  wire \waddr[12]_rep_i_1__5_n_0 ;
  wire \waddr[12]_rep_i_1_n_0 ;
  wire \waddr[13]_i_1_n_0 ;
  wire \waddr[13]_rep_i_1__0_n_0 ;
  wire \waddr[13]_rep_i_1__1_n_0 ;
  wire \waddr[13]_rep_i_1__2_n_0 ;
  wire \waddr[13]_rep_i_1__3_n_0 ;
  wire \waddr[13]_rep_i_1__4_n_0 ;
  wire \waddr[13]_rep_i_1__5_n_0 ;
  wire \waddr[13]_rep_i_1_n_0 ;
  wire \waddr[14]_i_1_n_0 ;
  wire \waddr[14]_rep_i_1__0_n_0 ;
  wire \waddr[14]_rep_i_1__1_n_0 ;
  wire \waddr[14]_rep_i_1__2_n_0 ;
  wire \waddr[14]_rep_i_1__3_n_0 ;
  wire \waddr[14]_rep_i_1__4_n_0 ;
  wire \waddr[14]_rep_i_1__5_n_0 ;
  wire \waddr[14]_rep_i_1_n_0 ;
  wire \waddr[15]_i_1_n_0 ;
  wire \waddr[15]_rep_i_1__0_n_0 ;
  wire \waddr[15]_rep_i_1__1_n_0 ;
  wire \waddr[15]_rep_i_1__2_n_0 ;
  wire \waddr[15]_rep_i_1__3_n_0 ;
  wire \waddr[15]_rep_i_1__4_n_0 ;
  wire \waddr[15]_rep_i_1__5_n_0 ;
  wire \waddr[15]_rep_i_1_n_0 ;
  wire \waddr[16]_i_1_n_0 ;
  wire \waddr[16]_rep_i_1__0_n_0 ;
  wire \waddr[16]_rep_i_1__1_n_0 ;
  wire \waddr[16]_rep_i_1__2_n_0 ;
  wire \waddr[16]_rep_i_1__3_n_0 ;
  wire \waddr[16]_rep_i_1__4_n_0 ;
  wire \waddr[16]_rep_i_1__5_n_0 ;
  wire \waddr[16]_rep_i_1_n_0 ;
  wire \waddr[17]_i_2_n_0 ;
  wire \waddr[17]_rep_i_1__0_n_0 ;
  wire \waddr[17]_rep_i_1__1_n_0 ;
  wire \waddr[17]_rep_i_1__2_n_0 ;
  wire \waddr[17]_rep_i_1__3_n_0 ;
  wire \waddr[17]_rep_i_1__4_n_0 ;
  wire \waddr[17]_rep_i_1__5_n_0 ;
  wire \waddr[17]_rep_i_1_n_0 ;
  wire \waddr[1]_i_1_n_0 ;
  wire \waddr[2]_i_1_n_0 ;
  wire \waddr[3]_i_1_n_0 ;
  wire \waddr[3]_i_3_n_0 ;
  wire \waddr[3]_i_4_n_0 ;
  wire \waddr[3]_i_5_n_0 ;
  wire \waddr[3]_i_6_n_0 ;
  wire \waddr[4]_i_1_n_0 ;
  wire \waddr[4]_rep__0_i_1_n_0 ;
  wire \waddr[4]_rep_i_1_n_0 ;
  wire \waddr[5]_i_1_n_0 ;
  wire \waddr[5]_rep__0_i_1_n_0 ;
  wire \waddr[5]_rep_i_1_n_0 ;
  wire \waddr[6]_i_1_n_0 ;
  wire \waddr[6]_rep__0_i_1_n_0 ;
  wire \waddr[6]_rep_i_1_n_0 ;
  wire \waddr[7]_i_1_n_0 ;
  wire \waddr[7]_i_3_n_0 ;
  wire \waddr[7]_i_4_n_0 ;
  wire \waddr[7]_i_5_n_0 ;
  wire \waddr[7]_i_6_n_0 ;
  wire \waddr[7]_rep__0_i_1_n_0 ;
  wire \waddr[7]_rep_i_1_n_0 ;
  wire \waddr[8]_i_1_n_0 ;
  wire \waddr[8]_rep__0_i_1_n_0 ;
  wire \waddr[8]_rep__1_i_1_n_0 ;
  wire \waddr[8]_rep__2_i_1_n_0 ;
  wire \waddr[8]_rep__3_i_1_n_0 ;
  wire \waddr[8]_rep__4_i_1_n_0 ;
  wire \waddr[8]_rep__5_i_1_n_0 ;
  wire \waddr[8]_rep_i_1_n_0 ;
  wire \waddr[9]_i_1_n_0 ;
  wire \waddr[9]_rep_i_1__0_n_0 ;
  wire \waddr[9]_rep_i_1__1_n_0 ;
  wire \waddr[9]_rep_i_1__2_n_0 ;
  wire \waddr[9]_rep_i_1__3_n_0 ;
  wire \waddr[9]_rep_i_1__4_n_0 ;
  wire \waddr[9]_rep_i_1__5_n_0 ;
  wire \waddr[9]_rep_i_1_n_0 ;
  wire \waddr_reg[10]_rep__0_n_0 ;
  wire \waddr_reg[10]_rep__1_n_0 ;
  wire \waddr_reg[10]_rep__2_n_0 ;
  wire \waddr_reg[10]_rep__3_n_0 ;
  wire \waddr_reg[10]_rep__4_n_0 ;
  wire \waddr_reg[10]_rep__5_n_0 ;
  wire \waddr_reg[10]_rep_n_0 ;
  wire \waddr_reg[11]_i_2_n_0 ;
  wire \waddr_reg[11]_i_2_n_1 ;
  wire \waddr_reg[11]_i_2_n_2 ;
  wire \waddr_reg[11]_i_2_n_3 ;
  wire \waddr_reg[11]_rep__0_n_0 ;
  wire \waddr_reg[11]_rep__1_n_0 ;
  wire \waddr_reg[11]_rep__2_n_0 ;
  wire \waddr_reg[11]_rep__3_n_0 ;
  wire \waddr_reg[11]_rep__4_n_0 ;
  wire \waddr_reg[11]_rep__5_n_0 ;
  wire \waddr_reg[11]_rep_n_0 ;
  wire \waddr_reg[12]_rep__0_n_0 ;
  wire \waddr_reg[12]_rep__1_n_0 ;
  wire \waddr_reg[12]_rep__2_n_0 ;
  wire \waddr_reg[12]_rep__3_n_0 ;
  wire \waddr_reg[12]_rep__4_n_0 ;
  wire \waddr_reg[12]_rep__5_n_0 ;
  wire \waddr_reg[12]_rep_n_0 ;
  wire \waddr_reg[13]_rep__0_n_0 ;
  wire \waddr_reg[13]_rep__1_n_0 ;
  wire \waddr_reg[13]_rep__2_n_0 ;
  wire \waddr_reg[13]_rep__3_n_0 ;
  wire \waddr_reg[13]_rep__4_n_0 ;
  wire \waddr_reg[13]_rep__5_n_0 ;
  wire \waddr_reg[13]_rep_n_0 ;
  wire \waddr_reg[14]_rep__0_n_0 ;
  wire \waddr_reg[14]_rep__1_n_0 ;
  wire \waddr_reg[14]_rep__2_n_0 ;
  wire \waddr_reg[14]_rep__3_n_0 ;
  wire \waddr_reg[14]_rep__4_n_0 ;
  wire \waddr_reg[14]_rep__5_n_0 ;
  wire \waddr_reg[14]_rep_n_0 ;
  wire \waddr_reg[15]_i_2_n_0 ;
  wire \waddr_reg[15]_i_2_n_1 ;
  wire \waddr_reg[15]_i_2_n_2 ;
  wire \waddr_reg[15]_i_2_n_3 ;
  wire \waddr_reg[15]_rep__0_n_0 ;
  wire \waddr_reg[15]_rep__1_n_0 ;
  wire \waddr_reg[15]_rep__2_n_0 ;
  wire \waddr_reg[15]_rep__3_n_0 ;
  wire \waddr_reg[15]_rep__4_n_0 ;
  wire \waddr_reg[15]_rep__5_n_0 ;
  wire \waddr_reg[15]_rep_n_0 ;
  wire \waddr_reg[16]_rep__0_n_0 ;
  wire \waddr_reg[16]_rep__1_n_0 ;
  wire \waddr_reg[16]_rep__2_n_0 ;
  wire \waddr_reg[16]_rep__3_n_0 ;
  wire \waddr_reg[16]_rep__4_n_0 ;
  wire \waddr_reg[16]_rep__5_n_0 ;
  wire \waddr_reg[16]_rep_n_0 ;
  wire \waddr_reg[17]_i_3_n_3 ;
  wire \waddr_reg[17]_rep__0_n_0 ;
  wire \waddr_reg[17]_rep__1_n_0 ;
  wire \waddr_reg[17]_rep__2_n_0 ;
  wire \waddr_reg[17]_rep__3_n_0 ;
  wire \waddr_reg[17]_rep__4_n_0 ;
  wire \waddr_reg[17]_rep__5_n_0 ;
  wire \waddr_reg[17]_rep_n_0 ;
  wire \waddr_reg[3]_i_2_n_0 ;
  wire \waddr_reg[3]_i_2_n_1 ;
  wire \waddr_reg[3]_i_2_n_2 ;
  wire \waddr_reg[3]_i_2_n_3 ;
  wire \waddr_reg[4]_rep__0_n_0 ;
  wire \waddr_reg[4]_rep_n_0 ;
  wire \waddr_reg[5]_rep__0_n_0 ;
  wire \waddr_reg[5]_rep_n_0 ;
  wire \waddr_reg[6]_rep__0_n_0 ;
  wire \waddr_reg[6]_rep_n_0 ;
  wire \waddr_reg[7]_i_2_n_0 ;
  wire \waddr_reg[7]_i_2_n_1 ;
  wire \waddr_reg[7]_i_2_n_2 ;
  wire \waddr_reg[7]_i_2_n_3 ;
  wire \waddr_reg[7]_rep__0_n_0 ;
  wire \waddr_reg[7]_rep_n_0 ;
  wire \waddr_reg[8]_rep__0_n_0 ;
  wire \waddr_reg[8]_rep__1_n_0 ;
  wire \waddr_reg[8]_rep__2_n_0 ;
  wire \waddr_reg[8]_rep__3_n_0 ;
  wire \waddr_reg[8]_rep__4_n_0 ;
  wire \waddr_reg[8]_rep__5_n_0 ;
  wire \waddr_reg[8]_rep_n_0 ;
  wire \waddr_reg[9]_rep__0_n_0 ;
  wire \waddr_reg[9]_rep__1_n_0 ;
  wire \waddr_reg[9]_rep__2_n_0 ;
  wire \waddr_reg[9]_rep__3_n_0 ;
  wire \waddr_reg[9]_rep__4_n_0 ;
  wire \waddr_reg[9]_rep__5_n_0 ;
  wire \waddr_reg[9]_rep_n_0 ;
  wire \waddr_reg_n_0_[0] ;
  wire \waddr_reg_n_0_[1] ;
  wire [1:0]wburst;
  wire [0:0]wid;
  wire [13:0]wr_word;
  wire [2:0]wsize;
  wire [0:0]wstate;
  wire \wstate[0]_i_1_n_0 ;
  wire \wstate[1]_i_1_n_0 ;
  wire NLW_bram_reg_0_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_0_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_0_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_0_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_0_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_0_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_0_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_0_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_0_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_0_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_0_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_0_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_0_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_0_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_0_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_0_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_0_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_0_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_0_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_0_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_0_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_0_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_0_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_0_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_0_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_0_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_0_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_0_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_0_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_0_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_10_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_10_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_10_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_10_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_10_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_10_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_10_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_10_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_10_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_10_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_10_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_10_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_10_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_10_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_10_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_10_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_10_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_10_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_10_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_10_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_10_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_10_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_10_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_10_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_10_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_10_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_10_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_10_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_10_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_10_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_11_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_11_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_11_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_11_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_11_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_11_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_11_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_11_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_11_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_11_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_11_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_11_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_11_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_11_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_11_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_11_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_11_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_11_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_11_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_11_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_11_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_11_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_11_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_11_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_11_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_11_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_11_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_11_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_11_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_11_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_12_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_12_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_12_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_12_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_12_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_12_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_12_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_12_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_12_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_12_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_12_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_12_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_12_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_12_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_12_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_12_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_12_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_12_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_12_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_12_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_12_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_12_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_12_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_12_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_12_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_12_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_12_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_12_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_12_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_12_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_13_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_13_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_13_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_13_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_13_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_13_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_13_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_13_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_13_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_13_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_13_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_13_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_13_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_13_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_13_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_13_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_13_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_13_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_13_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_13_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_13_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_13_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_13_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_13_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_13_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_13_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_13_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_13_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_13_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_13_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_14_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_14_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_14_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_14_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_14_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_14_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_14_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_14_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_14_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_14_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_14_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_14_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_14_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_14_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_14_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_14_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_14_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_14_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_14_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_14_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_14_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_14_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_14_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_14_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_14_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_14_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_14_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_14_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_14_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_14_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_15_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_15_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_15_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_15_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_15_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_15_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_15_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_15_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_15_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_15_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_15_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_15_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_15_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_15_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_15_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_15_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_15_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_15_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_15_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_15_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_15_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_15_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_15_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_15_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_15_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_15_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_15_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_15_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_15_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_15_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_1_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_1_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_1_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_1_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_1_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_1_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_1_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_1_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_1_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_1_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_1_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_1_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_1_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_1_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_1_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_1_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_1_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_1_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_1_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_1_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_1_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_1_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_1_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_1_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_1_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_1_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_1_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_1_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_1_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_1_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_2_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_2_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_2_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_2_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_2_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_2_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_2_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_2_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_2_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_2_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_2_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_2_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_2_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_2_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_2_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_2_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_2_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_2_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_2_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_2_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_2_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_2_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_2_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_2_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_2_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_2_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_2_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_2_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_2_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_2_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_3_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_3_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_3_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_3_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_3_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_3_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_3_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_3_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_3_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_3_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_3_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_3_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_3_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_3_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_3_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_3_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_3_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_3_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_3_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_3_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_3_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_3_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_3_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_3_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_3_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_3_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_3_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_3_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_3_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_3_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_4_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_4_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_4_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_4_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_4_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_4_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_4_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_4_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_4_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_4_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_4_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_4_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_4_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_4_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_4_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_4_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_4_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_4_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_4_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_4_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_4_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_4_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_4_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_4_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_4_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_4_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_4_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_4_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_4_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_4_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_5_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_5_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_5_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_5_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_5_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_5_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_5_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_5_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_5_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_5_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_5_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_5_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_5_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_5_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_5_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_5_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_5_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_5_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_5_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_5_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_5_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_5_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_5_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_5_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_5_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_5_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_5_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_5_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_5_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_5_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_6_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_6_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_6_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_6_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_6_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_6_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_6_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_6_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_6_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_6_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_6_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_6_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_6_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_6_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_6_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_6_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_6_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_6_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_6_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_6_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_6_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_6_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_6_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_6_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_6_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_6_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_6_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_6_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_6_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_6_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_7_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_7_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_7_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_7_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_7_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_7_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_7_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_7_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_7_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_7_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_7_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_7_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_7_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_7_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_7_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_7_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_7_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_7_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_7_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_7_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_7_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_7_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_7_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_7_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_7_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_7_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_7_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_7_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_7_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_7_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_8_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_8_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_8_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_8_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_8_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_8_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_8_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_8_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_8_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_8_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_8_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_8_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_8_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_8_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_8_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_8_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_8_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_8_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_8_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_8_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_8_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_8_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_8_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_8_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_8_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_8_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_8_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_8_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_8_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_8_3_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_9_0_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_9_0_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_9_0_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_0_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_0_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_0_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_9_0_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_9_0_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_0_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_0_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_9_0_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_9_0_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_9_1_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_9_1_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_9_1_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_1_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_1_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_1_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_9_1_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_9_1_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_1_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_1_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_9_1_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_9_1_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_9_2_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_9_2_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_9_2_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_2_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_2_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_2_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_9_2_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_9_2_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_2_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_2_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_9_2_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_9_2_RDADDRECC_UNCONNECTED;
  wire NLW_bram_reg_9_3_CASCADEOUTA_UNCONNECTED;
  wire NLW_bram_reg_9_3_CASCADEOUTB_UNCONNECTED;
  wire NLW_bram_reg_9_3_DBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_3_INJECTDBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_3_INJECTSBITERR_UNCONNECTED;
  wire NLW_bram_reg_9_3_SBITERR_UNCONNECTED;
  wire [31:0]NLW_bram_reg_9_3_DOADO_UNCONNECTED;
  wire [31:2]NLW_bram_reg_9_3_DOBDO_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_3_DOPADOP_UNCONNECTED;
  wire [3:0]NLW_bram_reg_9_3_DOPBDOP_UNCONNECTED;
  wire [7:0]NLW_bram_reg_9_3_ECCPARITY_UNCONNECTED;
  wire [8:0]NLW_bram_reg_9_3_RDADDRECC_UNCONNECTED;
  wire [3:2]\NLW_p_0_out_inferred__0/i__carry__0_CO_UNCONNECTED ;
  wire [3:3]\NLW_p_0_out_inferred__0/i__carry__0_O_UNCONNECTED ;
  wire [3:1]\NLW_waddr_reg[17]_i_3_CO_UNCONNECTED ;
  wire [3:2]\NLW_waddr_reg[17]_i_3_O_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \FSM_onehot_wstate[0]_i_1 
       (.I0(rst_n),
        .O(\FSM_onehot_wstate[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFEAEAEAEAEAEAEA)) 
    \FSM_onehot_wstate[0]_i_2 
       (.I0(wid),
        .I1(s_axi_bready),
        .I2(\FSM_onehot_wstate_reg_n_0_[2] ),
        .I3(s_axi_wlast),
        .I4(s_axi_wvalid),
        .I5(s_axi_wready),
        .O(wstate));
  (* FSM_ENCODED_STATES = "W_IDLE:001,W_DATA:010,W_RESP:100," *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_wstate_reg[0] 
       (.C(clk),
        .CE(wstate),
        .D(\FSM_onehot_wstate_reg_n_0_[2] ),
        .Q(s_axi_awready),
        .S(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "W_IDLE:001,W_DATA:010,W_RESP:100," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[1] 
       (.C(clk),
        .CE(wstate),
        .D(s_axi_awready),
        .Q(s_axi_wready),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "W_IDLE:001,W_DATA:010,W_RESP:100," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_wstate_reg[2] 
       (.C(clk),
        .CE(wstate),
        .D(s_axi_wready),
        .Q(\FSM_onehot_wstate_reg_n_0_[2] ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "1" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_0_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_0_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_0_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_0_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[1:0]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_0_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_0_0_DOBDO_UNCONNECTED[31:2],w_word[1:0]}),
        .DOPADOP(NLW_bram_reg_0_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_0_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_0_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_0_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_0_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_0_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_0_0_SBITERR_UNCONNECTED),
        .WEA({bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "2" *) 
  (* ram_slice_end = "3" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_0_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_0_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_0_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_0_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[3:2]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_0_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_0_1_DOBDO_UNCONNECTED[31:2],w_word[3:2]}),
        .DOPADOP(NLW_bram_reg_0_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_0_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_0_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_0_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_0_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_0_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_0_1_SBITERR_UNCONNECTED),
        .WEA({bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "4" *) 
  (* ram_slice_end = "5" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_0_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_0_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_0_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_0_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[5:4]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_0_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_0_2_DOBDO_UNCONNECTED[31:2],w_word[5:4]}),
        .DOPADOP(NLW_bram_reg_0_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_0_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_0_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_0_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_0_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_0_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_0_2_SBITERR_UNCONNECTED),
        .WEA({bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "7" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_0_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_0_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_0_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_0_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[7:6]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_0_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_0_3_DOBDO_UNCONNECTED[31:2],w_word[7:6]}),
        .DOPADOP(NLW_bram_reg_0_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_0_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_0_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_0_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_0_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_0_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_0_3_SBITERR_UNCONNECTED),
        .WEA({bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0,bram_reg_0_3_i_1_n_0}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h10)) 
    bram_reg_0_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[0]),
        .O(bram_reg_0_3_i_1_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "80" *) 
  (* ram_slice_end = "81" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_10_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_10_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_10_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_10_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[17:16]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_10_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_10_0_DOBDO_UNCONNECTED[31:2],w_word[81:80]}),
        .DOPADOP(NLW_bram_reg_10_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_10_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_10_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_10_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_10_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_10_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_10_0_SBITERR_UNCONNECTED),
        .WEA({p_10_in,p_10_in,p_10_in,p_10_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "82" *) 
  (* ram_slice_end = "83" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_10_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_10_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_10_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_10_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[19:18]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_10_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_10_1_DOBDO_UNCONNECTED[31:2],w_word[83:82]}),
        .DOPADOP(NLW_bram_reg_10_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_10_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_10_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_10_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_10_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_10_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_10_1_SBITERR_UNCONNECTED),
        .WEA({p_10_in,p_10_in,p_10_in,p_10_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "84" *) 
  (* ram_slice_end = "85" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_10_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_10_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_10_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_10_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[21:20]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_10_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_10_2_DOBDO_UNCONNECTED[31:2],w_word[85:84]}),
        .DOPADOP(NLW_bram_reg_10_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_10_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_10_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_10_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_10_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_10_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_10_2_SBITERR_UNCONNECTED),
        .WEA({p_10_in,p_10_in,p_10_in,p_10_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "86" *) 
  (* ram_slice_end = "87" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_10_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_10_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_10_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_10_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[23:22]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_10_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_10_3_DOBDO_UNCONNECTED[31:2],w_word[87:86]}),
        .DOPADOP(NLW_bram_reg_10_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_10_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_10_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_10_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_10_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_10_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_10_3_SBITERR_UNCONNECTED),
        .WEA({p_10_in,p_10_in,p_10_in,p_10_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_10_3_i_1
       (.I0(p_0_in__0[2]),
        .I1(p_0_in__0[3]),
        .I2(s_axi_wstrb[2]),
        .O(p_10_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "88" *) 
  (* ram_slice_end = "89" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_11_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_11_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_11_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_11_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[25:24]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_11_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_11_0_DOBDO_UNCONNECTED[31:2],w_word[89:88]}),
        .DOPADOP(NLW_bram_reg_11_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_11_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_11_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_11_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_11_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_11_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_11_0_SBITERR_UNCONNECTED),
        .WEA({p_11_in,p_11_in,p_11_in,p_11_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "90" *) 
  (* ram_slice_end = "91" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_11_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_11_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_11_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_11_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[27:26]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_11_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_11_1_DOBDO_UNCONNECTED[31:2],w_word[91:90]}),
        .DOPADOP(NLW_bram_reg_11_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_11_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_11_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_11_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_11_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_11_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_11_1_SBITERR_UNCONNECTED),
        .WEA({p_11_in,p_11_in,p_11_in,p_11_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "92" *) 
  (* ram_slice_end = "93" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_11_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_11_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_11_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_11_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[29:28]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_11_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_11_2_DOBDO_UNCONNECTED[31:2],w_word[93:92]}),
        .DOPADOP(NLW_bram_reg_11_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_11_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_11_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_11_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_11_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_11_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_11_2_SBITERR_UNCONNECTED),
        .WEA({p_11_in,p_11_in,p_11_in,p_11_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "94" *) 
  (* ram_slice_end = "95" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_11_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_11_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_11_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_11_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[31:30]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_11_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_11_3_DOBDO_UNCONNECTED[31:2],w_word[95:94]}),
        .DOPADOP(NLW_bram_reg_11_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_11_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_11_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_11_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_11_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_11_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_11_3_SBITERR_UNCONNECTED),
        .WEA({p_11_in,p_11_in,p_11_in,p_11_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_11_3_i_1
       (.I0(p_0_in__0[2]),
        .I1(p_0_in__0[3]),
        .I2(s_axi_wstrb[3]),
        .O(p_11_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "96" *) 
  (* ram_slice_end = "97" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_12_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_12_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_12_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_12_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[1:0]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_12_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_12_0_DOBDO_UNCONNECTED[31:2],w_word[97:96]}),
        .DOPADOP(NLW_bram_reg_12_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_12_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_12_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_12_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_12_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_12_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_12_0_SBITERR_UNCONNECTED),
        .WEA({p_12_in,p_12_in,p_12_in,p_12_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "98" *) 
  (* ram_slice_end = "99" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_12_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__3_n_0 ,\waddr_reg[16]_rep__3_n_0 ,\waddr_reg[15]_rep__3_n_0 ,\waddr_reg[14]_rep__3_n_0 ,\waddr_reg[13]_rep__3_n_0 ,\waddr_reg[12]_rep__3_n_0 ,\waddr_reg[11]_rep__3_n_0 ,\waddr_reg[10]_rep__3_n_0 ,\waddr_reg[9]_rep__3_n_0 ,\waddr_reg[8]_rep__3_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_12_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_12_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_12_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[3:2]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_12_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_12_1_DOBDO_UNCONNECTED[31:2],w_word[99:98]}),
        .DOPADOP(NLW_bram_reg_12_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_12_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_12_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_12_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_12_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_12_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_12_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_12_1_SBITERR_UNCONNECTED),
        .WEA({p_12_in,p_12_in,p_12_in,p_12_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_12_1_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_12_1_i_1_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "100" *) 
  (* ram_slice_end = "101" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_12_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_12_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_12_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_12_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[5:4]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_12_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_12_2_DOBDO_UNCONNECTED[31:2],w_word[101:100]}),
        .DOPADOP(NLW_bram_reg_12_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_12_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_12_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_12_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_12_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_12_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_12_2_SBITERR_UNCONNECTED),
        .WEA({p_12_in,p_12_in,p_12_in,p_12_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "102" *) 
  (* ram_slice_end = "103" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_12_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_12_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_12_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_12_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[7:6]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_12_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_12_3_DOBDO_UNCONNECTED[31:2],w_word[103:102]}),
        .DOPADOP(NLW_bram_reg_12_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_12_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_12_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_12_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_12_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_12_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_12_3_SBITERR_UNCONNECTED),
        .WEA({p_12_in,p_12_in,p_12_in,p_12_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h80)) 
    bram_reg_12_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[0]),
        .O(p_12_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "104" *) 
  (* ram_slice_end = "105" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_13_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_13_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_13_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_13_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[9:8]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_13_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_13_0_DOBDO_UNCONNECTED[31:2],w_word[105:104]}),
        .DOPADOP(NLW_bram_reg_13_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_13_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_13_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_13_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_13_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_13_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_13_0_SBITERR_UNCONNECTED),
        .WEA({p_13_in,p_13_in,p_13_in,p_13_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "106" *) 
  (* ram_slice_end = "107" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_13_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_13_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_13_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_13_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[11:10]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_13_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_13_1_DOBDO_UNCONNECTED[31:2],w_word[107:106]}),
        .DOPADOP(NLW_bram_reg_13_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_13_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_13_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_13_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_13_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_13_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_13_1_SBITERR_UNCONNECTED),
        .WEA({p_13_in,p_13_in,p_13_in,p_13_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "108" *) 
  (* ram_slice_end = "109" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_13_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_13_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_13_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_13_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[13:12]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_13_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_13_2_DOBDO_UNCONNECTED[31:2],w_word[109:108]}),
        .DOPADOP(NLW_bram_reg_13_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_13_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_13_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_13_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_13_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_13_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_13_2_SBITERR_UNCONNECTED),
        .WEA({p_13_in,p_13_in,p_13_in,p_13_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "110" *) 
  (* ram_slice_end = "111" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_13_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_13_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_13_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_13_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[15:14]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_13_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_13_3_DOBDO_UNCONNECTED[31:2],w_word[111:110]}),
        .DOPADOP(NLW_bram_reg_13_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_13_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_13_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_13_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_13_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_13_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_13_3_SBITERR_UNCONNECTED),
        .WEA({p_13_in,p_13_in,p_13_in,p_13_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h80)) 
    bram_reg_13_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[1]),
        .O(p_13_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "112" *) 
  (* ram_slice_end = "113" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_14_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_14_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_14_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_14_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[17:16]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_14_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_14_0_DOBDO_UNCONNECTED[31:2],w_word[113:112]}),
        .DOPADOP(NLW_bram_reg_14_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_14_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_14_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_14_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_14_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_14_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_14_0_SBITERR_UNCONNECTED),
        .WEA({p_14_in,p_14_in,p_14_in,p_14_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "114" *) 
  (* ram_slice_end = "115" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_14_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_14_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_14_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_14_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[19:18]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_14_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_14_1_DOBDO_UNCONNECTED[31:2],w_word[115:114]}),
        .DOPADOP(NLW_bram_reg_14_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_14_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_14_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_14_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_14_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_14_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_14_1_SBITERR_UNCONNECTED),
        .WEA({p_14_in,p_14_in,p_14_in,p_14_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "116" *) 
  (* ram_slice_end = "117" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_14_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_14_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_14_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_14_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[21:20]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_14_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_14_2_DOBDO_UNCONNECTED[31:2],w_word[117:116]}),
        .DOPADOP(NLW_bram_reg_14_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_14_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_14_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_14_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_14_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_14_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_14_2_SBITERR_UNCONNECTED),
        .WEA({p_14_in,p_14_in,p_14_in,p_14_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "118" *) 
  (* ram_slice_end = "119" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_14_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__4_n_0 ,\waddr_reg[16]_rep__4_n_0 ,\waddr_reg[15]_rep__4_n_0 ,\waddr_reg[14]_rep__4_n_0 ,\waddr_reg[13]_rep__4_n_0 ,\waddr_reg[12]_rep__4_n_0 ,\waddr_reg[11]_rep__4_n_0 ,\waddr_reg[10]_rep__4_n_0 ,\waddr_reg[9]_rep__4_n_0 ,\waddr_reg[8]_rep__4_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_14_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_14_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_14_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[23:22]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_14_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_14_3_DOBDO_UNCONNECTED[31:2],w_word[119:118]}),
        .DOPADOP(NLW_bram_reg_14_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_14_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_14_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_14_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_14_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_14_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_14_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_14_3_SBITERR_UNCONNECTED),
        .WEA({p_14_in,p_14_in,p_14_in,p_14_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_14_3_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_14_3_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    bram_reg_14_3_i_2
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[2]),
        .O(p_14_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "120" *) 
  (* ram_slice_end = "121" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_15_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__5_n_0 ,\waddr_reg[16]_rep__5_n_0 ,\waddr_reg[15]_rep__5_n_0 ,\waddr_reg[14]_rep__5_n_0 ,\waddr_reg[13]_rep__5_n_0 ,\waddr_reg[12]_rep__5_n_0 ,\waddr_reg[11]_rep__5_n_0 ,\waddr_reg[10]_rep__5_n_0 ,\waddr_reg[9]_rep__5_n_0 ,\waddr_reg[8]_rep__5_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_15_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_15_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_15_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[25:24]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_15_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_15_0_DOBDO_UNCONNECTED[31:2],w_word[121:120]}),
        .DOPADOP(NLW_bram_reg_15_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_15_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_15_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_15_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_15_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_15_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_15_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_15_0_SBITERR_UNCONNECTED),
        .WEA({p_0_in[0],p_0_in[0],p_0_in[0],p_0_in[0]}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "122" *) 
  (* ram_slice_end = "123" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_15_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__5_n_0 ,\waddr_reg[16]_rep__5_n_0 ,\waddr_reg[15]_rep__5_n_0 ,\waddr_reg[14]_rep__5_n_0 ,\waddr_reg[13]_rep__5_n_0 ,\waddr_reg[12]_rep__5_n_0 ,\waddr_reg[11]_rep__5_n_0 ,\waddr_reg[10]_rep__5_n_0 ,\waddr_reg[9]_rep__5_n_0 ,\waddr_reg[8]_rep__5_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_15_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_15_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_15_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[27:26]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_15_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_15_1_DOBDO_UNCONNECTED[31:2],w_word[123:122]}),
        .DOPADOP(NLW_bram_reg_15_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_15_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_15_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_15_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_15_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_15_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_15_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_15_1_SBITERR_UNCONNECTED),
        .WEA({p_0_in[0],p_0_in[0],p_0_in[0],p_0_in[0]}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "124" *) 
  (* ram_slice_end = "125" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_15_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__5_n_0 ,\waddr_reg[16]_rep__5_n_0 ,\waddr_reg[15]_rep__5_n_0 ,\waddr_reg[14]_rep__5_n_0 ,\waddr_reg[13]_rep__5_n_0 ,\waddr_reg[12]_rep__5_n_0 ,\waddr_reg[11]_rep__5_n_0 ,\waddr_reg[10]_rep__5_n_0 ,\waddr_reg[9]_rep__5_n_0 ,\waddr_reg[8]_rep__5_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_15_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_15_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_15_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[29:28]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_15_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_15_2_DOBDO_UNCONNECTED[31:2],w_word[125:124]}),
        .DOPADOP(NLW_bram_reg_15_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_15_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_15_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_15_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_15_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_15_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_15_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_15_2_SBITERR_UNCONNECTED),
        .WEA({p_0_in[0],p_0_in[0],p_0_in[0],p_0_in[0]}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "126" *) 
  (* ram_slice_end = "127" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_15_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__5_n_0 ,\waddr_reg[16]_rep__5_n_0 ,\waddr_reg[15]_rep__5_n_0 ,\waddr_reg[14]_rep__5_n_0 ,\waddr_reg[13]_rep__5_n_0 ,\waddr_reg[12]_rep__5_n_0 ,\waddr_reg[11]_rep__5_n_0 ,\waddr_reg[10]_rep__5_n_0 ,\waddr_reg[9]_rep__5_n_0 ,\waddr_reg[8]_rep__5_n_0 ,\waddr_reg[7]_rep__0_n_0 ,\waddr_reg[6]_rep__0_n_0 ,\waddr_reg[5]_rep__0_n_0 ,\waddr_reg[4]_rep__0_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_15_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_15_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_15_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[31:30]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_15_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_15_3_DOBDO_UNCONNECTED[31:2],w_word[127:126]}),
        .DOPADOP(NLW_bram_reg_15_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_15_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_15_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_15_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_15_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_15_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_15_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_15_3_SBITERR_UNCONNECTED),
        .WEA({p_0_in[0],p_0_in[0],p_0_in[0],p_0_in[0]}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_15_3_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_15_3_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    bram_reg_15_3_i_2
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[3]),
        .O(p_0_in[0]));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "8" *) 
  (* ram_slice_end = "9" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_1_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_1_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_1_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_1_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[9:8]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_1_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_1_0_DOBDO_UNCONNECTED[31:2],w_word[9:8]}),
        .DOPADOP(NLW_bram_reg_1_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_1_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_1_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_1_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_1_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_1_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_1_0_SBITERR_UNCONNECTED),
        .WEA({p_1_in,p_1_in,p_1_in,p_1_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "10" *) 
  (* ram_slice_end = "11" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_1_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_1_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_1_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_1_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[11:10]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_1_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_1_1_DOBDO_UNCONNECTED[31:2],w_word[11:10]}),
        .DOPADOP(NLW_bram_reg_1_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_1_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_1_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_1_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_1_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_1_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_1_1_SBITERR_UNCONNECTED),
        .WEA({p_1_in,p_1_in,p_1_in,p_1_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "12" *) 
  (* ram_slice_end = "13" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_1_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_1_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_1_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_1_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[13:12]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_1_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_1_2_DOBDO_UNCONNECTED[31:2],w_word[13:12]}),
        .DOPADOP(NLW_bram_reg_1_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_1_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_1_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_1_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_1_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_1_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_1_2_SBITERR_UNCONNECTED),
        .WEA({p_1_in,p_1_in,p_1_in,p_1_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "14" *) 
  (* ram_slice_end = "15" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_1_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_1_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_1_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_1_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[15:14]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_1_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_1_3_DOBDO_UNCONNECTED[31:2],w_word[15:14]}),
        .DOPADOP(NLW_bram_reg_1_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_1_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_1_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_1_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_1_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_1_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_1_3_SBITERR_UNCONNECTED),
        .WEA({p_1_in,p_1_in,p_1_in,p_1_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h10)) 
    bram_reg_1_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[1]),
        .O(p_1_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "16" *) 
  (* ram_slice_end = "17" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_2_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_2_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_2_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_2_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[17:16]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_2_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_2_0_DOBDO_UNCONNECTED[31:2],w_word[17:16]}),
        .DOPADOP(NLW_bram_reg_2_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_2_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_2_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_2_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_2_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_2_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_2_0_SBITERR_UNCONNECTED),
        .WEA({p_2_in,p_2_in,p_2_in,p_2_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "18" *) 
  (* ram_slice_end = "19" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_2_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep_n_0 ,\waddr_reg[16]_rep_n_0 ,\waddr_reg[15]_rep_n_0 ,\waddr_reg[14]_rep_n_0 ,\waddr_reg[13]_rep_n_0 ,\waddr_reg[12]_rep_n_0 ,\waddr_reg[11]_rep_n_0 ,\waddr_reg[10]_rep_n_0 ,\waddr_reg[9]_rep_n_0 ,\waddr_reg[8]_rep_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_2_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_2_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_2_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[19:18]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_2_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_2_1_DOBDO_UNCONNECTED[31:2],w_word[19:18]}),
        .DOPADOP(NLW_bram_reg_2_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_2_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_2_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_2_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_2_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_2_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_2_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_2_1_SBITERR_UNCONNECTED),
        .WEA({p_2_in,p_2_in,p_2_in,p_2_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_2_1_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_2_1_i_1_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "20" *) 
  (* ram_slice_end = "21" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_2_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_2_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_2_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_2_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[21:20]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_2_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_2_2_DOBDO_UNCONNECTED[31:2],w_word[21:20]}),
        .DOPADOP(NLW_bram_reg_2_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_2_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_2_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_2_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_2_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_2_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_2_2_SBITERR_UNCONNECTED),
        .WEA({p_2_in,p_2_in,p_2_in,p_2_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "22" *) 
  (* ram_slice_end = "23" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_2_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_2_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_2_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_2_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[23:22]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_2_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_2_3_DOBDO_UNCONNECTED[31:2],w_word[23:22]}),
        .DOPADOP(NLW_bram_reg_2_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_2_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_2_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_2_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_2_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_2_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_2_3_SBITERR_UNCONNECTED),
        .WEA({p_2_in,p_2_in,p_2_in,p_2_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h10)) 
    bram_reg_2_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[2]),
        .O(p_2_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "24" *) 
  (* ram_slice_end = "25" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_3_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_3_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_3_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_3_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[25:24]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_3_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_3_0_DOBDO_UNCONNECTED[31:2],w_word[25:24]}),
        .DOPADOP(NLW_bram_reg_3_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_3_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_3_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_3_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_3_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_3_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_3_0_SBITERR_UNCONNECTED),
        .WEA({p_3_in,p_3_in,p_3_in,p_3_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "26" *) 
  (* ram_slice_end = "27" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_3_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_3_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_3_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_3_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[27:26]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_3_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_3_1_DOBDO_UNCONNECTED[31:2],w_word[27:26]}),
        .DOPADOP(NLW_bram_reg_3_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_3_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_3_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_3_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_3_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_3_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_3_1_SBITERR_UNCONNECTED),
        .WEA({p_3_in,p_3_in,p_3_in,p_3_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "28" *) 
  (* ram_slice_end = "29" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_3_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_3_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_3_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_3_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[29:28]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_3_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_3_2_DOBDO_UNCONNECTED[31:2],w_word[29:28]}),
        .DOPADOP(NLW_bram_reg_3_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_3_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_3_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_3_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_3_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_3_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_3_2_SBITERR_UNCONNECTED),
        .WEA({p_3_in,p_3_in,p_3_in,p_3_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "30" *) 
  (* ram_slice_end = "31" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_3_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_3_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_3_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_3_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[31:30]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_3_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_3_3_DOBDO_UNCONNECTED[31:2],w_word[31:30]}),
        .DOPADOP(NLW_bram_reg_3_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_3_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_3_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_3_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_3_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_3_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_3_3_SBITERR_UNCONNECTED),
        .WEA({p_3_in,p_3_in,p_3_in,p_3_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h10)) 
    bram_reg_3_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[3]),
        .O(p_3_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "32" *) 
  (* ram_slice_end = "33" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_4_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_4_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_4_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_4_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[1:0]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_4_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_4_0_DOBDO_UNCONNECTED[31:2],w_word[33:32]}),
        .DOPADOP(NLW_bram_reg_4_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_4_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_4_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_4_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_4_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_4_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_4_0_SBITERR_UNCONNECTED),
        .WEA({p_4_in,p_4_in,p_4_in,p_4_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "34" *) 
  (* ram_slice_end = "35" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_4_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_4_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_4_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_4_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[3:2]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_4_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_4_1_DOBDO_UNCONNECTED[31:2],w_word[35:34]}),
        .DOPADOP(NLW_bram_reg_4_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_4_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_4_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_4_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_4_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_4_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_4_1_SBITERR_UNCONNECTED),
        .WEA({p_4_in,p_4_in,p_4_in,p_4_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "36" *) 
  (* ram_slice_end = "37" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_4_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_4_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_4_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_4_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[5:4]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_4_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_4_2_DOBDO_UNCONNECTED[31:2],w_word[37:36]}),
        .DOPADOP(NLW_bram_reg_4_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_4_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_4_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_4_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_4_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_4_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_4_2_SBITERR_UNCONNECTED),
        .WEA({p_4_in,p_4_in,p_4_in,p_4_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "38" *) 
  (* ram_slice_end = "39" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_4_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__0_n_0 ,\waddr_reg[16]_rep__0_n_0 ,\waddr_reg[15]_rep__0_n_0 ,\waddr_reg[14]_rep__0_n_0 ,\waddr_reg[13]_rep__0_n_0 ,\waddr_reg[12]_rep__0_n_0 ,\waddr_reg[11]_rep__0_n_0 ,\waddr_reg[10]_rep__0_n_0 ,\waddr_reg[9]_rep__0_n_0 ,\waddr_reg[8]_rep__0_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_4_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_4_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_4_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[7:6]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_4_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_4_3_DOBDO_UNCONNECTED[31:2],w_word[39:38]}),
        .DOPADOP(NLW_bram_reg_4_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_4_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_4_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_4_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_4_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_4_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_4_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_4_3_SBITERR_UNCONNECTED),
        .WEA({p_4_in,p_4_in,p_4_in,p_4_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_4_3_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_4_3_i_1_n_0));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_4_3_i_2
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[0]),
        .O(p_4_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "40" *) 
  (* ram_slice_end = "41" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_5_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,wr_word[3:0],1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_5_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_5_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_5_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[9:8]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_5_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_5_0_DOBDO_UNCONNECTED[31:2],w_word[41:40]}),
        .DOPADOP(NLW_bram_reg_5_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_5_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_5_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_5_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_5_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_5_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_5_0_SBITERR_UNCONNECTED),
        .WEA({p_5_in,p_5_in,p_5_in,p_5_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "42" *) 
  (* ram_slice_end = "43" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_5_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_5_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_5_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_5_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[11:10]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_5_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_5_1_DOBDO_UNCONNECTED[31:2],w_word[43:42]}),
        .DOPADOP(NLW_bram_reg_5_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_5_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_5_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_5_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_5_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_5_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_5_1_SBITERR_UNCONNECTED),
        .WEA({p_5_in,p_5_in,p_5_in,p_5_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "44" *) 
  (* ram_slice_end = "45" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_5_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_5_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_5_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_5_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[13:12]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_5_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_5_2_DOBDO_UNCONNECTED[31:2],w_word[45:44]}),
        .DOPADOP(NLW_bram_reg_5_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_5_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_5_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_5_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_5_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_5_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_5_2_SBITERR_UNCONNECTED),
        .WEA({p_5_in,p_5_in,p_5_in,p_5_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "46" *) 
  (* ram_slice_end = "47" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_5_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_5_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_5_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_5_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[15:14]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_5_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_5_3_DOBDO_UNCONNECTED[31:2],w_word[47:46]}),
        .DOPADOP(NLW_bram_reg_5_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_5_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_5_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_5_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_5_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_5_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_5_3_SBITERR_UNCONNECTED),
        .WEA({p_5_in,p_5_in,p_5_in,p_5_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_5_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[1]),
        .O(p_5_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "48" *) 
  (* ram_slice_end = "49" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_6_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_6_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_6_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_6_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[17:16]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_6_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_6_0_DOBDO_UNCONNECTED[31:2],w_word[49:48]}),
        .DOPADOP(NLW_bram_reg_6_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_6_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_6_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_6_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_6_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_6_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_6_0_SBITERR_UNCONNECTED),
        .WEA({p_6_in,p_6_in,p_6_in,p_6_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "50" *) 
  (* ram_slice_end = "51" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_6_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_6_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_6_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_6_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[19:18]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_6_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_6_1_DOBDO_UNCONNECTED[31:2],w_word[51:50]}),
        .DOPADOP(NLW_bram_reg_6_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_6_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_6_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_6_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_6_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_6_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_6_1_SBITERR_UNCONNECTED),
        .WEA({p_6_in,p_6_in,p_6_in,p_6_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "52" *) 
  (* ram_slice_end = "53" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_6_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_6_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_6_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_6_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[21:20]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_6_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_6_2_DOBDO_UNCONNECTED[31:2],w_word[53:52]}),
        .DOPADOP(NLW_bram_reg_6_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_6_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_6_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_6_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_6_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_6_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_6_2_SBITERR_UNCONNECTED),
        .WEA({p_6_in,p_6_in,p_6_in,p_6_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "54" *) 
  (* ram_slice_end = "55" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_6_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_6_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_6_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_6_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[23:22]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_6_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_6_3_DOBDO_UNCONNECTED[31:2],w_word[55:54]}),
        .DOPADOP(NLW_bram_reg_6_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_6_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_6_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_6_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_6_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_6_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_6_3_SBITERR_UNCONNECTED),
        .WEA({p_6_in,p_6_in,p_6_in,p_6_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_6_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[2]),
        .O(p_6_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "56" *) 
  (* ram_slice_end = "57" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_7_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_7_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_7_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_7_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[25:24]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_7_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_7_0_DOBDO_UNCONNECTED[31:2],w_word[57:56]}),
        .DOPADOP(NLW_bram_reg_7_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_7_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_7_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_7_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_7_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_7_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_7_0_SBITERR_UNCONNECTED),
        .WEA({p_7_in,p_7_in,p_7_in,p_7_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "58" *) 
  (* ram_slice_end = "59" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_7_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__1_n_0 ,\waddr_reg[16]_rep__1_n_0 ,\waddr_reg[15]_rep__1_n_0 ,\waddr_reg[14]_rep__1_n_0 ,\waddr_reg[13]_rep__1_n_0 ,\waddr_reg[12]_rep__1_n_0 ,\waddr_reg[11]_rep__1_n_0 ,\waddr_reg[10]_rep__1_n_0 ,\waddr_reg[9]_rep__1_n_0 ,\waddr_reg[8]_rep__1_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_7_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_7_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_7_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[27:26]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_7_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_7_1_DOBDO_UNCONNECTED[31:2],w_word[59:58]}),
        .DOPADOP(NLW_bram_reg_7_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_7_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_7_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_7_1_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_7_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_7_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_7_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_7_1_SBITERR_UNCONNECTED),
        .WEA({p_7_in,p_7_in,p_7_in,p_7_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_7_1_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_7_1_i_1_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "60" *) 
  (* ram_slice_end = "61" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_7_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_7_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_7_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_7_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[29:28]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_7_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_7_2_DOBDO_UNCONNECTED[31:2],w_word[61:60]}),
        .DOPADOP(NLW_bram_reg_7_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_7_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_7_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_7_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_7_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_7_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_7_2_SBITERR_UNCONNECTED),
        .WEA({p_7_in,p_7_in,p_7_in,p_7_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "62" *) 
  (* ram_slice_end = "63" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_7_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_7_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_7_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_7_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[31:30]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_7_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_7_3_DOBDO_UNCONNECTED[31:2],w_word[63:62]}),
        .DOPADOP(NLW_bram_reg_7_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_7_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_7_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_7_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_7_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_7_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_7_3_SBITERR_UNCONNECTED),
        .WEA({p_7_in,p_7_in,p_7_in,p_7_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_7_3_i_1
       (.I0(p_0_in__0[3]),
        .I1(p_0_in__0[2]),
        .I2(s_axi_wstrb[3]),
        .O(p_7_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "64" *) 
  (* ram_slice_end = "65" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_8_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_8_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_8_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_8_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[1:0]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_8_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_8_0_DOBDO_UNCONNECTED[31:2],w_word[65:64]}),
        .DOPADOP(NLW_bram_reg_8_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_8_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_8_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_8_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_8_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_8_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_8_0_SBITERR_UNCONNECTED),
        .WEA({p_8_in,p_8_in,p_8_in,p_8_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "66" *) 
  (* ram_slice_end = "67" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_8_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_8_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_8_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_8_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[3:2]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_8_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_8_1_DOBDO_UNCONNECTED[31:2],w_word[67:66]}),
        .DOPADOP(NLW_bram_reg_8_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_8_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_8_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_8_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_8_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_8_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_8_1_SBITERR_UNCONNECTED),
        .WEA({p_8_in,p_8_in,p_8_in,p_8_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "68" *) 
  (* ram_slice_end = "69" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_8_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_8_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_8_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_8_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[5:4]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_8_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_8_2_DOBDO_UNCONNECTED[31:2],w_word[69:68]}),
        .DOPADOP(NLW_bram_reg_8_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_8_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_8_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_8_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_8_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_8_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_8_2_SBITERR_UNCONNECTED),
        .WEA({p_8_in,p_8_in,p_8_in,p_8_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "70" *) 
  (* ram_slice_end = "71" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_8_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_8_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_8_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_8_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[7:6]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_8_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_8_3_DOBDO_UNCONNECTED[31:2],w_word[71:70]}),
        .DOPADOP(NLW_bram_reg_8_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_8_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_8_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_8_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_8_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_8_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_8_3_SBITERR_UNCONNECTED),
        .WEA({p_8_in,p_8_in,p_8_in,p_8_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_8_3_i_1
       (.I0(p_0_in__0[2]),
        .I1(p_0_in__0[3]),
        .I2(s_axi_wstrb[0]),
        .O(p_8_in));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "72" *) 
  (* ram_slice_end = "73" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_9_0
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_9_0_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_9_0_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_9_0_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[9:8]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_9_0_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_9_0_DOBDO_UNCONNECTED[31:2],w_word[73:72]}),
        .DOPADOP(NLW_bram_reg_9_0_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_9_0_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_9_0_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_9_0_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_9_0_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_9_0_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_9_0_SBITERR_UNCONNECTED),
        .WEA({p_9_in,p_9_in,p_9_in,p_9_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "74" *) 
  (* ram_slice_end = "75" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_9_1
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_9_1_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_9_1_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_9_1_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[11:10]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_9_1_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_9_1_DOBDO_UNCONNECTED[31:2],w_word[75:74]}),
        .DOPADOP(NLW_bram_reg_9_1_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_9_1_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_9_1_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_9_1_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_9_1_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_9_1_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_9_1_SBITERR_UNCONNECTED),
        .WEA({p_9_in,p_9_in,p_9_in,p_9_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "76" *) 
  (* ram_slice_end = "77" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_9_2
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_9_2_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_9_2_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_9_2_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[13:12]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_9_2_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_9_2_DOBDO_UNCONNECTED[31:2],w_word[77:76]}),
        .DOPADOP(NLW_bram_reg_9_2_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_9_2_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_9_2_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_9_2_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_9_2_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_9_2_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_9_2_SBITERR_UNCONNECTED),
        .WEA({p_9_in,p_9_in,p_9_in,p_9_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d2" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2097152" *) 
  (* RTL_RAM_NAME = "arty_ddr_weight_bram_0_0/inst/bram_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "16383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "78" *) 
  (* ram_slice_end = "79" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(2),
    .READ_WIDTH_B(2),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(2),
    .WRITE_WIDTH_B(2)) 
    bram_reg_9_3
       (.ADDRARDADDR({1'b1,\waddr_reg[17]_rep__2_n_0 ,\waddr_reg[16]_rep__2_n_0 ,\waddr_reg[15]_rep__2_n_0 ,\waddr_reg[14]_rep__2_n_0 ,\waddr_reg[13]_rep__2_n_0 ,\waddr_reg[12]_rep__2_n_0 ,\waddr_reg[11]_rep__2_n_0 ,\waddr_reg[10]_rep__2_n_0 ,\waddr_reg[9]_rep__2_n_0 ,\waddr_reg[8]_rep__2_n_0 ,\waddr_reg[7]_rep_n_0 ,\waddr_reg[6]_rep_n_0 ,\waddr_reg[5]_rep_n_0 ,\waddr_reg[4]_rep_n_0 ,1'b1}),
        .ADDRBWRADDR({1'b1,w_word_addr,1'b1}),
        .CASCADEINA(1'b1),
        .CASCADEINB(1'b1),
        .CASCADEOUTA(NLW_bram_reg_9_3_CASCADEOUTA_UNCONNECTED),
        .CASCADEOUTB(NLW_bram_reg_9_3_CASCADEOUTB_UNCONNECTED),
        .CLKARDCLK(clk),
        .CLKBWRCLK(clk),
        .DBITERR(NLW_bram_reg_9_3_DBITERR_UNCONNECTED),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[15:14]}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(NLW_bram_reg_9_3_DOADO_UNCONNECTED[31:0]),
        .DOBDO({NLW_bram_reg_9_3_DOBDO_UNCONNECTED[31:2],w_word[79:78]}),
        .DOPADOP(NLW_bram_reg_9_3_DOPADOP_UNCONNECTED[3:0]),
        .DOPBDOP(NLW_bram_reg_9_3_DOPBDOP_UNCONNECTED[3:0]),
        .ECCPARITY(NLW_bram_reg_9_3_ECCPARITY_UNCONNECTED[7:0]),
        .ENARDEN(bram_reg_9_3_i_1_n_0),
        .ENBWREN(1'b1),
        .INJECTDBITERR(NLW_bram_reg_9_3_INJECTDBITERR_UNCONNECTED),
        .INJECTSBITERR(NLW_bram_reg_9_3_INJECTSBITERR_UNCONNECTED),
        .RDADDRECC(NLW_bram_reg_9_3_RDADDRECC_UNCONNECTED[8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(NLW_bram_reg_9_3_SBITERR_UNCONNECTED),
        .WEA({p_9_in,p_9_in,p_9_in,p_9_in}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT4 #(
    .INIT(16'h4000)) 
    bram_reg_9_3_i_1
       (.I0(p_0_in[3]),
        .I1(s_axi_wvalid),
        .I2(rst_n),
        .I3(p_0_in[2]),
        .O(bram_reg_9_3_i_1_n_0));
  LUT3 #(
    .INIT(8'h40)) 
    bram_reg_9_3_i_2
       (.I0(p_0_in__0[2]),
        .I1(p_0_in__0[3]),
        .I2(s_axi_wstrb[1]),
        .O(p_9_in));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAAA)) 
    i__carry__0_i_1
       (.I0(rbeats_reg[5]),
        .I1(\rid_r[3]_i_2_n_0 ),
        .I2(rbeats_reg[3]),
        .I3(rbeats_reg[2]),
        .I4(rbeats_reg[4]),
        .I5(s_axi_arlen[5]),
        .O(A[5]));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAAA)) 
    i__carry__0_i_2
       (.I0(rbeats_reg[4]),
        .I1(\rid_r[3]_i_2_n_0 ),
        .I2(rbeats_reg[3]),
        .I3(rbeats_reg[2]),
        .I4(rbeats_reg[5]),
        .I5(s_axi_arlen[4]),
        .O(A[4]));
  LUT5 #(
    .INIT(32'hC3C2C2C3)) 
    i__carry__0_i_3
       (.I0(i__carry__0_i_6_n_0),
        .I1(rbeats_reg[7]),
        .I2(rbeats_reg[6]),
        .I3(s_axi_arlen[7]),
        .I4(s_axi_arlen[6]),
        .O(i__carry__0_i_3_n_0));
  LUT5 #(
    .INIT(32'hA5A5A6A5)) 
    i__carry__0_i_4
       (.I0(A[5]),
        .I1(i__carry__0_i_6_n_0),
        .I2(rbeats_reg[6]),
        .I3(s_axi_arlen[6]),
        .I4(rbeats_reg[7]),
        .O(i__carry__0_i_4_n_0));
  LUT5 #(
    .INIT(32'hF0F00F09)) 
    i__carry__0_i_5
       (.I0(s_axi_arlen[4]),
        .I1(s_axi_arlen[5]),
        .I2(rbeats_reg[4]),
        .I3(i__carry__0_i_7_n_0),
        .I4(rbeats_reg[5]),
        .O(i__carry__0_i_5_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFD)) 
    i__carry__0_i_6
       (.I0(s_axi_arvalid),
        .I1(s_axi_rvalid_reg_0),
        .I2(rbeats_reg[1]),
        .I3(s_axi_arready_INST_0_i_1_n_0),
        .I4(rbeats_reg[0]),
        .O(i__carry__0_i_6_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    i__carry__0_i_7
       (.I0(\rid_r[3]_i_2_n_0 ),
        .I1(rbeats_reg[3]),
        .I2(rbeats_reg[2]),
        .O(i__carry__0_i_7_n_0));
  LUT5 #(
    .INIT(32'hAAAAAAAE)) 
    i__carry_i_1
       (.I0(rbeats_reg[0]),
        .I1(s_axi_arlen[0]),
        .I2(rbeats_reg[6]),
        .I3(rbeats_reg[7]),
        .I4(\rbeats[0]_i_2_n_0 ),
        .O(A[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    i__carry_i_10
       (.I0(rbeats_reg[7]),
        .I1(rbeats_reg[6]),
        .I2(rbeats_reg[0]),
        .O(i__carry_i_10_n_0));
  LUT3 #(
    .INIT(8'hFE)) 
    i__carry_i_11
       (.I0(\rid_r[3]_i_2_n_0 ),
        .I1(rbeats_reg[5]),
        .I2(rbeats_reg[4]),
        .O(i__carry_i_11_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAAA)) 
    i__carry_i_2
       (.I0(rbeats_reg[3]),
        .I1(\rid_r[3]_i_2_n_0 ),
        .I2(rbeats_reg[5]),
        .I3(rbeats_reg[4]),
        .I4(rbeats_reg[2]),
        .I5(s_axi_arlen[3]),
        .O(A[3]));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAAA)) 
    i__carry_i_3
       (.I0(rbeats_reg[2]),
        .I1(\rid_r[3]_i_2_n_0 ),
        .I2(rbeats_reg[5]),
        .I3(rbeats_reg[4]),
        .I4(rbeats_reg[3]),
        .I5(s_axi_arlen[2]),
        .O(A[2]));
  LUT6 #(
    .INIT(64'hAAAAABAAAAAAAAAA)) 
    i__carry_i_4
       (.I0(rbeats_reg[1]),
        .I1(s_axi_arready_INST_0_i_1_n_0),
        .I2(i__carry_i_10_n_0),
        .I3(s_axi_arvalid),
        .I4(s_axi_rvalid_reg_0),
        .I5(s_axi_arlen[1]),
        .O(A[1]));
  LUT1 #(
    .INIT(2'h1)) 
    i__carry_i_5
       (.I0(A[1]),
        .O(i__carry_i_5_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_6
       (.I0(A[3]),
        .I1(A[4]),
        .O(i__carry_i_6_n_0));
  LUT5 #(
    .INIT(32'hF0F00F09)) 
    i__carry_i_7
       (.I0(s_axi_arlen[2]),
        .I1(s_axi_arlen[3]),
        .I2(rbeats_reg[2]),
        .I3(i__carry_i_11_n_0),
        .I4(rbeats_reg[3]),
        .O(i__carry_i_7_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_8
       (.I0(A[1]),
        .I1(A[2]),
        .O(i__carry_i_8_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_9
       (.I0(A[1]),
        .I1(s_axi_rvalid0),
        .O(i__carry_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \p_0_out_inferred__0/i__carry 
       (.CI(1'b0),
        .CO({\p_0_out_inferred__0/i__carry_n_0 ,\p_0_out_inferred__0/i__carry_n_1 ,\p_0_out_inferred__0/i__carry_n_2 ,\p_0_out_inferred__0/i__carry_n_3 }),
        .CYINIT(A[0]),
        .DI({A[3:1],i__carry_i_5_n_0}),
        .O({\p_0_out_inferred__0/i__carry_n_4 ,\p_0_out_inferred__0/i__carry_n_5 ,\p_0_out_inferred__0/i__carry_n_6 ,\p_0_out_inferred__0/i__carry_n_7 }),
        .S({i__carry_i_6_n_0,i__carry_i_7_n_0,i__carry_i_8_n_0,i__carry_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 \p_0_out_inferred__0/i__carry__0 
       (.CI(\p_0_out_inferred__0/i__carry_n_0 ),
        .CO({\NLW_p_0_out_inferred__0/i__carry__0_CO_UNCONNECTED [3:2],\p_0_out_inferred__0/i__carry__0_n_2 ,\p_0_out_inferred__0/i__carry__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,A[5:4]}),
        .O({\NLW_p_0_out_inferred__0/i__carry__0_O_UNCONNECTED [3],\p_0_out_inferred__0/i__carry__0_n_5 ,\p_0_out_inferred__0/i__carry__0_n_6 ,\p_0_out_inferred__0/i__carry__0_n_7 }),
        .S({1'b0,i__carry__0_i_3_n_0,i__carry__0_i_4_n_0,i__carry__0_i_5_n_0}));
  LUT5 #(
    .INIT(32'h0000FEFF)) 
    \rbeats[0]_i_1 
       (.I0(\rbeats[0]_i_2_n_0 ),
        .I1(rbeats_reg[7]),
        .I2(rbeats_reg[6]),
        .I3(s_axi_arlen[0]),
        .I4(rbeats_reg[0]),
        .O(\rbeats[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hFEFF)) 
    \rbeats[0]_i_2 
       (.I0(s_axi_arready_INST_0_i_1_n_0),
        .I1(rbeats_reg[1]),
        .I2(s_axi_rvalid_reg_0),
        .I3(s_axi_arvalid),
        .O(\rbeats[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hF8)) 
    \rbeats[7]_i_1 
       (.I0(s_axi_rready),
        .I1(s_axi_rvalid_reg_0),
        .I2(s_axi_rvalid0),
        .O(\rbeats[7]_i_1_n_0 ));
  FDRE \rbeats_reg[0] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\rbeats[0]_i_1_n_0 ),
        .Q(rbeats_reg[0]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[1] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry_n_7 ),
        .Q(rbeats_reg[1]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[2] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry_n_6 ),
        .Q(rbeats_reg[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[3] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry_n_5 ),
        .Q(rbeats_reg[3]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[4] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry_n_4 ),
        .Q(rbeats_reg[4]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[5] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry__0_n_7 ),
        .Q(rbeats_reg[5]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[6] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry__0_n_6 ),
        .Q(rbeats_reg[6]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rbeats_reg[7] 
       (.C(clk),
        .CE(\rbeats[7]_i_1_n_0 ),
        .D(\p_0_out_inferred__0/i__carry__0_n_5 ),
        .Q(rbeats_reg[7]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \rid_r[3]_i_1 
       (.I0(\rid_r[3]_i_2_n_0 ),
        .I1(rbeats_reg[4]),
        .I2(rbeats_reg[5]),
        .I3(rbeats_reg[2]),
        .I4(rbeats_reg[3]),
        .O(s_axi_rvalid0));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \rid_r[3]_i_2 
       (.I0(rbeats_reg[0]),
        .I1(rbeats_reg[6]),
        .I2(rbeats_reg[7]),
        .I3(rbeats_reg[1]),
        .I4(s_axi_rvalid_reg_0),
        .I5(s_axi_arvalid),
        .O(\rid_r[3]_i_2_n_0 ));
  FDRE \rid_r_reg[0] 
       (.C(clk),
        .CE(s_axi_rvalid0),
        .D(s_axi_arid[0]),
        .Q(s_axi_rid[0]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rid_r_reg[1] 
       (.C(clk),
        .CE(s_axi_rvalid0),
        .D(s_axi_arid[1]),
        .Q(s_axi_rid[1]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rid_r_reg[2] 
       (.C(clk),
        .CE(s_axi_rvalid0),
        .D(s_axi_arid[2]),
        .Q(s_axi_rid[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \rid_r_reg[3] 
       (.C(clk),
        .CE(s_axi_rvalid0),
        .D(s_axi_arid[3]),
        .Q(s_axi_rid[3]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    s_axi_arready_INST_0
       (.I0(s_axi_rvalid_reg_0),
        .I1(rbeats_reg[1]),
        .I2(rbeats_reg[7]),
        .I3(rbeats_reg[6]),
        .I4(rbeats_reg[0]),
        .I5(s_axi_arready_INST_0_i_1_n_0),
        .O(s_axi_arready));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    s_axi_arready_INST_0_i_1
       (.I0(rbeats_reg[3]),
        .I1(rbeats_reg[2]),
        .I2(rbeats_reg[5]),
        .I3(rbeats_reg[4]),
        .O(s_axi_arready_INST_0_i_1_n_0));
  LUT5 #(
    .INIT(32'hE2220000)) 
    s_axi_bvalid_i_1
       (.I0(s_axi_bvalid),
        .I1(s_axi_bvalid_i_2_n_0),
        .I2(s_axi_wlast),
        .I3(s_axi_wready),
        .I4(rst_n),
        .O(s_axi_bvalid_i_1_n_0));
  LUT5 #(
    .INIT(32'hFF808080)) 
    s_axi_bvalid_i_2
       (.I0(s_axi_wready),
        .I1(s_axi_wvalid),
        .I2(s_axi_wlast),
        .I3(\FSM_onehot_wstate_reg_n_0_[2] ),
        .I4(s_axi_bready),
        .O(s_axi_bvalid_i_2_n_0));
  FDRE s_axi_bvalid_reg
       (.C(clk),
        .CE(1'b1),
        .D(s_axi_bvalid_i_1_n_0),
        .Q(s_axi_bvalid),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000010)) 
    s_axi_rlast_INST_0
       (.I0(rbeats_reg[6]),
        .I1(rbeats_reg[7]),
        .I2(rbeats_reg[0]),
        .I3(rbeats_reg[1]),
        .I4(s_axi_arready_INST_0_i_1_n_0),
        .O(s_axi_rlast));
  LUT5 #(
    .INIT(32'hFFA20000)) 
    s_axi_rvalid_i_1
       (.I0(s_axi_rvalid_reg_0),
        .I1(s_axi_rvalid_i_2_n_0),
        .I2(s_axi_arready_INST_0_i_1_n_0),
        .I3(s_axi_rvalid0),
        .I4(rst_n),
        .O(s_axi_rvalid_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    s_axi_rvalid_i_2
       (.I0(s_axi_rvalid_reg_0),
        .I1(s_axi_rready),
        .I2(rbeats_reg[0]),
        .I3(rbeats_reg[1]),
        .I4(rbeats_reg[7]),
        .I5(rbeats_reg[6]),
        .O(s_axi_rvalid_i_2_n_0));
  FDRE s_axi_rvalid_reg
       (.C(clk),
        .CE(1'b1),
        .D(s_axi_rvalid_i_1_n_0),
        .Q(s_axi_rvalid_reg_0),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[0]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[0]),
        .I2(s_axi_wready),
        .I3(in5[0]),
        .O(\waddr[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[10]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[10]),
        .I2(s_axi_wready),
        .I3(in5[10]),
        .O(\waddr[10]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[11]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[11]),
        .I2(s_axi_wready),
        .I3(in5[11]),
        .O(\waddr[11]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[12]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[12]),
        .I2(s_axi_wready),
        .I3(in5[12]),
        .O(\waddr[12]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[13]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[13]),
        .I2(s_axi_wready),
        .I3(in5[13]),
        .O(\waddr[13]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[14]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[14]),
        .I2(s_axi_wready),
        .I3(in5[14]),
        .O(\waddr[14]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[15]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[15]),
        .I2(s_axi_wready),
        .I3(in5[15]),
        .O(\waddr[15]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[16]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[16]),
        .I2(s_axi_wready),
        .I3(in5[16]),
        .O(\waddr[16]_rep_i_1__5_n_0 ));
  LUT6 #(
    .INIT(64'hFFF8888888888888)) 
    \waddr[17]_i_1 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awready),
        .I2(wburst[0]),
        .I3(wburst[1]),
        .I4(s_axi_wready),
        .I5(s_axi_wvalid),
        .O(waddr));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_i_2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[17]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[17]),
        .I2(s_axi_wready),
        .I3(in5[17]),
        .O(\waddr[17]_rep_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[1]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[1]),
        .I2(s_axi_wready),
        .I3(in5[1]),
        .O(\waddr[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[2]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[2]),
        .I2(s_axi_wready),
        .I3(in5[2]),
        .O(\waddr[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[3]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[3]),
        .I2(s_axi_wready),
        .I3(in5[3]),
        .O(\waddr[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAA6A)) 
    \waddr[3]_i_3 
       (.I0(p_0_in__0[3]),
        .I1(wsize[0]),
        .I2(wsize[1]),
        .I3(wsize[2]),
        .O(\waddr[3]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \waddr[3]_i_4 
       (.I0(p_0_in__0[2]),
        .I1(wsize[0]),
        .I2(wsize[1]),
        .I3(wsize[2]),
        .O(\waddr[3]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hAAA6)) 
    \waddr[3]_i_5 
       (.I0(\waddr_reg_n_0_[1] ),
        .I1(wsize[0]),
        .I2(wsize[1]),
        .I3(wsize[2]),
        .O(\waddr[3]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hAAA9)) 
    \waddr[3]_i_6 
       (.I0(\waddr_reg_n_0_[0] ),
        .I1(wsize[0]),
        .I2(wsize[1]),
        .I3(wsize[2]),
        .O(\waddr[3]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[4]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[4]),
        .I2(s_axi_wready),
        .I3(in5[4]),
        .O(\waddr[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[4]_rep__0_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[4]),
        .I2(s_axi_wready),
        .I3(in5[4]),
        .O(\waddr[4]_rep__0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[4]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[4]),
        .I2(s_axi_wready),
        .I3(in5[4]),
        .O(\waddr[4]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[5]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[5]),
        .I2(s_axi_wready),
        .I3(in5[5]),
        .O(\waddr[5]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[5]_rep__0_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[5]),
        .I2(s_axi_wready),
        .I3(in5[5]),
        .O(\waddr[5]_rep__0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[5]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[5]),
        .I2(s_axi_wready),
        .I3(in5[5]),
        .O(\waddr[5]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[6]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[6]),
        .I2(s_axi_wready),
        .I3(in5[6]),
        .O(\waddr[6]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[6]_rep__0_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[6]),
        .I2(s_axi_wready),
        .I3(in5[6]),
        .O(\waddr[6]_rep__0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[6]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[6]),
        .I2(s_axi_wready),
        .I3(in5[6]),
        .O(\waddr[6]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[7]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[7]),
        .I2(s_axi_wready),
        .I3(in5[7]),
        .O(\waddr[7]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h6AAA)) 
    \waddr[7]_i_3 
       (.I0(wr_word[3]),
        .I1(wsize[0]),
        .I2(wsize[1]),
        .I3(wsize[2]),
        .O(\waddr[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h9AAA)) 
    \waddr[7]_i_4 
       (.I0(wr_word[2]),
        .I1(wsize[0]),
        .I2(wsize[1]),
        .I3(wsize[2]),
        .O(\waddr[7]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hAA6A)) 
    \waddr[7]_i_5 
       (.I0(wr_word[1]),
        .I1(wsize[0]),
        .I2(wsize[2]),
        .I3(wsize[1]),
        .O(\waddr[7]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hAA9A)) 
    \waddr[7]_i_6 
       (.I0(wr_word[0]),
        .I1(wsize[0]),
        .I2(wsize[2]),
        .I3(wsize[1]),
        .O(\waddr[7]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[7]_rep__0_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[7]),
        .I2(s_axi_wready),
        .I3(in5[7]),
        .O(\waddr[7]_rep__0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[7]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[7]),
        .I2(s_axi_wready),
        .I3(in5[7]),
        .O(\waddr[7]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep__0_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep__0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep__1_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep__1_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep__2_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep__2_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep__3_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep__3_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep__4_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep__4_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep__5_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep__5_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[8]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[8]),
        .I2(s_axi_wready),
        .I3(in5[8]),
        .O(\waddr[8]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1__0 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1__1 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1__2 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1__3 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1__4 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \waddr[9]_rep_i_1__5 
       (.I0(s_axi_awready),
        .I1(s_axi_awaddr[9]),
        .I2(s_axi_wready),
        .I3(in5[9]),
        .O(\waddr[9]_rep_i_1__5_n_0 ));
  FDRE \waddr_reg[0] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[0]_i_1_n_0 ),
        .Q(\waddr_reg_n_0_[0] ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_i_1_n_0 ),
        .Q(wr_word[6]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1_n_0 ),
        .Q(\waddr_reg[10]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[10]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[10]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[10]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[10]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[10]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[10]" *) 
  FDRE \waddr_reg[10]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[10]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[10]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_i_1_n_0 ),
        .Q(wr_word[7]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \waddr_reg[11]_i_2 
       (.CI(\waddr_reg[7]_i_2_n_0 ),
        .CO({\waddr_reg[11]_i_2_n_0 ,\waddr_reg[11]_i_2_n_1 ,\waddr_reg[11]_i_2_n_2 ,\waddr_reg[11]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(in5[11:8]),
        .S(wr_word[7:4]));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1_n_0 ),
        .Q(\waddr_reg[11]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[11]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[11]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[11]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[11]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[11]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[11]" *) 
  FDRE \waddr_reg[11]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[11]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[11]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_i_1_n_0 ),
        .Q(wr_word[8]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1_n_0 ),
        .Q(\waddr_reg[12]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[12]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[12]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[12]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[12]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[12]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[12]" *) 
  FDRE \waddr_reg[12]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[12]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[12]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_i_1_n_0 ),
        .Q(wr_word[9]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1_n_0 ),
        .Q(\waddr_reg[13]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[13]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[13]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[13]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[13]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[13]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[13]" *) 
  FDRE \waddr_reg[13]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[13]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[13]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_i_1_n_0 ),
        .Q(wr_word[10]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1_n_0 ),
        .Q(\waddr_reg[14]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[14]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[14]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[14]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[14]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[14]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[14]" *) 
  FDRE \waddr_reg[14]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[14]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[14]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_i_1_n_0 ),
        .Q(wr_word[11]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \waddr_reg[15]_i_2 
       (.CI(\waddr_reg[11]_i_2_n_0 ),
        .CO({\waddr_reg[15]_i_2_n_0 ,\waddr_reg[15]_i_2_n_1 ,\waddr_reg[15]_i_2_n_2 ,\waddr_reg[15]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(in5[15:12]),
        .S(wr_word[11:8]));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1_n_0 ),
        .Q(\waddr_reg[15]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[15]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[15]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[15]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[15]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[15]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[15]" *) 
  FDRE \waddr_reg[15]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[15]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[15]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_i_1_n_0 ),
        .Q(wr_word[12]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1_n_0 ),
        .Q(\waddr_reg[16]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[16]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[16]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[16]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[16]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[16]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[16]" *) 
  FDRE \waddr_reg[16]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[16]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[16]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_i_2_n_0 ),
        .Q(wr_word[13]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \waddr_reg[17]_i_3 
       (.CI(\waddr_reg[15]_i_2_n_0 ),
        .CO({\NLW_waddr_reg[17]_i_3_CO_UNCONNECTED [3:1],\waddr_reg[17]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_waddr_reg[17]_i_3_O_UNCONNECTED [3:2],in5[17:16]}),
        .S({1'b0,1'b0,wr_word[13:12]}));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1_n_0 ),
        .Q(\waddr_reg[17]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[17]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[17]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[17]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[17]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[17]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[17]" *) 
  FDRE \waddr_reg[17]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[17]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[17]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \waddr_reg[1] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[1]_i_1_n_0 ),
        .Q(\waddr_reg_n_0_[1] ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \waddr_reg[2] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[2]_i_1_n_0 ),
        .Q(p_0_in__0[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \waddr_reg[3] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[3]_i_1_n_0 ),
        .Q(p_0_in__0[3]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \waddr_reg[3]_i_2 
       (.CI(1'b0),
        .CO({\waddr_reg[3]_i_2_n_0 ,\waddr_reg[3]_i_2_n_1 ,\waddr_reg[3]_i_2_n_2 ,\waddr_reg[3]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({p_0_in__0,\waddr_reg_n_0_[1] ,\waddr_reg_n_0_[0] }),
        .O(in5[3:0]),
        .S({\waddr[3]_i_3_n_0 ,\waddr[3]_i_4_n_0 ,\waddr[3]_i_5_n_0 ,\waddr[3]_i_6_n_0 }));
  (* ORIG_CELL_NAME = "waddr_reg[4]" *) 
  FDRE \waddr_reg[4] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[4]_i_1_n_0 ),
        .Q(wr_word[0]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[4]" *) 
  FDRE \waddr_reg[4]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[4]_rep_i_1_n_0 ),
        .Q(\waddr_reg[4]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[4]" *) 
  FDRE \waddr_reg[4]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[4]_rep__0_i_1_n_0 ),
        .Q(\waddr_reg[4]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[5]" *) 
  FDRE \waddr_reg[5] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[5]_i_1_n_0 ),
        .Q(wr_word[1]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[5]" *) 
  FDRE \waddr_reg[5]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[5]_rep_i_1_n_0 ),
        .Q(\waddr_reg[5]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[5]" *) 
  FDRE \waddr_reg[5]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[5]_rep__0_i_1_n_0 ),
        .Q(\waddr_reg[5]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[6]" *) 
  FDRE \waddr_reg[6] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[6]_i_1_n_0 ),
        .Q(wr_word[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[6]" *) 
  FDRE \waddr_reg[6]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[6]_rep_i_1_n_0 ),
        .Q(\waddr_reg[6]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[6]" *) 
  FDRE \waddr_reg[6]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[6]_rep__0_i_1_n_0 ),
        .Q(\waddr_reg[6]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[7]" *) 
  FDRE \waddr_reg[7] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[7]_i_1_n_0 ),
        .Q(wr_word[3]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \waddr_reg[7]_i_2 
       (.CI(\waddr_reg[3]_i_2_n_0 ),
        .CO({\waddr_reg[7]_i_2_n_0 ,\waddr_reg[7]_i_2_n_1 ,\waddr_reg[7]_i_2_n_2 ,\waddr_reg[7]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(wr_word[3:0]),
        .O(in5[7:4]),
        .S({\waddr[7]_i_3_n_0 ,\waddr[7]_i_4_n_0 ,\waddr[7]_i_5_n_0 ,\waddr[7]_i_6_n_0 }));
  (* ORIG_CELL_NAME = "waddr_reg[7]" *) 
  FDRE \waddr_reg[7]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[7]_rep_i_1_n_0 ),
        .Q(\waddr_reg[7]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[7]" *) 
  FDRE \waddr_reg[7]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[7]_rep__0_i_1_n_0 ),
        .Q(\waddr_reg[7]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_i_1_n_0 ),
        .Q(wr_word[4]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep__0_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep__1_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep__2_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep__3_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep__4_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[8]" *) 
  FDRE \waddr_reg[8]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[8]_rep__5_i_1_n_0 ),
        .Q(\waddr_reg[8]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9] 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_i_1_n_0 ),
        .Q(wr_word[5]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1_n_0 ),
        .Q(\waddr_reg[9]_rep_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep__0 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1__0_n_0 ),
        .Q(\waddr_reg[9]_rep__0_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep__1 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1__1_n_0 ),
        .Q(\waddr_reg[9]_rep__1_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep__2 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1__2_n_0 ),
        .Q(\waddr_reg[9]_rep__2_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep__3 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1__3_n_0 ),
        .Q(\waddr_reg[9]_rep__3_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep__4 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1__4_n_0 ),
        .Q(\waddr_reg[9]_rep__4_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* ORIG_CELL_NAME = "waddr_reg[9]" *) 
  FDRE \waddr_reg[9]_rep__5 
       (.C(clk),
        .CE(waddr),
        .D(\waddr[9]_rep_i_1__5_n_0 ),
        .Q(\waddr_reg[9]_rep__5_n_0 ),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDSE \wburst_reg[0] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awburst[0]),
        .Q(wburst[0]),
        .S(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wburst_reg[1] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awburst[1]),
        .Q(wburst[1]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \wid[3]_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awvalid),
        .O(wid));
  FDRE \wid_reg[0] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awid[0]),
        .Q(s_axi_bid[0]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wid_reg[1] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awid[1]),
        .Q(s_axi_bid[1]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wid_reg[2] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awid[2]),
        .Q(s_axi_bid[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wid_reg[3] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awid[3]),
        .Q(s_axi_bid[3]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wsize_reg[0] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awsize[0]),
        .Q(wsize[0]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDSE \wsize_reg[1] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awsize[1]),
        .Q(wsize[1]),
        .S(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wsize_reg[2] 
       (.C(clk),
        .CE(wid),
        .D(s_axi_awsize[2]),
        .Q(wsize[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \wstate[0]_i_1 
       (.I0(p_0_in[2]),
        .I1(p_0_in[3]),
        .O(\wstate[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \wstate[1]_i_1 
       (.I0(p_0_in[2]),
        .I1(p_0_in[3]),
        .O(\wstate[1]_i_1_n_0 ));
  FDRE \wstate_reg[0] 
       (.C(clk),
        .CE(wstate),
        .D(\wstate[0]_i_1_n_0 ),
        .Q(p_0_in[2]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
  FDRE \wstate_reg[1] 
       (.C(clk),
        .CE(wstate),
        .D(\wstate[1]_i_1_n_0 ),
        .Q(p_0_in[3]),
        .R(\FSM_onehot_wstate[0]_i_1_n_0 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
