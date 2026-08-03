// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
// DO NOT MODIFY THIS FILE.

// MODULE VLNV: amd.com:blockdesign:arty_ddr:1.0

`timescale 1ps / 1ps

`include "vivado_interfaces.svh"

module arty_ddr_sv (
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [15:0] DDR3_0_dq,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] DDR3_0_dqs_p,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] DDR3_0_dqs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [13:0] DDR3_0_addr,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [2:0] DDR3_0_ba,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire DDR3_0_ras_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire DDR3_0_cas_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire DDR3_0_we_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire DDR3_0_reset_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] DDR3_0_ck_p,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] DDR3_0_ck_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] DDR3_0_cke,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] DDR3_0_cs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [1:0] DDR3_0_dm,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] DDR3_0_odt,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire eth_mdio_mdc,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_mdio_mdio_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire eth_mdio_mdio_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire eth_mdio_mdio_t,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_baudoutn,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire UART_0_ctsn,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire UART_0_dcdn,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_ddis,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire UART_0_dsrn,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_dtrn,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_out1n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_out2n,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire UART_0_ri,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_rtsn,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire UART_0_rxd,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_rxrdyn,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_txd,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire UART_0_txrdyn,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire sys_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire sys_rst_n,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_tx_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_rx_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_crs,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_col,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_rx_dv,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [3:0] eth_rxd,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire eth_rxerr,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire eth_tx_en,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0] eth_txd,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire eth_rstn,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire eth_ref_clk,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0] gpio_io_o_0
);

  arty_ddr inst (
    .DDR3_0_dq(DDR3_0_dq),
    .DDR3_0_dqs_p(DDR3_0_dqs_p),
    .DDR3_0_dqs_n(DDR3_0_dqs_n),
    .DDR3_0_addr(DDR3_0_addr),
    .DDR3_0_ba(DDR3_0_ba),
    .DDR3_0_ras_n(DDR3_0_ras_n),
    .DDR3_0_cas_n(DDR3_0_cas_n),
    .DDR3_0_we_n(DDR3_0_we_n),
    .DDR3_0_reset_n(DDR3_0_reset_n),
    .DDR3_0_ck_p(DDR3_0_ck_p),
    .DDR3_0_ck_n(DDR3_0_ck_n),
    .DDR3_0_cke(DDR3_0_cke),
    .DDR3_0_cs_n(DDR3_0_cs_n),
    .DDR3_0_dm(DDR3_0_dm),
    .DDR3_0_odt(DDR3_0_odt),
    .eth_mdio_mdc(eth_mdio_mdc),
    .eth_mdio_mdio_i(eth_mdio_mdio_i),
    .eth_mdio_mdio_o(eth_mdio_mdio_o),
    .eth_mdio_mdio_t(eth_mdio_mdio_t),
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
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .eth_tx_clk(eth_tx_clk),
    .eth_rx_clk(eth_rx_clk),
    .eth_crs(eth_crs),
    .eth_col(eth_col),
    .eth_rx_dv(eth_rx_dv),
    .eth_rxd(eth_rxd),
    .eth_rxerr(eth_rxerr),
    .eth_tx_en(eth_tx_en),
    .eth_txd(eth_txd),
    .eth_rstn(eth_rstn),
    .eth_ref_clk(eth_ref_clk),
    .gpio_io_o_0(gpio_io_o_0)
  );

endmodule
