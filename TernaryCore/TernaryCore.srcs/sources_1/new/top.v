`timescale 1ns / 1ps

module top (
    input  wire       clk_100M,   // Pin E3 (100MHz system clock)
    input  wire       sys_rst_n,  // Pin C2 (Red CPU rst_n button - active low)
    input  wire       btn0,       // Pin D9 (Button 0 to trigger the test)
    output reg        led_pass,   // Pin H5 (LD4 green LED)
    output reg        led_fail    // Pin J5 (LD5 green LED)
);

    // --- 1. Proper Active-Low Reset Synchronization ---
    // We synchronize the active-low button and preserve its active-low polarity.
    reg [1:0] rst_sync = 2'b00; // Initialize to zero (reset state) on power-up
    always @(posedge clk_100M or negedge sys_rst_n) begin
        if (!sys_rst_n) rst_sync <= 2'b00;
        else            rst_sync <= {rst_sync[0], 1'b1};
    end
    wire sys_rst_n_sync = rst_sync[1]; // Stable, synchronized Active-LOW reset

    // --- 2. Interface Signals ---
    reg        valid_in = 0;
    reg signed [7:0]  reg_activation = 8'sd0;
    reg        [1:0]  reg_weight = 2'b00;
    reg signed [31:0] reg_acc_in = 32'sd0;
    
    wire signed [31:0] mac_out;
    wire               mac_valid_out;

    // --- 3. UUT Instantiation ---
    ternary_mac #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(32)
    ) uut (
        .clk(clk_100M),
        .rst_n(sys_rst_n_sync), // Clean active-low signal connected to your .rst_n port
        .valid_in(valid_in),
        .activation(reg_activation),
        .weight_enc(reg_weight),
        .acc_in(reg_acc_in),
        .acc_out(mac_out),
        .valid_out(mac_valid_out)
    );

    // --- 4. Test Controller FSM ---
    localparam STATE_IDLE  = 2'b00,
               STATE_RUN   = 2'b01,
               STATE_CHECK = 2'b10;
               
    reg [1:0] state = STATE_IDLE; 

    always @(posedge clk_100M) begin
        if (!sys_rst_n_sync) begin    // Reset when this signal drops to 0
            state          <= STATE_IDLE;
            valid_in       <= 0;
            reg_activation <= 8'sd0;
            reg_weight     <= 2'b00;
            reg_acc_in     <= 32'sd0;
            led_pass       <= 0;
            led_fail       <= 0;
        end else begin                 // Run normally when this signal is 1
            case (state)
                STATE_IDLE: begin
                    valid_in <= 0;
                    if (btn0) begin
                        state          <= STATE_RUN;
                        valid_in       <= 1;
                        // Test vector: -5 * -1 (weight 2'b10) + accumulator 10 = 15
                        reg_activation <= -8'sd5; 
                        reg_weight     <= 2'b10;   
                        reg_acc_in     <= 32'sd10;  
                    end
                end

                STATE_RUN: begin
                    valid_in <= 0; 
                    state    <= STATE_CHECK;
                end

                STATE_CHECK: begin
                    if (mac_valid_out) begin
                        if (mac_out == 32'sd15) begin
                            led_pass <= 1;
                            led_fail <= 0;
                        end else begin
                            led_pass <= 0;
                            led_fail <= 1;
                        end
                        state <= STATE_IDLE;
                    end
                end
                
                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule