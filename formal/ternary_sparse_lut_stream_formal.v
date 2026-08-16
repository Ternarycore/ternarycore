module ternary_sparse_lut_stream_formal;
    reg clk, rst_n, activation_valid, weight_valid;
    reg signed [7:0] x0,x1,x2,x3; reg [7:0] packed_weights;
    wire busy,ready,activation_ready; wire [3:0] keep_mask; wire [1:0] keep_count;
    wire signed [7:0] kept_value0, kept_value1;
    wire result_valid,error_out; wire signed [15:0] result;
    ternary_sparse_lut_stream dut(.*);
    always @(posedge clk) begin
        assume(rst_n);
        assert(!(busy && ready));
        assert(activation_ready == !busy);
    end
endmodule
