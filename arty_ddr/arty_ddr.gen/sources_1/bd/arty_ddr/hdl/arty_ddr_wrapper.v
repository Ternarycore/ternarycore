//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Sun Aug  2 11:16:16 2026
//Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
//Command     : generate_target arty_ddr_wrapper.bd
//Design      : arty_ddr_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module arty_ddr_wrapper
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
    gpio_io_o_0,
    sys_clk,
    sys_rst_n);
  output [13:0]DDR3_0_addr;
  output [2:0]DDR3_0_ba;
  output DDR3_0_cas_n;
  output [0:0]DDR3_0_ck_n;
  output [0:0]DDR3_0_ck_p;
  output [0:0]DDR3_0_cke;
  output [0:0]DDR3_0_cs_n;
  output [1:0]DDR3_0_dm;
  inout [15:0]DDR3_0_dq;
  inout [1:0]DDR3_0_dqs_n;
  inout [1:0]DDR3_0_dqs_p;
  output [0:0]DDR3_0_odt;
  output DDR3_0_ras_n;
  output DDR3_0_reset_n;
  output DDR3_0_we_n;
  output UART_0_baudoutn;
  input UART_0_ctsn;
  input UART_0_dcdn;
  output UART_0_ddis;
  input UART_0_dsrn;
  output UART_0_dtrn;
  output UART_0_out1n;
  output UART_0_out2n;
  input UART_0_ri;
  output UART_0_rtsn;
  input UART_0_rxd;
  output UART_0_rxrdyn;
  output UART_0_txd;
  output UART_0_txrdyn;
  output [3:0]gpio_io_o_0;
  input sys_clk;
  input sys_rst_n;

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
  wire [3:0]gpio_io_o_0;
  wire sys_clk;
  wire sys_rst_n;

  arty_ddr arty_ddr_i
       (.DDR3_0_addr(DDR3_0_addr),
        .DDR3_0_ba(DDR3_0_ba),
        .DDR3_0_cas_n(DDR3_0_cas_n),
        .DDR3_0_ck_n(DDR3_0_ck_n),
        .DDR3_0_ck_p(DDR3_0_ck_p),
        .DDR3_0_cke(DDR3_0_cke),
        .DDR3_0_cs_n(DDR3_0_cs_n),
        .DDR3_0_dm(DDR3_0_dm),
        .DDR3_0_dq(DDR3_0_dq),
        .DDR3_0_dqs_n(DDR3_0_dqs_n),
        .DDR3_0_dqs_p(DDR3_0_dqs_p),
        .DDR3_0_odt(DDR3_0_odt),
        .DDR3_0_ras_n(DDR3_0_ras_n),
        .DDR3_0_reset_n(DDR3_0_reset_n),
        .DDR3_0_we_n(DDR3_0_we_n),
        .UART_0_baudoutn(UART_0_baudoutn),
        .UART_0_ctsn(UART_0_ctsn),
        .UART_0_dcdn(UART_0_dcdn),
        .UART_0_ddis(UART_0_ddis),
        .UART_0_dsrn(UART_0_dsrn),
        .UART_0_dtrn(UART_0_dtrn),
        .UART_0_out1n(UART_0_out1n),
        .UART_0_out2n(UART_0_out2n),
        .UART_0_ri(UART_0_ri),
        .UART_0_rtsn(UART_0_rtsn),
        .UART_0_rxd(UART_0_rxd),
        .UART_0_rxrdyn(UART_0_rxrdyn),
        .UART_0_txd(UART_0_txd),
        .UART_0_txrdyn(UART_0_txrdyn),
        .gpio_io_o_0(gpio_io_o_0),
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n));
endmodule
