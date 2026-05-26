// tb_weight_bram.v
// Testbench for weight_bram — AXI4-Lite BFM drives BRAM weight cache.
//
// Verifies: AXI4-Lite write/read handshake, BRAM write,
// weight port readback, and data integrity.
//
// Run with: cd sim && make tb_weight_bram

`timescale 1ns / 1ps

`ifndef ADDR_WIDTH_VAL
`define ADDR_WIDTH_VAL 4
`endif

module tb_weight_bram;

    parameter ADDR_WIDTH = `ADDR_WIDTH_VAL;
    parameter DATA_WIDTH = 8;

    reg                     clk;
    reg                     rst_n;

    reg  [ADDR_WIDTH-1:0]   s_axi_awaddr;
    reg  [2:0]              s_axi_awprot;
    reg                     s_axi_awvalid;
    wire                    s_axi_awready;

    reg  [31:0]             s_axi_wdata;
    reg  [3:0]              s_axi_wstrb;
    reg                     s_axi_wvalid;
    wire                    s_axi_wready;

    wire [1:0]              s_axi_bresp;
    wire                    s_axi_bvalid;
    reg                     s_axi_bready;

    reg  [ADDR_WIDTH-1:0]   s_axi_araddr;
    reg  [2:0]              s_axi_arprot;
    reg                     s_axi_arvalid;
    wire                    s_axi_arready;

    wire [31:0]             s_axi_rdata;
    wire [1:0]              s_axi_rresp;
    wire                    s_axi_rvalid;
    reg                     s_axi_rready;

    reg  [ADDR_WIDTH-1:0]   weight_addr;
    wire [DATA_WIDTH-1:0]   weight_byte;

    weight_bram #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .s_axi_awaddr  (s_axi_awaddr),
        .s_axi_awprot  (s_axi_awprot),
        .s_axi_awvalid (s_axi_awvalid),
        .s_axi_awready (s_axi_awready),
        .s_axi_wdata   (s_axi_wdata),
        .s_axi_wstrb   (s_axi_wstrb),
        .s_axi_wvalid  (s_axi_wvalid),
        .s_axi_wready  (s_axi_wready),
        .s_axi_bresp   (s_axi_bresp),
        .s_axi_bvalid  (s_axi_bvalid),
        .s_axi_bready  (s_axi_bready),
        .s_axi_araddr  (s_axi_araddr),
        .s_axi_arprot  (s_axi_arprot),
        .s_axi_arvalid (s_axi_arvalid),
        .s_axi_arready (s_axi_arready),
        .s_axi_rdata   (s_axi_rdata),
        .s_axi_rresp   (s_axi_rresp),
        .s_axi_rvalid  (s_axi_rvalid),
        .s_axi_rready  (s_axi_rready),
        .weight_addr   (weight_addr),
        .weight_byte   (weight_byte)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_weight_bram.vcd");
        $dumpvars(0, tb_weight_bram);
    end

    integer errors = 0;

    // ── AXI BFM tasks ──────────────────────────────────────────────

    task automatic axi_write;
        input [ADDR_WIDTH-1:0] addr;
        input [31:0]           data;
        input [3:0]            strb;
        begin
            @(posedge clk);
            #1;
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1;
            s_axi_wdata   = data;
            s_axi_wvalid  = 1;
            s_axi_wstrb   = strb;
            @(posedge clk);
            #1;
            s_axi_awvalid = 0;
            s_axi_wvalid  = 0;
            @(posedge clk);
            #1;
            s_axi_bready  = 1;
            @(posedge clk);
            #1;
            s_axi_bready  = 0;
            @(posedge clk);
        end
    endtask

    task automatic axi_read;
        input  [ADDR_WIDTH-1:0] addr;
        output [31:0]           data;
        begin
            @(posedge clk);
            #1;
            s_axi_araddr  = addr;
            s_axi_arvalid = 1;
            @(posedge clk);
            #1;
            s_axi_arvalid = 0;
            @(posedge clk);
            #1;
            data = s_axi_rdata;
            s_axi_rready   = 1;
            @(posedge clk);
            #1;
            s_axi_rready   = 0;
            @(posedge clk);
        end
    endtask

    // ── Weight port read task ──────────────────────────────────────
    task automatic weight_read;
        input  [ADDR_WIDTH-1:0] addr;
        output [7:0]            data;
        begin
            weight_addr = addr;
            @(posedge clk);
            #1;
            data = weight_byte;
        end
    endtask

    // ── Test data ──────────────────────────────────────────────────
    // 16 ternary weights packed into 4 bytes.
    // Each byte: bits[1:0]=w0, bits[3:2]=w1, bits[5:4]=w2, bits[7:6]=w3
    // Encoding: 00=zero, 01=+1, 10=-1
    //
    // Byte 0 (addr 0): w0=01(+1), w1=10(-1), w2=00(0), w3=01(+1) → 0x49
    // Byte 1 (addr 1): w0=10(-1), w1=00(0), w2=01(+1), w3=10(-1) → 0x92
    // Byte 2 (addr 2): w0=00(0), w1=01(+1), w2=01(+1), w3=00(0)   → 0x14
    // Byte 3 (addr 3): w0=01(+1), w1=10(-1), w2=10(-1), w3=00(0)  → 0x29

    reg [7:0] expected_bytes [0:3];
    reg [7:0] wb_read;
    reg [31:0] rd_val;
    integer  i;
    reg [ADDR_WIDTH-1:0] tmp_addr;

    // ── Main test ──────────────────────────────────────────────────
    initial begin
        expected_bytes[0] = 8'h49;
        expected_bytes[1] = 8'h92;
        expected_bytes[2] = 8'h14;
        expected_bytes[3] = 8'h29;

        s_axi_awaddr   = 0;
        s_axi_awvalid  = 0;
        s_axi_wdata    = 0;
        s_axi_wvalid   = 0;
        s_axi_wstrb    = 0;
        s_axi_bready   = 0;
        s_axi_araddr   = 0;
        s_axi_arvalid  = 0;
        s_axi_rready   = 0;
        weight_addr    = 0;

        rst_n = 0;
        @(posedge clk);
        @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        @(posedge clk);

        $display("=== Weight BRAM Testbench (ADDR_WIDTH=%0d) ===", ADDR_WIDTH);

        // ── Test 1: Write 16 weights via AXI ───────────────────
        $display("--- Test 1: AXI Write 16 packed weights ---");
        tmp_addr = 0;
        axi_write(tmp_addr,
                  {expected_bytes[3], expected_bytes[2], expected_bytes[1], expected_bytes[0]},
                  4'hF);

        // ── Test 2: Read back via weight port ──────────────────
        $display("--- Test 2: Weight port readback ---");
        for (i = 0; i < 4; i = i + 1) begin
            tmp_addr = i;
            weight_read(tmp_addr, wb_read);
            if (wb_read !== expected_bytes[i]) begin
                $display("FAIL weight port addr=%0d: got %h expected %h",
                         i, wb_read, expected_bytes[i]);
                errors = errors + 1;
            end else begin
                $display("PASS weight port addr=%0d: %h", i, wb_read);
            end
        end

        // ── Test 3: AXI readback ───────────────────────────────
        $display("--- Test 3: AXI readback ---");
        tmp_addr = 0;
        axi_read(tmp_addr, rd_val);
        if (rd_val !== {expected_bytes[3], expected_bytes[2], expected_bytes[1], expected_bytes[0]}) begin
            $display("FAIL AXI readback: got %h expected %h_%h_%h_%h",
                     rd_val, expected_bytes[3], expected_bytes[2], expected_bytes[1], expected_bytes[0]);
            errors = errors + 1;
        end else begin
            $display("PASS AXI readback: %h", rd_val);
        end

        // ── Test 4: Write with byte strobes ────────────────────
        $display("--- Test 4: Write with byte strobes ---");
        // Write only bytes 0 and 2, leave bytes 1 and 3 unchanged
        // New values: byte0=0x55, byte2=0xAA
        // Expected result: {0x29, 0xAA, 0x92, 0x55}
        tmp_addr = 0;
        axi_write(tmp_addr, 32'h29AA9255, 4'b0101);

        expected_bytes[0] = 8'h55;
        expected_bytes[2] = 8'hAA;

        for (i = 0; i < 4; i = i + 1) begin
            tmp_addr = i;
            weight_read(tmp_addr, wb_read);
            if (wb_read !== expected_bytes[i]) begin
                $display("FAIL strb test addr=%0d: got %h expected %h",
                         i, wb_read, expected_bytes[i]);
                errors = errors + 1;
            end else begin
                $display("PASS strb test addr=%0d: %h", i, wb_read);
            end
        end

        // ── Test 5: Write at non-zero address ──────────────────
        $display("--- Test 5: Write at non-zero address ---");
        // addr=8, byte0=0xAA, byte1=0xBB, byte2=0xCC, byte3=0xDD
        expected_bytes[0] = 8'hAA;
        expected_bytes[1] = 8'hBB;
        expected_bytes[2] = 8'hCC;
        expected_bytes[3] = 8'hDD;

        tmp_addr = 8;
        axi_write(tmp_addr,
                  {expected_bytes[3], expected_bytes[2], expected_bytes[1], expected_bytes[0]},
                  4'hF);

        for (i = 0; i < 4; i = i + 1) begin
            tmp_addr = 8 + i;
            weight_read(tmp_addr, wb_read);
            if (wb_read !== expected_bytes[i]) begin
                $display("FAIL offset write addr=%0d: got %h expected %h",
                         8 + i, wb_read, expected_bytes[i]);
                errors = errors + 1;
            end else begin
                $display("PASS offset write addr=%0d: %h", 8 + i, wb_read);
            end
        end

        // ── Test 6: Original location not corrupted ────────────
        $display("--- Test 6: Original location not corrupted ---");
        expected_bytes[0] = 8'h55;
        expected_bytes[1] = 8'h92;
        expected_bytes[2] = 8'hAA;
        expected_bytes[3] = 8'h29;

        for (i = 0; i < 4; i = i + 1) begin
            tmp_addr = i;
            weight_read(tmp_addr, wb_read);
            if (wb_read !== expected_bytes[i]) begin
                $display("FAIL corruption check addr=%0d: got %h expected %h",
                         i, wb_read, expected_bytes[i]);
                errors = errors + 1;
            end else begin
                $display("PASS corruption check addr=%0d: %h", i, wb_read);
            end
        end

        // ── Test 7: Weight port combinational read ─────────────
        $display("--- Test 7: Combinational weight port read ---");
        tmp_addr = 0;
        weight_addr = tmp_addr;
        #1;
        if (weight_byte !== expected_bytes[0]) begin
            $display("FAIL comb read: got %h expected %h", weight_byte, expected_bytes[0]);
            errors = errors + 1;
        end else begin
            $display("PASS comb read: %h", weight_byte);
        end

        tmp_addr = 1;
        weight_addr = tmp_addr;
        #1;
        if (weight_byte !== expected_bytes[1]) begin
            $display("FAIL comb read: got %h expected %h", weight_byte, expected_bytes[1]);
            errors = errors + 1;
        end else begin
            $display("PASS comb read: %h", weight_byte);
        end

        // ── Results ────────────────────────────────────────────
        $display("=== %0d error(s) ===", errors);
        if (errors == 0) $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
