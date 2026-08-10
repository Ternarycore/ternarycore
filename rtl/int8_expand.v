// int8_expand.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// Turns one int8 x int8 product into eight ternary operations, so attention's
// activation-by-activation matmuls can run on the existing ternary array.
//
//     a * b  =  sum(k=0..6) b_k * (a << k)  -  b_7 * (a << 7)
//
// Every term is zero, plus a shifted activation, or minus one -- exactly what
// ternary_weight already selects. So the array needs no change: this sits in
// front of it and emits the eight partial products, and ternary_dot's normal
// accumulation produces the product.
//
// Cost: 8 cycles per MAC per lane. With COLS=64 that is 8 MACs/cycle against
// the soft CPU's 1 per 12.7 cycles -- about 100x, using no DSP slices.

`default_nettype none

module int8_expand #(
    parameter DATA_WIDTH = 16          // must hold a << 7 for int8 a
) (
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   valid_in,
    input  wire signed [7:0]      a,           // activation operand
    input  wire        [7:0]      b,           // second operand, bit-serialised
    output wire                   ready,       // may accept a new pair
    output reg                    valid_out,
    output reg  [DATA_WIDTH-1:0]  activation,
    output reg  [1:0]             weight_enc
);

    reg  signed [7:0] a_r;
    reg         [7:0] b_r;
    reg         [3:0] k;               // 0..7, plus an idle value of 8
    wire busy = (k != 4'd8);
    assign ready = !busy;

    // The k=7 term is subtracted: in two's complement the top bit carries
    // negative weight. That is the only asymmetry in the whole scheme.
    wire [1:0] code = (b_r[k[2:0]] == 1'b0) ? 2'b00
                    : (k == 4'd7)          ? 2'b10
                                           : 2'b01;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            k          <= 4'd8;
            valid_out  <= 1'b0;
            activation <= {DATA_WIDTH{1'b0}};
            weight_enc <= 2'b00;
            a_r        <= 8'sd0;
            b_r        <= 8'd0;
        end else if (!busy) begin
            valid_out <= 1'b0;
            if (valid_in) begin a_r <= a; b_r <= b; k <= 4'd0; end
        end else begin
            activation <= $signed(a_r) <<< k[2:0];
            weight_enc <= code;
            valid_out  <= 1'b1;
            k          <= (k == 4'd7) ? 4'd8 : (k + 4'd1);
        end
    end

endmodule

`default_nettype wire
