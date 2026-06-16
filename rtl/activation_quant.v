// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet b1.58 activation quantizer.
// q = RoundClip(x * 127 / absmax, -127, 127)
// Uses precomputed inv = round(2^PRECISION * 127 / absmax).
//
// Pipeline:
//   Stage 1: product = x * inv (when valid_in)
//   Stage 2: q = clip(product >> PRECISION), valid_out fires here
//
// valid_out aligns with q: both are valid at stage 2 output.
// M consecutive valid_in cycles produce M consecutive valid_out cycles.

`timescale 1ns / 1ps

module activation_quant #(
    parameter DATA_WIDTH = 8,
    parameter PRECISION  = 15,
    parameter INV_WIDTH  = 22
)(
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire                       valid_in,
    input  wire signed [DATA_WIDTH-1:0] x,
    input  wire [INV_WIDTH-1:0]       inv,
    output reg  signed [DATA_WIDTH-1:0] q,
    output reg                      valid_out
);

    // Stage 1: sample input product, track whether product is valid
    reg signed [DATA_WIDTH+INV_WIDTH-1:0] product;
    reg                                  product_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product       <= 0;
            product_valid <= 0;
        end else begin
            product_valid <= valid_in;
            if (valid_in)
                product <= x * $signed({1'b0, inv});
        end
    end

    // Stage 2: shift, round, clip — valid_out fires 1 cycle after valid_in
    wire [PRECISION-1:0] trunc_bits = product[PRECISION-1:0];
    wire                 round_bit  = |trunc_bits;
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] shifted = product >>> PRECISION;
    wire signed [DATA_WIDTH+INV_WIDTH-PRECISION:0] unclipped = shifted + round_bit;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q          <= 0;
            valid_out  <= 0;
        end else begin
            valid_out  <= product_valid;
            if (product_valid)
                q <= (unclipped > 127) ? 127 :
                     (unclipped < -127) ? -127 : unclipped;
        end
    end

endmodule