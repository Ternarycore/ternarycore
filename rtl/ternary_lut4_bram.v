// SPDX-License-Identifier: CERN-OHL-S-2.0
// Synchronous BRAM-backed lookup core for four-element ternary dot products.
//
// Software or a loader populates one table for the current activation group:
// address is a base-3 ternary pattern (0..80), data is its precomputed dot
// product. Querying then performs one registered BRAM read instead of four
// add/sub/skip operations.

`timescale 1ns / 1ps

module ternary_lut4_bram #(
    parameter ACC_WIDTH = 16,
    parameter ADDR_WIDTH = 7,
    parameter LUT_DEPTH = 81
)(
    input wire                         clk,
    input wire                         rst_n,
    input wire                         wr_en,
    input wire [ADDR_WIDTH-1:0]        wr_addr,
    input wire signed [ACC_WIDTH-1:0]  wr_data,
    input wire                         query_valid,
    input wire [ADDR_WIDTH-1:0]        query_addr,
    output reg                         result_valid,
    output reg                         error_out,
    output reg signed [ACC_WIDTH-1:0]  result
);
    reg signed [ACC_WIDTH-1:0] table_mem [0:LUT_DEPTH-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_valid <= 0;
            error_out <= 0;
            result <= 0;
        end else begin
            result_valid <= query_valid && (query_addr < LUT_DEPTH);
            error_out <= query_valid && (query_addr >= LUT_DEPTH);
            if (wr_en && (wr_addr < LUT_DEPTH))
                table_mem[wr_addr] <= wr_data;
            if (query_valid && (query_addr < LUT_DEPTH)) begin
                // Define the same-cycle collision explicitly as write-first.
                if (wr_en && (wr_addr < LUT_DEPTH) && (wr_addr == query_addr))
                    result <= wr_data;
                else
                    result <= table_mem[query_addr];
            end
        end
    end
endmodule
