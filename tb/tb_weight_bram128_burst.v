// tb_weight_bram128_burst.v -- AXI4 INCR burst write coverage for weight_bram128
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Covers: AWLEN 0 / 1 / 15, lane-offset starts, 128-bit word crossings,
// partial WSTRB, back-to-back bursts, and the cycles/word the pager depends on.
`timescale 1ns/1ps
`default_nettype none

module tb_weight_bram128_burst;
    localparam AW = 18, IDW = 4;

    reg clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    reg  [IDW-1:0] awid = 0;
    reg  [AW-1:0]  awaddr = 0;
    reg  [7:0]     awlen = 0;
    reg  [2:0]     awsize = 3'd2;
    reg  [1:0]     awburst = 2'b01;
    reg            awvalid = 0;
    wire           awready;
    reg  [31:0]    wdata = 0;
    reg  [3:0]     wstrb = 4'hF;
    reg            wlast = 0, wvalid = 0;
    wire           wready;
    wire [IDW-1:0] bid;
    wire [1:0]     bresp;
    wire           bvalid;
    reg            bready = 1;

    reg  [AW-5:0]  w_word_addr = 0;
    wire [127:0]   w_word;
    integer errors = 0;
    integer i, t0, t1;

    weight_bram128 #(.ADDR_WIDTH(AW), .ID_WIDTH(IDW)) dut (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awid(awid), .s_axi_awaddr(awaddr), .s_axi_awlen(awlen),
        .s_axi_awsize(awsize), .s_axi_awburst(awburst), .s_axi_awlock(1'b0),
        .s_axi_awcache(4'd0), .s_axi_awprot(3'd0), .s_axi_awqos(4'd0),
        .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wlast(wlast),
        .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bid(bid), .s_axi_bresp(bresp), .s_axi_bvalid(bvalid),
        .s_axi_bready(bready),
        .s_axi_arid(4'd0), .s_axi_araddr(18'd0), .s_axi_arlen(8'd0),
        .s_axi_arsize(3'd2), .s_axi_arburst(2'b01), .s_axi_arlock(1'b0),
        .s_axi_arcache(4'd0), .s_axi_arprot(3'd0), .s_axi_arqos(4'd0),
        .s_axi_arvalid(1'b0), .s_axi_arready(), .s_axi_rid(), .s_axi_rdata(),
        .s_axi_rresp(), .s_axi_rlast(), .s_axi_rvalid(), .s_axi_rready(1'b1),
        .w_word_addr(w_word_addr), .w_word(w_word)
    );

    // one INCR burst of (len+1) beats, data = seed + beat index
    task burst(input [AW-1:0] a, input [7:0] len, input [31:0] seed,
               input [3:0] strb);
        integer k;
        begin
            @(posedge clk);
            awaddr <= a; awlen <= len; awvalid <= 1'b1; awburst <= 2'b01;
            @(posedge clk);
            while (!awready) @(posedge clk);
            awvalid <= 1'b0;
            for (k = 0; k <= len; k = k + 1) begin
                wdata  <= seed + k;
                wstrb  <= strb;
                wlast  <= (k == len);
                wvalid <= 1'b1;
                @(posedge clk);
                while (!wready) @(posedge clk);
            end
            wvalid <= 1'b0; wlast <= 1'b0;
            while (!bvalid) @(posedge clk);
            @(posedge clk);
        end
    endtask

    task expect_word(input [AW-5:0] wa, input [127:0] want);
        begin
            w_word_addr <= wa;
            @(posedge clk); @(posedge clk);
            if (w_word !== want) begin
                $display("FAIL word %0d: got %032x want %032x", wa, w_word, want);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        for (i = 0; i < 4096; i = i + 1) dut.bram[i] = 128'h0;  // BRAM has no reset
        repeat (4) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        // 1. AWLEN=15: 16 beats from 0 -> fills words 0..3 exactly
        t0 = $time;
        burst(18'h00000, 8'd15, 32'h1000_0000, 4'hF);
        t1 = $time;
        expect_word(0, {32'h1000_0003, 32'h1000_0002, 32'h1000_0001, 32'h1000_0000});
        expect_word(3, {32'h1000_000F, 32'h1000_000E, 32'h1000_000D, 32'h1000_000C});
        $display("burst16: %0d ns for 16 words = %0.2f cycles/word",
                 t1 - t0, (t1 - t0) / 10.0 / 16.0);

        // 2. AWLEN=0: single beat still works (AXI4-Lite compatibility)
        burst(18'h00100, 8'd0, 32'hAAAA_0000, 4'hF);
        expect_word(16, {96'h0, 32'hAAAA_0000});

        // 3. lane-offset start crossing a 128-bit word boundary:
        //    addr 0x20C is lane 3 of word 32; 2 beats spill into word 33 lane 0
        burst(18'h0020C, 8'd1, 32'hBBBB_0000, 4'hF);
        expect_word(32, {32'hBBBB_0000, 96'h0});
        expect_word(33, {96'h0, 32'hBBBB_0001});

        // 4. partial WSTRB: only byte 0 of each beat must land
        burst(18'h00300, 8'd1, 32'hCCCC_CCDD, 4'h1);
        expect_word(48, {64'h0, 24'h0, 8'hDE, 24'h0, 8'hDD});  // seed+1 = ..DE

        // 5. back-to-back bursts, no gap: second must not be swallowed
        burst(18'h00400, 8'd3, 32'h5555_0000, 4'hF);
        burst(18'h00410, 8'd3, 32'h6666_0000, 4'hF);
        expect_word(64, {32'h5555_0003, 32'h5555_0002, 32'h5555_0001, 32'h5555_0000});
        expect_word(65, {32'h6666_0003, 32'h6666_0002, 32'h6666_0001, 32'h6666_0000});

        // 6. throughput at the CDMA's working size: 256 B in 16-beat bursts
        t0 = $time;
        for (i = 0; i < 4; i = i + 1)
            burst(18'h01000 + i*64, 8'd15, 32'h7000_0000 + i*16, 4'hF);
        t1 = $time;
        $display("64 words in 4 bursts: %0d ns = %0.2f cycles/word",
                 t1 - t0, (t1 - t0) / 10.0 / 64.0);

        if (errors == 0) $display("TB PASS: all burst cases exact");
        else             $display("TB FAIL: %0d errors", errors);
        $finish;
    end
endmodule

`default_nettype wire
