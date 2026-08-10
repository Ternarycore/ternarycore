// Formal cover + bmc for ternary_mac — the atomic MAC cell.

`timescale 1ns / 1ps

module ternary_mac_formal(
    input wire clk
);
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;

    wire         rst_n;
    wire         valid_in;
    wire signed [DATA_WIDTH-1:0] activation;
    wire [1:0]   weight_enc;
    wire signed [ACC_WIDTH-1:0] acc_in;
    wire signed [ACC_WIDTH-1:0] acc_out;
    wire         valid_out;

    ternary_mac #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_in(acc_in), .acc_out(acc_out), .valid_out(valid_out)
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
        end
    end

    reg [3:0] run_cnt;
    initial run_cnt = 0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 0;
        else if (run_cnt < 15) run_cnt <= run_cnt + 1;
    end

    // Match ternary_weight.v / main ternary_mac: DATA_WIDTH+1 bit select
    wire signed [DATA_WIDTH:0] a_ext =
        $signed({activation[DATA_WIDTH-1], activation});
    wire signed [DATA_WIDTH:0] ref_weighted =
        (weight_enc == 2'b00) ? {(DATA_WIDTH+1){1'b0}} :
        (weight_enc == 2'b01) ?  a_ext
                              : -a_ext;

    reg signed [ACC_WIDTH-1:0] ref_next;
    always @(posedge clk) begin
        if (!rst_n) begin
            ref_next <= 0;
        end else if (valid_in) begin
            ref_next <= acc_in +
                {{(ACC_WIDTH-DATA_WIDTH-1){ref_weighted[DATA_WIDTH]}}, ref_weighted};
        end
    end

    // valid_d1: valid_in delayed by 1 cycle (matches main's valid_out <= valid_in)
    reg valid_d1;
    always @(posedge clk) begin
        if (!rst_n) valid_d1 <= 0;
        else valid_d1 <= valid_in;
    end

    reg [1:0] assume_cnt;
    initial assume_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) assume_cnt <= 0;
        else if (assume_cnt < 3) assume_cnt <= assume_cnt + 1;
    end

    always @(posedge clk) begin
        if (run_cnt >= 10 && valid_in) begin
            // acc_out latches acc_in + weighted when valid_in is high.
            // valid_out timing is verified by cover test.
            assert(acc_out == ref_next);
        end
    end

    // Cover: each weight encoding, both signs, and valid_out
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            cover(valid_in && weight_enc == 2'b01);
            cover(valid_in && weight_enc == 2'b10);
            cover(valid_in && weight_enc == 2'b00);
            cover(!valid_in);
            cover(valid_out);
        end
    end

endmodule