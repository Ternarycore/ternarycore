// Minimal formal cover for ternary_gemm_stream.
// Directly drives start, act_data, w_data with a simple cycle counter.

`timescale 1ns / 1ps

module ternary_gemm_stream_cover(
    input wire clk
);
    parameter DEPTH = 4;
    parameter COLS = 2;

    wire         rst_n;
    wire         start;
    wire [7:0]   act_data;
    wire [3:0]   w_data;
    wire         busy;
    wire         done;
    wire [63:0]  result;

    ternary_gemm_stream #(.DEPTH(DEPTH), .COLS(COLS), .ADDR_WIDTH(3)) dut (
        .clk(clk), .rst_n(rst_n),
        .start(start), .busy(busy), .done(done),
        .act_addr(), .act_data(act_data),
        .w_addr(), .w_data(w_data),
        .result(result)
    );

    reg [1:0] reset_cnt;
    initial reset_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin assume(!rst_n); reset_cnt <= reset_cnt + 1; end
        else assume(rst_n);
    end

    reg [4:0] state;
    always @(posedge clk) begin
        if (!rst_n) state <= 0;
        else if (state < 30) state <= state + 1;
    end

    // State 2: pulse start for 1 cycle
    assign start = (state == 2);

    // Free BRAM data — solver can choose any values
    // act_data and w_data are undriven wires → free in formal

    reg [3:0] run_cnt;
    initial run_cnt = 0;
    always @(posedge clk) begin
        if (!rst_n) run_cnt <= 0;
        else if (run_cnt < 15) run_cnt <= run_cnt + 1;
    end

    // Cover: done fires within the replay window
    always @(posedge clk) begin
        if (run_cnt >= 4) begin
            cover(done);
            cover(done && !busy);
            cover(done && result != 0);
        end
    end

endmodule