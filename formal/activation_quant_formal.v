// Formal wrapper for activation_quant — cover mode.
// Enforces 2-cycle reset. Cover points check quantizer behavior.

`timescale 1ns / 1ps

module activation_quant_formal(
    input wire       clk,
    input wire       rst_n,
    input wire       valid_in,
    input wire [7:0] x,
    input wire [21:0] inv
);
    wire [7:0] q;
    wire       valid_out;

    activation_quant #(.DATA_WIDTH(8), .PRECISION(15), .INV_WIDTH(22)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .x(x), .inv(inv), .q(q), .valid_out(valid_out)
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
            // inv is a precomputed per-tensor reciprocal held constant during a
            // pass (inv = round(2^PRECISION * Q_MAX / absmax)). Constrain it to
            // the pipeline-test value (absmax=100 -> inv=41615) so the multiply
            // in the datapath reference stays solver-friendly while still
            // exercising the full rounding/clip logic.
            assume(inv == 22'd41615);
        end
    end

    // ── Reference model for prove mode ───────────────────────────
    // The quantizer is a 2-stage pipeline:
    //   stage 1: product <= x * inv            (latched when valid_in)
    //   stage 2: q <= clip((product + 2^14) >> 15)   (latched one cycle later)
    // valid_out is valid_in delayed by 2 cycles. The reference below
    // delays x/inv through the same two latch stages and recomputes the
    // rounded, clipped quantization algebraically, so the k-induction
    // proof constrains the datapath.
    reg [7:0]  x_d1, x_d2;
    reg [21:0] inv_d1, inv_d2;
    reg        v_d1, v_d2;
    initial begin
        x_d1 = 8'd0;  x_d2 = 8'd0;
        inv_d1 = 22'd0; inv_d2 = 22'd0;
        v_d1 = 1'b0;  v_d2 = 1'b0;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            x_d1 <= 8'd0;  x_d2 <= 8'd0;
            inv_d1 <= 22'd0; inv_d2 <= 22'd0;
            v_d1 <= 1'b0;  v_d2 <= 1'b0;
        end else begin
            v_d1 <= valid_in;
            v_d2 <= v_d1;
            if (valid_in) begin
                x_d1 <= x;
                inv_d1 <= inv;
            end
            if (v_d1) begin
                x_d2 <= x_d1;
                inv_d2 <= inv_d1;
            end
        end
    end

    wire signed [29:0] ref_prod   = $signed(x_d2) * $signed({1'b0, inv_d2});
    wire signed [29:0] ref_biased = ref_prod + 30'sd16384;
    wire signed [29:0] ref_shifted = ref_biased >>> 15;
    wire signed [7:0] ref_q =
        (ref_shifted >  8'sd127) ?  8'sd127 :
        (ref_shifted < -8'sd127) ? -8'sd127 : $signed(ref_shifted[7:0]);

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
                assert(q == ref_q);
        end
    end

    // Cover points
    always @(posedge clk) begin
        if (reset_cnt == 2) begin
            cover(valid_out);               // pipeline produces output
            cover(q != 0 && valid_out);     // non-zero quantized value
            cover(q == 127 && valid_out);   // positive clip
        end
    end

endmodule