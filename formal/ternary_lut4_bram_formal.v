`timescale 1ns / 1ps
module ternary_lut4_bram_formal;
    reg clk,rst_n,wr_en,query_valid;
    reg [6:0] wr_addr,query_addr; reg signed [15:0] wr_data;
    wire result_valid,error_out; wire signed [15:0] result;
    reg [1:0] reset_count; reg rst_d,query_d; reg [6:0] query_addr_d;
    initial begin reset_count=0;rst_d=0;query_d=0;query_addr_d=0;end
    ternary_lut4_bram dut (.*);
    always @(posedge clk) begin
        if(reset_count<2) begin assume(!rst_n);reset_count<=reset_count+1;end
        else begin
            assume(rst_n);
            if(rst_d && query_d) begin
                assert(result_valid == (query_addr_d < 81));
                assert(error_out == (query_addr_d >= 81));
            end else if(rst_d) begin
                assert(!result_valid && !error_out);
            end
        end
        rst_d<=rst_n;query_d<=query_valid;query_addr_d<=query_addr;
    end
endmodule
