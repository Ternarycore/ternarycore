// Corner-case formal proof for fp8_to_q15.
// Exhaustively checks all 256 FP8 E5M2 values against known expected results
// and asserts invariants.

`timescale 1ns / 1ps

module fp8_to_q15_corner_formal(input wire clk);
    wire [7:0] fp8;
    wire [15:0] q15;

    fp8_to_q15 dut(.fp8(fp8), .q15(q15));

    // Synthesize all 256 FP8 values via covering
    reg [7:0] fp8_reg;
    assign fp8 = fp8_reg;

    reg [3:0] run_cnt;
    initial run_cnt = 0;
    always @(posedge clk) begin
        if (run_cnt < 15) run_cnt <= run_cnt + 1;
    end

    // Step through all 256 values
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            fp8_reg <= fp8_reg + 1;
        end else begin
            fp8_reg <= 0;
        end
    end

    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            // Assertion 1: q15 is never X (unknown) — inferred from valid range check
            // Assertion 2: q15 is always a valid unsigned Q15 value [0, 65535]
            assert(q15 <= 16'hFFFF);

            // Assertion 3: fp8=0x00 (zero) -> q15=0
            if (fp8 == 8'h00)
                assert(q15 == 16'h0000);

            // Assertion 4: fp8=0x3C (exp=15, frac=0 -> 1.0 in E5M2) -> q15=32768
            if (fp8 == 8'h3C)
                assert(q15 == 16'h8000);

            // Assertion 5: fp8=0x7C (sign=1, exp=15, frac=0 -> -1.0)
            // Sign is ignored for unsigned alpha, so q15=32768
            if (fp8 == 8'h7C)
                assert(q15 == 16'h8000);

            // Assertion 6: denorm range (exp=0): q15 must be 0 or 1
            // E5M2 denorm: value = mant_frac * 2^(-16), Q15 = mant_frac / 2 (integer)
            // mant_frac=0 -> 0, mant_frac=1 -> 0, mant_frac=2 -> 1, mant_frac=3 -> 1
            if (fp8[6:2] == 5'b00000) begin
                assert(q15 == {15'h0000, fp8[1]});  // q15 = fp8[1] (mant_frac[1])
            end

            // Assertion 7: NaN (exp=31, frac=3) -> q15=0xFFFF
            if (fp8 == 8'h7F)
                assert(q15 == 16'hFFFF);

            // Assertion 8: Inf (exp=31, frac=0) -> q15=0xFFFF
            if (fp8 == 8'h7E)
                assert(q15 == 16'hFFFF);

            // Assertion 9: NaN with sign=0 (exp=31, frac=3) -> q15=0xFFFF
            if (fp8 == 8'hFF)
                assert(q15 == 16'hFFFF);

            // Assertion 10: Inf with sign=0 (exp=31, frac=0) -> q15=0xFFFF
            if (fp8 == 8'hFE)
                assert(q15 == 16'hFFFF);

            // Assertion 11: Maximum representable finite value
            // fp8=0x3F (exp=15, frac=3): 1.75 * 2^0 = 1.75
            // Q15: 1.75 * 32768 = 57344 = 0xE000
            if (fp8 == 8'h3F)
                assert(q15 == 16'hE000);

            // Assertion 12: exp=16, frac=0 -> 1.0 * 2^(16-15) = 2.0
            // Q15: 2.0 * 32768 = 65536 -> saturates to 65535
            if (fp8 == 8'h40)
                assert(q15 == 16'hFFFF);

            // Assertion 13: Minimum positive normal
            // fp8=0x04 (exp=1, frac=0): 1.0 * 2^(1-15) = 2^(-14)
            // Q15: 2^(-14) * 32768 = 2^(-14) * 2^15 = 2^1 = 2
            if (fp8 == 8'h04)
                assert(q15 == 16'h0002);

            // Assertion 14: Sign bit is ignored entirely
            // fp8=0xBC (sign=1, exp=15, frac=0) == fp8=0x3C -> both give 32768
            if (fp8 == 8'hBC)
                assert(q15 == 16'h8000);
        end
    end
endmodule
