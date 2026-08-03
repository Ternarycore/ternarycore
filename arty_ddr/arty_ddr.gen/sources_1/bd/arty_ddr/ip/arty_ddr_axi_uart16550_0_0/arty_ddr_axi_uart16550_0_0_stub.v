// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Mon Aug  3 14:21:18 2026
// Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_axi_uart16550_0_0/arty_ddr_axi_uart16550_0_0_stub.v
// Design      : arty_ddr_axi_uart16550_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "arty_ddr_axi_uart16550_0_0,axi_uart16550,{}" *) (* core_generation_info = "arty_ddr_axi_uart16550_0_0,axi_uart16550,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=axi_uart16550,x_ipVersion=2.0,x_ipCoreRevision=39,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=artix7,C_SIM_DEVICE=VERSAL_AI_CORE_ES1,C_S_AXI_ACLK_FREQ_HZ=81000000,C_S_AXI_ADDR_WIDTH=13,C_S_AXI_DATA_WIDTH=32,C_IS_A_16550=1,C_HAS_EXTERNAL_XIN=0,C_HAS_EXTERNAL_RCLK=0,C_EXTERNAL_XIN_CLK_HZ=25000000}" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* x_core_info = "axi_uart16550,Vivado 2025.2" *) 
module arty_ddr_axi_uart16550_0_0(s_axi_aclk, s_axi_aresetn, ip2intc_irpt, 
  freeze, s_axi_awaddr, s_axi_awvalid, s_axi_awready, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, 
  s_axi_wready, s_axi_bresp, s_axi_bvalid, s_axi_bready, s_axi_araddr, s_axi_arvalid, 
  s_axi_arready, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready, baudoutn, ctsn, dcdn, ddis, 
  dsrn, dtrn, out1n, out2n, rin, rtsn, rxrdyn, sin, sout, txrdyn)
/* synthesis syn_black_box black_box_pad_pin="s_axi_aresetn,ip2intc_irpt,freeze,s_axi_awaddr[12:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[12:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,baudoutn,ctsn,dcdn,ddis,dsrn,dtrn,out1n,out2n,rin,rtsn,rxrdyn,sin,sout,txrdyn" */
/* synthesis syn_force_seq_prim="s_axi_aclk" */;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 ACLK CLK" *) (* x_interface_mode = "slave ACLK" *) (* x_interface_parameter = "XIL_INTERFACENAME ACLK, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0" *) input s_axi_aclk /* synthesis syn_isclock = 1 */;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 ARESETN RST" *) (* x_interface_mode = "slave ARESETN" *) (* x_interface_parameter = "XIL_INTERFACENAME ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* x_interface_info = "xilinx.com:signal:interrupt:1.0 INTERRUPT INTERRUPT" *) (* x_interface_mode = "master INTERRUPT" *) (* x_interface_parameter = "XIL_INTERFACENAME INTERRUPT, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) output ip2intc_irpt;
  input freeze;
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
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART BAUDOUTn" *) (* x_interface_mode = "master UART" *) (* x_interface_parameter = "XIL_INTERFACENAME UART, BOARD.ASSOCIATED_PARAM UART_BOARD_INTERFACE" *) output baudoutn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART CTSn" *) input ctsn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART DCDn" *) input dcdn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART DDIS" *) output ddis;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART DSRn" *) input dsrn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART DTRn" *) output dtrn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART OUT1n" *) output out1n;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART OUT2n" *) output out2n;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART RI" *) input rin;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART RTSn" *) output rtsn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART RXRDYn" *) output rxrdyn;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART RxD" *) input sin;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART TxD" *) output sout;
  (* x_interface_info = "xilinx.com:interface:uart:1.0 UART TXRDYn" *) output txrdyn;
endmodule
