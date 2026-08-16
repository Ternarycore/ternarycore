// SPDX-License-Identifier: CERN-OHL-S-2.0
// Registered 4-point Walsh-Hadamard transform for activation preconditioning.

`timescale 1ns / 1ps

module hadamard4 #(
    parameter DATA_WIDTH = 8,
    parameter OUTPUT_WIDTH = DATA_WIDTH + 2
)(
    input  wire                          clk,
    input  wire                          rst_n,
    input  wire                          valid_in,
    input  wire signed [DATA_WIDTH-1:0]  x0,
    input  wire signed [DATA_WIDTH-1:0]  x1,
    input  wire signed [DATA_WIDTH-1:0]  x2,
    input  wire signed [DATA_WIDTH-1:0]  x3,
    output reg                           valid_out,
    output reg signed [OUTPUT_WIDTH-1:0] y0,
    output reg signed [OUTPUT_WIDTH-1:0] y1,
    output reg signed [OUTPUT_WIDTH-1:0] y2,
    output reg signed [OUTPUT_WIDTH-1:0] y3
);
    wire signed [OUTPUT_WIDTH-1:0] x0_ext = {{(OUTPUT_WIDTH-DATA_WIDTH){x0[DATA_WIDTH-1]}}, x0};
    wire signed [OUTPUT_WIDTH-1:0] x1_ext = {{(OUTPUT_WIDTH-DATA_WIDTH){x1[DATA_WIDTH-1]}}, x1};
    wire signed [OUTPUT_WIDTH-1:0] x2_ext = {{(OUTPUT_WIDTH-DATA_WIDTH){x2[DATA_WIDTH-1]}}, x2};
    wire signed [OUTPUT_WIDTH-1:0] x3_ext = {{(OUTPUT_WIDTH-DATA_WIDTH){x3[DATA_WIDTH-1]}}, x3};
    wire signed [OUTPUT_WIDTH-1:0] sum02  = x0_ext + x2_ext;
    wire signed [OUTPUT_WIDTH-1:0] diff02 = x0_ext - x2_ext;
    wire signed [OUTPUT_WIDTH-1:0] sum13  = x1_ext + x3_ext;
    wire signed [OUTPUT_WIDTH-1:0] diff13 = x1_ext - x3_ext;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            y0 <= '0; y1 <= '0; y2 <= '0; y3 <= '0;
        end else begin
            valid_out <= valid_in;
            if (valid_in) begin
                y0 <= sum02 + sum13;
                y1 <= sum02 - sum13;
                y2 <= diff02 + diff13;
                y3 <= diff02 - diff13;
            end
        end
    end
endmodule
