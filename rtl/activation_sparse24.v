// SPDX-License-Identifier: CERN-OHL-S-2.0
// Lossy-but-bounded 2:4 activation selector.
//
// For each group of four signed activations, retain the two largest
// magnitudes (ties prefer the lower lane) and emit their original-lane mask.
// The block is intended for models trained or calibrated for N:M sparsity.

`timescale 1ns / 1ps

module activation_sparse24 #(
    parameter DATA_WIDTH = 8
)(
    input wire                         clk,
    input wire                         rst_n,
    input wire                         valid_in,
    input wire signed [DATA_WIDTH-1:0] x0,
    input wire signed [DATA_WIDTH-1:0] x1,
    input wire signed [DATA_WIDTH-1:0] x2,
    input wire signed [DATA_WIDTH-1:0] x3,
    output reg                         valid_out,
    output reg [3:0]                   keep_mask,
    output reg signed [DATA_WIDTH-1:0] value0,
    output reg signed [DATA_WIDTH-1:0] value1
);
    wire signed [DATA_WIDTH:0] sx0 = {x0[DATA_WIDTH-1], x0};
    wire signed [DATA_WIDTH:0] sx1 = {x1[DATA_WIDTH-1], x1};
    wire signed [DATA_WIDTH:0] sx2 = {x2[DATA_WIDTH-1], x2};
    wire signed [DATA_WIDTH:0] sx3 = {x3[DATA_WIDTH-1], x3};
    wire [DATA_WIDTH:0] a0 = sx0[DATA_WIDTH] ? -sx0 : sx0;
    wire [DATA_WIDTH:0] a1 = sx1[DATA_WIDTH] ? -sx1 : sx1;
    wire [DATA_WIDTH:0] a2 = sx2[DATA_WIDTH] ? -sx2 : sx2;
    wire [DATA_WIDTH:0] a3 = sx3[DATA_WIDTH] ? -sx3 : sx3;

    reg [1:0] max_idx, second_idx;
    reg [3:0] next_mask;
    reg signed [DATA_WIDTH-1:0] next_value0, next_value1;
    reg [DATA_WIDTH:0] max_abs, second_abs;

    always @* begin
        if ((a0 >= a1) && (a0 >= a2) && (a0 >= a3)) max_idx = 0;
        else if ((a1 >= a0) && (a1 >= a2) && (a1 >= a3)) max_idx = 1;
        else if ((a2 >= a0) && (a2 >= a1) && (a2 >= a3)) max_idx = 2;
        else max_idx = 3;

        case (max_idx)
            0: begin
                max_abs = a0;
                if (a1 >= a2 && a1 >= a3) second_idx=1;
                else if (a2 >= a3) second_idx=2;
                else second_idx=3;
            end
            1: begin
                max_abs = a1;
                if (a0 >= a2 && a0 >= a3) second_idx=0;
                else if (a2 >= a3) second_idx=2;
                else second_idx=3;
            end
            2: begin
                max_abs = a2;
                if (a0 >= a1 && a0 >= a3) second_idx=0;
                else if (a1 >= a3) second_idx=1;
                else second_idx=3;
            end
            default: begin
                max_abs = a3;
                if (a0 >= a1 && a0 >= a2) second_idx=0;
                else if (a1 >= a2) second_idx=1;
                else second_idx=2;
            end
        endcase

        case (second_idx)
            0: second_abs=a0;
            1: second_abs=a1;
            2: second_abs=a2;
            default: second_abs=a3;
        endcase

        next_mask = 4'b0;
        next_value0 = 0;
        next_value1 = 0;
        case (max_idx)
            0: next_value0=x0;
            1: next_value0=x1;
            2: next_value0=x2;
            default: next_value0=x3;
        endcase
        case (second_idx)
            0: next_value1=x0;
            1: next_value1=x1;
            2: next_value1=x2;
            default: next_value1=x3;
        endcase
        if (max_abs != 0) next_mask[max_idx] = 1'b1;
        else next_value0 = 0;
        if (second_abs != 0) next_mask[second_idx] = 1'b1;
        else next_value1 = 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 0; keep_mask <= 0; value0 <= 0; value1 <= 0;
        end else begin
            valid_out <= valid_in;
            if (valid_in) begin
                keep_mask <= next_mask;
                value0 <= next_value0;
                value1 <= next_value1;
            end
        end
    end
endmodule
