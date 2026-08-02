// tb_axi_gemm_stream.v -- integration TB: axi_gemm_stream + weight_bram128.
// Loads a small ternary matrix over AXI, streams two column tiles, checks
// results and cycle count against a golden model. House rule: this must
// pass in iverilog before Vivado sees the RTL.
`timescale 1ns / 1ps
module tb_axi_gemm_stream;
    localparam DEPTH = 96;          // runtime depth for the test
    localparam COLS  = 64;

    reg clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    // AXI to gemm_stream
    reg  [7:0]  g_awaddr; reg g_awvalid; wire g_awready;
    reg  [31:0] g_wdata;  reg g_wvalid;  wire g_wready;
    wire [1:0]  g_bresp;  wire g_bvalid; reg  g_bready = 1;
    reg  [7:0]  g_araddr; reg g_arvalid; wire g_arready;
    wire [31:0] g_rdata;  wire g_rvalid; reg  g_rready = 1;
    // AXI to weight bram
    reg  [17:0] w_awaddr; reg w_awvalid; wire w_awready;
    reg  [31:0] w_wdata;  reg w_wvalid;  wire w_wready;
    wire [1:0]  w_bresp;  wire w_bvalid; reg  w_bready = 1;

    wire [13:0]  ww_addr;
    wire [127:0] ww_data;

    weight_bram128 u_bram (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awaddr(w_awaddr), .s_axi_awprot(3'b0), .s_axi_awvalid(w_awvalid),
        .s_axi_awready(w_awready), .s_axi_wdata(w_wdata), .s_axi_wstrb(4'hF),
        .s_axi_wvalid(w_wvalid), .s_axi_wready(w_wready), .s_axi_bresp(w_bresp),
        .s_axi_bvalid(w_bvalid), .s_axi_bready(w_bready),
        .s_axi_araddr(18'b0), .s_axi_arprot(3'b0), .s_axi_arvalid(1'b0),
        .s_axi_arready(), .s_axi_rdata(), .s_axi_rresp(), .s_axi_rvalid(),
        .s_axi_rready(1'b1),
        .w_word_addr(ww_addr), .w_word(ww_data));

    axi_gemm_stream u_dut (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awaddr(g_awaddr), .s_axi_awprot(3'b0), .s_axi_awvalid(g_awvalid),
        .s_axi_awready(g_awready), .s_axi_wdata(g_wdata), .s_axi_wstrb(4'hF),
        .s_axi_wvalid(g_wvalid), .s_axi_wready(g_wready), .s_axi_bresp(g_bresp),
        .s_axi_bvalid(g_bvalid), .s_axi_bready(g_bready),
        .s_axi_araddr(g_araddr), .s_axi_arprot(3'b0), .s_axi_arvalid(g_arvalid),
        .s_axi_arready(g_arready), .s_axi_rdata(g_rdata), .s_axi_rresp(),
        .s_axi_rvalid(g_rvalid), .s_axi_rready(g_rready),
        .w_word_addr(ww_addr), .w_word(ww_data));

    // -- AXI tasks -----------------------------------------------------------
    task gwr(input [7:0] a, input [31:0] d); begin
        @(negedge clk); g_awaddr=a; g_wdata=d; g_awvalid=1; g_wvalid=1;
        @(posedge clk); while(!(g_awready&&g_wready)) @(posedge clk);
        @(negedge clk); g_awvalid=0; g_wvalid=0;
        @(posedge clk); while(!g_bvalid) @(posedge clk);
    end endtask
    task grd(input [7:0] a, output [31:0] d); begin
        @(negedge clk); g_araddr=a; g_arvalid=1;
        @(posedge clk); while(!g_arready) @(posedge clk);
        @(negedge clk); g_arvalid=0;
        @(posedge clk); while(!g_rvalid) @(posedge clk); d=g_rdata;
    end endtask
    task wwr(input [17:0] a, input [31:0] d); begin
        @(negedge clk); w_awaddr=a; w_wdata=d; w_awvalid=1; w_wvalid=1;
        @(posedge clk); while(!(w_awready&&w_wready)) @(posedge clk);
        @(negedge clk); w_awvalid=0; w_wvalid=0;
        @(posedge clk); while(!w_bvalid) @(posedge clk);
    end endtask

    // -- golden model --------------------------------------------------------
    integer k, c, t, errors;
    reg signed [7:0]  acts  [0:DEPTH-1];
    integer           tern  [0:DEPTH-1][0:127];   // 2 tiles x 64 cols
    integer           golden[0:127];
    reg [1:0]  code;
    reg [31:0] word;
    reg [31:0] rd, cyc;
    integer tile_cols, gaddr, lane;

    initial begin
        errors = 0;
        g_awvalid=0; g_wvalid=0; g_arvalid=0;
        w_awvalid=0; w_wvalid=0;

        // build data
        for (k = 0; k < DEPTH; k = k + 1) begin
            acts[k] = (k * 7) % 11 - 5;
            for (c = 0; c < 128; c = c + 1)
                tern[k][c] = ((k + 3*c) % 3) - 1;
        end
        for (c = 0; c < 128; c = c + 1) begin
            golden[c] = 0;
            for (k = 0; k < DEPTH; k = k + 1)
                golden[c] = golden[c] + acts[k] * tern[k][c];
        end

        repeat (4) @(posedge clk); rst_n = 1; repeat (2) @(posedge clk);

        // load weights over AXI: layout word = k*16 + ct, byte g in word =
        // cols [ct*64 + g*4 .. +3]; two tiles => bytes 0..31 of each row.
        for (k = 0; k < DEPTH; k = k + 1)
            for (t = 0; t < 2; t = t + 1)
                for (lane = 0; lane < 4; lane = lane + 1) begin
                    word = 32'b0;
                    for (c = 0; c < 16; c = c + 1) begin
                        code = (tern[k][t*64 + lane*16 + c] == 0) ? 2'b00 :
                               (tern[k][t*64 + lane*16 + c] == 1) ? 2'b01 : 2'b10;
                        word[c*2 +: 2] = code;
                    end
                    // byte address: word_index*16 + lane*4
                    wwr((k*16 + t)*16 + lane*4, word);
                end

        // load activations
        gwr(8'h00, 32'h4);                    // ACT_PTR_RST
        for (k = 0; k < DEPTH; k = k + 1)
            gwr(8'h08, {24'b0, acts[k][7:0]});

        gwr(8'h10, DEPTH);                    // DEPTH

        for (t = 0; t < 2; t = t + 1) begin
            gwr(8'h0C, t);                    // CT
            gwr(8'h00, 32'h1);                // START
            rd = 0;
            while (!(rd & 32'h2)) grd(8'h04, rd);   // wait done
            grd(8'h20, cyc);
            for (c = 0; c < COLS; c = c + 1) begin
                gwr(8'h14, c);
                grd(8'h18, rd);
                if ($signed(rd) !== golden[t*64 + c]) begin
                    errors = errors + 1;
                    if (errors < 8)
                        $display("FAIL t=%0d c=%0d got %0d exp %0d",
                                 t, c, $signed(rd), golden[t*64 + c]);
                end
            end
            $display("tile %0d: %0d cycles for %0d elements", t, cyc, DEPTH);
            gwr(8'h00, 32'h2);                // CLEAR
        end

        if (errors == 0)
            $display("TB PASS: 128 columns exact across 2 tiles");
        else
            $display("TB FAIL: %0d errors", errors);
        $finish;
    end

    initial begin #4000000; $display("TIMEOUT"); $finish; end
endmodule
