// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet b1.58 activation quantizer.
//
// Implements absmax quantization:
//   q = RoundClip(x * 127 / absmax, -127, 127)
//
// In hardware: inv = round(2^PRECISION * 127 / absmax)
//              q   = round(clip(x * inv >> PRECISION, -127, 127))
//
// absmax is per-tensor (from the input's absmax). 2^PRECISION / absmax
// is precomputed in software and multiplied by 127 to save a hardware
// multiply.  Precision: 15+7 = 22 bits for inv, 30 bits for product.

`timescale 1ns / 1ps

module activation_quant #(
    parameter DATA_WIDTH = 8,
    parameter PRECISION  = 15,   // reciprocal fixed-point shift
    parameter INV_WIDTH  = 22    // enough for 2^15 * 127 / 1 = 4,161,536
)(
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire                       valid_in,
    input  wire signed [DATA_WIDTH-1:0] x,          // raw activation
    input  wire [INV_WIDTH-1:0]       inv,          // round(2^PRECISION * 127 / absmax)
    output reg  signed [DATA_WIDTH-1:0] q,          // quantized activation [-127,127]
    output reg                      valid_out
);

    // Stage 1: multiply x * inv
    reg signed [DATA_WIDTH+INV_WIDTH-1:0] product;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product   <= 0;
            valid_out <= 0;
        end else begin
            product   <= x * $signed({1'b0, inv});
            valid_out <= valid_in;
        end
    end

    // Stage 2: shift right by PRECISION, round, clip to [-127, 127]
    wire [PRECISION-1:0] trunc_bits = product[PRECISION-1:0];
    wire                 round_bit  = |trunc_bits;
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] shifted = product >>> PRECISION;
    wire signed [DATA_WIDTH+INV_WIDTH-PRECISION:0] unclipped = shifted + round_bit;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 0;
        end else if (valid_out) begin
            if (unclipped > 127)
                q <= 127;
            else if (unclipped < -127)
                q <= -127;
            else
                q <= unclipped;
        end
    end

endmodule