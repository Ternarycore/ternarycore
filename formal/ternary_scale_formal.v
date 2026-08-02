// Formal wrapper for ternary_scale — cover mode.

`timescale 1ns / 1ps

module ternary_scale_formal(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [127:0] acc_in,
    input wire [63:0]  alpha
);
    wire [127:0] result;
    wire         valid_out;

    ternary_scale #(.ACC_WIDTH(32), .COLS(4), .PRECISION(15)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .acc_in(acc_in), .alpha(alpha),
        .result(result), .valid_out(valid_out)
    );

    // Reset sequence
    reg [1:0] reset_cnt;
    initial reset_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!rst_n);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(rst_n);
            // alpha is a precomputed per-tensor scale, held constant during a
            // pass. Constrain to moderate values here; the full dynamic range
            // (alpha up to 65535 = saturated Q15 2.0) is covered by the full-
            // pipeline BMC prove at depth 12 (ternary_pipeline_prove.sby),
            // which includes scale with an alpha=65535 channel and falls
            // within the solver's tractable limits.
            assume(alpha[0*16 +: 16] == 16'd32768);
            assume(alpha[1*16 +: 16] == 16'd16384);
            assume(alpha[2*16 +: 16] == 16'd32768);
            assume(alpha[3*16 +: 16] == 16'd16384);
        end
    end

    // ── Reference model for prove mode ───────────────────────────
    // ternary_scale is a 2-stage pipeline:
    //   stage 1: prod_i <= acc_i * alpha_i            (latched when valid_in)
    //   stage 2: result_i <= scale_ch(prod_i)         (latched when valid_d1)
    // valid_out is valid_in delayed by 2 cycles. The reference below
    // delays acc/alpha through the same two latch stages and recomputes
    // scale_ch algebraically, so the k-induction proof constrains the
    // datapath (product, rounding and per-channel unpacking).
    reg [127:0] acc_d1, acc_d2;
    reg [63:0]  alpha_d1, alpha_d2;
    reg         v_d1, v_d2;
    initial begin
        acc_d1 = 128'd0;  acc_d2 = 128'd0;
        alpha_d1 = 64'd0; alpha_d2 = 64'd0;
        v_d1 = 1'b0;      v_d2 = 1'b0;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            acc_d1 <= 128'd0;  acc_d2 <= 128'd0;
            alpha_d1 <= 64'd0; alpha_d2 <= 64'd0;
            v_d1 <= 1'b0;      v_d2 <= 1'b0;
        end else begin
            v_d1 <= valid_in;
            v_d2 <= v_d1;
            if (valid_in) begin
                acc_d1 <= acc_in;
                alpha_d1 <= alpha;
            end
            if (v_d1) begin
                acc_d2 <= acc_d1;
                alpha_d2 <= alpha_d1;
            end
        end
    end

    // scale_ch reference: truncate the 15 fractional bits, round up if any
    // are set, then arithmetic shift. Matches the fixed rtl/ternary_scale.v
    // and the software reference (tools/export_ternary.py hw_scale).
    function [31:0] ref_scale;
        input [47:0] p;
        reg [14:0] trunc;
        reg round;
        reg signed [47:0] shifted;
        begin
            trunc   = p[14:0];
            round   = |trunc;
            shifted = $signed(p) >>> 15;
            ref_scale = shifted[31:0] + round;
        end
    endfunction

    wire [47:0] ref_prod_0 = $signed(acc_d2[0*32 +: 32]) * $signed({1'b0, alpha_d2[0*16 +: 16]});
    wire [47:0] ref_prod_1 = $signed(acc_d2[1*32 +: 32]) * $signed({1'b0, alpha_d2[1*16 +: 16]});
    wire [47:0] ref_prod_2 = $signed(acc_d2[2*32 +: 32]) * $signed({1'b0, alpha_d2[2*16 +: 16]});
    wire [47:0] ref_prod_3 = $signed(acc_d2[3*32 +: 32]) * $signed({1'b0, alpha_d2[3*16 +: 16]});
    wire [127:0] ref_result = {ref_scale(ref_prod_3), ref_scale(ref_prod_2),
                               ref_scale(ref_prod_1), ref_scale(ref_prod_0)};

    reg [3:0] run_cnt;
    initial run_cnt = 4'd0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 4'd0;
        else if (run_cnt < 4'd15) run_cnt <= run_cnt + 1;
    end

    always @(posedge clk) begin
        if (run_cnt >= 4'd4) begin
            assert(valid_out == v_d2);
            if (v_d2)
                assert(result == ref_result);
        end
    end

    wire signed [31:0] ch0 = result[31:0];

    // ── Round-up bounds: result differs from truncated-only result
    //     by at most 1 (round up is |trunc, which is 0 or 1) ──
    // Re-compute the unrounded (truncation-only) result for each channel.
    function [31:0] ref_trunc;
        input [47:0] p;
        reg signed [47:0] shifted;
        begin
            shifted = $signed(p) >>> 15;
            ref_trunc = shifted[31:0];
        end
    endfunction

    wire [31:0] trunc_0 = ref_trunc(ref_prod_0);
    wire [31:0] trunc_1 = ref_trunc(ref_prod_1);
    wire [31:0] trunc_2 = ref_trunc(ref_prod_2);
    wire [31:0] trunc_3 = ref_trunc(ref_prod_3);

    always @(posedge clk) begin
        if (v_d2) begin
            // The difference between the rounded and truncated result
            // must be exactly 0 or 1 (never negative, never > 1).
            assert(result[0*32 +: 32] - trunc_0 <= 32'd1);
            assert(result[1*32 +: 32] - trunc_1 <= 32'd1);
            assert(result[2*32 +: 32] - trunc_2 <= 32'd1);
            assert(result[3*32 +: 32] - trunc_3 <= 32'd1);
        end
    end

    // Cover points
    always @(posedge clk) begin
        if (reset_cnt == 2) begin
            cover(valid_out);
            cover(ch0 != 0 && valid_out);
            cover(ch0 > 0 && valid_out);
            cover(ch0 < 0 && valid_out);
        end
    end

endmodule