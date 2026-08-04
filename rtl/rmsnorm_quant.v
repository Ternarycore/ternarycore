// rmsnorm_quant.v -- fused RMSNorm + absmax int8 quantizer, in fabric
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// This replaces nq_core, which measured 32.05 cycles per element for the sum
// of squares and 18.02 for the quantizer -- 183 ms of a 744 ms token, and
// about 9 seconds of a 20 second MNLI classification, where the per-token CPU
// work scales with prompt length and the weight paging does not.
//
// Three streaming passes at one element per cycle:
//
//   pass 1   amx = max|x|,  then xs from the 2047 rule
//   pass 2   u = x >>> xs ; ss += u*u ; t = x*g ; mx = max|t|
//   divide   r = (127 << RECIP_SH) / mxs                once per vector
//   pass 3   o8 = clip(round(ts * r >> RECIP_SH), -128, 127)
//
// On the reciprocal. nq_core forms (127 << 46)/mx and multiplies a 32-bit t
// by that 53-bit value -- a 54-bit product, three or four DSP slices. That
// precision cannot reach the output: the result is eight bits, so an error of
// one part in 2^20 moves it by 1e-4 of a level. Reducing mx and t by a common
// shift first makes the multiply 21 x 44, and the bits that matter fit in
// LUTs. The "zero DSP slices" claim is about the ternary MAC array and holds
// either way, but there is no reason to spend DSPs computing bits that are
// discarded.
//
// RECIP_SH and MXS_W are parameters because their right values are a question
// for the testbench rather than for me: it compares against vectors captured
// from the board running nq_core, and counts the elements that disagree.
//
// The sum of squares is 48-bit and renormalized the way the fixed nq_core
// does -- ss >>= 2 with xs += 1, which leaves ss * 4^xs unchanged. The
// original 32-bit accumulator only bounded n = 1024, and two of the four
// RMSNorms in every block are wider than that.

