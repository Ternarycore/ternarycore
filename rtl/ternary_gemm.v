// ternary_gemm.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// This source describes Hardware and is licensed under the CERN-OHL-S v2.
// You may redistribute and modify this source and make products using it
// under the terms of the CERN-OHL-S v2 (https://ohwr.org/cern_ohl_s_v2.txt).
//
// Ternary matrix-multiply: C = A * W  (ROWS x COLS output, inner dim DEPTH).
//
// Architecture: COLS parallel ternary_dot units, each DEPTH elements deep.
// Each clock cycle, one activation element is broadcast to all COLS dots,
// each receiving its own 2-bit weight encoding from the packed weight_enc bus.
// After DEPTH valid_in cycles, one full output row is ready (valid_out high).
// Feed ROWS groups of DEPTH activations to produce the complete output matrix.
//
// This implementation explicitly instantiates COLS=4 dot units with literal
// bit selects for maximum portability across Icarus Verilog versions.
//
// Interface:
//   activation  — one element of the current row of A per cycle (int8)
//   weight_enc  — 2*COLS bits packed: {w[3],w[2],w[1],w[0]}, 2 bits each
//                 encoding: 00=zero, 01=+1, 10=-1
//   acc_out     — ACC_WIDTH*COLS bits packed: {out[3],out[2],out[1],out[0]}
//   valid_out   — high for one cycle when one output row is ready

`timescale 1ns / 1ps

module ternary_gemm #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter ROWS       = 4,
    parameter COLS       = 4,
    parameter DEPTH      = 4
) (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire                      valid_in,
    input  wire [DATA_WIDTH-1:0]     activation,
    input  wire [2*COLS-1:0]         weight_enc,
    output wire [ACC_WIDTH*COLS-1:0] acc_out,
    output wire                      valid_out
);

    wire valid_col0, valid_col1, valid_col2, valid_col3;

    // Column 0 — weight_enc[1:0], result in acc_out[31:0]
    ternary_dot #(
        .DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(DEPTH)
    ) u_dot0 (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation),
        .weight_enc(weight_enc[1:0]),
        .acc_out(acc_out[ACC_WIDTH*1-1:ACC_WIDTH*0]),
        .valid_out(valid_col0)
    );

    // Column 1 — weight_enc[3:2], result in acc_out[63:32]
    ternary_dot #(
        .DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(DEPTH)
    ) u_dot1 (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation),
        .weight_enc(weight_enc[3:2]),
        .acc_out(acc_out[ACC_WIDTH*2-1:ACC_WIDTH*1]),
        .valid_out(valid_col1)
    );

    // Column 2 — weight_enc[5:4], result in acc_out[95:64]
    ternary_dot #(
        .DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(DEPTH)
    ) u_dot2 (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation),
        .weight_enc(weight_enc[5:4]),
        .acc_out(acc_out[ACC_WIDTH*3-1:ACC_WIDTH*2]),
        .valid_out(valid_col2)
    );

    // Column 3 — weight_enc[7:6], result in acc_out[127:96]
    ternary_dot #(
        .DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(DEPTH)
    ) u_dot3 (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation),
        .weight_enc(weight_enc[7:6]),
        .acc_out(acc_out[ACC_WIDTH*4-1:ACC_WIDTH*3]),
        .valid_out(valid_col3)
    );

    // All columns complete in lock-step; col0 is the shared valid flag
    assign valid_out = valid_col0;

endmodule
