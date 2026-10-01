// Edge-case vectors for ternary_dot (scripts/xcheck/ternary_dot_nodebug.v @ 25358a24).
// VECTOR_LEN=4 so each case is four elements; the reference is computed in the bench
// with 32-bit signed arithmetic and compared against acc_out on valid_out.
`timescale 1ns / 1ps
module tb_edge;
    reg clk = 0, rst_n = 0, valid_in = 0;
    reg  [7:0] activation;
    reg  [1:0] weight_enc;
    wire [31:0] acc_out;
    wire valid_out;

    ternary_dot #(.VECTOR_LEN(4)) dut (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out));

    always #5 clk = ~clk;

    integer ref_sum, i, fails = 0;
    reg signed [7:0] a [0:3];
    reg [1:0] w [0:3];

    function integer tval(input [1:0] e);
        tval = (e == 2'b01) ? 1 : (e == 2'b10) ? -1 : 0;
    endfunction

    task run_case(input [255:0] name);
        begin
            ref_sum = 0;
            for (i = 0; i < 4; i = i + 1) ref_sum = ref_sum + tval(w[i]) * a[i];
            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk); valid_in = 1; activation = a[i]; weight_enc = w[i];
            end
            @(negedge clk); valid_in = 0;
            if (!valid_out) @(posedge valid_out);
            // acc_out is registered from result_latch on the edge after vector_done rises
            @(posedge clk); #1;
            if ($signed(acc_out) !== ref_sum) begin
                fails = fails + 1;
                $display("FAIL %0s: got %0d expected %0d", name, $signed(acc_out), ref_sum);
            end else
                $display("ok   %0s: %0d", name, ref_sum);
            repeat (3) @(negedge clk);
        end
    endtask

    initial begin
        activation = 0; weight_enc = 0;
        repeat (3) @(negedge clk); rst_n = 1;

        a[0]=127;  a[1]=127;  a[2]=127;  a[3]=127;  w[0]=1; w[1]=1; w[2]=1; w[3]=1; run_case("all +1 x 127");
        a[0]=127;  a[1]=127;  a[2]=127;  a[3]=127;  w[0]=2; w[1]=2; w[2]=2; w[3]=2; run_case("all -1 x 127");
        a[0]=-127; a[1]=-127; a[2]=-127; a[3]=-127; w[0]=2; w[1]=2; w[2]=2; w[3]=2; run_case("all -1 x -127");
        a[0]=-128; a[1]=-128; a[2]=-128; a[3]=-128; w[0]=1; w[1]=1; w[2]=1; w[3]=1; run_case("all +1 x -128");
        a[0]=-128; a[1]=0;    a[2]=0;    a[3]=0;    w[0]=2; w[1]=0; w[2]=0; w[3]=0; run_case("one -1 x -128");
        a[0]=-128; a[1]=-128; a[2]=-128; a[3]=-128; w[0]=2; w[1]=2; w[2]=2; w[3]=2; run_case("all -1 x -128");
        a[0]=5;    a[1]=0;    a[2]=0;    a[3]=0;    w[0]=3; w[1]=0; w[2]=0; w[3]=0; run_case("reserved 2'b11 x 5 (ref: 0)");

        $display("fails=%0d", fails);
        $finish;
    end
endmodule
