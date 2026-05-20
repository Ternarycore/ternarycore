// ternary_dot.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// Streaming ternary dot product.
// Accumulates VECTOR_LEN ternary MAC operations in series.
// Weight encoding: 2-bit {00=zero, 01=+1, 10=-1}
//
// Output timing:
//   valid_out pulses HIGH exactly ONE cycle after the last element is fed.
//   acc_out holds the result for that cycle. Both clear next cycle.
//   Resets acc for the next vector during the same output cycle.
//
// Counter strategy: DOWN-counter from VECTOR_LEN-1 → 0.
//   Terminal condition is (count == 16'b0) — a literal-zero comparison,
//   not a parameter expression — which avoids Icarus Verilog elaboration-time
//   bit-width inference bugs on (count == VECTOR_LEN-1).
//   No $clog2 needed; plain reg [15:0] supports up to 65535 elements.

`timescale 1ns / 1ps

module ternary_dot #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 64,
    parameter DOT_ID     = 0
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   valid_in,
    input  wire [DATA_WIDTH-1:0]  activation,
    input  wire [1:0]             weight_enc,   // 00=0, 01=+1, 10=-1
        (* mark_debug = "true", keep = "true", dont_touch = "true" *) output reg  [ACC_WIDTH-1:0]   acc_out,
        output wire                   valid_out,
        // Exported debug ports (preserved for ILA/board probing)
        (* mark_debug = "true", keep = "true", dont_touch = "true" *) output reg                  debug_valid_in_out,
        (* mark_debug = "true", keep = "true", dont_touch = "true" *) output reg [DATA_WIDTH-1:0] debug_activation_out,
        (* mark_debug = "true", keep = "true", dont_touch = "true" *) output reg [1:0]            debug_weight_enc_out,
        (* mark_debug = "true", keep = "true", dont_touch = "true" *) output reg [ACC_WIDTH-1:0] debug_acc_out_out,
        (* mark_debug = "true", keep = "true", dont_touch = "true" *) output reg                  debug_valid_out_out
);

    (* mark_debug = "true" *) reg signed [DATA_WIDTH-1:0] weighted;
    (* mark_debug = "true" *) reg [ACC_WIDTH-1:0] weighted_ext;

    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg [ACC_WIDTH-1:0] acc;
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg [15:0]          count;       // down-counter, no $clog2 required
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg                 vector_done; // pulses 1 cycle when last element processed
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg [ACC_WIDTH-1:0] result_latch; // latches the result for output
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg                 vector_done_delayed;

    (* mark_debug = "true" *) reg [ACC_WIDTH-1:0] next_acc;
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg                  debug_valid_in;
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg [DATA_WIDTH-1:0] debug_activation;
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg [1:0]            debug_weight_enc;
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg [ACC_WIDTH-1:0] debug_acc_out;
    (* mark_debug = "true", keep = "true", dont_touch = "true" *) reg                  debug_valid_out;

    // ILA-visible port taps: mirror external I/O so the ILA can capture
    // interface-level transitions without depending on optimization choices.
    (* mark_debug = "true" *) wire                 debug_tap_valid_in;
    (* mark_debug = "true" *) wire signed [DATA_WIDTH-1:0] debug_tap_activation;
    (* mark_debug = "true" *) wire [1:0]            debug_tap_weight_enc;
    (* mark_debug = "true" *) wire [ACC_WIDTH-1:0] debug_tap_acc_out;
    (* mark_debug = "true" *) wire                 debug_tap_valid_out;

    // Tie taps to module ports / internal outputs
    assign debug_tap_valid_in    = valid_in;
    assign debug_tap_activation  = activation;
    assign debug_tap_weight_enc  = weight_enc;
    assign debug_tap_acc_out     = acc_out;
    assign debug_tap_valid_out   = valid_out;
    // ── Main sequential logic ─────────────────────────────────────
    always @(posedge clk or negedge rst_n) begin
         if (!rst_n) begin
             acc        <= {ACC_WIDTH{1'b0}};
             count      <= VECTOR_LEN;    // load down-counter (counts VECTOR_LEN down to 1)
             acc_out    <= {ACC_WIDTH{1'b0}};
             vector_done <= 1'b0;
             vector_done_delayed <= 1'b0;
              result_latch <= {ACC_WIDTH{1'b0}};
             debug_valid_in <= 1'b0;
              debug_activation <= {DATA_WIDTH{1'b0}};
              debug_weight_enc <= 2'b00;
              debug_acc_out <= {ACC_WIDTH{1'b0}};
              debug_valid_out <= 1'b0;
              // initialize exported debug outputs
              debug_valid_in_out <= 1'b0;
              debug_activation_out <= {DATA_WIDTH{1'b0}};
              debug_weight_enc_out <= 2'b00;
              debug_acc_out_out <= {ACC_WIDTH{1'b0}};
              debug_valid_out_out <= 1'b0;
          end else begin
              // Compute weighted value from current inputs
              weighted = (weight_enc == 2'b00) ?  {DATA_WIDTH{1'b0}} :
                         (weight_enc == 2'b01) ?  $signed(activation) :
                                                  -$signed(activation);
              weighted_ext = {{(ACC_WIDTH-DATA_WIDTH){weighted[DATA_WIDTH-1]}}, weighted};
              next_acc = acc + weighted_ext;

             // ── Accumulation + counter stage ──────────────────────────────
             // Accumulate when valid_in is high and we're not done (or we're starting new vector)
             if (valid_in && (!vector_done || vector_done_delayed)) begin
                 if (count == 16'b1) begin
                     // Last element — latch result, set done flag, reload counter
                     result_latch <= next_acc;
                     vector_done <= 1'b1;
                     acc        <= {ACC_WIDTH{1'b0}};   // reset for next vector
                     count      <= VECTOR_LEN;
                 end else begin
                     vector_done <= 1'b0;
                     acc        <= next_acc;
                     count      <= count - 16'b1;
                 end
             end else begin
                 // valid_in=0 or valid_in=1 but vector_done=1 and vector_done_delayed=0
                 // Keep vector_done as is
                 vector_done <= vector_done;
             end

             debug_valid_in <= valid_in;
             debug_activation <= activation;
             debug_weight_enc <= weight_enc;
             debug_acc_out <= acc_out;
             debug_valid_out <= vector_done;
             // drive exported debug outputs so tools see explicit top-level nets
             debug_valid_in_out <= valid_in;
             debug_activation_out <= activation;
             debug_weight_enc_out <= weight_enc;
             debug_acc_out_out <= acc_out;
             debug_valid_out_out <= vector_done;
         end
    end

    // ── Output stage ─────────────────────────────────────────────
    // valid_out pulses high ONE CYCLE after the last element is fed.
    // Combinatorial: valid_out is high when vector_done was true previous cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vector_done_delayed <= 1'b0;
        end else begin
            vector_done_delayed <= vector_done;
        end
    end
    
    // Output result when valid_out is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_out <= {ACC_WIDTH{1'b0}};
        end else if (vector_done) begin
            acc_out <= result_latch;
        end else begin
            acc_out <= {ACC_WIDTH{1'b0}};
        end
    end
    
    assign valid_out = vector_done;

endmodule
