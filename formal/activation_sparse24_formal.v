`timescale 1ns / 1ps
module activation_sparse24_formal;
    reg clk, rst_n, valid_in;
    reg signed [7:0] x0,x1,x2,x3;
    wire valid_out; wire [3:0] keep_mask; wire [1:0] keep_count;
    wire signed [7:0] value0,value1;
    reg [1:0] reset_count; reg rst_d, valid_d;
    reg signed [7:0] x0_d,x1_d,x2_d,x3_d;
    initial begin
        reset_count=0; rst_d=0; valid_d=0;
        x0_d=0; x1_d=0; x2_d=0; x3_d=0;
    end
    activation_sparse24 dut (.*);

    always @(posedge clk) begin
        if (reset_count < 2) begin
            assume(!rst_n); reset_count <= reset_count + 1;
        end else begin
            assume(rst_n);
            if (rst_d && valid_d) begin
                assert(valid_out);
                assert($unsigned(keep_mask[0]) + $unsigned(keep_mask[1]) +
                       $unsigned(keep_mask[2]) + $unsigned(keep_mask[3]) <= 2);
                assert(keep_count == $unsigned(keep_mask[0]) + $unsigned(keep_mask[1]) +
                       $unsigned(keep_mask[2]) + $unsigned(keep_mask[3]));
                if (keep_mask[0]) assert(value0==x0_d || value1==x0_d);
                if (keep_mask[1]) assert(value0==x1_d || value1==x1_d);
                if (keep_mask[2]) assert(value0==x2_d || value1==x2_d);
                if (keep_mask[3]) assert(value0==x3_d || value1==x3_d);
                if (!keep_mask[0] && !keep_mask[1] && !keep_mask[2] && !keep_mask[3]) begin
                    assert(value0==0 && value1==0);
                end
            end else if (rst_d) begin
                assert(!valid_out);
            end
        end
        rst_d <= rst_n; valid_d <= valid_in;
        x0_d <= x0; x1_d <= x1; x2_d <= x2; x3_d <= x3;
    end
endmodule
