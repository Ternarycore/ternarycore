// weight_bram.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// Dual-port BRAM weight cache for ternary neural network weights.
//
// Write port: AXI4-Lite slave (MicroBlaze loads packed ternary weights).
// Read port:  synchronous (1-cycle latency), drives weight_enc bus.
//
// Packing: 4 ternary weights per byte (2 bits each, 00=zero, 01=+1, 10=-1).
// ADDR_WIDTH=18 → 2^16 × 32-bit words = 256 KB = 1M ternary params.
// Maps to ~35 BRAM36 tiles on Artix-7 100T.
//
// BRAM is 32-bit wide (word-addressed). AXI byte-enable writes use
// per-byte if-guards so Vivado infers RAMB36E1 with byte-write enables.

`timescale 1ns / 1ps

module weight_bram #(
    parameter ADDR_WIDTH = 18,   // byte-address width (256 KB)
    parameter DATA_WIDTH = 8     // weight_byte output width
)(
    input  wire                     clk,
    input  wire                     rst_n,

    // AXI4-Lite write address
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
/* verilator lint_off UNUSEDSIGNAL */
    input  wire [2:0]               s_axi_awprot,
    input  wire                     s_axi_awvalid,
/* verilator lint_on UNUSEDSIGNAL */
    output wire                     s_axi_awready,

    // AXI4-Lite write data
    input  wire [31:0]              s_axi_wdata,
    input  wire [3:0]               s_axi_wstrb,
    input  wire                     s_axi_wvalid,
    output wire                     s_axi_wready,

    // AXI4-Lite write response
    output wire [1:0]               s_axi_bresp,
    output wire                     s_axi_bvalid,
    input  wire                     s_axi_bready,

    // AXI4-Lite read address
/* verilator lint_off UNUSEDSIGNAL */
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [2:0]               s_axi_arprot,
    input  wire                     s_axi_arvalid,
/* verilator lint_on UNUSEDSIGNAL */
    output wire                     s_axi_arready,

    // AXI4-Lite read data
    output reg  [31:0]              s_axi_rdata,
    output wire [1:0]               s_axi_rresp,
    output wire                     s_axi_rvalid,
    input  wire                     s_axi_rready,

    // Weight read port (1-cycle registered latency)
    input  wire [ADDR_WIDTH-1:0]    weight_addr,
    output wire [DATA_WIDTH-1:0]    weight_byte
);

    // 32-bit wide BRAM, word-addressed (drop 2 LSBs of byte address)
    localparam WORD_DEPTH = 1 << (ADDR_WIDTH - 2);

    (* ram_style = "block" *)
    reg [31:0] bram [0:WORD_DEPTH-1];

    // ── Weight read port ──────────────────────────────────────────────────────
    reg [31:0] weight_word_r;
    always @(posedge clk) begin
        weight_word_r <= bram[weight_addr[ADDR_WIDTH-1:2]];
    end
    // Select byte lane from registered word output
    assign weight_byte = weight_word_r[{weight_addr[1:0], 3'b000} +: DATA_WIDTH];

    // ── AXI write state machine ───────────────────────────────────────────────
    reg aw_accepted, w_accepted, b_pending;
/* verilator lint_off UNUSEDSIGNAL */
    reg [ADDR_WIDTH-1:0] wr_addr;
/* verilator lint_on UNUSEDSIGNAL */

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aw_accepted <= 1'b0;
            w_accepted  <= 1'b0;
            b_pending   <= 1'b0;
            wr_addr     <= {ADDR_WIDTH{1'b0}};
        end else begin
            if (s_axi_awvalid && s_axi_awready) begin
                aw_accepted <= 1'b1;
                wr_addr     <= s_axi_awaddr;
            end else if (b_pending && s_axi_bready) begin
                aw_accepted <= 1'b0;
            end

            if (s_axi_wvalid && s_axi_wready) begin
                w_accepted <= 1'b1;
            end else if (b_pending && s_axi_bready) begin
                w_accepted <= 1'b0;
            end

            if (aw_accepted && w_accepted && !b_pending) begin
                b_pending <= 1'b1;
            end else if (b_pending && s_axi_bready) begin
                b_pending <= 1'b0;
            end
        end
    end

    assign s_axi_awready = !aw_accepted && !b_pending;
    assign s_axi_wready  = !w_accepted  && !b_pending;
    assign s_axi_bvalid  = b_pending;
    assign s_axi_bresp   = 2'b00;

    wire wr_commit = b_pending && s_axi_bready;

    // ── BRAM write (byte-enable guards → infers RAMB36E1 with byte-write en) ─
    always @(posedge clk) begin
        if (wr_commit) begin
            if (s_axi_wstrb[0]) bram[wr_addr[ADDR_WIDTH-1:2]][7:0]   <= s_axi_wdata[7:0];
            if (s_axi_wstrb[1]) bram[wr_addr[ADDR_WIDTH-1:2]][15:8]  <= s_axi_wdata[15:8];
            if (s_axi_wstrb[2]) bram[wr_addr[ADDR_WIDTH-1:2]][23:16] <= s_axi_wdata[23:16];
            if (s_axi_wstrb[3]) bram[wr_addr[ADDR_WIDTH-1:2]][31:24] <= s_axi_wdata[31:24];
        end
    end

    // ── AXI read state machine ────────────────────────────────────────────────
    reg rd_active;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_active <= 1'b0;
        end else begin
            if (s_axi_arvalid && s_axi_arready) begin
                rd_active <= 1'b1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                rd_active <= 1'b0;
            end
        end
    end

    assign s_axi_arready = !rd_active;
    assign s_axi_rvalid  = rd_active;
    assign s_axi_rresp   = 2'b00;

    // ── BRAM read (synchronous, single 32-bit read) ───────────────────────────
    always @(posedge clk) begin
        if (s_axi_arvalid && s_axi_arready) begin
            s_axi_rdata <= bram[s_axi_araddr[ADDR_WIDTH-1:2]];
        end
    end

endmodule
