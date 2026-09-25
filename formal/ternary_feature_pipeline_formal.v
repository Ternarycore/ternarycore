`timescale 1ns / 1ps
module ternary_feature_pipeline_formal;
    reg clk, rst_n, activation_valid, weight_valid;
    reg signed [7:0] x0,x1,x2,x3;
    reg [7:0] packed_weights;
    wire busy,ready; wire [3:0] keep_mask; wire [1:0] keep_count;
    wire signed [7:0] kept_value0,kept_value1; wire [9:0] decoded_weights;
    wire result_valid,error_out; wire signed [15:0] result;
    reg [1:0] reset_count;

    initial begin reset_count=0; end
    ternary_feature_pipeline dut (.*);

    always @(posedge clk) begin
        if (reset_count < 2) begin
            assume(!rst_n);
            reset_count <= reset_count + 1'b1;
        end else begin
            assume(rst_n);
            assert(!(busy && ready));
            if (keep_count > 2) assert(1'b0);
            if (keep_mask == 0) assert(keep_count == 0);
        end
    end
endmodule
