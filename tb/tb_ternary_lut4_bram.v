`timescale 1ns / 1ps
module tb_ternary_lut4_bram;
    reg clk=0,rst_n=0,wr_en=0,query_valid=0;
    reg [6:0] wr_addr,query_addr; reg signed [15:0] wr_data;
    wire result_valid,error_out; wire signed [15:0] result;
    integer errors=0,cases=0;
    always #5 clk=~clk;
    ternary_lut4_bram dut (.*);

    function integer ternary_value(input integer digit);
        begin ternary_value = digit==0 ? 0 : digit==1 ? 1 : -1; end
    endfunction
    function integer dot_for_code(input integer code_value);
        integer n,i,d,total;
        begin
            n=code_value; total=0;
            for(i=0;i<4;i=i+1) begin
                d=n%3; n=n/3;
                total=total+ternary_value(d)*(i+1);
            end
            dot_for_code=total;
        end
    endfunction

    task automatic write_entry(input integer addr,input integer data);
        begin @(negedge clk); wr_addr=addr;wr_data=data;wr_en=1;
              @(posedge clk); #1; @(negedge clk);wr_en=0; end
    endtask
    task automatic query_entry(input integer addr,input integer expected);
        begin @(negedge clk);query_addr=addr;query_valid=1;
              @(posedge clk); #1; cases=cases+1;
              if(!result_valid || error_out || result!==expected) begin
                  $display("FAIL addr=%0d result=%0d expected=%0d",addr,result,expected);
                  errors=errors+1;
              end
              @(negedge clk);query_valid=0; end
    endtask
    task automatic write_and_query_entry(input integer addr,input integer new_data);
        begin @(negedge clk); wr_addr=addr;wr_data=new_data;wr_en=1;
              query_addr=addr;query_valid=1;
              @(posedge clk); #1; cases=cases+1;
              if(!result_valid || error_out || result!==new_data) begin
                  $display("FAIL write-first collision addr=%0d result=%0d expected=%0d",
                           addr,result,new_data);
                  errors=errors+1;
              end
              @(negedge clk);wr_en=0;query_valid=0; end
    endtask

    integer i;
    initial begin
        wr_addr=0;query_addr=0;wr_data=0;
        repeat(2) @(posedge clk);rst_n=1;
        for(i=0;i<81;i=i+1) write_entry(i,dot_for_code(i));
        query_entry(0,dot_for_code(0));
        query_entry(1,dot_for_code(1));
        query_entry(40,dot_for_code(40));
        query_entry(80,dot_for_code(80));
        write_and_query_entry(40,1234);
        query_entry(40,1234);
        @(negedge clk);query_addr=81;query_valid=1;
        @(posedge clk);#1;cases=cases+1;
        if(result_valid || !error_out) begin $display("FAIL invalid LUT address accepted");errors=errors+1;end
        if(errors!=0) $fatal(1,"ternary LUT BRAM regression failed");
        $display("ternary LUT BRAM regression: %0d queries passed",cases);$finish;
    end
    initial begin #20000;$fatal(1,"ternary LUT BRAM regression timeout");end
endmodule
