// tb_ternary_gemm.v
// Testbench for ternary_gemm — 4×4 matrix multiply.
//
// A (activations, int8):
//   [[  1,  2,  3,  4 ],
//    [  5,  6,  7,  8 ],
//    [ -1, -2, -3, -4 ],
//    [ 10,  0,  5, -3 ]]
//
// W (ternary weights, {+1,-1,0}):
//   [[ +1, -1, +1,  0 ],
//    [  0, +1, -1, +1 ],
//    [ -1,  0, +1, -1 ],
//    [ +1, -1,  0, +1 ]]
//
// Expected C = A * W (verified against Python/NumPy in verify_gemm.py):
//   [[  2, -3,  2,  3 ],
//    [  6, -7,  6,  7 ],
//    [ -2,  3, -2, -3 ],
//    [  2, -7, 15, -8 ]]
//
// Weight encoding per clock cycle k (row k of W, packed across COLS):
//   weight_enc[2*col+1:2*col] = encoding for column col
//   Encoding: 00=0, 01=+1, 10=-1
//
// Run with: cd sim && make tb_ternary_gemm

`timescale 1ns / 1ps

module tb_ternary_gemm;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter ROWS       = 4;
    parameter COLS       = 4;
    parameter DEPTH      = 4;

    reg                       clk;
    reg                       rst_n;
    reg                       valid_in;
    reg  [DATA_WIDTH-1:0]     activation;
    reg  [2*COLS-1:0]         weight_enc;

    wire [ACC_WIDTH*COLS-1:0] acc_out;
    wire                      valid_out;

    ternary_gemm #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ROWS(ROWS), .COLS(COLS), .DEPTH(DEPTH)
    ) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_ternary_gemm.vcd");
        $dumpvars(0, tb_ternary_gemm);
    end

    integer errors = 0;
    integer row, col, k;

    // Weight matrix rows packed as {w_col3, w_col2, w_col1, w_col0}
    // W = [[+1,-1,+1,0],[0,+1,-1,+1],[-1,0,+1,-1],[+1,-1,0,+1]]
    // k=0: col0=01,col1=10,col2=01,col3=00 → 8'b00_01_10_01 = 8'h19
    // k=1: col0=00,col1=01,col2=10,col3=01 → 8'b01_10_01_00 = 8'h64
    // k=2: col0=10,col1=00,col2=01,col3=10 → 8'b10_01_00_10 = 8'h92
    // k=3: col0=01,col1=10,col2=00,col3=01 → 8'b01_00_10_01 = 8'h49
    reg [2*COLS-1:0] W_row [0:DEPTH-1];

    // Activation matrix rows (signed 8-bit)
    reg [DATA_WIDTH-1:0] A_row [0:ROWS-1][0:DEPTH-1];

    // Expected output matrix (signed 32-bit)
    reg signed [ACC_WIDTH-1:0] C_exp [0:ROWS-1][0:COLS-1];

    task check_row;
        input integer r;
        integer c;
        reg signed [ACC_WIDTH-1:0] got;
        begin
            for (c = 0; c < COLS; c = c + 1) begin
                got = $signed(acc_out[ACC_WIDTH*(c+1)-1 -: ACC_WIDTH]);
                if (got !== C_exp[r][c]) begin
                    $display("FAIL row=%0d col=%0d: got=%0d expected=%0d",
                             r, c, got, C_exp[r][c]);
                    errors = errors + 1;
                end
            end
        end
    endtask

    initial begin
        // Weight rows
        W_row[0] = 8'h19;   // k=0: +1,-1,+1, 0
        W_row[1] = 8'h64;   // k=1:  0,+1,-1,+1
        W_row[2] = 8'h92;   // k=2: -1, 0,+1,-1
        W_row[3] = 8'h49;   // k=3: +1,-1, 0,+1

        // Activation matrix A (8-bit, signed)
        A_row[0][0]=8'd1;  A_row[0][1]=8'd2;  A_row[0][2]=8'd3;  A_row[0][3]=8'd4;
        A_row[1][0]=8'd5;  A_row[1][1]=8'd6;  A_row[1][2]=8'd7;  A_row[1][3]=8'd8;
        A_row[2][0]=8'hFF; A_row[2][1]=8'hFE; A_row[2][2]=8'hFD; A_row[2][3]=8'hFC; // -1,-2,-3,-4
        A_row[3][0]=8'd10; A_row[3][1]=8'd0;  A_row[3][2]=8'd5;  A_row[3][3]=8'hFD; // 10,0,5,-3

        // Expected output C = A * W
        C_exp[0][0]= 2; C_exp[0][1]=-3; C_exp[0][2]= 2; C_exp[0][3]= 3;
        C_exp[1][0]= 6; C_exp[1][1]=-7; C_exp[1][2]= 6; C_exp[1][3]= 7;
        C_exp[2][0]=-2; C_exp[2][1]= 3; C_exp[2][2]=-2; C_exp[2][3]=-3;
        C_exp[3][0]= 2; C_exp[3][1]=-7; C_exp[3][2]=15; C_exp[3][3]=-8;

        // Reset
        rst_n = 0; valid_in = 0; activation = 0; weight_enc = 0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        @(posedge clk); // Extra cycle after reset

        $display("--- TernaryCore GEMM Testbench (4x4) ---");

        // Feed all ROWS groups of DEPTH activation elements
        for (row = 0; row < ROWS; row = row + 1) begin
            for (k = 0; k < DEPTH; k = k + 1) begin
                // Set signals with small delay before clock edge
                #1;
                activation = A_row[row][k];
                weight_enc = W_row[k];
                valid_in   = 1;
                $display("TB: Setting row %0d k=%0d: activation=%0d weight_enc=%02x (binary %08b) at time %0t", 
                         row, k, A_row[row][k], W_row[k], W_row[k], $time);
                @(posedge clk);
                #1;
            end
             // valid_out pulses one cycle after last element. 
              // Set valid_in=0 before clock edge, then check valid_out
              #1;
              valid_in = 0;
              @(posedge clk);
              #1;
              if (!valid_out) begin
                  $display("ERROR: valid_out did not assert for row %0d", row);
                  errors = errors + 1;
              end else begin
                  check_row(row);
                  $display("PASS row %0d: [%0d, %0d, %0d, %0d]",
                      row,
                      $signed(acc_out[ACC_WIDTH*1-1 -: ACC_WIDTH]),
                      $signed(acc_out[ACC_WIDTH*2-1 -: ACC_WIDTH]),
                      $signed(acc_out[ACC_WIDTH*3-1 -: ACC_WIDTH]),
                      $signed(acc_out[ACC_WIDTH*4-1 -: ACC_WIDTH]));
              end
              #1;
              @(posedge clk);
              #1;
        end

        $display("--- %0d error(s) ---", errors);
        if (errors == 0) $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
