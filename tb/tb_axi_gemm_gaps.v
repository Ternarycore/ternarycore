// tb_axi_gemm_gaps.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Regression for the on-hardware Tier 1 failure (July 2026):
// a CPU feeding the wrapper over AXI leaves long idle gaps between writes.
// ternary_dot holds valid_out high across those gaps while its accumulator
// resets, so a level-sensitive latch in the wrapper is rewritten with zeros
// and DONE can never be cleared by a CTRL write. This bench drives the
// wrapper with MicroBlaze-like gaps (~20 cycles between transactions) and
// checks (a) correct nonzero results, (b) DONE clears on CTRL write.
`timescale 1ns / 1ps

module tb_axi_gemm_gaps;
    localparam DEPTH = 8;
    localparam COLS  = 4;
    localparam GAP   = 20;

    reg clk = 0, rstn = 0;
    always #5 clk = ~clk;

    // AXI4-Lite master signals
    reg  [7:0]  awaddr;  reg awvalid;  wire awready;
    reg  [31:0] wdata;   reg wvalid;   wire wready;
    wire [1:0]  bresp;   wire bvalid;  reg bready;
    reg  [7:0]  araddr;  reg arvalid;  wire arready;
    wire [31:0] rdata;   wire rvalid;  wire [1:0] rresp; reg rready;

    axi_gemm_wrapper #(.DEPTH(DEPTH), .COLS(COLS)) dut (
        .s_axi_aclk(clk), .s_axi_aresetn(rstn),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(4'hF), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rvalid(rvalid), .s_axi_rresp(rresp), .s_axi_rready(rready)
    );

    integer errors = 0;

    task axi_write(input [7:0] addr, input [31:0] data);
        begin
            @(posedge clk); #1;
            awaddr = addr; awvalid = 1; wdata = data; wvalid = 1; bready = 1;
            wait (awready && wready);
            @(posedge clk); #1;
            awvalid = 0; wvalid = 0;
            wait (bvalid);
            @(posedge clk); #1;
            bready = 0;
            repeat (GAP) @(posedge clk);   // CPU-like idle gap
        end
    endtask

    task axi_read(input [7:0] addr, output [31:0] data);
        begin
            @(posedge clk); #1;
            araddr = addr; arvalid = 1; rready = 1;
            wait (arready);
            @(posedge clk); #1;
            arvalid = 0;
            wait (rvalid);
            data = rdata;
            @(posedge clk); #1;
            rready = 0;
            repeat (GAP) @(posedge clk);
        end
    endtask

    reg [31:0] rd;
    integer k, v;
    integer expect0, expect1;

    initial begin
        awvalid = 0; wvalid = 0; bready = 0; arvalid = 0; rready = 0;
        repeat (5) @(posedge clk);
        rstn = 1;
        repeat (5) @(posedge clk);

        for (v = 0; v < 2; v = v + 1) begin
            // weights: col0=+1, col1=-1, col2=0, col3=+1 -> 8'b01_00_10_01
            axi_write(8'h00, 32'h1);            // CTRL: start (clears done)
            axi_read(8'h00, rd);
            if (rd[31] !== 1'b0 && v > 0) begin
                errors = errors + 1;
                $display("FAIL vec%0d: DONE did not clear on CTRL write (CTRL=%h)", v, rd);
            end
            expect0 = 0;
            for (k = 0; k < DEPTH; k = k + 1) begin
                axi_write(8'h08, 8'b01_00_10_01);
                axi_write(8'h04, (k + 1 + v));  // activations 1..8 (+v offset)
                expect0 = expect0 + (k + 1 + v);
            end
            expect1 = -expect0;

            axi_read(8'h00, rd);
            if (rd[31] !== 1'b1) begin
                errors = errors + 1;
                $display("FAIL vec%0d: DONE not set after %0d elements (CTRL=%h)", v, DEPTH, rd);
            end
            axi_read(8'h10, rd);
            if ($signed(rd) !== expect0) begin
                errors = errors + 1;
                $display("FAIL vec%0d col0: got %0d expected %0d", v, $signed(rd), expect0);
            end else $display("PASS vec%0d col0 = %0d", v, $signed(rd));
            axi_read(8'h14, rd);
            if ($signed(rd) !== expect1) begin
                errors = errors + 1;
                $display("FAIL vec%0d col1: got %0d expected %0d", v, $signed(rd), expect1);
            end else $display("PASS vec%0d col1 = %0d", v, $signed(rd));
            axi_read(8'h18, rd);
            if ($signed(rd) !== 0) begin
                errors = errors + 1;
                $display("FAIL vec%0d col2: got %0d expected 0", v, $signed(rd));
            end else $display("PASS vec%0d col2 = 0", v);
        end

        if (errors == 0) $display("ALL GAP TESTS PASSED");
        else begin
            $display("=== %0d error(s) ===", errors);
            $fatal(1, "AXI gap regression failed");
        end
        $finish;
    end

    initial begin
        #5000000;
        $fatal(1, "AXI gap regression timeout");
    end
endmodule
