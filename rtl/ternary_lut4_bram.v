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
    reg entry_valid [0:LUT_DEPTH-1];
    integer init_idx;

    initial begin
        if (ACC_WIDTH < 1 || ADDR_WIDTH < 1 || LUT_DEPTH < 1)
            $error("ternary_lut4_bram dimensions must be positive");
        if (LUT_DEPTH > (1 << ADDR_WIDTH))
            $error("LUT_DEPTH must fit in ADDR_WIDTH");
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_valid <= 0;
            error_out <= 0;
            result <= 0;
            for (init_idx = 0; init_idx < LUT_DEPTH; init_idx = init_idx + 1)
                entry_valid[init_idx] <= 1'b0;
        end else begin
            result_valid <= 1'b0;
            error_out <= 1'b0;
            if (wr_en && (wr_addr < LUT_DEPTH)) begin
                table_mem[wr_addr] <= wr_data;
                entry_valid[wr_addr] <= 1'b1;
            end
            if (query_valid) begin
                // A same-cycle write makes the entry immediately readable.
                if ((query_addr < LUT_DEPTH) &&
                    (entry_valid[query_addr] ||
                     (wr_en && (wr_addr < LUT_DEPTH) && (wr_addr == query_addr)))) begin
                    result_valid <= 1'b1;
                    if (wr_en && (wr_addr < LUT_DEPTH) && (wr_addr == query_addr))
                        result <= wr_data;
                    else
                        result <= table_mem[query_addr];
                end else begin
                    error_out <= 1'b1;
                end
            end
        end
    end
endmodule
