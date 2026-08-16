// SPDX-License-Identifier: CERN-OHL-S-2.0
// Decode five base-3 ternary weights packed into one byte.
//
// Codes 0..242 are valid (3^5 combinations). Codes 243..255 are reserved
// and are reported through error_out instead of being presented downstream.

`timescale 1ns / 1ps

module ternary_decompress5 #(
    parameter CODE_WIDTH = 8
)(
    input wire                   clk,
    input wire                   rst_n,
    input wire                   valid_in,
    input wire [CODE_WIDTH-1:0]  packed_in,
    output reg                   valid_out,
    output reg                   error_out,
    output reg [9:0]             weight_enc
);
    localparam integer VALID_CODES = 243;
    integer code;
    reg [1:0] remainder;
    reg [1:0] digit0, digit1, digit2, digit3, digit4;
    reg [9:0] decoded_next;
    reg error_next;

    // The packed format is deliberately fixed at one byte: 3^5 values fit
    // in 8 bits, with 13 reserved codes available for error detection.
    initial begin
        if (CODE_WIDTH != 8)
            $error("ternary_decompress5 requires CODE_WIDTH=8");
    end

    always @* begin
        code = {{24{1'b0}}, packed_in};
        // The modulo result is mathematically in 0..2; the explicit slice
        // keeps the hardware-facing digit representation two bits wide.
        /* verilator lint_off WIDTHTRUNC */
        remainder = code % 3; digit0 = remainder[1:0]; code = code / 3;
        remainder = code % 3; digit1 = remainder[1:0]; code = code / 3;
        remainder = code % 3; digit2 = remainder[1:0]; code = code / 3;
        remainder = code % 3; digit3 = remainder[1:0]; code = code / 3;
        remainder = code % 3; digit4 = remainder[1:0];
        /* verilator lint_on WIDTHTRUNC */
        error_next = (packed_in >= VALID_CODES);
        decoded_next = {digit4[1:0], digit3[1:0], digit2[1:0],
                        digit1[1:0], digit0[1:0]};
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 0; error_out <= 0; weight_enc <= 0;
        end else begin
            valid_out <= valid_in && !error_next;
            error_out <= valid_in && error_next;
            if (valid_in && !error_next)
                weight_enc <= decoded_next;
        end
    end
endmodule
