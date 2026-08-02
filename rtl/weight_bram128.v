// weight_bram128.v -- packed ternary weight store, 256 KB.
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
//
// v2 for the Tier-2 line-rate feeder: internal organization is 128-bit
// words (16 packed bytes = 64 ternary columns) so one read feeds the
// COLS=64 array every cycle. AXI4-Lite write/read slave is unchanged in
// behavior from weight_bram v1 (32-bit, byte-addressed 256 KB window).
//
// Read port: w_word_addr (14b, 128-bit word address) -> w_word, 1-cycle
// registered latency. Word w holds bytes [w*16 .. w*16+15] of the packed
// layout addr = k*GROUPS + g  (GROUPS = 256 for a 1024-wide matrix), i.e.
// word address = k*16 + column_tile for tile-of-64 reads.

`timescale 1ns / 1ps
`default_nettype none

module weight_bram128 #(
    parameter ADDR_WIDTH = 18            // byte-address width (256 KB)
) (
    input  wire                     clk,
    input  wire                     rst_n,

    // AXI4-Lite write address / data / response
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [2:0]               s_axi_awprot,
    input  wire                     s_axi_awvalid,
    output wire                     s_axi_awready,
    input  wire [31:0]              s_axi_wdata,
    input  wire [3:0]               s_axi_wstrb,
    input  wire                     s_axi_wvalid,
    output wire                     s_axi_wready,
    output wire [1:0]               s_axi_bresp,
    output reg                      s_axi_bvalid,
    input  wire                     s_axi_bready,

    // AXI4-Lite read address / data
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [2:0]               s_axi_arprot,
    input  wire                     s_axi_arvalid,
    output wire                     s_axi_arready,
    output reg  [31:0]              s_axi_rdata,
    output wire [1:0]               s_axi_rresp,
    output reg                      s_axi_rvalid,
    input  wire                     s_axi_rready,

    // 128-bit weight read port (1-cycle registered latency)
    input  wire [ADDR_WIDTH-5:0]    w_word_addr,   // 14b: 16K x 128b
    output reg  [127:0]             w_word
);

    localparam WORD_DEPTH = 1 << (ADDR_WIDTH - 4);   // 16384 x 128b = 256 KB

    (* ram_style = "block" *)
    reg [127:0] bram [0:WORD_DEPTH-1];

    // -- 128b read port ------------------------------------------------------
    always @(posedge clk) begin
        w_word <= bram[w_word_addr];
    end

    // -- AXI4-Lite write: 32b lane into a 128b word --------------------------
    wire aw_fire = s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid;
    assign s_axi_awready = aw_fire;
    assign s_axi_wready  = aw_fire;
    assign s_axi_bresp   = 2'b00;

    wire [ADDR_WIDTH-5:0] wr_word = s_axi_awaddr[ADDR_WIDTH-1:4];
    wire [1:0]            wr_lane = s_axi_awaddr[3:2];
    wire [15:0]  wstrb16  = {12'b0, s_axi_wstrb} << {wr_lane, 2'b00};
    wire [127:0] wdata128 = {4{s_axi_wdata}};

    integer bi;
    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_bvalid <= 1'b0;
        end else begin
            if (aw_fire) begin
                for (bi = 0; bi < 16; bi = bi + 1)
                    if (wstrb16[bi])
                        bram[wr_word][bi*8 +: 8] <= wdata128[bi*8 +: 8];
                s_axi_bvalid <= 1'b1;
            end else if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end
        end
    end

    // -- AXI4-Lite read: 32b lane out of a 128b word -------------------------
    wire ar_fire = s_axi_arvalid && !s_axi_rvalid;
    assign s_axi_arready = ar_fire;
    assign s_axi_rresp   = 2'b00;

    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_rvalid <= 1'b0;
        end else begin
            if (ar_fire) begin
                s_axi_rdata  <= 32'hDEADBEEF;  // readback removed: keeps BRAM at 2 ports
                s_axi_rvalid <= 1'b1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end
        end
    end

endmodule

`default_nettype wire
