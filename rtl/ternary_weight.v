// ternary_weight.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// The one definition of what a ternary weight does to an activation:
// select zero, plus, or minus, and sign-extend to the accumulator width.
//
// This existed twice -- in ternary_mac.v and inlined in ternary_dot.v --
// which is why the two's-complement negation bug had to be found and fixed
// twice, and why the cell's own testbench was not protecting the copy that
// actually synthesises. One definition, two instantiations.
//
// The negation happens at DATA_WIDTH+1 bits. Two's complement has no
// +2^(N-1), so negating the most negative activation at DATA_WIDTH wraps it
// back to itself and a weight of -1 emerges with the wrong SIGN. One extra
// bit costs almost nothing and makes the cell exact over its full range --
// which the int8 attention path needs, since it feeds shifted activations
// that reach the extremes.

`default_nettype none

module ternary_weight #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
) (
    input  wire [DATA_WIDTH-1:0] activation,
    input  wire [1:0]            weight_enc,    // 00 = 0, 01 = +1, 10 = -1
    output wire [ACC_WIDTH-1:0]  weighted_ext
);

    wire signed [DATA_WIDTH:0] a_ext =
        $signed({activation[DATA_WIDTH-1], activation});

    wire signed [DATA_WIDTH:0] w =
        (weight_enc == 2'b00) ? {(DATA_WIDTH+1){1'b0}} :
        (weight_enc == 2'b01) ?  a_ext
                              : -a_ext;

    assign weighted_ext = {{(ACC_WIDTH-DATA_WIDTH-1){w[DATA_WIDTH]}}, w};

endmodule

`default_nettype wire
