// Formal wrapper for ternary_dot — cover mode.
// Enforces a 2-cycle reset to prevent vacuous passes.

`timescale 1ns / 1ps

module ternary_dot_formal(
    input wire       clk,
    input wire       rst_n,
    input wire       valid_in,
    input wire [7:0] activation,
    input wire [1:0] weight_enc
);
    parameter VECTOR_LEN = 4;

    wire [31:0] acc_out;
    wire        valid_out;

    ternary_dot #(.DATA_WIDTH(8), .ACC_WIDTH(32), .VECTOR_LEN(VECTOR_LEN)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out)
    );

    // ── Explicit reset sequence ──────────────────────────────────
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

    // ── Cover points ─────────────────────────────────────────────
    always @(posedge clk) begin
        if (reset_cnt == 2) begin
            cover(valid_out);                              // vector complete
            cover(valid_out && acc_out != 0);              // non-zero result
            cover(valid_out && acc_out == 0);              // zero result (weights=0)
        end
    end

endmodule