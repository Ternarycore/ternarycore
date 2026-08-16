`timescale 1ns / 1ps
module ternary_decompress5_formal;
    reg clk,rst_n,valid_in; reg [7:0] packed_in;
    wire valid_out,error_out; wire [9:0] weight_enc;
    reg [1:0] reset_count; reg rst_d,valid_d; reg [7:0] packed_d;
    initial begin reset_count=0;rst_d=0;valid_d=0;packed_d=0;end
    ternary_decompress5 dut (.*);

    function [9:0] expected_weights(input [7:0] code_value);
        integer n,i,d;
        begin
            n=code_value; expected_weights=0;
            for(i=0;i<5;i=i+1) begin
                d=n%3; n=n/3;
                expected_weights[i*2 +: 2]=d[1:0];
            end
        end
    endfunction

    wire expected_error = (packed_d >= 243);
    wire [9:0] expected_weight = expected_weights(packed_d);
    wire [1:0] w0=weight_enc[1:0], w1=weight_enc[3:2],
               w2=weight_enc[5:4], w3=weight_enc[7:6], w4=weight_enc[9:8];
    always @(posedge clk) begin
        if(reset_count<2) begin assume(!rst_n); reset_count<=reset_count+1; end
        else begin
            assume(rst_n);
            if(rst_d && valid_d) begin
                assert(error_out == expected_error);
                assert(valid_out == !expected_error);
                if (!expected_error) assert(weight_enc == expected_weight);
                assert(w0<=2 && w1<=2 && w2<=2 && w3<=2 && w4<=2);
            end else if(rst_d) begin
                assert(!valid_out && !error_out);
            end
        end
        rst_d<=rst_n; valid_d<=valid_in; packed_d<=packed_in;
    end
endmodule
