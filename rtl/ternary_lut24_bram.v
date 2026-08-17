// SPDX-License-Identifier: CERN-OHL-S-2.0
// Compact ternary LUT for a 2:4 activation-masked dot product.
//
// A four-lane ternary LUT normally needs 3^4 = 81 entries.  Once the
// activation mask is fixed to two lanes, only 3^2 = 9 weight states can
// produce distinct results.  This block builds those nine entries and maps
// four-lane packed weights onto the compact two-digit address.

`timescale 1ns / 1ps

module ternary_lut24_bram #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input wire clk,
    input wire rst_n,
    input wire load_valid,
    input wire [3:0] keep_mask,
    input wire signed [DATA_WIDTH-1:0] x0,
    input wire signed [DATA_WIDTH-1:0] x1,
    input wire signed [DATA_WIDTH-1:0] x2,
    input wire signed [DATA_WIDTH-1:0] x3,
    input wire query_valid,
    input wire [7:0] packed_weights,
    output wire busy,
    output wire ready,
    output reg result_valid,
    output reg error_out,
    output reg signed [ACC_WIDTH-1:0] result
);
    reg signed [ACC_WIDTH-1:0] table_mem [0:8];
    reg [3:0] mask_q;
    reg signed [DATA_WIDTH-1:0] x0_q, x1_q, x2_q, x3_q;
    reg [3:0] build_index;
    reg building;
    integer i;

    assign busy = building;
    assign ready = !building && (mask_q != 4'b0);

    function signed [ACC_WIDTH-1:0] lane_value(input integer lane);
        begin
            case (lane)
                0: lane_value = {{(ACC_WIDTH-DATA_WIDTH){x0_q[DATA_WIDTH-1]}}, x0_q};
                1: lane_value = {{(ACC_WIDTH-DATA_WIDTH){x1_q[DATA_WIDTH-1]}}, x1_q};
                2: lane_value = {{(ACC_WIDTH-DATA_WIDTH){x2_q[DATA_WIDTH-1]}}, x2_q};
                default: lane_value = {{(ACC_WIDTH-DATA_WIDTH){x3_q[DATA_WIDTH-1]}}, x3_q};
            endcase
        end
    endfunction

    function signed [ACC_WIDTH-1:0] build_value(input [3:0] code);
        integer n, digit, lane, selected;
        reg signed [ACC_WIDTH-1:0] total;
        begin
            n = {28'b0, code};
            total = 0;
            selected = 0;
            for (lane = 0; lane < 4; lane = lane + 1) begin
                if (mask_q[lane]) begin
                    digit = n % 3;
                    n = n / 3;
                    if (digit == 1) total = total + lane_value(lane);
                    else if (digit == 2) total = total - lane_value(lane);
                    selected = selected + 1;
                end
            end
            build_value = total;
        end
    endfunction

    function [3:0] compact_code(input [7:0] weights);
        integer lane, digit, code, multiplier, selected;
        begin
            code = 0;
            multiplier = 1;
            selected = 0;
            for (lane = 0; lane < 4; lane = lane + 1) begin
                if (mask_q[lane]) begin
                    case (weights[lane*2 +: 2])
                        2'b00: digit = 0;
                        2'b01: digit = 1;
                        2'b10: digit = 2;
                        default: digit = -1;
                    endcase
                    if (digit >= 0) begin
                        code = code + digit * multiplier;
                        multiplier = multiplier * 3;
                        selected = selected + 1;
                    end
                end
            end
            compact_code = (selected == 2 && code < 9) ? code[3:0] : 4'hf;
        end
    endfunction

    initial begin
        if (DATA_WIDTH < 1 || ACC_WIDTH < DATA_WIDTH)
            $error("ternary_lut24_bram widths are invalid");
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mask_q <= 0;
            x0_q <= 0; x1_q <= 0; x2_q <= 0; x3_q <= 0;
            build_index <= 0;
            building <= 0;
            result_valid <= 0;
            error_out <= 0;
            result <= 0;
            for (i = 0; i < 9; i = i + 1) table_mem[i] <= 0;
        end else begin
            result_valid <= 0;
            error_out <= 0;
            if (load_valid && !building) begin
                if ((keep_mask == 0) ||
                    ((keep_mask[0] + keep_mask[1] + keep_mask[2] + keep_mask[3]) != 2)) begin
                    error_out <= 1;
                end else begin
                    mask_q <= keep_mask;
                    x0_q <= x0; x1_q <= x1; x2_q <= x2; x3_q <= x3;
                    build_index <= 0;
                    building <= 1;
                end
            end else if (building) begin
                table_mem[build_index] <= build_value(build_index);
                if (build_index == 8) building <= 0;
                else build_index <= build_index + 1'b1;
            end
            if (query_valid && ready) begin
                if (compact_code(packed_weights) == 4'hf) error_out <= 1;
                else begin
                    result <= table_mem[compact_code(packed_weights)];
                    result_valid <= 1;
                end
            end else if (query_valid && !ready) error_out <= 1;
        end
    end
endmodule
