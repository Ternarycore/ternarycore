`timescale 1ns / 1ps
module ternary_lut4_bram_formal;
    reg clk,rst_n,wr_en,query_valid;
    reg [6:0] wr_addr,query_addr; reg signed [15:0] wr_data;
    wire result_valid,error_out; wire signed [15:0] result;
    reg [1:0] reset_count; reg rst_d,query_d,wr_d;
    reg [6:0] query_addr_d,wr_addr_d; reg signed [15:0] wr_data_d;
    reg [80:0] valid_shadow;
    initial begin
        reset_count=0;rst_d=0;query_d=0;wr_d=0;
        query_addr_d=0;wr_addr_d=0;wr_data_d=0;
        valid_shadow=0;
    end
    ternary_lut4_bram dut (.*);
    always @(posedge clk) begin
        if(reset_count<2) begin assume(!rst_n);reset_count<=reset_count+1;end
        else begin
            assume(rst_n);
            if(rst_d && query_d) begin
                if (query_addr_d < 81) begin
                    if (valid_shadow[query_addr_d] ||
                        (wr_d && wr_addr_d < 81 && wr_addr_d == query_addr_d)) begin
                        assert(result_valid);
                        assert(!error_out);
                    end else begin
                        assert(!result_valid);
                        assert(error_out);
                    end
                    if (wr_d && wr_addr_d < 81 && wr_addr_d == query_addr_d)
                        assert(result == wr_data_d);
                end else begin
                    assert(!result_valid && error_out);
                end
            end else if(rst_d) begin
                assert(!result_valid && !error_out);
            end
        end
        if (!rst_n)
            valid_shadow <= 0;
        else if (wr_en && wr_addr < 81)
            valid_shadow[wr_addr] <= 1'b1;
        rst_d<=rst_n;query_d<=query_valid;query_addr_d<=query_addr;
        wr_d<=wr_en;wr_addr_d<=wr_addr;wr_data_d<=wr_data;
    end
endmodule
