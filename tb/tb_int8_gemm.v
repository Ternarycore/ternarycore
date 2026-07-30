// tb_int8_gemm.v — correctness of the INT8 baseline (COLS parallel dots).
`timescale 1ns / 1ps
module tb_int8_gemm;
    localparam DW=8, WW=8, AW=32, COLS=4, DEPTH=8;
    reg clk=0, rst_n=0, valid_in=0;
    reg signed [DW-1:0] activation;
    reg [WW*COLS-1:0] weight;
    wire [AW*COLS-1:0] acc_out;
    wire valid_out;
    always #5 clk=~clk;

    int8_gemm #(.DATA_WIDTH(DW),.WEIGHT_WIDTH(WW),.ACC_WIDTH(AW),.COLS(COLS),.DEPTH(DEPTH)) dut(
        .clk(clk),.rst_n(rst_n),.valid_in(valid_in),.activation(activation),
        .weight(weight),.acc_out(acc_out),.valid_out(valid_out));

    integer k,c,errors; integer exp[0:COLS-1];
    reg signed [DW-1:0] acts[0:DEPTH-1];
    reg signed [WW-1:0] w[0:DEPTH-1][0:COLS-1];
    initial begin
        errors=0;
        for(c=0;c<COLS;c=c+1) exp[c]=0;
        for(k=0;k<DEPTH;k=k+1) begin
            acts[k]=(k%9)-4;
            for(c=0;c<COLS;c=c+1) begin w[k][c]=((k+c)%7)-3; exp[c]=exp[c]+acts[k]*w[k][c]; end
        end
        repeat(3) @(posedge clk); rst_n=1; @(posedge clk);
        for(k=0;k<DEPTH;k=k+1) begin
            @(negedge clk); valid_in=1; activation=acts[k];
            for(c=0;c<COLS;c=c+1) weight[WW*c +: WW]=w[k][c];
        end
        @(negedge clk); valid_in=0;
        wait(valid_out); @(posedge clk); #1;
        for(c=0;c<COLS;c=c+1)
            if($signed(acc_out[AW*c +: AW])!==exp[c]) begin
                errors=errors+1; $display("FAIL col %0d: %0d exp %0d",c,$signed(acc_out[AW*c +: AW]),exp[c]);
            end
        if(errors==0) $display("INT8 baseline: ALL %0d COLUMNS CORRECT",COLS);
        else $display("INT8 baseline: %0d errors",errors);
        $finish;
    end
    initial begin #50000; $display("TIMEOUT"); $finish; end
endmodule
