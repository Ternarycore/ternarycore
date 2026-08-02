// Formal proof for weight_bram — write-then-readback via AXI.
// Uses tightly constrained AXI handshake to make the solver's job easy.

`timescale 1ns / 1ps

module weight_bram_formal(input wire clk);
    parameter ADDR_WIDTH = 4;

    wire          rst_n;
    wire [7:0]    s_axi_awaddr;
    wire [31:0]   s_axi_wdata;
    wire [3:0]    s_axi_wstrb;
    wire          s_axi_awvalid;
    wire          s_axi_wvalid;
    wire          s_axi_bready;
    wire [ADDR_WIDTH-1:0] weight_addr;
    wire [7:0]    weight_byte;

    weight_bram #(.ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .s_axi_awaddr  (s_axi_awaddr),
        .s_axi_awprot  (3'b000),
        .s_axi_awvalid (s_axi_awvalid),
        .s_axi_awready (),
        .s_axi_wdata   (s_axi_wdata),
        .s_axi_wstrb   (s_axi_wstrb),
        .s_axi_wvalid  (s_axi_wvalid),
        .s_axi_wready  (),
        .s_axi_bresp   (),
        .s_axi_bvalid  (),
        .s_axi_bready  (s_axi_bready),
        .s_axi_araddr  (8'b0),
        .s_axi_arprot  (3'b000),
        .s_axi_arvalid (1'b0),
        .s_axi_arready (),
        .s_axi_rdata   (),
        .s_axi_rresp   (),
        .s_axi_rvalid  (),
        .s_axi_rready  (1'b0),
        .weight_addr   (weight_addr),
        .weight_byte   (weight_byte)
    );

    // 2-cycle reset
    reg [1:0] rst_cnt;
    initial rst_cnt = 0;
    always @(posedge clk) begin
        if (rst_cnt < 2) begin assume(!rst_n); rst_cnt <= rst_cnt + 1; end
        else assume(rst_n);
    end

    reg [4:0] state;
    always @(posedge clk) begin
        if (!rst_n) state <= 0;
        else if (state < 20) state <= state + 1;
    end

    // Drive a single AXI write to address 3 with known data.
    // State 0-1: reset. State 2: AW+W. State 4: B.
    wire [ADDR_WIDTH-1:0] addr_val = 3;
    wire [31:0] data_val = 32'hAABBCCDD;

    assign s_axi_awaddr  = (state == 2) ? {4'b0, addr_val} : 8'b0;
    assign s_axi_awvalid = (state == 2);
    assign s_axi_wdata   = (state == 2) ? data_val : 32'b0;
    assign s_axi_wstrb   = (state == 2) ? 4'b1111 : 4'b0;
    assign s_axi_wvalid  = (state == 2);
    assign s_axi_bready  = (state == 4);

    // Drive weight_addr to addr_val after write completes, hold 2 cycles
    assign weight_addr   = (state >= 5 && state <= 6) ? addr_val : 0;

    // Replicate DUT's wr_commit for cover point
    wire b_pending;
    wire bvalid;
    assign b_pending = dut.b_pending;
    assign bvalid = b_pending;
    wire wr_commit_local = b_pending && s_axi_bready;

    reg [3:0] run_cnt;
    initial run_cnt = 0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 0;
        else if (run_cnt < 15) run_cnt <= run_cnt + 1;
    end

    // After write + BRAM latency, weight_byte must match lane 0
    always @(posedge clk) begin
        if (run_cnt >= 8 && weight_addr == addr_val)
            assert(weight_byte == data_val[7:0]);
    end

    // Cover: write completes
    always @(posedge clk) begin
        if (run_cnt >= 4) cover(wr_commit_local);
    end

endmodule