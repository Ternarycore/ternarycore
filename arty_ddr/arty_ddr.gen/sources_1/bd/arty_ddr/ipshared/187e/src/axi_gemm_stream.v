// axi_gemm_stream.v -- Tier-2 line-rate streaming GEMM accelerator.
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
//
// COLS=64 ternary array fed at one activation element per clock from an
// internal activation RAM and the external 128-bit weight port of
// weight_bram128. One pass computes 64 output columns over DEPTH elements
// in ~DEPTH+pipe cycles (64 MACs/cycle); a 1024-wide layer = 16 passes
// selected by the column-tile register.
//
// Register map (AXI4-Lite, 32-bit):
//   0x00 CTRL    W   bit0 START  bit1 CLEAR done  bit2 ACT_PTR_RST
//                    bit3 INT8 mode: attention's activation x activation
//                         matmuls, bit-serialised through the ternary array
//   0x04 STATUS  R   bit0 busy  bit1 done
//   0x08 ACT_WR  W   [7:0] byte -> act_ram[wptr++]
//   0x0C CT      RW  [3:0] column tile (0..15)
//   0x10 DEPTH   RW  elements per pass (default 1024)
//   0x14 RIDX    RW  [5:0] result select
//   0x18 RDATA   R   acc[RIDX] (stable while done=1)
//   0x1C ID      R   32'h7C0DE002
//   0x20 CYCLES  R   cycle count of last pass (start->done)

`timescale 1ns / 1ps
`default_nettype none

