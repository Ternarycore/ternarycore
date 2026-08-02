// Liveness formal: feed VECTOR_LEN consecutive elements, check valid_out fires
// within VECTOR_LEN+2 cycles. No reference model needed — the solver proves
// the RTL's counter FSM always terminates for a full vector.
//
// Strategy:
//   After reset, the solver must drive valid_in=1 for exactly VECTOR_LEN
//   consecutive cycles (states 2..2+VECTOR_LEN-1). activation and weight_enc
//   are completely unconstrained. The assertion checks that valid_out fires
//   by state 2+VECTOR_LEN+1 at the latest.
//
//   A second safety assertion checks that valid_out does NOT fire before the
//   terminal feed (early-out would be a bug).

`timescale 1ns / 1ps

module ternary_dot_liveness_formal(
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

    ternary_dot #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(VECTOR_LEN)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out)
    );

    // ── Reset sequence ──────────────────────────────────────────
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

    // ── Liveness state machine ─────────────────────────────────
    //   state  0-1: reset
    //   state  2..2+VECTOR_LEN-1: feeding (valid_in=1)
    //   state  2+VECTOR_LEN..2+VECTOR_LEN+1: wait for valid_out
    //   state >2+VECTOR_LEN+1: done (solver may relax)
    reg [4:0] state;
    initial state = 0;
    always @(posedge clk) begin
        if (!rst_n) state <= 0;
        else if (state < 20) state <= state + 1;
    end

    wire feeding = (state >= 2 && state < 2 + VECTOR_LEN);
    always @(posedge clk) begin
        assume(valid_in == feeding);
    end

    // ── Liveness assertion: valid_out fires within VECTOR_LEN+2 ──
    // valid_out appears the cycle AFTER the terminal feed. The terminal
    // feed happens at state 2+VECTOR_LEN-1, so valid_out is read at
    // state 2+VECTOR_LEN.
    reg vo_d1;
    always @(posedge clk) begin
        if (!rst_n) vo_d1 <= 0;
        else vo_d1 <= valid_out;
    end

    always @(posedge clk) begin
        if (state == 2 + VECTOR_LEN) begin
            assert(valid_out || vo_d1);
        end
    end

    // ── Safety: valid_out must NOT fire before the terminal feed ──
    always @(posedge clk) begin
        if (state >= 2 && state < 2 + VECTOR_LEN - 1)
            assert(!valid_out);
    end

    // Cover: liveness satisfied
    always @(posedge clk) begin
        if (state >= 2)
            cover(valid_out);
    end

endmodule
