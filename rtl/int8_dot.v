// int8_dot.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Binary-multiplier INT8 dot product — the baseline against ternary_dot.
// Same streaming semantics (valid_in per element, valid_out after VECTOR_LEN),
// but a real int8×int8 multiply (infers a DSP48 on Artix-7) instead of a mux.
`timescale 1ns / 1ps

module int8_dot #(
    parameter DATA_WIDTH   = 8,
    parameter WEIGHT_WIDTH = 8,
    parameter ACC_WIDTH    = 32,
    parameter VECTOR_LEN   = 64
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     valid_in,
    input  wire signed [DATA_WIDTH-1:0]   activation,
    input  wire signed [WEIGHT_WIDTH-1:0] weight,
    output reg  [ACC_WIDTH-1:0]     acc_out,
    output wire                     valid_out
);
    reg  [ACC_WIDTH-1:0] acc;
    reg  [15:0]          count;
    reg                  vdone;
    reg  [ACC_WIDTH-1:0] result_latch;
    reg                  vdone_dly;

    wire signed [DATA_WIDTH+WEIGHT_WIDTH-1:0] prod = $signed(activation) * $signed(weight);
    wire signed [ACC_WIDTH-1:0] prod_ext = {{(ACC_WIDTH-DATA_WIDTH-WEIGHT_WIDTH){prod[DATA_WIDTH+WEIGHT_WIDTH-1]}}, prod};
    wire [ACC_WIDTH-1:0] next_acc = acc + prod_ext;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 0; count <= VECTOR_LEN; vdone <= 0; result_latch <= 0;
        end else begin
            if (valid_in && (!vdone || vdone_dly)) begin
                if (count == 16'b1) begin
                    result_latch <= next_acc; vdone <= 1'b1;
                    acc <= 0; count <= VECTOR_LEN;
                end else begin
                    vdone <= 1'b0; acc <= next_acc; count <= count - 16'b1;
                end
            end else vdone <= vdone;
        end
    end

    always @(posedge clk or negedge rst_n)
        if (!rst_n) vdone_dly <= 0; else vdone_dly <= vdone;

    always @(posedge clk or negedge rst_n)
        if (!rst_n) acc_out <= 0;
        else if (vdone) acc_out <= result_latch;
        else acc_out <= 0;

    assign valid_out = vdone;
endmodule
