`timescale 1ns / 1ps
module tb_hadamard4;
    localparam W = 8;
    localparam OW = 10;
    reg clk = 0, rst_n = 0, valid_in = 0;
    reg signed [W-1:0] x0, x1, x2, x3;
    wire valid_out;
    wire signed [OW-1:0] y0, y1, y2, y3;
    integer errors = 0, cases = 0;
    always #5 clk = ~clk;
    hadamard4 #(.DATA_WIDTH(W), .OUTPUT_WIDTH(OW)) dut (.*);

    task automatic apply_case(input integer a, input integer b,
                              input integer c, input integer d);
        integer e0, e1, e2, e3;
        begin
            e0 = a+b+c+d; e1 = a-b+c-d; e2 = a+b-c-d; e3 = a-b-c+d;
            @(negedge clk); x0=a; x1=b; x2=c; x3=d; valid_in=1;
            @(posedge clk); #1;
            cases = cases + 1;
            if (!valid_out || $signed(y0)!=e0 || $signed(y1)!=e1 ||
                $signed(y2)!=e2 || $signed(y3)!=e3) begin
                $display("FAIL valid=%b [%0d,%0d,%0d,%0d] -> [%0d,%0d,%0d,%0d] expected [%0d,%0d,%0d,%0d]",
                         valid_out,a,b,c,d,y0,y1,y2,y3,e0,e1,e2,e3);
                errors = errors + 1;
            end
            @(negedge clk); valid_in=0;
        end
    endtask

    initial begin
        x0=0; x1=0; x2=0; x3=0;
        repeat (2) @(posedge clk); rst_n=1;
        apply_case(1,2,3,4);
        apply_case(127,-128,127,-128);
        apply_case(-17,42,-99,63);
        apply_case(0,0,0,0);
        if (errors != 0) $fatal(1, "Hadamard4 regression failed");
        $display("Hadamard4 regression: %0d/%0d cases passed", cases, cases);
        $finish;
    end
    initial begin #10000; $fatal(1, "Hadamard4 regression timeout"); end
endmodule
