// 64-lane base-243 decode stage: 13 pbytes bytes (one weight row) -> the
// 128-bit w_data (64 x 2-bit codes) the ternary array's feeder expects.
// Drops straight in front of ternary_gemm_stream's w_data port when the weight
// store holds base-243 bytes instead of 2-bit words. Combinational.
module weight_decode243_row #(
    parameter COLS   = 64,
    parameter NBYTES = (COLS + 4) / 5   // 13
) (
    input  wire [8*NBYTES-1:0]  pbytes,   // 104 bits
    output wire [2*COLS-1:0]    w_data     // 128 bits
);
    wire [10*NBYTES-1:0] all;              // 13 x 5 x 2-bit = 130 bits
    genvar i;
    generate
        for (i = 0; i < NBYTES; i = i + 1) begin : g_dec
            trit_decode243 u (
                .b     (pbytes[i*8 +: 8]),
                .codes (all[i*10 +: 10])
            );
        end
    endgenerate
    assign w_data = all[0 +: 2*COLS];      // first 64 codes; 1 pad slot dropped
endmodule
