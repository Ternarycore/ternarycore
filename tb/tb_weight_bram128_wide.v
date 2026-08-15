// tb_weight_bram128_wide.v -- 128-bit AXI4 write coverage for weight_bram128
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// The narrow testbench proves the 32-bit path, which is what the pager has
// been using: 1.25 cycles per 32-bit word, 3.2 bytes per cycle, 0.8125 ms
// a page. The block RAM behind that port has always been 128 bits wide and
// so has the MIG in front of it, so three quarters of the memory system was
// idle by construction.
//
// This covers the wide path. The cases are deliberately not the same ones:
// lane offsets and word crossings cannot happen when a beat is a whole word,
// and testing them again would look like coverage while proving nothing. The
// cases that matter here are the ones the width changes -- a 16-bit strobe
// mapping straight through, awsize=4 walking the address by 16, and the
// 256-beat burst the CDMA actually issues.
//
// House rule: silicon sees nothing simulation hasn't blessed.

`timescale 1ns/1ps
`default_nettype none

module tb_weight_bram128_wide;
    localparam AW = 18, IDW = 4, DW = 128;

    reg clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    reg  [IDW-1:0] awid = 0;
    reg  [AW-1:0]  awaddr = 0;
    reg  [7:0]     awlen = 0;
    reg  [2:0]     awsize = 3'd4;          // 16 bytes per beat
    reg  [1:0]     awburst = 2'b01;
    reg            awvalid = 0;
    wire           awready;
    reg  [127:0]   wdata = 0;
    reg  [15:0]    wstrb = 16'hFFFF;
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

    weight_bram128 #(.ADDR_WIDTH(AW), .ID_WIDTH(IDW), .DATA_WIDTH(DW)) dut (
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
        .s_axi_arsize(3'd4), .s_axi_arburst(2'b01), .s_axi_arlock(1'b0),
        .s_axi_arcache(4'd0), .s_axi_arprot(3'd0), .s_axi_arqos(4'd0),
        .s_axi_arvalid(1'b0), .s_axi_arready(), .s_axi_rid(), .s_axi_rdata(),
        .s_axi_rresp(), .s_axi_rlast(), .s_axi_rvalid(), .s_axi_rready(1'b1),
        .w_word_addr(w_word_addr), .w_word(w_word)
    );

    // one INCR burst of (len+1) 128-bit beats; beat k is four distinct words
    // rather than one repeated, so a beat landing in the wrong place shows up
    // as a wrong lane and not only as a wrong address
    task burst(input [AW-1:0] a, input [7:0] len, input [31:0] seed,
               input [15:0] strb);
        integer k;
        reg [31:0] b0, b1, b2, b3;
        begin
            @(posedge clk);
            awaddr <= a; awlen <= len; awvalid <= 1'b1; awburst <= 2'b01;
            awsize <= 3'd4;
            @(posedge clk);
            while (!awready) @(posedge clk);
            awvalid <= 1'b0;
            for (k = 0; k <= len; k = k + 1) begin
                b0 = seed + 4*k;      b1 = seed + 4*k + 1;
                b2 = seed + 4*k + 2;  b3 = seed + 4*k + 3;
                wdata  <= {b3, b2, b1, b0};
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
        for (i = 0; i < 4096; i = i + 1) dut.bram[i] = 128'h0;
        repeat (4) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        // 1. AWLEN=15: 16 beats is now 16 whole words, not four
        t0 = $time;
        burst(18'h00000, 8'd15, 32'h1000_0000, 16'hFFFF);
        t1 = $time;
        expect_word(0,  {32'h1000_0003, 32'h1000_0002,
                         32'h1000_0001, 32'h1000_0000});
        expect_word(15, {32'h1000_003F, 32'h1000_003E,
                         32'h1000_003D, 32'h1000_003C});
        $display("burst16: %0d ns for 16 words (256 B) = %0.2f cycles/word, %0.1f bytes/cycle", t1 - t0, (t1 - t0) / 10.0 / 16.0,
                 256.0 / ((t1 - t0) / 10.0));

        // 2. AWLEN=0: a single 128-bit beat
        burst(18'h00400, 8'd0, 32'hAAAA_0000, 16'hFFFF);
        expect_word(64, {32'hAAAA_0003, 32'hAAAA_0002,
                         32'hAAAA_0001, 32'hAAAA_0000});

        // 3. partial WSTRB: at 128 bits the strobes map straight through
        //    rather than being shifted by a lane, so this is the case the
        //    width actually changed. Bytes 4..7 only.
        expect_word(80, 128'h0);
        burst(18'h00500, 8'd0, 32'hCCCC_CCCC, 16'h00F0);
        expect_word(80, {64'h0, 32'hCCCC_CCCD, 32'h0});

        // 4. awsize=4 must walk the address by 16, not by 4
        burst(18'h00600, 8'd3, 32'hDDDD_0000, 16'hFFFF);
        expect_word(96, {32'hDDDD_0003, 32'hDDDD_0002,
                         32'hDDDD_0001, 32'hDDDD_0000});
        expect_word(99, {32'hDDDD_000F, 32'hDDDD_000E,
                         32'hDDDD_000D, 32'hDDDD_000C});

        // 5. back-to-back bursts, no gap
        burst(18'h00700, 8'd3, 32'h5555_0000, 16'hFFFF);
        burst(18'h00740, 8'd3, 32'h6666_0000, 16'hFFFF);
        expect_word(112, {32'h5555_0003, 32'h5555_0002,
                          32'h5555_0001, 32'h5555_0000});
        expect_word(116, {32'h6666_0003, 32'h6666_0002,
                          32'h6666_0001, 32'h6666_0000});

        // 6. AWLEN=255: the burst the CDMA is configured to issue, and the
        //    one that took the narrow path from 1.16 to 1.01 cycles/word
        t0 = $time;
        burst(18'h01000, 8'd255, 32'h7000_0000, 16'hFFFF);
        t1 = $time;
        expect_word(256, {32'h7000_0003, 32'h7000_0002,
                          32'h7000_0001, 32'h7000_0000});
        expect_word(511, {32'h7000_03FF, 32'h7000_03FE,
                          32'h7000_03FD, 32'h7000_03FC});
        $display("burst256: %0d ns for 256 words (4 KB) = %0.2f cycles/word, %0.1f bytes/cycle", t1 - t0, (t1 - t0) / 10.0 / 256.0,
                 4096.0 / ((t1 - t0) / 10.0));
        $display("a 256 KB page at that rate = %0.4f ms",
                 (t1 - t0) / 10.0 / 256.0 * 16384.0 / 100000.0);

        if (errors == 0) $display("TB PASS: 128-bit path exact");
        else             $display("TB FAIL: %0d errors", errors);
        $finish;
    end
endmodule

`default_nettype wire
