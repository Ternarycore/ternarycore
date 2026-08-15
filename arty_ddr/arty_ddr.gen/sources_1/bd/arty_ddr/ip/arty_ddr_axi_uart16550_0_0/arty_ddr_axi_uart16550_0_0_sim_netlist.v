// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue Aug  4 23:11:12 2026
// Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_axi_uart16550_0_0/arty_ddr_axi_uart16550_0_0_sim_netlist.v
// Design      : arty_ddr_axi_uart16550_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "arty_ddr_axi_uart16550_0_0,axi_uart16550,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "axi_uart16550,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module arty_ddr_axi_uart16550_0_0
   (s_axi_aclk,
    s_axi_aresetn,
    ip2intc_irpt,
    freeze,
    s_axi_awaddr,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rvalid,
    s_axi_rready,
    baudoutn,
    ctsn,
    dcdn,
    ddis,
    dsrn,
    dtrn,
    out1n,
    out2n,
    rin,
    rtsn,
    rxrdyn,
    sin,
    sout,
    txrdyn);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 ACLK CLK" *) (* x_interface_mode = "slave ACLK" *) (* x_interface_parameter = "XIL_INTERFACENAME ACLK, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0" *) input s_axi_aclk;
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

  wire \<const0> ;
  wire baudoutn;
  wire ctsn;
  wire dcdn;
  wire ddis;
  wire dsrn;
  wire dtrn;
  wire freeze;
  wire ip2intc_irpt;
  wire out1n;
  wire out2n;
  wire rin;
  wire rtsn;
  wire rxrdyn;
  wire s_axi_aclk;
  wire [12:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [12:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [7:0]\^s_axi_rdata ;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire sin;
  wire sout;
  wire txrdyn;
  wire NLW_U0_xout_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:8]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7:0] = \^s_axi_rdata [7:0];
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_EXTERNAL_XIN_CLK_HZ = "25000000" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_EXTERNAL_RCLK = "0" *) 
  (* C_HAS_EXTERNAL_XIN = "0" *) 
  (* C_IS_A_16550 = "1" *) 
  (* C_SIM_DEVICE = "VERSAL_AI_CORE_ES1" *) 
  (* C_S_AXI_ACLK_FREQ_HZ = "81000000" *) 
  (* C_S_AXI_ADDR_WIDTH = "13" *) 
  (* C_S_AXI_DATA_WIDTH = "32" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  arty_ddr_axi_uart16550_0_0_axi_uart16550 U0
       (.baudoutn(baudoutn),
        .ctsn(ctsn),
        .dcdn(dcdn),
        .ddis(ddis),
        .dsrn(dsrn),
        .dtrn(dtrn),
        .freeze(freeze),
        .ip2intc_irpt(ip2intc_irpt),
        .out1n(out1n),
        .out2n(out2n),
        .rclk(1'b0),
        .rin(rin),
        .rtsn(rtsn),
        .rxrdyn(rxrdyn),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_araddr[4:2],1'b0,1'b0}),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_awaddr[4:2],1'b0,1'b0}),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata({NLW_U0_s_axi_rdata_UNCONNECTED[31:8],\^s_axi_rdata }),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata[7:0]}),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(s_axi_wvalid),
        .sin(sin),
        .sout(sout),
        .txrdyn(txrdyn),
        .xin(1'b0),
        .xout(NLW_U0_xout_UNCONNECTED));
endmodule

(* ORIG_REF_NAME = "address_decoder" *) 
module arty_ddr_axi_uart16550_0_0_address_decoder
   (\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ,
    bus2ip_rdce_i,
    Wr,
    bus2ip_wrce_i,
    s_axi_aclk,
    Bus_RNW_reg_reg_0,
    Q,
    s_axi_aresetn,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_2 ,
    wrReq_d1);
  output \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ;
  output [0:0]bus2ip_rdce_i;
  output Wr;
  output [0:0]bus2ip_wrce_i;
  input s_axi_aclk;
  input Bus_RNW_reg_reg_0;
  input Q;
  input s_axi_aresetn;
  input \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ;
  input \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_2 ;
  input wrReq_d1;

  wire Bus_RNW_reg;
  wire Bus_RNW_reg_i_1_n_0;
  wire Bus_RNW_reg_reg_0;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1_n_0 ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_2 ;
  wire Q;
  wire Wr;
  wire [0:0]bus2ip_rdce_i;
  wire [0:0]bus2ip_wrce_i;
  wire s_axi_aclk;
  wire s_axi_aresetn;
  wire wrReq_d1;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    Bus_RNW_reg_i_1
       (.I0(Bus_RNW_reg_reg_0),
        .I1(Q),
        .I2(Bus_RNW_reg),
        .O(Bus_RNW_reg_i_1_n_0));
  FDRE Bus_RNW_reg_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Bus_RNW_reg_i_1_n_0),
        .Q(Bus_RNW_reg),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h000000E0)) 
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .I1(Q),
        .I2(s_axi_aresetn),
        .I3(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ),
        .I4(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_2 ),
        .O(\GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1_n_0 ));
  FDRE \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1_n_0 ),
        .Q(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    bus2ip_rdreq_d1_i_1
       (.I0(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .I1(Bus_RNW_reg),
        .O(bus2ip_rdce_i));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h2)) 
    wrReq_d1_i_1
       (.I0(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .I1(Bus_RNW_reg),
        .O(bus2ip_wrce_i));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h04)) 
    wr_d_i_1
       (.I0(Bus_RNW_reg),
        .I1(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .I2(wrReq_d1),
        .O(Wr));
endmodule

(* ORIG_REF_NAME = "axi_lite_ipif" *) 
module arty_ddr_axi_uart16550_0_0_axi_lite_ipif
   (bus2ip_reset_int_core,
    ce_out_i,
    s_axi_rvalid,
    s_axi_bvalid,
    SR,
    rst_reg,
    s_axi_rdata,
    \bus2ip_addr_i_reg[4] ,
    bus2ip_rdce_i,
    Wr,
    bus2ip_wrce_i,
    s_axi_aclk,
    s_axi_arvalid,
    \GENERATING_FIFOS.rx_fifo_rst ,
    p_2_in44_in,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ,
    s_axi_rready,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ,
    s_axi_bready,
    s_axi_awvalid,
    s_axi_wvalid,
    Q,
    s_axi_aresetn,
    s_axi_araddr,
    s_axi_awaddr,
    wrReq_d1);
  output bus2ip_reset_int_core;
  output [0:0]ce_out_i;
  output s_axi_rvalid;
  output s_axi_bvalid;
  output [0:0]SR;
  output rst_reg;
  output [7:0]s_axi_rdata;
  output [2:0]\bus2ip_addr_i_reg[4] ;
  output [0:0]bus2ip_rdce_i;
  output Wr;
  output [0:0]bus2ip_wrce_i;
  input s_axi_aclk;
  input s_axi_arvalid;
  input \GENERATING_FIFOS.rx_fifo_rst ;
  input p_2_in44_in;
  input \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ;
  input s_axi_rready;
  input \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ;
  input s_axi_bready;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input [7:0]Q;
  input s_axi_aresetn;
  input [2:0]s_axi_araddr;
  input [2:0]s_axi_awaddr;
  input wrReq_d1;

  wire \GENERATING_FIFOS.rx_fifo_rst ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ;
  wire [7:0]Q;
  wire [0:0]SR;
  wire Wr;
  wire [2:0]\bus2ip_addr_i_reg[4] ;
  wire [0:0]bus2ip_rdce_i;
  wire bus2ip_reset_int_core;
  wire [0:0]bus2ip_wrce_i;
  wire [0:0]ce_out_i;
  wire p_2_in44_in;
  wire rst_reg;
  wire s_axi_aclk;
  wire [2:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arvalid;
  wire [2:0]s_axi_awaddr;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [7:0]s_axi_rdata;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire s_axi_wvalid;
  wire wrReq_d1;

  arty_ddr_axi_uart16550_0_0_slave_attachment I_SLAVE_ATTACHMENT
       (.\GENERATING_FIFOS.rx_fifo_rst (\GENERATING_FIFOS.rx_fifo_rst ),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] (ce_out_i),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 (\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 (\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .Q(Q),
        .SR(bus2ip_reset_int_core),
        .Wr(Wr),
        .\bus2ip_addr_i_reg[4]_0 (\bus2ip_addr_i_reg[4] ),
        .bus2ip_rdce_i(bus2ip_rdce_i),
        .bus2ip_wrce_i(bus2ip_wrce_i),
        .p_2_in44_in(p_2_in44_in),
        .rst_reg_0(SR),
        .rst_reg_1(rst_reg),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wvalid(s_axi_wvalid),
        .wrReq_d1(wrReq_d1));
endmodule

(* C_EXTERNAL_XIN_CLK_HZ = "25000000" *) (* C_FAMILY = "artix7" *) (* C_HAS_EXTERNAL_RCLK = "0" *) 
(* C_HAS_EXTERNAL_XIN = "0" *) (* C_IS_A_16550 = "1" *) (* C_SIM_DEVICE = "VERSAL_AI_CORE_ES1" *) 
(* C_S_AXI_ACLK_FREQ_HZ = "81000000" *) (* C_S_AXI_ADDR_WIDTH = "13" *) (* C_S_AXI_DATA_WIDTH = "32" *) 
(* ORIG_REF_NAME = "axi_uart16550" *) (* downgradeipidentifiedwarnings = "yes" *) 
module arty_ddr_axi_uart16550_0_0_axi_uart16550
   (s_axi_aclk,
    s_axi_aresetn,
    ip2intc_irpt,
    freeze,
    s_axi_awaddr,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rvalid,
    s_axi_rready,
    baudoutn,
    ctsn,
    dcdn,
    ddis,
    dsrn,
    dtrn,
    out1n,
    out2n,
    rclk,
    rin,
    rtsn,
    rxrdyn,
    sin,
    sout,
    txrdyn,
    xin,
    xout);
  input s_axi_aclk;
  input s_axi_aresetn;
  (* sigis = "INTERRUPT" *) output ip2intc_irpt;
  input freeze;
  input [12:0]s_axi_awaddr;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wvalid;
  output s_axi_wready;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [12:0]s_axi_araddr;
  input s_axi_arvalid;
  output s_axi_arready;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rvalid;
  input s_axi_rready;
  output baudoutn;
  input ctsn;
  input dcdn;
  output ddis;
  input dsrn;
  output dtrn;
  output out1n;
  output out2n;
  (* sigis = "CLK" *) input rclk;
  input rin;
  output rtsn;
  output rxrdyn;
  input sin;
  output sout;
  output txrdyn;
  (* sigis = "CLK" *) input xin;
  output xout;

  wire \<const0> ;
  wire AXI_LITE_IPIF_I_n_4;
  wire AXI_LITE_IPIF_I_n_5;
  wire [2:0]Addr;
  wire [7:0]Dout;
  wire \IPIC_IF_I_1/wrReq_d1 ;
  wire [0:0]\I_SLAVE_ATTACHMENT/I_DECODER/ce_out_i ;
  wire \UART16550_I_1/GENERATING_FIFOS.rx_fifo_rst ;
  wire \UART16550_I_1/p_2_in44_in ;
  wire Wr;
  wire baudoutn;
  wire [0:0]bus2ip_rdce_i;
  wire bus2ip_reset_int_core;
  wire [0:0]bus2ip_wrce_i;
  wire ctsn;
  wire dcdn;
  wire ddis;
  wire dsrn;
  wire dtrn;
  wire freeze;
  wire ip2intc_irpt;
  wire out1n;
  wire out2n;
  wire rin;
  wire rtsn;
  wire rxrdyn;
  wire s_axi_aclk;
  wire [12:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [12:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [7:0]\^s_axi_rdata ;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wvalid;
  wire sin;
  wire sout;
  wire txrdyn;

  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7:0] = \^s_axi_rdata [7:0];
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_wready = s_axi_awready;
  assign xout = \<const0> ;
  arty_ddr_axi_uart16550_0_0_axi_lite_ipif AXI_LITE_IPIF_I
       (.\GENERATING_FIFOS.rx_fifo_rst (\UART16550_I_1/GENERATING_FIFOS.rx_fifo_rst ),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] (s_axi_arready),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 (s_axi_awready),
        .Q(Dout),
        .SR(AXI_LITE_IPIF_I_n_4),
        .Wr(Wr),
        .\bus2ip_addr_i_reg[4] (Addr),
        .bus2ip_rdce_i(bus2ip_rdce_i),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .bus2ip_wrce_i(bus2ip_wrce_i),
        .ce_out_i(\I_SLAVE_ATTACHMENT/I_DECODER/ce_out_i ),
        .p_2_in44_in(\UART16550_I_1/p_2_in44_in ),
        .rst_reg(AXI_LITE_IPIF_I_n_5),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr[4:2]),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr[4:2]),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(\^s_axi_rdata ),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wvalid(s_axi_wvalid),
        .wrReq_d1(\IPIC_IF_I_1/wrReq_d1 ));
  GND GND
       (.G(\<const0> ));
  arty_ddr_axi_uart16550_0_0_xuart XUART_I_1
       (.\GENERATING_FIFOS.rx_fifo_rst (\UART16550_I_1/GENERATING_FIFOS.rx_fifo_rst ),
        .Q(Dout),
        .SR(AXI_LITE_IPIF_I_n_4),
        .Wr(Wr),
        .\addr_d_reg[2] (Addr),
        .baudoutn(baudoutn),
        .bus2ip_rdce_i(bus2ip_rdce_i),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .bus2ip_wrce_i(bus2ip_wrce_i),
        .ce_out_i(\I_SLAVE_ATTACHMENT/I_DECODER/ce_out_i ),
        .ctsn(ctsn),
        .dcdn(dcdn),
        .ddis(ddis),
        .dsrn(dsrn),
        .dtrn(dtrn),
        .freeze(freeze),
        .ip2intc_irpt(ip2intc_irpt),
        .out1n(out1n),
        .out2n(out2n),
        .p_2_in44_in(\UART16550_I_1/p_2_in44_in ),
        .rin(rin),
        .rtsn(rtsn),
        .rxrdyn(rxrdyn),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_arready(s_axi_arready),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata[7:0]),
        .sin(sin),
        .sout(sout),
        .thre_iir_set_reg(AXI_LITE_IPIF_I_n_5),
        .txrdyn(txrdyn),
        .wrReq_d1(\IPIC_IF_I_1/wrReq_d1 ));
endmodule

(* ORIG_REF_NAME = "ipic_if" *) 
module arty_ddr_axi_uart16550_0_0_ipic_if
   (wrReq_d1,
    s_axi_awready,
    s_axi_arready,
    Rd,
    bus2ip_reset_int_core,
    bus2ip_wrce_i,
    s_axi_aclk,
    bus2ip_rdce_i);
  output wrReq_d1;
  output s_axi_awready;
  output s_axi_arready;
  output Rd;
  input bus2ip_reset_int_core;
  input [0:0]bus2ip_wrce_i;
  input s_axi_aclk;
  input [0:0]bus2ip_rdce_i;

  wire Rd;
  wire [0:0]bus2ip_rdce_i;
  wire bus2ip_rdreq_d1;
  wire bus2ip_rdreq_d2;
  wire bus2ip_rdreq_d3;
  wire bus2ip_rdreq_d4;
  wire bus2ip_reset_int_core;
  wire [0:0]bus2ip_wrce_i;
  wire ip2bus_rdack;
  wire ip2bus_rdack_d1;
  wire ip2bus_wrack;
  wire ip2bus_wrack_d1;
  wire s_axi_aclk;
  wire s_axi_arready;
  wire s_axi_awready;
  wire wrReq_d1;
  wire wrReq_d2;
  wire wrReq_d3;

  FDRE IP2Bus_RdAcknowledge_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_rdack_d1),
        .Q(s_axi_arready),
        .R(bus2ip_reset_int_core));
  FDRE IP2Bus_WrAcknowledge_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_wrack_d1),
        .Q(s_axi_awready),
        .R(bus2ip_reset_int_core));
  FDRE bus2ip_rdreq_d1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bus2ip_rdce_i),
        .Q(bus2ip_rdreq_d1),
        .R(bus2ip_reset_int_core));
  FDRE bus2ip_rdreq_d2_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bus2ip_rdreq_d1),
        .Q(bus2ip_rdreq_d2),
        .R(bus2ip_reset_int_core));
  FDRE bus2ip_rdreq_d3_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bus2ip_rdreq_d2),
        .Q(bus2ip_rdreq_d3),
        .R(bus2ip_reset_int_core));
  FDRE bus2ip_rdreq_d4_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bus2ip_rdreq_d3),
        .Q(bus2ip_rdreq_d4),
        .R(bus2ip_reset_int_core));
  LUT2 #(
    .INIT(4'h2)) 
    ip2bus_rdack_d1_i_1
       (.I0(bus2ip_rdreq_d3),
        .I1(bus2ip_rdreq_d4),
        .O(ip2bus_rdack));
  FDRE ip2bus_rdack_d1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_rdack),
        .Q(ip2bus_rdack_d1),
        .R(bus2ip_reset_int_core));
  LUT2 #(
    .INIT(4'h2)) 
    ip2bus_wrack_d1_i_1
       (.I0(wrReq_d2),
        .I1(wrReq_d3),
        .O(ip2bus_wrack));
  FDRE ip2bus_wrack_d1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_wrack),
        .Q(ip2bus_wrack_d1),
        .R(bus2ip_reset_int_core));
  LUT2 #(
    .INIT(4'h2)) 
    rd_d_i_1
       (.I0(bus2ip_rdreq_d1),
        .I1(bus2ip_rdreq_d2),
        .O(Rd));
  FDRE wrReq_d1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bus2ip_wrce_i),
        .Q(wrReq_d1),
        .R(bus2ip_reset_int_core));
  FDRE wrReq_d2_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(wrReq_d1),
        .Q(wrReq_d2),
        .R(bus2ip_reset_int_core));
  FDRE wrReq_d3_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(wrReq_d2),
        .Q(wrReq_d3),
        .R(bus2ip_reset_int_core));
endmodule

