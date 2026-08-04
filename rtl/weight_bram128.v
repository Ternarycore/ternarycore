// weight_bram128.v -- 256 KB weight store: AXI4 burst write + 128-bit read port
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// Build-14 measurement: the AXI4-Lite slave this replaces cost ~5.9 cycles per
// 32-bit word -- every word needed its own AW + W + B round trip, and the
// SmartConnect protocol converter shredded the CDMA's bursts into singles.
// 256 KB took 4.75 ms, capping the board near 0.5 tok/s. This version accepts
// AXI4 INCR bursts: one address, N back-to-back beats, one response at WLAST.
//
// The read channel still returns 0xDEADBEEF (readback was removed to keep the
// block RAM at two ports) but is protocol-legal -- RID/RLAST -- so an upstream
// converter never stalls waiting for beats that will not come.

`default_nettype none

module weight_bram128 #(
    parameter ADDR_WIDTH = 18,           // byte-address width (256 KB)
    parameter ID_WIDTH   = 4,
    // 32 keeps the original, verified narrow path. 128 matches both the
    // block RAM behind this port and the MIG user interface in front of
    // it, and is the only reason paging costs 341 ms rather than 85.
    parameter DATA_WIDTH = 32
) (
    input  wire                     clk,
    input  wire                     rst_n,

    // AXI4 write address
    input  wire [ID_WIDTH-1:0]      s_axi_awid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [7:0]               s_axi_awlen,
    input  wire [2:0]               s_axi_awsize,
    input  wire [1:0]               s_axi_awburst,
    input  wire                     s_axi_awlock,
    input  wire [3:0]               s_axi_awcache,
    input  wire [2:0]               s_axi_awprot,
    input  wire [3:0]               s_axi_awqos,
    input  wire                     s_axi_awvalid,
    output wire                     s_axi_awready,

    // AXI4 write data / response
    input  wire [DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [DATA_WIDTH/8-1:0]  s_axi_wstrb,
    input  wire                     s_axi_wlast,
    input  wire                     s_axi_wvalid,
    output wire                     s_axi_wready,
    output wire [ID_WIDTH-1:0]      s_axi_bid,
    output wire [1:0]               s_axi_bresp,
    output reg                      s_axi_bvalid,
    input  wire                     s_axi_bready,

    // AXI4 read address
    input  wire [ID_WIDTH-1:0]      s_axi_arid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [7:0]               s_axi_arlen,
    input  wire [2:0]               s_axi_arsize,
    input  wire [1:0]               s_axi_arburst,
    input  wire                     s_axi_arlock,
    input  wire [3:0]               s_axi_arcache,
    input  wire [2:0]               s_axi_arprot,
    input  wire [3:0]               s_axi_arqos,
    input  wire                     s_axi_arvalid,
    output wire                     s_axi_arready,

    // AXI4 read data
    output wire [ID_WIDTH-1:0]      s_axi_rid,
    output wire [DATA_WIDTH-1:0]    s_axi_rdata,
    output wire [1:0]               s_axi_rresp,
    output wire                     s_axi_rlast,
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

    // -- AXI4 burst write: 32b lanes into 128b words -------------------------
    // Three states. IDLE takes the address; DATA streams beats and walks the
    // address itself; RESP issues one BVALID for the whole burst.
    localparam W_IDLE = 2'd0, W_DATA = 2'd1, W_RESP = 2'd2;

    reg [1:0]            wstate;
    reg [ADDR_WIDTH-1:0] waddr;
    reg [ID_WIDTH-1:0]   wid;
    reg [1:0]            wburst;
    reg [2:0]            wsize;

    assign s_axi_awready = (wstate == W_IDLE);
    assign s_axi_wready  = (wstate == W_DATA);
    assign s_axi_bresp   = 2'b00;
    assign s_axi_bid     = wid;

    wire w_beat = (wstate == W_DATA) && s_axi_wvalid;

    wire [ADDR_WIDTH-5:0] wr_word = waddr[ADDR_WIDTH-1:4];
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
    endgenerate

    integer bi;
    always @(posedge clk) begin
        if (!rst_n) begin
            wstate       <= W_IDLE;
            s_axi_bvalid <= 1'b0;
            waddr        <= {ADDR_WIDTH{1'b0}};
            wid          <= {ID_WIDTH{1'b0}};
            wburst       <= 2'b01;
            wsize        <= 3'd2;
        end else begin
            case (wstate)
            W_IDLE: if (s_axi_awvalid) begin
                waddr  <= s_axi_awaddr;
                wid    <= s_axi_awid;
                wburst <= s_axi_awburst;
                wsize  <= s_axi_awsize;
                wstate <= W_DATA;
            end
            W_DATA: if (s_axi_wvalid) begin
                for (bi = 0; bi < 16; bi = bi + 1)
                    if (wstrb16[bi])
                        bram[wr_word][bi*8 +: 8] <= wdata128[bi*8 +: 8];
                // INCR walks; FIXED holds. WRAP is not issued by the CDMA and
                // is treated as INCR -- asserted against in the testbench.
                if (wburst != 2'b00)
                    waddr <= waddr + (1 << wsize);
                if (s_axi_wlast) begin
                    s_axi_bvalid <= 1'b1;
                    wstate       <= W_RESP;
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

    // -- AXI4 read: protocol-legal stub (no readback; 2-port BRAM budget) ----
    reg [7:0]          rbeats;
    reg [ID_WIDTH-1:0] rid_r;

    assign s_axi_arready = !s_axi_rvalid && (rbeats == 8'd0);
    assign s_axi_rresp   = 2'b00;
    assign s_axi_rdata   = {(DATA_WIDTH/32){32'hDEADBEEF}};
    assign s_axi_rid     = rid_r;
    assign s_axi_rlast   = (rbeats == 8'd1);

    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_rvalid <= 1'b0;
            rbeats       <= 8'd0;
            rid_r        <= {ID_WIDTH{1'b0}};
        end else if (s_axi_arready && s_axi_arvalid) begin
            rid_r        <= s_axi_arid;
            rbeats       <= s_axi_arlen + 8'd1;
            s_axi_rvalid <= 1'b1;
        end else if (s_axi_rvalid && s_axi_rready) begin
            rbeats       <= rbeats - 8'd1;
            if (rbeats == 8'd1) s_axi_rvalid <= 1'b0;
        end
    end

endmodule

`default_nettype wire
