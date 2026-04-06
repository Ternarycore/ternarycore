// tb_ternary_mac.v
// Testbench for the ternary_mac cell.
// Tests all three weight paths (+1, -1, 0) and accumulation correctness.
//
// Run with: iverilog -o sim_mac tb/tb_ternary_mac.v rtl/ternary_mac.v && ./sim_mac

`timescale 1ns / 1ps

module tb_ternary_mac;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;

    // DUT signals
    reg                  clk;
    reg                  rst_n;
    reg                  valid_in;
    reg  [DATA_WIDTH-1:0] activation;
    reg  [1:0]            weight_enc;
    reg  [ACC_WIDTH-1:0]  acc_in;
    wire [ACC_WIDTH-1:0]  acc_out;
    wire                  valid_out;

    // Instantiate DUT
    ternary_mac #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_in(acc_in), .acc_out(acc_out), .valid_out(valid_out)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz

    // Waveform dump
    initial begin
        $dumpfile("tb_ternary_mac.vcd");
        $dumpvars(0, tb_ternary_mac);
    end

    integer errors = 0;

    task apply_and_check;
        input signed [DATA_WIDTH-1:0] act;
        input [1:0] wenc;
        input signed [ACC_WIDTH-1:0] acc;
        input signed [ACC_WIDTH-1:0] expected;
        begin
            activation = act;
            weight_enc = wenc;
            acc_in     = acc;
            valid_in   = 1;
            @(posedge clk); #1;
            valid_in = 0;
            @(posedge clk); #1;
            if (acc_out !== expected) begin
                $display("FAIL: act=%0d w=%0b acc_in=%0d => got %0d, expected %0d",
                         act, wenc, acc, acc_out, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: act=%0d w=%0b acc_in=%0d => acc_out=%0d",
                         act, wenc, acc, acc_out);
            end
        end
    endtask

    initial begin
        // Reset
        rst_n = 0; valid_in = 0; activation = 0; weight_enc = 0; acc_in = 0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        $display("--- TernaryCore MAC Testbench ---");

        // w=+1: acc_out should be acc_in + activation
        apply_and_check(8'd10, 2'b01, 32'd0,   32'd10);   // 0 + 10 = 10
        apply_and_check(8'd25, 2'b01, 32'd10,  32'd35);   // 10 + 25 = 35

        // w=-1: acc_out should be acc_in - activation
        apply_and_check(8'd10, 2'b10, 32'd35,  32'd25);   // 35 - 10 = 25
        apply_and_check(8'd25, 2'b10, 32'd25,  32'd0);    // 25 - 25 = 0

        // w=0: acc_out should equal acc_in unchanged
        apply_and_check(8'd99, 2'b00, 32'd42,  32'd42);   // 0 * anything = 0
        apply_and_check(8'd127,2'b00, 32'd0,   32'd0);

        // Signed activation: act = -5 (8'd251 in two's complement)
        apply_and_check(8'hFB, 2'b01, 32'd0,   -32'd5);   // +1 * (-5) = -5
        apply_and_check(8'hFB, 2'b10, 32'd0,   32'd5);    // -1 * (-5) = +5

        $display("--- %0d error(s) ---", errors);
        if (errors == 0) $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