module axi_gemm_stream #(
    parameter DEPTH_MAX  = 1024,
    parameter COLS       = 64,
    parameter ACC_WIDTH  = 32,
    parameter WADDR_W    = 14
) (
    input  wire         clk,
    input  wire         rst_n,

    // AXI4-Lite slave
    input  wire [7:0]   s_axi_awaddr,
    input  wire [2:0]   s_axi_awprot,
    input  wire         s_axi_awvalid,
    output wire         s_axi_awready,
    input  wire [31:0]  s_axi_wdata,
    input  wire [3:0]   s_axi_wstrb,
    input  wire         s_axi_wvalid,
    output wire         s_axi_wready,
    output wire [1:0]   s_axi_bresp,
    output reg          s_axi_bvalid,
    input  wire         s_axi_bready,
    input  wire [7:0]   s_axi_araddr,
    input  wire [2:0]   s_axi_arprot,
    input  wire         s_axi_arvalid,
    output wire         s_axi_arready,
    output reg  [31:0]  s_axi_rdata,
    output wire [1:0]   s_axi_rresp,
    output reg          s_axi_rvalid,
    input  wire         s_axi_rready,

    // weight_bram128 read port
    output wire [WADDR_W-1:0] w_word_addr,
    input  wire [127:0]       w_word
);

    // -- registers ------------------------------------------------------------
    reg  [3:0]  ct;
    reg  [10:0] depth;          // up to 1024
    reg  [5:0]  ridx;
    reg  [10:0] act_wptr;
    reg         done;
    reg  [31:0] cycles;

    // -- activation RAM (1024 x 8) -------------------------------------------
    (* ram_style = "block" *)
    reg [7:0] act_ram [0:DEPTH_MAX-1];
    reg [7:0] act_q;

    // -- streaming FSM --------------------------------------------------------
    localparam S_IDLE = 2'd0, S_CLR = 2'd1, S_RUN = 2'd2, S_WAIT = 2'd3;
    reg [1:0]  state;
    reg [10:0] k;               // issue counter
    reg        v0, v1;          // address-issued / data-valid pipeline
    reg [1:0]  clr_cnt;
    reg        int8_mode;       // latched at START
    reg [2:0]  bslice;          // which bit of the int8 operand, 0..7
    reg        vout_d;

    wire busy = (state != S_IDLE);

    wire [10:0] act_addr = k;
    // int8 mode walks the bit-slices flat: one 64-bit slice per sub-cycle.
    assign w_word_addr = int8_mode ? {4'd0, k[9:0]} : {k[9:0], ct};

    always @(posedge clk) act_q <= act_ram[act_addr[9:0]];
    // Single driver. This was assigned here AND in the FSM's reset branch;
    // iverilog resolved the conflict one way and Vivado the other, so the
    // shift silently vanished on silicon while simulation passed.
    always @(posedge clk or negedge rst_n)
        if (!rst_n) bslice <= 3'd0;
        else        bslice <= k[2:0];   // aligns with act_q / w_word

    // -- int8 attention path ---------------------------------------------
    // a*b = sum(k=0..6) b_k*(a<<k) - b_7*(a<<7). The weight port carries one
    // BIT of each of the 64 int8 operands per sub-cycle, in its low 64 bits;
    // we expand that to the array's 2-bit codes here. The k=7 term is negated
    // because in two's complement the top bit carries negative weight. So
    // attention runs on the ternary array with no multiplier and no DSP.
    wire [127:0] w_int8;
    genvar gi;
    generate
        for (gi = 0; gi < COLS; gi = gi + 1) begin : g_bitslice
            assign w_int8[gi*2 +: 2] =
                (w_word[gi] == 1'b0) ? 2'b00 :
                (bslice == 3'd7)     ? 2'b10 : 2'b01;
        end
    endgenerate

    wire [127:0] w_sel = int8_mode ? w_int8 : w_word;

    // Sign-extend to 16 bits, then shift. Ternary mode shifts by zero, so the
    // value is identical and that path stays cycle-for-cycle unchanged.
    wire signed [15:0] act_ext = $signed(act_q);
    wire        [15:0] act_sel = int8_mode ? (act_ext <<< bslice) : act_ext;

    // gemm core (synchronously cleared between passes)
    reg  gemm_clr;
    wire gemm_rst_n = rst_n & ~gemm_clr;
    wire [ACC_WIDTH*COLS-1:0] acc_out;
    wire valid_out;

    ternary_gemm #(
        .DATA_WIDTH (16),
        .ACC_WIDTH  (ACC_WIDTH),
        .COLS       (COLS),
        .DEPTH      (DEPTH_MAX)   // counter compare uses depth reg below
    ) u_gemm (
        .clk        (clk),
        .rst_n      (gemm_rst_n),
        .valid_in   (v1),
        .activation (act_sel),
        .weight_enc (w_sel),      // 2*64 = 128 bits
        .acc_out    (acc_out),
        .valid_out  (valid_out)
    );

    // element-count-based done: we track accepted elements ourselves so the
    // pass length is the runtime 'depth' register, independent of the
    // compile-time DEPTH parameter inside ternary_gemm.
    reg [10:0] fed;
    wire pass_done = (fed == DEPTH_MAX) && !v0 && !v1;

    wire start_cmd, clear_cmd, aptr_cmd, int8_cmd;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_IDLE; k <= 0; v0 <= 0; v1 <= 0; fed <= 0;
            done <= 0; gemm_clr <= 0; clr_cnt <= 0; cycles <= 0;
            int8_mode <= 0;
        end else begin
            case (state)
                S_IDLE: if (start_cmd) begin
                    state <= S_CLR; gemm_clr <= 1; clr_cnt <= 2;
                    done <= 0; k <= 0; v0 <= 0; v1 <= 0; fed <= 0; cycles <= 0; vout_d <= 0;
                    int8_mode <= int8_cmd;   // same AXI write, so coherent
                end
                S_CLR: begin
                    cycles <= cycles + 1;
                    clr_cnt <= clr_cnt - 1;
                    if (clr_cnt == 1) begin gemm_clr <= 0; state <= S_RUN; end
                end
                S_RUN: begin
                    cycles <= cycles + 1;
                    // issue phase
                    if (k < DEPTH_MAX) begin
                        k  <= k + 1;
                        v0 <= 1;
                    end else begin
                        v0 <= 0;
                    end
                    v1 <= v0;
                    if (v1) fed <= fed + 1;
                    if (pass_done) begin state <= S_WAIT; end
                end
                S_WAIT: begin
                    cycles <= cycles + 1;
                    vout_d <= valid_out;
                    if (vout_d) begin done <= 1; state <= S_IDLE; end
                end
            endcase
            if (clear_cmd) done <= 0;
        end
    end

    // -- AXI4-Lite slave ------------------------------------------------------
    wire aw_fire = s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid;
    assign s_axi_awready = aw_fire;
    assign s_axi_wready  = aw_fire;
    assign s_axi_bresp   = 2'b00;

    assign start_cmd = aw_fire && (s_axi_awaddr[7:2] == 6'h00) && s_axi_wdata[0];
    assign clear_cmd = aw_fire && (s_axi_awaddr[7:2] == 6'h00) && s_axi_wdata[1];
    assign aptr_cmd  = aw_fire && (s_axi_awaddr[7:2] == 6'h00) && s_axi_wdata[2];
    assign int8_cmd  = aw_fire && (s_axi_awaddr[7:2] == 6'h00) && s_axi_wdata[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_bvalid <= 0; ct <= 0; depth <= DEPTH_MAX[10:0];
            ridx <= 0; act_wptr <= 0;
        end else begin
            if (aw_fire) begin
                case (s_axi_awaddr[7:2])
                    6'h02: begin                       // ACT_WR
                        act_ram[act_wptr[9:0]] <= s_axi_wdata[7:0];
                        act_wptr <= act_wptr + 1;
                    end
                    6'h03: ct    <= s_axi_wdata[3:0];  // CT
                    6'h04: depth <= s_axi_wdata[10:0]; // DEPTH
                    6'h05: ridx  <= s_axi_wdata[5:0];  // RIDX
                    default: ;
                endcase
                if (aptr_cmd) act_wptr <= 0;
                s_axi_bvalid <= 1;
            end else if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 0;
            end
        end
    end

    wire ar_fire = s_axi_arvalid && !s_axi_rvalid;
    assign s_axi_arready = ar_fire;
    assign s_axi_rresp   = 2'b00;

    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_rvalid <= 0;
        end else begin
            if (ar_fire) begin
                case (s_axi_araddr[7:2])
                    6'h01: s_axi_rdata <= {30'b0, done, busy};
                    6'h03: s_axi_rdata <= {28'b0, ct};
                    6'h04: s_axi_rdata <= {21'b0, depth};
                    6'h05: s_axi_rdata <= {26'b0, ridx};
                    6'h06: s_axi_rdata <= acc_out[ridx*ACC_WIDTH +: ACC_WIDTH];
                    6'h07: s_axi_rdata <= 32'h7C0DE002;
                    6'h08: s_axi_rdata <= cycles;
                    default: s_axi_rdata <= 32'hDEADBEEF;
                endcase
                s_axi_rvalid <= 1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 0;
            end
        end
    end

endmodule

`default_nettype wire
