// Formal wrapper for ternary_mac — cover mode.
// Checks reachability: can we observe valid_out assertions,
// non-zero outputs, and pipeline behavior?

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

    // Cover points: can we observe these behaviors?
    always @(posedge clk) begin
        cover(valid_out);                              // valid_out asserts
        cover(acc_out != 0 && rst_n);                  // non-zero output after reset
        cover(valid_out && acc_out != 0);             // valid non-zero result
        cover(valid_in && !valid_out);                // pipeline latency
        cover(weight_enc == 2'b01 && valid_out);      // +1 weight reaches output
        cover(weight_enc == 2'b10 && valid_out);      // -1 weight reaches output
    end

endmodule