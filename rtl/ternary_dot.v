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
    parameter VECTOR_LEN = 64
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   valid_in,
    input  wire [DATA_WIDTH-1:0]  activation,
    input  wire [1:0]             weight_enc,   // 00=0, 01=+1, 10=-1
    output reg  [ACC_WIDTH-1:0]   acc_out,
    output reg                    valid_out
);

    reg signed [DATA_WIDTH-1:0] weighted;
    reg [ACC_WIDTH-1:0] weighted_ext;

     reg [ACC_WIDTH-1:0] acc;
    reg [15:0]          count;       // down-counter, no $clog2 required
    reg                 vector_done; // pulses 1 cycle when last element processed
    reg [ACC_WIDTH-1:0] result_latch; // latches the result for output
    reg                 valid_out_latched; // latches valid_out for testbench sampling
    reg                 just_done;     // pulses 1 cycle when vector completes

    wire [ACC_WIDTH-1:0] next_acc;
    assign next_acc = acc + weighted_ext;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc        <= {ACC_WIDTH{1'b0}};
            count      <= VECTOR_LEN - 1;    // load down-counter
            acc_out    <= {ACC_WIDTH{1'b0}};
            valid_out  <= 1'b0;
            valid_out_latched <= 1'b0;
            vector_done <= 1'b0;
            result_latch <= {ACC_WIDTH{1'b0}};
            $display("DBG RESET: VECTOR_LEN=%0d count_init=%0d", VECTOR_LEN, VECTOR_LEN-1);

        end else begin

            // Compute weighted value from current inputs
            weighted = (weight_enc == 2'b00) ?  {DATA_WIDTH{1'b0}} :
                       (weight_enc == 2'b01) ?  $signed(activation) :
                                                -$signed(activation);
            weighted_ext = {{(ACC_WIDTH-DATA_WIDTH){weighted[DATA_WIDTH-1]}}, weighted};

            $display("DBG CLK: vi=%b vd=%b count=%0d acc=%0d vo=%b act=%0d wenc=%b w=%0d",
                     valid_in, vector_done, count, $signed(acc), valid_out,
                     $signed(activation), weight_enc, $signed(weighted));

            // ── Output stage ─────────────────────────────────────────────
            // valid_out pulses high for one cycle when vector completes.
            // It stays high for one cycle after vector_done is cleared, giving
            // the testbench time to sample it.
            if (just_done) begin
                acc_out   <= result_latch;
                valid_out <= 1'b1;
                valid_out_latched <= 1'b1;
            end else if (valid_out_latched) begin
                valid_out <= 1'b1;
                valid_out_latched <= 1'b0;
            end else begin
                valid_out <= 1'b0;
            end

            // ── Accumulation + counter stage ──────────────────────────────
            just_done <= 1'b0;  // default: not done

            if (!vector_done) begin
                if (valid_in) begin
                    if (count == 16'b0) begin
                        // Last element — latch result, set done flag, reload counter
                        result_latch <= next_acc;
                        vector_done <= 1'b1;
                        just_done   <= 1'b1;   // signal that vector just completed
                        acc        <= {ACC_WIDTH{1'b0}};   // reset for next vector
                        count      <= VECTOR_LEN - 1;
                        $display("DBG  --> count==0 HIT: vector_done<=1, result=%0d", $signed(next_acc));
                    end else begin
                        vector_done <= 1'b0;
                        $display("DBG  --> acc=%0d + weighted=%0d (act=%0d, wenc=%b) = next_acc=%0d",
                   $signed(acc), $signed(weighted), $signed(activation), weight_enc, $signed(next_acc));
                        acc        <= next_acc;
                        count      <= count - 16'b1;
                    end
                end else begin
                    vector_done <= 1'b0;
                end
            end else begin
                // vector_done is high — clear it when valid_in goes low (output consumed)
                if (!valid_in) begin
                    vector_done <= 1'b0;
                end
            end

        end
    end

endmodule
