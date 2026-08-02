// Formal cover + bmc for ternary_gemm — COLS parallel ternary_dot units.
// Reference: per-column sliding-window accumulator, one reference per column.

`timescale 1ns / 1ps

module ternary_gemm_formal(
    input wire clk
);
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter COLS       = 2;
    parameter DEPTH      = 4;

    wire         rst_n;
    wire         valid_in;
    wire [DATA_WIDTH-1:0] activation;
    wire [2*COLS-1:0]     weight_enc;
    wire [ACC_WIDTH*COLS-1:0] acc_out;
    wire                    valid_out;

    ternary_gemm #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH),
                   .COLS(COLS), .DEPTH(DEPTH)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out)
    );

    reg [1:0] reset_cnt;
    initial reset_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!rst_n);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(rst_n);
        end
    end

    reg [3:0] run_cnt;
    initial run_cnt = 0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 0;
        else if (run_cnt < 15) run_cnt <= run_cnt + 1;
    end

    // Force DEPTH (= VECTOR_LEN) valid_in=1 cycles to complete the vector
    reg [3:0] feed_counter;
    always @(posedge clk) begin
        if (!rst_n) feed_counter <= 0;
        else if (run_cnt >= 4 && feed_counter < DEPTH) begin
            if (valid_in) feed_counter <= feed_counter + 1;
            assume(valid_in);
        end else if (run_cnt >= 4 && feed_counter >= DEPTH) begin
            assume(!valid_in);
        end else begin
            assume(!valid_in);
        end
    end

    // Per-column reference: sliding-window accumulator
    reg [3:0]          feed_count;
    reg signed [ACC_WIDTH-1:0] dot_acc [0:COLS-1];
    reg                        ref_done;
    reg signed [ACC_WIDTH-1:0] ref_result [0:COLS-1];

    wire signed [DATA_WIDTH:0] weighted [0:COLS-1];
    genvar ci;
    generate
        for (ci = 0; ci < COLS; ci = ci + 1) begin : ref_col
            assign weighted[ci] =
                (weight_enc[2*ci +: 2] == 2'b00) ? 0 :
                (weight_enc[2*ci +: 2] == 2'b01) ? $signed(activation) :
                (weight_enc[2*ci +: 2] == 2'b10) ? -$signed(activation) : -$signed(activation);
        end
    endgenerate

    integer c;
    always @(posedge clk) begin
        if (!rst_n) begin
            feed_count <= 0;
            ref_done <= 0;
            for (c = 0; c < COLS; c = c + 1) begin
                dot_acc[c] <= 0;
                ref_result[c] <= 0;
            end
        end else begin
            ref_done <= 0;
            if (valid_in) begin
                if (feed_count == DEPTH-1) begin
                    for (c = 0; c < COLS; c = c + 1) begin
                        ref_result[c] <= dot_acc[c] + weighted[c];
                        dot_acc[c] <= 0;
                    end
                    ref_done <= 1;
                    feed_count <= 0;
                end else begin
                    feed_count <= feed_count + 1;
                    for (c = 0; c < COLS; c = c + 1) begin
                        dot_acc[c] <= dot_acc[c] + weighted[c];
                    end
                end
            end
        end
    end

    // ── Assertions ────────────────────────────────────
    // All columns finish simultaneously → valid_out == ref_done
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            assert(valid_out == ref_done);
        end
    end

    // When valid_out fires, each column's acc_out matches reference
    generate
        for (ci = 0; ci < COLS; ci = ci + 1) begin : chk_col
            always @(posedge clk) begin
                if (run_cnt >= 4 && ref_done)
                    assert(acc_out[ACC_WIDTH*ci +: ACC_WIDTH] == ref_result[ci]);
            end
        end
    endgenerate

    // Safety: valid_out never stays high 2+ consecutive cycles
    reg vo_d1;
    always @(posedge clk) begin
        if (!rst_n) vo_d1 <= 0;
        else vo_d1 <= valid_out;
    end
    always @(posedge clk) begin
        if (run_cnt >= 4)
            assert(!(valid_out && vo_d1));
    end

    // Cover: valid_out fires, non-zero results per column
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            cover(valid_out);
            cover(valid_out && acc_out[ACC_WIDTH*0 +: ACC_WIDTH] != 0);
            cover(valid_out && $signed(acc_out[ACC_WIDTH*0 +: ACC_WIDTH]) > 0);
            cover(valid_out && $signed(acc_out[ACC_WIDTH*0 +: ACC_WIDTH]) < 0);
        end
    end

endmodule
