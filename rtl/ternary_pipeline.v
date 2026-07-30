// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet full inference pipeline: activation_quant → GEMM → scale.
`timescale 1ns / 1ps

module ternary_pipeline #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 4,
    parameter COLS       = 4,
    parameter PRECISION  = 15,
    parameter INV_WIDTH  = 22
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         valid_in,
    input  wire signed [DATA_WIDTH-1:0] activation,
    input  wire [INV_WIDTH-1:0]         inv,
    input  wire [COLS*(PRECISION+1)-1:0] alpha,
    input  wire [2*COLS-1:0]            weight_enc,
    output reg  [COLS*ACC_WIDTH-1:0]    result,
    output reg                          valid_out
);

    wire [DATA_WIDTH-1:0] q;
    wire                  q_valid;

    activation_quant #(.DATA_WIDTH(DATA_WIDTH), .PRECISION(15), .INV_WIDTH(INV_WIDTH)) quant (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in), .x(activation), .inv(inv),
        .q(q), .valid_out(q_valid)
    );

    wire [COLS*ACC_WIDTH-1:0] gemm_result;
    wire                      gemm_valid;
    reg [2*COLS-1:0]          weight_enc_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) weight_enc_d1 <= 0;
        else if (valid_in) weight_enc_d1 <= weight_enc;
    end

    ternary_gemm #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH),
                   .DEPTH(VECTOR_LEN), .COLS(COLS)) gemm (
        .clk(clk), .rst_n(rst_n),
        .valid_in(q_valid), .activation($signed(q)), .weight_enc(weight_enc_d1),
        .acc_out(gemm_result), .valid_out(gemm_valid)
    );

    ternary_scale #(.ACC_WIDTH(ACC_WIDTH), .COLS(COLS), .PRECISION(PRECISION)) scale (
        .clk(clk), .rst_n(rst_n),
        .valid_in(gemm_valid),
        .acc_in(gemm_result), .alpha(alpha),
        .result(result), .valid_out(valid_out)
    );
endmodule
