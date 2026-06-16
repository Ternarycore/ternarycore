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
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!rst_n);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(rst_n);
        end
    end

    wire signed [31:0] ch0 = result[31:0];

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