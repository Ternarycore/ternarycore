`timescale 1ns / 1ps

module hadamard4_formal;
    reg clk, rst_n, valid_in;
    reg signed [7:0] x0, x1, x2, x3;
    wire valid_out;
    wire signed [9:0] y0, y1, y2, y3;
    reg [1:0] reset_count;
    reg valid_d;
    reg rst_d;
    reg signed [7:0] x0_d, x1_d, x2_d, x3_d;

    initial begin
        reset_count = 0; valid_d = 0; rst_d = 0;
        x0_d = 0; x1_d = 0; x2_d = 0; x3_d = 0;
    end

    wire signed [9:0] sx0 = {{2{x0_d[7]}}, x0_d};
    wire signed [9:0] sx1 = {{2{x1_d[7]}}, x1_d};
    wire signed [9:0] sx2 = {{2{x2_d[7]}}, x2_d};
    wire signed [9:0] sx3 = {{2{x3_d[7]}}, x3_d};

    hadamard4 dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .valid_out(valid_out), .y0(y0), .y1(y1), .y2(y2), .y3(y3)
    );

    always @(posedge clk) begin
        if (reset_count < 2) begin
            assume(!rst_n);
            reset_count <= reset_count + 1;
        end else begin
            assume(rst_n);
            if (rst_d && valid_d) begin
                assert(valid_out);
                assert(y0 == sx0 + sx1 + sx2 + sx3);
                assert(y1 == sx0 - sx1 + sx2 - sx3);
                assert(y2 == sx0 + sx1 - sx2 - sx3);
                assert(y3 == sx0 - sx1 - sx2 + sx3);
            end else if (rst_d) begin
                assert(!valid_out);
            end
        end
        valid_d <= valid_in;
        rst_d <= rst_n;
        x0_d <= x0; x1_d <= x1; x2_d <= x2; x3_d <= x3;
    end
endmodule
