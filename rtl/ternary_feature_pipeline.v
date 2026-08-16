// SPDX-License-Identifier: CERN-OHL-S-2.0
// Integration shell for the sparse activation, packed-weight, and LUT paths.
//
// A valid activation group is sparsified first.  The resulting masked group
// populates all 3^4 LUT entries, after which a packed five-weight byte can be
// decoded and its first four weights can query the populated table.  The fifth
// decoded weight is exposed for a future 5-wide consumer; this LUT is 4-wide.

`timescale 1ns / 1ps

module ternary_feature_pipeline #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 16
)(
    input wire                         clk,
    input wire                         rst_n,
    input wire                         activation_valid,
    input wire signed [DATA_WIDTH-1:0] x0,
    input wire signed [DATA_WIDTH-1:0] x1,
    input wire signed [DATA_WIDTH-1:0] x2,
    input wire signed [DATA_WIDTH-1:0] x3,
    input wire                         weight_valid,
    input wire [7:0]                   packed_weights,
    output wire                         busy,
    output wire                         ready,
    output wire [3:0]                   keep_mask,
    output wire [1:0]                   keep_count,
    output wire signed [DATA_WIDTH-1:0] kept_value0,
    output wire signed [DATA_WIDTH-1:0] kept_value1,
    output wire [9:0]                   decoded_weights,
    output wire                         result_valid,
    output wire                         error_out,
    output wire signed [ACC_WIDTH-1:0] result
);
    localparam S_IDLE = 2'd0, S_FILL = 2'd1, S_READY = 2'd2;

    wire sparse_valid;
    wire [3:0] sparse_mask;
    wire [1:0] sparse_count;
    wire signed [DATA_WIDTH-1:0] sparse_value0, sparse_value1;
    reg signed [DATA_WIDTH-1:0] x0_pending, x1_pending, x2_pending, x3_pending;
    reg signed [DATA_WIDTH-1:0] x0_q, x1_q, x2_q, x3_q;
    reg [3:0] mask_q;

    activation_sparse24 #(.DATA_WIDTH(DATA_WIDTH)) u_sparse (
        .clk(clk), .rst_n(rst_n), .valid_in(activation_valid),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .valid_out(sparse_valid), .keep_mask(sparse_mask),
        .keep_count(sparse_count), .value0(sparse_value0),
        .value1(sparse_value1));

    assign keep_mask = sparse_mask;
    assign keep_count = sparse_count;
    assign kept_value0 = sparse_value0;
    assign kept_value1 = sparse_value1;

    reg [1:0] state;
    reg [6:0] fill_addr;
    initial begin
        if (ACC_WIDTH < DATA_WIDTH)
            $error("ternary_feature_pipeline requires ACC_WIDTH >= DATA_WIDTH");
    end
    assign busy = (state == S_FILL);
    assign ready = (state == S_READY);

    function signed [ACC_WIDTH-1:0] sparse_dot(input [6:0] code_value);
        integer n, d, i;
        reg signed [ACC_WIDTH-1:0] total, selected;
        begin
            n = {25'b0, code_value};
            total = 0;
            for (i = 0; i < 4; i = i + 1) begin
                d = n % 3;
                n = n / 3;
                case (i)
                    0: selected = {{(ACC_WIDTH-DATA_WIDTH){x0_q[DATA_WIDTH-1]}}, x0_q};
                    1: selected = {{(ACC_WIDTH-DATA_WIDTH){x1_q[DATA_WIDTH-1]}}, x1_q};
                    2: selected = {{(ACC_WIDTH-DATA_WIDTH){x2_q[DATA_WIDTH-1]}}, x2_q};
                    default: selected = {{(ACC_WIDTH-DATA_WIDTH){x3_q[DATA_WIDTH-1]}}, x3_q};
                endcase
                if (mask_q[i]) begin
                    if (d == 1) total = total + selected;
                    else if (d == 2) total = total - selected;
                end
            end
            sparse_dot = total;
        end
    endfunction

    wire lut_wr_en = (state == S_FILL);
    wire [6:0] lut_wr_addr = fill_addr;
    wire signed [ACC_WIDTH-1:0] lut_wr_data = sparse_dot(fill_addr);

    wire dec_valid, dec_error;
    ternary_decompress5 u_decompress (
        .clk(clk), .rst_n(rst_n), .valid_in(weight_valid),
        .packed_in(packed_weights), .valid_out(dec_valid),
        .error_out(dec_error), .weight_enc(decoded_weights));

    function [6:0] first_four_address(input [7:0] weights);
        integer d0, d1, d2, d3;
        begin
            d0 = (weights[1:0] == 2'b01) ? 1 :
                 (weights[1:0] == 2'b10) ? 2 : 0;
            d1 = (weights[3:2] == 2'b01) ? 1 :
                 (weights[3:2] == 2'b10) ? 2 : 0;
            d2 = (weights[5:4] == 2'b01) ? 1 :
                 (weights[5:4] == 2'b10) ? 2 : 0;
            d3 = (weights[7:6] == 2'b01) ? 1 :
                 (weights[7:6] == 2'b10) ? 2 : 0;
            first_four_address = 7'(d0 + 3*d1 + 9*d2 + 27*d3);
        end
    endfunction

    wire invalid_weight = (decoded_weights[1:0] == 2'b11) ||
                          (decoded_weights[3:2] == 2'b11) ||
                          (decoded_weights[5:4] == 2'b11) ||
                          (decoded_weights[7:6] == 2'b11);
    wire lut_query_valid = dec_valid && ready && !dec_error && !invalid_weight;
    wire [6:0] lut_query_addr = first_four_address(decoded_weights[7:0]);
    wire lut_result_valid, lut_error;

    ternary_lut4_bram #(.ACC_WIDTH(ACC_WIDTH)) u_lut (
        .clk(clk), .rst_n(rst_n), .wr_en(lut_wr_en),
        .wr_addr(lut_wr_addr), .wr_data(lut_wr_data),
        .query_valid(lut_query_valid), .query_addr(lut_query_addr),
        .result_valid(lut_result_valid), .error_out(lut_error),
        .result(result));

    assign result_valid = lut_result_valid;
    assign error_out = dec_error || (dec_valid && ready && invalid_weight) || lut_error;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            fill_addr <= 0;
            x0_pending <= 0; x1_pending <= 0; x2_pending <= 0; x3_pending <= 0;
            x0_q <= 0; x1_q <= 0; x2_q <= 0; x3_q <= 0;
            mask_q <= 0;
        end else begin
            if (activation_valid) begin
                x0_pending <= x0; x1_pending <= x1;
                x2_pending <= x2; x3_pending <= x3;
            end
            case (state)
                S_IDLE, S_READY: if (sparse_valid) begin
                    x0_q <= x0_pending; x1_q <= x1_pending;
                    x2_q <= x2_pending; x3_q <= x3_pending;
                    mask_q <= sparse_mask;
                    fill_addr <= 0;
                    state <= S_FILL;
                end
                S_FILL: if (fill_addr == 7'd80) begin
                    state <= S_READY;
                end else begin
                    fill_addr <= fill_addr + 1'b1;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
