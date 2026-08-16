module ternary_lut24_bram_formal;
    reg clk, rst_n, load_valid, query_valid;
    reg [3:0] keep_mask;
    reg signed [7:0] x0,x1,x2,x3;
    reg [7:0] packed_weights;
    wire busy,ready,result_valid,error_out; wire signed [15:0] result;
    ternary_lut24_bram dut(.*);
    always @(posedge clk) begin
        assume(rst_n);
        assume(keep_mask == 4'b0101);
        assert(!(busy && ready));
    end
endmodule
