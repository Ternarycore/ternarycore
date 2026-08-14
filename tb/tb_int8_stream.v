// tb_int8_stream.v -- attention's activation x activation matmul on the
// ternary array, end to end through the streaming feeder.
//
// Layout for int8 mode: element i occupies eight consecutive slots k=8i+b.
// act_ram[k] holds q[i] (each value written eight times, which is cheap);
// the weight port supplies, in its low 64 bits, bit b of k_j[i] for the 64
// columns. The feeder shifts and sign-selects; the array accumulates
// sum_i q[i]*k_j[i] with no multiplier anywhere.
`timescale 1ns / 1ps
`default_nettype none

module tb_int8_stream;
    localparam COLS = 64, N = 128;   // head_dim = 128 -> 1024 slots
    reg clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    reg  [7:0]  awaddr = 0, araddr = 0;
    reg         awvalid = 0, wvalid = 0, arvalid = 0, bready = 1, rready = 1;
    reg  [31:0] wdata = 0;
    wire        awready, wready, arready, rvalid, bvalid;
    wire [31:0] rdata;
    wire [13:0] w_word_addr;
    reg  [127:0] w_word;

    reg signed [7:0] q [0:N-1];
    reg signed [7:0] kmat [0:COLS-1][0:N-1];
    reg [127:0] wmem [0:1023];
    integer i, j, b, errors = 0;
    integer want;

    axi_gemm_stream dut (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awaddr(awaddr), .s_axi_awprot(3'b0), .s_axi_awvalid(awvalid),
        .s_axi_awready(awready), .s_axi_wdata(wdata), .s_axi_wstrb(4'hF),
        .s_axi_wvalid(wvalid), .s_axi_wready(wready), .s_axi_bresp(),
        .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arprot(3'b0), .s_axi_arvalid(arvalid),
        .s_axi_arready(arready), .s_axi_rdata(rdata), .s_axi_rresp(),
        .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .w_word_addr(w_word_addr), .w_word(w_word));

    always @(posedge clk) w_word <= wmem[w_word_addr[9:0]];

    task wr(input [7:0] a, input [31:0] d);
        begin
            @(negedge clk); awaddr = a; wdata = d; awvalid = 1; wvalid = 1;
            @(posedge clk); while (!(awready && wready)) @(posedge clk);
            @(negedge clk); awvalid = 0; wvalid = 0;
        end
    endtask

    task rd(input [7:0] a, output [31:0] d);
        begin
            @(negedge clk); araddr = a; arvalid = 1;
            @(posedge clk); while (!arready) @(posedge clk);
            @(negedge clk); arvalid = 0;
            @(posedge clk); while (!rvalid) @(posedge clk);
            d = rdata;
        end
    endtask

    reg [31:0] got;
    initial begin
        // deterministic operands spanning the int8 range, corners included
        for (i = 0; i < N; i = i + 1)
            q[i] = (i == 0) ? -128 : (i == 1) ? 127 : ((i * 37) % 256) - 128;
        for (j = 0; j < COLS; j = j + 1)
            for (i = 0; i < N; i = i + 1)
                kmat[j][i] = (j == 0 && i == 0) ? -128
                           : ((i * 13 + j * 91) % 256) - 128;
        // bit-slice K into the weight words: word 8i+b, bit j = bit b of k_j[i]
        for (i = 0; i < N; i = i + 1)
            for (b = 0; b < 8; b = b + 1) begin
                wmem[i*8 + b] = 128'd0;
                for (j = 0; j < COLS; j = j + 1)
                    wmem[i*8 + b][j] = kmat[j][i][b];
            end

        repeat (4) @(negedge clk); rst_n = 1;
        wr(8'h00, 32'h4);                       // ACT_PTR_RST
        for (i = 0; i < N; i = i + 1)           // each q value eight times
            for (b = 0; b < 8; b = b + 1)
                wr(8'h08, {24'd0, q[i]});
        wr(8'h00, 32'h9);                       // START | INT8
        got = 0;
        while (!got[1]) rd(8'h04, got);         // poll STATUS.done

        for (j = 0; j < COLS; j = j + 1) begin
            want = 0;
            for (i = 0; i < N; i = i + 1) want = want + q[i] * kmat[j][i];
            wr(8'h14, j);                        // RIDX
            rd(8'h18, got);                      // RDATA
            if ($signed(got) !== want) begin
                $display("FAIL col %0d: got %0d want %0d", j, $signed(got), want);
                errors = errors + 1;
            end
        end
        if (errors == 0)
            $display("TB PASS: %0d int8 dot products exact on the ternary array", COLS);
        else
            $display("TB FAIL: %0d of %0d columns wrong", errors, COLS);
        $finish;
    end
endmodule
`default_nettype wire
