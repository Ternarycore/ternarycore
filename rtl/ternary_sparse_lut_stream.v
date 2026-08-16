// SPDX-License-Identifier: CERN-OHL-S-2.0
// Streaming connection between the 2:4 selector and compact ternary LUT.

`timescale 1ns / 1ps

module ternary_sparse_lut_stream #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input wire clk,
    input wire rst_n,
    input wire activation_valid,
    input wire signed [DATA_WIDTH-1:0] x0,
    input wire signed [DATA_WIDTH-1:0] x1,
    input wire signed [DATA_WIDTH-1:0] x2,
    input wire signed [DATA_WIDTH-1:0] x3,
    input wire weight_valid,
    input wire [7:0] packed_weights,
    output wire busy,
    output wire ready,
    output wire [3:0] keep_mask,
    output wire [1:0] keep_count,
    output wire signed [DATA_WIDTH-1:0] kept_value0,
    output wire signed [DATA_WIDTH-1:0] kept_value1,
    output wire result_valid,
    output wire error_out,
    output wire signed [ACC_WIDTH-1:0] result
);
    wire sparse_valid;
    wire [3:0] sparse_mask;
    wire [1:0] sparse_count;
    wire signed [DATA_WIDTH-1:0] sparse_value0, sparse_value1;
    wire signed [DATA_WIDTH-1:0] pending_x0, pending_x1, pending_x2, pending_x3;
    reg signed [DATA_WIDTH-1:0] x0_q, x1_q, x2_q, x3_q;
    reg load_valid;

    activation_sparse24 #(.DATA_WIDTH(DATA_WIDTH)) sparse_i (
        .clk(clk), .rst_n(rst_n), .valid_in(activation_valid),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .valid_out(sparse_valid), .keep_mask(sparse_mask),
        .keep_count(sparse_count), .value0(sparse_value0), .value1(sparse_value1));

    assign keep_mask = sparse_mask;
    assign keep_count = sparse_count;
    assign kept_value0 = sparse_value0;
    assign kept_value1 = sparse_value1;
    assign pending_x0 = x0_q;
    assign pending_x1 = x1_q;
    assign pending_x2 = x2_q;
    assign pending_x3 = x3_q;

    ternary_lut24_bram #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) lut_i (
        .clk(clk), .rst_n(rst_n), .load_valid(load_valid),
        .keep_mask(sparse_mask), .x0(pending_x0), .x1(pending_x1),
        .x2(pending_x2), .x3(pending_x3),
        .query_valid(weight_valid), .packed_weights(packed_weights),
        .busy(busy), .ready(ready), .result_valid(result_valid),
        .error_out(error_out), .result(result));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x0_q <= 0; x1_q <= 0; x2_q <= 0; x3_q <= 0;
            load_valid <= 0;
        end else begin
            load_valid <= sparse_valid;
            if (activation_valid) begin
                x0_q <= x0; x1_q <= x1; x2_q <= x2; x3_q <= x3;
            end
        end
    end
endmodule
