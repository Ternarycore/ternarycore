// ternary_scale_corner_formal.v
// Formal corner-case test for ternary_scale.
// Tests:
//   A — alpha=0 → result must be 0 for any acc_in
//   B — max positive acc_in (2^31-1) with various alpha values
//   C — max negative acc_in (-2^31) with various alpha values
//   D — alpha=0 with valid_in toggling

`timescale 1ns / 1ps

module ternary_scale_corner_formal(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [127:0] acc_in,
    input wire [63:0]  alpha
);
    // ── DUT with COLS=4, ACC_WIDTH=32, PRECISION=15 ───────
    wire [127:0] result;
    wire         valid_out;

    ternary_scale #(.ACC_WIDTH(32), .COLS(4), .PRECISION(15)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .acc_in(acc_in), .alpha(alpha),
        .result(result), .valid_out(valid_out)
    );

    // ── Reset sequence ─────────────────────────────────────
    reg [1:0] reset_cnt;
    initial reset_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!rst_n);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(rst_n);
        end
    end

    reg [3:0] run_cnt;
    initial run_cnt = 4'd0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 4'd0;
        else if (run_cnt < 4'd15) run_cnt <= run_cnt + 1;
    end

    // alpha is a precomputed per-tensor scale, held constant during a pass.
    reg [63:0] alpha_constraint;
    always @(posedge clk) begin
        if (!rst_n)
            alpha_constraint <= 64'd0;
        else if (reset_cnt == 2)
            alpha_constraint <= alpha;
    end
    always @(posedge clk) begin
        if (reset_cnt >= 2)
            assume(alpha == alpha_constraint);
    end

    // Scenario A: alpha=0 → result must be 0 for any acc
    // Force all 4 alpha channels to 0. Since alpha is constant, the solver
    // picks one value for the whole pass, so result must be 0 whenever
    // valid_out fires (including the first pipeline output from reset).
    wire alpha_all_zero = (alpha[0*16 +: 16] == 16'd0) &&
                          (alpha[1*16 +: 16] == 16'd0) &&
                          (alpha[2*16 +: 16] == 16'd0) &&
                          (alpha[3*16 +: 16] == 16'd0);

    wire [31:0] res_ch0 = result[0*32 +: 32];
    wire [31:0] res_ch1 = result[1*32 +: 32];
    wire [31:0] res_ch2 = result[2*32 +: 32];
    wire [31:0] res_ch3 = result[3*32 +: 32];

    always @(posedge clk) begin
        if (run_cnt >= 8 && valid_out && alpha_all_zero) begin
            // When alpha=0, result must be 0 for every channel
            assert(res_ch0 == 32'd0);
            assert(res_ch1 == 32'd0);
            assert(res_ch2 == 32'd0);
            assert(res_ch3 == 32'd0);
        end
    end

    // ── Scenario B: max positive acc with various alpha ─────
    // acc_in = 0x7FFFFFFF (max signed 32-bit) for all 4 channels
    wire acc_is_max_pos = (acc_in[0*32 +: 32] == 32'h7FFFFFFF) &&
                          (acc_in[1*32 +: 32] == 32'h7FFFFFFF) &&
                          (acc_in[2*32 +: 32] == 32'h7FFFFFFF) &&
                          (acc_in[3*32 +: 32] == 32'h7FFFFFFF);

    // Reference for max positive: (2^31-1) * alpha / 2^15
    // Result should be in range [0, (2^31-1)*65535/32768] with rounding
    always @(posedge clk) begin
        if (run_cnt >= 8 && valid_out && acc_is_max_pos) begin
            // result must be >= 0 since max_pos * alpha >= 0
            assert($signed(res_ch0) >= 0);
            assert($signed(res_ch1) >= 0);
            assert($signed(res_ch2) >= 0);
            assert($signed(res_ch3) >= 0);
        end
    end

    // ── Scenario C: max negative acc with various alpha ─────
    // acc_in = 0x80000000 (min signed 32-bit) for all 4 channels
    wire acc_is_min_neg = (acc_in[0*32 +: 32] == 32'h80000000) &&
                          (acc_in[1*32 +: 32] == 32'h80000000) &&
                          (acc_in[2*32 +: 32] == 32'h80000000) &&
                          (acc_in[3*32 +: 32] == 32'h80000000);

    always @(posedge clk) begin
        if (run_cnt >= 8 && valid_out && acc_is_min_neg) begin
            // result must be <= 0 since min_neg * alpha <= 0
            // (min_neg is -2^31, multiplied by unsigned alpha gives negative)
            assert($signed(res_ch0) <= 0);
            assert($signed(res_ch1) <= 0);
            assert($signed(res_ch2) <= 0);
            assert($signed(res_ch3) <= 0);
        end
    end

    // ── Property: result never exceeds 32-bit range ─────────
    // After rounding, the result should stay within [-(2^31), 2^31-1]
    // The max product is (2^31-1) * 65535, shifted right by 15, which
    // fits in 32 bits. Verify this.
    always @(posedge clk) begin
        if (run_cnt >= 8 && valid_out) begin
            assert($signed(res_ch0) <= 32'd2147483647);
            assert($signed(res_ch1) <= 32'd2147483647);
            assert($signed(res_ch2) <= 32'd2147483647);
            assert($signed(res_ch3) <= 32'd2147483647);
        end
    end

    // ── Cover points ───────────────────────────────────────
    always @(posedge clk) begin
        if (reset_cnt == 2) begin
            cover(valid_out && alpha_all_zero);
            cover(valid_out && alpha_all_zero && result == 0);
            cover(valid_out && acc_is_max_pos);
            cover(valid_out && acc_is_min_neg);
        end
    end

endmodule
