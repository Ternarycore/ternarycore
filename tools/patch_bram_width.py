#!/usr/bin/env python3
"""patch_bram_width.py -- parameterize the weight store's AXI write width.

The block RAM is already 128 bits wide: `reg [127:0] bram[0:16383]`, and
the array reads a whole 128-bit word every cycle. What is 32 bits is the
AXI write port the CDMA fills it through, and that is the entire reason
paging costs 341 ms a token instead of 85.

The MIG's user interface on this part is 128 bits at 81.25 MHz -- 1.3
GB/s -- and a 32-bit write path uses a quarter of it. Article 05's
"99.2% of what this bus width can physically deliver" is true and was
always the careful phrasing: 99.2% of a bus that is four times narrower
than the memory behind it.

At DATA_WIDTH = 128 the lane machinery disappears rather than growing.
wr_lane, the strobe shift and the {4{...}} replication all exist only
because a beat is narrower than a word; when they are the same size, one
beat is one word and the strobes map straight through. The wide path is
the simpler of the two.

DATA_WIDTH = 32 stays the default and stays bit-identical, so
tb_weight_bram128_burst still passes unchanged -- which is what makes
this a parameterization rather than a rewrite.

  python tools/patch_bram_width.py
"""
import os
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
p = os.path.join(root, "rtl", "weight_bram128.v")
s = open(p).read()

if "DATA_WIDTH" in s:
    sys.exit("already parameterized")

EDITS = [
    # 1. the parameter
    ("""    parameter ADDR_WIDTH = 18,           // byte-address width (256 KB)
    parameter ID_WIDTH   = 4""",
     """    parameter ADDR_WIDTH = 18,           // byte-address width (256 KB)
    parameter ID_WIDTH   = 4,
    // 32 keeps the original, verified narrow path. 128 matches both the
    // block RAM behind this port and the MIG user interface in front of
    // it, and is the only reason paging costs 341 ms rather than 85.
    parameter DATA_WIDTH = 32"""),

    # 2. write data/strobe ports
    ("""    input  wire [31:0]              s_axi_wdata,
    input  wire [3:0]               s_axi_wstrb,""",
     """    input  wire [DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [DATA_WIDTH/8-1:0]  s_axi_wstrb,"""),

    # 3. read data port
    ("""    output wire [31:0]              s_axi_rdata,""",
     """    output wire [DATA_WIDTH-1:0]    s_axi_rdata,"""),

    # 4. the lane machinery, which only exists when a beat is narrow
    ("""    wire [ADDR_WIDTH-5:0] wr_word = waddr[ADDR_WIDTH-1:4];
    wire [1:0]            wr_lane = waddr[3:2];
    wire [15:0]  wstrb16  = {12'b0, s_axi_wstrb} << {wr_lane, 2'b00};
    wire [127:0] wdata128 = {4{s_axi_wdata}};""",
     """    wire [ADDR_WIDTH-5:0] wr_word = waddr[ADDR_WIDTH-1:4];
    wire [15:0]  wstrb16;
    wire [127:0] wdata128;

    // A narrow beat lands in one of four lanes of a 128-bit word, so the
    // data is replicated and the strobes shifted to pick the lane. A beat
    // that is already a whole word needs neither: this is one of the rare
    // cases where the faster path is also the smaller one.
    generate
        if (DATA_WIDTH == 128) begin : g_wide
            assign wstrb16  = s_axi_wstrb;
            assign wdata128 = s_axi_wdata;
        end else begin : g_narrow
            wire [1:0] wr_lane = waddr[3:2];
            assign wstrb16  = {12'b0, s_axi_wstrb} << {wr_lane, 2'b00};
            assign wdata128 = {4{s_axi_wdata}};
        end
    endgenerate"""),

    # 5. the placeholder readback, widened
    ("""    assign s_axi_rdata   = 32'hDEADBEEF;""",
     """    assign s_axi_rdata   = {(DATA_WIDTH/32){32'hDEADBEEF}};"""),
]

for old, new in EDITS:
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:120]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("weight_bram128.v: DATA_WIDTH parameterized, 32 unchanged, 128 added")
