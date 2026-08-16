`timescale 1ns / 1ps
module tb_ternary_feature_pipeline;
    reg clk=0, rst_n=0, activation_valid=0, weight_valid=0;
    reg signed [7:0] x0,x1,x2,x3; reg [7:0] packed_weights;
    wire busy,ready; wire [3:0] keep_mask; wire [1:0] keep_count;
    wire signed [7:0] kept_value0,kept_value1; wire [9:0] decoded_weights;
    wire result_valid,error_out; wire signed [15:0] result;
    integer errors=0;
    always #5 clk=~clk;

    ternary_feature_pipeline dut (.*);

    task send_activation(input integer a0,input integer a1,input integer a2,input integer a3);
        begin
            @(negedge clk); x0=a0; x1=a1; x2=a2; x3=a3; activation_valid=1;
            @(posedge clk); #1; @(negedge clk); activation_valid=0;
        end
    endtask
    task query(input integer code_value,input integer expected);
        integer i; reg seen;
        begin
            @(negedge clk); packed_weights=code_value; weight_valid=1;
            seen=0;
            @(posedge clk); #1; weight_valid=0;
            for (i=0; i<5; i=i+1) begin
                if (result_valid || error_out) begin
                    seen=1;
                    if (!result_valid || error_out || result !== expected) begin
                        $display("FAIL code=%0d valid=%b error=%b result=%0d expected=%0d",
                                 code_value,result_valid,error_out,result,expected);
                        errors=errors+1;
                    end
                end
                @(posedge clk); #1;
            end
            if (!seen) begin
                $display("FAIL code=%0d valid=%b error=%b result=%0d expected=%0d",
                         code_value,result_valid,error_out,result,expected);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        x0=0;x1=0;x2=0;x3=0;packed_weights=0;
        repeat(2) @(posedge clk); rst_n=1;
        send_activation(3,-2,5,1);
        wait(ready);
        if (keep_mask !== 4'b0101 || keep_count !== 2 ||
            kept_value0 !== 5 || kept_value1 !== 3) begin
            $display("FAIL sparse metadata mask=%b count=%0d values=%0d,%0d",
                     keep_mask,keep_count,kept_value0,kept_value1);
            errors=errors+1;
        end
        // digits [lane0..3] = [+,0,-,0], fifth digit = 0: code 19.
        query(19,-2);
        // digits [lane0..3] = [+, -, 0, +], fifth digit = 0: code 34.
        query(34,3);
        // 243 is reserved by the five-weight decoder.
        @(negedge clk); packed_weights=243; weight_valid=1;
        @(posedge clk); #1; weight_valid=0;
        if (error_out && !result_valid) begin
            // Expected one-cycle reserved-code error pulse.
        end else begin
            repeat(2) @(posedge clk); #1;
        end
        if (!error_out || result_valid) begin
            $display("FAIL reserved packed code was accepted"); errors=errors+1;
        end
        if (errors == 0) $display("feature pipeline integration: PASS");
        else $fatal(1,"feature pipeline integration: %0d error(s)",errors);
        $finish;
    end
    initial begin #20000; $fatal(1,"feature pipeline integration timeout"); end
endmodule
