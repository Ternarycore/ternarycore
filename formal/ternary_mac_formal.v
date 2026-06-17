// Formal wrapper for ternary_mac — cover mode.
// Enforces a 2-cycle reset to prevent vacuous passes from unconstrained
// register initial states. Cover points check post-reset behavior.

`timescale 1ns / 1ps

module ternary_mac_formal(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] activation,
    input wire [1:0] weight_enc,
    input wire [31:0] acc_in
);
    wire [31:0] acc_out;
    wire        valid_out;

    ternary_mac #(.DATA_WIDTH(8), .ACC_WIDTH(32)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_in(acc_in), .acc_out(acc_out), .valid_out(valid_out)
    );

    // ── Explicit reset sequence ──────────────────────────────────
    // Forces rst_n low for 2 cycles then high forever. Prevents the
    // solver from starting with rst_n=1 and unconstrained registers.
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

    // Pipeline delay flop for weight_enc so cover checks align with
    // the cycle when valid_out reflects the weight that was applied.
    reg [1:0] weight_enc_q;
    always @(posedge clk) begin
        if (valid_in && rst_n)
            weight_enc_q <= weight_enc;
    end

    // ── Cover points (only after reset is complete) ──────────────
    always @(posedge clk) begin
        if (reset_cnt == 2) begin
            cover(valid_out);                              // valid_out asserts
            cover(acc_out != 0);                           // non-zero output
            cover(valid_out && acc_out != 0);             // valid non-zero result
            cover(valid_in && !valid_out);                // pipeline latency
            cover(weight_enc_q == 2'b01 && valid_out);    // +1 weight reaches output
            cover(weight_enc_q == 2'b10 && valid_out);    // -1 weight reaches output
        end
    end

endmodule