`timescale 1ns / 1ps
module tb_ternary_sparse_lut_stream;
    reg clk=0,rst_n=0,activation_valid=0,weight_valid=0;
    reg signed [7:0] x0,x1,x2,x3; reg [7:0] packed_weights;
    wire busy,ready; wire [3:0] keep_mask; wire [1:0] keep_count;
    wire signed [7:0] kept_value0, kept_value1;
    wire result_valid,error_out; wire signed [15:0] result;
    integer errors=0;
    always #5 clk=~clk;
    ternary_sparse_lut_stream dut(.*);
    initial begin
        x0=3;x1=-2;x2=5;x3=1;packed_weights=0;
        repeat(2) @(posedge clk); rst_n=1;
        @(negedge clk); activation_valid=1;
        @(posedge clk); #1; activation_valid=0;
        wait(ready);
        if (keep_mask !== 4'b0101 || keep_count !== 2) begin
            $display("FAIL sparse metadata mask=%b count=%0d",keep_mask,keep_count); errors=errors+1;
        end
        @(negedge clk); packed_weights=8'h21; weight_valid=1;
        @(posedge clk); #1;
        if (!result_valid || error_out || result !== -2) begin
            $display("FAIL streamed result=%0d expected=-2",result); errors=errors+1;
        end
        weight_valid=0;
        @(negedge clk); packed_weights=8'h03; weight_valid=1;
        @(posedge clk); #1;
        if (result_valid || !error_out) begin
            $display("FAIL streamed reserved code"); errors=errors+1;
        end
        weight_valid=0;
        if (errors != 0) $fatal(1,"sparse stream regression failed");
        $display("sparse ternary LUT stream: PASS"); $finish;
    end
    initial begin #10000; $fatal(1,"sparse stream timeout"); end
endmodule
