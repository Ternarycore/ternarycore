// tb_int8_dot.v -- int8 x int8 through the unmodified ternary datapath.
// int8_expand emits the eight partial products; ternary_weight accumulates
// them. If the sum equals a*b over the full corner set, attention can run on
// the array with no multiplier and no DSP slice.
`timescale 1ns / 1ps
`default_nettype none

module tb_int8_dot;
    localparam DW = 16, AW = 32;
    reg clk = 0, rst_n = 0, valid_in = 0;
    reg signed [7:0] a = 0, b = 0;
    wire ready, valid_out;
    wire [DW-1:0] act;
    wire [1:0] enc;
    wire [AW-1:0] wext;
    reg signed [AW-1:0] acc = 0;
    integer errors = 0, i, j, n = 0;
    always #5 clk = ~clk;

    int8_expand #(.DATA_WIDTH(DW)) u_x (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in), .a(a), .b(b),
        .ready(ready), .valid_out(valid_out),
        .activation(act), .weight_enc(enc));

    ternary_weight #(.DATA_WIDTH(DW), .ACC_WIDTH(AW)) u_w (
        .activation(act), .weight_enc(enc), .weighted_ext(wext));

    always @(posedge clk) if (valid_out) acc <= acc + $signed(wext);

    task product(input signed [7:0] x, input signed [7:0] y);
        begin
            @(negedge clk); acc = 0; a = x; b = y; valid_in = 1;
            @(negedge clk); valid_in = 0;
            repeat (11) @(posedge clk);
            n = n + 1;
            if (acc !== (x * y)) begin
                $display("FAIL %0d x %0d: got %0d want %0d", x, y, acc, x*y);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        repeat (3) @(negedge clk); rst_n = 1;
        // corners first: the values that break naive implementations
        product(-128, -128); product(-128,  127); product( 127, -128);
        product(-128,    1); product(   1, -128); product(-128,    0);
        product( 127,  127); product(  -1,   -1); product(   0,    0);
        // then a deterministic sweep across the space
        for (i = -128; i < 128; i = i + 17)
            for (j = -128; j < 128; j = j + 13)
                product(i[7:0], j[7:0]);
        if (errors == 0)
            $display("TB PASS: %0d int8 products exact via ternary partials", n);
        else
            $display("TB FAIL: %0d of %0d wrong", errors, n);
        $finish;
    end
endmodule
`default_nettype wire
