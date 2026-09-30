module trit_decode243 (input wire [7:0] b, output wire [9:0] codes);
  // base-243 -> 5 x 2-bit codes, as a depth-1 distributed ROM (shallowest path).
  reg [9:0] rom [0:255];
  integer i, x, k, c;
  initial begin
    for (i = 0; i < 256; i = i + 1) begin
      x = i; c = 0;
      for (k = 0; k < 5; k = k + 1) begin
        c = c | ((x % 3) << (2*k));
        x = x / 3;
      end
      rom[i] = c;
    end
  end
  assign codes = rom[b];
endmodule
