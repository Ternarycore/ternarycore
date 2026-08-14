// ternary_gemm_stream.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Tier 2 streaming feeder.
//
// The Tier 1 bottleneck was the soft CPU hand-feeding the GEMM one element
// per ~12 AXI cycles (array ~3% utilized). This module is the fix: a
// hardware sequencer that streams weights + activations from BRAM into the
// ternary_gemm at ONE element per clock, no CPU in the loop.
//
// One pass = one DEPTH-long accumulation across all COLS columns in
// parallel, at line rate:
//   cycles/pass ≈ DEPTH + a few  (vs ~5.3M CPU-fed for a 768×768 layer)
//
// Pipeline (Xilinx block RAM = 1-cycle read latency):
//   stage 0 : present address k on act_addr/w_addr; mark v0
//   stage 1 : act_data/w_data valid, v0 delayed to v1 -> drive gemm.valid_in
// Data and valid stay aligned because both carry exactly one cycle of delay.
//
// Weight memory: one row per k, 2*COLS bits (2-bit ternary code per column).
// Activation memory: one int8 per k.

`timescale 1ns / 1ps

module ternary_gemm_stream #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter DEPTH      = 768,
    parameter COLS       = 64,
    parameter ADDR_WIDTH = 10
)(
    input  wire                        clk,
    input  wire                        rst_n,
    input  wire                        start,
    output reg                         busy,
    output reg                         done,

    output wire [ADDR_WIDTH-1:0]       act_addr,
    input  wire [DATA_WIDTH-1:0]       act_data,
    output wire [ADDR_WIDTH-1:0]       w_addr,
    input  wire [2*COLS-1:0]           w_data,

    output wire [ACC_WIDTH*COLS-1:0]   result
);

    localparam S_IDLE = 2'd0, S_RUN = 2'd1, S_WAIT = 2'd2;

    reg [1:0]            state;
    reg [ADDR_WIDTH:0]   k;        // address counter, 0..DEPTH
    reg                  run;      // issuing addresses
    reg                  v0;       // stage-0: valid address presented this cycle
    reg                  v1;       // stage-1: data valid -> feed GEMM
    reg [ADDR_WIDTH:0]   fed;      // count of elements driven into GEMM

    assign act_addr = k[ADDR_WIDTH-1:0];
    assign w_addr   = k[ADDR_WIDTH-1:0];

    wire [ACC_WIDTH*COLS-1:0] gemm_acc_out;
    wire                      gemm_valid_out;
    reg  [ACC_WIDTH*COLS-1:0] result_latch;
    assign result = result_latch;

    ternary_gemm #(
        .DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH),
        .ROWS(1), .COLS(COLS), .DEPTH(DEPTH)
    ) gemm_i (
        .clk(clk), .rst_n(rst_n),
        .valid_in(v1),              // aligned to act_data/w_data (both +1 cycle)
        .activation(act_data),
        .weight_enc(w_data),
        .acc_out(gemm_acc_out),
        .valid_out(gemm_valid_out)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE; busy <= 0; done <= 0;
            k <= 0; run <= 0; v0 <= 0; v1 <= 0; fed <= 0;
            result_latch <= {ACC_WIDTH*COLS{1'b0}};
        end else begin
            done <= 1'b0;
            v1   <= v0;             // BRAM-latency align
            case (state)
                S_IDLE: begin
                    v0 <= 1'b0;
                    if (start) begin
                        k    <= 0;
                        run  <= 1'b1;
                        v0   <= 1'b1;   // address 0 presented next cycle
                        fed  <= 0;
                        busy <= 1'b1;
                        state<= S_RUN;
                    end
                end
                S_RUN: begin
                    if (run) begin
                        if (k == DEPTH-1) run <= 1'b0;
                        k  <= k + 1'b1;
                        v0 <= 1'b1;
                    end else begin
                        v0 <= 1'b0;
                    end
                    if (v1) fed <= fed + 1'b1;
                    if (fed == DEPTH) state <= S_WAIT;   // all DEPTH driven
                end
                S_WAIT: begin
                    v0 <= 1'b0;
                    if (gemm_valid_out) begin
                        result_latch <= gemm_acc_out;
                        done  <= 1'b1;
                        busy  <= 1'b0;
                        state <= S_IDLE;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
