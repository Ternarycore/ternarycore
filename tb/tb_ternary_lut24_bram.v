`timescale 1ns / 1ps
module tb_ternary_lut24_bram;
    reg clk=0, rst_n=0, load_valid=0, query_valid=0;
    reg [3:0] keep_mask; reg signed [7:0] x0,x1,x2,x3; reg [7:0] packed_weights;
    wire busy,ready,result_valid,error_out; wire signed [15:0] result;
    integer errors=0;
    always #5 clk=~clk;
    ternary_lut24_bram dut(.*);
    task load;
        begin @(negedge clk); load_valid=1; @(posedge clk); #1; load_valid=0;
              wait(!busy); @(negedge clk); end
    endtask
    task query(input [7:0] weights,input integer expected);
        begin @(negedge clk); packed_weights=weights; query_valid=1;
              @(posedge clk); #1;
              if (!result_valid || error_out || result !== expected) begin
                  $display("FAIL weights=%h result=%0d expected=%0d",weights,result,expected); errors=errors+1;
              end
              query_valid=0; end
    endtask
    initial begin
        keep_mask=4'b0101; x0=3; x1=-2; x2=5; x3=1; packed_weights=0;
        repeat(2) @(posedge clk); rst_n=1; load();
        query(8'b00000000,0);       // both selected weights zero
        query(8'b00000100,0);       // unselected lane 1 = +1
        query(8'b00010000,5);       // selected lane 2 = +1
        query(8'b00000001,3);       // selected lane 0 = +1
        query(8'b00100001,-2);      // lane 0 = +1, lane 2 = -1
        query(8'b00001000,0);       // unselected lane does not affect the compact key
        @(negedge clk); packed_weights=8'b00000011; query_valid=1;
        @(posedge clk); #1;
        if (error_out == 0 || result_valid) begin
            $display("FAIL reserved selected encoding"); errors=errors+1;
        end
        query_valid=0;
        @(negedge clk); keep_mask=4'b0001; load_valid=1;
        @(posedge clk); #1;
        if (!error_out || busy) begin $display("FAIL one-lane mask accepted"); errors=errors+1; end
        load_valid=0; keep_mask=4'b0101;
        if (errors != 0) $fatal(1,"compact ternary LUT regression failed");
        $display("compact ternary LUT regression: PASS"); $finish;
    end
    initial begin #10000; $fatal(1,"compact LUT timeout"); end
endmodule
