#!/usr/bin/env python3
"""patch_p2_width.py -- the multiplies were 32x32. They are 16x16.

Pipelining pass 3 took WNS from -12.731 to -4.781, and moved the critical
path to pass 2:

    Source       rmsnorm_0/inst/core/xmem_reg (RAMB36E1)
    Destination  rmsnorm_0/inst/core/mx_reg[10]/CE
    Data Path    16.718 ns (logic 11.146, route 5.572)

which is: read x and g, multiply, take the absolute value, compare
against the running maximum, enable the register. Two problems, both
mine.

First, the operands. |x| <= 32767 by nq_core's precondition and |g| <=
32767 by the Q15 normalization, so these are 16x16 multiplies -- the
comment beside them says exactly that. But they were written on 32-bit
signed operands, and Vivado cannot know the bound, so it built 32x32
multipliers: three or four cascaded DSP48s where one would do. The
comment was right and the Verilog was not, which is the least excusable
kind of wrong.

Second, even a fast multiply followed by an absolute value, a 32-bit
compare and a register enable is a long way for one cycle. Pass 2 gets
the same treatment pass 3 got: multiply in one stage, compare and store
in the next. One extra cycle on a pass of n.

Acceptance is unchanged and non-negotiable: the same five vectors from
silicon, 5/5 exact, and 3/3 through the AXI port.

  python tools/patch_p2_width.py
"""
import os
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
p = os.path.join(root, "rtl", "rmsnorm_quant.v")
s = open(p).read()

if "tw_r" in s:
    sys.exit("already patched")

OLD_MUL = """    // pass 2. |u| <= 2047 by the xs rule, so u*u is 22 bits and non-negative;
    // the square is taken on the signed value, not on its low bits.
    wire signed [31:0] u   = xv >>> xs;
    wire signed [31:0] usq = u * u;
    wire signed [31:0] tw  = xv * gv;            // 16x16 into 32, as in C

    // max|t| must come from the value being written this cycle, not from the
    // memory it is being written into -- tmem[i] still holds the last pass.
    wire [31:0] abstw = tw[31] ? (~tw + 32'd1) : tw;"""

NEW_MUL = """    // Pass 2, and the operand widths are load-bearing. |u| <= 2047 by the
    // xs rule and |x|, |g| <= 32767 by nq_core's precondition and the Q15
    // normalization -- so these are 12x12 and 16x16 multiplies. Written on
    // 32-bit operands they became 32x32, because Vivado cannot know a bound
    // that lives in a comment: three or four cascaded DSP48s each, and the
    // critical path at -4.781 ns.
    wire signed [31:0] u   = xv >>> xs;
    wire signed [31:0] usq = $signed(u[11:0])  * $signed(u[11:0]);
    wire signed [31:0] tw  = $signed(xv[15:0]) * $signed(gv[15:0]);

    // ...and the product is registered before the absolute value and the
    // comparison, for the same reason pass 3 is pipelined: multiply, abs,
    // 32-bit compare and a register enable do not fit in 12.3 ns together.
    reg  signed [31:0] tw_r;
    reg  [AW-1:0]      i_p2;
    reg  [AW+1:0]      p2cnt, p2lim;

    wire [31:0] abstw = tw_r[31] ? (~tw_r + 32'd1) : tw_r;"""

OLD_XS = """            S_XS: if ((amx >> xs) > 32'd2047) xs <= xs + 1'b1;
                  else st <= S_P2;"""

NEW_XS = """            S_XS: if ((amx >> xs) > 32'd2047) xs <= xs + 1'b1;
                  else begin
                      p2cnt <= {(AW+2){1'b0}};
                      p2lim <= {2'b0, n};
                      st <= S_P2;
                  end"""

OLD_P2 = """            // pass 2: sum of squares, the gain product, and its maximum
            S_P2: begin
                ss48 <= ss48 + {16'd0, usq};
                tmem[i] <= tw;
                if (abstw > mx) mx <= abstw;
                if (i == n - 1'b1) begin i <= {AW{1'b0}}; st <= S_NORM; end
                else i <= i + 1'b1;
            end"""

NEW_P2 = """            // pass 2: sum of squares, the gain product, and its maximum,
            // in two stages. Element k is stored and compared at cycle
            // k+1, so the pass runs n+1 cycles; stage one stops feeding at
            // n-1 and the sum of squares only accumulates while it is live.
            S_P2: begin
                if (p2cnt < {2'b0, n}) ss48 <= ss48 + {16'd0, usq};
                tw_r <= tw;
                i_p2 <= i;
                if (p2cnt >= {{(AW+1){1'b0}}, 1'b1}) begin
                    tmem[i_p2] <= tw_r;
                    if (abstw > mx) mx <= abstw;
                end
                if (i < n - 1'b1) i <= i + 1'b1;
                if (p2cnt == p2lim) begin i <= {AW{1'b0}}; st <= S_NORM; end
                else p2cnt <= p2cnt + 1'b1;
            end"""

for old, new in ((OLD_MUL, NEW_MUL), (OLD_XS, NEW_XS), (OLD_P2, NEW_P2)):
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:160]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("rmsnorm_quant: multiplies narrowed to their real widths, pass 2 pipelined")
