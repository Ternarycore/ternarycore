// rmsnorm_quant_axi.v -- AXI4 slave wrapper for the fabric normalizer
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// A slave, not a master, and that is a decision rather than a shortcut.
//
// The obvious design gives this unit its own AXI master port so it fetches
// x and g from DDR and writes the result back without help. Measured, that
// buys 0.1 ms of a 574 ms token -- two hundredths of one percent -- because
// the CDMA setup it would replace is five register writes per transfer and
// the transfers themselves run at memory bandwidth either way.
//
// What it would cost is a new master on the interconnect with a new address
// space. That is the exact ground where build 12 shipped a bitstream with a
// duplicate route to the weight memory, and build 13 shipped one whose CDMA
// had been silently excluded from the weight memory's address range -- both
// of which passed timing, reported zero errors, and computed zeros. Paying
// that risk for 0.02% would be a poor trade.
//
// So this looks like weight_bram128: a slave the CDMA writes into and reads
// out of, and a handful of control registers the MicroBlaze pokes. The
// address-map assertion that already guards CDMA-to-weight_bram extends to
// CDMA-to-here by analogy, which is the other reason to keep the shape.
//
// Aperture, 128 KB:
//
//   0x00000  x        4096 x 32b, written by the CDMA
//   0x04000  g        4096 x 32b, written by the CDMA
//   0x08000  o8       4096 x  8b, read by the CDMA, four per word
//   0x10000  ctrl     [12:0] n, bit 31 start
//   0x10004  status   bit0 busy, bit1 done
//   0x10008  mx       } valid while done, the three numbers the host
//   0x1000C  ss       } needs to reconstruct the output scale
//   0x10010  xs       }

