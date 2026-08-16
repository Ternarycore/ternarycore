`timescale 1ns / 1ps

module activation_quant_int4_formal;
    reg clk, rst_n, valid_in;
    reg signed [7:0] x;
    reg [18:0] inv;
    wire signed [3:0] q;
    wire valid_out;
    reg [1:0] reset_count;
    reg valid_d1, valid_d2, rst_d1, rst_d2;
    reg signed [26:0] product_d1, product_d2;

    initial begin
        reset_count = 0;
        valid_d1 = 0; valid_d2 = 0;
        rst_d1 = 0; rst_d2 = 0;
        product_d1 = 0; product_d2 = 0;
    end

    wire signed [26:0] round_amt = 27'sd16384;
    wire signed [26:0] biased = product_d2 + round_amt;
    wire signed [26:0] shifted = biased >>> 15;
    wire signed [26:0] expected = (shifted > 7) ? 7 :
                                   (shifted < -7) ? -7 : shifted;

    activation_quant #(
        .DATA_WIDTH(8), .Q_WIDTH(4), .PRECISION(15), .INV_WIDTH(19)
    ) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in), .x(x), .inv(inv),
        .q(q), .valid_out(valid_out)
    );

    always @(posedge clk) begin
        if (reset_count < 2) begin
            assume(!rst_n);
            reset_count <= reset_count + 1;
        end else begin
            assume(rst_n);
            if (rst_d2 && valid_d2) begin
                assert(valid_out);
                assert($signed(q) == expected);
                assert($signed(q) >= -7);
                assert($signed(q) <= 7);
            end else if (rst_d2) begin
                assert(!valid_out);
            end
        end
        valid_d1 <= valid_in;
        valid_d2 <= valid_d1;
        rst_d1 <= rst_n;
        rst_d2 <= rst_d1;
        product_d1 <= x * $signed({1'b0, inv});
        product_d2 <= product_d1;
    end
endmodule
