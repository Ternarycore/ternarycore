// tb_ternary_gemm.v
// Testbench for ternary_gemm — parameterized matrix multiply.
//
// Supports DEPTH sweep via `define DEPTH_VAL: 4, 16, 64.
// Uses deterministic pattern-based test data generated in Verilog.
//
// Run with: cd sim && make tb_ternary_gemm

`timescale 1ns / 1ps

`ifndef DEPTH_VAL
`define DEPTH_VAL 4
`endif

module tb_ternary_gemm;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter ROWS       = 4;
    parameter COLS       = 4;
    parameter DEPTH      = `DEPTH_VAL;

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
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in), .end_of_vector(1'b0),
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

    reg [2*COLS-1:0]         weight_rows [0:DEPTH-1];
    reg signed [DATA_WIDTH-1:0] act_mat [0:ROWS-1][0:DEPTH-1];
    reg signed [ACC_WIDTH-1:0]  expected  [0:ROWS-1][0:COLS-1];

    task automatic check_row;
        input integer r;
        integer c;
        reg signed [ACC_WIDTH-1:0] got;
        begin
            for (c = 0; c < COLS; c = c + 1) begin
                got = $signed(acc_out[ACC_WIDTH*c +: ACC_WIDTH]);
                if (got !== expected[r][c]) begin
                    $display("FAIL row=%0d col=%0d: got=%0d expected=%0d",
                             r, c, got, expected[r][c]);
                    errors = errors + 1;
                end
            end
        end
    endtask

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
                        if (w_enc == 2'b01)
                            w_val = 1;
                        else if (w_enc == 2'b10)
                            w_val = -1;
                        else
                            w_val = 0;
                        a_val = $signed(act_mat[r][k]);
                        expected[r][c] = expected[r][c] + a_val * w_val;
                    end
                end
            end
        end
    endtask

    initial begin
        gen_test_data();

        rst_n = 0; valid_in = 0; activation = 0; weight_enc = 0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        @(posedge clk);

        $display("--- TernaryCore GEMM Testbench (COLS=%0d DEPTH=%0d) ---", COLS, DEPTH);

        for (row = 0; row < ROWS; row = row + 1) begin
            for (k = 0; k < DEPTH; k = k + 1) begin
                #1;
                activation = act_mat[row][k];
                weight_enc = weight_rows[k];
                valid_in   = 1;
                @(posedge clk);
                #1;
            end
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
                    $signed(acc_out[0 +: ACC_WIDTH]),
                    $signed(acc_out[ACC_WIDTH +: ACC_WIDTH]),
                    $signed(acc_out[ACC_WIDTH*2 +: ACC_WIDTH]),
                    $signed(acc_out[ACC_WIDTH*3 +: ACC_WIDTH]));
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
