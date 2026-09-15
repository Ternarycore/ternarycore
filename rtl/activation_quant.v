// SPDX-License-Identifier: CERN-OHL-S-2.0
// Fixed-point activation quantizer supporting signed INT8 and INT4 output.

`timescale 1ns / 1ps

module activation_quant #(
    parameter DATA_WIDTH = 8,
    parameter Q_WIDTH    = 8,
    parameter PRECISION  = 15,
    parameter INV_WIDTH  = PRECISION + Q_WIDTH
)(
    input wire                         clk,
    input wire                         rst_n,
    input wire                         valid_in,
    input wire signed [DATA_WIDTH-1:0] x,
    input wire [INV_WIDTH-1:0]         inv,
    output reg signed [Q_WIDTH-1:0]    q,
    output reg                         valid_out
);
    localparam Q_MAX = (1 << (Q_WIDTH - 1)) - 1;
    localparam Q_MIN = -(1 << (Q_WIDTH - 1)) + 1;
    reg signed [DATA_WIDTH+INV_WIDTH-1:0] product;
    reg product_valid;
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] round_amt = 1 << (PRECISION - 1);
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] biased = product + round_amt;
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] shifted = biased >>> PRECISION;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 0;
            product_valid <= 1'b0;
        end else begin
            product_valid <= valid_in;
            if (valid_in)
                product <= x * $signed({1'b0, inv});
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= product_valid;
            if (product_valid)
                q <= (shifted > Q_MAX) ? Q_MAX :
                     (shifted < Q_MIN) ? Q_MIN : shifted[Q_WIDTH-1:0];
        end
    end
endmodule
