`timescale 1ns / 1ps
module tb_ternary_decompress5;
    reg clk=0,rst_n=0,valid_in=0; reg [7:0] packed_in;
    wire valid_out,error_out; wire [9:0] weight_enc;
    integer errors=0,cases=0,code_value;
    always #5 clk=~clk;
    ternary_decompress5 dut (.*);

    task automatic apply_code(input integer code_value);
        integer n,d,i; reg [9:0] expected;
        begin
            n=code_value; expected=0;
            for(i=0;i<5;i=i+1) begin
                d=n%3; n=n/3; expected[i*2 +: 2]=d[1:0];
            end
            @(negedge clk); packed_in=code_value; valid_in=1;
            @(posedge clk); #1; cases=cases+1;
            if(!valid_out || error_out || weight_enc!==expected) begin
                $display("FAIL code=%0d got valid=%b error=%b weights=%b expected=%b",
                         code_value,valid_out,error_out,weight_enc,expected);
                errors=errors+1;
            end
            @(negedge clk); valid_in=0;
        end
    endtask

    initial begin
        packed_in=0; repeat(2) @(posedge clk); rst_n=1;
        for(code_value=0; code_value<243; code_value=code_value+1)
            apply_code(code_value);
        @(negedge clk); packed_in=243; valid_in=1;
        @(posedge clk); #1; cases=cases+1;
        if(valid_out || !error_out) begin
            $display("FAIL reserved code was accepted"); errors=errors+1;
        end
        @(negedge clk); packed_in=255; valid_in=1;
        @(posedge clk); #1; cases=cases+1;
        if(valid_out || !error_out) begin
            $display("FAIL highest reserved code was accepted"); errors=errors+1;
        end
        if(errors!=0) $fatal(1,"ternary decompressor regression failed");
        $display("ternary decompressor regression: %0d cases passed",cases);
        $finish;
    end
    initial begin #10000; $fatal(1,"ternary decompressor regression timeout"); end
endmodule
