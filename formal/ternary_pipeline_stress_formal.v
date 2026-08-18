// SPDX-License-Identifier: CERN-OHL-S-2.0
// Formal wrapper for the full inference pipeline (activation_quant →
// ternary_gemm → ternary_scale), STRESS variant.
//
// Based on ternary_pipeline_formal.v but REMOVES all constraints on
// activation, inv, and alpha — the solver may pick ANY values within
// their bit-widths.
//
// Asserts (gated on run_cnt >= 4 so reset has fully flushed):
//   * dut.valid_out == ref.svalid   — exact output-pulse timing
//   * dut.valid_out == 0 || dut.result[col] == ref.result[col] per column —
//     the result must be correct whenever a result is presented.

`timescale 1ns / 1ps

module ternary_pipeline_stress_formal #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 4,
    parameter COLS       = 2,
    parameter PRECISION  = 15,
    parameter INV_WIDTH  = 22
)(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire signed [DATA_WIDTH-1:0] activation,
    input wire [INV_WIDTH-1:0] inv,
    input wire [COLS*(PRECISION+1)-1:0] alpha,
    input wire [2*COLS-1:0] weight_enc
);

    localparam Q_MAX  = (1 << (DATA_WIDTH - 1)) - 1;   // 127
    localparam Q_MIN  = -(1 << (DATA_WIDTH - 1)) + 1;  // -127

    // ── DUT ─────────────────────────────────────────────
    wire [COLS*ACC_WIDTH-1:0] dut_result;
    wire                      dut_valid;

    ternary_pipeline #(
        .DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH),
        .VECTOR_LEN(VECTOR_LEN), .COLS(COLS),
        .PRECISION(PRECISION), .INV_WIDTH(INV_WIDTH)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in), .activation(activation), .inv(inv),
        .alpha(alpha), .weight_enc(weight_enc),
        .result(dut_result), .valid_out(dut_valid)
    );

    // ── Reset sequence / reset gate ─────────────────────
    reg [1:0] reset_cnt;
    initial reset_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!rst_n);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(rst_n);
            // NO constraints on activation, inv, or alpha.
            // The solver has full freedom over all input values.
        end
    end

    // ── Reference: delayed histories ────────────────────
    // Quantized activation path: two gated latch stages (mirrors the
    // activation_quant product/q registers; a bubble simply drops feed).
    // inv must be tracked alongside the activation because the DUT's
    // activation_quant latches product = x * inv when valid_in is asserted,
    // using the inv value at THAT time, not the current inv when x_d2 fires.
    reg signed [DATA_WIDTH-1:0] x_d1, x_d2;
    reg [INV_WIDTH-1:0]         inv_d1, inv_d2;
    reg                         v_d1, v_d2;
    initial begin
        x_d1 = 8'd0; x_d2 = 8'd0;
        inv_d1 = 0; inv_d2 = 0;
        v_d1 = 1'b0; v_d2 = 1'b0;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            x_d1 <= 8'd0; x_d2 <= 8'd0;
            inv_d1 <= 0; inv_d2 <= 0;
            v_d1 <= 1'b0; v_d2 <= 1'b0;
        end else begin
            v_d1 <= valid_in;
            v_d2 <= v_d1;
            if (valid_in) begin
                x_d1 <= activation;
                inv_d1 <= inv;
            end
            if (v_d1) begin
                x_d2 <= x_d1;
                inv_d2 <= inv_d1;
            end
        end
    end

    // Weight path: unconditional 2-stage shift (mirrors weight_enc_d2).
    reg [2*COLS-1:0] w_d1, w_d2;
    initial begin
        w_d1 = 0; w_d2 = 0;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            w_d1 <= 0; w_d2 <= 0;
        end else begin
            w_d1 <= weight_enc;
            w_d2 <= w_d1;
        end
    end

    // ── Reference: quantization ─────────────────────────
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] ref_prod    = $signed(x_d2) * $signed({1'b0, inv_d2});
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] ref_biased  = ref_prod + $signed(1 << (PRECISION-1));
    wire signed [DATA_WIDTH+INV_WIDTH-1:0] ref_shifted = ref_biased >>> PRECISION;
    wire signed [DATA_WIDTH-1:0] ref_q =
        (ref_shifted >  $signed(Q_MAX)) ? $signed(Q_MAX) :
        (ref_shifted <  $signed(Q_MIN)) ? $signed(Q_MIN) : $signed(ref_shifted[DATA_WIDTH-1:0]);

    // ── Reference: gemm (sliding-window dot per column) ─
    // product of q and the decoded 2-bit weight. Matches the RTL dot's
    // decode exactly: (w==00)?0 : (w==01)?+q : -q — so 2'b11 (an out-of-
    // spec encoding) still contributes -q, as it does in hardware.
    function signed [DATA_WIDTH:0] ref_prod9;
        input [1:0] w;
        input signed [DATA_WIDTH-1:0] q;
        begin
            case (w)
                2'b00:   ref_prod9 = 0;
                2'b01:   ref_prod9 = $signed(q);
                default: ref_prod9 = -$signed(q);
            endcase
        end
    endfunction

    reg signed [DATA_WIDTH:0] pwin [0:COLS-1][0:VECTOR_LEN-1];
    reg signed [ACC_WIDTH-1:0] psum   [0:COLS-1];
    reg signed [ACC_WIDTH-1:0] acc_sum [0:COLS-1];
    reg [1:0] feed_cnt;
    reg       dot_done;
    initial begin
        feed_cnt = 0; dot_done = 0;
    end

    integer c, k;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (c = 0; c < COLS; c = c + 1) begin
                psum[c]    <= 0;
                acc_sum[c] <= 0;
                for (k = 0; k < VECTOR_LEN; k = k + 1)
                    pwin[c][k] <= 0;
            end
            feed_cnt <= 0;
            dot_done <= 0;
        end else begin
            if (v_d2) begin
                for (c = 0; c < COLS; c = c + 1) begin
                    psum[c] <= psum[c] + ref_prod9(w_d2[2*c +: 2], ref_q) - pwin[c][VECTOR_LEN-1];
                    for (k = VECTOR_LEN-1; k > 0; k = k - 1)
                        pwin[c][k] <= pwin[c][k-1];
                    pwin[c][0] <= ref_prod9(w_d2[2*c +: 2], ref_q);
                end
                feed_cnt <= feed_cnt + 1'b1;
                if (feed_cnt == VECTOR_LEN-1) begin
                    for (c = 0; c < COLS; c = c + 1)
                        acc_sum[c] <= psum[c] + ref_prod9(w_d2[2*c +: 2], ref_q) - pwin[c][VECTOR_LEN-1];
                    dot_done <= 1'b1;
                end else begin
                    // Self-clear on any non-terminal feed so dot_done pulses
                    // for exactly one cycle, mirroring the RTL dot's
                    // vector_done (which clears on every non-terminal cycle).
                    dot_done <= 1'b0;
                end
            end else begin
                dot_done <= 1'b0;
            end
        end
    end

    // ── Reference: scale (2-stage product + scale_ch) ───
    function [ACC_WIDTH-1:0] ref_scale;
        input signed [ACC_WIDTH+PRECISION:0] p;
        reg [PRECISION-1:0] trunc;
        reg round;
        reg signed [ACC_WIDTH+PRECISION:0] shifted;
        begin
            trunc   = p[PRECISION-1:0];
            round   = |trunc;
            shifted = p >>> PRECISION;
            ref_scale = shifted[ACC_WIDTH-1:0] + round;
        end
    endfunction

    reg signed [ACC_WIDTH+PRECISION:0] s_prod [0:COLS-1];
    reg        [COLS*ACC_WIDTH-1:0]    s_result;
    reg                               s_d1, svalid;
    initial begin
        s_d1 = 0; svalid = 0; s_result = 0;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            for (c = 0; c < COLS; c = c + 1)
                s_prod[c] <= 0;
            s_result <= 0;
            s_d1 <= 0;
            svalid <= 0;
        end else begin
            s_d1 <= dot_done;
            svalid <= s_d1;
            if (dot_done) begin
                for (c = 0; c < COLS; c = c + 1)
                    s_prod[c] <= $signed(acc_sum[c]) * $signed({1'b0, alpha[c*(PRECISION+1) +: PRECISION+1]});
            end
            if (s_d1)
                for (c = 0; c < COLS; c = c + 1)
                    s_result[c*ACC_WIDTH +: ACC_WIDTH] <= ref_scale(s_prod[c]);
        end
    end

    // ── Asserts ─────────────────────────────────────────
    reg [3:0] run_cnt;
    initial run_cnt = 4'd0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 4'd0;
        else if (run_cnt < 4'd15) run_cnt <= run_cnt + 1;
    end

    always @(posedge clk) begin
        if (run_cnt >= 4'd4) begin
            assert(dut_valid == svalid);
            if (svalid)
                for (c = 0; c < COLS; c = c + 1)
                    assert(dut_result[c*ACC_WIDTH +: ACC_WIDTH] == s_result[c*ACC_WIDTH +: ACC_WIDTH]);
        end
    end

    // ── Safety: valid_out never stays high for 2+ consecutive cycles ──
    reg pv_d1;
    always @(posedge clk) begin
        if (!rst_n) pv_d1 <= 1'b0;
        else pv_d1 <= dut_valid;
    end
    always @(posedge clk) begin
        if (run_cnt >= 4'd4)
            assert(!(dut_valid && pv_d1));
    end

    // ── Safety: valid_out never stays high when valid_in=0 (anti-sticky) ──
    always @(posedge clk) begin
        if (run_cnt >= 4'd4 && !valid_in)
            assert(!(dut_valid && pv_d1));
    end

    // ── Cover points ────────────────────────────────────
    always @(posedge clk) begin
        if (run_cnt >= 4'd4) begin
            cover(dut_valid);                          // a vector completes end-to-end
            cover(dut_valid && s_result[0*ACC_WIDTH +: ACC_WIDTH] != 0);
            cover(dut_valid && s_result[0*ACC_WIDTH +: ACC_WIDTH] >  0);
            cover(dut_valid && $signed(s_result[0*ACC_WIDTH +: ACC_WIDTH]) < 0);
            cover(dut_valid == 1'b0);     // valid_out self-clears between vectors
        end
    end

endmodule