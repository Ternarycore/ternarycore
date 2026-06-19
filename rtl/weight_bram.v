// weight_bram.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// This source describes Hardware and is licensed under the CERN-OHL-S v2.
// You may redistribute and modify this source and make products using it
// under the terms of the CERN-OHL-S v2 (https://ohwr.org/cern_ohl_s_v2.txt).
//
// Dual-port BRAM weight cache for ternary neural network weights.
//
// Write port: AXI4-Lite slave (MicroBlaze loads packed ternary weights).
// Read port: combinatorial, drives weight_enc bus of axi_gemm_wrapper.
//
// Packing: 4 ternary weights per byte (2 bits each, 00=zero, 01=+1, 10=-1).
// Default address width 18 bits → 2^18 = 262,144 bytes = 256 KB
// stores 1,048,576 ternary parameters (4 params/byte).
// Fits in ~35 BRAM36 tiles on Artix-7 100T (34.7 tiles required).
//
// AXI4-Lite interface: 32-bit word access, byte-level addressing.
// Writes use wstrb for byte-level write enable within a 32-bit word.

`timescale 1ns / 1ps

module weight_bram #(
    parameter ADDR_WIDTH = 18,
    parameter DATA_WIDTH = 8
)(
    input  wire                     clk,
    input  wire                     rst_n,

    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [2:0]               s_axi_awprot,
    input  wire                     s_axi_awvalid,
    output wire                     s_axi_awready,

    input  wire [31:0]              s_axi_wdata,
    input  wire [3:0]               s_axi_wstrb,
    input  wire                     s_axi_wvalid,
    output wire                     s_axi_wready,

    output wire [1:0]               s_axi_bresp,
    output wire                     s_axi_bvalid,
    input  wire                     s_axi_bready,

    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [2:0]               s_axi_arprot,
    input  wire                     s_axi_arvalid,
    output wire                     s_axi_arready,

    output reg  [31:0]              s_axi_rdata,
    output wire [1:0]               s_axi_rresp,
    output wire                     s_axi_rvalid,
    input  wire                     s_axi_rready,

    input  wire [ADDR_WIDTH-1:0]    weight_addr,
    output wire [DATA_WIDTH-1:0]    weight_byte
);

    localparam BRAM_DEPTH = 1 << ADDR_WIDTH;

    (* ram_style = "block" *)
    reg [DATA_WIDTH-1:0] bram [0:BRAM_DEPTH-1];

    assign weight_byte = bram[weight_addr];

    // ── AXI write state machine ────────────────────────────────────
    reg         aw_accepted;
    reg         w_accepted;
    reg         b_pending;
    reg [ADDR_WIDTH-1:0] wr_addr;

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

    wire wr_commit;
    assign wr_commit = b_pending && s_axi_bready;

    assign s_axi_awready = !aw_accepted && !b_pending;
    assign s_axi_wready  = !w_accepted  && !b_pending;
    assign s_axi_bvalid  = b_pending;
    assign s_axi_bresp   = 2'b00;

    // ── BRAM write logic ───────────────────────────────────────────
    integer i;
    always @(posedge clk) begin
        if (wr_commit) begin
            for (i = 0; i < 4; i = i + 1) begin
                if (s_axi_wstrb[i]) begin
                    bram[wr_addr + i] <= s_axi_wdata[i*8 +: 8];
                end
            end
        end
    end

    // ── AXI read state machine ─────────────────────────────────────
    reg         rd_active;
    reg [ADDR_WIDTH-1:0] rd_addr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_active <= 1'b0;
            rd_addr   <= {ADDR_WIDTH{1'b0}};
        end else begin
            if (s_axi_arvalid && s_axi_arready) begin
                rd_active <= 1'b1;
                rd_addr   <= s_axi_araddr;
            end else if (s_axi_rvalid && s_axi_rready) begin
                rd_active <= 1'b0;
            end
        end
    end

    assign s_axi_arready = !rd_active;
    assign s_axi_rvalid  = rd_active;
    assign s_axi_rresp   = 2'b00;

    // ── BRAM read logic ────────────────────────────────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axi_rdata <= 32'h00000000;
        end else begin
            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rdata <= {
                    bram[rd_addr + 3],
                    bram[rd_addr + 2],
                    bram[rd_addr + 1],
                    bram[rd_addr + 0]
                };
            end
        end
    end

endmodule
