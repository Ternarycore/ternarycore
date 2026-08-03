// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Mon Aug  3 14:21:57 2026
// Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_axi_gemm_stream_0_0/arty_ddr_axi_gemm_stream_0_0_stub.v
// Design      : arty_ddr_axi_gemm_stream_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "arty_ddr_axi_gemm_stream_0_0,axi_gemm_stream,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "package_project" *) 
(* X_CORE_INFO = "axi_gemm_stream,Vivado 2025.2" *) 
module arty_ddr_axi_gemm_stream_0_0(clk, rst_n, s_axi_awaddr, s_axi_awprot, 
  s_axi_awvalid, s_axi_awready, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, s_axi_wready, 
  s_axi_bresp, s_axi_bvalid, s_axi_bready, s_axi_araddr, s_axi_arprot, s_axi_arvalid, 
  s_axi_arready, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready, w_word_addr, w_word)
/* synthesis syn_black_box black_box_pad_pin="rst_n,s_axi_awaddr[7:0],s_axi_awprot[2:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[7:0],s_axi_arprot[2:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,w_word_addr[13:0],w_word[127:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF s_axi, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0" *) input clk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 81247969, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [7:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWPROT" *) input [2:0]s_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARADDR" *) input [7:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARPROT" *) input [2:0]s_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *) input s_axi_rready;
  output [13:0]w_word_addr;
  input [127:0]w_word;
endmodule