`default_nettype none

module rmsnorm_quant #(
    parameter MAXN     = 4096,
    parameter AW       = 13,     // address width, covers MAXN
    parameter MXS_W    = 20,     // mx is reduced to this width before dividing
    parameter RECIP_SH = 36      // fractional bits held in the reciprocal
)(
    input  wire               clk,
    input  wire               rst_n,

    // control
    input  wire               start,
    input  wire [AW-1:0]      n,
    output reg                busy,
    output reg                done,

    // reductions, valid while done
    output reg  [31:0]        o_mx,
    output reg  [31:0]        o_ss,
    output reg  [4:0]         o_xs,

    // input vectors, written before start
    input  wire               xw_en,
    input  wire [AW-1:0]      xw_addr,
    input  wire signed [31:0] xw_data,
    input  wire               gw_en,
    input  wire [AW-1:0]      gw_addr,
    input  wire signed [31:0] gw_data,

    // int8 result, readable while done
    input  wire [AW-1:0]      o8_addr,
    output wire signed [7:0]  o8_data,

    // four packed int8 at a word index, for the AXI read channel: the
    // CDMA moves the result out 32 bits at a time, not a byte at a time
    input  wire [AW-3:0]      o8_widx,
    output wire [31:0]        o8_word
);

    localparam S_IDLE = 4'd0, S_P1 = 4'd1, S_XS  = 4'd2, S_P2 = 4'd3,
               S_NORM = 4'd4, S_DIV = 4'd5, S_P3 = 4'd6, S_END = 4'd7;

    localparam NUM_W = 7 + RECIP_SH;             // 127 needs 7 bits
    localparam PW    = MXS_W + NUM_W + 2;        // room for ts * recip

    reg signed [31:0] xmem [0:MAXN-1];
    reg signed [31:0] gmem [0:MAXN-1];
    reg signed [31:0] tmem [0:MAXN-1];
    reg signed [7:0]  omem [0:MAXN-1];

    always @(posedge clk) begin
        if (xw_en) xmem[xw_addr] <= xw_data;
        if (gw_en) gmem[gw_addr] <= gw_data;
    end

    assign o8_data = omem[o8_addr];
    assign o8_word = {omem[{o8_widx, 2'b11}], omem[{o8_widx, 2'b10}],
                      omem[{o8_widx, 2'b01}], omem[{o8_widx, 2'b00}]};

    reg  [3:0]        st;
    reg  [AW-1:0]     i;
    reg  [31:0]       amx;
    reg  [4:0]        xs;
    reg  [47:0]       ss48;
    reg  [31:0]       mx;
    reg  [5:0]        ks;
    reg  [MXS_W-1:0]  mxs;

    reg  [NUM_W-1:0]  dnum, dquo, recip;
    reg  [NUM_W:0]    drem;
    reg  [7:0]        dcnt;

    wire signed [31:0] xv = xmem[i];
    wire signed [31:0] gv = gmem[i];
    wire signed [31:0] tv = tmem[i];

    wire [31:0] absx = xv[31] ? (~xv + 32'd1) : xv;

    // pass 2. |u| <= 2047 by the xs rule, so u*u is 22 bits and non-negative;
    // the square is taken on the signed value, not on its low bits.
    wire signed [31:0] u   = xv >>> xs;
    wire signed [31:0] usq = u * u;
    wire signed [31:0] tw  = xv * gv;            // 16x16 into 32, as in C

    // max|t| must come from the value being written this cycle, not from the
    // memory it is being written into -- tmem[i] still holds the last pass.
    wire [31:0] abstw = tw[31] ? (~tw + 32'd1) : tw;

    // Pass 3, at the reduced width, in three pipeline stages.
    //
    // Unpipelined this was one combinational chain -- index, tmem read,
    // shift by ks, the multiply, round, clip, write -- and it closed at
    // WNS = -12.731 ns against a 12.3 ns period, with the tools naming
    // i_reg -> omem_reg as the path. Every element here is independent of
    // every other, so splitting it costs two cycles of latency on a pass
    // of n and nothing else. Registers either side of the multiply also
    // let it map onto DSP48 slices properly pipelined.
    reg  signed [MXS_W:0] ts_r;
    reg  signed [PW-1:0]  prod_r;
    reg  [AW-1:0]         i_d1, i_d2;
    reg  [AW+1:0]         p3cnt, p3lim;

    wire signed [MXS_W:0]  ts     = tv >>> ks;                      // stage 1
    wire signed [PW-1:0]   prod_w = ts_r * $signed({1'b0, recip});  // stage 2
    wire signed [PW-1:0]   half = {{(PW-1){1'b0}}, 1'b1} << (RECIP_SH - 1);
    // stage 3: round half away from zero, exactly as nq_core does
    wire signed [PW-1:0]   rnd  = (prod_r >= 0)
                                ? ((prod_r + half) >>> RECIP_SH)
                                : -(((-prod_r) + half) >>> RECIP_SH);
    wire signed [7:0] clipped = (rnd >  127) ?  8'sd127
                              : (rnd < -128) ? -8'sd128 : rnd[7:0];

    always @(posedge clk) begin
        if (!rst_n) begin
            st <= S_IDLE; busy <= 1'b0; done <= 1'b0;
        end else begin
            case (st)
            // done stays asserted until the next start, not for one cycle.
            // A status register polled over AXI is read every several cycles
            // at best, and a flag that is true for exactly one of them is a
            // flag nobody can observe.
            S_IDLE: begin
                if (start) begin
                    done <= 1'b0;
                    busy <= 1'b1; i <= {AW{1'b0}};
                    amx  <= 32'd0; ss48 <= 48'd0; mx <= 32'd0;
                    xs   <= 5'd0;  ks   <= 6'd0;
                    st   <= S_P1;
                end
            end

            // pass 1: the maximum, which decides xs
            S_P1: begin
                if (absx > amx) amx <= absx;
                if (i == n - 1'b1) begin i <= {AW{1'b0}}; st <= S_XS; end
                else i <= i + 1'b1;
            end

            // xs is at most 4: amx <= 32767 and 32767 >> 4 = 2047
            S_XS: if ((amx >> xs) > 32'd2047) xs <= xs + 1'b1;
                  else st <= S_P2;

            // pass 2: sum of squares, the gain product, and its maximum
            S_P2: begin
                ss48 <= ss48 + {16'd0, usq};
                tmem[i] <= tw;
                if (abstw > mx) mx <= abstw;
                if (i == n - 1'b1) begin i <= {AW{1'b0}}; st <= S_NORM; end
                else i <= i + 1'b1;
            end

            // Renormalize ss into 32 bits, then reduce mx for the divide.
            // ss >>= 2 with xs += 1 leaves ss * 4^xs unchanged, and that
            // product is the only thing the host does with either number.
            S_NORM: begin
                if (ss48 >= (48'd1 << 32)) begin
                    ss48 <= ss48 >> 2; xs <= xs + 1'b1;
                end else if ((mx >> ks) >= (32'd1 << MXS_W)) begin
                    ks <= ks + 1'b1;
                end else begin
                    mxs  <= (mx == 32'd0) ? {{(MXS_W-1){1'b0}}, 1'b1}
                                          : (mx >> ks);
                    dnum <= {7'd127, {RECIP_SH{1'b0}}};
                    dquo <= {NUM_W{1'b0}};
                    drem <= {(NUM_W+1){1'b0}};
                    dcnt <= NUM_W;
                    st   <= S_DIV;
                end
            end

            // restoring division, one bit per cycle. Once per vector, so its
            // NUM_W cycles vanish beside the 3n of the passes.
            S_DIV: begin
                if (dcnt == 0) begin
                    recip <= dquo; i <= {AW{1'b0}}; st <= S_P3;
                    p3cnt <= {(AW+2){1'b0}};
                    p3lim <= {2'b0, n} + {{(AW+1){1'b0}}, 1'b1};
                end else begin
                    if ({drem[NUM_W-1:0], dnum[NUM_W-1]}
                        >= {{(NUM_W+1-MXS_W){1'b0}}, mxs}) begin
                        drem <= {drem[NUM_W-1:0], dnum[NUM_W-1]}
                                - {{(NUM_W+1-MXS_W){1'b0}}, mxs};
                        dquo <= {dquo[NUM_W-2:0], 1'b1};
                    end else begin
                        drem <= {drem[NUM_W-1:0], dnum[NUM_W-1]};
                        dquo <= {dquo[NUM_W-2:0], 1'b0};
                    end
                    dnum <= {dnum[NUM_W-2:0], 1'b0};
                    dcnt <= dcnt - 1'b1;
                end
            end

            // pass 3: scale, round away from zero, clip. Element k is
            // written at cycle k+2, so the pass runs n+2 cycles and the
            // index feeding stage 1 stops at n-1 while the tail drains.
            S_P3: begin
                ts_r   <= ts;
                i_d1   <= i;
                prod_r <= prod_w;
                i_d2   <= i_d1;
                if (p3cnt >= {{AW{1'b0}}, 2'd2}) omem[i_d2] <= clipped;
                if (i < n - 1'b1) i <= i + 1'b1;
                if (p3cnt == p3lim) st <= S_END;
                else p3cnt <= p3cnt + 1'b1;
            end

            S_END: begin
                o_mx <= (mx == 32'd0) ? 32'd1 : mx;
                o_ss <= ss48[31:0];
                o_xs <= xs;
                busy <= 1'b0; done <= 1'b1; st <= S_IDLE;
            end

            default: st <= S_IDLE;
            endcase
        end
    end

endmodule

`default_nettype wire
