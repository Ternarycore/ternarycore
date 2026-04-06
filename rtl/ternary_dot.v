// ternary_dot.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// This source describes Hardware and is licensed under the CERN-OHL-S v2.
// You may redistribute and modify this source and make products using it
// under the terms of the CERN-OHL-S v2 (https://ohwr.org/cern_ohl_s_v2.txt).
//
// Streaming ternary dot product.
// Accumulates VECTOR_LEN ternary MAC operations in series.
// Weight encoding: 2-bit {00=zero, 01=+1, 10=-1}
// Asserts valid_out for one cycle when the dot product is ready.
// Resets accumulator automatically for the next vector.
//
// Latency: VECTOR_LEN cycles from first valid_in to valid_out.
// Throughput: back-to-back vectors with no gap required.

`timescale 1ns / 1ps

module ternary_dot #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 64
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  valid_in,
    input  wire [DATA_WIDTH-1:0] activation,   // signed input activation
    input  wire [1:0]            weight_enc,   // 2-bit ternary weight
    output reg  [ACC_WIDTH-1:0]  acc_out,
    output reg                   valid_out
);

    // Ternary multiply: mux only, no DSP block consumed
    wire signed [DATA_WIDTH-1:0] weighted;
    assign weighted = (weight_enc == 2'b00) ? {DATA_WIDTH{1'b0}}  :
                      (weight_enc == 2'b01) ? $signed(activation)  :
                                              -$signed(activation);

    // Sign-extended contribution
    wire [ACC_WIDTH-1:0] weighted_ext;
    assign weighted_ext = {{(ACC_WIDTH-DATA_WIDTH){weighted[DATA_WIDTH-1]}}, weighted};

    // Internal running accumulator and element counter
    // Use a 16-bit counter — supports VECTOR_LEN up to 65535, avoids $clog2
    reg [ACC_WIDTH-1:0]  acc;
    reg [15:0]           count;

    wire [ACC_WIDTH-1:0] next_acc;
    assign next_acc = acc + weighted_ext;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc       <= {ACC_WIDTH{1'b0}};
            count     <= 16'b0;
            acc_out   <= {ACC_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end else if (valid_in) begin
            if (count == VECTOR_LEN - 1) begin
                // Last element: latch result, reset counter for next vector
                acc_out   <= next_acc;
                valid_out <= 1'b1;
                acc       <= {ACC_WIDTH{1'b0}};
                count     <= 16'b0;
            end else begin
                // Mid-vector: accumulate, clear valid_out
                valid_out <= 1'b0;
                acc       <= next_acc;
                count     <= count + 16'b1;
            end
        end
        // valid_in=0: all registers hold — valid_out stays high between vectors
    end

endmodule
