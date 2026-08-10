// Formal cover + bmc for ternary_dot in isolation.
// Reference matches main's RTL after ternary_weight.v split:
//   - 9-bit signed select (exact over full int8 range)
//   - sticky vector_done (valid_out = vector_done)
//   - acc_out updates one cycle after vector_done rises

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

    // Match ternary_weight.v: DATA_WIDTH+1 bit signed select
    wire signed [DATA_WIDTH:0] a_ext =
        $signed({activation[DATA_WIDTH-1], activation});
    wire signed [DATA_WIDTH:0] weighted =
        (weight_enc == 2'b00) ? {(DATA_WIDTH+1){1'b0}} :
        (weight_enc == 2'b01) ?  a_ext
                              : -a_ext;
    wire signed [ACC_WIDTH-1:0] weighted_ext =
        {{(ACC_WIDTH-DATA_WIDTH-1){weighted[DATA_WIDTH]}}, weighted};

    always @(posedge clk) begin
        if (!rst_n) begin
            feed_count <= 0;
            dot_acc <= 0;
            ref_done <= 0;
            ref_done_d1 <= 0;
            ref_result <= 0;
        end else begin
            ref_done_d1 <= ref_done;
            // Sticky vector_done: rises on terminal feed, stays until first
            // non-terminal element of the next vector.
            if (valid_in && (!ref_done || ref_done_d1)) begin
                if (feed_count == VECTOR_LEN-1) begin
                    ref_result <= dot_acc + weighted_ext;
                    ref_done <= 1;
                    feed_count <= 0;
                    dot_acc <= 0;
                end else begin
                    ref_done <= 0;
                    feed_count <= feed_count + 1;
                    dot_acc <= dot_acc + weighted_ext;
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
            // acc_out is written on the posedge where vector_done is already 1,
            // so it matches ref_result starting the cycle after ref_done rises.
            if (ref_done && ref_done_d1)
                assert(acc_out == ref_result);
        end
    end

    // Safety: first non-terminal feed of a new vector clears vector_done
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
            // Sample result one cycle after done rises (acc_out latched)
            cover(ref_done && ref_done_d1 && acc_out != 0);
            cover(ref_done && ref_done_d1 && $signed(acc_out) > 0);
            cover(ref_done && ref_done_d1 && $signed(acc_out) < 0);
        end
    end

endmodule
