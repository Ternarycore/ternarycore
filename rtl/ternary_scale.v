// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet b1.58 per-channel scale multiplier.
//
// Post-MAC: y = round(acc * alpha >> PRECISION)
// where alpha is the learned per-channel scale (fixed-point).
// Q15: 1.0 = 32768, 2.0 = 65536, etc.  Max representable = 65535 * 2 = ~2.0.
//
// COLS: number of parallel channels (default 4 for 4x4 GEMM)
// Pipeline: 2 cycles (multiply → shift+round+pack).

`timescale 1ns / 1ps

module ternary_scale #(
    parameter ACC_WIDTH  = 32,
    parameter COLS       = 4,
    parameter PRECISION  = 15   // Q15: 1.0 = 32768
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         valid_in,
    input  wire  [COLS*ACC_WIDTH-1:0]   acc_in,    // packed GEMM results
    input  wire  [COLS*(PRECISION+1)-1:0]   alpha,     // per-channel scales (QPRECISION: 1.0 = 2^PRECISION)
    output reg   [COLS*ACC_WIDTH-1:0]   result,
    output reg                          valid_out
);

    // Separately-named registers per channel (no shared multi-driver reg)
    reg [ACC_WIDTH+PRECISION:0] prod_0, prod_1, prod_2, prod_3;  // 32+16 = 48 bits

    // Stage 1: per-channel multiply
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prod_0 <= 0; prod_1 <= 0; prod_2 <= 0; prod_3 <= 0;
        end else if (valid_in) begin
            prod_0 <= $signed(acc_in[0*ACC_WIDTH +: ACC_WIDTH]) *
                      $signed({1'b0, alpha [0*(PRECISION+1) +: PRECISION+1]});
            prod_1 <= $signed(acc_in[1*ACC_WIDTH +: ACC_WIDTH]) *
                      $signed({1'b0, alpha [1*(PRECISION+1) +: PRECISION+1]});
            prod_2 <= $signed(acc_in[2*ACC_WIDTH +: ACC_WIDTH]) *
                      $signed({1'b0, alpha [2*(PRECISION+1) +: PRECISION+1]});
            prod_3 <= $signed(acc_in[3*ACC_WIDTH +: ACC_WIDTH]) *
                      $signed({1'b0, alpha [3*(PRECISION+1) +: PRECISION+1]});
        end
    end

    // Stage 2: shift, round, pack (2nd cycle)
    reg valid_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_d1  <= 0;
            valid_out <= 0;
        end else begin
            valid_d1  <= valid_in;
            valid_out <= valid_d1;
        end
    end

    /* verilator lint_off UNUSEDSIGNAL */
    function [ACC_WIDTH-1:0] scale_ch;
        input [ACC_WIDTH+PRECISION:0] p;  // 48 bits
        reg [PRECISION:0] trunc;
        reg round;
        reg signed [ACC_WIDTH+PRECISION:0] shifted;
        begin
            trunc   = p[PRECISION:0];
            round   = |trunc;
            shifted = p >>> PRECISION;
            scale_ch = shifted[ACC_WIDTH-1:0] + round;
        end
    endfunction
    /* verilator lint_on UNUSEDSIGNAL */

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            result <= 0;
        else if (valid_d1) begin
            result[0*ACC_WIDTH +: ACC_WIDTH] <= scale_ch(prod_0);
            result[1*ACC_WIDTH +: ACC_WIDTH] <= scale_ch(prod_1);
            result[2*ACC_WIDTH +: ACC_WIDTH] <= scale_ch(prod_2);
            result[3*ACC_WIDTH +: ACC_WIDTH] <= scale_ch(prod_3);
        end
    end

endmodule