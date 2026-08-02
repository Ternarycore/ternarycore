// tb_axi_gemm_wrapper.v
// Testbench for axi_gemm_wrapper — AXI4-Lite BFM drives ternary GEMM.
//
// Verifies: AXI4-Lite read/write handshake, register map, GEMM
// computation through the wrapper, done flag polling, and ACC_OUT readback.
//
// Run with: cd sim && make tb_axi_gemm_wrapper

`timescale 1ns / 1ps

`ifndef DEPTH_VAL
`define DEPTH_VAL 4
`endif

module tb_axi_gemm_wrapper;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter ROWS       = 4;
    parameter COLS       = 4;
    parameter DEPTH      = `DEPTH_VAL;

    reg         s_axi_aclk;
    reg         s_axi_aresetn;

    reg  [7:0]  s_axi_awaddr;
    reg  [2:0]  s_axi_awprot;
    reg         s_axi_awvalid;
    wire        s_axi_awready;

    reg  [31:0] s_axi_wdata;
    reg  [3:0]  s_axi_wstrb;
    reg         s_axi_wvalid;
    wire        s_axi_wready;

    wire [1:0]  s_axi_bresp;
    wire        s_axi_bvalid;
    reg         s_axi_bready;

    reg  [7:0]  s_axi_araddr;
    reg  [2:0]  s_axi_arprot;
    reg         s_axi_arvalid;
    wire        s_axi_arready;

    wire [31:0] s_axi_rdata;
    wire [1:0]  s_axi_rresp;
    wire        s_axi_rvalid;
    reg         s_axi_rready;

    axi_gemm_wrapper #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .COLS(COLS),
        .DEPTH(DEPTH)
    ) dut (
        .s_axi_aclk   (s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_awaddr (s_axi_awaddr),
        .s_axi_awprot (s_axi_awprot),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata  (s_axi_wdata),
        .s_axi_wstrb  (s_axi_wstrb),
        .s_axi_wvalid (s_axi_wvalid),
        .s_axi_wready (s_axi_wready),
        .s_axi_bresp  (s_axi_bresp),
        .s_axi_bvalid (s_axi_bvalid),
        .s_axi_bready (s_axi_bready),
        .s_axi_araddr (s_axi_araddr),
        .s_axi_arprot (s_axi_arprot),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        .s_axi_rdata  (s_axi_rdata),
        .s_axi_rresp  (s_axi_rresp),
        .s_axi_rvalid (s_axi_rvalid),
        .s_axi_rready (s_axi_rready)
    );

    initial s_axi_aclk = 0;
    always #5 s_axi_aclk = ~s_axi_aclk;

    initial begin
        $dumpfile("tb_axi_gemm_wrapper.vcd");
        $dumpvars(0, tb_axi_gemm_wrapper);
    end

    integer errors = 0;

    // ── AXI BFM tasks ──────────────────────────────────────────────

    task automatic axi_write;
        input [7:0]  addr;
        input [31:0] data;
        begin
            @(posedge s_axi_aclk);
            #1;
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1;
            s_axi_wdata   = data;
            s_axi_wvalid  = 1;
            s_axi_wstrb   = 4'hF;
            @(posedge s_axi_aclk);
            #1;
            s_axi_awvalid = 0;
            s_axi_wvalid  = 0;
            @(posedge s_axi_aclk);
            #1;
            s_axi_bready  = 1;
            @(posedge s_axi_aclk);
            #1;
            s_axi_bready  = 0;
            @(posedge s_axi_aclk);
        end
    endtask

    task automatic axi_read;
        input  [7:0]  addr;
        output [31:0] data;
        begin
            @(posedge s_axi_aclk);
            #1;
            s_axi_araddr  = addr;
            s_axi_arvalid = 1;
            @(posedge s_axi_aclk);
            #1;
            s_axi_arvalid = 0;
            @(posedge s_axi_aclk);
            #1;
            data = s_axi_rdata;
            s_axi_rready   = 1;
            @(posedge s_axi_aclk);
            #1;
            s_axi_rready   = 0;
            @(posedge s_axi_aclk);
        end
    endtask

    task automatic axi_poll_done;
        output reg done;
        reg [31:0] val;
        begin
            done = 0;
            while (!done) begin
                axi_read(8'h00, val);
                done = val[31];
            end
        end
    endtask

    // ── Test data generation ───────────────────────────────────────
    reg [2*COLS-1:0]         weight_rows [0:DEPTH-1];
    reg signed [DATA_WIDTH-1:0] act_mat [0:ROWS-1][0:DEPTH-1];
    reg signed [ACC_WIDTH-1:0]  expected  [0:ROWS-1][0:COLS-1];

    task automatic gen_test_data;
        integer r, c, k;
        integer w_tmp;
        reg signed [ACC_WIDTH-1:0] w_val;
        reg signed [ACC_WIDTH-1:0] a_val;
        reg [1:0] w_enc;
        begin
            for (k = 0; k < DEPTH; k = k + 1) begin
                weight_rows[k] = 0;
                for (c = 0; c < COLS; c = c + 1) begin
                    w_tmp = (c + k) % 3;
                    case (w_tmp)
                        0: weight_rows[k][2*c +: 2] = 2'b01;
                        1: weight_rows[k][2*c +: 2] = 2'b10;
                        2: weight_rows[k][2*c +: 2] = 2'b00;
                        default: weight_rows[k][2*c +: 2] = 2'b00;
                    endcase
                end
            end

            for (r = 0; r < ROWS; r = r + 1) begin
                for (k = 0; k < DEPTH; k = k + 1) begin
                    act_mat[r][k] = (r * 7 + k * 13 + 1) & 8'h7F;
                end
            end

            for (r = 0; r < ROWS; r = r + 1) begin
                for (c = 0; c < COLS; c = c + 1) begin
                    expected[r][c] = 0;
                    for (k = 0; k < DEPTH; k = k + 1) begin
                        w_enc = weight_rows[k][2*c +: 2];
                        if (w_enc == 2'b01) w_val = 1;
                        else if (w_enc == 2'b10) w_val = -1;
                        else w_val = 0;
                        a_val = $signed(act_mat[r][k]);
                        expected[r][c] = expected[r][c] + a_val * w_val;
                    end
                end
            end
        end
    endtask

    // ── Main test ──────────────────────────────────────────────────
    reg [31:0] rd_val;
    reg        done;
    integer    row, col, k;

    initial begin
        gen_test_data();

        s_axi_aresetn  = 0;
        s_axi_awaddr   = 0;
        s_axi_awvalid  = 0;
        s_axi_wdata    = 0;
        s_axi_wvalid   = 0;
        s_axi_wstrb    = 0;
        s_axi_bready   = 0;
        s_axi_araddr   = 0;
        s_axi_arvalid  = 0;
        s_axi_rready   = 0;

        @(posedge s_axi_aclk);
        @(posedge s_axi_aclk);
        s_axi_aresetn  = 1;
        @(posedge s_axi_aclk);
        @(posedge s_axi_aclk);

        $display("=== AXI4-Lite GEMM Wrapper Testbench (COLS=%0d DEPTH=%0d) ===", COLS, DEPTH);

        for (row = 0; row < ROWS; row = row + 1) begin
            $display("--- Row %0d ---", row);

            axi_write(8'h00, 32'h00000001);

            for (k = 0; k < DEPTH; k = k + 1) begin
                axi_write(8'h08, { {(32-2*COLS){1'b0}}, weight_rows[k] });
                axi_write(8'h04, { {24{1'b0}}, act_mat[row][k] });
            end

            axi_poll_done(done);

            for (col = 0; col < COLS; col = col + 1) begin
                axi_read(8'h10 + 4*col, rd_val);
                if ($signed(rd_val) !== expected[row][col]) begin
                    $display("FAIL row=%0d col=%0d: got=%0d expected=%0d",
                             row, col, $signed(rd_val), expected[row][col]);
                    errors = errors + 1;
                end else begin
                    $display("PASS row=%0d col=%0d: %0d", row, col, $signed(rd_val));
                end
            end
        end

        // ── CTRL register readback test ────────────────────────────
        $display("--- CTRL register readback ---");
        axi_write(8'h00, 32'h00000001);
        axi_read(8'h00, rd_val);
        if (rd_val[0] !== 1'b1) begin
            $display("FAIL CTRL start bit: got %b expected 1", rd_val[0]);
            errors = errors + 1;
        end else begin
            $display("PASS CTRL start bit = 1");
        end

        axi_write(8'h00, 32'h00000002);
        axi_read(8'h00, rd_val);
        if (rd_val[1] !== 1'b1) begin
            $display("FAIL CTRL rst_sw bit: got %b expected 1", rd_val[1]);
            errors = errors + 1;
        end else begin
            $display("PASS CTRL rst_sw bit = 1");
        end

        axi_write(8'h00, 32'h00000000);
        axi_read(8'h00, rd_val);
        if (rd_val[1:0] !== 2'b00) begin
            $display("FAIL CTRL clear: got %b expected 00", rd_val[1:0]);
            errors = errors + 1;
        end else begin
            $display("PASS CTRL cleared");
        end

        // ── WEIGHT_ENC register readback test ──────────────────────
        $display("--- WEIGHT_ENC register readback ---");
        axi_write(8'h08, 32'hDEADBEEF);
        axi_read(8'h08, rd_val);
        if (rd_val !== 32'hDEADBEEF) begin
            $display("FAIL WEIGHT_ENC_LO readback: got %h expected DEADBEEF", rd_val);
            errors = errors + 1;
        end else begin
            $display("PASS WEIGHT_ENC_LO readback = DEADBEEF");
        end

        axi_write(8'h0C, 32'hCAFEBABE);
        axi_read(8'h0C, rd_val);
        if (rd_val !== 32'hCAFEBABE) begin
            $display("FAIL WEIGHT_ENC_HI readback: got %h expected CAFEBABE", rd_val);
            errors = errors + 1;
        end else begin
            $display("PASS WEIGHT_ENC_HI readback = CAFEBABE");
        end

        $display("=== %0d error(s) ===", errors);
        if (errors == 0) $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
