// tb_rmsnorm_quant.v -- fabric normalizer against vectors captured from silicon
// SPDX-License-Identifier: CERN-OHL-S-2.0
//
// The reference is not a Python model of nq_core. It is what the board
// returned when nq_core actually ran, dumped by tools/dump_nq_vectors.py.
// Comparing against a reimplementation would only establish that two of my
// transcriptions agree with each other.
//
// Five cases, chosen for what they do to the reciprocal rather than for
// realism. 'spiky' pins six elements at full scale and leaves the rest near
// zero, so mx sits far above the bulk and almost every output lands on a
// rounding boundary -- that is where a narrowed reciprocal would show itself.
// 'small' keeps everything under 300, where the result is a handful of levels
// and any scale error is visibly the wrong one.
//
// The pass criterion is exact agreement with silicon, plus mx, ss and xs.
// If the reduced-precision multiply costs anything, this counts it.

`timescale 1ns/1ps
`default_nettype none

module tb_rmsnorm_quant;
    localparam MAXN = 4096, AW = 13;

    reg clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    reg               start = 0;
    reg  [AW-1:0]     n = 0;
    wire              busy, done;
    wire [31:0]       o_mx, o_ss;
    wire [4:0]        o_xs;
    reg               mem_we = 0;
    reg  [AW-1:0]     mem_addr = 0;
    reg signed [31:0] mem_x = 0, mem_g = 0;
    // the wrapper drives these separately; the datapath check fills both
    // at once, which is still a legal use of two independent ports
    reg  [AW-1:0]     o8_addr = 0;
    wire signed [7:0] o8_data;

    rmsnorm_quant #(.MAXN(MAXN), .AW(AW)) dut (
        .clk(clk), .rst_n(rst_n),
        .start(start), .n(n), .busy(busy), .done(done),
        .o_mx(o_mx), .o_ss(o_ss), .o_xs(o_xs),
        .xw_en(mem_we), .xw_addr(mem_addr), .xw_data(mem_x),
        .gw_en(mem_we), .gw_addr(mem_addr), .gw_data(mem_g),
        .o8_addr(o8_addr), .o8_data(o8_data)
    );

    reg signed [31:0] fx [0:MAXN-1];
    reg signed [31:0] fg [0:MAXN-1];
    reg signed [7:0]  fo [0:MAXN-1];

    integer j, bad, total_bad, cases_ok, t0, cyc;

    task run_case(input [8*32-1:0] name, input integer nn,
                  input integer want_mx, input integer want_ss,
                  input integer want_xs);
        begin
            @(posedge clk);
            for (j = 0; j < nn; j = j + 1) begin
                mem_we <= 1'b1; mem_addr <= j[AW-1:0];
                mem_x  <= fx[j]; mem_g <= fg[j];
                @(posedge clk);
            end
            mem_we <= 1'b0;
            n <= nn[AW-1:0];
            @(posedge clk);
            t0 = $time;
            start <= 1'b1; @(posedge clk); start <= 1'b0;
            while (!done) @(posedge clk);
            cyc = ($time - t0) / 10;

            bad = 0;
            for (j = 0; j < nn; j = j + 1) begin
                o8_addr <= j[AW-1:0];
                @(posedge clk);
                if (o8_data !== fo[j]) begin
                    if (bad < 4)
                        $display("    elem %0d: fabric %0d, silicon %0d",
                                 j, o8_data, fo[j]);
                    bad = bad + 1;
                end
            end
            total_bad = total_bad + bad;
            if (bad == 0 && o_mx == want_mx && o_ss == want_ss
                         && o_xs == want_xs) cases_ok = cases_ok + 1;

            $display("  %0s n=%0d %0d cycles (%0.2f/elem) mx %0s ss %0s xs %0s %0d/%0d differ",
                     name, nn, cyc, cyc * 1.0 / nn,
                     (o_mx == want_mx) ? "ok" : "BAD",
                     (o_ss == want_ss) ? "ok" : "BAD",
                     (o_xs == want_xs) ? "ok" : "BAD", bad, nn);
            if (o_mx !== want_mx)
                $display("    mx fabric %0d silicon %0d", o_mx, want_mx);
            if (o_ss !== want_ss)
                $display("    ss fabric %0d silicon %0d", o_ss, want_ss);
            if (o_xs !== want_xs)
                $display("    xs fabric %0d silicon %0d", o_xs, want_xs);
        end
    endtask

    initial begin
        total_bad = 0; cases_ok = 0;
        repeat (4) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);
        $display("fabric RMSNorm+quantizer vs nq_core on silicon\n");

        $readmemh("vectors/uniform/x.hex",  fx);
        $readmemh("vectors/uniform/g.hex",  fg);
        $readmemh("vectors/uniform/o8.hex", fo);
        run_case("uniform", 1024, 972207585, 1493787038, 4);

        $readmemh("vectors/gauss/x.hex",  fx);
        $readmemh("vectors/gauss/g.hex",  fg);
        $readmemh("vectors/gauss/o8.hex", fo);
        run_case("gauss", 1024, 717073028, 275580480, 4);

        $readmemh("vectors/spiky/x.hex",  fx);
        $readmemh("vectors/spiky/g.hex",  fg);
        $readmemh("vectors/spiky/o8.hex", fo);
        run_case("spiky", 1024, 984484515, 25308508, 4);

        $readmemh("vectors/wide/x.hex",  fx);
        $readmemh("vectors/wide/g.hex",  fg);
        $readmemh("vectors/wide/o8.hex", fo);
        run_case("wide", 3072, 598040870, 815837657, 4);

        $readmemh("vectors/small/x.hex",  fx);
        $readmemh("vectors/small/g.hex",  fg);
        $readmemh("vectors/small/o8.hex", fo);
        run_case("small", 1024, 8364114, 31481488, 0);

        $display("");
        if (cases_ok == 5 && total_bad == 0)
            $display("TB PASS: 5/5 exact against silicon");
        else
            $display("TB FAIL: %0d/5 cases exact, %0d elements differ",
                     cases_ok, total_bad);
        $finish;
    end
endmodule

`default_nettype wire
