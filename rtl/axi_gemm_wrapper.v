// axi_gemm_wrapper.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// This source describes Hardware and is licensed under the CERN-OHL-S v2.
// You may redistribute and modify this source and make products using it
// under the terms of the CERN-OHL-S v2 (https://ohwr.org/cern_ohl_s_v2.txt).
//
// AXI4-Lite slave wrapper for ternary_gemm.
// Exposes ternary_gemm as a memory-mapped peripheral suitable for MicroBlaze.
//
// Register map (word-aligned, 32-bit accesses):
//   0x00  CTRL            [RW]  bit0=start, bit1=rst_sw, bit31=done (RO)
//   0x04  ACTIVATION      [WO]  int8 activation value in bits [7:0]
//   0x08  WEIGHT_ENC_LOW  [RW]  weight encoding bits [31:0]
//   0x0C  WEIGHT_ENC_HIGH [RW]  weight encoding bits [63:32] (for COLS > 16)
//   0x10  ACC_OUT0        [RO]  accumulator output column 0
//   0x14  ACC_OUT1        [RO]  accumulator output column 1
//   0x18  ACC_OUT2        [RO]  accumulator output column 2
//   0x1C  ACC_OUT3        [RO]  accumulator output column 3

`timescale 1ns / 1ps

module axi_gemm_wrapper #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter ROWS       = 4,
    parameter COLS       = 4,
    parameter DEPTH      = 4
)(
    input  wire         s_axi_aclk,
    input  wire         s_axi_aresetn,

    input  wire [7:0]   s_axi_awaddr,
    input  wire [2:0]   s_axi_awprot,
    input  wire         s_axi_awvalid,
    output wire         s_axi_awready,

    input  wire [31:0]  s_axi_wdata,
    input  wire [3:0]   s_axi_wstrb,
    input  wire         s_axi_wvalid,
    output wire         s_axi_wready,

    output wire [1:0]   s_axi_bresp,
    output wire         s_axi_bvalid,
    input  wire         s_axi_bready,

    input  wire [7:0]   s_axi_araddr,
    input  wire [2:0]   s_axi_arprot,
    input  wire         s_axi_arvalid,
    output wire         s_axi_arready,

    output wire [31:0]  s_axi_rdata,
    output wire [1:0]   s_axi_rresp,
    output wire         s_axi_rvalid,
    input  wire         s_axi_rready
);

    localparam ADDR_CTRL           = 8'h00;
    localparam ADDR_ACTIVATION     = 8'h04;
    localparam ADDR_WEIGHT_ENC_LO  = 8'h08;
    localparam ADDR_WEIGHT_ENC_HI  = 8'h0C;
    localparam ADDR_ACC_OUT0       = 8'h10;
    localparam ADDR_ACC_OUT1       = 8'h14;
    localparam ADDR_ACC_OUT2       = 8'h18;
    localparam ADDR_ACC_OUT3       = 8'h1C;

    // ── Internal registers ─────────────────────────────────────────
    reg         ctrl_start;
    reg         ctrl_rst_sw;
    reg         ctrl_done;
    reg [DATA_WIDTH-1:0] activation_reg;
    reg [31:0]  weight_enc_lo;
    reg [31:0]  weight_enc_hi;

    // ── AXI write state machine ────────────────────────────────────
    // aw_accepted: AW handshake completed, awaiting W
    // w_accepted:   W handshake completed, awaiting AW
    // b_pending:   B response outbound
    reg         aw_accepted;
    reg         w_accepted;
    reg         b_pending;
    reg [7:0]   wr_addr;

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            aw_accepted <= 1'b0;
            w_accepted  <= 1'b0;
            b_pending   <= 1'b0;
            wr_addr     <= 8'h00;
        end else begin
            if (s_axi_awvalid && s_axi_awready) begin
                aw_accepted <= 1'b1;
                wr_addr     <= s_axi_awaddr[7:0];
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

    // ── Register write logic ───────────────────────────────────────
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            ctrl_start     <= 1'b0;
            ctrl_rst_sw    <= 1'b0;
            activation_reg <= {DATA_WIDTH{1'b0}};
            weight_enc_lo  <= 32'h00000000;
            weight_enc_hi  <= 32'h00000000;
        end else begin
            if (wr_commit) begin
                case (wr_addr)
                    ADDR_CTRL: begin
                        ctrl_start  <= s_axi_wdata[0];
                        ctrl_rst_sw <= s_axi_wdata[1];
                    end
                    ADDR_ACTIVATION: begin
                        activation_reg <= s_axi_wdata[DATA_WIDTH-1:0];
                    end
                    ADDR_WEIGHT_ENC_LO: begin
                        weight_enc_lo <= s_axi_wdata;
                    end
                    ADDR_WEIGHT_ENC_HI: begin
                        weight_enc_hi <= s_axi_wdata;
                    end
                    default: begin
                    end
                endcase
            end
        end
    end

    // ── AXI read state machine ─────────────────────────────────────
    reg         rd_active;
    reg [7:0]   rd_addr;

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            rd_active <= 1'b0;
            rd_addr   <= 8'h00;
        end else begin
            if (s_axi_arvalid && s_axi_arready) begin
                rd_active <= 1'b1;
                rd_addr   <= s_axi_araddr[7:0];
            end else if (s_axi_rvalid && s_axi_rready) begin
                rd_active <= 1'b0;
            end
        end
    end

    assign s_axi_arready = !rd_active;
    assign s_axi_rvalid  = rd_active;
    assign s_axi_rresp   = 2'b00;

    // ── ternary_gemm instantiation ─────────────────────────────────
    wire                      gemm_rst_n;
    wire                      gemm_valid_in;
    wire [2*COLS-1:0]         weight_enc_int;
    wire [ACC_WIDTH*COLS-1:0] acc_out_wire;
    wire                      gemm_valid_out;

    assign gemm_rst_n = s_axi_aresetn && !ctrl_rst_sw;

    generate
        if (COLS <= 16) begin : weight_mux_narrow
            assign weight_enc_int = weight_enc_lo[2*COLS-1:0];
        end else begin : weight_mux_wide
            assign weight_enc_int = { weight_enc_hi[2*COLS-33:0], weight_enc_lo };
        end
    endgenerate

    reg act_wr_pending;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            act_wr_pending <= 1'b0;
        end else begin
            if (wr_commit && (wr_addr == ADDR_ACTIVATION))
                act_wr_pending <= 1'b1;
            else
                act_wr_pending <= 1'b0;
        end
    end

    assign gemm_valid_in = act_wr_pending;

    ternary_gemm #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ROWS(ROWS),
        .COLS(COLS),
        .DEPTH(DEPTH)
    ) gemm_i (
        .clk       (s_axi_aclk),
        .rst_n     (gemm_rst_n),
        .valid_in  (gemm_valid_in),
        .activation(activation_reg),
        .weight_enc(weight_enc_int),
        .acc_out   (acc_out_wire),
        .valid_out (gemm_valid_out)
    );

    // ── ACC_OUT latch ──────────────────────────────────────────────
    reg [ACC_WIDTH*COLS-1:0] acc_out_latch;

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            acc_out_latch <= {ACC_WIDTH*COLS{1'b0}};
        end else if (gemm_valid_out) begin
            acc_out_latch <= acc_out_wire;
        end
    end

    // ── Done flag ──────────────────────────────────────────────────
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            ctrl_done <= 1'b0;
        end else if (gemm_valid_out) begin
            ctrl_done <= 1'b1;
        end else if (wr_commit && (wr_addr == ADDR_CTRL)) begin
            ctrl_done <= 1'b0;
        end
    end

    // ── Read data mux ──────────────────────────────────────────────
    reg [31:0] rdata;

    function [31:0] get_acc_out;
        input [7:0] addr;
        input integer n;
        begin
            if (n < COLS)
                get_acc_out = acc_out_latch[ACC_WIDTH*n +: ACC_WIDTH];
            else
                get_acc_out = 32'h00000000;
        end
    endfunction

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            rdata <= 32'h00000000;
        end else begin
            if (s_axi_arvalid && s_axi_arready) begin
                case (s_axi_araddr[7:0])
                    ADDR_CTRL: begin
                        rdata <= {ctrl_done, 29'b0, ctrl_rst_sw, ctrl_start};
                    end
                    ADDR_WEIGHT_ENC_LO: rdata <= weight_enc_lo;
                    ADDR_WEIGHT_ENC_HI: rdata <= weight_enc_hi;
                    ADDR_ACC_OUT0:      rdata <= get_acc_out(8'h00, 0);
                    ADDR_ACC_OUT1:      rdata <= get_acc_out(8'h00, 1);
                    ADDR_ACC_OUT2:      rdata <= get_acc_out(8'h00, 2);
                    ADDR_ACC_OUT3:      rdata <= get_acc_out(8'h00, 3);
                    default:            rdata <= 32'h00000000;
                endcase
            end
        end
    end

    assign s_axi_rdata = rdata;

endmodule
