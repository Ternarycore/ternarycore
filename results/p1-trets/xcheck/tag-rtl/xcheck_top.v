// Wrapper for the v1.0.1-trets rtl/ternary_dot.v: same seven ports as the xcheck
// ternary_dot_nodebug.v, debug outputs left unconnected so synthesis drops them.
// The tag RTL itself is used unmodified.
module xcheck_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  activation,
    input  wire [1:0]  weight_enc,
    output wire [31:0] acc_out,
    output wire        valid_out
);
    ternary_dot u (
        .clk(clk), .rst_n(rst_n), .valid_in(valid_in),
        .activation(activation), .weight_enc(weight_enc),
        .acc_out(acc_out), .valid_out(valid_out),
        .debug_valid_in_out(), .debug_activation_out(), .debug_weight_enc_out(),
        .debug_acc_out_out(), .debug_valid_out_out()
    );
endmodule
