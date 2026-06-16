// Formal wrapper for activation_quant — cover mode.
// Enforces 2-cycle reset. Cover points check quantizer behavior.

`timescale 1ns / 1ps

module activation_quant_formal(
    input wire       clk,
    input wire       rst_n,
    input wire       valid_in,
    input wire [7:0] x,
    input wire [21:0] inv
);
    wire [7:0] q;
    wire       valid_out;

    activation_quant #(.DATA_WIDTH(8), .PRECISION(15), .INV_WIDTH(22)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .x(x), .inv(inv), .q(q), .valid_out(valid_out)
    );

    // Reset sequence
    reg [1:0] reset_cnt;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!rst_n);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(rst_n);
        end
    end

    // Cover points
    always @(posedge clk) begin
        if (reset_cnt == 2) begin
            cover(valid_out);               // pipeline produces output
            cover(q != 0 && valid_out);     // non-zero quantized value
            cover(q == 127 && valid_out);   // positive clip
        end
    end

endmodule