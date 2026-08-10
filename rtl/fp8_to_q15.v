// SPDX-License-Identifier: CERN-OHL-S-2.0
// FP8 E5M2 → unsigned Q15 decoder for alpha scales (not E4M3).
// 1.0 = 32768 in Q15. Feeds directly into ternary_scale.alpha.
// fp8[7] (IEEE-style sign) is intentionally ignored: per-channel alphas
// are non-negative magnitudes in unsigned Q15.

`timescale 1ns / 1ps

module fp8_to_q15 (
    input  wire [7:0] fp8,
    output reg [15:0] q15
);

    // E5M2 layout: [7]=sign (unused), [6:2]=exp, [1:0]=frac
    wire [4:0] mant_exp = fp8[6:2];
    wire [1:0] mant_frac = fp8[1:0];

    wire [15:0] base = 16'h8000 | ({{14{1'b0}}, mant_frac} << 13);

    always @(*) begin
        if (mant_exp == 0)
            q15 = ({{14{1'b0}}, mant_frac} << 13) >> 14;
        else if (mant_exp > 15)
            q15 = (base > (16'hFFFF >> (mant_exp - 15))) ? 16'hFFFF : (base << (mant_exp - 15));
        else if (mant_exp == 15)
            q15 = base;
        else
            q15 = base >> (15 - mant_exp);
    end

endmodule
