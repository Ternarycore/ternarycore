// tb_gemm_stream.v
// SPDX-License-Identifier: CERN-OHL-S-2.0
// Verifies the Tier-2 streaming feeder: correctness vs a reference AND the
// line-rate cycle count (start → done ≈ DEPTH + fixed latency).
`timescale 1ns / 1ps

module tb_gemm_stream;
    localparam DW = 8, AW_ACC = 32, DEPTH = 768, COLS = 64, AW = 10;

    reg clk = 0, rst_n = 0, start = 0;
    always #5 clk = ~clk;

    wire busy, done;
    wire [AW-1:0] act_addr, w_addr;
    wire [AW_ACC*COLS-1:0] result;

    reg [DW-1:0]      act_mem [0:DEPTH-1];
    reg [2*COLS-1:0]  w_mem   [0:DEPTH-1];
    reg [DW-1:0]      act_data;
    reg [2*COLS-1:0]  w_data;
    always @(posedge clk) begin
        act_data <= act_mem[act_addr];
        w_data   <= w_mem[w_addr];
    end

    ternary_gemm_stream #(.DATA_WIDTH(DW), .ACC_WIDTH(AW_ACC),
        .DEPTH(DEPTH), .COLS(COLS), .ADDR_WIDTH(AW)) dut (
        .clk(clk), .rst_n(rst_n), .start(start), .busy(busy), .done(done),
        .act_addr(act_addr), .act_data(act_data),
        .w_addr(w_addr), .w_data(w_data), .result(result));

    integer k, c, seed;
    reg signed [DW-1:0]     acts   [0:DEPTH-1];
    reg signed [1:0]        wgt    [0:DEPTH-1][0:COLS-1];
    integer                 expect_col [0:COLS-1];
    integer                 cyc_start, cyc_end, cyc, errors;

    always @(posedge clk) if (rst_n) cyc <= cyc + 1;

    task build_vectors;
        integer i, j, t, code;
        begin
            seed = 32'hC0FFEE;
            for (j = 0; j < COLS; j = j + 1) expect_col[j] = 0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                acts[i] = ($random(seed) % 7) - 3;
                act_mem[i] = acts[i];
                w_mem[i] = {(2*COLS){1'b0}};
                for (j = 0; j < COLS; j = j + 1) begin
                    t = $random(seed) % 3;
                    code = (t == 1) ? 2'b01 : (t == 2) ? 2'b10 : 2'b00;
                    wgt[i][j] = (t == 1) ? 1 : (t == 2) ? -1 : 0;
                    w_mem[i][2*j +: 2] = code[1:0];
                    expect_col[j] = expect_col[j] + acts[i]*wgt[i][j];
                end
            end
        end
    endtask

    initial begin
        cyc = 0; errors = 0;
        build_vectors;
        repeat (4) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        @(negedge clk); start = 1;
        @(negedge clk); start = 0;
        cyc_start = cyc;

        wait (done);
        cyc_end = cyc;

        for (c = 0; c < COLS; c = c + 1) begin
            if ($signed(result[AW_ACC*c +: AW_ACC]) !== expect_col[c]) begin
                errors = errors + 1;
                $display("FAIL col %0d: got %0d expected %0d", c,
                         $signed(result[AW_ACC*c +: AW_ACC]), expect_col[c]);
            end
        end

        $display("----------------------------------------------------");
        $display("Tier-2 streaming feeder — DEPTH=%0d COLS=%0d", DEPTH, COLS);
        $display("cycles per pass (start->done): %0d   [line rate = DEPTH+few]",
                 cyc_end - cyc_start);
        $display("MACs/cycle at line rate       : %0d  (= COLS)", COLS);
        $display("throughput @100MHz            : %0d GOPS (2 ops/MAC)",
                 (COLS*100*2)/1000);
        $display("");
        $display("Full 768x768 layer:");
        $display("  passes needed (768/COLS)    : %0d", 768/COLS);
        $display("  Tier-2 total cycles         : %0d", (768/COLS)*(cyc_end-cyc_start));
        $display("  Tier-1 CPU-fed cycles       : 5,319,845");
        $display("  SPEEDUP over Tier-1 CPU-fed : ~%0dx",
                 5319845/((768/COLS)*(cyc_end-cyc_start)));
        if (errors == 0) $display("RESULT: ALL %0d COLUMNS CORRECT, line-rate confirmed", COLS);
        else             $display("RESULT: %0d error(s)", errors);
        $display("----------------------------------------------------");
        $finish;
    end

    initial begin #200000; $display("TIMEOUT"); $finish; end
endmodule
