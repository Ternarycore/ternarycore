// tb_rmsnorm_quant_axi.v -- the normalizer through its AXI port
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// The datapath is already exact against silicon. What this checks is the
// wrapper: that x and g arrive intact through burst writes, that the control
// register starts a run, that a polled status flag can actually be observed,
// and that the result reads back through a burst with the right data on the
// FIRST beat as well as the rest.
//
// That last one is the reason this exists. rdata is registered, so a read mux
// driven from the current address serves stale data on beat zero and correct
// data on every beat after -- which looks fine in a waveform, passes a
// single-beat test, and corrupts exactly one element in 256.
//
// The transactions are the ones the CDMA actually issues: 256-beat INCR
// bursts, because that is what took the pager from 1.16 to 1.01 cycles/word
// and it is what will move these vectors too.

`timescale 1ns/1ps
`default_nettype none

module tb_rmsnorm_quant_axi;
    localparam MAXN = 4096, AW = 13, ADDR_WIDTH = 17, IDW = 4;

    reg clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    reg  [IDW-1:0]        awid = 0;
    reg  [ADDR_WIDTH-1:0] awaddr = 0;
    reg  [7:0]            awlen = 0;
    reg                   awvalid = 0;
    wire                  awready;
    reg  [31:0]           wdata = 0;
    reg                   wlast = 0, wvalid = 0;
    wire                  wready;
    wire [1:0]            bresp;
    wire                  bvalid;
    reg                   bready = 1;

    reg  [ADDR_WIDTH-1:0] araddr = 0;
    reg  [7:0]            arlen = 0;
    reg                   arvalid = 0;
    wire                  arready;
    wire [31:0]           rdata;
    wire                  rlast, rvalid;
    reg                   rready = 1;

    rmsnorm_quant_axi #(.MAXN(MAXN), .AW(AW), .ADDR_WIDTH(ADDR_WIDTH),
                        .ID_WIDTH(IDW)) dut (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awid(awid), .s_axi_awaddr(awaddr), .s_axi_awlen(awlen),
        .s_axi_awsize(3'd2), .s_axi_awburst(2'b01),
        .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(4'hF), .s_axi_wlast(wlast),
        .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bid(), .s_axi_bresp(bresp), .s_axi_bvalid(bvalid),
        .s_axi_bready(bready),
        .s_axi_arid(4'd0), .s_axi_araddr(araddr), .s_axi_arlen(arlen),
        .s_axi_arsize(3'd2), .s_axi_arburst(2'b01),
        .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rid(), .s_axi_rdata(rdata), .s_axi_rresp(),
        .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready)
    );

    reg signed [31:0] fx [0:MAXN-1];
    reg signed [31:0] fg [0:MAXN-1];
    reg signed [7:0]  fo [0:MAXN-1];
    reg        [31:0] rbuf [0:1023];

    integer j, k, bad, total_bad, cases_ok;
    reg [31:0] rv;

    // one INCR burst of (len+1) words, taken from fx (sel=0) or fg (sel=1)
    task wr_burst(input [ADDR_WIDTH-1:0] a, input integer base,
                  input integer len, input integer sel);
        begin
            @(posedge clk);
            awaddr <= a; awlen <= len[7:0]; awvalid <= 1'b1;
            @(posedge clk);
            while (!awready) @(posedge clk);
            awvalid <= 1'b0;
            for (k = 0; k <= len; k = k + 1) begin
                wdata  <= sel ? fg[base + k] : fx[base + k];
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

    task wr_reg(input [ADDR_WIDTH-1:0] a, input [31:0] d);
        begin
            @(posedge clk);
            awaddr <= a; awlen <= 8'd0; awvalid <= 1'b1;
            @(posedge clk);
            while (!awready) @(posedge clk);
            awvalid <= 1'b0;
            wdata <= d; wlast <= 1'b1; wvalid <= 1'b1;
            @(posedge clk);
            while (!wready) @(posedge clk);
            wvalid <= 1'b0; wlast <= 1'b0;
            while (!bvalid) @(posedge clk);
            @(posedge clk);
        end
    endtask

    task rd_reg(input [ADDR_WIDTH-1:0] a, output [31:0] d);
        begin
            @(posedge clk);
            araddr <= a; arlen <= 8'd0; arvalid <= 1'b1;
            @(posedge clk);
            while (!arready) @(posedge clk);
            arvalid <= 1'b0;
            while (!rvalid) @(posedge clk);
            d = rdata;
            @(posedge clk);
        end
    endtask

    // burst read into rbuf[base ..], which is where the first-beat bug shows
    task rd_burst(input [ADDR_WIDTH-1:0] a, input integer base,
                  input integer len);
        begin
            @(posedge clk);
            araddr <= a; arlen <= len[7:0]; arvalid <= 1'b1;
            @(posedge clk);
            while (!arready) @(posedge clk);
            arvalid <= 1'b0;
            for (k = 0; k <= len; k = k + 1) begin
                while (!rvalid) @(posedge clk);
                rbuf[base + k] = rdata;
                @(posedge clk);
            end
        end
    endtask

    task run_case(input [8*32-1:0] name, input integer nn,
                  input integer want_mx, input integer want_ss,
                  input integer want_xs);
        integer nb, w, got;
        begin
            for (j = 0; j < nn; j = j + 256)
                wr_burst(j * 4, j, 255, 0);              // x at 0x00000
            for (j = 0; j < nn; j = j + 256)
                wr_burst(17'h04000 + j * 4, j, 255, 1);  // g at 0x04000

            wr_reg(17'h10000, {1'b1, 18'd0, nn[12:0]});  // n, start

            rv = 0;
            while (!rv[1]) rd_reg(17'h10004, rv);        // poll done

            nb = nn / 4;                                  // words of o8
            for (j = 0; j < nb; j = j + 256)
                rd_burst(17'h08000 + j * 4, j, 255);

            bad = 0;
            for (j = 0; j < nn; j = j + 1) begin
                w   = rbuf[j / 4];
                got = $signed(w[(j % 4) * 8 +: 8]);
                if (got !== fo[j]) begin
                    if (bad < 4)
                        $display("    elem %0d: axi %0d, silicon %0d",
                                 j, got, fo[j]);
                    bad = bad + 1;
                end
            end
            total_bad = total_bad + bad;

            rd_reg(17'h10008, rv);
            if (rv !== want_mx) $display("    mx axi %0d silicon %0d",
                                         rv, want_mx);
            bad = bad + (rv !== want_mx);
            rd_reg(17'h1000C, rv);
            if (rv !== want_ss) $display("    ss axi %0d silicon %0d",
                                         rv, want_ss);
            bad = bad + (rv !== want_ss);
            rd_reg(17'h10010, rv);
            if (rv !== want_xs) $display("    xs axi %0d silicon %0d",
                                         rv, want_xs);
            bad = bad + (rv !== want_xs);

            if (bad == 0) cases_ok = cases_ok + 1;
            $display("  %0s n=%0d  %0s", name, nn,
                     (bad == 0) ? "exact through AXI" : "MISMATCH");
        end
    endtask

    initial begin
        total_bad = 0; cases_ok = 0;
        repeat (4) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);
        $display("fabric normalizer through its AXI port\n");

        $readmemh("vectors/uniform/x.hex",  fx);
        $readmemh("vectors/uniform/g.hex",  fg);
        $readmemh("vectors/uniform/o8.hex", fo);
        run_case("uniform", 1024, 972207585, 1493787038, 4);

        $readmemh("vectors/spiky/x.hex",  fx);
        $readmemh("vectors/spiky/g.hex",  fg);
        $readmemh("vectors/spiky/o8.hex", fo);
        run_case("spiky", 1024, 984484515, 25308508, 4);

        $readmemh("vectors/wide/x.hex",  fx);
        $readmemh("vectors/wide/g.hex",  fg);
        $readmemh("vectors/wide/o8.hex", fo);
        run_case("wide", 3072, 598040870, 815837657, 4);

        $display("");
        if (cases_ok == 3 && total_bad == 0)
            $display("TB PASS: 3/3 exact through AXI");
        else begin
            $display("TB FAIL: %0d/3 cases exact, %0d elements differ",
                     cases_ok, total_bad);
            $fatal(1, "RMSNorm AXI regression failed");
        end
        $finish;
    end

    initial begin
        #5000000;
        $fatal(1, "RMSNorm AXI regression timeout");
    end
endmodule

`default_nettype wire
