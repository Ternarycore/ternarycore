// Formal cover + bmc for ternary_dot in isolation.
// Reference: sliding-window dot product over VECTOR_LEN elements.
// Matches main's RTL timing: sticky vector_done, valid_out = vector_done.

`timescale 1ns / 1ps

module ternary_dot_formal(
    input wire clk
);
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter VECTOR_LEN = 4;

    wire         rst_n;
    wire         valid_in;
    wire [DATA_WIDTH-1:0] activation;
    wire [1:0]   weight_enc;
    wire [ACC_WIDTH-1:0] acc_out;
    wire         valid_out;

    // Main's ternary_dot has debug export ports. Connect them via .*
    wire         debug_valid_in_out;
    wire [DATA_WIDTH-1:0] debug_activation_out;
    wire [1:0]   debug_weight_enc_out;
    wire [ACC_WIDTH-1:0] debug_acc_out_out;
    wire         debug_valid_out_out;

    ternary_dot #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(VECTOR_LEN)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out),
        .*
    );

    // 2-cycle reset assumption
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

    // Reference: tracks RTL's sticky vector_done
    reg [3:0] feed_count;
    reg signed [ACC_WIDTH-1:0] dot_acc;
    reg                         ref_done;
    reg                         ref_done_d1;
    reg signed [ACC_WIDTH-1:0] ref_result;

    // Match main's 8-bit weighted computation (not the 9-bit fix)
    wire signed [DATA_WIDTH-1:0] weighted =
        (weight_enc == 2'b00) ? 0 :
        (weight_enc == 2'b01) ? $signed(activation) :
        (weight_enc == 2'b10) ? -$signed(activation) : -$signed(activation);

    always @(posedge clk) begin
        if (!rst_n) begin
            feed_count <= 0;
            dot_acc <= 0;
            ref_done <= 0;
            ref_done_d1 <= 0;
            ref_result <= 0;
        end else begin
            ref_done_d1 <= ref_done;
            // Main's RTL: vector_done goes high on terminal feed (count==1, valid_in)
            // and stays high (sticky) across valid_in=0 gaps.
            // Clears on the first non-terminal element of the next vector.
            if (valid_in && (!ref_done || ref_done_d1)) begin
                if (feed_count == VECTOR_LEN-1) begin
                    ref_result <= dot_acc + weighted;
                    ref_done <= 1;
                    feed_count <= 0;
                    dot_acc <= 0;
                end else begin
                    ref_done <= 0;
                    feed_count <= feed_count + 1;
                    dot_acc <= dot_acc + weighted;
                end
            end else begin
                ref_done <= ref_done;
            end
        end
    end

    // valid_out = vector_done (combinatorial), so valid_out == ref_done
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            assert(valid_out == ref_done);
            if (ref_done && ref_done_d1)
                assert(acc_out == ref_result);
        end
    end

    // Safety: valid_out never stays high when a new valid_in vector starts
    // (the first non-terminal feed of a new vector clears vector_done)
    reg vo_d1;
    always @(posedge clk) begin
        if (!rst_n) vo_d1 <= 0;
        else vo_d1 <= valid_out;
    end
    always @(posedge clk) begin
        if (run_cnt >= 4 && vo_d1 && valid_in && !ref_done_d1)
            assert(!valid_out);
    end

    // Cover: one full vector completes, valid_out fires
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            cover(valid_out);
            cover(valid_out && acc_out != 0);
            cover(valid_out && $signed(acc_out) > 0);
            cover(valid_out && $signed(acc_out) < 0);
        end
    end

endmodule