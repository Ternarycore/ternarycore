#!/usr/bin/env python3
"""patch_p3_pipeline.py -- pass 3 was one combinational chain. Split it.

The build closed at WNS = -12.731 ns against a 12.3 ns period, and the
failing path was named exactly:

    Startpoint  rmsnorm_0/inst/core/i_reg[1]
    Endpoint    rmsnorm_0/inst/core/omem_reg

which is pass 3 end to end in a single cycle -- index, tmem read,
variable shift by ks, 21x44 multiply, conditional negate, 66-bit add,
shift, clip, write. About 25 ns of logic where 12.3 was available.

Every element in that pass is independent of every other, so the only
price of splitting it is latency, and latency on a pass of n = 1024 is
two cycles. Three stages:

    1  read tmem[i], shift by ks        ->  ts_r
    2  multiply by the reciprocal       ->  prod_r
    3  round, clip, write omem[i-2]

Registers on both sides of the multiply also let the tools map it onto
DSP48 slices with proper pipelining rather than building a wide LUT
multiplier and hoping.

The datapath's output must be unchanged: the same five vectors from
silicon, still 5/5 exact, or this is not a pipeline -- it is a rewrite.

  python tools/patch_p3_pipeline.py
"""
import os
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
p = os.path.join(root, "rtl", "rmsnorm_quant.v")
s = open(p).read()

if "prod_r" in s:
    sys.exit("already pipelined")

OLD_WIRES = """    // pass 3, at the reduced width
    wire signed [MXS_W:0]  ts   = tv >>> ks;
    wire signed [PW-1:0]   prod = ts * $signed({1'b0, recip});
    wire signed [PW-1:0]   half = {{(PW-1){1'b0}}, 1'b1} << (RECIP_SH - 1);
    // round half away from zero, exactly as nq_core does
    wire signed [PW-1:0]   rnd  = (prod >= 0)
                                ? ((prod + half) >>> RECIP_SH)
                                : -(((-prod) + half) >>> RECIP_SH);
    wire signed [7:0] clipped = (rnd >  127) ?  8'sd127
                              : (rnd < -128) ? -8'sd128 : rnd[7:0];"""

NEW_WIRES = """    // Pass 3, at the reduced width, in three pipeline stages.
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
                              : (rnd < -128) ? -8'sd128 : rnd[7:0];"""

OLD_DIV = """                if (dcnt == 0) begin
                    recip <= dquo; i <= {AW{1'b0}}; st <= S_P3;
                end else begin"""

NEW_DIV = """                if (dcnt == 0) begin
                    recip <= dquo; i <= {AW{1'b0}}; st <= S_P3;
                    p3cnt <= {(AW+2){1'b0}};
                    p3lim <= {2'b0, n} + {{(AW+1){1'b0}}, 1'b1};
                end else begin"""

OLD_P3 = """            // pass 3: scale, round away from zero, clip
            S_P3: begin
                omem[i] <= clipped;
                if (i == n - 1'b1) st <= S_END;
                else i <= i + 1'b1;
            end"""

NEW_P3 = """            // pass 3: scale, round away from zero, clip. Element k is
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
            end"""

for old, new in ((OLD_WIRES, NEW_WIRES), (OLD_DIV, NEW_DIV), (OLD_P3, NEW_P3)):
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:160]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("rmsnorm_quant: pass 3 pipelined into three stages")
