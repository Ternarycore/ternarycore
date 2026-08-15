// tb_ternary_mac_ext.v -- widened MAC + the corner the old TB never tried.
// Two's-complement negation overflows at the datapath width: -(-2^(N-1))
// is not representable in N bits and wraps to itself. A weight of -1 times
// the most negative activation therefore comes out with the wrong sign.
`timescale 1ns / 1ps
`default_nettype none

module tb_ternary_mac_ext;
    parameter DW = 8, AW = 32;
    reg clk = 0, rst_n = 0, valid_in = 0;
    reg [DW-1:0] activation = 0;
    reg [1:0] weight_enc = 0;
    reg [AW-1:0] acc_in = 0;
    wire [AW-1:0] acc_out;
    wire valid_out;
    integer errors = 0;
    always #5 clk = ~clk;

    ternary_mac #(.DATA_WIDTH(DW), .ACC_WIDTH(AW)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_in(acc_in), .acc_out(acc_out), .valid_out(valid_out));

    task check(input signed [DW-1:0] a, input [1:0] w,
               input signed [AW-1:0] base, input signed [AW-1:0] want,
               input [200:0] name);
        begin
            @(negedge clk);
            activation = a; weight_enc = w; acc_in = base; valid_in = 1;
            @(negedge clk); valid_in = 0;
            @(posedge clk); #1;
            if ($signed(acc_out) !== want) begin
                $display("FAIL %0s: a=%0d w=%b base=%0d got %0d want %0d",
                         name, a, w, base, $signed(acc_out), want);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        repeat (3) @(negedge clk); rst_n = 1;
        check(  50, 2'b01,    0,   50, "w=+1");
        check(  50, 2'b10,    0,  -50, "w=-1");
        check(  50, 2'b00,  123,  123, "w=0 passes acc through");
        check( -50, 2'b10,  100,  150, "w=-1 on a negative");
        check(  50, 2'b01, 1000, 1050, "accumulates");
        check(-128, 2'b10,    0,  128, "w=-1 x most-negative activation");
        check(-128, 2'b01,    0, -128, "w=+1 x most-negative activation");
        check( 127, 2'b10,    0, -127, "w=-1 x most-positive activation");
        if (errors == 0) $display("TB PASS: ternary_mac exact incl. -2^(N-1)");
        else begin
            $display("TB FAIL: %0d errors", errors);
            $fatal(1, "extended ternary MAC regression failed");
        end
        $finish;
    end

    initial begin
        #5000000;
        $fatal(1, "extended ternary MAC regression timeout");
    end
endmodule
`default_nettype wire