(* ORIG_REF_NAME = "rx16550" *) 
module arty_ddr_axi_uart16550_0_0_rx16550
   (rx_fifo_data_in,
    character_received,
    \Lcr_reg[1] ,
    baudoutN_int,
    \dlm_reg[2] ,
    \dll_reg[2] ,
    SR,
    rx_fifo_wr_en_i,
    Rx_error_in_fifo0,
    D,
    \Rbr_reg[6]_0 ,
    s_axi_aclk,
    rx_sin,
    Q,
    baudoutN_int_i,
    data,
    framing_error_flag_reg_0,
    mcr4_d,
    bus2ip_reset_int_core,
    have_bi_in_fifo_n_i_reg_0,
    \character_counter_reg[0] ,
    rx_fifo_rd_en_d,
    SS,
    rx_fifo_full,
    \Dout_reg[7] ,
    \Dout_reg[7]_0 ,
    data3,
    \Dout_reg[7]_1 ,
    \Dout_reg[7]_2 ,
    \Dout_reg[4] ,
    \Dout_reg[4]_0 ,
    \Dout_reg[4]_1 ,
    out,
    \Dout_reg[1] ,
    \Dout_reg[1]_0 ,
    \Dout_reg[0] ,
    \Dout_reg[0]_0 ,
    \Dout_reg[0]_1 ,
    \Dout_reg[0]_2 ,
    \Dout_reg[1]_1 );
  output [10:0]rx_fifo_data_in;
  output character_received;
  output \Lcr_reg[1] ;
  output baudoutN_int;
  output \dlm_reg[2] ;
  output \dll_reg[2] ;
  output [0:0]SR;
  output rx_fifo_wr_en_i;
  output Rx_error_in_fifo0;
  output [3:0]D;
  output [3:0]\Rbr_reg[6]_0 ;
  input s_axi_aclk;
  input rx_sin;
  input [5:0]Q;
  input baudoutN_int_i;
  input [15:0]data;
  input [0:0]framing_error_flag_reg_0;
  input mcr4_d;
  input bus2ip_reset_int_core;
  input have_bi_in_fifo_n_i_reg_0;
  input [0:0]\character_counter_reg[0] ;
  input rx_fifo_rd_en_d;
  input [0:0]SS;
  input rx_fifo_full;
  input \Dout_reg[7] ;
  input \Dout_reg[7]_0 ;
  input [0:0]data3;
  input \Dout_reg[7]_1 ;
  input \Dout_reg[7]_2 ;
  input \Dout_reg[4] ;
  input \Dout_reg[4]_0 ;
  input \Dout_reg[4]_1 ;
  input [1:0]out;
  input \Dout_reg[1] ;
  input \Dout_reg[1]_0 ;
  input \Dout_reg[0] ;
  input \Dout_reg[0]_0 ;
  input \Dout_reg[0]_1 ;
  input \Dout_reg[0]_2 ;
  input \Dout_reg[1]_1 ;

  wire [3:0]D;
  wire \Dout[1]_i_2_n_0 ;
  wire \Dout_reg[0] ;
  wire \Dout_reg[0]_0 ;
  wire \Dout_reg[0]_1 ;
  wire \Dout_reg[0]_2 ;
  wire \Dout_reg[1] ;
  wire \Dout_reg[1]_0 ;
  wire \Dout_reg[1]_1 ;
  wire \Dout_reg[4] ;
  wire \Dout_reg[4]_0 ;
  wire \Dout_reg[4]_1 ;
  wire \Dout_reg[7] ;
  wire \Dout_reg[7]_0 ;
  wire \Dout_reg[7]_1 ;
  wire \Dout_reg[7]_2 ;
  wire \FSM_sequential_receive_state[0]_i_10_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_2_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_3_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_4_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_5_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_6_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_7_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_8_n_0 ;
  wire \FSM_sequential_receive_state[0]_i_9_n_0 ;
  wire \FSM_sequential_receive_state[1]_i_2_n_0 ;
  wire \FSM_sequential_receive_state[1]_i_3_n_0 ;
  wire \FSM_sequential_receive_state[1]_i_4_n_0 ;
  wire \FSM_sequential_receive_state[1]_i_5_n_0 ;
  wire \FSM_sequential_receive_state[3]_i_3_n_0 ;
  wire \FSM_sequential_receive_state[3]_i_4_n_0 ;
  wire \FSM_sequential_receive_state[3]_i_5_n_0 ;
  wire \FSM_sequential_receive_state[3]_i_6_n_0 ;
  wire \FSM_sequential_receive_state[3]_i_7_n_0 ;
  wire \Lcr_reg[1] ;
  wire \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_3_n_0 ;
  wire \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_5_n_0 ;
  wire [5:0]Q;
  wire [7:0]Rbr;
  wire [3:0]\Rbr_reg[6]_0 ;
  wire Rx_error_in_fifo0;
  wire [0:0]SR;
  wire [0:0]SS;
  wire baudoutN_int;
  wire baudoutN_int_i;
  wire break_interrupt_error_d_i_1_n_0;
  wire break_interrupt_error_d_i_2_n_0;
  wire break_interrupt_error_d_i_3_n_0;
  wire break_interrupt_error_d_i_4_n_0;
  wire break_interrupt_error_d_i_5_n_0;
  wire break_interrupt_error_d_i_6_n_0;
  wire break_interrupt_error_d_i_7_n_0;
  wire break_interrupt_error_d_i_8_n_0;
  wire break_interrupt_error_d_reg_n_0;
  wire break_interrupt_flag;
  wire break_interrupt_flag_i_2_n_0;
  wire break_interrupt_i0;
  wire bus2ip_reset_int_core;
  wire [0:0]\character_counter_reg[0] ;
  wire character_received;
  wire character_received_d;
  wire character_received_d_i_1_n_0;
  wire character_received_flag;
  wire character_received_flag0;
  wire character_received_rclk;
  wire clk1x;
  wire clk1x_d;
  wire clk1x_i_2_n_0;
  wire clk1x_i_3_n_0;
  wire clk1x_i_4_n_0;
  wire clk1x_i_5_n_0;
  wire clk2x;
  wire clk2x_i_1__0_n_0;
  wire clk_div_en_i_1_n_0;
  wire clk_div_en_i_2_n_0;
  wire clk_div_en_i_3_n_0;
  wire clk_div_en_reg_n_0;
  wire [3:0]clkdiv;
  wire \clkdiv[2]_i_2_n_0 ;
  wire \clkdiv[2]_i_3_n_0 ;
  wire \clkdiv[3]_i_1_n_0 ;
  wire \clkdiv[3]_i_3_n_0 ;
  wire \clkdiv[3]_i_4_n_0 ;
  wire \clkdiv[3]_i_5_n_0 ;
  wire \clkdiv[3]_i_6_n_0 ;
  wire \clkdiv[3]_i_7_n_0 ;
  wire \clkdiv[3]_i_8_n_0 ;
  wire \clkdiv_reg_n_0_[0] ;
  wire \clkdiv_reg_n_0_[1] ;
  wire \clkdiv_reg_n_0_[2] ;
  wire \clkdiv_reg_n_0_[3] ;
  wire clock_1x_early;
  wire clock_1x_early_i_1_n_0;
  wire [15:0]data;
  wire [0:0]data3;
  wire \dll_reg[2] ;
  wire \dlm_reg[2] ;
  wire framing_error_d;
  wire framing_error_d_i_1_n_0;
  wire framing_error_d_i_2_n_0;
  wire framing_error_d_i_3_n_0;
  wire framing_error_flag;
  wire framing_error_flag0;
  wire framing_error_flag_i_1_n_0;
  wire [0:0]framing_error_flag_reg_0;
  wire framing_error_i0;
  wire got_start_bit_com;
  wire got_start_bit_d;
  wire have_bi_in_fifo_n;
  wire have_bi_in_fifo_n_i_i_1_n_0;
  wire have_bi_in_fifo_n_i_i_2_n_0;
  wire have_bi_in_fifo_n_i_reg_0;
  wire load_rbr_com;
  wire load_rbr_d;
  wire load_rbr_d_i_1_n_0;
  wire mcr4_d;
  wire [3:0]next_state;
  wire [1:0]out;
  wire parity_error_d;
  wire parity_error_d0;
  wire parity_error_d_i_2_n_0;
  wire parity_error_d_i_4_n_0;
  wire parity_error_d_i_5_n_0;
  wire parity_error_d_i_6_n_0;
  wire parity_error_d_i_7_n_0;
  wire parity_error_i0;
  wire parity_error_latch;
  wire parity_error_latch_i_1_n_0;
  wire rbr_d0;
  wire \rbr_d[0]_i_1_n_0 ;
  wire \rbr_d[1]_i_1_n_0 ;
  wire \rbr_d[2]_i_1_n_0 ;
  wire \rbr_d[3]_i_1_n_0 ;
  wire \rbr_d[4]_i_1_n_0 ;
  wire \rbr_d[5]_i_1_n_0 ;
  wire \rbr_d[6]_i_1_n_0 ;
  wire \rbr_d[7]_i_2_n_0 ;
  wire rclk_int;
  wire [3:0]receive_state;
  wire resynch_clkdiv;
  wire resynch_clkdiv_d;
  wire resynch_clkdiv_d_i_2_n_0;
  wire resynch_clkdiv_frame_d;
  wire resynch_clkdiv_frame_d_i_1_n_0;
  wire resynch_clkdiv_frame_d_i_2_n_0;
  wire resynch_clkdiv_frame_d_i_3_n_0;
  wire resynch_clkdiv_startbit;
  wire resynch_clkdiv_startbit_d;
  wire resynch_clkdiv_startbit_d_i_2_n_0;
  wire resynch_clkdiv_startbit_d_i_3_n_0;
  wire [7:0]rsr;
  wire [10:0]rx_fifo_data_in;
  wire rx_fifo_full;
  wire rx_fifo_rd_en_d;
  wire rx_fifo_wr_en_i;
  wire rx_parity_com;
  wire rx_rst;
  wire rx_sin;
  wire s_axi_aclk;
  wire sin_d1;
  wire sin_d10;
  wire sin_d2;
  wire sin_d3;
  wire sin_d4;
  wire sin_d5;
  wire sin_d6;
  wire sin_d7;
  wire sin_d8;
  wire sin_d9;

  FDRE Data_ready_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(character_received_flag),
        .Q(character_received),
        .R(rx_rst));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF4F44)) 
    \Dout[0]_i_1 
       (.I0(\Dout_reg[0] ),
        .I1(\Dout_reg[0]_0 ),
        .I2(\Dout_reg[7]_1 ),
        .I3(Rbr[0]),
        .I4(\Dout_reg[0]_1 ),
        .I5(\Dout_reg[0]_2 ),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFFBAFFBABA)) 
    \Dout[1]_i_1 
       (.I0(\Dout[1]_i_2_n_0 ),
        .I1(\Dout_reg[7]_0 ),
        .I2(\Dout_reg[1] ),
        .I3(\Dout_reg[4]_1 ),
        .I4(out[0]),
        .I5(\Dout_reg[1]_0 ),
        .O(D[1]));
  LUT4 #(
    .INIT(16'h4F44)) 
    \Dout[1]_i_2 
       (.I0(\Dout_reg[0] ),
        .I1(\Dout_reg[1]_1 ),
        .I2(\Dout_reg[7]_1 ),
        .I3(Rbr[1]),
        .O(\Dout[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFEEFFFFEFEEEFEE)) 
    \Dout[4]_i_1 
       (.I0(\Dout_reg[4] ),
        .I1(\Dout_reg[4]_0 ),
        .I2(\Dout_reg[7]_1 ),
        .I3(Rbr[4]),
        .I4(\Dout_reg[4]_1 ),
        .I5(out[1]),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hFFFFFFFFBABAFFBA)) 
    \Dout[7]_i_2 
       (.I0(\Dout_reg[7] ),
        .I1(\Dout_reg[7]_0 ),
        .I2(data3),
        .I3(Rbr[7]),
        .I4(\Dout_reg[7]_1 ),
        .I5(\Dout_reg[7]_2 ),
        .O(D[3]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFF01)) 
    \FSM_sequential_receive_state[0]_i_1 
       (.I0(\FSM_sequential_receive_state[0]_i_2_n_0 ),
        .I1(sin_d2),
        .I2(Q[2]),
        .I3(\FSM_sequential_receive_state[0]_i_3_n_0 ),
        .I4(\FSM_sequential_receive_state[0]_i_4_n_0 ),
        .I5(\FSM_sequential_receive_state[0]_i_5_n_0 ),
        .O(next_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \FSM_sequential_receive_state[0]_i_10 
       (.I0(receive_state[1]),
        .I1(receive_state[2]),
        .I2(receive_state[3]),
        .O(\FSM_sequential_receive_state[0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFB3FFB3FFB3F3B3F)) 
    \FSM_sequential_receive_state[0]_i_2 
       (.I0(receive_state[1]),
        .I1(receive_state[3]),
        .I2(receive_state[2]),
        .I3(receive_state[0]),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(\FSM_sequential_receive_state[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAEAEAEBBAAAAAAAA)) 
    \FSM_sequential_receive_state[0]_i_3 
       (.I0(\FSM_sequential_receive_state[0]_i_6_n_0 ),
        .I1(receive_state[0]),
        .I2(receive_state[3]),
        .I3(receive_state[2]),
        .I4(receive_state[1]),
        .I5(sin_d2),
        .O(\FSM_sequential_receive_state[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h202020200000FF0F)) 
    \FSM_sequential_receive_state[0]_i_4 
       (.I0(Q[3]),
        .I1(\Lcr_reg[1] ),
        .I2(receive_state[3]),
        .I3(\FSM_sequential_receive_state[0]_i_7_n_0 ),
        .I4(receive_state[0]),
        .I5(receive_state[2]),
        .O(\FSM_sequential_receive_state[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h030303030F020202)) 
    \FSM_sequential_receive_state[0]_i_5 
       (.I0(\FSM_sequential_receive_state[0]_i_8_n_0 ),
        .I1(\FSM_sequential_receive_state[0]_i_9_n_0 ),
        .I2(receive_state[0]),
        .I3(Q[3]),
        .I4(receive_state[3]),
        .I5(\FSM_sequential_receive_state[3]_i_5_n_0 ),
        .O(\FSM_sequential_receive_state[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h000000F100000000)) 
    \FSM_sequential_receive_state[0]_i_6 
       (.I0(sin_d2),
        .I1(Q[2]),
        .I2(Q[3]),
        .I3(\FSM_sequential_receive_state[0]_i_10_n_0 ),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(\FSM_sequential_receive_state[0]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_sequential_receive_state[0]_i_7 
       (.I0(Q[2]),
        .I1(receive_state[1]),
        .O(\FSM_sequential_receive_state[0]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \FSM_sequential_receive_state[0]_i_8 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\FSM_sequential_receive_state[0]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \FSM_sequential_receive_state[0]_i_9 
       (.I0(receive_state[2]),
        .I1(receive_state[1]),
        .O(\FSM_sequential_receive_state[0]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'hFF01)) 
    \FSM_sequential_receive_state[1]_i_1 
       (.I0(\FSM_sequential_receive_state[1]_i_2_n_0 ),
        .I1(sin_d2),
        .I2(Q[2]),
        .I3(\FSM_sequential_receive_state[1]_i_3_n_0 ),
        .O(next_state[1]));
  LUT6 #(
    .INIT(64'hFFFFBBBB40FF11BB)) 
    \FSM_sequential_receive_state[1]_i_2 
       (.I0(receive_state[2]),
        .I1(receive_state[0]),
        .I2(\FSM_sequential_receive_state[1]_i_4_n_0 ),
        .I3(receive_state[3]),
        .I4(receive_state[1]),
        .I5(Q[3]),
        .O(\FSM_sequential_receive_state[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF01120012)) 
    \FSM_sequential_receive_state[1]_i_3 
       (.I0(receive_state[2]),
        .I1(receive_state[1]),
        .I2(receive_state[0]),
        .I3(receive_state[3]),
        .I4(Q[2]),
        .I5(\FSM_sequential_receive_state[1]_i_5_n_0 ),
        .O(\FSM_sequential_receive_state[1]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \FSM_sequential_receive_state[1]_i_4 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(\FSM_sequential_receive_state[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hC0C0C00020200020)) 
    \FSM_sequential_receive_state[1]_i_5 
       (.I0(receive_state[1]),
        .I1(receive_state[2]),
        .I2(receive_state[3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(receive_state[0]),
        .O(\FSM_sequential_receive_state[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h21BC01BC21BC21BC)) 
    \FSM_sequential_receive_state[2]_i_1 
       (.I0(receive_state[0]),
        .I1(receive_state[2]),
        .I2(receive_state[1]),
        .I3(receive_state[3]),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(next_state[2]));
  LUT4 #(
    .INIT(16'hBEFF)) 
    \FSM_sequential_receive_state[3]_i_1 
       (.I0(bus2ip_reset_int_core),
        .I1(mcr4_d),
        .I2(framing_error_flag_reg_0),
        .I3(have_bi_in_fifo_n),
        .O(parity_error_d0));
  LUT6 #(
    .INIT(64'hEFEEEFEFEFEEEFEE)) 
    \FSM_sequential_receive_state[3]_i_2 
       (.I0(\FSM_sequential_receive_state[3]_i_3_n_0 ),
        .I1(\FSM_sequential_receive_state[3]_i_4_n_0 ),
        .I2(\FSM_sequential_receive_state[3]_i_5_n_0 ),
        .I3(\FSM_sequential_receive_state[3]_i_6_n_0 ),
        .I4(\FSM_sequential_receive_state[3]_i_7_n_0 ),
        .I5(receive_state[3]),
        .O(next_state[3]));
  LUT6 #(
    .INIT(64'hE010E00000DC0000)) 
    \FSM_sequential_receive_state[3]_i_3 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(receive_state[3]),
        .I3(receive_state[2]),
        .I4(receive_state[1]),
        .I5(receive_state[0]),
        .O(\FSM_sequential_receive_state[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hEAAA0000EA000F00)) 
    \FSM_sequential_receive_state[3]_i_4 
       (.I0(Q[3]),
        .I1(Q[0]),
        .I2(receive_state[0]),
        .I3(receive_state[1]),
        .I4(receive_state[3]),
        .I5(receive_state[2]),
        .O(\FSM_sequential_receive_state[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_receive_state[3]_i_5 
       (.I0(sin_d2),
        .I1(Q[2]),
        .O(\FSM_sequential_receive_state[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'h04)) 
    \FSM_sequential_receive_state[3]_i_6 
       (.I0(receive_state[0]),
        .I1(receive_state[1]),
        .I2(receive_state[2]),
        .O(\FSM_sequential_receive_state[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_receive_state[3]_i_7 
       (.I0(receive_state[0]),
        .I1(receive_state[2]),
        .O(\FSM_sequential_receive_state[3]_i_7_n_0 ));
  (* FSM_ENCODED_STATES = "data_bit3:0001,data_bit2:0000,data_bit1:0110,frame_error:0011,stop_bit1:1000,stop_bit2:0111,parity_bit:1001,start_bit:0100,idle:0101,data_bit6:1010,data_bit8:1100,data_bit5:1101,data_bit7:1011,data_bit4:0010" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_sequential_receive_state_reg[0] 
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(next_state[0]),
        .Q(receive_state[0]),
        .S(parity_error_d0));
  (* FSM_ENCODED_STATES = "data_bit3:0001,data_bit2:0000,data_bit1:0110,frame_error:0011,stop_bit1:1000,stop_bit2:0111,parity_bit:1001,start_bit:0100,idle:0101,data_bit6:1010,data_bit8:1100,data_bit5:1101,data_bit7:1011,data_bit4:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_receive_state_reg[1] 
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(next_state[1]),
        .Q(receive_state[1]),
        .R(parity_error_d0));
  (* FSM_ENCODED_STATES = "data_bit3:0001,data_bit2:0000,data_bit1:0110,frame_error:0011,stop_bit1:1000,stop_bit2:0111,parity_bit:1001,start_bit:0100,idle:0101,data_bit6:1010,data_bit8:1100,data_bit5:1101,data_bit7:1011,data_bit4:0010" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_sequential_receive_state_reg[2] 
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(next_state[2]),
        .Q(receive_state[2]),
        .S(parity_error_d0));
  (* FSM_ENCODED_STATES = "data_bit3:0001,data_bit2:0000,data_bit1:0110,frame_error:0011,stop_bit1:1000,stop_bit2:0111,parity_bit:1001,start_bit:0100,idle:0101,data_bit6:1010,data_bit8:1100,data_bit5:1101,data_bit7:1011,data_bit4:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_receive_state_reg[3] 
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(next_state[3]),
        .Q(receive_state[3]),
        .R(parity_error_d0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_sequential_transmit_state[3]_i_4 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\Lcr_reg[1] ));
  LUT5 #(
    .INIT(32'hAAAAA8AA)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_1 
       (.I0(baudoutN_int_i),
        .I1(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_3_n_0 ),
        .I2(\dlm_reg[2] ),
        .I3(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_5_n_0 ),
        .I4(\dll_reg[2] ),
        .O(baudoutN_int));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_3 
       (.I0(data[14]),
        .I1(data[15]),
        .I2(data[12]),
        .I3(data[13]),
        .O(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_4 
       (.I0(data[10]),
        .I1(data[11]),
        .I2(data[8]),
        .I3(data[9]),
        .O(\dlm_reg[2] ));
  LUT4 #(
    .INIT(16'h0001)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_5 
       (.I0(data[5]),
        .I1(data[6]),
        .I2(data[4]),
        .I3(data[7]),
        .O(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_6 
       (.I0(data[2]),
        .I1(data[3]),
        .I2(data[0]),
        .I3(data[1]),
        .O(\dll_reg[2] ));
  FDRE \Rbr_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[0]),
        .Q(Rbr[0]),
        .R(rx_rst));
  FDRE \Rbr_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[1]),
        .Q(Rbr[1]),
        .R(rx_rst));
  FDRE \Rbr_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[2]),
        .Q(\Rbr_reg[6]_0 [0]),
        .R(rx_rst));
  FDRE \Rbr_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[3]),
        .Q(\Rbr_reg[6]_0 [1]),
        .R(rx_rst));
  FDRE \Rbr_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[4]),
        .Q(Rbr[4]),
        .R(rx_rst));
  FDRE \Rbr_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[5]),
        .Q(\Rbr_reg[6]_0 [2]),
        .R(rx_rst));
  FDRE \Rbr_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[6]),
        .Q(\Rbr_reg[6]_0 [3]),
        .R(rx_rst));
  FDRE \Rbr_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_data_in[7]),
        .Q(Rbr[7]),
        .R(rx_rst));
  LUT4 #(
    .INIT(16'hAAA8)) 
    Rx_error_in_fifo_i_1
       (.I0(rx_fifo_wr_en_i),
        .I1(rx_fifo_data_in[8]),
        .I2(rx_fifo_data_in[10]),
        .I3(rx_fifo_data_in[9]),
        .O(Rx_error_in_fifo0));
  LUT6 #(
    .INIT(64'h00000000BA8ABAAA)) 
    break_interrupt_error_d_i_1
       (.I0(break_interrupt_error_d_reg_n_0),
        .I1(break_interrupt_error_d_i_2_n_0),
        .I2(clk1x),
        .I3(break_interrupt_error_d_i_3_n_0),
        .I4(break_interrupt_error_d_i_4_n_0),
        .I5(parity_error_d0),
        .O(break_interrupt_error_d_i_1_n_0));
  LUT6 #(
    .INIT(64'h2222222200200220)) 
    break_interrupt_error_d_i_2
       (.I0(break_interrupt_error_d_i_5_n_0),
        .I1(break_interrupt_error_d_i_6_n_0),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(receive_state[0]),
        .I5(\FSM_sequential_receive_state[0]_i_9_n_0 ),
        .O(break_interrupt_error_d_i_2_n_0));
  LUT6 #(
    .INIT(64'h2A2A02AA2A2802AA)) 
    break_interrupt_error_d_i_3
       (.I0(sin_d2),
        .I1(receive_state[1]),
        .I2(receive_state[2]),
        .I3(receive_state[0]),
        .I4(receive_state[3]),
        .I5(Q[2]),
        .O(break_interrupt_error_d_i_3_n_0));
  LUT6 #(
    .INIT(64'h2222222202002200)) 
    break_interrupt_error_d_i_4
       (.I0(break_interrupt_error_d_i_7_n_0),
        .I1(break_interrupt_error_d_i_8_n_0),
        .I2(\Lcr_reg[1] ),
        .I3(receive_state[0]),
        .I4(receive_state[3]),
        .I5(resynch_clkdiv_startbit_d_i_3_n_0),
        .O(break_interrupt_error_d_i_4_n_0));
  LUT6 #(
    .INIT(64'hFF0000CCFF4FCCCC)) 
    break_interrupt_error_d_i_5
       (.I0(\Lcr_reg[1] ),
        .I1(Q[2]),
        .I2(receive_state[0]),
        .I3(receive_state[1]),
        .I4(receive_state[2]),
        .I5(Q[3]),
        .O(break_interrupt_error_d_i_5_n_0));
  LUT6 #(
    .INIT(64'h7777FFFF55575757)) 
    break_interrupt_error_d_i_6
       (.I0(receive_state[3]),
        .I1(receive_state[2]),
        .I2(receive_state[0]),
        .I3(Q[0]),
        .I4(receive_state[1]),
        .I5(sin_d2),
        .O(break_interrupt_error_d_i_6_n_0));
  LUT6 #(
    .INIT(64'hF4FFCCC0F2FFCCC0)) 
    break_interrupt_error_d_i_7
       (.I0(Q[0]),
        .I1(receive_state[0]),
        .I2(receive_state[2]),
        .I3(receive_state[1]),
        .I4(receive_state[3]),
        .I5(Q[1]),
        .O(break_interrupt_error_d_i_7_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h77006000)) 
    break_interrupt_error_d_i_8
       (.I0(receive_state[1]),
        .I1(receive_state[2]),
        .I2(Q[3]),
        .I3(receive_state[3]),
        .I4(Q[2]),
        .O(break_interrupt_error_d_i_8_n_0));
  FDRE break_interrupt_error_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(break_interrupt_error_d_i_1_n_0),
        .Q(break_interrupt_error_d_reg_n_0),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hFFBE)) 
    break_interrupt_flag_i_1
       (.I0(character_received_rclk),
        .I1(framing_error_flag_reg_0),
        .I2(mcr4_d),
        .I3(bus2ip_reset_int_core),
        .O(framing_error_flag0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hF4)) 
    break_interrupt_flag_i_2
       (.I0(baudoutN_int),
        .I1(break_interrupt_error_d_reg_n_0),
        .I2(break_interrupt_flag),
        .O(break_interrupt_flag_i_2_n_0));
  FDRE break_interrupt_flag_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(break_interrupt_flag_i_2_n_0),
        .Q(break_interrupt_flag),
        .R(framing_error_flag0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h2)) 
    break_interrupt_i_i_1
       (.I0(character_received_flag),
        .I1(break_interrupt_flag),
        .O(break_interrupt_i0));
  FDRE break_interrupt_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(break_interrupt_i0),
        .Q(rx_fifo_data_in[8]),
        .R(rx_rst));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \character_counter[9]_i_1 
       (.I0(rx_fifo_wr_en_i),
        .I1(\character_counter_reg[0] ),
        .I2(rx_fifo_rd_en_d),
        .I3(SS),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h44004402)) 
    character_received_d_i_1
       (.I0(receive_state[3]),
        .I1(receive_state[1]),
        .I2(receive_state[2]),
        .I3(receive_state[0]),
        .I4(Q[2]),
        .O(character_received_d_i_1_n_0));
  FDRE character_received_d_reg
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(character_received_d_i_1_n_0),
        .Q(character_received_d),
        .R(parity_error_d0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h2)) 
    character_received_flag_i_1
       (.I0(character_received_d),
        .I1(baudoutN_int),
        .O(character_received_flag0));
  FDRE character_received_flag_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(character_received_flag0),
        .Q(character_received_flag),
        .R(framing_error_flag0));
  FDRE character_received_rclk_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(character_received_d),
        .Q(character_received_rclk),
        .R(rx_rst));
  FDRE clk1x_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clk1x),
        .Q(clk1x_d),
        .R(rx_rst));
  LUT3 #(
    .INIT(8'hBE)) 
    clk1x_i_1
       (.I0(bus2ip_reset_int_core),
        .I1(mcr4_d),
        .I2(framing_error_flag_reg_0),
        .O(rx_rst));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    clk1x_i_2
       (.I0(baudoutN_int),
        .I1(clk1x_i_3_n_0),
        .I2(\clkdiv_reg_n_0_[0] ),
        .I3(\clkdiv_reg_n_0_[1] ),
        .I4(\clkdiv_reg_n_0_[2] ),
        .I5(\clkdiv_reg_n_0_[3] ),
        .O(clk1x_i_2_n_0));
  LUT5 #(
    .INIT(32'h10110000)) 
    clk1x_i_3
       (.I0(clk1x_i_4_n_0),
        .I1(clk1x_i_5_n_0),
        .I2(receive_state[2]),
        .I3(Q[2]),
        .I4(got_start_bit_d),
        .O(clk1x_i_3_n_0));
  LUT6 #(
    .INIT(64'hBFBFBEBFFDFDFDFD)) 
    clk1x_i_4
       (.I0(receive_state[3]),
        .I1(receive_state[0]),
        .I2(receive_state[1]),
        .I3(sin_d10),
        .I4(sin_d9),
        .I5(receive_state[2]),
        .O(clk1x_i_4_n_0));
  LUT6 #(
    .INIT(64'hDDDDDDDDDDD0DDDD)) 
    clk1x_i_5
       (.I0(receive_state[2]),
        .I1(receive_state[1]),
        .I2(framing_error_d),
        .I3(sin_d5),
        .I4(sin_d6),
        .I5(clock_1x_early),
        .O(clk1x_i_5_n_0));
  FDRE clk1x_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clk1x_i_2_n_0),
        .Q(clk1x),
        .R(rx_rst));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    clk2x_i_1__0
       (.I0(baudoutN_int),
        .I1(\clkdiv_reg_n_0_[2] ),
        .I2(\clkdiv_reg_n_0_[0] ),
        .I3(\clkdiv_reg_n_0_[1] ),
        .I4(\clkdiv_reg_n_0_[3] ),
        .O(clk2x_i_1__0_n_0));
  FDRE clk2x_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clk2x_i_1__0_n_0),
        .Q(clk2x),
        .R(rx_rst));
  LUT6 #(
    .INIT(64'h4044444400000000)) 
    clk_div_en_i_1
       (.I0(rx_rst),
        .I1(have_bi_in_fifo_n),
        .I2(resynch_clkdiv_startbit_d_i_3_n_0),
        .I3(clk_div_en_i_2_n_0),
        .I4(clk1x_d),
        .I5(clk_div_en_i_3_n_0),
        .O(clk_div_en_i_1_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    clk_div_en_i_2
       (.I0(receive_state[0]),
        .I1(receive_state[3]),
        .O(clk_div_en_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'hFFFF0004)) 
    clk_div_en_i_3
       (.I0(sin_d1),
        .I1(sin_d2),
        .I2(got_start_bit_d),
        .I3(baudoutN_int),
        .I4(clk_div_en_reg_n_0),
        .O(clk_div_en_i_3_n_0));
  FDRE clk_div_en_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clk_div_en_i_1_n_0),
        .Q(clk_div_en_reg_n_0),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hF0F0F0FB)) 
    \clkdiv[0]_i_1__0 
       (.I0(baudoutN_int),
        .I1(clk1x_i_3_n_0),
        .I2(\clkdiv[2]_i_2_n_0 ),
        .I3(\clkdiv_reg_n_0_[0] ),
        .I4(\clkdiv[3]_i_3_n_0 ),
        .O(clkdiv[0]));
  LUT6 #(
    .INIT(64'hF0F0F0FBF0FBF0F0)) 
    \clkdiv[1]_i_1__0 
       (.I0(baudoutN_int),
        .I1(clk1x_i_3_n_0),
        .I2(\clkdiv[2]_i_2_n_0 ),
        .I3(\clkdiv[3]_i_3_n_0 ),
        .I4(\clkdiv_reg_n_0_[0] ),
        .I5(\clkdiv_reg_n_0_[1] ),
        .O(clkdiv[1]));
  LUT6 #(
    .INIT(64'hF0F0F0F0F0F0FBF0)) 
    \clkdiv[2]_i_1__0 
       (.I0(baudoutN_int),
        .I1(clk1x_i_3_n_0),
        .I2(\clkdiv[2]_i_2_n_0 ),
        .I3(clk_div_en_reg_n_0),
        .I4(rx_rst),
        .I5(\clkdiv[2]_i_3_n_0 ),
        .O(clkdiv[2]));
  LUT6 #(
    .INIT(64'h0000000000200000)) 
    \clkdiv[2]_i_2 
       (.I0(clk_div_en_reg_n_0),
        .I1(rx_rst),
        .I2(clk2x),
        .I3(\Lcr_reg[1] ),
        .I4(Q[2]),
        .I5(\clkdiv[3]_i_4_n_0 ),
        .O(\clkdiv[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5555555555554111)) 
    \clkdiv[2]_i_3 
       (.I0(resynch_clkdiv_d),
        .I1(\clkdiv_reg_n_0_[2] ),
        .I2(\clkdiv_reg_n_0_[0] ),
        .I3(\clkdiv_reg_n_0_[1] ),
        .I4(resynch_clkdiv_startbit_d),
        .I5(resynch_clkdiv_frame_d),
        .O(\clkdiv[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAABAAAAAFFFFFFFF)) 
    \clkdiv[3]_i_1 
       (.I0(\clkdiv[3]_i_3_n_0 ),
        .I1(\clkdiv[3]_i_4_n_0 ),
        .I2(Q[2]),
        .I3(\Lcr_reg[1] ),
        .I4(clk2x),
        .I5(baudoutN_int),
        .O(\clkdiv[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h4044404040444044)) 
    \clkdiv[3]_i_2 
       (.I0(\clkdiv[3]_i_5_n_0 ),
        .I1(\clkdiv[3]_i_6_n_0 ),
        .I2(\clkdiv[3]_i_7_n_0 ),
        .I3(resynch_clkdiv_startbit_d_i_2_n_0),
        .I4(receive_state[2]),
        .I5(Q[2]),
        .O(clkdiv[3]));
  LUT5 #(
    .INIT(32'hFFFFFEFF)) 
    \clkdiv[3]_i_3 
       (.I0(resynch_clkdiv_frame_d),
        .I1(resynch_clkdiv_startbit_d),
        .I2(rx_rst),
        .I3(clk_div_en_reg_n_0),
        .I4(resynch_clkdiv_d),
        .O(\clkdiv[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'hFFFD)) 
    \clkdiv[3]_i_4 
       (.I0(receive_state[3]),
        .I1(receive_state[1]),
        .I2(receive_state[2]),
        .I3(receive_state[0]),
        .O(\clkdiv[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h1000000001111111)) 
    \clkdiv[3]_i_5 
       (.I0(resynch_clkdiv_frame_d),
        .I1(resynch_clkdiv_startbit_d),
        .I2(\clkdiv_reg_n_0_[2] ),
        .I3(\clkdiv_reg_n_0_[0] ),
        .I4(\clkdiv_reg_n_0_[1] ),
        .I5(\clkdiv_reg_n_0_[3] ),
        .O(\clkdiv[3]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h04000004)) 
    \clkdiv[3]_i_6 
       (.I0(resynch_clkdiv_d),
        .I1(clk_div_en_reg_n_0),
        .I2(bus2ip_reset_int_core),
        .I3(mcr4_d),
        .I4(framing_error_flag_reg_0),
        .O(\clkdiv[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hF8F8FCFCF8FFFCFC)) 
    \clkdiv[3]_i_7 
       (.I0(receive_state[1]),
        .I1(clk1x_i_5_n_0),
        .I2(clk1x_i_4_n_0),
        .I3(receive_state[2]),
        .I4(Q[2]),
        .I5(\clkdiv[3]_i_8_n_0 ),
        .O(\clkdiv[3]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \clkdiv[3]_i_8 
       (.I0(clk2x),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(\clkdiv[3]_i_8_n_0 ));
  FDRE \clkdiv_reg[0] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1_n_0 ),
        .D(clkdiv[0]),
        .Q(\clkdiv_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \clkdiv_reg[1] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1_n_0 ),
        .D(clkdiv[1]),
        .Q(\clkdiv_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \clkdiv_reg[2] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1_n_0 ),
        .D(clkdiv[2]),
        .Q(\clkdiv_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \clkdiv_reg[3] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1_n_0 ),
        .D(clkdiv[3]),
        .Q(\clkdiv_reg_n_0_[3] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h00100000)) 
    clock_1x_early_i_1
       (.I0(baudoutN_int),
        .I1(\clkdiv_reg_n_0_[0] ),
        .I2(\clkdiv_reg_n_0_[1] ),
        .I3(\clkdiv_reg_n_0_[3] ),
        .I4(\clkdiv_reg_n_0_[2] ),
        .O(clock_1x_early_i_1_n_0));
  FDRE clock_1x_early_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clock_1x_early_i_1_n_0),
        .Q(clock_1x_early),
        .R(rx_rst));
  LUT4 #(
    .INIT(16'h0080)) 
    \data_reg[15][10]_srl16_i_1 
       (.I0(character_received),
        .I1(have_bi_in_fifo_n_i_reg_0),
        .I2(have_bi_in_fifo_n),
        .I3(rx_fifo_full),
        .O(rx_fifo_wr_en_i));
  LUT5 #(
    .INIT(32'h01550101)) 
    framing_error_d_i_1
       (.I0(sin_d2),
        .I1(Q[3]),
        .I2(framing_error_d_i_2_n_0),
        .I3(receive_state[2]),
        .I4(framing_error_d_i_3_n_0),
        .O(framing_error_d_i_1_n_0));
  LUT6 #(
    .INIT(64'hFBFFEBFFD9FFF1FF)) 
    framing_error_d_i_2
       (.I0(receive_state[0]),
        .I1(receive_state[2]),
        .I2(receive_state[1]),
        .I3(receive_state[3]),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(framing_error_d_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h40)) 
    framing_error_d_i_3
       (.I0(receive_state[1]),
        .I1(receive_state[0]),
        .I2(receive_state[3]),
        .O(framing_error_d_i_3_n_0));
  FDRE framing_error_d_reg
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(framing_error_d_i_1_n_0),
        .Q(framing_error_d),
        .R(parity_error_d0));
  LUT3 #(
    .INIT(8'hF4)) 
    framing_error_flag_i_1
       (.I0(baudoutN_int),
        .I1(framing_error_d),
        .I2(framing_error_flag),
        .O(framing_error_flag_i_1_n_0));
  FDRE framing_error_flag_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(framing_error_flag_i_1_n_0),
        .Q(framing_error_flag),
        .R(framing_error_flag0));
  LUT2 #(
    .INIT(4'h8)) 
    framing_error_i_i_1
       (.I0(character_received_flag),
        .I1(framing_error_flag),
        .O(framing_error_i0));
  FDRE framing_error_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(framing_error_i0),
        .Q(rx_fifo_data_in[9]),
        .R(rx_rst));
  LUT6 #(
    .INIT(64'h0FFF0FFB303FFFFF)) 
    got_start_bit_d_i_1
       (.I0(Q[2]),
        .I1(sin_d2),
        .I2(receive_state[1]),
        .I3(receive_state[2]),
        .I4(receive_state[0]),
        .I5(receive_state[3]),
        .O(got_start_bit_com));
  FDRE got_start_bit_d_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(got_start_bit_com),
        .Q(got_start_bit_d),
        .R(rx_rst));
  LUT4 #(
    .INIT(16'hFFF6)) 
    have_bi_in_fifo_n_i_i_1
       (.I0(framing_error_flag_reg_0),
        .I1(mcr4_d),
        .I2(bus2ip_reset_int_core),
        .I3(have_bi_in_fifo_n_i_i_2_n_0),
        .O(have_bi_in_fifo_n_i_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFBABFAAAAAAAA)) 
    have_bi_in_fifo_n_i_i_2
       (.I0(sin_d2),
        .I1(rx_fifo_data_in[8]),
        .I2(have_bi_in_fifo_n_i_reg_0),
        .I3(character_received_flag),
        .I4(break_interrupt_flag),
        .I5(have_bi_in_fifo_n),
        .O(have_bi_in_fifo_n_i_i_2_n_0));
  FDRE have_bi_in_fifo_n_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(have_bi_in_fifo_n_i_i_1_n_0),
        .Q(have_bi_in_fifo_n),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h00004540)) 
    load_rbr_d_i_1
       (.I0(rx_rst),
        .I1(load_rbr_com),
        .I2(clk2x),
        .I3(load_rbr_d),
        .I4(resynch_clkdiv_d),
        .O(load_rbr_d_i_1_n_0));
  FDRE load_rbr_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(load_rbr_d_i_1_n_0),
        .Q(load_rbr_d),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFFEAAAAAAA)) 
    parity_error_d_i_1
       (.I0(parity_error_d_i_2_n_0),
        .I1(load_rbr_com),
        .I2(sin_d2),
        .I3(Q[4]),
        .I4(Q[5]),
        .I5(parity_error_d_i_4_n_0),
        .O(rx_parity_com));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h00001E10)) 
    parity_error_d_i_2
       (.I0(receive_state[1]),
        .I1(receive_state[2]),
        .I2(receive_state[3]),
        .I3(receive_state[0]),
        .I4(Q[4]),
        .O(parity_error_d_i_2_n_0));
  LUT6 #(
    .INIT(64'h00241F0000000000)) 
    parity_error_d_i_3
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(receive_state[0]),
        .I3(receive_state[2]),
        .I4(receive_state[1]),
        .I5(receive_state[3]),
        .O(load_rbr_com));
  LUT6 #(
    .INIT(64'h111144F411114444)) 
    parity_error_d_i_4
       (.I0(parity_error_d_i_5_n_0),
        .I1(parity_error_d),
        .I2(Q[5]),
        .I3(Q[4]),
        .I4(sin_d2),
        .I5(parity_error_d_i_6_n_0),
        .O(parity_error_d_i_4_n_0));
  LUT6 #(
    .INIT(64'hAAAA82AA8AAA82AA)) 
    parity_error_d_i_5
       (.I0(break_interrupt_error_d_i_7_n_0),
        .I1(receive_state[1]),
        .I2(receive_state[2]),
        .I3(receive_state[3]),
        .I4(Q[5]),
        .I5(parity_error_d_i_7_n_0),
        .O(parity_error_d_i_5_n_0));
  LUT6 #(
    .INIT(64'h0404040C04A45404)) 
    parity_error_d_i_6
       (.I0(receive_state[1]),
        .I1(receive_state[3]),
        .I2(receive_state[0]),
        .I3(receive_state[2]),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(parity_error_d_i_6_n_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'h57)) 
    parity_error_d_i_7
       (.I0(receive_state[0]),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(parity_error_d_i_7_n_0));
  FDRE parity_error_d_reg
       (.C(s_axi_aclk),
        .CE(clk1x),
        .D(rx_parity_com),
        .Q(parity_error_d),
        .R(parity_error_d0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h80)) 
    parity_error_i_i_1
       (.I0(parity_error_latch),
        .I1(character_received_flag),
        .I2(Q[3]),
        .O(parity_error_i0));
  FDRE parity_error_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(parity_error_i0),
        .Q(rx_fifo_data_in[10]),
        .R(rx_rst));
  LUT4 #(
    .INIT(16'hBF80)) 
    parity_error_latch_i_1
       (.I0(parity_error_d),
        .I1(load_rbr_d),
        .I2(clk2x),
        .I3(parity_error_latch),
        .O(parity_error_latch_i_1_n_0));
  FDRE parity_error_latch_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(parity_error_latch_i_1_n_0),
        .Q(parity_error_latch),
        .R(framing_error_flag0));
  LUT6 #(
    .INIT(64'hAAFFCCF0AA00CCF0)) 
    \rbr_d[0]_i_1 
       (.I0(rsr[0]),
        .I1(rsr[2]),
        .I2(rsr[3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(rsr[1]),
        .O(\rbr_d[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFCCF0AA00CCF0)) 
    \rbr_d[1]_i_1 
       (.I0(rsr[1]),
        .I1(rsr[3]),
        .I2(rsr[4]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(rsr[2]),
        .O(\rbr_d[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFCCF0AA00CCF0)) 
    \rbr_d[2]_i_1 
       (.I0(rsr[2]),
        .I1(rsr[4]),
        .I2(rsr[5]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(rsr[3]),
        .O(\rbr_d[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCAAFFF0CCAA00)) 
    \rbr_d[3]_i_1 
       (.I0(rsr[5]),
        .I1(rsr[4]),
        .I2(rsr[3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(rsr[6]),
        .O(\rbr_d[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAFFCCF0AA00CCF0)) 
    \rbr_d[4]_i_1 
       (.I0(rsr[4]),
        .I1(rsr[6]),
        .I2(rsr[7]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(rsr[5]),
        .O(\rbr_d[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hFAC00AC0)) 
    \rbr_d[5]_i_1 
       (.I0(rsr[6]),
        .I1(rsr[7]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(rsr[5]),
        .O(\rbr_d[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'hC808)) 
    \rbr_d[6]_i_1 
       (.I0(rsr[7]),
        .I1(Q[1]),
        .I2(Q[0]),
        .I3(rsr[6]),
        .O(\rbr_d[6]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \rbr_d[7]_i_1 
       (.I0(clk1x),
        .I1(load_rbr_d),
        .O(rbr_d0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \rbr_d[7]_i_2 
       (.I0(rsr[7]),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(\rbr_d[7]_i_2_n_0 ));
  FDRE \rbr_d_reg[0] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[0]_i_1_n_0 ),
        .Q(rx_fifo_data_in[0]),
        .R(rx_rst));
  FDRE \rbr_d_reg[1] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[1]_i_1_n_0 ),
        .Q(rx_fifo_data_in[1]),
        .R(rx_rst));
  FDRE \rbr_d_reg[2] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[2]_i_1_n_0 ),
        .Q(rx_fifo_data_in[2]),
        .R(rx_rst));
  FDRE \rbr_d_reg[3] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[3]_i_1_n_0 ),
        .Q(rx_fifo_data_in[3]),
        .R(rx_rst));
  FDRE \rbr_d_reg[4] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[4]_i_1_n_0 ),
        .Q(rx_fifo_data_in[4]),
        .R(rx_rst));
  FDRE \rbr_d_reg[5] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[5]_i_1_n_0 ),
        .Q(rx_fifo_data_in[5]),
        .R(rx_rst));
  FDRE \rbr_d_reg[6] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[6]_i_1_n_0 ),
        .Q(rx_fifo_data_in[6]),
        .R(rx_rst));
  FDRE \rbr_d_reg[7] 
       (.C(s_axi_aclk),
        .CE(rbr_d0),
        .D(\rbr_d[7]_i_2_n_0 ),
        .Q(rx_fifo_data_in[7]),
        .R(rx_rst));
  LUT6 #(
    .INIT(64'h0000000000000800)) 
    resynch_clkdiv_d_i_1
       (.I0(resynch_clkdiv_startbit_d_i_2_n_0),
        .I1(resynch_clkdiv_d_i_2_n_0),
        .I2(clock_1x_early),
        .I3(sin_d6),
        .I4(sin_d5),
        .I5(framing_error_d),
        .O(resynch_clkdiv));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h40004002)) 
    resynch_clkdiv_d_i_2
       (.I0(receive_state[3]),
        .I1(receive_state[1]),
        .I2(receive_state[2]),
        .I3(receive_state[0]),
        .I4(Q[2]),
        .O(resynch_clkdiv_d_i_2_n_0));
  FDRE resynch_clkdiv_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(resynch_clkdiv),
        .Q(resynch_clkdiv_d),
        .R(rx_rst));
  LUT5 #(
    .INIT(32'h88888B88)) 
    resynch_clkdiv_frame_d_i_1
       (.I0(resynch_clkdiv_frame_d),
        .I1(rx_rst),
        .I2(baudoutN_int),
        .I3(framing_error_d),
        .I4(resynch_clkdiv_frame_d_i_2_n_0),
        .O(resynch_clkdiv_frame_d_i_1_n_0));
  LUT6 #(
    .INIT(64'hFF4FFFFFFFFFFFFF)) 
    resynch_clkdiv_frame_d_i_2
       (.I0(receive_state[2]),
        .I1(Q[2]),
        .I2(got_start_bit_d),
        .I3(sin_d9),
        .I4(sin_d10),
        .I5(resynch_clkdiv_frame_d_i_3_n_0),
        .O(resynch_clkdiv_frame_d_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h40)) 
    resynch_clkdiv_frame_d_i_3
       (.I0(receive_state[3]),
        .I1(receive_state[0]),
        .I2(receive_state[1]),
        .O(resynch_clkdiv_frame_d_i_3_n_0));
  FDRE resynch_clkdiv_frame_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(resynch_clkdiv_frame_d_i_1_n_0),
        .Q(resynch_clkdiv_frame_d),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000000200000000)) 
    resynch_clkdiv_startbit_d_i_1
       (.I0(resynch_clkdiv_startbit_d_i_2_n_0),
        .I1(receive_state[0]),
        .I2(receive_state[3]),
        .I3(resynch_clkdiv_startbit_d_i_3_n_0),
        .I4(sin_d9),
        .I5(sin_d10),
        .O(resynch_clkdiv_startbit));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h2)) 
    resynch_clkdiv_startbit_d_i_2
       (.I0(got_start_bit_d),
        .I1(baudoutN_int),
        .O(resynch_clkdiv_startbit_d_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'hB)) 
    resynch_clkdiv_startbit_d_i_3
       (.I0(receive_state[1]),
        .I1(receive_state[2]),
        .O(resynch_clkdiv_startbit_d_i_3_n_0));
  FDRE resynch_clkdiv_startbit_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(resynch_clkdiv_startbit),
        .Q(resynch_clkdiv_startbit_d),
        .R(rx_rst));
  FDRE \rsr_reg[0] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[1]),
        .Q(rsr[0]),
        .R(rx_rst));
  FDRE \rsr_reg[1] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[2]),
        .Q(rsr[1]),
        .R(rx_rst));
  FDRE \rsr_reg[2] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[3]),
        .Q(rsr[2]),
        .R(rx_rst));
  FDRE \rsr_reg[3] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[4]),
        .Q(rsr[3]),
        .R(rx_rst));
  FDRE \rsr_reg[4] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[5]),
        .Q(rsr[4]),
        .R(rx_rst));
  FDRE \rsr_reg[5] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[6]),
        .Q(rsr[5]),
        .R(rx_rst));
  FDRE \rsr_reg[6] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(rsr[7]),
        .Q(rsr[6]),
        .R(rx_rst));
  FDRE \rsr_reg[7] 
       (.C(s_axi_aclk),
        .CE(clk1x_d),
        .D(sin_d2),
        .Q(rsr[7]),
        .R(rx_rst));
  FDRE sin_d10_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d9),
        .Q(sin_d10),
        .R(rx_rst));
  LUT1 #(
    .INIT(2'h1)) 
    sin_d1_i_1
       (.I0(baudoutN_int),
        .O(rclk_int));
  FDRE sin_d1_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(rx_sin),
        .Q(sin_d1),
        .R(rx_rst));
  FDRE sin_d2_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d1),
        .Q(sin_d2),
        .R(rx_rst));
  FDRE sin_d3_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d2),
        .Q(sin_d3),
        .R(rx_rst));
  FDRE sin_d4_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d3),
        .Q(sin_d4),
        .R(rx_rst));
  FDRE sin_d5_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d4),
        .Q(sin_d5),
        .R(rx_rst));
  FDRE sin_d6_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d5),
        .Q(sin_d6),
        .R(rx_rst));
  FDRE sin_d7_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d6),
        .Q(sin_d7),
        .R(rx_rst));
  FDRE sin_d8_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d7),
        .Q(sin_d8),
        .R(rx_rst));
  FDRE sin_d9_reg
       (.C(s_axi_aclk),
        .CE(rclk_int),
        .D(sin_d8),
        .Q(sin_d9),
        .R(rx_rst));
endmodule

(* ORIG_REF_NAME = "rx_fifo_block" *) 
module arty_ddr_axi_uart16550_0_0_rx_fifo_block
   (rx_fifo_full,
    Rx_error_in_fifo,
    \GENERATING_FIFOS.fcr_reg[0] ,
    Q,
    \lsr_reg[1] ,
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ,
    out,
    \GENERATING_FIFOS.fcr_reg[0]_0 ,
    thre_iir_set_reg,
    \dll_reg[7] ,
    D,
    \addr_d_reg[1] ,
    \lsr_reg[0] ,
    lsr4_set,
    lsr3_set,
    lsr2_set,
    \addr_i_reg[4] ,
    thre_iir_set_reg_0,
    thre_iir_set_reg_1,
    \ier_reg[0] ,
    bus2ip_reset_int_core,
    s_axi_aclk,
    SS,
    Rx_error_in_fifo0,
    \lsr_reg[0]_0 ,
    \lsr_reg[0]_1 ,
    readStrobe,
    \lsr_reg[1]_0 ,
    lsr_reg0,
    \lsr_reg[1]_1 ,
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ,
    baudoutN_int,
    data3,
    rx_fifo_rd_en_d,
    rx_fifo_wr_en_i,
    character_received,
    rxrdyN_int_reg,
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ,
    \iir_reg[1] ,
    \iir_reg[1]_0 ,
    \Dout_reg[3] ,
    thre_iir_set_reg_2,
    \Dout_reg[7] ,
    thre_iir_set_reg_3,
    thre_iir_set_reg_4,
    thre_iir_set_reg_5,
    thre_iir_set,
    writing_thr,
    thre_iir_set_reg_6,
    thre_iir_set_reg_7,
    thre_iir_set_reg_8,
    \iir[3]_i_2 ,
    \iir[3]_i_2_0 ,
    \Dout_reg[7]_0 ,
    \Dout_reg[7]_1 ,
    data,
    \Dout_reg[7]_2 ,
    \Dout_reg[2] ,
    \Dout[7]_i_6 ,
    \Dout[7]_i_6_0 ,
    \Dout_reg[5] ,
    \Dout_reg[2]_0 ,
    \Dout_reg[6] ,
    \Dout_reg[6]_0 ,
    \Dout_reg[6]_1 ,
    \Dout_reg[5]_0 ,
    \Dout_reg[5]_1 ,
    \Dout_reg[5]_2 ,
    \Dout_reg[5]_3 ,
    \Dout_reg[5]_4 ,
    \Dout_reg[3]_0 ,
    \Dout_reg[3]_1 ,
    \Dout_reg[2]_1 ,
    \Dout_reg[2]_2 ,
    L,
    \Dout_reg[3]_2 ,
    rxrdyn,
    rx_fifo_rd_en_d1,
    rx_fifo_data_in,
    chipSelect,
    wr_d,
    lsr2_rst,
    \iir_reg[0] ,
    SR);
  output rx_fifo_full;
  output Rx_error_in_fifo;
  output \GENERATING_FIFOS.fcr_reg[0] ;
  output [0:0]Q;
  output \lsr_reg[1] ;
  output \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ;
  output [1:0]out;
  output \GENERATING_FIFOS.fcr_reg[0]_0 ;
  output thre_iir_set_reg;
  output \dll_reg[7] ;
  output [3:0]D;
  output \addr_d_reg[1] ;
  output \lsr_reg[0] ;
  output lsr4_set;
  output lsr3_set;
  output lsr2_set;
  output \addr_i_reg[4] ;
  output thre_iir_set_reg_0;
  output thre_iir_set_reg_1;
  output \ier_reg[0] ;
  input bus2ip_reset_int_core;
  input s_axi_aclk;
  input [0:0]SS;
  input Rx_error_in_fifo0;
  input \lsr_reg[0]_0 ;
  input \lsr_reg[0]_1 ;
  input readStrobe;
  input \lsr_reg[1]_0 ;
  input lsr_reg0;
  input [1:0]\lsr_reg[1]_1 ;
  input \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ;
  input baudoutN_int;
  input [2:0]data3;
  input rx_fifo_rd_en_d;
  input rx_fifo_wr_en_i;
  input character_received;
  input rxrdyN_int_reg;
  input \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ;
  input [1:0]\iir_reg[1] ;
  input \iir_reg[1]_0 ;
  input \Dout_reg[3] ;
  input thre_iir_set_reg_2;
  input \Dout_reg[7] ;
  input thre_iir_set_reg_3;
  input thre_iir_set_reg_4;
  input thre_iir_set_reg_5;
  input thre_iir_set;
  input writing_thr;
  input thre_iir_set_reg_6;
  input thre_iir_set_reg_7;
  input thre_iir_set_reg_8;
  input \iir[3]_i_2 ;
  input \iir[3]_i_2_0 ;
  input \Dout_reg[7]_0 ;
  input \Dout_reg[7]_1 ;
  input [1:0]data;
  input \Dout_reg[7]_2 ;
  input \Dout_reg[2] ;
  input \Dout[7]_i_6 ;
  input \Dout[7]_i_6_0 ;
  input \Dout_reg[5] ;
  input \Dout_reg[2]_0 ;
  input [3:0]\Dout_reg[6] ;
  input \Dout_reg[6]_0 ;
  input \Dout_reg[6]_1 ;
  input \Dout_reg[5]_0 ;
  input \Dout_reg[5]_1 ;
  input [1:0]\Dout_reg[5]_2 ;
  input \Dout_reg[5]_3 ;
  input \Dout_reg[5]_4 ;
  input \Dout_reg[3]_0 ;
  input \Dout_reg[3]_1 ;
  input \Dout_reg[2]_1 ;
  input \Dout_reg[2]_2 ;
  input [0:3]L;
  input \Dout_reg[3]_2 ;
  input rxrdyn;
  input rx_fifo_rd_en_d1;
  input [10:0]rx_fifo_data_in;
  input chipSelect;
  input wr_d;
  input lsr2_rst;
  input \iir_reg[0] ;
  input [0:0]SR;

  wire [3:0]D;
  wire \Dout[7]_i_6 ;
  wire \Dout[7]_i_6_0 ;
  wire \Dout_reg[2] ;
  wire \Dout_reg[2]_0 ;
  wire \Dout_reg[2]_1 ;
  wire \Dout_reg[2]_2 ;
  wire \Dout_reg[3] ;
  wire \Dout_reg[3]_0 ;
  wire \Dout_reg[3]_1 ;
  wire \Dout_reg[3]_2 ;
  wire \Dout_reg[5] ;
  wire \Dout_reg[5]_0 ;
  wire \Dout_reg[5]_1 ;
  wire [1:0]\Dout_reg[5]_2 ;
  wire \Dout_reg[5]_3 ;
  wire \Dout_reg[5]_4 ;
  wire [3:0]\Dout_reg[6] ;
  wire \Dout_reg[6]_0 ;
  wire \Dout_reg[6]_1 ;
  wire \Dout_reg[7] ;
  wire \Dout_reg[7]_0 ;
  wire \Dout_reg[7]_1 ;
  wire \Dout_reg[7]_2 ;
  wire \GENERATING_FIFOS.fcr_reg[0] ;
  wire \GENERATING_FIFOS.fcr_reg[0]_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ;
  wire [0:3]L;
  wire [0:0]Q;
  wire Rx_error_in_fifo;
  wire Rx_error_in_fifo0;
  wire [0:0]SR;
  wire [0:0]SS;
  wire \addr_d_reg[1] ;
  wire \addr_i_reg[4] ;
  wire baudoutN_int;
  wire bus2ip_reset_int_core;
  wire character_received;
  wire chipSelect;
  wire [1:0]data;
  wire [2:0]data3;
  wire \dll_reg[7] ;
  wire fifo_trigger_level_flag;
  wire \ier_reg[0] ;
  wire \iir[3]_i_2 ;
  wire \iir[3]_i_2_0 ;
  wire \iir_reg[0] ;
  wire [1:0]\iir_reg[1] ;
  wire \iir_reg[1]_0 ;
  wire lsr2_rst;
  wire lsr2_set;
  wire lsr3_set;
  wire lsr4_set;
  wire lsr_reg0;
  wire \lsr_reg[0] ;
  wire \lsr_reg[0]_0 ;
  wire \lsr_reg[0]_1 ;
  wire \lsr_reg[1] ;
  wire \lsr_reg[1]_0 ;
  wire [1:0]\lsr_reg[1]_1 ;
  wire [1:0]out;
  wire readStrobe;
  wire [10:0]rx_fifo_data_in;
  wire rx_fifo_full;
  wire rx_fifo_rd_en_d;
  wire rx_fifo_rd_en_d1;
  wire rx_fifo_wr_en_i;
  wire rxrdyN_int_reg;
  wire rxrdyn;
  wire s_axi_aclk;
  wire thre_iir_set;
  wire thre_iir_set_reg;
  wire thre_iir_set_reg_0;
  wire thre_iir_set_reg_1;
  wire thre_iir_set_reg_2;
  wire thre_iir_set_reg_3;
  wire thre_iir_set_reg_4;
  wire thre_iir_set_reg_5;
  wire thre_iir_set_reg_6;
  wire thre_iir_set_reg_7;
  wire thre_iir_set_reg_8;
  wire wr_d;
  wire writing_thr;

  arty_ddr_axi_uart16550_0_0_rx_fifo_control rx_fifo_control_1
       (.\GENERATING_FIFOS.fcr_reg[0] (\GENERATING_FIFOS.fcr_reg[0]_0 ),
        .Q(Q),
        .Rx_error_in_fifo(Rx_error_in_fifo),
        .Rx_error_in_fifo0(Rx_error_in_fifo0),
        .SR(SR),
        .baudoutN_int(baudoutN_int),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .data3(data3[0]),
        .fifo_trigger_level_flag(fifo_trigger_level_flag),
        .\ier_reg[0] (\ier_reg[0] ),
        .\iir[3]_i_2_0 (\iir[3]_i_2 ),
        .\iir[3]_i_2_1 (\iir[3]_i_2_0 ),
        .\iir_reg[0] (\iir_reg[0] ),
        .\iir_reg[1] (\iir_reg[1] ),
        .\iir_reg[1]_0 (\iir_reg[1]_0 ),
        .\iir_reg[3] (\Dout_reg[3] ),
        .\iir_reg[3]_0 (\lsr_reg[0]_1 ),
        .\iir_reg[3]_1 (\Dout_reg[7] ),
        .\lsr_reg[0] (\lsr_reg[0] ),
        .readStrobe(readStrobe),
        .rxrdyN_int_reg(\lsr_reg[0]_0 ),
        .rxrdyN_int_reg_0(rxrdyN_int_reg),
        .rxrdyn(rxrdyn),
        .s_axi_aclk(s_axi_aclk),
        .thre_iir_set(thre_iir_set),
        .thre_iir_set_reg(thre_iir_set_reg),
        .thre_iir_set_reg_0(thre_iir_set_reg_0),
        .thre_iir_set_reg_1(thre_iir_set_reg_1),
        .thre_iir_set_reg_2(thre_iir_set_reg_2),
        .thre_iir_set_reg_3(thre_iir_set_reg_3),
        .thre_iir_set_reg_4(thre_iir_set_reg_4),
        .thre_iir_set_reg_5(thre_iir_set_reg_5),
        .thre_iir_set_reg_6(thre_iir_set_reg_6),
        .thre_iir_set_reg_7(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ),
        .thre_iir_set_reg_8(thre_iir_set_reg_7),
        .thre_iir_set_reg_9(thre_iir_set_reg_8),
        .writing_thr(writing_thr));
  arty_ddr_axi_uart16550_0_0_srl_fifo__parameterized0 srl_fifo_rbu_f_i1
       (.D(D),
        .\Dout[7]_i_6_0 (\Dout[7]_i_6 ),
        .\Dout[7]_i_6_1 (\Dout[7]_i_6_0 ),
        .\Dout_reg[2] (\Dout_reg[2] ),
        .\Dout_reg[2]_0 (\Dout_reg[2]_0 ),
        .\Dout_reg[2]_1 (\Dout_reg[2]_1 ),
        .\Dout_reg[2]_2 (\Dout_reg[2]_2 ),
        .\Dout_reg[3] (\Dout_reg[3]_0 ),
        .\Dout_reg[3]_0 (\Dout_reg[3] ),
        .\Dout_reg[3]_1 (\Dout_reg[3]_1 ),
        .\Dout_reg[3]_2 (\Dout_reg[3]_2 ),
        .\Dout_reg[5] (\Dout_reg[5] ),
        .\Dout_reg[5]_0 (\Dout_reg[5]_0 ),
        .\Dout_reg[5]_1 (\Dout_reg[5]_1 ),
        .\Dout_reg[5]_2 (\Dout_reg[5]_2 ),
        .\Dout_reg[5]_3 (\Dout_reg[5]_3 ),
        .\Dout_reg[5]_4 (\Dout_reg[5]_4 ),
        .\Dout_reg[6] (\Dout_reg[6] ),
        .\Dout_reg[6]_0 (\Dout_reg[6]_0 ),
        .\Dout_reg[6]_1 (\Dout_reg[6]_1 ),
        .\Dout_reg[7] (\Dout_reg[7]_0 ),
        .\Dout_reg[7]_0 (\Dout_reg[7]_1 ),
        .\Dout_reg[7]_1 (\Dout_reg[7] ),
        .\Dout_reg[7]_2 (\Dout_reg[7]_2 ),
        .\GENERATING_FIFOS.fcr_reg[0] (\GENERATING_FIFOS.fcr_reg[0] ),
        .\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 (\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ),
        .\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg (\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ),
        .\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 (\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ),
        .L(L),
        .Q(Q),
        .SS(SS),
        .\addr_d_reg[1] (\addr_d_reg[1] ),
        .\addr_i_reg[4]_0 (\addr_i_reg[4] ),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .character_received(character_received),
        .chipSelect(chipSelect),
        .data(data),
        .data3(data3),
        .\dll_reg[7] (\dll_reg[7] ),
        .fifo_trigger_level_flag(fifo_trigger_level_flag),
        .lsr2_rst(lsr2_rst),
        .lsr2_set(lsr2_set),
        .lsr3_set(lsr3_set),
        .lsr4_set(lsr4_set),
        .lsr_reg0(lsr_reg0),
        .\lsr_reg[0] (\lsr_reg[0]_0 ),
        .\lsr_reg[0]_0 (\lsr_reg[0]_1 ),
        .\lsr_reg[1] (\lsr_reg[1] ),
        .\lsr_reg[1]_0 (\lsr_reg[1]_0 ),
        .\lsr_reg[1]_1 (\lsr_reg[1]_1 ),
        .\lsr_reg[1]_2 (rxrdyN_int_reg),
        .out(out),
        .readStrobe(readStrobe),
        .rx_fifo_data_in(rx_fifo_data_in),
        .rx_fifo_full(rx_fifo_full),
        .rx_fifo_rd_en_d(rx_fifo_rd_en_d),
        .rx_fifo_rd_en_d1(rx_fifo_rd_en_d1),
        .rx_fifo_wr_en_i(rx_fifo_wr_en_i),
        .s_axi_aclk(s_axi_aclk),
        .wr_d(wr_d));
endmodule

(* ORIG_REF_NAME = "rx_fifo_control" *) 
module arty_ddr_axi_uart16550_0_0_rx_fifo_control
   (Rx_error_in_fifo,
    \GENERATING_FIFOS.fcr_reg[0] ,
    thre_iir_set_reg,
    \lsr_reg[0] ,
    thre_iir_set_reg_0,
    thre_iir_set_reg_1,
    \ier_reg[0] ,
    bus2ip_reset_int_core,
    fifo_trigger_level_flag,
    s_axi_aclk,
    Rx_error_in_fifo0,
    baudoutN_int,
    rxrdyN_int_reg,
    \iir_reg[1] ,
    \iir_reg[1]_0 ,
    \iir_reg[3] ,
    \iir_reg[3]_0 ,
    readStrobe,
    thre_iir_set_reg_2,
    \iir_reg[3]_1 ,
    thre_iir_set_reg_3,
    thre_iir_set_reg_4,
    thre_iir_set_reg_5,
    thre_iir_set,
    writing_thr,
    thre_iir_set_reg_6,
    thre_iir_set_reg_7,
    thre_iir_set_reg_8,
    thre_iir_set_reg_9,
    \iir[3]_i_2_0 ,
    \iir[3]_i_2_1 ,
    rxrdyN_int_reg_0,
    data3,
    rxrdyn,
    \iir_reg[0] ,
    Q,
    SR);
  output Rx_error_in_fifo;
  output \GENERATING_FIFOS.fcr_reg[0] ;
  output thre_iir_set_reg;
  output \lsr_reg[0] ;
  output thre_iir_set_reg_0;
  output thre_iir_set_reg_1;
  output \ier_reg[0] ;
  input bus2ip_reset_int_core;
  input fifo_trigger_level_flag;
  input s_axi_aclk;
  input Rx_error_in_fifo0;
  input baudoutN_int;
  input rxrdyN_int_reg;
  input [1:0]\iir_reg[1] ;
  input \iir_reg[1]_0 ;
  input \iir_reg[3] ;
  input \iir_reg[3]_0 ;
  input readStrobe;
  input thre_iir_set_reg_2;
  input \iir_reg[3]_1 ;
  input thre_iir_set_reg_3;
  input thre_iir_set_reg_4;
  input thre_iir_set_reg_5;
  input thre_iir_set;
  input writing_thr;
  input thre_iir_set_reg_6;
  input thre_iir_set_reg_7;
  input thre_iir_set_reg_8;
  input thre_iir_set_reg_9;
  input \iir[3]_i_2_0 ;
  input \iir[3]_i_2_1 ;
  input rxrdyN_int_reg_0;
  input [0:0]data3;
  input rxrdyn;
  input \iir_reg[0] ;
  input [0:0]Q;
  input [0:0]SR;

  wire \GENERATING_FIFOS.fcr_reg[0] ;
  wire [0:0]Q;
  wire Rx_error_in_fifo;
  wire Rx_error_in_fifo0;
  wire [0:0]SR;
  wire baudoutN_int;
  wire bus2ip_reset_int_core;
  wire character_counter0;
  wire \character_counter[9]_i_4_n_0 ;
  wire \character_counter_reg_n_0_[0] ;
  wire \character_counter_reg_n_0_[1] ;
  wire \character_counter_reg_n_0_[2] ;
  wire \character_counter_reg_n_0_[3] ;
  wire \character_counter_reg_n_0_[4] ;
  wire \character_counter_reg_n_0_[5] ;
  wire \character_counter_reg_n_0_[6] ;
  wire \character_counter_reg_n_0_[7] ;
  wire [0:0]data3;
  wire fifo_trigger_level_flag;
  wire \ier_reg[0] ;
  wire [2:2]iir;
  wire \iir[1]_i_2_n_0 ;
  wire \iir[2]_i_4_n_0 ;
  wire \iir[2]_i_7_n_0 ;
  wire \iir[3]_i_2_0 ;
  wire \iir[3]_i_2_1 ;
  wire \iir[3]_i_2_n_0 ;
  wire \iir[3]_i_4_n_0 ;
  wire \iir_reg[0] ;
  wire [1:0]\iir_reg[1] ;
  wire \iir_reg[1]_0 ;
  wire \iir_reg[3] ;
  wire \iir_reg[3]_0 ;
  wire \iir_reg[3]_1 ;
  wire \lsr_reg[0] ;
  wire p_0_in;
  wire p_1_in;
  wire p_1_out0;
  wire [9:0]plusOp;
  wire readStrobe;
  wire rx_fifo_trigger;
  wire rxrdyN_int_i_2_n_0;
  wire rxrdyN_int_reg;
  wire rxrdyN_int_reg_0;
  wire rxrdyn;
  wire s_axi_aclk;
  wire thre_iir_set;
  wire thre_iir_set_reg;
  wire thre_iir_set_reg_0;
  wire thre_iir_set_reg_1;
  wire thre_iir_set_reg_2;
  wire thre_iir_set_reg_3;
  wire thre_iir_set_reg_4;
  wire thre_iir_set_reg_5;
  wire thre_iir_set_reg_6;
  wire thre_iir_set_reg_7;
  wire thre_iir_set_reg_8;
  wire thre_iir_set_reg_9;
  wire writing_thr;

  FDRE Rx_error_in_fifo_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Rx_error_in_fifo0),
        .Q(Rx_error_in_fifo),
        .R(bus2ip_reset_int_core));
  FDRE Rx_fifo_trigger_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(fifo_trigger_level_flag),
        .Q(rx_fifo_trigger),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \character_counter[0]_i_1 
       (.I0(\character_counter_reg_n_0_[0] ),
        .O(plusOp[0]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \character_counter[1]_i_1 
       (.I0(\character_counter_reg_n_0_[1] ),
        .I1(\character_counter_reg_n_0_[0] ),
        .O(plusOp[1]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \character_counter[2]_i_1 
       (.I0(\character_counter_reg_n_0_[2] ),
        .I1(\character_counter_reg_n_0_[1] ),
        .I2(\character_counter_reg_n_0_[0] ),
        .O(plusOp[2]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \character_counter[3]_i_1 
       (.I0(\character_counter_reg_n_0_[3] ),
        .I1(\character_counter_reg_n_0_[0] ),
        .I2(\character_counter_reg_n_0_[1] ),
        .I3(\character_counter_reg_n_0_[2] ),
        .O(plusOp[3]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \character_counter[4]_i_1 
       (.I0(\character_counter_reg_n_0_[2] ),
        .I1(\character_counter_reg_n_0_[1] ),
        .I2(\character_counter_reg_n_0_[0] ),
        .I3(\character_counter_reg_n_0_[3] ),
        .I4(\character_counter_reg_n_0_[4] ),
        .O(plusOp[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \character_counter[5]_i_1 
       (.I0(\character_counter_reg_n_0_[5] ),
        .I1(\character_counter_reg_n_0_[2] ),
        .I2(\character_counter_reg_n_0_[1] ),
        .I3(\character_counter_reg_n_0_[0] ),
        .I4(\character_counter_reg_n_0_[3] ),
        .I5(\character_counter_reg_n_0_[4] ),
        .O(plusOp[5]));
  LUT3 #(
    .INIT(8'h6A)) 
    \character_counter[6]_i_1 
       (.I0(\character_counter_reg_n_0_[6] ),
        .I1(\character_counter[9]_i_4_n_0 ),
        .I2(\character_counter_reg_n_0_[5] ),
        .O(plusOp[6]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \character_counter[7]_i_1 
       (.I0(\character_counter_reg_n_0_[7] ),
        .I1(\character_counter_reg_n_0_[5] ),
        .I2(\character_counter[9]_i_4_n_0 ),
        .I3(\character_counter_reg_n_0_[6] ),
        .O(plusOp[7]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \character_counter[8]_i_1 
       (.I0(p_0_in),
        .I1(\character_counter_reg_n_0_[6] ),
        .I2(\character_counter[9]_i_4_n_0 ),
        .I3(\character_counter_reg_n_0_[5] ),
        .I4(\character_counter_reg_n_0_[7] ),
        .O(plusOp[8]));
  LUT3 #(
    .INIT(8'h07)) 
    \character_counter[9]_i_2 
       (.I0(p_0_in),
        .I1(p_1_in),
        .I2(baudoutN_int),
        .O(character_counter0));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \character_counter[9]_i_3 
       (.I0(p_1_in),
        .I1(\character_counter_reg_n_0_[7] ),
        .I2(\character_counter_reg_n_0_[5] ),
        .I3(\character_counter[9]_i_4_n_0 ),
        .I4(\character_counter_reg_n_0_[6] ),
        .I5(p_0_in),
        .O(plusOp[9]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \character_counter[9]_i_4 
       (.I0(\character_counter_reg_n_0_[4] ),
        .I1(\character_counter_reg_n_0_[3] ),
        .I2(\character_counter_reg_n_0_[0] ),
        .I3(\character_counter_reg_n_0_[1] ),
        .I4(\character_counter_reg_n_0_[2] ),
        .O(\character_counter[9]_i_4_n_0 ));
  FDRE \character_counter_reg[0] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[0]),
        .Q(\character_counter_reg_n_0_[0] ),
        .R(SR));
  FDRE \character_counter_reg[1] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[1]),
        .Q(\character_counter_reg_n_0_[1] ),
        .R(SR));
  FDRE \character_counter_reg[2] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[2]),
        .Q(\character_counter_reg_n_0_[2] ),
        .R(SR));
  FDRE \character_counter_reg[3] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[3]),
        .Q(\character_counter_reg_n_0_[3] ),
        .R(SR));
  FDRE \character_counter_reg[4] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[4]),
        .Q(\character_counter_reg_n_0_[4] ),
        .R(SR));
  FDRE \character_counter_reg[5] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[5]),
        .Q(\character_counter_reg_n_0_[5] ),
        .R(SR));
  FDRE \character_counter_reg[6] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[6]),
        .Q(\character_counter_reg_n_0_[6] ),
        .R(SR));
  FDRE \character_counter_reg[7] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[7]),
        .Q(\character_counter_reg_n_0_[7] ),
        .R(SR));
  FDRE \character_counter_reg[8] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[8]),
        .Q(p_0_in),
        .R(SR));
  FDRE \character_counter_reg[9] 
       (.C(s_axi_aclk),
        .CE(character_counter0),
        .D(plusOp[9]),
        .Q(p_1_in),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFF0015)) 
    \iir[0]_i_1 
       (.I0(iir),
        .I1(thre_iir_set),
        .I2(\iir_reg[1] [1]),
        .I3(\iir_reg[0] ),
        .I4(p_1_out0),
        .O(thre_iir_set_reg_0));
  LUT5 #(
    .INIT(32'h0000FF08)) 
    \iir[1]_i_1 
       (.I0(thre_iir_set),
        .I1(\iir_reg[1] [1]),
        .I2(\iir[1]_i_2_n_0 ),
        .I3(\iir_reg[1]_0 ),
        .I4(p_1_out0),
        .O(thre_iir_set_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hEFE00000)) 
    \iir[1]_i_2 
       (.I0(rxrdyN_int_i_2_n_0),
        .I1(rx_fifo_trigger),
        .I2(rxrdyN_int_reg),
        .I3(rxrdyN_int_reg_0),
        .I4(\iir_reg[1] [0]),
        .O(\iir[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \iir[2]_i_1 
       (.I0(iir),
        .I1(p_1_out0),
        .O(\ier_reg[0] ));
  LUT6 #(
    .INIT(64'hEEEAEEEAEEEAAAEA)) 
    \iir[2]_i_2 
       (.I0(\iir_reg[1]_0 ),
        .I1(\iir_reg[1] [0]),
        .I2(rxrdyN_int_reg_0),
        .I3(rxrdyN_int_reg),
        .I4(rx_fifo_trigger),
        .I5(rxrdyN_int_i_2_n_0),
        .O(iir));
  LUT6 #(
    .INIT(64'hEEEEEEEEFEEEEEEE)) 
    \iir[2]_i_3 
       (.I0(\iir[2]_i_4_n_0 ),
        .I1(thre_iir_set_reg_6),
        .I2(thre_iir_set_reg_7),
        .I3(thre_iir_set_reg_2),
        .I4(thre_iir_set_reg_8),
        .I5(thre_iir_set_reg_9),
        .O(p_1_out0));
  LUT6 #(
    .INIT(64'hFFFFFFFF00000232)) 
    \iir[2]_i_4 
       (.I0(\iir[3]_i_2_0 ),
        .I1(thre_iir_set_reg_2),
        .I2(thre_iir_set_reg_8),
        .I3(\iir[2]_i_7_n_0 ),
        .I4(thre_iir_set_reg_9),
        .I5(bus2ip_reset_int_core),
        .O(\iir[2]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \iir[2]_i_7 
       (.I0(rx_fifo_trigger),
        .I1(rxrdyN_int_reg),
        .O(\iir[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000008000)) 
    \iir[3]_i_1 
       (.I0(\iir[3]_i_2_n_0 ),
        .I1(rxrdyN_int_i_2_n_0),
        .I2(rxrdyN_int_reg),
        .I3(\iir_reg[1] [0]),
        .I4(bus2ip_reset_int_core),
        .I5(\iir_reg[1]_0 ),
        .O(\GENERATING_FIFOS.fcr_reg[0] ));
  LUT6 #(
    .INIT(64'hFFFFEAEEEAFFEAEE)) 
    \iir[3]_i_2 
       (.I0(\iir[3]_i_4_n_0 ),
        .I1(\iir_reg[3] ),
        .I2(\iir_reg[3]_0 ),
        .I3(readStrobe),
        .I4(thre_iir_set_reg_2),
        .I5(\iir_reg[3]_1 ),
        .O(\iir[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF05053505)) 
    \iir[3]_i_4 
       (.I0(\iir[3]_i_2_0 ),
        .I1(thre_iir_set_reg_2),
        .I2(thre_iir_set_reg_8),
        .I3(rx_fifo_trigger),
        .I4(\iir_reg[3] ),
        .I5(\iir[3]_i_2_1 ),
        .O(\iir[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h155515551555D555)) 
    rxrdyN_int_i_1
       (.I0(rxrdyN_int_reg_0),
        .I1(data3),
        .I2(rxrdyN_int_reg),
        .I3(rxrdyn),
        .I4(rx_fifo_trigger),
        .I5(rxrdyN_int_i_2_n_0),
        .O(\lsr_reg[0] ));
  LUT3 #(
    .INIT(8'h40)) 
    rxrdyN_int_i_2
       (.I0(Q),
        .I1(p_0_in),
        .I2(p_1_in),
        .O(rxrdyN_int_i_2_n_0));
  LUT6 #(
    .INIT(64'h00000000AAAAA200)) 
    thre_iir_set_i_1
       (.I0(thre_iir_set_reg_3),
        .I1(thre_iir_set_reg_4),
        .I2(p_1_out0),
        .I3(thre_iir_set_reg_5),
        .I4(thre_iir_set),
        .I5(writing_thr),
        .O(thre_iir_set_reg));
endmodule

(* ORIG_REF_NAME = "slave_attachment" *) 
module arty_ddr_axi_uart16550_0_0_slave_attachment
   (SR,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ,
    s_axi_rvalid,
    s_axi_bvalid,
    rst_reg_0,
    rst_reg_1,
    s_axi_rdata,
    \bus2ip_addr_i_reg[4]_0 ,
    bus2ip_rdce_i,
    Wr,
    bus2ip_wrce_i,
    s_axi_aclk,
    s_axi_arvalid,
    \GENERATING_FIFOS.rx_fifo_rst ,
    p_2_in44_in,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ,
    s_axi_rready,
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ,
    s_axi_bready,
    s_axi_awvalid,
    s_axi_wvalid,
    Q,
    s_axi_aresetn,
    s_axi_araddr,
    s_axi_awaddr,
    wrReq_d1);
  output [0:0]SR;
  output \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ;
  output s_axi_rvalid;
  output s_axi_bvalid;
  output [0:0]rst_reg_0;
  output rst_reg_1;
  output [7:0]s_axi_rdata;
  output [2:0]\bus2ip_addr_i_reg[4]_0 ;
  output [0:0]bus2ip_rdce_i;
  output Wr;
  output [0:0]bus2ip_wrce_i;
  input s_axi_aclk;
  input s_axi_arvalid;
  input \GENERATING_FIFOS.rx_fifo_rst ;
  input p_2_in44_in;
  input \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ;
  input s_axi_rready;
  input \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ;
  input s_axi_bready;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input [7:0]Q;
  input s_axi_aresetn;
  input [2:0]s_axi_araddr;
  input [2:0]s_axi_awaddr;
  input wrReq_d1;

  wire \FSM_onehot_state[0]_i_1_n_0 ;
  wire \FSM_onehot_state[1]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[3]_i_1_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire \GENERATING_FIFOS.rx_fifo_rst ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ;
  wire [7:0]Q;
  wire [0:0]SR;
  wire Wr;
  wire \bus2ip_addr_i[2]_i_1_n_0 ;
  wire \bus2ip_addr_i[3]_i_1_n_0 ;
  wire \bus2ip_addr_i[4]_i_1_n_0 ;
  wire \bus2ip_addr_i[4]_i_2_n_0 ;
  wire [2:0]\bus2ip_addr_i_reg[4]_0 ;
  wire [0:0]bus2ip_rdce_i;
  wire bus2ip_rnw_i_reg_n_0;
  wire [0:0]bus2ip_wrce_i;
  wire p_2_in44_in;
  wire rst_i_1_n_0;
  wire [0:0]rst_reg_0;
  wire rst_reg_1;
  wire s_axi_aclk;
  wire [2:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arvalid;
  wire [2:0]s_axi_awaddr;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire [0:0]s_axi_bresp_i;
  wire s_axi_bvalid;
  wire s_axi_bvalid_i_i_1_n_0;
  wire [7:0]s_axi_rdata;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp_i;
  wire s_axi_rvalid;
  wire s_axi_rvalid_i_i_1_n_0;
  wire s_axi_wvalid;
  wire start2;
  wire start2_i_1_n_0;
  wire state1__2;
  wire wrReq_d1;

  LUT6 #(
    .INIT(64'hFFFF88F888F888F8)) 
    \FSM_onehot_state[0]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ),
        .I1(s_axi_bresp_i),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(state1__2),
        .I4(s_axi_rresp_i),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .O(\FSM_onehot_state[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h888F8F8F88888888)) 
    \FSM_onehot_state[1]_i_1 
       (.I0(state1__2),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(s_axi_arvalid),
        .I3(s_axi_wvalid),
        .I4(s_axi_awvalid),
        .I5(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\FSM_onehot_state[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \FSM_onehot_state[1]_i_2 
       (.I0(s_axi_bready),
        .I1(s_axi_bvalid),
        .I2(s_axi_rready),
        .I3(s_axi_rvalid),
        .O(state1__2));
  LUT6 #(
    .INIT(64'h0800FFFF08000800)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(s_axi_wvalid),
        .I1(s_axi_awvalid),
        .I2(s_axi_arvalid),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .I4(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ),
        .I5(s_axi_bresp_i),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_state[3]_i_1 
       (.I0(s_axi_arvalid),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .I3(s_axi_rresp_i),
        .O(\FSM_onehot_state[3]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "sm_read:1000,sm_write:0100,sm_resp:0001,sm_idle:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[0]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .R(SR));
  (* FSM_ENCODED_STATES = "sm_read:1000,sm_write:0100,sm_resp:0001,sm_idle:0010" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[1]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .S(SR));
  (* FSM_ENCODED_STATES = "sm_read:1000,sm_write:0100,sm_resp:0001,sm_idle:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[2]_i_1_n_0 ),
        .Q(s_axi_bresp_i),
        .R(SR));
  (* FSM_ENCODED_STATES = "sm_read:1000,sm_write:0100,sm_resp:0001,sm_idle:0010" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[3]_i_1_n_0 ),
        .Q(s_axi_rresp_i),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_1 
       (.I0(SR),
        .I1(\GENERATING_FIFOS.rx_fifo_rst ),
        .O(rst_reg_0));
  arty_ddr_axi_uart16550_0_0_address_decoder I_DECODER
       (.Bus_RNW_reg_reg_0(bus2ip_rnw_i_reg_n_0),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 (\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] ),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 (\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_2 (\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ),
        .Q(start2),
        .Wr(Wr),
        .bus2ip_rdce_i(bus2ip_rdce_i),
        .bus2ip_wrce_i(bus2ip_wrce_i),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .wrReq_d1(wrReq_d1));
  LUT3 #(
    .INIT(8'hB8)) 
    \bus2ip_addr_i[2]_i_1 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_arvalid),
        .I2(s_axi_awaddr[0]),
        .O(\bus2ip_addr_i[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \bus2ip_addr_i[3]_i_1 
       (.I0(s_axi_araddr[1]),
        .I1(s_axi_arvalid),
        .I2(s_axi_awaddr[1]),
        .O(\bus2ip_addr_i[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hEA00)) 
    \bus2ip_addr_i[4]_i_1 
       (.I0(s_axi_arvalid),
        .I1(s_axi_awvalid),
        .I2(s_axi_wvalid),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\bus2ip_addr_i[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \bus2ip_addr_i[4]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_arvalid),
        .I2(s_axi_awaddr[2]),
        .O(\bus2ip_addr_i[4]_i_2_n_0 ));
  FDRE \bus2ip_addr_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[4]_i_1_n_0 ),
        .D(\bus2ip_addr_i[2]_i_1_n_0 ),
        .Q(\bus2ip_addr_i_reg[4]_0 [0]),
        .R(SR));
  FDRE \bus2ip_addr_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[4]_i_1_n_0 ),
        .D(\bus2ip_addr_i[3]_i_1_n_0 ),
        .Q(\bus2ip_addr_i_reg[4]_0 [1]),
        .R(SR));
  FDRE \bus2ip_addr_i_reg[4] 
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[4]_i_1_n_0 ),
        .D(\bus2ip_addr_i[4]_i_2_n_0 ),
        .Q(\bus2ip_addr_i_reg[4]_0 [2]),
        .R(SR));
  FDRE bus2ip_rnw_i_reg
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[4]_i_1_n_0 ),
        .D(s_axi_arvalid),
        .Q(bus2ip_rnw_i_reg_n_0),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    rst_i_1
       (.I0(s_axi_aresetn),
        .O(rst_i_1_n_0));
  FDRE rst_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rst_i_1_n_0),
        .Q(SR),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h8F88)) 
    s_axi_bvalid_i_i_1
       (.I0(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_1 ),
        .I1(s_axi_bresp_i),
        .I2(s_axi_bready),
        .I3(s_axi_bvalid),
        .O(s_axi_bvalid_i_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axi_bvalid_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_bvalid_i_i_1_n_0),
        .Q(s_axi_bvalid),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[0]),
        .Q(s_axi_rdata[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[1]),
        .Q(s_axi_rdata[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[2]),
        .Q(s_axi_rdata[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[3]),
        .Q(s_axi_rdata[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[4] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[4]),
        .Q(s_axi_rdata[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[5] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[5]),
        .Q(s_axi_rdata[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[6] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[6]),
        .Q(s_axi_rdata[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[7] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(Q[7]),
        .Q(s_axi_rdata[7]),
        .R(SR));
  LUT4 #(
    .INIT(16'h8F88)) 
    s_axi_rvalid_i_i_1
       (.I0(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]_0 ),
        .I1(s_axi_rresp_i),
        .I2(s_axi_rready),
        .I3(s_axi_rvalid),
        .O(s_axi_rvalid_i_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axi_rvalid_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_rvalid_i_i_1_n_0),
        .Q(s_axi_rvalid),
        .R(SR));
  LUT4 #(
    .INIT(16'hF800)) 
    start2_i_1
       (.I0(s_axi_awvalid),
        .I1(s_axi_wvalid),
        .I2(s_axi_arvalid),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .O(start2_i_1_n_0));
  FDRE start2_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(start2_i_1_n_0),
        .Q(start2),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'hE)) 
    thre_iir_set_i_4
       (.I0(SR),
        .I1(p_2_in44_in),
        .O(rst_reg_1));
endmodule

(* ORIG_REF_NAME = "srl_fifo" *) 
module arty_ddr_axi_uart16550_0_0_srl_fifo
   (Q,
    FIFO_Full_reg_0,
    out,
    SS,
    s_axi_aclk,
    \addr_i_reg[3]_0 ,
    \GENERATING_FIFOS.tx_fifo_wr_en_d ,
    txrdyN_int_reg,
    tx_fifo_rd_en_int,
    txrdyn,
    data3,
    txrdyN_int_reg_0,
    \tsr_reg[7] );
  output [0:0]Q;
  output FIFO_Full_reg_0;
  output [7:0]out;
  input [0:0]SS;
  input s_axi_aclk;
  input \addr_i_reg[3]_0 ;
  input \GENERATING_FIFOS.tx_fifo_wr_en_d ;
  input txrdyN_int_reg;
  input tx_fifo_rd_en_int;
  input txrdyn;
  input [0:0]data3;
  input txrdyN_int_reg_0;
  input [7:0]\tsr_reg[7] ;

  wire FIFO_Full_i_2_n_0;
  wire FIFO_Full_i_3_n_0;
  wire FIFO_Full_i_4_n_0;
  wire FIFO_Full_i_5_n_0;
  wire FIFO_Full_reg_0;
  wire \GENERATING_FIFOS.tx_fifo_wr_en_d ;
  wire [0:0]Q;
  wire [0:0]SS;
  wire [4:0]addr_i_p1;
  wire \addr_i_reg[3]_0 ;
  wire \addr_i_reg_n_0_[0] ;
  wire \addr_i_reg_n_0_[1] ;
  wire \addr_i_reg_n_0_[2] ;
  wire \addr_i_reg_n_0_[3] ;
  wire [0:0]data3;
  wire fifo_full_p1;
  wire [7:0]out;
  wire s_axi_aclk;
  wire [7:0]\tsr_reg[7] ;
  wire tx_fifo_full;
  wire tx_fifo_rd_en_int;
  wire tx_fifo_wr_en_i;
  wire txrdyN_int_reg;
  wire txrdyN_int_reg_0;
  wire txrdyn;

  LUT6 #(
    .INIT(64'h00AA000000008A20)) 
    FIFO_Full_i_1
       (.I0(FIFO_Full_i_2_n_0),
        .I1(FIFO_Full_i_3_n_0),
        .I2(\addr_i_reg_n_0_[2] ),
        .I3(\addr_i_reg_n_0_[3] ),
        .I4(FIFO_Full_i_4_n_0),
        .I5(Q),
        .O(fifo_full_p1));
  LUT6 #(
    .INIT(64'h2282002000004404)) 
    FIFO_Full_i_2
       (.I0(\addr_i_reg_n_0_[2] ),
        .I1(\addr_i_reg[3]_0 ),
        .I2(\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .I3(tx_fifo_full),
        .I4(\addr_i_reg_n_0_[0] ),
        .I5(\addr_i_reg_n_0_[1] ),
        .O(FIFO_Full_i_2_n_0));
  LUT6 #(
    .INIT(64'h08FFFFFFFFFFFFFF)) 
    FIFO_Full_i_3
       (.I0(tx_fifo_rd_en_int),
        .I1(txrdyN_int_reg),
        .I2(Q),
        .I3(tx_fifo_wr_en_i),
        .I4(\addr_i_reg_n_0_[0] ),
        .I5(\addr_i_reg_n_0_[1] ),
        .O(FIFO_Full_i_3_n_0));
  LUT4 #(
    .INIT(16'h0002)) 
    FIFO_Full_i_4
       (.I0(FIFO_Full_i_5_n_0),
        .I1(\addr_i_reg_n_0_[1] ),
        .I2(\addr_i_reg_n_0_[0] ),
        .I3(\addr_i_reg_n_0_[2] ),
        .O(FIFO_Full_i_4_n_0));
  LUT5 #(
    .INIT(32'h40004040)) 
    FIFO_Full_i_5
       (.I0(Q),
        .I1(txrdyN_int_reg),
        .I2(tx_fifo_rd_en_int),
        .I3(tx_fifo_full),
        .I4(\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .O(FIFO_Full_i_5_n_0));
  FDRE FIFO_Full_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(fifo_full_p1),
        .Q(tx_fifo_full),
        .R(SS));
  LUT6 #(
    .INIT(64'h9A659A9A9A9A9A9A)) 
    \addr_i[0]_i_1 
       (.I0(\addr_i_reg_n_0_[0] ),
        .I1(tx_fifo_full),
        .I2(\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .I3(Q),
        .I4(txrdyN_int_reg),
        .I5(tx_fifo_rd_en_int),
        .O(addr_i_p1[0]));
  LUT6 #(
    .INIT(64'h7555EFFF8AAA1000)) 
    \addr_i[1]_i_1 
       (.I0(\addr_i_reg_n_0_[0] ),
        .I1(Q),
        .I2(txrdyN_int_reg),
        .I3(tx_fifo_rd_en_int),
        .I4(tx_fifo_wr_en_i),
        .I5(\addr_i_reg_n_0_[1] ),
        .O(addr_i_p1[1]));
  LUT6 #(
    .INIT(64'hEFF7EFEF10081010)) 
    \addr_i[2]_i_1 
       (.I0(\addr_i_reg_n_0_[0] ),
        .I1(\addr_i_reg_n_0_[1] ),
        .I2(\addr_i_reg[3]_0 ),
        .I3(tx_fifo_full),
        .I4(\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .I5(\addr_i_reg_n_0_[2] ),
        .O(addr_i_p1[2]));
  LUT6 #(
    .INIT(64'hAAAA6AAAAAA9AAAA)) 
    \addr_i[3]_i_1 
       (.I0(\addr_i_reg_n_0_[3] ),
        .I1(\addr_i_reg_n_0_[1] ),
        .I2(\addr_i_reg_n_0_[0] ),
        .I3(tx_fifo_wr_en_i),
        .I4(\addr_i_reg[3]_0 ),
        .I5(\addr_i_reg_n_0_[2] ),
        .O(addr_i_p1[3]));
  LUT5 #(
    .INIT(32'hA6A696A6)) 
    \addr_i[4]_i_1 
       (.I0(Q),
        .I1(FIFO_Full_i_4_n_0),
        .I2(\addr_i_reg_n_0_[3] ),
        .I3(\addr_i_reg_n_0_[2] ),
        .I4(FIFO_Full_i_3_n_0),
        .O(addr_i_p1[4]));
  FDSE \addr_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[0]),
        .Q(\addr_i_reg_n_0_[0] ),
        .S(SS));
  FDSE \addr_i_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[1]),
        .Q(\addr_i_reg_n_0_[1] ),
        .S(SS));
  FDSE \addr_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[2]),
        .Q(\addr_i_reg_n_0_[2] ),
        .S(SS));
  FDSE \addr_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[3]),
        .Q(\addr_i_reg_n_0_[3] ),
        .S(SS));
  FDSE \addr_i_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[4]),
        .Q(Q),
        .S(SS));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][0]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][0]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [7]),
        .Q(out[7]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][1]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][1]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [6]),
        .Q(out[6]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][2]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][2]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [5]),
        .Q(out[5]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][3]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][3]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [4]),
        .Q(out[4]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][4]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][4]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [3]),
        .Q(out[3]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][5]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][5]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [2]),
        .Q(out[2]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][6]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][6]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [1]),
        .Q(out[1]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.tx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][7]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][7]_srl16 
       (.A0(\addr_i_reg_n_0_[0] ),
        .A1(\addr_i_reg_n_0_[1] ),
        .A2(\addr_i_reg_n_0_[2] ),
        .A3(\addr_i_reg_n_0_[3] ),
        .CE(tx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(\tsr_reg[7] [0]),
        .Q(out[0]));
  LUT2 #(
    .INIT(4'h2)) 
    \data_reg[15][7]_srl16_i_1 
       (.I0(\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .I1(tx_fifo_full),
        .O(tx_fifo_wr_en_i));
  LUT5 #(
    .INIT(32'h2000EFFF)) 
    txrdyN_int_i_1
       (.I0(tx_fifo_full),
        .I1(txrdyn),
        .I2(data3),
        .I3(txrdyN_int_reg),
        .I4(txrdyN_int_reg_0),
        .O(FIFO_Full_reg_0));
endmodule

(* ORIG_REF_NAME = "srl_fifo" *) 
module arty_ddr_axi_uart16550_0_0_srl_fifo__parameterized0
   (rx_fifo_full,
    \GENERATING_FIFOS.fcr_reg[0] ,
    Q,
    \lsr_reg[1] ,
    fifo_trigger_level_flag,
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ,
    \dll_reg[7] ,
    D,
    \addr_d_reg[1] ,
    lsr4_set,
    lsr3_set,
    lsr2_set,
    \addr_i_reg[4]_0 ,
    out,
    SS,
    s_axi_aclk,
    \lsr_reg[0] ,
    \lsr_reg[0]_0 ,
    readStrobe,
    bus2ip_reset_int_core,
    \lsr_reg[1]_0 ,
    lsr_reg0,
    \lsr_reg[1]_1 ,
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ,
    data3,
    rx_fifo_rd_en_d,
    rx_fifo_wr_en_i,
    character_received,
    \lsr_reg[1]_2 ,
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ,
    \Dout_reg[7] ,
    \Dout_reg[7]_0 ,
    data,
    \Dout_reg[7]_1 ,
    \Dout_reg[7]_2 ,
    \Dout_reg[2] ,
    \Dout[7]_i_6_0 ,
    \Dout[7]_i_6_1 ,
    \Dout_reg[5] ,
    \Dout_reg[2]_0 ,
    \Dout_reg[6] ,
    \Dout_reg[6]_0 ,
    \Dout_reg[6]_1 ,
    \Dout_reg[5]_0 ,
    \Dout_reg[5]_1 ,
    \Dout_reg[5]_2 ,
    \Dout_reg[5]_3 ,
    \Dout_reg[5]_4 ,
    \Dout_reg[3] ,
    \Dout_reg[3]_0 ,
    \Dout_reg[3]_1 ,
    \Dout_reg[2]_1 ,
    \Dout_reg[2]_2 ,
    L,
    \Dout_reg[3]_2 ,
    rx_fifo_rd_en_d1,
    rx_fifo_data_in,
    chipSelect,
    wr_d,
    lsr2_rst);
  output rx_fifo_full;
  output \GENERATING_FIFOS.fcr_reg[0] ;
  output [0:0]Q;
  output \lsr_reg[1] ;
  output fifo_trigger_level_flag;
  output \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ;
  output \dll_reg[7] ;
  output [3:0]D;
  output \addr_d_reg[1] ;
  output lsr4_set;
  output lsr3_set;
  output lsr2_set;
  output \addr_i_reg[4]_0 ;
  output [1:0]out;
  input [0:0]SS;
  input s_axi_aclk;
  input \lsr_reg[0] ;
  input \lsr_reg[0]_0 ;
  input readStrobe;
  input bus2ip_reset_int_core;
  input \lsr_reg[1]_0 ;
  input lsr_reg0;
  input [1:0]\lsr_reg[1]_1 ;
  input \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ;
  input [2:0]data3;
  input rx_fifo_rd_en_d;
  input rx_fifo_wr_en_i;
  input character_received;
  input \lsr_reg[1]_2 ;
  input \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ;
  input \Dout_reg[7] ;
  input \Dout_reg[7]_0 ;
  input [1:0]data;
  input \Dout_reg[7]_1 ;
  input \Dout_reg[7]_2 ;
  input \Dout_reg[2] ;
  input \Dout[7]_i_6_0 ;
  input \Dout[7]_i_6_1 ;
  input \Dout_reg[5] ;
  input \Dout_reg[2]_0 ;
  input [3:0]\Dout_reg[6] ;
  input \Dout_reg[6]_0 ;
  input \Dout_reg[6]_1 ;
  input \Dout_reg[5]_0 ;
  input \Dout_reg[5]_1 ;
  input [1:0]\Dout_reg[5]_2 ;
  input \Dout_reg[5]_3 ;
  input \Dout_reg[5]_4 ;
  input \Dout_reg[3] ;
  input \Dout_reg[3]_0 ;
  input \Dout_reg[3]_1 ;
  input \Dout_reg[2]_1 ;
  input \Dout_reg[2]_2 ;
  input [0:3]L;
  input \Dout_reg[3]_2 ;
  input rx_fifo_rd_en_d1;
  input [10:0]rx_fifo_data_in;
  input chipSelect;
  input wr_d;
  input lsr2_rst;

  wire [3:0]D;
  wire \Dout[3]_i_2_n_0 ;
  wire \Dout[5]_i_4_n_0 ;
  wire \Dout[7]_i_6_0 ;
  wire \Dout[7]_i_6_1 ;
  wire \Dout[7]_i_9_n_0 ;
  wire \Dout_reg[2] ;
  wire \Dout_reg[2]_0 ;
  wire \Dout_reg[2]_1 ;
  wire \Dout_reg[2]_2 ;
  wire \Dout_reg[3] ;
  wire \Dout_reg[3]_0 ;
  wire \Dout_reg[3]_1 ;
  wire \Dout_reg[3]_2 ;
  wire \Dout_reg[5] ;
  wire \Dout_reg[5]_0 ;
  wire \Dout_reg[5]_1 ;
  wire [1:0]\Dout_reg[5]_2 ;
  wire \Dout_reg[5]_3 ;
  wire \Dout_reg[5]_4 ;
  wire [3:0]\Dout_reg[6] ;
  wire \Dout_reg[6]_0 ;
  wire \Dout_reg[6]_1 ;
  wire \Dout_reg[7] ;
  wire \Dout_reg[7]_0 ;
  wire \Dout_reg[7]_1 ;
  wire \Dout_reg[7]_2 ;
  wire FIFO_Full_i_2__0_n_0;
  wire \GENERATING_FIFOS.fcr_reg[0] ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ;
  wire [0:3]L;
  wire [0:0]Q;
  wire Rx_fifo_trigger_i_2_n_0;
  wire Rx_fifo_trigger_i_3_n_0;
  wire [0:0]SS;
  wire \addr_d_reg[1] ;
  wire \addr_i[3]_i_2_n_0 ;
  wire \addr_i[4]_i_2_n_0 ;
  wire \addr_i[4]_i_3_n_0 ;
  wire [4:0]addr_i_p1;
  wire \addr_i_reg[4]_0 ;
  wire bus2ip_reset_int_core;
  wire character_received;
  wire chipSelect;
  wire [1:0]data;
  wire [2:0]data3;
  wire \dll_reg[7] ;
  wire fifo_full_p1;
  wire fifo_trigger_level_flag;
  wire lsr1_set;
  wire lsr2_rst;
  wire lsr2_set;
  wire lsr3_set;
  wire lsr4_set;
  wire \lsr[0]_i_3_n_0 ;
  wire \lsr[2]_i_5_n_0 ;
  wire lsr_reg0;
  wire \lsr_reg[0] ;
  wire \lsr_reg[0]_0 ;
  wire \lsr_reg[1] ;
  wire \lsr_reg[1]_0 ;
  wire [1:0]\lsr_reg[1]_1 ;
  wire \lsr_reg[1]_2 ;
  wire [1:0]out;
  wire readStrobe;
  wire [3:0]rx_fifo_count;
  wire [10:0]rx_fifo_data_in;
  wire [10:0]rx_fifo_data_out;
  wire rx_fifo_full;
  wire rx_fifo_rd_en_d;
  wire rx_fifo_rd_en_d1;
  wire rx_fifo_wr_en_i;
  wire s_axi_aclk;
  wire wr_d;

  LUT6 #(
    .INIT(64'h0201000002000000)) 
    \Dout[0]_i_2 
       (.I0(L[2]),
        .I1(L[3]),
        .I2(L[1]),
        .I3(L[0]),
        .I4(\lsr_reg[0] ),
        .I5(rx_fifo_data_out[0]),
        .O(\addr_d_reg[1] ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF4F44)) 
    \Dout[2]_i_1 
       (.I0(\Dout_reg[2] ),
        .I1(rx_fifo_data_out[2]),
        .I2(\Dout_reg[2]_0 ),
        .I3(\Dout_reg[6] [0]),
        .I4(\Dout_reg[2]_1 ),
        .I5(\Dout_reg[2]_2 ),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFFBAFFBABA)) 
    \Dout[3]_i_1 
       (.I0(\Dout[3]_i_2_n_0 ),
        .I1(\Dout_reg[3] ),
        .I2(\Dout_reg[3]_0 ),
        .I3(\Dout_reg[2]_0 ),
        .I4(\Dout_reg[6] [1]),
        .I5(\Dout_reg[3]_1 ),
        .O(D[1]));
  LUT4 #(
    .INIT(16'h4F44)) 
    \Dout[3]_i_2 
       (.I0(\Dout_reg[2] ),
        .I1(rx_fifo_data_out[3]),
        .I2(\Dout_reg[3]_2 ),
        .I3(data3[0]),
        .O(\Dout[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFEFEFFFE)) 
    \Dout[5]_i_1 
       (.I0(\Dout_reg[5]_0 ),
        .I1(\Dout_reg[5]_1 ),
        .I2(\Dout[5]_i_4_n_0 ),
        .I3(\Dout_reg[6] [2]),
        .I4(\Dout_reg[2]_0 ),
        .O(D[2]));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \Dout[5]_i_4 
       (.I0(\Dout_reg[2] ),
        .I1(rx_fifo_data_out[5]),
        .I2(\Dout_reg[5]_2 [1]),
        .I3(\Dout_reg[5]_3 ),
        .I4(\Dout_reg[5]_4 ),
        .I5(\Dout_reg[5] ),
        .O(\Dout[5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF4F44)) 
    \Dout[6]_i_1 
       (.I0(\Dout_reg[2] ),
        .I1(rx_fifo_data_out[6]),
        .I2(\Dout_reg[2]_0 ),
        .I3(\Dout_reg[6] [3]),
        .I4(\Dout_reg[6]_0 ),
        .I5(\Dout_reg[6]_1 ),
        .O(D[3]));
  LUT6 #(
    .INIT(64'hFFFFFFFFBAFFBABA)) 
    \Dout[7]_i_6 
       (.I0(\Dout_reg[7] ),
        .I1(\Dout_reg[7]_0 ),
        .I2(data[0]),
        .I3(\Dout_reg[7]_1 ),
        .I4(\Dout_reg[7]_2 ),
        .I5(\Dout[7]_i_9_n_0 ),
        .O(\dll_reg[7] ));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \Dout[7]_i_9 
       (.I0(\Dout_reg[2] ),
        .I1(rx_fifo_data_out[7]),
        .I2(data[1]),
        .I3(\Dout[7]_i_6_0 ),
        .I4(\Dout[7]_i_6_1 ),
        .I5(\Dout_reg[5] ),
        .O(\Dout[7]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h0C03510051000000)) 
    FIFO_Full_i_1__0
       (.I0(FIFO_Full_i_2__0_n_0),
        .I1(rx_fifo_rd_en_d),
        .I2(Q),
        .I3(rx_fifo_wr_en_i),
        .I4(\addr_i[4]_i_3_n_0 ),
        .I5(rx_fifo_count[3]),
        .O(fifo_full_p1));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hFFDF)) 
    FIFO_Full_i_2__0
       (.I0(rx_fifo_count[1]),
        .I1(rx_fifo_count[0]),
        .I2(rx_fifo_count[2]),
        .I3(Q),
        .O(FIFO_Full_i_2__0_n_0));
  FDRE FIFO_Full_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(fifo_full_p1),
        .Q(rx_fifo_full),
        .R(SS));
  LUT6 #(
    .INIT(64'hF2F2F2F2F2F2F200)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_1 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 ),
        .I2(rx_fifo_rd_en_d),
        .I3(rx_fifo_data_out[10]),
        .I4(rx_fifo_data_out[9]),
        .I5(rx_fifo_data_out[8]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ));
  LUT6 #(
    .INIT(64'h00000000AAAAA8AA)) 
    Rx_fifo_trigger_i_1
       (.I0(Rx_fifo_trigger_i_2_n_0),
        .I1(Rx_fifo_trigger_i_3_n_0),
        .I2(rx_fifo_count[2]),
        .I3(data3[1]),
        .I4(rx_fifo_count[3]),
        .I5(Q),
        .O(fifo_trigger_level_flag));
  LUT6 #(
    .INIT(64'hD5D5D555FDDDDDDD)) 
    Rx_fifo_trigger_i_2
       (.I0(data3[2]),
        .I1(rx_fifo_count[3]),
        .I2(rx_fifo_count[2]),
        .I3(rx_fifo_count[1]),
        .I4(rx_fifo_count[0]),
        .I5(data3[1]),
        .O(Rx_fifo_trigger_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    Rx_fifo_trigger_i_3
       (.I0(rx_fifo_count[1]),
        .I1(rx_fifo_count[0]),
        .O(Rx_fifo_trigger_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h59A6)) 
    \addr_i[0]_i_1__0 
       (.I0(rx_fifo_count[0]),
        .I1(rx_fifo_rd_en_d),
        .I2(Q),
        .I3(rx_fifo_wr_en_i),
        .O(addr_i_p1[0]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h5DFBA204)) 
    \addr_i[1]_i_1__0 
       (.I0(rx_fifo_wr_en_i),
        .I1(rx_fifo_rd_en_d),
        .I2(Q),
        .I3(rx_fifo_count[0]),
        .I4(rx_fifo_count[1]),
        .O(addr_i_p1[1]));
  LUT6 #(
    .INIT(64'h2FFFFFFDD0000002)) 
    \addr_i[2]_i_1__0 
       (.I0(rx_fifo_rd_en_d),
        .I1(Q),
        .I2(rx_fifo_wr_en_i),
        .I3(rx_fifo_count[1]),
        .I4(rx_fifo_count[0]),
        .I5(rx_fifo_count[2]),
        .O(addr_i_p1[2]));
  LUT6 #(
    .INIT(64'hDFFFFFFB20000004)) 
    \addr_i[3]_i_1__0 
       (.I0(rx_fifo_wr_en_i),
        .I1(\addr_i[3]_i_2_n_0 ),
        .I2(rx_fifo_count[0]),
        .I3(rx_fifo_count[1]),
        .I4(rx_fifo_count[2]),
        .I5(rx_fifo_count[3]),
        .O(addr_i_p1[3]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \addr_i[3]_i_2 
       (.I0(rx_fifo_rd_en_d),
        .I1(Q),
        .O(\addr_i[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h03CCCCCCCCECCCEC)) 
    \addr_i[4]_i_1__0 
       (.I0(\addr_i[4]_i_2_n_0 ),
        .I1(Q),
        .I2(rx_fifo_rd_en_d),
        .I3(rx_fifo_wr_en_i),
        .I4(\addr_i[4]_i_3_n_0 ),
        .I5(rx_fifo_count[3]),
        .O(addr_i_p1[4]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \addr_i[4]_i_2 
       (.I0(rx_fifo_count[0]),
        .I1(rx_fifo_count[1]),
        .I2(rx_fifo_count[2]),
        .O(\addr_i[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \addr_i[4]_i_3 
       (.I0(rx_fifo_count[0]),
        .I1(rx_fifo_count[1]),
        .I2(rx_fifo_count[2]),
        .O(\addr_i[4]_i_3_n_0 ));
  FDSE \addr_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[0]),
        .Q(rx_fifo_count[0]),
        .S(SS));
  FDSE \addr_i_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[1]),
        .Q(rx_fifo_count[1]),
        .S(SS));
  FDSE \addr_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[2]),
        .Q(rx_fifo_count[2]),
        .S(SS));
  FDSE \addr_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[3]),
        .Q(rx_fifo_count[3]),
        .S(SS));
  FDSE \addr_i_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(addr_i_p1[4]),
        .Q(Q),
        .S(SS));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][0]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][0]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[10]),
        .Q(rx_fifo_data_out[10]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][10]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][10]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[0]),
        .Q(rx_fifo_data_out[0]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][1]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][1]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[9]),
        .Q(rx_fifo_data_out[9]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][2]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][2]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[8]),
        .Q(rx_fifo_data_out[8]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][3]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][3]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[7]),
        .Q(rx_fifo_data_out[7]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][4]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][4]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[6]),
        .Q(rx_fifo_data_out[6]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][5]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][5]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[5]),
        .Q(rx_fifo_data_out[5]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][6]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][6]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[4]),
        .Q(out[1]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][7]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][7]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[3]),
        .Q(rx_fifo_data_out[3]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][8]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][8]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[2]),
        .Q(rx_fifo_data_out[2]));
  (* srl_bus_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15] " *) 
  (* srl_name = "U0/\\XUART_I_1/UART16550_I_1/GENERATING_FIFOS.rx_fifo_block_1/srl_fifo_rbu_f_i1/data_reg[15][9]_srl16 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \data_reg[15][9]_srl16 
       (.A0(rx_fifo_count[0]),
        .A1(rx_fifo_count[1]),
        .A2(rx_fifo_count[2]),
        .A3(rx_fifo_count[3]),
        .CE(rx_fifo_wr_en_i),
        .CLK(s_axi_aclk),
        .D(rx_fifo_data_in[1]),
        .Q(out[0]));
  LUT6 #(
    .INIT(64'h44444FFF44444444)) 
    lsr2_rst_i_1
       (.I0(Q),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ),
        .I2(chipSelect),
        .I3(wr_d),
        .I4(rx_fifo_rd_en_d),
        .I5(lsr2_rst),
        .O(\addr_i_reg[4]_0 ));
  LUT6 #(
    .INIT(64'h0000000045EF0000)) 
    \lsr[0]_i_1 
       (.I0(\lsr_reg[0] ),
        .I1(\lsr_reg[0]_0 ),
        .I2(readStrobe),
        .I3(Q),
        .I4(\lsr[0]_i_3_n_0 ),
        .I5(bus2ip_reset_int_core),
        .O(\GENERATING_FIFOS.fcr_reg[0] ));
  LUT6 #(
    .INIT(64'hBFFFBBFB8FFF88F8)) 
    \lsr[0]_i_3 
       (.I0(\lsr_reg[1]_1 [0]),
        .I1(lsr_reg0),
        .I2(\lsr_reg[0] ),
        .I3(Q),
        .I4(character_received),
        .I5(\lsr_reg[1]_2 ),
        .O(\lsr[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000FECE)) 
    \lsr[1]_i_1 
       (.I0(\lsr_reg[1]_0 ),
        .I1(lsr1_set),
        .I2(lsr_reg0),
        .I3(\lsr_reg[1]_1 [1]),
        .I4(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg ),
        .I5(bus2ip_reset_int_core),
        .O(\lsr_reg[1] ));
  LUT4 #(
    .INIT(16'h8C80)) 
    \lsr[1]_i_2 
       (.I0(rx_fifo_full),
        .I1(character_received),
        .I2(\lsr_reg[0] ),
        .I3(\lsr_reg[1]_2 ),
        .O(lsr1_set));
  LUT6 #(
    .INIT(64'h0200FF0002000000)) 
    \lsr[2]_i_2 
       (.I0(rx_fifo_data_out[10]),
        .I1(\lsr[2]_i_5_n_0 ),
        .I2(rx_fifo_rd_en_d1),
        .I3(\Dout_reg[5]_2 [0]),
        .I4(\lsr_reg[0] ),
        .I5(rx_fifo_data_in[10]),
        .O(lsr2_set));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \lsr[2]_i_5 
       (.I0(Q),
        .I1(rx_fifo_rd_en_d),
        .O(\lsr[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0100FFFF01000000)) 
    \lsr[3]_i_2 
       (.I0(rx_fifo_rd_en_d1),
        .I1(rx_fifo_rd_en_d),
        .I2(Q),
        .I3(rx_fifo_data_out[9]),
        .I4(\lsr_reg[0] ),
        .I5(rx_fifo_data_in[9]),
        .O(lsr3_set));
  LUT6 #(
    .INIT(64'h0100FFFF01000000)) 
    \lsr[4]_i_2 
       (.I0(rx_fifo_rd_en_d1),
        .I1(rx_fifo_rd_en_d),
        .I2(Q),
        .I3(rx_fifo_data_out[8]),
        .I4(\lsr_reg[0] ),
        .I5(rx_fifo_data_in[8]),
        .O(lsr4_set));
endmodule

(* ORIG_REF_NAME = "tx16550" *) 
module arty_ddr_axi_uart16550_0_0_tx16550
   (tx_empty,
    tx_fifo_rd_en_int,
    Tx_fifo_rd_en_reg_0,
    rx_sin,
    sout,
    bus2ip_reset_int_core,
    s_axi_aclk,
    baudoutN_int,
    \FSM_sequential_transmit_state_reg[3]_0 ,
    Q,
    \FSM_sequential_transmit_state_reg[0]_0 ,
    \tsr_reg[7]_0 ,
    \tsr_reg[7]_1 ,
    out,
    \addr_i_reg[3] ,
    sin,
    sout_0,
    freeze);
  output tx_empty;
  output tx_fifo_rd_en_int;
  output Tx_fifo_rd_en_reg_0;
  output rx_sin;
  output sout;
  input bus2ip_reset_int_core;
  input s_axi_aclk;
  input baudoutN_int;
  input \FSM_sequential_transmit_state_reg[3]_0 ;
  input [6:0]Q;
  input \FSM_sequential_transmit_state_reg[0]_0 ;
  input [7:0]\tsr_reg[7]_0 ;
  input \tsr_reg[7]_1 ;
  input [7:0]out;
  input [0:0]\addr_i_reg[3] ;
  input sin;
  input [0:0]sout_0;
  input freeze;

  wire \FSM_sequential_transmit_state[0]_i_2_n_0 ;
  wire \FSM_sequential_transmit_state[0]_i_4_n_0 ;
  wire \FSM_sequential_transmit_state[0]_i_5_n_0 ;
  wire \FSM_sequential_transmit_state[0]_i_6_n_0 ;
  wire \FSM_sequential_transmit_state[0]_i_7_n_0 ;
  wire \FSM_sequential_transmit_state[3]_i_3_n_0 ;
  wire \FSM_sequential_transmit_state[3]_i_5_n_0 ;
  wire \FSM_sequential_transmit_state_reg[0]_0 ;
  wire \FSM_sequential_transmit_state_reg[3]_0 ;
  wire [6:0]Q;
  wire Sout0;
  wire Sout_i_1_n_0;
  wire Sout_i_2_n_0;
  wire Sout_i_3_n_0;
  wire Tx_empty0;
  wire Tx_fifo_rd_en_reg_0;
  wire [0:0]\addr_i_reg[3] ;
  wire baudoutN_int;
  wire bus2ip_reset_int_core;
  wire clk1x;
  wire clk1x_i_1__0_n_0;
  wire clk2x;
  wire clk2x0;
  wire [2:0]clkdiv;
  wire \clkdiv[3]_i_1__0_n_0 ;
  wire \clkdiv[3]_i_2__0_n_0 ;
  wire [3:0]clkdiv_reg;
  wire freeze;
  wire [6:0]in12;
  wire [3:0]next_state;
  wire [7:0]out;
  wire rx_sin;
  wire s_axi_aclk;
  wire sin;
  wire sout;
  wire [0:0]sout_0;
  wire [3:0]transmit_state;
  wire transmitting_n;
  wire transmitting_n_com;
  wire \tsr[0]_i_2_n_0 ;
  wire \tsr[0]_i_3_n_0 ;
  wire \tsr[1]_i_2_n_0 ;
  wire \tsr[1]_i_3_n_0 ;
  wire \tsr[2]_i_2_n_0 ;
  wire \tsr[2]_i_3_n_0 ;
  wire \tsr[3]_i_2_n_0 ;
  wire \tsr[3]_i_3_n_0 ;
  wire \tsr[4]_i_2_n_0 ;
  wire \tsr[4]_i_3_n_0 ;
  wire \tsr[5]_i_2_n_0 ;
  wire \tsr[5]_i_3_n_0 ;
  wire \tsr[6]_i_2_n_0 ;
  wire \tsr[6]_i_3_n_0 ;
  wire \tsr[6]_i_4_n_0 ;
  wire \tsr[7]_i_2_n_0 ;
  wire \tsr[7]_i_3_n_0 ;
  wire [7:0]tsr_com;
  wire [7:0]\tsr_reg[7]_0 ;
  wire \tsr_reg[7]_1 ;
  wire \tsr_reg_n_0_[0] ;
  wire tx_empty;
  wire tx_fifo_rd_en_com;
  wire tx_fifo_rd_en_int;
  wire tx_parity;
  wire tx_parity_com;
  wire tx_parity_i_2_n_0;
  wire tx_sout;

  LUT6 #(
    .INIT(64'hFFFFFFFFEAEAEAEE)) 
    \FSM_sequential_transmit_state[0]_i_1 
       (.I0(\FSM_sequential_transmit_state[0]_i_2_n_0 ),
        .I1(\FSM_sequential_transmit_state_reg[0]_0 ),
        .I2(\FSM_sequential_transmit_state[0]_i_4_n_0 ),
        .I3(Q[2]),
        .I4(\FSM_sequential_transmit_state[0]_i_5_n_0 ),
        .I5(\FSM_sequential_transmit_state[0]_i_6_n_0 ),
        .O(next_state[0]));
  LUT6 #(
    .INIT(64'h4445554544444444)) 
    \FSM_sequential_transmit_state[0]_i_2 
       (.I0(transmit_state[0]),
        .I1(\FSM_sequential_transmit_state[0]_i_7_n_0 ),
        .I2(transmit_state[1]),
        .I3(Q[1]),
        .I4(transmit_state[3]),
        .I5(\FSM_sequential_transmit_state_reg[0]_0 ),
        .O(\FSM_sequential_transmit_state[0]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_sequential_transmit_state[0]_i_4 
       (.I0(transmit_state[3]),
        .I1(transmit_state[2]),
        .O(\FSM_sequential_transmit_state[0]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_transmit_state[0]_i_5 
       (.I0(transmit_state[3]),
        .I1(transmit_state[1]),
        .O(\FSM_sequential_transmit_state[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000040000550000)) 
    \FSM_sequential_transmit_state[0]_i_6 
       (.I0(Q[3]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(transmit_state[2]),
        .I4(transmit_state[3]),
        .I5(transmit_state[1]),
        .O(\FSM_sequential_transmit_state[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0FFC0CFC0FFC0F7C)) 
    \FSM_sequential_transmit_state[0]_i_7 
       (.I0(Q[3]),
        .I1(transmit_state[1]),
        .I2(transmit_state[2]),
        .I3(transmit_state[3]),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(\FSM_sequential_transmit_state[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00200FFF0FFF0400)) 
    \FSM_sequential_transmit_state[1]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(transmit_state[2]),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[0]),
        .O(next_state[1]));
  LUT6 #(
    .INIT(64'h0B0B300030303030)) 
    \FSM_sequential_transmit_state[2]_i_1 
       (.I0(Q[2]),
        .I1(transmit_state[3]),
        .I2(transmit_state[2]),
        .I3(\FSM_sequential_transmit_state_reg[3]_0 ),
        .I4(transmit_state[0]),
        .I5(transmit_state[1]),
        .O(next_state[2]));
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_sequential_transmit_state[3]_i_1 
       (.I0(clk1x),
        .I1(\FSM_sequential_transmit_state[3]_i_3_n_0 ),
        .O(Sout0));
  LUT6 #(
    .INIT(64'h0000CFFFF5000000)) 
    \FSM_sequential_transmit_state[3]_i_2 
       (.I0(\FSM_sequential_transmit_state_reg[3]_0 ),
        .I1(Q[2]),
        .I2(transmit_state[0]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(transmit_state[3]),
        .O(next_state[3]));
  LUT6 #(
    .INIT(64'h0000000040000000)) 
    \FSM_sequential_transmit_state[3]_i_3 
       (.I0(\FSM_sequential_transmit_state[3]_i_5_n_0 ),
        .I1(transmit_state[3]),
        .I2(transmit_state[2]),
        .I3(Q[2]),
        .I4(clk2x),
        .I5(\FSM_sequential_transmit_state_reg[3]_0 ),
        .O(\FSM_sequential_transmit_state[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_sequential_transmit_state[3]_i_5 
       (.I0(transmit_state[1]),
        .I1(transmit_state[0]),
        .O(\FSM_sequential_transmit_state[3]_i_5_n_0 ));
  (* FSM_ENCODED_STATES = "data_bit3:0100,data_bit2:0011,data_bit1:0010,stop_bit2:1100,stop_bit1:1011,parity_bit:1010,start_bit:0001,idle:0000,data_bit6:0111,data_bit8:1001,data_bit5:0110,data_bit7:1000,data_bit4:0101" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_transmit_state_reg[0] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(next_state[0]),
        .Q(transmit_state[0]),
        .R(bus2ip_reset_int_core));
  (* FSM_ENCODED_STATES = "data_bit3:0100,data_bit2:0011,data_bit1:0010,stop_bit2:1100,stop_bit1:1011,parity_bit:1010,start_bit:0001,idle:0000,data_bit6:0111,data_bit8:1001,data_bit5:0110,data_bit7:1000,data_bit4:0101" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_transmit_state_reg[1] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(next_state[1]),
        .Q(transmit_state[1]),
        .R(bus2ip_reset_int_core));
  (* FSM_ENCODED_STATES = "data_bit3:0100,data_bit2:0011,data_bit1:0010,stop_bit2:1100,stop_bit1:1011,parity_bit:1010,start_bit:0001,idle:0000,data_bit6:0111,data_bit8:1001,data_bit5:0110,data_bit7:1000,data_bit4:0101" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_transmit_state_reg[2] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(next_state[2]),
        .Q(transmit_state[2]),
        .R(bus2ip_reset_int_core));
  (* FSM_ENCODED_STATES = "data_bit3:0100,data_bit2:0011,data_bit1:0010,stop_bit2:1100,stop_bit1:1011,parity_bit:1010,start_bit:0001,idle:0000,data_bit6:0111,data_bit8:1001,data_bit5:0110,data_bit7:1000,data_bit4:0101" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_transmit_state_reg[3] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(next_state[3]),
        .Q(transmit_state[3]),
        .R(bus2ip_reset_int_core));
  LUT2 #(
    .INIT(4'h1)) 
    Sout_i_1
       (.I0(Q[6]),
        .I1(Sout_i_2_n_0),
        .O(Sout_i_1_n_0));
  LUT6 #(
    .INIT(64'h00000000F3C5555C)) 
    Sout_i_2
       (.I0(\tsr_reg_n_0_[0] ),
        .I1(transmit_state[0]),
        .I2(transmit_state[2]),
        .I3(transmit_state[1]),
        .I4(transmit_state[3]),
        .I5(Sout_i_3_n_0),
        .O(Sout_i_2_n_0));
  LUT6 #(
    .INIT(64'h0008080800080000)) 
    Sout_i_3
       (.I0(transmit_state[3]),
        .I1(transmit_state[1]),
        .I2(transmit_state[2]),
        .I3(Q[4]),
        .I4(Q[5]),
        .I5(tx_parity),
        .O(Sout_i_3_n_0));
  FDSE Sout_reg
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(Sout_i_1_n_0),
        .Q(tx_sout),
        .S(bus2ip_reset_int_core));
  LUT2 #(
    .INIT(4'h8)) 
    Tx_empty_i_1
       (.I0(clk1x),
        .I1(transmitting_n),
        .O(Tx_empty0));
  FDSE Tx_empty_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Tx_empty0),
        .Q(tx_empty),
        .S(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h00001000)) 
    Tx_fifo_rd_en_i_1
       (.I0(transmit_state[3]),
        .I1(transmit_state[1]),
        .I2(clk1x),
        .I3(transmit_state[0]),
        .I4(transmit_state[2]),
        .O(tx_fifo_rd_en_com));
  FDRE Tx_fifo_rd_en_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(tx_fifo_rd_en_com),
        .Q(tx_fifo_rd_en_int),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \addr_i[3]_i_2__0 
       (.I0(tx_fifo_rd_en_int),
        .I1(\tsr_reg[7]_1 ),
        .I2(\addr_i_reg[3] ),
        .O(Tx_fifo_rd_en_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h00004000)) 
    clk1x_i_1__0
       (.I0(clkdiv_reg[3]),
        .I1(clkdiv_reg[2]),
        .I2(clkdiv_reg[0]),
        .I3(clkdiv_reg[1]),
        .I4(baudoutN_int),
        .O(clk1x_i_1__0_n_0));
  FDRE clk1x_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clk1x_i_1__0_n_0),
        .Q(clk1x),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h00008000)) 
    clk2x_i_1
       (.I0(clkdiv_reg[3]),
        .I1(clkdiv_reg[2]),
        .I2(clkdiv_reg[0]),
        .I3(clkdiv_reg[1]),
        .I4(baudoutN_int),
        .O(clk2x0));
  FDRE clk2x_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clk2x0),
        .Q(clk2x),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \clkdiv[0]_i_1 
       (.I0(clkdiv_reg[0]),
        .I1(\FSM_sequential_transmit_state[3]_i_3_n_0 ),
        .O(clkdiv[0]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h9A)) 
    \clkdiv[1]_i_1 
       (.I0(clkdiv_reg[1]),
        .I1(\FSM_sequential_transmit_state[3]_i_3_n_0 ),
        .I2(clkdiv_reg[0]),
        .O(clkdiv[1]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'hAA6A)) 
    \clkdiv[2]_i_1 
       (.I0(clkdiv_reg[2]),
        .I1(clkdiv_reg[1]),
        .I2(clkdiv_reg[0]),
        .I3(\FSM_sequential_transmit_state[3]_i_3_n_0 ),
        .O(clkdiv[2]));
  LUT2 #(
    .INIT(4'hB)) 
    \clkdiv[3]_i_1__0 
       (.I0(\FSM_sequential_transmit_state[3]_i_3_n_0 ),
        .I1(baudoutN_int),
        .O(\clkdiv[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h56666666)) 
    \clkdiv[3]_i_2__0 
       (.I0(clkdiv_reg[3]),
        .I1(\FSM_sequential_transmit_state[3]_i_3_n_0 ),
        .I2(clkdiv_reg[2]),
        .I3(clkdiv_reg[0]),
        .I4(clkdiv_reg[1]),
        .O(\clkdiv[3]_i_2__0_n_0 ));
  FDRE \clkdiv_reg[0] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1__0_n_0 ),
        .D(clkdiv[0]),
        .Q(clkdiv_reg[0]),
        .R(bus2ip_reset_int_core));
  FDRE \clkdiv_reg[1] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1__0_n_0 ),
        .D(clkdiv[1]),
        .Q(clkdiv_reg[1]),
        .R(bus2ip_reset_int_core));
  FDRE \clkdiv_reg[2] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1__0_n_0 ),
        .D(clkdiv[2]),
        .Q(clkdiv_reg[2]),
        .R(bus2ip_reset_int_core));
  FDRE \clkdiv_reg[3] 
       (.C(s_axi_aclk),
        .CE(\clkdiv[3]_i_1__0_n_0 ),
        .D(\clkdiv[3]_i_2__0_n_0 ),
        .Q(clkdiv_reg[3]),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'hFFAC)) 
    sin_d1_i_2
       (.I0(tx_sout),
        .I1(sin),
        .I2(sout_0),
        .I3(freeze),
        .O(rx_sin));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h54)) 
    sout_INST_0
       (.I0(Q[6]),
        .I1(tx_sout),
        .I2(sout_0),
        .O(sout));
  LUT6 #(
    .INIT(64'h2001240100012401)) 
    transmitting_n_i_1
       (.I0(transmit_state[0]),
        .I1(transmit_state[2]),
        .I2(transmit_state[1]),
        .I3(transmit_state[3]),
        .I4(\FSM_sequential_transmit_state_reg[0]_0 ),
        .I5(Q[2]),
        .O(transmitting_n_com));
  FDRE transmitting_n_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(transmitting_n_com),
        .Q(transmitting_n),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[0]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [0]),
        .I3(in12[0]),
        .I4(\tsr[0]_i_2_n_0 ),
        .I5(\tsr[0]_i_3_n_0 ),
        .O(tsr_com[0]));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[0]_i_2 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [0]),
        .O(\tsr[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[0]_i_3 
       (.I0(out[0]),
        .I1(in12[0]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[1]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [1]),
        .I3(in12[1]),
        .I4(\tsr[1]_i_2_n_0 ),
        .I5(\tsr[1]_i_3_n_0 ),
        .O(tsr_com[1]));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[1]_i_2 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [1]),
        .O(\tsr[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[1]_i_3 
       (.I0(out[1]),
        .I1(in12[1]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[2]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [2]),
        .I3(in12[2]),
        .I4(\tsr[2]_i_2_n_0 ),
        .I5(\tsr[2]_i_3_n_0 ),
        .O(tsr_com[2]));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[2]_i_2 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [2]),
        .O(\tsr[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[2]_i_3 
       (.I0(out[2]),
        .I1(in12[2]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[3]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [3]),
        .I3(in12[3]),
        .I4(\tsr[3]_i_2_n_0 ),
        .I5(\tsr[3]_i_3_n_0 ),
        .O(tsr_com[3]));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[3]_i_2 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [3]),
        .O(\tsr[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[3]_i_3 
       (.I0(out[3]),
        .I1(in12[3]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[4]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [4]),
        .I3(in12[4]),
        .I4(\tsr[4]_i_2_n_0 ),
        .I5(\tsr[4]_i_3_n_0 ),
        .O(tsr_com[4]));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[4]_i_2 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [4]),
        .O(\tsr[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[4]_i_3 
       (.I0(out[4]),
        .I1(in12[4]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[5]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [5]),
        .I3(in12[5]),
        .I4(\tsr[5]_i_2_n_0 ),
        .I5(\tsr[5]_i_3_n_0 ),
        .O(tsr_com[5]));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[5]_i_2 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [5]),
        .O(\tsr[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[5]_i_3 
       (.I0(out[5]),
        .I1(in12[5]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7500)) 
    \tsr[6]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[6]_i_2_n_0 ),
        .I2(\tsr_reg[7]_0 [6]),
        .I3(in12[6]),
        .I4(\tsr[6]_i_3_n_0 ),
        .I5(\tsr[6]_i_4_n_0 ),
        .O(tsr_com[6]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \tsr[6]_i_2 
       (.I0(\tsr_reg[7]_1 ),
        .I1(transmit_state[3]),
        .O(\tsr[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0050F0070050F005)) 
    \tsr[6]_i_3 
       (.I0(transmit_state[0]),
        .I1(\tsr_reg[7]_1 ),
        .I2(transmit_state[3]),
        .I3(transmit_state[1]),
        .I4(transmit_state[2]),
        .I5(\tsr_reg[7]_0 [6]),
        .O(\tsr[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00800080008000A0)) 
    \tsr[6]_i_4 
       (.I0(out[6]),
        .I1(in12[6]),
        .I2(\tsr_reg[7]_1 ),
        .I3(transmit_state[3]),
        .I4(transmit_state[1]),
        .I5(transmit_state[2]),
        .O(\tsr[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hDFDFDDDFDFDDDDDD)) 
    \tsr[7]_i_1 
       (.I0(\tsr[7]_i_2_n_0 ),
        .I1(\tsr[7]_i_3_n_0 ),
        .I2(transmit_state[3]),
        .I3(\tsr_reg[7]_1 ),
        .I4(out[7]),
        .I5(\tsr_reg[7]_0 [7]),
        .O(tsr_com[7]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'hEC10)) 
    \tsr[7]_i_2 
       (.I0(transmit_state[2]),
        .I1(transmit_state[1]),
        .I2(transmit_state[0]),
        .I3(transmit_state[3]),
        .O(\tsr[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \tsr[7]_i_3 
       (.I0(transmit_state[1]),
        .I1(transmit_state[2]),
        .O(\tsr[7]_i_3_n_0 ));
  FDSE \tsr_reg[0] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[0]),
        .Q(\tsr_reg_n_0_[0] ),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[1] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[1]),
        .Q(in12[0]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[2] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[2]),
        .Q(in12[1]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[3] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[3]),
        .Q(in12[2]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[4] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[4]),
        .Q(in12[3]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[5] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[5]),
        .Q(in12[4]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[6] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[6]),
        .Q(in12[5]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_reg[7] 
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tsr_com[7]),
        .Q(in12[6]),
        .S(bus2ip_reset_int_core));
  LUT6 #(
    .INIT(64'hFFFFFFFF00000100)) 
    tx_parity_i_1
       (.I0(transmit_state[3]),
        .I1(transmit_state[1]),
        .I2(Q[4]),
        .I3(transmit_state[0]),
        .I4(transmit_state[2]),
        .I5(tx_parity_i_2_n_0),
        .O(tx_parity_com));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h00660660)) 
    tx_parity_i_2
       (.I0(tx_parity),
        .I1(\tsr_reg_n_0_[0] ),
        .I2(transmit_state[1]),
        .I3(transmit_state[3]),
        .I4(transmit_state[2]),
        .O(tx_parity_i_2_n_0));
  FDRE tx_parity_reg
       (.C(s_axi_aclk),
        .CE(Sout0),
        .D(tx_parity_com),
        .Q(tx_parity),
        .R(bus2ip_reset_int_core));
endmodule

(* ORIG_REF_NAME = "tx_fifo_block" *) 
module arty_ddr_axi_uart16550_0_0_tx_fifo_block
   (Q,
    FIFO_Full_reg,
    out,
    SS,
    s_axi_aclk,
    \addr_i_reg[3] ,
    \GENERATING_FIFOS.tx_fifo_wr_en_d ,
    txrdyN_int_reg,
    tx_fifo_rd_en_int,
    txrdyn,
    data3,
    txrdyN_int_reg_0,
    \tsr_reg[7] );
  output [0:0]Q;
  output FIFO_Full_reg;
  output [7:0]out;
  input [0:0]SS;
  input s_axi_aclk;
  input \addr_i_reg[3] ;
  input \GENERATING_FIFOS.tx_fifo_wr_en_d ;
  input txrdyN_int_reg;
  input tx_fifo_rd_en_int;
  input txrdyn;
  input [0:0]data3;
  input txrdyN_int_reg_0;
  input [7:0]\tsr_reg[7] ;

  wire FIFO_Full_reg;
  wire \GENERATING_FIFOS.tx_fifo_wr_en_d ;
  wire [0:0]Q;
  wire [0:0]SS;
  wire \addr_i_reg[3] ;
  wire [0:0]data3;
  wire [7:0]out;
  wire s_axi_aclk;
  wire [7:0]\tsr_reg[7] ;
  wire tx_fifo_rd_en_int;
  wire txrdyN_int_reg;
  wire txrdyN_int_reg_0;
  wire txrdyn;

  arty_ddr_axi_uart16550_0_0_srl_fifo srl_fifo_rbu_f_i1
       (.FIFO_Full_reg_0(FIFO_Full_reg),
        .\GENERATING_FIFOS.tx_fifo_wr_en_d (\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .Q(Q),
        .SS(SS),
        .\addr_i_reg[3]_0 (\addr_i_reg[3] ),
        .data3(data3),
        .out(out),
        .s_axi_aclk(s_axi_aclk),
        .\tsr_reg[7] (\tsr_reg[7] ),
        .tx_fifo_rd_en_int(tx_fifo_rd_en_int),
        .txrdyN_int_reg(txrdyN_int_reg),
        .txrdyN_int_reg_0(txrdyN_int_reg_0),
        .txrdyn(txrdyn));
endmodule

(* ORIG_REF_NAME = "uart16550" *) 
module arty_ddr_axi_uart16550_0_0_uart16550
   (baudoutn,
    SS,
    \lsr_reg[5]_0 ,
    ip2intc_irpt,
    ddis,
    txrdyn,
    rxrdyn,
    rtsn,
    dtrn,
    out1n,
    out2n,
    sout,
    Q,
    s_axi_aclk,
    bus2ip_reset_int_core,
    Rd,
    Wr,
    ctsn,
    dsrn,
    rin,
    dcdn,
    ce_out_i,
    thre_iir_set_reg_0,
    freeze,
    sin,
    s_axi_wdata,
    \addr_d_reg[2]_0 ,
    SR);
  output baudoutn;
  output [0:0]SS;
  output \lsr_reg[5]_0 ;
  output ip2intc_irpt;
  output ddis;
  output txrdyn;
  output rxrdyn;
  output rtsn;
  output dtrn;
  output out1n;
  output out2n;
  output sout;
  output [7:0]Q;
  input s_axi_aclk;
  input bus2ip_reset_int_core;
  input Rd;
  input Wr;
  input ctsn;
  input dsrn;
  input rin;
  input dcdn;
  input [0:0]ce_out_i;
  input thre_iir_set_reg_0;
  input freeze;
  input sin;
  input [7:0]s_axi_wdata;
  input [2:0]\addr_d_reg[2]_0 ;
  input [0:0]SR;

  wire D2;
  wire Ddis_i_1_n_0;
  wire \Dout[0]_i_3_n_0 ;
  wire \Dout[0]_i_4_n_0 ;
  wire \Dout[0]_i_5_n_0 ;
  wire \Dout[0]_i_6_n_0 ;
  wire \Dout[1]_i_3_n_0 ;
  wire \Dout[1]_i_4_n_0 ;
  wire \Dout[1]_i_5_n_0 ;
  wire \Dout[1]_i_6_n_0 ;
  wire \Dout[2]_i_2_n_0 ;
  wire \Dout[2]_i_3_n_0 ;
  wire \Dout[2]_i_4_n_0 ;
  wire \Dout[2]_i_5_n_0 ;
  wire \Dout[2]_i_6_n_0 ;
  wire \Dout[2]_i_7_n_0 ;
  wire \Dout[3]_i_3_n_0 ;
  wire \Dout[3]_i_4_n_0 ;
  wire \Dout[3]_i_5_n_0 ;
  wire \Dout[3]_i_6_n_0 ;
  wire \Dout[3]_i_7_n_0 ;
  wire \Dout[4]_i_2_n_0 ;
  wire \Dout[4]_i_3_n_0 ;
  wire \Dout[4]_i_4_n_0 ;
  wire \Dout[4]_i_5_n_0 ;
  wire \Dout[5]_i_2_n_0 ;
  wire \Dout[5]_i_3_n_0 ;
  wire \Dout[5]_i_5_n_0 ;
  wire \Dout[6]_i_2_n_0 ;
  wire \Dout[6]_i_3_n_0 ;
  wire \Dout[6]_i_4_n_0 ;
  wire \Dout[6]_i_5_n_0 ;
  wire \Dout[6]_i_6_n_0 ;
  wire \Dout[7]_i_3_n_0 ;
  wire \Dout[7]_i_4_n_0 ;
  wire \Dout[7]_i_5_n_0 ;
  wire \Dout[7]_i_7_n_0 ;
  wire \Dout[7]_i_8_n_0 ;
  wire \GENERATING_FIFOS.fcr[0]_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr[1]_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr[2]_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr[3]_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr[6]_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr[7]_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr_0_prev_i_1_n_0 ;
  wire \GENERATING_FIFOS.fcr_reg0 ;
  wire \GENERATING_FIFOS.fcr_reg_n_0_[0] ;
  wire \GENERATING_FIFOS.fcr_reg_n_0_[1] ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt[0]_i_1_n_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt[1]_i_1_n_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt[2]_i_1_n_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2_n_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_3_n_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_2_n_0 ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_3_n_0 ;
  wire [3:0]\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg ;
  wire \GENERATING_FIFOS.rx_error_in_fifo_cnt_up ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_10 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_11 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_12 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_13 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_14 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_15 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_16 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_2 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_20 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_21 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_22 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_23 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_4 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_8 ;
  wire \GENERATING_FIFOS.rx_fifo_block_1_n_9 ;
  wire \GENERATING_FIFOS.rx_fifo_rst0 ;
  wire \GENERATING_FIFOS.tx_fifo_block_1_n_1 ;
  wire \GENERATING_FIFOS.tx_fifo_rst ;
  wire \GENERATING_FIFOS.tx_fifo_rst0 ;
  wire \GENERATING_FIFOS.tx_fifo_wr_en ;
  wire \GENERATING_FIFOS.tx_fifo_wr_en_d ;
  wire \GENERATING_FIFOS.tx_fifo_wr_en_d_i_2_n_0 ;
  wire Intr0;
  wire [0:3]L;
  wire Lcr0;
  wire \Lcr_reg_n_0_[0] ;
  wire \Lcr_reg_n_0_[1] ;
  wire \Lcr_reg_n_0_[2] ;
  wire \Lcr_reg_n_0_[4] ;
  wire \Lcr_reg_n_0_[5] ;
  wire \Lcr_reg_n_0_[6] ;
  wire \Lcr_reg_n_0_[7] ;
  wire \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_7_n_0 ;
  wire \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_8_n_0 ;
  wire [7:0]Q;
  wire [6:2]Rbr;
  wire Rd;
  wire Rx_error_in_fifo;
  wire [0:0]SR;
  wire [0:0]SS;
  wire [7:0]Thr;
  wire Thr0;
  wire Wr;
  wire [2:0]\addr_d_reg[2]_0 ;
  wire baudCounter1;
  wire \baudCounter[0]_i_2_n_0 ;
  wire \baudCounter[0]_i_3_n_0 ;
  wire \baudCounter[0]_i_4_n_0 ;
  wire \baudCounter[0]_i_5_n_0 ;
  wire \baudCounter[0]_i_6_n_0 ;
  wire \baudCounter[0]_i_7_n_0 ;
  wire \baudCounter[0]_i_8_n_0 ;
  wire \baudCounter[0]_i_9_n_0 ;
  wire \baudCounter[12]_i_2_n_0 ;
  wire \baudCounter[12]_i_3_n_0 ;
  wire \baudCounter[12]_i_4_n_0 ;
  wire \baudCounter[12]_i_5_n_0 ;
  wire \baudCounter[12]_i_6_n_0 ;
  wire \baudCounter[12]_i_7_n_0 ;
  wire \baudCounter[4]_i_2_n_0 ;
  wire \baudCounter[4]_i_3_n_0 ;
  wire \baudCounter[4]_i_4_n_0 ;
  wire \baudCounter[4]_i_5_n_0 ;
  wire \baudCounter[4]_i_6_n_0 ;
  wire \baudCounter[4]_i_7_n_0 ;
  wire \baudCounter[4]_i_8_n_0 ;
  wire \baudCounter[8]_i_2_n_0 ;
  wire \baudCounter[8]_i_3_n_0 ;
  wire \baudCounter[8]_i_4_n_0 ;
  wire \baudCounter[8]_i_5_n_0 ;
  wire \baudCounter[8]_i_6_n_0 ;
  wire \baudCounter[8]_i_7_n_0 ;
  wire \baudCounter[8]_i_8_n_0 ;
  wire \baudCounter[8]_i_9_n_0 ;
  wire [15:0]baudCounter_reg;
  wire \baudCounter_reg[0]_i_1_n_0 ;
  wire \baudCounter_reg[0]_i_1_n_1 ;
  wire \baudCounter_reg[0]_i_1_n_2 ;
  wire \baudCounter_reg[0]_i_1_n_3 ;
  wire \baudCounter_reg[0]_i_1_n_4 ;
  wire \baudCounter_reg[0]_i_1_n_5 ;
  wire \baudCounter_reg[0]_i_1_n_6 ;
  wire \baudCounter_reg[0]_i_1_n_7 ;
  wire \baudCounter_reg[12]_i_1_n_1 ;
  wire \baudCounter_reg[12]_i_1_n_2 ;
  wire \baudCounter_reg[12]_i_1_n_3 ;
  wire \baudCounter_reg[12]_i_1_n_4 ;
  wire \baudCounter_reg[12]_i_1_n_5 ;
  wire \baudCounter_reg[12]_i_1_n_6 ;
  wire \baudCounter_reg[12]_i_1_n_7 ;
  wire \baudCounter_reg[4]_i_1_n_0 ;
  wire \baudCounter_reg[4]_i_1_n_1 ;
  wire \baudCounter_reg[4]_i_1_n_2 ;
  wire \baudCounter_reg[4]_i_1_n_3 ;
  wire \baudCounter_reg[4]_i_1_n_4 ;
  wire \baudCounter_reg[4]_i_1_n_5 ;
  wire \baudCounter_reg[4]_i_1_n_6 ;
  wire \baudCounter_reg[4]_i_1_n_7 ;
  wire \baudCounter_reg[8]_i_1_n_0 ;
  wire \baudCounter_reg[8]_i_1_n_1 ;
  wire \baudCounter_reg[8]_i_1_n_2 ;
  wire \baudCounter_reg[8]_i_1_n_3 ;
  wire \baudCounter_reg[8]_i_1_n_4 ;
  wire \baudCounter_reg[8]_i_1_n_5 ;
  wire \baudCounter_reg[8]_i_1_n_6 ;
  wire \baudCounter_reg[8]_i_1_n_7 ;
  wire baud_counter_loaded;
  wire baud_counter_loaded_i_2_n_0;
  wire baud_counter_loaded_i_3_n_0;
  wire baud_counter_loaded_i_4_n_0;
  wire baud_counter_loaded_i_5_n_0;
  wire baudoutN_int;
  wire baudoutN_int_i;
  wire baudoutN_int_i_i_1_n_0;
  wire baudoutn;
  wire bus2ip_reset_int_core;
  wire [0:0]ce_out_i;
  wire character_received;
  wire chipSelect;
  wire ctsN_d;
  wire ctsn;
  wire \d_d_reg_n_0_[0] ;
  wire \d_d_reg_n_0_[5] ;
  wire [15:0]data;
  wire [7:3]data3;
  wire dcdN_d;
  wire dcdn;
  wire ddis;
  wire divisor_latch_loaded;
  wire divisor_latch_loaded_i_1_n_0;
  wire dlab_i_1_n_0;
  wire dll0;
  wire dlm0;
  wire dsrN_d;
  wire dsrn;
  wire dtrn;
  wire fcr1;
  wire fcr_0_prev;
  wire freeze;
  wire ier1_d;
  wire ier_reg0;
  wire \ier_reg_n_0_[0] ;
  wire \ier_reg_n_0_[3] ;
  wire \iir[0]_i_2_n_0 ;
  wire \iir[2]_i_5_n_0 ;
  wire \iir[2]_i_6_n_0 ;
  wire \iir[2]_i_8_n_0 ;
  wire \iir[3]_i_3_n_0 ;
  wire \iir[3]_i_5_n_0 ;
  wire \iir_reg_n_0_[0] ;
  wire \iir_reg_n_0_[1] ;
  wire \iir_reg_n_0_[2] ;
  wire \iir_reg_n_0_[3] ;
  wire \iir_reg_n_0_[7] ;
  wire ip2intc_irpt;
  wire load_baudlower;
  wire load_baudupper;
  wire lsr2_rst;
  wire lsr2_set;
  wire lsr3_set;
  wire lsr4_set;
  wire lsr5_d;
  wire \lsr[0]_i_2_n_0 ;
  wire \lsr[2]_i_1_n_0 ;
  wire \lsr[2]_i_4_n_0 ;
  wire \lsr[3]_i_1_n_0 ;
  wire \lsr[4]_i_1_n_0 ;
  wire \lsr[7]_i_1_n_0 ;
  wire \lsr[7]_i_2_n_0 ;
  wire \lsr[7]_i_3_n_0 ;
  wire lsr_reg;
  wire lsr_reg0;
  wire \lsr_reg[5]_0 ;
  wire \lsr_reg_n_0_[0] ;
  wire \lsr_reg_n_0_[1] ;
  wire \lsr_reg_n_0_[7] ;
  wire mcr0;
  wire mcr4_d;
  wire \mcr_reg_n_0_[0] ;
  wire \mcr_reg_n_0_[2] ;
  wire \mcr_reg_n_0_[3] ;
  wire \modem_prev_val[0]_i_1_n_0 ;
  wire \modem_prev_val[1]_i_1_n_0 ;
  wire \modem_prev_val[2]_i_1_n_0 ;
  wire \modem_prev_val[3]_i_1_n_0 ;
  wire \modem_prev_val_reg_n_0_[0] ;
  wire \modem_prev_val_reg_n_0_[1] ;
  wire msr1;
  wire \msr[0]_i_2_n_0 ;
  wire \msr[1]_i_1_n_0 ;
  wire \msr[2]_i_1_n_0 ;
  wire \msr[3]_i_1_n_0 ;
  wire \msr[4]_i_1_n_0 ;
  wire \msr[5]_i_1_n_0 ;
  wire \msr[6]_i_1_n_0 ;
  wire \msr[7]_i_1_n_0 ;
  wire msr_reg;
  wire msr_reg0;
  wire \msr_reg_n_0_[0] ;
  wire \msr_reg_n_0_[5] ;
  wire \msr_reg_n_0_[6] ;
  wire \msr_reg_n_0_[7] ;
  wire out1n;
  wire out2n;
  wire p_0_in;
  wire p_0_in1_in;
  wire p_0_in32_in;
  wire p_0_in33_in;
  wire p_0_in34_in;
  wire p_0_in37_in;
  wire p_0_in56_in;
  wire p_0_in8_in;
  wire p_1_in38_in;
  wire p_1_in3_in;
  wire p_1_in6_in;
  wire [6:0]p_2_in;
  wire p_2_in39_in;
  wire p_3_in;
  wire p_3_in60_in;
  wire p_5_in;
  wire p_71_in;
  wire rd_d;
  wire readStrobe;
  wire riN_d;
  wire rin;
  wire rtsn;
  wire rx16550_1_n_12;
  wire rx16550_1_n_14;
  wire rx16550_1_n_15;
  wire rx16550_1_n_19;
  wire rx16550_1_n_20;
  wire rx16550_1_n_21;
  wire rx16550_1_n_22;
  wire \rx_fifo_control_1/Rx_error_in_fifo0 ;
  wire \rx_fifo_control_1/character_counter_rst ;
  wire [10:0]rx_fifo_data_in;
  wire [4:1]rx_fifo_data_out;
  wire rx_fifo_empty;
  wire rx_fifo_full;
  wire rx_fifo_rd_en_d;
  wire rx_fifo_rd_en_d1;
  wire rx_fifo_wr_en_i;
  wire rx_sin;
  wire rxrdyn;
  wire s_axi_aclk;
  wire [7:0]s_axi_wdata;
  wire [7:0]scr;
  wire scr0;
  wire sin;
  wire sout;
  wire thre_iir_set;
  wire thre_iir_set_i_2_n_0;
  wire thre_iir_set_i_3_n_0;
  wire thre_iir_set_reg_0;
  wire [7:0]tsr_int;
  wire tx16550_1_n_2;
  wire tx_empty;
  wire [7:0]tx_fifo_data_out;
  wire tx_fifo_empty;
  wire tx_fifo_rd_en_int;
  wire txrdyn;
  wire wr_d;
  wire writing_thr;
  wire xuart_tx_load_sm_1_n_0;
  wire xuart_tx_load_sm_1_n_1;
  wire xuart_tx_load_sm_1_n_2;
  wire \NLW_NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_S_UNCONNECTED ;
  wire [3:3]\NLW_baudCounter_reg[12]_i_1_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT2 #(
    .INIT(4'h7)) 
    Ddis_i_1
       (.I0(chipSelect),
        .I1(rd_d),
        .O(Ddis_i_1_n_0));
  FDRE Ddis_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Ddis_i_1_n_0),
        .Q(ddis),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFFBAFFBABA)) 
    \Dout[0]_i_3 
       (.I0(\Dout[0]_i_4_n_0 ),
        .I1(\Dout[4]_i_4_n_0 ),
        .I2(data[8]),
        .I3(\lsr[7]_i_2_n_0 ),
        .I4(\lsr_reg_n_0_[0] ),
        .I5(\Dout[0]_i_5_n_0 ),
        .O(\Dout[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFC0800080)) 
    \Dout[0]_i_4 
       (.I0(\Lcr_reg_n_0_[0] ),
        .I1(L[2]),
        .I2(L[3]),
        .I3(L[1]),
        .I4(scr[0]),
        .I5(\Dout[0]_i_6_n_0 ),
        .O(\Dout[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000030800000008)) 
    \Dout[0]_i_5 
       (.I0(\ier_reg_n_0_[0] ),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[0]),
        .I4(L[1]),
        .I5(data[0]),
        .O(\Dout[0]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h23002000)) 
    \Dout[0]_i_6 
       (.I0(\msr_reg_n_0_[0] ),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[1]),
        .I4(\mcr_reg_n_0_[0] ),
        .O(\Dout[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hEFEEFFFFEFEEEFEE)) 
    \Dout[1]_i_3 
       (.I0(\Dout[1]_i_4_n_0 ),
        .I1(\Dout[1]_i_5_n_0 ),
        .I2(\Dout[4]_i_4_n_0 ),
        .I3(data[9]),
        .I4(\Dout[2]_i_6_n_0 ),
        .I5(scr[1]),
        .O(\Dout[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAFAEAAAAAAAEAAA)) 
    \Dout[1]_i_4 
       (.I0(\Dout[1]_i_6_n_0 ),
        .I1(\Lcr_reg_n_0_[1] ),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .I5(p_0_in32_in),
        .O(\Dout[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0202030002020000)) 
    \Dout[1]_i_5 
       (.I0(p_0_in),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[0]),
        .I4(L[1]),
        .I5(data[1]),
        .O(\Dout[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000A3000000A000)) 
    \Dout[1]_i_6 
       (.I0(\lsr_reg_n_0_[1] ),
        .I1(L[0]),
        .I2(L[1]),
        .I3(L[3]),
        .I4(L[2]),
        .I5(p_0_in56_in),
        .O(\Dout[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0000080C00000800)) 
    \Dout[2]_i_2 
       (.I0(p_0_in1_in),
        .I1(L[2]),
        .I2(L[3]),
        .I3(L[0]),
        .I4(L[1]),
        .I5(\iir_reg_n_0_[2] ),
        .O(\Dout[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEFEEFFFFEFEEEFEE)) 
    \Dout[2]_i_3 
       (.I0(\Dout[2]_i_4_n_0 ),
        .I1(\Dout[2]_i_5_n_0 ),
        .I2(\Dout[2]_i_6_n_0 ),
        .I3(scr[2]),
        .I4(\Dout[7]_i_8_n_0 ),
        .I5(data[2]),
        .O(\Dout[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF38000800)) 
    \Dout[2]_i_4 
       (.I0(p_0_in37_in),
        .I1(L[1]),
        .I2(L[2]),
        .I3(L[3]),
        .I4(\Lcr_reg_n_0_[2] ),
        .I5(\Dout[2]_i_7_n_0 ),
        .O(\Dout[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00A0030000A00000)) 
    \Dout[2]_i_5 
       (.I0(p_0_in33_in),
        .I1(L[0]),
        .I2(L[1]),
        .I3(L[3]),
        .I4(L[2]),
        .I5(p_3_in60_in),
        .O(\Dout[2]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \Dout[2]_i_6 
       (.I0(L[3]),
        .I1(L[2]),
        .I2(L[1]),
        .O(\Dout[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000F008000000080)) 
    \Dout[2]_i_7 
       (.I0(L[0]),
        .I1(data[10]),
        .I2(L[3]),
        .I3(L[2]),
        .I4(L[1]),
        .I5(\mcr_reg_n_0_[2] ),
        .O(\Dout[2]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'hFFFD)) 
    \Dout[3]_i_3 
       (.I0(L[2]),
        .I1(L[3]),
        .I2(L[0]),
        .I3(L[1]),
        .O(\Dout[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hEFEEFFFFEFEEEFEE)) 
    \Dout[3]_i_4 
       (.I0(\Dout[3]_i_5_n_0 ),
        .I1(\Dout[3]_i_6_n_0 ),
        .I2(\Dout[7]_i_8_n_0 ),
        .I3(data[3]),
        .I4(\lsr[7]_i_2_n_0 ),
        .I5(p_1_in38_in),
        .O(\Dout[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFAAAEAAAAAAAEAAA)) 
    \Dout[3]_i_5 
       (.I0(\Dout[3]_i_7_n_0 ),
        .I1(p_5_in),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .I5(scr[3]),
        .O(\Dout[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'h0E000200)) 
    \Dout[3]_i_6 
       (.I0(\mcr_reg_n_0_[3] ),
        .I1(L[2]),
        .I2(L[3]),
        .I3(L[1]),
        .I4(p_0_in34_in),
        .O(\Dout[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000C0800000008)) 
    \Dout[3]_i_7 
       (.I0(\ier_reg_n_0_[3] ),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[0]),
        .I4(L[1]),
        .I5(data[11]),
        .O(\Dout[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \Dout[4]_i_2 
       (.I0(\Dout[7]_i_8_n_0 ),
        .I1(data[4]),
        .I2(data[12]),
        .I3(\Dout[4]_i_4_n_0 ),
        .I4(msr_reg),
        .I5(\Dout[6]_i_4_n_0 ),
        .O(\Dout[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFB0008000)) 
    \Dout[4]_i_3 
       (.I0(scr[4]),
        .I1(L[1]),
        .I2(L[2]),
        .I3(L[3]),
        .I4(\Lcr_reg_n_0_[4] ),
        .I5(\Dout[4]_i_5_n_0 ),
        .O(\Dout[4]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'hFFDF)) 
    \Dout[4]_i_4 
       (.I0(L[3]),
        .I1(L[2]),
        .I2(L[0]),
        .I3(L[1]),
        .O(\Dout[4]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT5 #(
    .INIT(32'h0E000200)) 
    \Dout[4]_i_5 
       (.I0(p_0_in8_in),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[1]),
        .I4(p_2_in39_in),
        .O(\Dout[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0808030008080000)) 
    \Dout[5]_i_2 
       (.I0(\lsr_reg[5]_0 ),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[0]),
        .I4(L[1]),
        .I5(data[5]),
        .O(\Dout[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hF000008000000080)) 
    \Dout[5]_i_3 
       (.I0(L[0]),
        .I1(data[13]),
        .I2(L[3]),
        .I3(L[2]),
        .I4(L[1]),
        .I5(scr[5]),
        .O(\Dout[5]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'hBF)) 
    \Dout[5]_i_5 
       (.I0(L[1]),
        .I1(L[3]),
        .I2(L[2]),
        .O(\Dout[5]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    \Dout[6]_i_2 
       (.I0(L[2]),
        .I1(L[3]),
        .I2(L[1]),
        .I3(L[0]),
        .I4(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .O(\Dout[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF4F44)) 
    \Dout[6]_i_3 
       (.I0(\Dout[6]_i_4_n_0 ),
        .I1(\msr_reg_n_0_[6] ),
        .I2(\lsr[7]_i_2_n_0 ),
        .I3(lsr_reg),
        .I4(\Dout[6]_i_5_n_0 ),
        .I5(\Dout[6]_i_6_n_0 ),
        .O(\Dout[6]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \Dout[6]_i_4 
       (.I0(L[2]),
        .I1(L[3]),
        .I2(L[1]),
        .O(\Dout[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000838000008080)) 
    \Dout[6]_i_5 
       (.I0(\Lcr_reg_n_0_[6] ),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[0]),
        .I4(L[1]),
        .I5(data[6]),
        .O(\Dout[6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h44F444F4FFFF44F4)) 
    \Dout[6]_i_6 
       (.I0(\Dout[7]_i_4_n_0 ),
        .I1(data3[6]),
        .I2(data[14]),
        .I3(\Dout[4]_i_4_n_0 ),
        .I4(scr[6]),
        .I5(\Dout[2]_i_6_n_0 ),
        .O(\Dout[6]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \Dout[7]_i_1 
       (.I0(rd_d),
        .I1(chipSelect),
        .O(readStrobe));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT5 #(
    .INIT(32'h00020000)) 
    \Dout[7]_i_3 
       (.I0(\iir_reg_n_0_[7] ),
        .I1(L[1]),
        .I2(L[0]),
        .I3(L[3]),
        .I4(L[2]),
        .O(\Dout[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'hFFDF)) 
    \Dout[7]_i_4 
       (.I0(L[2]),
        .I1(L[3]),
        .I2(L[0]),
        .I3(L[1]),
        .O(\Dout[7]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \Dout[7]_i_5 
       (.I0(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I1(L[2]),
        .I2(L[3]),
        .I3(L[1]),
        .I4(L[0]),
        .O(\Dout[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'hB0008000)) 
    \Dout[7]_i_7 
       (.I0(scr[7]),
        .I1(L[1]),
        .I2(L[3]),
        .I3(L[2]),
        .I4(\Lcr_reg_n_0_[7] ),
        .O(\Dout[7]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT4 #(
    .INIT(16'hFFEF)) 
    \Dout[7]_i_8 
       (.I0(L[3]),
        .I1(L[2]),
        .I2(L[0]),
        .I3(L[1]),
        .O(\Dout[7]_i_8_n_0 ));
  FDRE \Dout_reg[0] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(rx16550_1_n_22),
        .Q(Q[0]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[1] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(rx16550_1_n_21),
        .Q(Q[1]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[2] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_14 ),
        .Q(Q[2]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[3] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_13 ),
        .Q(Q[3]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[4] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(rx16550_1_n_20),
        .Q(Q[4]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[5] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_12 ),
        .Q(Q[5]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[6] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_11 ),
        .Q(Q[6]),
        .R(bus2ip_reset_int_core));
  FDRE \Dout_reg[7] 
       (.C(s_axi_aclk),
        .CE(readStrobe),
        .D(rx16550_1_n_19),
        .Q(Q[7]),
        .R(bus2ip_reset_int_core));
  LUT6 #(
    .INIT(64'hFFFFFBFF00000800)) 
    \GENERATING_FIFOS.fcr[0]_i_1 
       (.I0(\d_d_reg_n_0_[0] ),
        .I1(\GENERATING_FIFOS.tx_fifo_wr_en_d_i_2_n_0 ),
        .I2(L[3]),
        .I3(L[2]),
        .I4(L[1]),
        .I5(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .O(\GENERATING_FIFOS.fcr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \GENERATING_FIFOS.fcr[1]_i_1 
       (.I0(p_2_in[0]),
        .I1(fcr1),
        .I2(bus2ip_reset_int_core),
        .O(\GENERATING_FIFOS.fcr[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \GENERATING_FIFOS.fcr[2]_i_1 
       (.I0(p_2_in[1]),
        .I1(fcr1),
        .I2(bus2ip_reset_int_core),
        .O(\GENERATING_FIFOS.fcr[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \GENERATING_FIFOS.fcr[3]_i_1 
       (.I0(p_2_in[2]),
        .I1(fcr1),
        .I2(data3[3]),
        .O(\GENERATING_FIFOS.fcr[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GENERATING_FIFOS.fcr[6]_i_1 
       (.I0(p_2_in[5]),
        .I1(fcr1),
        .I2(data3[6]),
        .O(\GENERATING_FIFOS.fcr[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GENERATING_FIFOS.fcr[7]_i_1 
       (.I0(p_2_in[6]),
        .I1(fcr1),
        .I2(data3[7]),
        .O(\GENERATING_FIFOS.fcr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0020000000000000)) 
    \GENERATING_FIFOS.fcr[7]_i_2 
       (.I0(fcr_0_prev),
        .I1(L[1]),
        .I2(L[2]),
        .I3(L[3]),
        .I4(chipSelect),
        .I5(wr_d),
        .O(fcr1));
  LUT6 #(
    .INIT(64'hFFFFFEFF00000200)) 
    \GENERATING_FIFOS.fcr_0_prev_i_1 
       (.I0(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I1(\GENERATING_FIFOS.tx_fifo_wr_en_d_i_2_n_0 ),
        .I2(L[3]),
        .I3(L[2]),
        .I4(L[1]),
        .I5(fcr_0_prev),
        .O(\GENERATING_FIFOS.fcr_0_prev_i_1_n_0 ));
  FDRE \GENERATING_FIFOS.fcr_0_prev_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr_0_prev_i_1_n_0 ),
        .Q(fcr_0_prev),
        .R(bus2ip_reset_int_core));
  FDRE \GENERATING_FIFOS.fcr_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr[0]_i_1_n_0 ),
        .Q(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .R(bus2ip_reset_int_core));
  FDRE \GENERATING_FIFOS.fcr_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr[1]_i_1_n_0 ),
        .Q(\GENERATING_FIFOS.fcr_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \GENERATING_FIFOS.fcr_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr[2]_i_1_n_0 ),
        .Q(p_0_in1_in),
        .R(1'b0));
  FDRE \GENERATING_FIFOS.fcr_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr[3]_i_1_n_0 ),
        .Q(data3[3]),
        .R(bus2ip_reset_int_core));
  FDRE \GENERATING_FIFOS.fcr_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr[6]_i_1_n_0 ),
        .Q(data3[6]),
        .R(bus2ip_reset_int_core));
  FDRE \GENERATING_FIFOS.fcr_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr[7]_i_1_n_0 ),
        .Q(data3[7]),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt[0]_i_1 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT5 #(
    .INIT(32'hE9696969)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt[1]_i_1 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_up ),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .I2(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .I3(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .I4(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT5 #(
    .INIT(32'hBFFCC003)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt[2]_i_1 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_up ),
        .I2(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .I3(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .I4(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE2AAAAAAA)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_up ),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .I2(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .I3(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .I4(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .I5(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn ),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT5 #(
    .INIT(32'hFFFE8001)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_3 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_up ),
        .I2(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .I3(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .I4(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h00800000)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_2 
       (.I0(chipSelect),
        .I1(rd_d),
        .I2(L[1]),
        .I3(L[2]),
        .I4(L[3]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'hFEFF)) 
    \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_3 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .I2(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .I3(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .O(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_3_n_0 ));
  FDRE \GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ),
        .Q(\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn ),
        .R(bus2ip_reset_int_core));
  FDRE \GENERATING_FIFOS.rx_error_in_fifo_cnt_reg[0] 
       (.C(s_axi_aclk),
        .CE(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2_n_0 ),
        .D(\GENERATING_FIFOS.rx_error_in_fifo_cnt[0]_i_1_n_0 ),
        .Q(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .R(SR));
  FDRE \GENERATING_FIFOS.rx_error_in_fifo_cnt_reg[1] 
       (.C(s_axi_aclk),
        .CE(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2_n_0 ),
        .D(\GENERATING_FIFOS.rx_error_in_fifo_cnt[1]_i_1_n_0 ),
        .Q(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .R(SR));
  FDRE \GENERATING_FIFOS.rx_error_in_fifo_cnt_reg[2] 
       (.C(s_axi_aclk),
        .CE(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2_n_0 ),
        .D(\GENERATING_FIFOS.rx_error_in_fifo_cnt[2]_i_1_n_0 ),
        .Q(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .R(SR));
  FDRE \GENERATING_FIFOS.rx_error_in_fifo_cnt_reg[3] 
       (.C(s_axi_aclk),
        .CE(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_2_n_0 ),
        .D(\GENERATING_FIFOS.rx_error_in_fifo_cnt[3]_i_3_n_0 ),
        .Q(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .R(SR));
  FDRE \GENERATING_FIFOS.rx_error_in_fifo_cnt_up_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Rx_error_in_fifo),
        .Q(\GENERATING_FIFOS.rx_error_in_fifo_cnt_up ),
        .R(bus2ip_reset_int_core));
  arty_ddr_axi_uart16550_0_0_rx_fifo_block \GENERATING_FIFOS.rx_fifo_block_1 
       (.D({\GENERATING_FIFOS.rx_fifo_block_1_n_11 ,\GENERATING_FIFOS.rx_fifo_block_1_n_12 ,\GENERATING_FIFOS.rx_fifo_block_1_n_13 ,\GENERATING_FIFOS.rx_fifo_block_1_n_14 }),
        .\Dout[7]_i_6 (\Dout[4]_i_4_n_0 ),
        .\Dout[7]_i_6_0 (\msr_reg_n_0_[7] ),
        .\Dout_reg[2] (\Dout[6]_i_2_n_0 ),
        .\Dout_reg[2]_0 (\Dout[7]_i_5_n_0 ),
        .\Dout_reg[2]_1 (\Dout[2]_i_2_n_0 ),
        .\Dout_reg[2]_2 (\Dout[2]_i_3_n_0 ),
        .\Dout_reg[3] (\iir_reg_n_0_[3] ),
        .\Dout_reg[3]_0 (\Dout[3]_i_3_n_0 ),
        .\Dout_reg[3]_1 (\Dout[3]_i_4_n_0 ),
        .\Dout_reg[3]_2 (\Dout[7]_i_4_n_0 ),
        .\Dout_reg[5] (\Dout[6]_i_4_n_0 ),
        .\Dout_reg[5]_0 (\Dout[5]_i_2_n_0 ),
        .\Dout_reg[5]_1 (\Dout[5]_i_3_n_0 ),
        .\Dout_reg[5]_2 ({\Lcr_reg_n_0_[5] ,p_5_in}),
        .\Dout_reg[5]_3 (\Dout[5]_i_5_n_0 ),
        .\Dout_reg[5]_4 (\msr_reg_n_0_[5] ),
        .\Dout_reg[6] ({Rbr[6:5],Rbr[3:2]}),
        .\Dout_reg[6]_0 (\Dout[7]_i_3_n_0 ),
        .\Dout_reg[6]_1 (\Dout[6]_i_3_n_0 ),
        .\Dout_reg[7] (\lsr[7]_i_2_n_0 ),
        .\Dout_reg[7]_0 (\Dout[7]_i_7_n_0 ),
        .\Dout_reg[7]_1 (\Dout[7]_i_8_n_0 ),
        .\Dout_reg[7]_2 (\lsr_reg_n_0_[7] ),
        .\GENERATING_FIFOS.fcr_reg[0] (\GENERATING_FIFOS.rx_fifo_block_1_n_2 ),
        .\GENERATING_FIFOS.fcr_reg[0]_0 (\GENERATING_FIFOS.rx_fifo_block_1_n_8 ),
        .\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 (\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn0 ),
        .\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg (\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_2_n_0 ),
        .\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_reg_0 (\GENERATING_FIFOS.rx_error_in_fifo_cnt_dn_i_3_n_0 ),
        .L(L),
        .Q(rx_fifo_empty),
        .Rx_error_in_fifo(Rx_error_in_fifo),
        .Rx_error_in_fifo0(\rx_fifo_control_1/Rx_error_in_fifo0 ),
        .SR(\rx_fifo_control_1/character_counter_rst ),
        .SS(SS),
        .\addr_d_reg[1] (\GENERATING_FIFOS.rx_fifo_block_1_n_15 ),
        .\addr_i_reg[4] (\GENERATING_FIFOS.rx_fifo_block_1_n_20 ),
        .baudoutN_int(baudoutN_int),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .character_received(character_received),
        .chipSelect(chipSelect),
        .data({data[15],data[7]}),
        .data3({data3[7:6],data3[3]}),
        .\dll_reg[7] (\GENERATING_FIFOS.rx_fifo_block_1_n_10 ),
        .\ier_reg[0] (\GENERATING_FIFOS.rx_fifo_block_1_n_23 ),
        .\iir[3]_i_2 (\iir[3]_i_5_n_0 ),
        .\iir[3]_i_2_0 (\iir_reg_n_0_[0] ),
        .\iir_reg[0] (\iir[0]_i_2_n_0 ),
        .\iir_reg[1] ({p_0_in56_in,\ier_reg_n_0_[0] }),
        .\iir_reg[1]_0 (\iir[3]_i_3_n_0 ),
        .lsr2_rst(lsr2_rst),
        .lsr2_set(lsr2_set),
        .lsr3_set(lsr3_set),
        .lsr4_set(lsr4_set),
        .lsr_reg0(lsr_reg0),
        .\lsr_reg[0] (\GENERATING_FIFOS.rx_fifo_block_1_n_16 ),
        .\lsr_reg[0]_0 (\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .\lsr_reg[0]_1 (\lsr[0]_i_2_n_0 ),
        .\lsr_reg[1] (\GENERATING_FIFOS.rx_fifo_block_1_n_4 ),
        .\lsr_reg[1]_0 (\lsr_reg_n_0_[1] ),
        .\lsr_reg[1]_1 ({p_2_in[0],\d_d_reg_n_0_[0] }),
        .out({rx_fifo_data_out[4],rx_fifo_data_out[1]}),
        .readStrobe(readStrobe),
        .rx_fifo_data_in(rx_fifo_data_in),
        .rx_fifo_full(rx_fifo_full),
        .rx_fifo_rd_en_d(rx_fifo_rd_en_d),
        .rx_fifo_rd_en_d1(rx_fifo_rd_en_d1),
        .rx_fifo_wr_en_i(rx_fifo_wr_en_i),
        .rxrdyN_int_reg(\lsr_reg_n_0_[0] ),
        .rxrdyn(rxrdyn),
        .s_axi_aclk(s_axi_aclk),
        .thre_iir_set(thre_iir_set),
        .thre_iir_set_reg(\GENERATING_FIFOS.rx_fifo_block_1_n_9 ),
        .thre_iir_set_reg_0(\GENERATING_FIFOS.rx_fifo_block_1_n_21 ),
        .thre_iir_set_reg_1(\GENERATING_FIFOS.rx_fifo_block_1_n_22 ),
        .thre_iir_set_reg_2(\iir_reg_n_0_[1] ),
        .thre_iir_set_reg_3(thre_iir_set_i_2_n_0),
        .thre_iir_set_reg_4(thre_iir_set_i_3_n_0),
        .thre_iir_set_reg_5(thre_iir_set_reg_0),
        .thre_iir_set_reg_6(\iir[2]_i_5_n_0 ),
        .thre_iir_set_reg_7(\iir_reg_n_0_[2] ),
        .thre_iir_set_reg_8(\iir[2]_i_6_n_0 ),
        .wr_d(wr_d),
        .writing_thr(writing_thr));
  FDRE \GENERATING_FIFOS.rx_fifo_rd_en_d1_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rx_fifo_rd_en_d),
        .Q(rx_fifo_rd_en_d1),
        .R(bus2ip_reset_int_core));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \GENERATING_FIFOS.rx_fifo_rd_en_d_i_1 
       (.I0(readStrobe),
        .I1(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I2(L[0]),
        .I3(L[1]),
        .I4(L[3]),
        .I5(L[2]),
        .O(p_71_in));
  FDRE \GENERATING_FIFOS.rx_fifo_rd_en_d_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_71_in),
        .Q(rx_fifo_rd_en_d),
        .R(bus2ip_reset_int_core));
  LUT5 #(
    .INIT(32'hFFFFAEEA)) 
    \GENERATING_FIFOS.rx_fifo_rst_i_1 
       (.I0(\GENERATING_FIFOS.fcr_reg_n_0_[1] ),
        .I1(\GENERATING_FIFOS.fcr_reg0 ),
        .I2(fcr_0_prev),
        .I3(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I4(bus2ip_reset_int_core),
        .O(\GENERATING_FIFOS.rx_fifo_rst0 ));
  FDRE \GENERATING_FIFOS.rx_fifo_rst_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_rst0 ),
        .Q(SS),
        .R(1'b0));
  arty_ddr_axi_uart16550_0_0_tx_fifo_block \GENERATING_FIFOS.tx_fifo_block_1 
       (.FIFO_Full_reg(\GENERATING_FIFOS.tx_fifo_block_1_n_1 ),
        .\GENERATING_FIFOS.tx_fifo_wr_en_d (\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .Q(tx_fifo_empty),
        .SS(\GENERATING_FIFOS.tx_fifo_rst ),
        .\addr_i_reg[3] (tx16550_1_n_2),
        .data3(data3[3]),
        .out(tx_fifo_data_out),
        .s_axi_aclk(s_axi_aclk),
        .\tsr_reg[7] (Thr),
        .tx_fifo_rd_en_int(tx_fifo_rd_en_int),
        .txrdyN_int_reg(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .txrdyN_int_reg_0(\lsr_reg[5]_0 ),
        .txrdyn(txrdyn));
  LUT5 #(
    .INIT(32'hFFFFAEEA)) 
    \GENERATING_FIFOS.tx_fifo_rst_i_1 
       (.I0(p_0_in1_in),
        .I1(\GENERATING_FIFOS.fcr_reg0 ),
        .I2(fcr_0_prev),
        .I3(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I4(bus2ip_reset_int_core),
        .O(\GENERATING_FIFOS.tx_fifo_rst0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT5 #(
    .INIT(32'h00000800)) 
    \GENERATING_FIFOS.tx_fifo_rst_i_2 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[3]),
        .I3(L[2]),
        .I4(L[1]),
        .O(\GENERATING_FIFOS.fcr_reg0 ));
  FDRE \GENERATING_FIFOS.tx_fifo_rst_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.tx_fifo_rst0 ),
        .Q(\GENERATING_FIFOS.tx_fifo_rst ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \GENERATING_FIFOS.tx_fifo_wr_en_d_i_1 
       (.I0(\GENERATING_FIFOS.tx_fifo_wr_en_d_i_2_n_0 ),
        .I1(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I2(L[0]),
        .I3(L[1]),
        .I4(L[3]),
        .I5(L[2]),
        .O(\GENERATING_FIFOS.tx_fifo_wr_en ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \GENERATING_FIFOS.tx_fifo_wr_en_d_i_2 
       (.I0(chipSelect),
        .I1(wr_d),
        .O(\GENERATING_FIFOS.tx_fifo_wr_en_d_i_2_n_0 ));
  FDRE \GENERATING_FIFOS.tx_fifo_wr_en_d_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.tx_fifo_wr_en ),
        .Q(\GENERATING_FIFOS.tx_fifo_wr_en_d ),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT2 #(
    .INIT(4'h1)) 
    Intr_i_1
       (.I0(\iir_reg_n_0_[0] ),
        .I1(freeze),
        .O(Intr0));
  FDRE Intr_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Intr0),
        .Q(ip2intc_irpt),
        .R(bus2ip_reset_int_core));
  LUT5 #(
    .INIT(32'h00008000)) 
    \Lcr[7]_i_1 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .O(Lcr0));
  FDSE \Lcr_reg[0] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(\Lcr_reg_n_0_[0] ),
        .S(bus2ip_reset_int_core));
  FDSE \Lcr_reg[1] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(p_2_in[0]),
        .Q(\Lcr_reg_n_0_[1] ),
        .S(bus2ip_reset_int_core));
  FDRE \Lcr_reg[2] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(p_2_in[1]),
        .Q(\Lcr_reg_n_0_[2] ),
        .R(bus2ip_reset_int_core));
  FDRE \Lcr_reg[3] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(p_2_in[2]),
        .Q(p_5_in),
        .R(bus2ip_reset_int_core));
  FDRE \Lcr_reg[4] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(p_3_in),
        .Q(\Lcr_reg_n_0_[4] ),
        .R(bus2ip_reset_int_core));
  FDRE \Lcr_reg[5] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(\d_d_reg_n_0_[5] ),
        .Q(\Lcr_reg_n_0_[5] ),
        .R(bus2ip_reset_int_core));
  FDRE \Lcr_reg[6] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(p_2_in[5]),
        .Q(\Lcr_reg_n_0_[6] ),
        .R(bus2ip_reset_int_core));
  FDRE \Lcr_reg[7] 
       (.C(s_axi_aclk),
        .CE(Lcr0),
        .D(p_2_in[6]),
        .Q(\Lcr_reg_n_0_[7] ),
        .R(bus2ip_reset_int_core));
  (* OPT_MODIFIED = "MLO" *) 
  (* __SRVAL = "FALSE" *) 
  (* box_type = "PRIMITIVE" *) 
  ODDR #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .INIT(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D1_INVERTED(1'b0),
    .IS_D2_INVERTED(1'b0),
    .SRTYPE("SYNC")) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D1(baudoutN_int),
        .D2(D2),
        .Q(baudoutn),
        .R(bus2ip_reset_int_core),
        .S(\NLW_NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_S_UNCONNECTED ));
  LUT2 #(
    .INIT(4'hE)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_2 
       (.I0(baudoutN_int_i),
        .I1(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_7_n_0 ),
        .O(D2));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_7 
       (.I0(rx16550_1_n_15),
        .I1(data[5]),
        .I2(data[6]),
        .I3(data[4]),
        .I4(data[7]),
        .I5(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_8_n_0 ),
        .O(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_8 
       (.I0(data[13]),
        .I1(data[12]),
        .I2(data[15]),
        .I3(data[14]),
        .I4(rx16550_1_n_14),
        .O(\NO_EXTERNAL_XIN.ODDR2_GEN.BAUD_FF_i_8_n_0 ));
  FDSE \Thr_reg[0] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(Thr[0]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[1] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(p_2_in[0]),
        .Q(Thr[1]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[2] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(p_2_in[1]),
        .Q(Thr[2]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[3] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(p_2_in[2]),
        .Q(Thr[3]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[4] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(p_3_in),
        .Q(Thr[4]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[5] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(\d_d_reg_n_0_[5] ),
        .Q(Thr[5]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[6] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(p_2_in[5]),
        .Q(Thr[6]),
        .S(bus2ip_reset_int_core));
  FDSE \Thr_reg[7] 
       (.C(s_axi_aclk),
        .CE(Thr0),
        .D(p_2_in[6]),
        .Q(Thr[7]),
        .S(bus2ip_reset_int_core));
  FDRE \addr_d_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\addr_d_reg[2]_0 [0]),
        .Q(L[3]),
        .R(bus2ip_reset_int_core));
  FDRE \addr_d_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\addr_d_reg[2]_0 [1]),
        .Q(L[2]),
        .R(bus2ip_reset_int_core));
  FDRE \addr_d_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\addr_d_reg[2]_0 [2]),
        .Q(L[1]),
        .R(bus2ip_reset_int_core));
  LUT1 #(
    .INIT(2'h1)) 
    \baudCounter[0]_i_2 
       (.I0(baudCounter1),
        .O(\baudCounter[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[0]_i_3 
       (.I0(\baudCounter[0]_i_7_n_0 ),
        .I1(data[3]),
        .I2(baudCounter_reg[2]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[3]),
        .I5(baudCounter1),
        .O(\baudCounter[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[0]_i_4 
       (.I0(\baudCounter[0]_i_7_n_0 ),
        .I1(data[2]),
        .I2(baudCounter_reg[3]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[2]),
        .I5(baudCounter1),
        .O(\baudCounter[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h88FF88807700777F)) 
    \baudCounter[0]_i_5 
       (.I0(\baudCounter[0]_i_8_n_0 ),
        .I1(data[1]),
        .I2(baudCounter_reg[0]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[1]),
        .I5(baudCounter1),
        .O(\baudCounter[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFF5DF05000A20FAF)) 
    \baudCounter[0]_i_6 
       (.I0(\baudCounter[0]_i_8_n_0 ),
        .I1(baudCounter_reg[1]),
        .I2(divisor_latch_loaded),
        .I3(data[0]),
        .I4(baudCounter_reg[0]),
        .I5(baudCounter1),
        .O(\baudCounter[0]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAABA)) 
    \baudCounter[0]_i_7 
       (.I0(divisor_latch_loaded),
        .I1(baud_counter_loaded_i_4_n_0),
        .I2(baud_counter_loaded_i_3_n_0),
        .I3(baudCounter_reg[5]),
        .I4(baudCounter_reg[4]),
        .O(\baudCounter[0]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAABAA)) 
    \baudCounter[0]_i_8 
       (.I0(divisor_latch_loaded),
        .I1(baudCounter_reg[15]),
        .I2(baudCounter_reg[14]),
        .I3(baud_counter_loaded_i_3_n_0),
        .I4(\baudCounter[0]_i_9_n_0 ),
        .O(\baudCounter[0]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \baudCounter[0]_i_9 
       (.I0(baudCounter_reg[4]),
        .I1(baudCounter_reg[5]),
        .I2(baudCounter_reg[2]),
        .I3(baudCounter_reg[3]),
        .O(\baudCounter[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[12]_i_2 
       (.I0(\baudCounter[12]_i_6_n_0 ),
        .I1(data[15]),
        .I2(baudCounter_reg[14]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[15]),
        .I5(baudCounter1),
        .O(\baudCounter[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[12]_i_3 
       (.I0(\baudCounter[12]_i_6_n_0 ),
        .I1(data[14]),
        .I2(baudCounter_reg[15]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[14]),
        .I5(baudCounter1),
        .O(\baudCounter[12]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[12]_i_4 
       (.I0(\baudCounter[12]_i_7_n_0 ),
        .I1(data[13]),
        .I2(baudCounter_reg[12]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[13]),
        .I5(baudCounter1),
        .O(\baudCounter[12]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[12]_i_5 
       (.I0(\baudCounter[12]_i_7_n_0 ),
        .I1(data[12]),
        .I2(baudCounter_reg[13]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[12]),
        .I5(baudCounter1),
        .O(\baudCounter[12]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hAAAABAAA)) 
    \baudCounter[12]_i_6 
       (.I0(divisor_latch_loaded),
        .I1(baudCounter_reg[1]),
        .I2(baudCounter_reg[0]),
        .I3(baud_counter_loaded_i_3_n_0),
        .I4(\baudCounter[0]_i_9_n_0 ),
        .O(\baudCounter[12]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAAAB)) 
    \baudCounter[12]_i_7 
       (.I0(divisor_latch_loaded),
        .I1(baud_counter_loaded_i_5_n_0),
        .I2(baud_counter_loaded_i_2_n_0),
        .I3(baudCounter_reg[11]),
        .I4(baudCounter_reg[10]),
        .O(\baudCounter[12]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[4]_i_2 
       (.I0(\baudCounter[4]_i_6_n_0 ),
        .I1(data[7]),
        .I2(baudCounter_reg[6]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[7]),
        .I5(baudCounter1),
        .O(\baudCounter[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[4]_i_3 
       (.I0(\baudCounter[4]_i_6_n_0 ),
        .I1(data[6]),
        .I2(baudCounter_reg[7]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[6]),
        .I5(baudCounter1),
        .O(\baudCounter[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[4]_i_4 
       (.I0(\baudCounter[4]_i_7_n_0 ),
        .I1(data[5]),
        .I2(baudCounter_reg[4]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[5]),
        .I5(baudCounter1),
        .O(\baudCounter[4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[4]_i_5 
       (.I0(\baudCounter[4]_i_7_n_0 ),
        .I1(data[4]),
        .I2(baudCounter_reg[5]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[4]),
        .I5(baudCounter1),
        .O(\baudCounter[4]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAABA)) 
    \baudCounter[4]_i_6 
       (.I0(divisor_latch_loaded),
        .I1(baud_counter_loaded_i_2_n_0),
        .I2(\baudCounter[4]_i_8_n_0 ),
        .I3(baudCounter_reg[9]),
        .I4(baudCounter_reg[8]),
        .O(\baudCounter[4]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAABA)) 
    \baudCounter[4]_i_7 
       (.I0(divisor_latch_loaded),
        .I1(baud_counter_loaded_i_4_n_0),
        .I2(baud_counter_loaded_i_3_n_0),
        .I3(baudCounter_reg[3]),
        .I4(baudCounter_reg[2]),
        .O(\baudCounter[4]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \baudCounter[4]_i_8 
       (.I0(baudCounter_reg[12]),
        .I1(baudCounter_reg[13]),
        .I2(baudCounter_reg[10]),
        .I3(baudCounter_reg[11]),
        .O(\baudCounter[4]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hB8B8FFB847470047)) 
    \baudCounter[8]_i_2 
       (.I0(data[11]),
        .I1(divisor_latch_loaded),
        .I2(baudCounter_reg[11]),
        .I3(\baudCounter[8]_i_6_n_0 ),
        .I4(\baudCounter[8]_i_7_n_0 ),
        .I5(baudCounter1),
        .O(\baudCounter[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB8B8FFB847470047)) 
    \baudCounter[8]_i_3 
       (.I0(data[10]),
        .I1(divisor_latch_loaded),
        .I2(baudCounter_reg[10]),
        .I3(\baudCounter[8]_i_8_n_0 ),
        .I4(\baudCounter[8]_i_7_n_0 ),
        .I5(baudCounter1),
        .O(\baudCounter[8]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[8]_i_4 
       (.I0(\baudCounter[8]_i_9_n_0 ),
        .I1(data[9]),
        .I2(baudCounter_reg[8]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[9]),
        .I5(baudCounter1),
        .O(\baudCounter[8]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h88FF8808770077F7)) 
    \baudCounter[8]_i_5 
       (.I0(\baudCounter[8]_i_9_n_0 ),
        .I1(data[8]),
        .I2(baudCounter_reg[9]),
        .I3(divisor_latch_loaded),
        .I4(baudCounter_reg[8]),
        .I5(baudCounter1),
        .O(\baudCounter[8]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h0010)) 
    \baudCounter[8]_i_6 
       (.I0(baudCounter_reg[12]),
        .I1(baudCounter_reg[13]),
        .I2(data[11]),
        .I3(baudCounter_reg[10]),
        .O(\baudCounter[8]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \baudCounter[8]_i_7 
       (.I0(baudCounter_reg[7]),
        .I1(baudCounter_reg[6]),
        .I2(baudCounter_reg[9]),
        .I3(baudCounter_reg[8]),
        .I4(baud_counter_loaded_i_2_n_0),
        .O(\baudCounter[8]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h0010)) 
    \baudCounter[8]_i_8 
       (.I0(baudCounter_reg[12]),
        .I1(baudCounter_reg[13]),
        .I2(data[10]),
        .I3(baudCounter_reg[11]),
        .O(\baudCounter[8]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAABA)) 
    \baudCounter[8]_i_9 
       (.I0(divisor_latch_loaded),
        .I1(baud_counter_loaded_i_2_n_0),
        .I2(\baudCounter[4]_i_8_n_0 ),
        .I3(baudCounter_reg[7]),
        .I4(baudCounter_reg[6]),
        .O(\baudCounter[8]_i_9_n_0 ));
  FDSE \baudCounter_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[0]_i_1_n_7 ),
        .Q(baudCounter_reg[0]),
        .S(bus2ip_reset_int_core));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \baudCounter_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\baudCounter_reg[0]_i_1_n_0 ,\baudCounter_reg[0]_i_1_n_1 ,\baudCounter_reg[0]_i_1_n_2 ,\baudCounter_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 }),
        .O({\baudCounter_reg[0]_i_1_n_4 ,\baudCounter_reg[0]_i_1_n_5 ,\baudCounter_reg[0]_i_1_n_6 ,\baudCounter_reg[0]_i_1_n_7 }),
        .S({\baudCounter[0]_i_3_n_0 ,\baudCounter[0]_i_4_n_0 ,\baudCounter[0]_i_5_n_0 ,\baudCounter[0]_i_6_n_0 }));
  FDRE \baudCounter_reg[10] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[8]_i_1_n_5 ),
        .Q(baudCounter_reg[10]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[11] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[8]_i_1_n_4 ),
        .Q(baudCounter_reg[11]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[12] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[12]_i_1_n_7 ),
        .Q(baudCounter_reg[12]),
        .R(bus2ip_reset_int_core));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \baudCounter_reg[12]_i_1 
       (.CI(\baudCounter_reg[8]_i_1_n_0 ),
        .CO({\NLW_baudCounter_reg[12]_i_1_CO_UNCONNECTED [3],\baudCounter_reg[12]_i_1_n_1 ,\baudCounter_reg[12]_i_1_n_2 ,\baudCounter_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 }),
        .O({\baudCounter_reg[12]_i_1_n_4 ,\baudCounter_reg[12]_i_1_n_5 ,\baudCounter_reg[12]_i_1_n_6 ,\baudCounter_reg[12]_i_1_n_7 }),
        .S({\baudCounter[12]_i_2_n_0 ,\baudCounter[12]_i_3_n_0 ,\baudCounter[12]_i_4_n_0 ,\baudCounter[12]_i_5_n_0 }));
  FDRE \baudCounter_reg[13] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[12]_i_1_n_6 ),
        .Q(baudCounter_reg[13]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[14] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[12]_i_1_n_5 ),
        .Q(baudCounter_reg[14]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[15] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[12]_i_1_n_4 ),
        .Q(baudCounter_reg[15]),
        .R(bus2ip_reset_int_core));
  FDSE \baudCounter_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[0]_i_1_n_6 ),
        .Q(baudCounter_reg[1]),
        .S(bus2ip_reset_int_core));
  FDSE \baudCounter_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[0]_i_1_n_5 ),
        .Q(baudCounter_reg[2]),
        .S(bus2ip_reset_int_core));
  FDSE \baudCounter_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[0]_i_1_n_4 ),
        .Q(baudCounter_reg[3]),
        .S(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[4]_i_1_n_7 ),
        .Q(baudCounter_reg[4]),
        .R(bus2ip_reset_int_core));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \baudCounter_reg[4]_i_1 
       (.CI(\baudCounter_reg[0]_i_1_n_0 ),
        .CO({\baudCounter_reg[4]_i_1_n_0 ,\baudCounter_reg[4]_i_1_n_1 ,\baudCounter_reg[4]_i_1_n_2 ,\baudCounter_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 }),
        .O({\baudCounter_reg[4]_i_1_n_4 ,\baudCounter_reg[4]_i_1_n_5 ,\baudCounter_reg[4]_i_1_n_6 ,\baudCounter_reg[4]_i_1_n_7 }),
        .S({\baudCounter[4]_i_2_n_0 ,\baudCounter[4]_i_3_n_0 ,\baudCounter[4]_i_4_n_0 ,\baudCounter[4]_i_5_n_0 }));
  FDRE \baudCounter_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[4]_i_1_n_6 ),
        .Q(baudCounter_reg[5]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[4]_i_1_n_5 ),
        .Q(baudCounter_reg[6]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[4]_i_1_n_4 ),
        .Q(baudCounter_reg[7]),
        .R(bus2ip_reset_int_core));
  FDRE \baudCounter_reg[8] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[8]_i_1_n_7 ),
        .Q(baudCounter_reg[8]),
        .R(bus2ip_reset_int_core));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \baudCounter_reg[8]_i_1 
       (.CI(\baudCounter_reg[4]_i_1_n_0 ),
        .CO({\baudCounter_reg[8]_i_1_n_0 ,\baudCounter_reg[8]_i_1_n_1 ,\baudCounter_reg[8]_i_1_n_2 ,\baudCounter_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 ,\baudCounter[0]_i_2_n_0 }),
        .O({\baudCounter_reg[8]_i_1_n_4 ,\baudCounter_reg[8]_i_1_n_5 ,\baudCounter_reg[8]_i_1_n_6 ,\baudCounter_reg[8]_i_1_n_7 }),
        .S({\baudCounter[8]_i_2_n_0 ,\baudCounter[8]_i_3_n_0 ,\baudCounter[8]_i_4_n_0 ,\baudCounter[8]_i_5_n_0 }));
  FDSE \baudCounter_reg[9] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\baudCounter_reg[8]_i_1_n_6 ),
        .Q(baudCounter_reg[9]),
        .S(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    baud_counter_loaded_i_1
       (.I0(divisor_latch_loaded),
        .I1(baud_counter_loaded_i_2_n_0),
        .I2(baud_counter_loaded_i_3_n_0),
        .O(baudCounter1));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    baud_counter_loaded_i_2
       (.I0(baudCounter_reg[3]),
        .I1(baudCounter_reg[2]),
        .I2(baudCounter_reg[5]),
        .I3(baudCounter_reg[4]),
        .I4(baud_counter_loaded_i_4_n_0),
        .O(baud_counter_loaded_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    baud_counter_loaded_i_3
       (.I0(baudCounter_reg[11]),
        .I1(baudCounter_reg[10]),
        .I2(baudCounter_reg[13]),
        .I3(baudCounter_reg[12]),
        .I4(baud_counter_loaded_i_5_n_0),
        .O(baud_counter_loaded_i_3_n_0));
  LUT4 #(
    .INIT(16'hFFEF)) 
    baud_counter_loaded_i_4
       (.I0(baudCounter_reg[14]),
        .I1(baudCounter_reg[15]),
        .I2(baudCounter_reg[0]),
        .I3(baudCounter_reg[1]),
        .O(baud_counter_loaded_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    baud_counter_loaded_i_5
       (.I0(baudCounter_reg[8]),
        .I1(baudCounter_reg[9]),
        .I2(baudCounter_reg[6]),
        .I3(baudCounter_reg[7]),
        .O(baud_counter_loaded_i_5_n_0));
  FDRE baud_counter_loaded_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(baudCounter1),
        .Q(baud_counter_loaded),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT2 #(
    .INIT(4'hB)) 
    baudoutN_int_i_i_1
       (.I0(baud_counter_loaded_i_2_n_0),
        .I1(baud_counter_loaded_i_3_n_0),
        .O(baudoutN_int_i_i_1_n_0));
  FDRE baudoutN_int_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(baudoutN_int_i_i_1_n_0),
        .Q(baudoutN_int_i),
        .R(1'b0));
  FDRE chipSelect_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ce_out_i),
        .Q(chipSelect),
        .R(bus2ip_reset_int_core));
  FDRE ctsN_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ctsn),
        .Q(ctsN_d),
        .R(1'b0));
  FDRE \d_d_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[0]),
        .Q(\d_d_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \d_d_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[1]),
        .Q(p_2_in[0]),
        .R(1'b0));
  FDRE \d_d_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[2]),
        .Q(p_2_in[1]),
        .R(1'b0));
  FDRE \d_d_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[3]),
        .Q(p_2_in[2]),
        .R(1'b0));
  FDRE \d_d_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[4]),
        .Q(p_3_in),
        .R(1'b0));
  FDRE \d_d_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[5]),
        .Q(\d_d_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \d_d_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[6]),
        .Q(p_2_in[5]),
        .R(1'b0));
  FDRE \d_d_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_wdata[7]),
        .Q(p_2_in[6]),
        .R(1'b0));
  FDRE dcdN_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(dcdn),
        .Q(dcdN_d),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h00005554)) 
    divisor_latch_loaded_i_1
       (.I0(bus2ip_reset_int_core),
        .I1(load_baudupper),
        .I2(load_baudlower),
        .I3(divisor_latch_loaded),
        .I4(baud_counter_loaded),
        .O(divisor_latch_loaded_i_1_n_0));
  FDRE divisor_latch_loaded_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(divisor_latch_loaded_i_1_n_0),
        .Q(divisor_latch_loaded),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFBFFF00008000)) 
    dlab_i_1
       (.I0(L[0]),
        .I1(\GENERATING_FIFOS.tx_fifo_wr_en_d_i_2_n_0 ),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .I5(\Lcr_reg_n_0_[7] ),
        .O(dlab_i_1_n_0));
  FDRE dlab_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(dlab_i_1_n_0),
        .Q(L[0]),
        .R(bus2ip_reset_int_core));
  LUT6 #(
    .INIT(64'h0000000000000800)) 
    \dll[7]_i_1 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[1]),
        .I3(L[0]),
        .I4(L[2]),
        .I5(L[3]),
        .O(dll0));
  FDSE \dll_reg[0] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(data[0]),
        .S(bus2ip_reset_int_core));
  FDSE \dll_reg[1] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(p_2_in[0]),
        .Q(data[1]),
        .S(bus2ip_reset_int_core));
  FDSE \dll_reg[2] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(p_2_in[1]),
        .Q(data[2]),
        .S(bus2ip_reset_int_core));
  FDSE \dll_reg[3] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(p_2_in[2]),
        .Q(data[3]),
        .S(bus2ip_reset_int_core));
  FDRE \dll_reg[4] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(p_3_in),
        .Q(data[4]),
        .R(bus2ip_reset_int_core));
  FDRE \dll_reg[5] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(\d_d_reg_n_0_[5] ),
        .Q(data[5]),
        .R(bus2ip_reset_int_core));
  FDRE \dll_reg[6] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(p_2_in[5]),
        .Q(data[6]),
        .R(bus2ip_reset_int_core));
  FDRE \dll_reg[7] 
       (.C(s_axi_aclk),
        .CE(dll0),
        .D(p_2_in[6]),
        .Q(data[7]),
        .R(bus2ip_reset_int_core));
  LUT6 #(
    .INIT(64'h0000080000000000)) 
    \dlm[7]_i_1 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[1]),
        .I3(L[0]),
        .I4(L[2]),
        .I5(L[3]),
        .O(dlm0));
  FDRE \dlm_reg[0] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(data[8]),
        .R(bus2ip_reset_int_core));
  FDSE \dlm_reg[1] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(p_2_in[0]),
        .Q(data[9]),
        .S(bus2ip_reset_int_core));
  FDRE \dlm_reg[2] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(p_2_in[1]),
        .Q(data[10]),
        .R(bus2ip_reset_int_core));
  FDRE \dlm_reg[3] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(p_2_in[2]),
        .Q(data[11]),
        .R(bus2ip_reset_int_core));
  FDRE \dlm_reg[4] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(p_3_in),
        .Q(data[12]),
        .R(bus2ip_reset_int_core));
  FDRE \dlm_reg[5] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(\d_d_reg_n_0_[5] ),
        .Q(data[13]),
        .R(bus2ip_reset_int_core));
  FDRE \dlm_reg[6] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(p_2_in[5]),
        .Q(data[14]),
        .R(bus2ip_reset_int_core));
  FDRE \dlm_reg[7] 
       (.C(s_axi_aclk),
        .CE(dlm0),
        .D(p_2_in[6]),
        .Q(data[15]),
        .R(bus2ip_reset_int_core));
  FDRE dsrN_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(dsrn),
        .Q(dsrN_d),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT2 #(
    .INIT(4'hB)) 
    dtrn_INST_0
       (.I0(p_0_in8_in),
        .I1(\mcr_reg_n_0_[0] ),
        .O(dtrn));
  FDRE ier1_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in56_in),
        .Q(ier1_d),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000000000000800)) 
    \ier[3]_i_1 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .I5(L[0]),
        .O(ier_reg0));
  FDRE \ier_reg[0] 
       (.C(s_axi_aclk),
        .CE(ier_reg0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(\ier_reg_n_0_[0] ),
        .R(bus2ip_reset_int_core));
  FDRE \ier_reg[1] 
       (.C(s_axi_aclk),
        .CE(ier_reg0),
        .D(p_2_in[0]),
        .Q(p_0_in56_in),
        .R(bus2ip_reset_int_core));
  FDRE \ier_reg[2] 
       (.C(s_axi_aclk),
        .CE(ier_reg0),
        .D(p_2_in[1]),
        .Q(p_3_in60_in),
        .R(bus2ip_reset_int_core));
  FDRE \ier_reg[3] 
       (.C(s_axi_aclk),
        .CE(ier_reg0),
        .D(p_2_in[2]),
        .Q(\ier_reg_n_0_[3] ),
        .R(bus2ip_reset_int_core));
  LUT5 #(
    .INIT(32'hAAAAAAA8)) 
    \iir[0]_i_2 
       (.I0(\ier_reg_n_0_[3] ),
        .I1(\msr_reg_n_0_[0] ),
        .I2(p_0_in34_in),
        .I3(p_0_in32_in),
        .I4(p_0_in33_in),
        .O(\iir[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000008200000000)) 
    \iir[2]_i_5 
       (.I0(\iir[2]_i_8_n_0 ),
        .I1(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .I2(\iir_reg_n_0_[3] ),
        .I3(\iir_reg_n_0_[0] ),
        .I4(\iir_reg_n_0_[1] ),
        .I5(\iir_reg_n_0_[2] ),
        .O(\iir[2]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \iir[2]_i_6 
       (.I0(\iir_reg_n_0_[3] ),
        .I1(\iir_reg_n_0_[0] ),
        .O(\iir[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \iir[2]_i_8 
       (.I0(chipSelect),
        .I1(rd_d),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .I5(L[0]),
        .O(\iir[2]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAAA8)) 
    \iir[3]_i_3 
       (.I0(p_3_in60_in),
        .I1(p_2_in39_in),
        .I2(\lsr_reg_n_0_[1] ),
        .I3(p_1_in38_in),
        .I4(p_0_in37_in),
        .O(\iir[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h00800000)) 
    \iir[3]_i_5 
       (.I0(chipSelect),
        .I1(rd_d),
        .I2(L[1]),
        .I3(L[3]),
        .I4(L[2]),
        .O(\iir[3]_i_5_n_0 ));
  FDRE \iir_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_21 ),
        .Q(\iir_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \iir_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_22 ),
        .Q(\iir_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \iir_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_23 ),
        .Q(\iir_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \iir_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_8 ),
        .Q(\iir_reg_n_0_[3] ),
        .R(1'b0));
  FDRE \iir_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .Q(\iir_reg_n_0_[7] ),
        .R(1'b0));
  FDRE load_baudlower_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(dll0),
        .Q(load_baudlower),
        .R(1'b0));
  FDRE load_baudupper_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(dlm0),
        .Q(load_baudupper),
        .R(1'b0));
  FDRE lsr2_rst_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_20 ),
        .Q(lsr2_rst),
        .R(bus2ip_reset_int_core));
  FDRE lsr5_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\lsr_reg[5]_0 ),
        .Q(lsr5_d),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \lsr[0]_i_2 
       (.I0(L[0]),
        .I1(L[1]),
        .I2(L[3]),
        .I3(L[2]),
        .O(\lsr[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000FECE)) 
    \lsr[2]_i_1 
       (.I0(p_0_in37_in),
        .I1(lsr2_set),
        .I2(lsr_reg0),
        .I3(p_2_in[1]),
        .I4(\lsr[2]_i_4_n_0 ),
        .I5(lsr2_rst),
        .O(\lsr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h00800000)) 
    \lsr[2]_i_3 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[1]),
        .I3(L[2]),
        .I4(L[3]),
        .O(lsr_reg0));
  LUT6 #(
    .INIT(64'hAEAAAAAAAAAAAAAA)) 
    \lsr[2]_i_4 
       (.I0(bus2ip_reset_int_core),
        .I1(L[3]),
        .I2(L[2]),
        .I3(L[1]),
        .I4(rd_d),
        .I5(chipSelect),
        .O(\lsr[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000FECE)) 
    \lsr[3]_i_1 
       (.I0(p_1_in38_in),
        .I1(lsr3_set),
        .I2(lsr_reg0),
        .I3(p_2_in[2]),
        .I4(\lsr[2]_i_4_n_0 ),
        .I5(lsr2_rst),
        .O(\lsr[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000FECE)) 
    \lsr[4]_i_1 
       (.I0(p_2_in39_in),
        .I1(lsr4_set),
        .I2(lsr_reg0),
        .I3(p_3_in),
        .I4(\lsr[2]_i_4_n_0 ),
        .I5(lsr2_rst),
        .O(\lsr[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h00004555)) 
    \lsr[7]_i_1 
       (.I0(bus2ip_reset_int_core),
        .I1(\lsr[7]_i_2_n_0 ),
        .I2(rd_d),
        .I3(chipSelect),
        .I4(\lsr[7]_i_3_n_0 ),
        .O(\lsr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \lsr[7]_i_2 
       (.I0(L[3]),
        .I1(L[2]),
        .I2(L[1]),
        .O(\lsr[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT5 #(
    .INIT(32'h0001FFFF)) 
    \lsr[7]_i_3 
       (.I0(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [1]),
        .I1(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [2]),
        .I2(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [3]),
        .I3(\GENERATING_FIFOS.rx_error_in_fifo_cnt_reg [0]),
        .I4(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .O(\lsr[7]_i_3_n_0 ));
  FDRE \lsr_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_2 ),
        .Q(\lsr_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \lsr_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_4 ),
        .Q(\lsr_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \lsr_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\lsr[2]_i_1_n_0 ),
        .Q(p_0_in37_in),
        .R(1'b0));
  FDRE \lsr_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\lsr[3]_i_1_n_0 ),
        .Q(p_1_in38_in),
        .R(1'b0));
  FDRE \lsr_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\lsr[4]_i_1_n_0 ),
        .Q(p_2_in39_in),
        .R(1'b0));
  FDRE \lsr_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(xuart_tx_load_sm_1_n_2),
        .Q(\lsr_reg[5]_0 ),
        .R(1'b0));
  FDRE \lsr_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(xuart_tx_load_sm_1_n_0),
        .Q(lsr_reg),
        .R(1'b0));
  FDRE \lsr_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\lsr[7]_i_1_n_0 ),
        .Q(\lsr_reg_n_0_[7] ),
        .R(1'b0));
  FDRE mcr4_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in8_in),
        .Q(mcr4_d),
        .R(bus2ip_reset_int_core));
  LUT5 #(
    .INIT(32'h00000080)) 
    \mcr[4]_i_1 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[1]),
        .I3(L[2]),
        .I4(L[3]),
        .O(mcr0));
  FDRE \mcr_reg[0] 
       (.C(s_axi_aclk),
        .CE(mcr0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(\mcr_reg_n_0_[0] ),
        .R(bus2ip_reset_int_core));
  FDRE \mcr_reg[1] 
       (.C(s_axi_aclk),
        .CE(mcr0),
        .D(p_2_in[0]),
        .Q(p_0_in),
        .R(bus2ip_reset_int_core));
  FDRE \mcr_reg[2] 
       (.C(s_axi_aclk),
        .CE(mcr0),
        .D(p_2_in[1]),
        .Q(\mcr_reg_n_0_[2] ),
        .R(bus2ip_reset_int_core));
  FDRE \mcr_reg[3] 
       (.C(s_axi_aclk),
        .CE(mcr0),
        .D(p_2_in[2]),
        .Q(\mcr_reg_n_0_[3] ),
        .R(bus2ip_reset_int_core));
  FDRE \mcr_reg[4] 
       (.C(s_axi_aclk),
        .CE(mcr0),
        .D(p_3_in),
        .Q(p_0_in8_in),
        .R(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h74)) 
    \modem_prev_val[0]_i_1 
       (.I0(ctsN_d),
        .I1(bus2ip_reset_int_core),
        .I2(msr_reg),
        .O(\modem_prev_val[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h74)) 
    \modem_prev_val[1]_i_1 
       (.I0(dsrN_d),
        .I1(bus2ip_reset_int_core),
        .I2(\msr_reg_n_0_[5] ),
        .O(\modem_prev_val[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h74)) 
    \modem_prev_val[2]_i_1 
       (.I0(riN_d),
        .I1(bus2ip_reset_int_core),
        .I2(\msr_reg_n_0_[6] ),
        .O(\modem_prev_val[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h74)) 
    \modem_prev_val[3]_i_1 
       (.I0(dcdN_d),
        .I1(bus2ip_reset_int_core),
        .I2(\msr_reg_n_0_[7] ),
        .O(\modem_prev_val[3]_i_1_n_0 ));
  FDRE \modem_prev_val_reg[0] 
       (.C(s_axi_aclk),
        .CE(msr_reg0),
        .D(\modem_prev_val[0]_i_1_n_0 ),
        .Q(\modem_prev_val_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \modem_prev_val_reg[1] 
       (.C(s_axi_aclk),
        .CE(msr_reg0),
        .D(\modem_prev_val[1]_i_1_n_0 ),
        .Q(\modem_prev_val_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \modem_prev_val_reg[2] 
       (.C(s_axi_aclk),
        .CE(msr_reg0),
        .D(\modem_prev_val[2]_i_1_n_0 ),
        .Q(p_1_in3_in),
        .R(1'b0));
  FDRE \modem_prev_val_reg[3] 
       (.C(s_axi_aclk),
        .CE(msr_reg0),
        .D(\modem_prev_val[3]_i_1_n_0 ),
        .Q(p_1_in6_in),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hAEAAAAAAAAAAAAAA)) 
    \msr[0]_i_1 
       (.I0(bus2ip_reset_int_core),
        .I1(L[2]),
        .I2(L[3]),
        .I3(L[1]),
        .I4(rd_d),
        .I5(chipSelect),
        .O(msr_reg0));
  LUT5 #(
    .INIT(32'hB8BFBFB8)) 
    \msr[0]_i_2 
       (.I0(\d_d_reg_n_0_[0] ),
        .I1(msr1),
        .I2(\msr_reg_n_0_[0] ),
        .I3(\modem_prev_val_reg_n_0_[0] ),
        .I4(msr_reg),
        .O(\msr[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h00800000)) 
    \msr[0]_i_3 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[1]),
        .I3(L[3]),
        .I4(L[2]),
        .O(msr1));
  LUT5 #(
    .INIT(32'hB8BFBFB8)) 
    \msr[1]_i_1 
       (.I0(p_2_in[0]),
        .I1(msr1),
        .I2(p_0_in32_in),
        .I3(\modem_prev_val_reg_n_0_[1] ),
        .I4(\msr_reg_n_0_[5] ),
        .O(\msr[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BFBFB8)) 
    \msr[2]_i_1 
       (.I0(p_2_in[1]),
        .I1(msr1),
        .I2(p_0_in33_in),
        .I3(p_1_in3_in),
        .I4(\msr_reg_n_0_[6] ),
        .O(\msr[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BFBFB8)) 
    \msr[3]_i_1 
       (.I0(p_2_in[2]),
        .I1(msr1),
        .I2(p_0_in34_in),
        .I3(p_1_in6_in),
        .I4(\msr_reg_n_0_[7] ),
        .O(\msr[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5F5F5C5550505C55)) 
    \msr[4]_i_1 
       (.I0(ctsN_d),
        .I1(p_0_in),
        .I2(bus2ip_reset_int_core),
        .I3(p_0_in8_in),
        .I4(msr1),
        .I5(p_3_in),
        .O(\msr[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h55CF55C055C555C5)) 
    \msr[5]_i_1 
       (.I0(dsrN_d),
        .I1(\d_d_reg_n_0_[5] ),
        .I2(msr1),
        .I3(bus2ip_reset_int_core),
        .I4(\mcr_reg_n_0_[0] ),
        .I5(p_0_in8_in),
        .O(\msr[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5F5F5C5550505C55)) 
    \msr[6]_i_1 
       (.I0(riN_d),
        .I1(\mcr_reg_n_0_[2] ),
        .I2(bus2ip_reset_int_core),
        .I3(p_0_in8_in),
        .I4(msr1),
        .I5(\d_d_reg_n_0_[5] ),
        .O(\msr[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5F5F5C5550505C55)) 
    \msr[7]_i_1 
       (.I0(dcdN_d),
        .I1(\mcr_reg_n_0_[3] ),
        .I2(bus2ip_reset_int_core),
        .I3(p_0_in8_in),
        .I4(msr1),
        .I5(\d_d_reg_n_0_[5] ),
        .O(\msr[7]_i_1_n_0 ));
  FDRE \msr_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[0]_i_2_n_0 ),
        .Q(\msr_reg_n_0_[0] ),
        .R(msr_reg0));
  FDRE \msr_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[1]_i_1_n_0 ),
        .Q(p_0_in32_in),
        .R(msr_reg0));
  FDRE \msr_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[2]_i_1_n_0 ),
        .Q(p_0_in33_in),
        .R(msr_reg0));
  FDRE \msr_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[3]_i_1_n_0 ),
        .Q(p_0_in34_in),
        .R(msr_reg0));
  FDRE \msr_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[4]_i_1_n_0 ),
        .Q(msr_reg),
        .R(1'b0));
  FDRE \msr_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[5]_i_1_n_0 ),
        .Q(\msr_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \msr_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[6]_i_1_n_0 ),
        .Q(\msr_reg_n_0_[6] ),
        .R(1'b0));
  FDRE \msr_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\msr[7]_i_1_n_0 ),
        .Q(\msr_reg_n_0_[7] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT2 #(
    .INIT(4'hB)) 
    out1n_INST_0
       (.I0(p_0_in8_in),
        .I1(\mcr_reg_n_0_[2] ),
        .O(out1n));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT2 #(
    .INIT(4'hB)) 
    out2n_INST_0
       (.I0(p_0_in8_in),
        .I1(\mcr_reg_n_0_[3] ),
        .O(out2n));
  FDRE rd_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Rd),
        .Q(rd_d),
        .R(1'b0));
  FDRE riN_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rin),
        .Q(riN_d),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT2 #(
    .INIT(4'hB)) 
    rtsn_INST_0
       (.I0(p_0_in8_in),
        .I1(p_0_in),
        .O(rtsn));
  arty_ddr_axi_uart16550_0_0_rx16550 rx16550_1
       (.D({rx16550_1_n_19,rx16550_1_n_20,rx16550_1_n_21,rx16550_1_n_22}),
        .\Dout_reg[0] (\Dout[3]_i_3_n_0 ),
        .\Dout_reg[0]_0 (\iir_reg_n_0_[0] ),
        .\Dout_reg[0]_1 (\GENERATING_FIFOS.rx_fifo_block_1_n_15 ),
        .\Dout_reg[0]_2 (\Dout[0]_i_3_n_0 ),
        .\Dout_reg[1] (\GENERATING_FIFOS.fcr_reg_n_0_[1] ),
        .\Dout_reg[1]_0 (\Dout[1]_i_3_n_0 ),
        .\Dout_reg[1]_1 (\iir_reg_n_0_[1] ),
        .\Dout_reg[4] (\Dout[4]_i_2_n_0 ),
        .\Dout_reg[4]_0 (\Dout[4]_i_3_n_0 ),
        .\Dout_reg[4]_1 (\Dout[6]_i_2_n_0 ),
        .\Dout_reg[7] (\Dout[7]_i_3_n_0 ),
        .\Dout_reg[7]_0 (\Dout[7]_i_4_n_0 ),
        .\Dout_reg[7]_1 (\Dout[7]_i_5_n_0 ),
        .\Dout_reg[7]_2 (\GENERATING_FIFOS.rx_fifo_block_1_n_10 ),
        .\Lcr_reg[1] (rx16550_1_n_12),
        .Q({\Lcr_reg_n_0_[5] ,\Lcr_reg_n_0_[4] ,p_5_in,\Lcr_reg_n_0_[2] ,\Lcr_reg_n_0_[1] ,\Lcr_reg_n_0_[0] }),
        .\Rbr_reg[6]_0 ({Rbr[6:5],Rbr[3:2]}),
        .Rx_error_in_fifo0(\rx_fifo_control_1/Rx_error_in_fifo0 ),
        .SR(\rx_fifo_control_1/character_counter_rst ),
        .SS(SS),
        .baudoutN_int(baudoutN_int),
        .baudoutN_int_i(baudoutN_int_i),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .\character_counter_reg[0] (rx_fifo_empty),
        .character_received(character_received),
        .data(data),
        .data3(data3[7]),
        .\dll_reg[2] (rx16550_1_n_15),
        .\dlm_reg[2] (rx16550_1_n_14),
        .framing_error_flag_reg_0(p_0_in8_in),
        .have_bi_in_fifo_n_i_reg_0(\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .mcr4_d(mcr4_d),
        .out({rx_fifo_data_out[4],rx_fifo_data_out[1]}),
        .rx_fifo_data_in(rx_fifo_data_in),
        .rx_fifo_full(rx_fifo_full),
        .rx_fifo_rd_en_d(rx_fifo_rd_en_d),
        .rx_fifo_wr_en_i(rx_fifo_wr_en_i),
        .rx_sin(rx_sin),
        .s_axi_aclk(s_axi_aclk));
  FDSE rxrdyN_int_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_16 ),
        .Q(rxrdyn),
        .S(bus2ip_reset_int_core));
  LUT5 #(
    .INIT(32'h80000000)) 
    \scr[7]_i_1 
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[1]),
        .I3(L[2]),
        .I4(L[3]),
        .O(scr0));
  FDRE \scr_reg[0] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(\d_d_reg_n_0_[0] ),
        .Q(scr[0]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[1] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(p_2_in[0]),
        .Q(scr[1]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[2] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(p_2_in[1]),
        .Q(scr[2]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[3] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(p_2_in[2]),
        .Q(scr[3]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[4] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(p_3_in),
        .Q(scr[4]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[5] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(\d_d_reg_n_0_[5] ),
        .Q(scr[5]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[6] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(p_2_in[5]),
        .Q(scr[6]),
        .R(bus2ip_reset_int_core));
  FDRE \scr_reg[7] 
       (.C(s_axi_aclk),
        .CE(scr0),
        .D(p_2_in[6]),
        .Q(scr[7]),
        .R(bus2ip_reset_int_core));
  LUT6 #(
    .INIT(64'hFFFFFEFFFFFFFFFF)) 
    thre_iir_set_i_2
       (.I0(\iir_reg_n_0_[2] ),
        .I1(\iir_reg_n_0_[0] ),
        .I2(\iir_reg_n_0_[3] ),
        .I3(readStrobe),
        .I4(\Dout[3]_i_3_n_0 ),
        .I5(\iir_reg_n_0_[1] ),
        .O(thre_iir_set_i_2_n_0));
  LUT3 #(
    .INIT(8'h8A)) 
    thre_iir_set_i_3
       (.I0(lsr5_d),
        .I1(ier1_d),
        .I2(p_0_in56_in),
        .O(thre_iir_set_i_3_n_0));
  FDRE thre_iir_set_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.rx_fifo_block_1_n_9 ),
        .Q(thre_iir_set),
        .R(1'b0));
  arty_ddr_axi_uart16550_0_0_tx16550 tx16550_1
       (.\FSM_sequential_transmit_state_reg[0]_0 (xuart_tx_load_sm_1_n_1),
        .\FSM_sequential_transmit_state_reg[3]_0 (rx16550_1_n_12),
        .Q({\Lcr_reg_n_0_[6] ,\Lcr_reg_n_0_[5] ,\Lcr_reg_n_0_[4] ,p_5_in,\Lcr_reg_n_0_[2] ,\Lcr_reg_n_0_[1] ,\Lcr_reg_n_0_[0] }),
        .Tx_fifo_rd_en_reg_0(tx16550_1_n_2),
        .\addr_i_reg[3] (tx_fifo_empty),
        .baudoutN_int(baudoutN_int),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .freeze(freeze),
        .out(tx_fifo_data_out),
        .rx_sin(rx_sin),
        .s_axi_aclk(s_axi_aclk),
        .sin(sin),
        .sout(sout),
        .sout_0(p_0_in8_in),
        .\tsr_reg[7]_0 (tsr_int),
        .\tsr_reg[7]_1 (\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .tx_empty(tx_empty),
        .tx_fifo_rd_en_int(tx_fifo_rd_en_int));
  FDRE txrdyN_int_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GENERATING_FIFOS.tx_fifo_block_1_n_1 ),
        .Q(txrdyn),
        .R(bus2ip_reset_int_core));
  FDRE wr_d_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Wr),
        .Q(wr_d),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    writing_thr_i_1
       (.I0(wr_d),
        .I1(chipSelect),
        .I2(L[2]),
        .I3(L[3]),
        .I4(L[1]),
        .I5(L[0]),
        .O(Thr0));
  FDRE writing_thr_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Thr0),
        .Q(writing_thr),
        .R(bus2ip_reset_int_core));
  arty_ddr_axi_uart16550_0_0_xuart_tx_load_sm xuart_tx_load_sm_1
       (.Q(tx_fifo_empty),
        .Thre_reg_0(xuart_tx_load_sm_1_n_2),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .chipSelect(chipSelect),
        .freeze(freeze),
        .freeze_0(xuart_tx_load_sm_1_n_1),
        .lsr_reg(lsr_reg),
        .\lsr_reg[5] (xuart_tx_load_sm_1_n_0),
        .\lsr_reg[6] (\lsr_reg[5]_0 ),
        .\lsr_reg[6]_0 (\GENERATING_FIFOS.fcr_reg_n_0_[0] ),
        .\lsr_reg[6]_1 (p_2_in[5]),
        .\lsr_reg[6]_2 (\lsr[7]_i_2_n_0 ),
        .s_axi_aclk(s_axi_aclk),
        .\tsr_int_reg[7]_0 (tsr_int),
        .\tsr_int_reg[7]_1 (Thr),
        .tx_empty(tx_empty),
        .tx_fifo_rd_en_int(tx_fifo_rd_en_int),
        .wr_d(wr_d),
        .writing_thr(writing_thr));
endmodule

(* ORIG_REF_NAME = "xuart" *) 
module arty_ddr_axi_uart16550_0_0_xuart
   (baudoutn,
    \GENERATING_FIFOS.rx_fifo_rst ,
    p_2_in44_in,
    ip2intc_irpt,
    ddis,
    txrdyn,
    rxrdyn,
    wrReq_d1,
    s_axi_awready,
    s_axi_arready,
    rtsn,
    dtrn,
    out1n,
    out2n,
    sout,
    Q,
    s_axi_aclk,
    bus2ip_reset_int_core,
    Wr,
    ctsn,
    dsrn,
    rin,
    dcdn,
    bus2ip_wrce_i,
    bus2ip_rdce_i,
    ce_out_i,
    thre_iir_set_reg,
    freeze,
    sin,
    s_axi_wdata,
    \addr_d_reg[2] ,
    SR);
  output baudoutn;
  output \GENERATING_FIFOS.rx_fifo_rst ;
  output p_2_in44_in;
  output ip2intc_irpt;
  output ddis;
  output txrdyn;
  output rxrdyn;
  output wrReq_d1;
  output s_axi_awready;
  output s_axi_arready;
  output rtsn;
  output dtrn;
  output out1n;
  output out2n;
  output sout;
  output [7:0]Q;
  input s_axi_aclk;
  input bus2ip_reset_int_core;
  input Wr;
  input ctsn;
  input dsrn;
  input rin;
  input dcdn;
  input [0:0]bus2ip_wrce_i;
  input [0:0]bus2ip_rdce_i;
  input [0:0]ce_out_i;
  input thre_iir_set_reg;
  input freeze;
  input sin;
  input [7:0]s_axi_wdata;
  input [2:0]\addr_d_reg[2] ;
  input [0:0]SR;

  wire \GENERATING_FIFOS.rx_fifo_rst ;
  wire [7:0]Q;
  wire Rd;
  wire [0:0]SR;
  wire Wr;
  wire [2:0]\addr_d_reg[2] ;
  wire baudoutn;
  wire [0:0]bus2ip_rdce_i;
  wire bus2ip_reset_int_core;
  wire [0:0]bus2ip_wrce_i;
  wire [0:0]ce_out_i;
  wire ctsn;
  wire dcdn;
  wire ddis;
  wire dsrn;
  wire dtrn;
  wire freeze;
  wire ip2intc_irpt;
  wire out1n;
  wire out2n;
  wire p_2_in44_in;
  wire rin;
  wire rtsn;
  wire rxrdyn;
  wire s_axi_aclk;
  wire s_axi_arready;
  wire s_axi_awready;
  wire [7:0]s_axi_wdata;
  wire sin;
  wire sout;
  wire thre_iir_set_reg;
  wire txrdyn;
  wire wrReq_d1;

  arty_ddr_axi_uart16550_0_0_ipic_if IPIC_IF_I_1
       (.Rd(Rd),
        .bus2ip_rdce_i(bus2ip_rdce_i),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .bus2ip_wrce_i(bus2ip_wrce_i),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_arready(s_axi_arready),
        .s_axi_awready(s_axi_awready),
        .wrReq_d1(wrReq_d1));
  arty_ddr_axi_uart16550_0_0_uart16550 UART16550_I_1
       (.Q(Q),
        .Rd(Rd),
        .SR(SR),
        .SS(\GENERATING_FIFOS.rx_fifo_rst ),
        .Wr(Wr),
        .\addr_d_reg[2]_0 (\addr_d_reg[2] ),
        .baudoutn(baudoutn),
        .bus2ip_reset_int_core(bus2ip_reset_int_core),
        .ce_out_i(ce_out_i),
        .ctsn(ctsn),
        .dcdn(dcdn),
        .ddis(ddis),
        .dsrn(dsrn),
        .dtrn(dtrn),
        .freeze(freeze),
        .ip2intc_irpt(ip2intc_irpt),
        .\lsr_reg[5]_0 (p_2_in44_in),
        .out1n(out1n),
        .out2n(out2n),
        .rin(rin),
        .rtsn(rtsn),
        .rxrdyn(rxrdyn),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_wdata(s_axi_wdata),
        .sin(sin),
        .sout(sout),
        .thre_iir_set_reg_0(thre_iir_set_reg),
        .txrdyn(txrdyn));
endmodule

(* ORIG_REF_NAME = "xuart_tx_load_sm" *) 
module arty_ddr_axi_uart16550_0_0_xuart_tx_load_sm
   (\lsr_reg[5] ,
    freeze_0,
    Thre_reg_0,
    \tsr_int_reg[7]_0 ,
    bus2ip_reset_int_core,
    s_axi_aclk,
    \lsr_reg[6] ,
    \lsr_reg[6]_0 ,
    tx_fifo_rd_en_int,
    freeze,
    tx_empty,
    writing_thr,
    Q,
    \lsr_reg[6]_1 ,
    \lsr_reg[6]_2 ,
    chipSelect,
    wr_d,
    lsr_reg,
    \tsr_int_reg[7]_1 );
  output \lsr_reg[5] ;
  output freeze_0;
  output Thre_reg_0;
  output [7:0]\tsr_int_reg[7]_0 ;
  input bus2ip_reset_int_core;
  input s_axi_aclk;
  input \lsr_reg[6] ;
  input \lsr_reg[6]_0 ;
  input tx_fifo_rd_en_int;
  input freeze;
  input tx_empty;
  input writing_thr;
  input [0:0]Q;
  input [0:0]\lsr_reg[6]_1 ;
  input \lsr_reg[6]_2 ;
  input chipSelect;
  input wr_d;
  input lsr_reg;
  input [7:0]\tsr_int_reg[7]_1 ;

  wire [0:0]Q;
  wire Thre;
  wire Thre_reg_0;
  wire Tsre;
  wire bus2ip_reset_int_core;
  wire chipSelect;
  wire [1:0]current_state;
  wire freeze;
  wire freeze_0;
  wire \lsr[6]_i_2_n_0 ;
  wire lsr_reg;
  wire lsr_reg022_out;
  wire \lsr_reg[5] ;
  wire \lsr_reg[6] ;
  wire \lsr_reg[6]_0 ;
  wire [0:0]\lsr_reg[6]_1 ;
  wire \lsr_reg[6]_2 ;
  wire [1:0]next_state;
  wire s_axi_aclk;
  wire thre_com;
  wire [0:0]tsr_com;
  wire [7:0]\tsr_int_reg[7]_0 ;
  wire [7:0]\tsr_int_reg[7]_1 ;
  wire tsre_com;
  wire tx_empty;
  wire tx_fifo_rd_en_int;
  wire wr_d;
  wire writing_thr;

  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \FSM_sequential_current_state[0]_i_1 
       (.I0(current_state[1]),
        .I1(current_state[0]),
        .I2(writing_thr),
        .O(next_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'h72)) 
    \FSM_sequential_current_state[1]_i_1 
       (.I0(current_state[1]),
        .I1(tx_fifo_rd_en_int),
        .I2(current_state[0]),
        .O(next_state[1]));
  (* FSM_ENCODED_STATES = "full_empty:10,empty_empty:00,full_full:11,empty_full:01" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_current_state_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(next_state[0]),
        .Q(current_state[0]),
        .R(bus2ip_reset_int_core));
  (* FSM_ENCODED_STATES = "full_empty:10,empty_empty:00,full_full:11,empty_full:01" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_current_state_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(next_state[1]),
        .Q(current_state[1]),
        .R(bus2ip_reset_int_core));
  LUT4 #(
    .INIT(16'h0415)) 
    \FSM_sequential_transmit_state[0]_i_3 
       (.I0(freeze),
        .I1(\lsr_reg[6]_0 ),
        .I2(\lsr_reg[6] ),
        .I3(Tsre),
        .O(freeze_0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'h1D)) 
    Thre_i_1
       (.I0(writing_thr),
        .I1(current_state[0]),
        .I2(current_state[1]),
        .O(thre_com));
  FDSE Thre_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(thre_com),
        .Q(Thre),
        .S(bus2ip_reset_int_core));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'hC5)) 
    Tsre_i_1
       (.I0(current_state[0]),
        .I1(tx_fifo_rd_en_int),
        .I2(current_state[1]),
        .O(tsre_com));
  FDSE Tsre_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(tsre_com),
        .Q(Tsre),
        .S(bus2ip_reset_int_core));
  LUT3 #(
    .INIT(8'hE2)) 
    \lsr[5]_i_1 
       (.I0(Thre),
        .I1(\lsr_reg[6]_0 ),
        .I2(Q),
        .O(Thre_reg_0));
  LUT6 #(
    .INIT(64'h0080000088808800)) 
    \lsr[6]_i_1 
       (.I0(\lsr[6]_i_2_n_0 ),
        .I1(\lsr_reg[6] ),
        .I2(Thre),
        .I3(\lsr_reg[6]_0 ),
        .I4(Tsre),
        .I5(tx_fifo_rd_en_int),
        .O(\lsr_reg[5] ));
  LUT6 #(
    .INIT(64'hFFFFEFFFFFFF2000)) 
    \lsr[6]_i_2 
       (.I0(\lsr_reg[6]_1 ),
        .I1(\lsr_reg[6]_2 ),
        .I2(chipSelect),
        .I3(wr_d),
        .I4(lsr_reg022_out),
        .I5(lsr_reg),
        .O(\lsr[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFF0008888)) 
    \lsr[6]_i_3 
       (.I0(Tsre),
        .I1(Thre),
        .I2(tx_empty),
        .I3(\lsr_reg[6] ),
        .I4(\lsr_reg[6]_0 ),
        .I5(bus2ip_reset_int_core),
        .O(lsr_reg022_out));
  LUT3 #(
    .INIT(8'h54)) 
    \tsr_int[7]_i_1 
       (.I0(current_state[1]),
        .I1(current_state[0]),
        .I2(writing_thr),
        .O(tsr_com));
  FDSE \tsr_int_reg[0] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [0]),
        .Q(\tsr_int_reg[7]_0 [0]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[1] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [1]),
        .Q(\tsr_int_reg[7]_0 [1]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[2] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [2]),
        .Q(\tsr_int_reg[7]_0 [2]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [3]),
        .Q(\tsr_int_reg[7]_0 [3]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[4] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [4]),
        .Q(\tsr_int_reg[7]_0 [4]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[5] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [5]),
        .Q(\tsr_int_reg[7]_0 [5]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[6] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [6]),
        .Q(\tsr_int_reg[7]_0 [6]),
        .S(bus2ip_reset_int_core));
  FDSE \tsr_int_reg[7] 
       (.C(s_axi_aclk),
        .CE(tsr_com),
        .D(\tsr_int_reg[7]_1 [7]),
        .Q(\tsr_int_reg[7]_0 [7]),
        .S(bus2ip_reset_int_core));
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
