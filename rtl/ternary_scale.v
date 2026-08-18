// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet b1.58 per-channel scale multiplier.
`timescale 1ns / 1ps

module ternary_scale #(
    parameter ACC_WIDTH  = 32,
    parameter COLS       = 4,
    parameter PRECISION  = 15
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         valid_in,
    input  wire  [COLS*ACC_WIDTH-1:0]   acc_in,
    input  wire  [COLS*(PRECISION+1)-1:0]   alpha,
    output reg   [COLS*ACC_WIDTH-1:0]   result,
    output reg                          valid_out
);

    // 48-bit product (32-bit acc * unsigned Q15 alpha). Kept UNSIGNED on
    // purpose: scale_ch shifts with >>>, and for a 48-bit operand the low
    // 32-bit slice of an arithmetic vs logical shift is identical, matching
    // the SW reference (hw_scale in tools/export_ternary.py). Declaring the
    // operands signed would be cosmetic here and makes the k-induction proof
    // in formal/ternary_scale_prove.sby intractable.
    reg [ACC_WIDTH+PRECISION:0] prod [0:COLS-1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < COLS; i = i + 1) prod[i] <= 0;
        end else if (valid_in) begin
            for (i = 0; i < COLS; i = i + 1)
                // Extend both operands to the product width before the
                // multiply; otherwise Verilog may size the expression to
                // the narrower operand and truncate large products.
                prod[i] <= $signed({{(PRECISION+1){acc_in[i*ACC_WIDTH + ACC_WIDTH - 1]}}, acc_in[i*ACC_WIDTH +: ACC_WIDTH]}) *
                           $signed({{ACC_WIDTH{1'b0}}, alpha[i*(PRECISION+1) +: PRECISION+1]});
        end
    end

    reg valid_d1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin valid_d1 <= 0; valid_out <= 0; end
        else begin valid_d1 <= valid_in; valid_out <= valid_d1; end
    end

    /* verilator lint_off UNUSEDSIGNAL */
    function [ACC_WIDTH-1:0] scale_ch;
        input [ACC_WIDTH+PRECISION:0] p;
        reg [PRECISION-1:0] trunc;
        reg round;
        reg signed [ACC_WIDTH+PRECISION:0] shifted;
        begin
            // Truncated bits are only the fractional part [PRECISION-1:0].
            // p[PRECISION] is the integer LSB and must NOT participate in the
            // round decision, otherwise exact products (e.g. 6237<<15, whose
            // fractional part is zero) spuriously round up by one.
            trunc   = p[PRECISION-1:0];
            round   = |trunc;
            shifted = p >>> PRECISION;
            scale_ch = shifted[ACC_WIDTH-1:0] + round;
        end
    endfunction
    /* verilator lint_on UNUSEDSIGNAL */

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) result <= 0;
        else if (valid_d1) begin
            for (i = 0; i < COLS; i = i + 1)
                result[i*ACC_WIDTH +: ACC_WIDTH] <= scale_ch(prod[i]);
        end
    end
endmodule
