`timescale 1ns / 1ps
module tb_activation_quant_int4;
    reg clk=0, rst_n=0, valid_in=0;
    reg signed [7:0] x;
    wire signed [3:0] q;
    wire valid_out;
    integer errors=0, cases=0;
    always #5 clk=~clk;
    activation_quant #(.DATA_WIDTH(8), .Q_WIDTH(4), .PRECISION(15), .INV_WIDTH(19)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in), .x(x), .inv(19'd1806),
        .q(q), .valid_out(valid_out));

    task automatic apply_case(input integer value, input integer expected);
        begin
            @(negedge clk); x=value; valid_in=1;
            @(posedge clk);
            @(negedge clk); valid_in=0;
            @(posedge clk); #1;
            cases=cases+1;
            if (!valid_out || $signed(q) != expected) begin
                $display("FAIL x=%0d: got %0d expected %0d", value, q, expected);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        x=0; repeat (2) @(posedge clk); rst_n=1;
        apply_case(-128,-7); apply_case(-127,-7); apply_case(-64,-4);
        apply_case(0,0); apply_case(64,4); apply_case(127,7);
        if (errors != 0) $fatal(1, "INT4 activation quantizer regression failed");
        $display("INT4 activation quantizer regression: %0d/%0d cases passed", cases, cases);
        $finish;
    end
    initial begin #10000; $fatal(1, "INT4 activation quantizer regression timeout"); end
endmodule
