// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet full inference pipeline: activation_quant → GEMM → scale.
`timescale 1ns / 1ps

module ternary_pipeline #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 4,
    parameter COLS       = 4,
    parameter PRECISION  = 15,
    parameter INV_WIDTH  = PRECISION + DATA_WIDTH - 1
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         valid_in,
    input  wire signed [DATA_WIDTH-1:0] activation,
    input  wire [INV_WIDTH-1:0]         inv,
    input  wire [COLS*(PRECISION+1)-1:0] alpha,
    input  wire [2*COLS-1:0]            weight_enc,
    output wire [COLS*ACC_WIDTH-1:0]    result,
    output wire                         valid_out
);

    wire [DATA_WIDTH-1:0] q;
    wire                  q_valid;

    activation_quant #(
        .DATA_WIDTH(DATA_WIDTH), .Q_WIDTH(DATA_WIDTH),
        .PRECISION(PRECISION), .INV_WIDTH(INV_WIDTH)
    ) quant (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in), .x(activation), .inv(inv),
        .q(q), .valid_out(q_valid)
    );

    wire [COLS*ACC_WIDTH-1:0] gemm_result;
    wire                      gemm_valid;
    reg                       gemm_valid_d1;
    reg                       gemm_valid_d2;
    // weight_enc must be delayed by exactly the activation_quant latency
    // (2 register stages: product, then q) so that element i of a row pairs
    // with weight i (q[i] * w[i]), not q[i] * w[i+1]. The delay registers
    // shift unconditionally every cycle, mirroring the quantizer's internal
    // pipeline, so alignment survives bubbles and the post-vector drain.
    reg [2*COLS-1:0]          weight_enc_d1;
    reg [2*COLS-1:0]          weight_enc_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            weight_enc_d1 <= 0;
            weight_enc_d2 <= 0;
        end else begin
            weight_enc_d1 <= weight_enc;
            weight_enc_d2 <= weight_enc_d1;
        end
    end

    ternary_gemm #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH),
                   .DEPTH(VECTOR_LEN), .COLS(COLS)) gemm (
        .clk(clk), .rst_n(rst_n),
        .valid_in(q_valid), .activation(q), .weight_enc(weight_enc_d2),
        .acc_out(gemm_result), .valid_out(gemm_valid)
    );

    // The shipped GEMM contract raises valid_out before acc_out is registered
    // and may hold it high until the next vector starts. Delay the level long
    // enough for acc_out to settle, then convert its rising edge to one pulse
    // so the scale stage consumes each completed vector exactly once.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gemm_valid_d1 <= 1'b0;
            gemm_valid_d2 <= 1'b0;
        end else begin
            gemm_valid_d1 <= gemm_valid;
            gemm_valid_d2 <= gemm_valid_d1;
        end
    end

    wire scale_valid = gemm_valid_d1 && !gemm_valid_d2;

    // inv is sampled with each valid activation. alpha is sampled when a
    // completed vector enters the scale stage; software must keep both values
    // stable for the transactions to which they apply.
    ternary_scale #(.ACC_WIDTH(ACC_WIDTH), .COLS(COLS), .PRECISION(PRECISION)) scale (
        .clk(clk), .rst_n(rst_n),
        .valid_in(scale_valid),
        .acc_in(gemm_result), .alpha(alpha),
        .result(result), .valid_out(valid_out)
    );
endmodule
