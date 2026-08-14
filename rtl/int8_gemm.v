// int8_gemm.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// INT8 binary-multiplier GEMM baseline — COLS parallel int8_dot units.
// Same interface as ternary_gemm but int8 weights (8 bits/col) and real
// multiplies. Used to compare LUT/DSP/Fmax against the ternary array on
// the same Artix-7 part.
`timescale 1ns / 1ps

module int8_gemm #(
    parameter DATA_WIDTH   = 8,
    parameter WEIGHT_WIDTH = 8,
    parameter ACC_WIDTH    = 32,
    parameter COLS         = 64,
    parameter DEPTH        = 768
)(
    input  wire                          clk,
    input  wire                          rst_n,
    input  wire                          valid_in,
    input  wire signed [DATA_WIDTH-1:0]  activation,
    input  wire [WEIGHT_WIDTH*COLS-1:0]  weight,      // int8 per column
    output wire [ACC_WIDTH*COLS-1:0]     acc_out,
    output wire                          valid_out
);
    wire [COLS-1:0] col_valids;
    assign valid_out = col_valids[0];

    genvar i;
    generate
        for (i = 0; i < COLS; i = i + 1) begin : dot_gen
            int8_dot #(.DATA_WIDTH(DATA_WIDTH), .WEIGHT_WIDTH(WEIGHT_WIDTH),
                       .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(DEPTH)) dot_i (
                .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
                .activation(activation),
                .weight($signed(weight[WEIGHT_WIDTH*i +: WEIGHT_WIDTH])),
                .acc_out(acc_out[ACC_WIDTH*i +: ACC_WIDTH]),
                .valid_out(col_valids[i]));
        end
    endgenerate
endmodule
