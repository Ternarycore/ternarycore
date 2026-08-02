// SPDX-License-Identifier: CERN-OHL-S-2.0
// Copyright (C) 2026 Ifedayo Oladapo
// TernaryCore — Open-Source FPGA Accelerator for BitNet Inference
// Source: https://github.com/shepherdscientific/ternarycore
//
// Shared definitions for TernaryCore RTL.
//
// weight_enc: 2-bit {00=zero, 01=+1, 10=-1}
// ternary_weighted returns a signed (DATA_WIDTH+1)-bit value so that
// -($signed(-128)) produces +128 without 8-bit overflow.

function signed [DATA_WIDTH+1-1:0] ternary_weighted;
    input [1:0] w;
    input signed [DATA_WIDTH-1:0] a;
    reg signed [DATA_WIDTH-1:0] a_ext;
    begin
        a_ext = a;
        case (w)
            2'b00:   ternary_weighted = {(DATA_WIDTH+1){1'b0}};
            2'b01:   ternary_weighted = $signed({a_ext[DATA_WIDTH-1], a_ext});
            default: ternary_weighted = -$signed({a_ext[DATA_WIDTH-1], a_ext});
        endcase
    end
endfunction
