// SPDX-License-Identifier: CERN-OHL-S-2.0
// BitNet full inference pipeline: activation_quant → GEMM → scale.
//
// Streaming interface: valid_in/valid_out handshake.
// Latency: VECTOR_LEN + 6 cycles from first valid_in to valid_out.
//
// Parameters match the submodules. The pipeline feeds quantized
// activations into the GEMM, then scales each column's result by
// its per-channel alpha.

`timescale 1ns / 1ps

module ternary_pipeline #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 4,
    parameter COLS       = 4,
    parameter PRECISION  = 15,    // Q15 for alpha (1.0 = 0x8000)
    parameter INV_WIDTH  = 22     // bits for inv (2^15 * 127 / absmax)
)(
    input  wire                         clk,
    input  wire                         rst_n,
    // Input stream: activations
    input  wire                         valid_in,
    input  wire signed [DATA_WIDTH-1:0] activation,
    // Per-tensor inverse absmax (precomputed)
    input  wire [INV_WIDTH-1:0]         inv,
    // Per-channel scales (packed)
    input  wire [COLS*(PRECISION+1)-1:0] alpha,
    // Fixed ternary weights per column (packed 2-bit per column)
    input  wire [2*COLS-1:0]            weight_enc,
    // Output stream: scaled results
    output reg  [COLS*ACC_WIDTH-1:0]    result,
    output reg                          valid_out
);

    // ── Stage 1: Activation quantizer ────────────────────────────
    wire [DATA_WIDTH-1:0] q;
    wire                  q_valid;

    activation_quant #(.DATA_WIDTH(DATA_WIDTH), .PRECISION(15), .INV_WIDTH(INV_WIDTH)) quant (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in), .x(activation), .inv(inv),
        .q(q), .valid_out(q_valid)
    );

    // ── Stage 2: GEMM ────────────────────────────────────────────
    wire [COLS*ACC_WIDTH-1:0] gemm_result;
    wire                      gemm_valid;

    ternary_gemm #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH),
                   .DEPTH(VECTOR_LEN), .COLS(COLS)) gemm (
        .clk(clk), .rst_n(rst_n),
        .valid_in(q_valid), .activation($signed(q)), .weight_enc(weight_enc),
        .acc_out(gemm_result), .valid_out(gemm_valid)
    );

    // ── Stage 3: Scale multiply ──────────────────────────────────
    ternary_scale #(.ACC_WIDTH(ACC_WIDTH), .COLS(COLS), .PRECISION(PRECISION)) scale (
        .clk(clk), .rst_n(rst_n),
        .valid_in(gemm_valid),
        .acc_in(gemm_result), .alpha(alpha),
        .result(result), .valid_out(valid_out)
    );

endmodule