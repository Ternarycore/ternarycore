// ternary_mac.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// This source describes Hardware and is licensed under the CERN-OHL-S v2.
// You may redistribute and modify this source and make products using it
// under the terms of the CERN-OHL-S v2 (https://ohwr.org/cern_ohl_s_v2.txt).
//
// Single ternary multiply-accumulate cell.
// Weight encoding: 2-bit {00=zero, 01=+1, 10=-1}
// No multiplier instantiated — only adders and mux logic.

`timescale 1ns / 1ps

module ternary_mac #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
) (
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  valid_in,
    input  wire [DATA_WIDTH-1:0] activation,   // signed input activation
    input  wire [1:0]            weight_enc,   // 2-bit ternary weight
    input  wire [ACC_WIDTH-1:0]  acc_in,       // running accumulator
    output reg  [ACC_WIDTH-1:0]  acc_out,
    output reg                   valid_out
);

    // Ternary multiply: mux only, no DSP block consumed
    wire signed [DATA_WIDTH-1:0] weighted;
    assign weighted = (weight_enc == 2'b00) ? {DATA_WIDTH{1'b0}}  :  // w = 0
                      (weight_enc == 2'b01) ? $signed(activation)  :  // w = +1
                                              -$signed(activation);    // w = -1

    // Sign-extend and accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_out   <= {ACC_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            if (valid_in)
                acc_out <= acc_in + {{(ACC_WIDTH-DATA_WIDTH){weighted[DATA_WIDTH-1]}}, weighted};
        end
    end

endmodule
