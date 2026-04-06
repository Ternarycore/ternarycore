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
// Ternary matrix-multiply: C = A * W (ROWS × COLS output).
//
// Architecture: COLS parallel ternary_dot units, each DEPTH elements deep.
// Each clock cycle, one activation element is broadcast to all COLS dots,
// paired with COLS different weight encodings (one per output column).
// After DEPTH valid_in cycles, one full output row is ready (valid_out high).
// Feed ROWS groups of DEPTH activations to produce the full output matrix.
//
// Interface:
//   activation   — one element of the current row of A per cycle
//   weight_enc   — 2*COLS bits: {w[COLS-1],...,w[1],w[0]}, 2 bits each
//   acc_out      — ACC_WIDTH*COLS bits: {out[COLS-1],...,out[1],out[0]}
//   valid_out    — high for one cycle when one output row is ready

`timescale 1ns / 1ps

module ternary_gemm #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter ROWS       = 4,    // number of output rows (= rows of A)
    parameter COLS       = 4,    // number of output cols (= cols of W)
    parameter DEPTH      = 4     // inner dimension (= cols of A = rows of W)
) (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire                      valid_in,
    input  wire [DATA_WIDTH-1:0]     activation,
    input  wire [2*COLS-1:0]         weight_enc,        // 2 bits per column
    output wire [ACC_WIDTH*COLS-1:0] acc_out,           // packed output row
    output wire                      valid_out
);

    wire [COLS-1:0] valid_col;

    // Instantiate one ternary_dot per output column
    genvar i;
    generate
        for (i = 0; i < COLS; i = i + 1) begin : dot_col
            ternary_dot #(
                .DATA_WIDTH(DATA_WIDTH),
                .ACC_WIDTH(ACC_WIDTH),
                .VECTOR_LEN(DEPTH)
            ) u_dot (
                .clk       (clk),
                .rst_n     (rst_n),
                .valid_in  (valid_in),
                .activation(activation),
                .weight_enc(weight_enc[2*i+1 : 2*i]),
                .acc_out   (acc_out[ACC_WIDTH*(i+1)-1 : ACC_WIDTH*i]),
                .valid_out (valid_col[i])
            );
        end
    endgenerate

    // All columns complete in lock-step; use column 0 as the shared valid flag
    assign valid_out = valid_col[0];

endmodule
