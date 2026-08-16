`timescale 1ns / 1ps
module tb_activation_sparse24;
    reg clk=0, rst_n=0, valid_in=0;
    reg signed [7:0] x0,x1,x2,x3;
    wire valid_out; wire [3:0] keep_mask; wire signed [7:0] value0,value1;
    integer errors=0, cases=0;
    always #5 clk=~clk;
    activation_sparse24 dut (.*);

    task automatic apply_case(input integer a,input integer b,input integer c,input integer d,
                              input [3:0] expected_mask);
        begin
            @(negedge clk); x0=a;x1=b;x2=c;x3=d;valid_in=1;
            @(posedge clk); #1; cases=cases+1;
            if (!valid_out || keep_mask !== expected_mask ||
                (keep_mask[0] && value0 != x0 && value1 != x0) ||
                (keep_mask[1] && value0 != x1 && value1 != x1) ||
                (keep_mask[2] && value0 != x2 && value1 != x2) ||
                (keep_mask[3] && value0 != x3 && value1 != x3)) begin
                $display("FAIL [%0d,%0d,%0d,%0d] mask=%b values=[%0d,%0d] expected=%b",
                         a,b,c,d,keep_mask,value0,value1,expected_mask);
                errors=errors+1;
            end
            @(negedge clk); valid_in=0;
        end
    endtask

    initial begin
        x0=0;x1=0;x2=0;x3=0; repeat(2) @(posedge clk); rst_n=1;
        apply_case(1,2,3,4,4'b1100);
        apply_case(-128,127,-64,32,4'b0011);
        apply_case(0,0,7,0,4'b0100);
        apply_case(5,-5,5,-5,4'b0011);
        apply_case(0,0,0,0,4'b0000);
        if(errors!=0) $fatal(1,"2:4 activation regression failed");
        $display("2:4 activation regression: %0d/%0d cases passed",cases,cases);
        $finish;
    end
    initial begin #10000; $fatal(1,"2:4 activation regression timeout"); end
endmodule
