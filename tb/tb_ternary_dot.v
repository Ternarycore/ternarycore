// tb_ternary_dot.v
// Testbench for ternary_dot.
// Tests streaming dot products with VECTOR_LEN=8 (overriding the default 64).
// Vectors chosen to exercise all weight states and signed activations.
//
// Run with: cd sim && make tb_ternary_dot

`timescale 1ns / 1ps

module tb_ternary_dot;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter VLEN       = 8;    // short vector for testbench clarity

    reg                  clk;
    reg                  rst_n;
    reg                  valid_in;
    reg  [DATA_WIDTH-1:0] activation;
    reg  [1:0]            weight_enc;
    wire [ACC_WIDTH-1:0]  acc_out;
    wire                  valid_out;

    ternary_dot #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .VECTOR_LEN(VLEN)
    ) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_ternary_dot.vcd");
        $dumpvars(0, tb_ternary_dot);
    end

    integer errors = 0;
    integer i;

    // Feed one vector, wait for valid_out, check result
    task feed_vector;
        input signed [ACC_WIDTH-1:0] expected;
        input [DATA_WIDTH*VLEN-1:0]  acts_packed;
        input [2*VLEN-1:0]           wencs_packed;
        reg [DATA_WIDTH-1:0] act;
        reg [1:0] wenc;
        integer j;
        begin
            for (j = 0; j < VLEN; j = j + 1) begin
                act  = acts_packed[DATA_WIDTH*(VLEN-1-j) +: DATA_WIDTH];
                wenc = wencs_packed[2*(VLEN-1-j) +: 2];
                activation = act;
                weight_enc = wenc;
                valid_in   = 1;
                #10;  // Allow continuous assignments to propagate before posedge
                @(posedge clk);
            end
            // valid_out holds high when valid_in=0 (no new vector started).
            // Sample at the NEXT posedge+#1 — identical timing to ternary_mac,
            // guaranteed past all NBA updates.
            valid_in = 0;
            @(posedge clk); #1;
            if (!valid_out) begin
                $display("FAIL: valid_out did not assert after vector");
                errors = errors + 1;
            end else if ($signed(acc_out) !== expected) begin
                $display("FAIL: got %0d, expected %0d", $signed(acc_out), expected);
                errors = errors + 1;
            end else begin
                $display("PASS: dot product = %0d", $signed(acc_out));
            end
            // valid_out deasserts automatically on the first element of the next vector
        end
    endtask

    initial begin
        rst_n = 0; valid_in = 0; activation = 0; weight_enc = 0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        $display("--- TernaryCore Dot Product Testbench (VLEN=%0d) ---", VLEN);

        // Test 1: all +1 weights, acts=[1..8] → 1+2+3+4+5+6+7+8 = 36
        feed_vector(32'd36,
            {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8},
            {2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01});

        // Test 2: all -1 weights, same acts → -(1+2+..+8) = -36
        feed_vector(-32'd36,
            {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8},
            {2'b10,2'b10,2'b10,2'b10,2'b10,2'b10,2'b10,2'b10});

        // Test 3: all zero weights → 0 regardless of activations
        feed_vector(32'd0,
            {8'd99,8'd42,8'd13,8'd7, 8'd200,8'd1, 8'd88,8'd55},
            {2'b00,2'b00,2'b00,2'b00,2'b00, 2'b00,2'b00,2'b00});

        // Test 4: mixed — first 4 +1, last 4 -1, same act=5 each → (4*5)-(4*5) = 0
        feed_vector(32'd0,
            {8'd5, 8'd5, 8'd5, 8'd5, 8'd5, 8'd5, 8'd5, 8'd5},
            {2'b01,2'b01,2'b01,2'b01,2'b10,2'b10,2'b10,2'b10});

        // Test 5: signed activations — act=-5 (8'hFB), w=+1, x8 → -40
        feed_vector(-32'd40,
            {8'hFB,8'hFB,8'hFB,8'hFB,8'hFB,8'hFB,8'hFB,8'hFB},
            {2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01});

        // Test 6: signed activations — act=-5, w=-1, x8 → +40
        feed_vector(32'd40,
            {8'hFB,8'hFB,8'hFB,8'hFB,8'hFB,8'hFB,8'hFB,8'hFB},
            {2'b10,2'b10,2'b10,2'b10,2'b10,2'b10,2'b10,2'b10});

        // Test 7: back-to-back, accumulation over large values
        // acts=[127,127,127,127,127,127,127,127], w=+1 → 1016
        feed_vector(32'd1016,
            {8'd127,8'd127,8'd127,8'd127,8'd127,8'd127,8'd127,8'd127},
            {2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01});

        $display("--- %0d error(s) ---", errors);
        if (errors == 0) $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