`default_nettype none

module rmsnorm_quant_axi #(
    parameter MAXN       = 4096,
    parameter AW         = 13,
    parameter ADDR_WIDTH = 17,          // 128 KB aperture
    parameter ID_WIDTH   = 4
)(
    input  wire                     clk,
    input  wire                     rst_n,

    input  wire [ID_WIDTH-1:0]      s_axi_awid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [7:0]               s_axi_awlen,
    input  wire [2:0]               s_axi_awsize,
    input  wire [1:0]               s_axi_awburst,
    input  wire                     s_axi_awvalid,
    output wire                     s_axi_awready,
    input  wire [31:0]              s_axi_wdata,
    input  wire [3:0]               s_axi_wstrb,
    input  wire                     s_axi_wlast,
    input  wire                     s_axi_wvalid,
    output wire                     s_axi_wready,
    output wire [ID_WIDTH-1:0]      s_axi_bid,
    output wire [1:0]               s_axi_bresp,
    output reg                      s_axi_bvalid,
    input  wire                     s_axi_bready,

    input  wire [ID_WIDTH-1:0]      s_axi_arid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [7:0]               s_axi_arlen,
    input  wire [2:0]               s_axi_arsize,
    input  wire [1:0]               s_axi_arburst,
    input  wire                     s_axi_arvalid,
    output wire                     s_axi_arready,
    output wire [ID_WIDTH-1:0]      s_axi_rid,
    output reg  [31:0]              s_axi_rdata,
    output wire [1:0]               s_axi_rresp,
    output reg                      s_axi_rlast,
    output reg                      s_axi_rvalid,
    input  wire                     s_axi_rready
);

    // ---- write channel ---------------------------------------------------
    localparam W_IDLE = 2'd0, W_DATA = 2'd1, W_RESP = 2'd2;

    reg  [1:0]            wstate;
    reg  [ADDR_WIDTH-1:0] waddr;
    reg  [ID_WIDTH-1:0]   wid;
    reg  [1:0]            wburst;

    assign s_axi_awready = (wstate == W_IDLE);
    assign s_axi_wready  = (wstate == W_DATA);
    assign s_axi_bresp   = 2'b00;
    assign s_axi_bid     = wid;

    wire w_beat  = (wstate == W_DATA) && s_axi_wvalid;
    wire w_isreg = waddr[16];
    wire [1:0] w_region = waddr[15:14];

    wire xw_en = w_beat && !w_isreg && (w_region == 2'b00);
    wire gw_en = w_beat && !w_isreg && (w_region == 2'b01);
    wire [AW-1:0] w_idx = {{(AW-12){1'b0}}, waddr[13:2]};

    // ---- control registers ----------------------------------------------
    reg  [AW-1:0] r_n;
    reg           r_start;
    wire          busy, done;
    wire [31:0]   o_mx, o_ss;
    wire [4:0]    o_xs;

    always @(posedge clk) begin
        if (!rst_n) begin
            wstate <= W_IDLE; s_axi_bvalid <= 1'b0;
            r_n <= {AW{1'b0}}; r_start <= 1'b0;
        end else begin
            r_start <= 1'b0;                 // one cycle, self clearing
            case (wstate)
            W_IDLE: if (s_axi_awvalid) begin
                waddr  <= s_axi_awaddr;
                wid    <= s_axi_awid;
                wburst <= s_axi_awburst;
                wstate <= W_DATA;
            end
            W_DATA: begin
                if (s_axi_wvalid) begin
                    if (w_isreg && waddr[7:0] == 8'h00) begin
                        r_n     <= s_axi_wdata[AW-1:0];
                        r_start <= s_axi_wdata[31];
                    end
                    if (wburst != 2'b00) waddr <= waddr + 3'd4;
                    if (s_axi_wlast) begin
                        s_axi_bvalid <= 1'b1;
                        wstate       <= W_RESP;
                    end
                end
            end
            W_RESP: if (s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
                wstate       <= W_IDLE;
            end
            default: wstate <= W_IDLE;
            endcase
        end
    end

    // ---- read channel ----------------------------------------------------
    localparam R_IDLE = 2'd0, R_DATA = 2'd1;

    reg  [1:0]            rstate;
    reg  [ADDR_WIDTH-1:0] raddr;
    reg  [ID_WIDTH-1:0]   rid_r;
    reg  [8:0]            rbeats;

    assign s_axi_arready = (rstate == R_IDLE);
    assign s_axi_rid     = rid_r;
    assign s_axi_rresp   = 2'b00;

    wire [AW-3:0] o8_widx = raddr[13:2];
    wire [31:0]   o8_word;

    // The result region is the only readable memory. Everything else in the
    // aperture answers with a register or with zero -- a read that decodes
    // nowhere returns 0 rather than stalling, because a slave that never
    // answers is indistinguishable from a hung bus, and this design has
    // already lost days to a bus nobody was checking.
    wire [31:0] rmux = raddr[16]
        ? ((raddr[7:0] == 8'h04) ? {30'd0, done, busy}
         : (raddr[7:0] == 8'h08) ? o_mx
         : (raddr[7:0] == 8'h0C) ? o_ss
         : (raddr[7:0] == 8'h10) ? {27'd0, o_xs}
         : 32'd0)
        : ((raddr[15:14] == 2'b10) ? o8_word : 32'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            rstate <= R_IDLE; s_axi_rvalid <= 1'b0; s_axi_rlast <= 1'b0;
        end else begin
            case (rstate)
            R_IDLE: if (s_axi_arvalid) begin
                raddr  <= s_axi_araddr;
                rid_r  <= s_axi_arid;
                rbeats <= {1'b0, s_axi_arlen};
                rstate <= R_DATA;
                s_axi_rvalid <= 1'b1;
                s_axi_rlast  <= (s_axi_arlen == 8'd0);
            end
            R_DATA: if (s_axi_rready) begin
                if (rbeats == 9'd0) begin
                    s_axi_rvalid <= 1'b0;
                    s_axi_rlast  <= 1'b0;
                    rstate       <= R_IDLE;
                end else begin
                    raddr       <= raddr + 3'd4;
                    rbeats      <= rbeats - 1'b1;
                    s_axi_rlast <= (rbeats == 9'd1);
                end
            end
            default: rstate <= R_IDLE;
            endcase
        end
    end

    always @(posedge clk) s_axi_rdata <= rmux;

    // ---- the datapath ----------------------------------------------------
    rmsnorm_quant #(.MAXN(MAXN), .AW(AW)) core (
        .clk(clk), .rst_n(rst_n),
        .start(r_start), .n(r_n), .busy(busy), .done(done),
        .o_mx(o_mx), .o_ss(o_ss), .o_xs(o_xs),
        .xw_en(xw_en), .xw_addr(w_idx), .xw_data(s_axi_wdata),
        .gw_en(gw_en), .gw_addr(w_idx), .gw_data(s_axi_wdata),
        .o8_addr({AW{1'b0}}), .o8_data(),
        .o8_widx(o8_widx), .o8_word(o8_word)
    );

endmodule

`default_nettype wire
