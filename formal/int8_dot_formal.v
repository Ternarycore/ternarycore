// Formal cover + bmc for int8_dot — exposes known bugs:
//   1. Sticky vdone (never self-clears)
//   2. Back-to-back: first element of next vector silently dropped
//   3. Extra vdone_dly latency flop
//
// Reference: sliding-window accumulator, same as ternary_dot_formal.

`timescale 1ns / 1ps

module int8_dot_formal(input wire clk);
    parameter DATA_WIDTH   = 8;
    parameter WEIGHT_WIDTH = 8;
    parameter ACC_WIDTH    = 32;
    parameter VECTOR_LEN   = 4;

    wire         rst_n;
    wire         valid_in;
    wire signed [DATA_WIDTH-1:0]   activation;
    wire signed [WEIGHT_WIDTH-1:0] weight;
    wire [ACC_WIDTH-1:0] acc_out;
    wire         valid_out;

    int8_dot #(.DATA_WIDTH(DATA_WIDTH), .WEIGHT_WIDTH(WEIGHT_WIDTH),
               .ACC_WIDTH(ACC_WIDTH), .VECTOR_LEN(VECTOR_LEN)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight(weight),
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

    // ── Two-burst stimulus ──────────────────────────────────────────
    // Burst 0: cycles 0..VECTOR_LEN-1 (starting from run_cnt >= 4)
    // Gap: 2 idle cycles
    // Burst 1: VECTOR_LEN cycles
    reg [3:0] cycle;
    always @(posedge clk) begin
        if (!rst_n) cycle <= 0;
        else if (run_cnt >= 4 && cycle < 4*VECTOR_LEN+4) cycle <= cycle + 1;
    end

    wire burst0_active = (cycle <= VECTOR_LEN);
    wire gap0_active   = (cycle > VECTOR_LEN && cycle <= VECTOR_LEN + 2);
    wire burst1_active = (cycle > VECTOR_LEN + 2 && cycle <= 2*VECTOR_LEN + 2);

    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            if (burst0_active)
                assume(valid_in);
            else if (gap0_active)
                assume(!valid_in);
            else if (burst1_active)
                assume(valid_in);
            else
                assume(!valid_in);
        end
    end

    // ── Reference: sliding-window accumulator ────────────────────────
    // Mirrors DUT: on each valid_in accumulate $signed(activation)*$signed(weight).
    // Sets ref_done for exactly 1 cycle when VECTOR_LEN elements seen.
    reg [3:0] feed_count;
    reg signed [ACC_WIDTH-1:0] dot_acc;
    reg                         ref_done;
    reg signed [ACC_WIDTH-1:0] ref_result;

    wire signed [DATA_WIDTH+WEIGHT_WIDTH-1:0] prod = $signed(activation) * $signed(weight);
    wire signed [ACC_WIDTH-1:0] prod_ext = {{(ACC_WIDTH-DATA_WIDTH-WEIGHT_WIDTH){prod[DATA_WIDTH+WEIGHT_WIDTH-1]}}, prod};

    always @(posedge clk) begin
        if (!rst_n) begin
            feed_count <= 0;
            dot_acc <= 0;
            ref_done <= 0;
            ref_result <= 0;
        end else begin
            ref_done <= 0;
            if (valid_in) begin
                if (feed_count == VECTOR_LEN-1) begin
                    ref_result <= dot_acc + prod_ext;
                    ref_done <= 1;
                    feed_count <= 0;
                    dot_acc <= 0;
                end else begin
                    feed_count <= feed_count + 1;
                    dot_acc <= dot_acc + prod_ext;
                end
            end
        end
    end

    // ── Assertion 1: valid_out tracks ref_done (proves sticky vdone) ─
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            assert(valid_out == ref_done);
        end
    end

    // ── Assertion 2: valid_out never stays high 2+ consecutive cycles ─
    reg vo_d1;
    always @(posedge clk) begin
        if (!rst_n) vo_d1 <= 0;
        else vo_d1 <= valid_out;
    end
    always @(posedge clk) begin
        if (run_cnt >= 4)
            assert(!(valid_out && vo_d1));
    end

    // ── Assertion 3: During burst 1, when feed_count==1 the next
    //    cycle should produce valid_out (proves back-to-back drop) ────
    reg [3:0] burst1_count;
    always @(posedge clk) begin
        if (!rst_n) burst1_count <= 0;
        else if (burst1_active && valid_in) burst1_count <= burst1_count + 1;
    end

    always @(posedge clk) begin
        if (run_cnt >= 4 && burst1_active && burst1_count == 1 && valid_in)
            assert(valid_out);
    end

    // ── Cover points ────────────────────────────────────────────────
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            cover(valid_out);
            cover(valid_out && acc_out != 0);
            cover(valid_out && $signed(acc_out) > 0);
            cover(valid_out && $signed(acc_out) < 0);
            cover(!valid_out && ref_done == 0);
        end
    end

endmodule
