`timescale 1ns / 1ps

module top (
    input  wire       clk_27M,     // pin 52 — 27 MHz onboard oscillator
    input  wire       sys_rst_n,   // pin 4 — dedicated reset button (active low)
    input  wire       btn_trigger, // pin 14 — User Button B (triggers MAC test)
    output reg        led_r,       // pin 15 — LED4: pass
    output reg        led_g,       // pin 16 — LED5: fail
    output reg        led_b        // pin 11 — LED1: heartbeat (clock alive)
);

    // --- 1. Active-Low Reset Synchronization ---
    reg [1:0] rst_sync = 2'b00;
    always @(posedge clk_27M or negedge sys_rst_n) begin
        if (!sys_rst_n) rst_sync <= 2'b00;
        else            rst_sync <= {rst_sync[0], 1'b1};
    end
    wire sys_rst_n_sync = rst_sync[1];

    // --- 2. Interface Signals ---
    reg               valid_in = 0;
    reg signed [7:0]  reg_activation = 8'sd0;
    reg        [1:0]  reg_weight = 2'b00;
    reg signed [31:0] reg_acc_in = 32'sd0;

    wire signed [31:0] mac_out;
    wire               mac_valid_out;

    // --- 3. UUT Instantiation (shared rtl/ternary_mac.v) ---
    ternary_mac #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(32)
    ) uut (
        .clk(clk_27M),
        .rst_n(sys_rst_n_sync),
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

    // --- 4b. Button Debounce (~5ms at 27MHz) ---
    reg btn_debounced;
    reg btn_pressed;
    reg btn_sync_0, btn_sync_1;
    reg [17:0] debounce_timer;  // 18-bit counter, 135k = ~5ms at 27MHz

    always @(posedge clk_27M or negedge sys_rst_n_sync) begin
        if (!sys_rst_n_sync) begin
            btn_sync_0    <= 1'b0;
            btn_sync_1    <= 1'b0;
            btn_debounced <= 1'b0;
            debounce_timer <= 18'd0;
        end else begin
            btn_sync_0 <= btn_trigger;
            btn_sync_1 <= btn_sync_0;

            if (btn_sync_1 == btn_debounced)
                debounce_timer <= 18'd0;
            else begin
                debounce_timer <= debounce_timer + 18'd1;
                if (debounce_timer == 18'd135_000)
                    btn_debounced <= btn_sync_1;
            end
        end
    end

    reg btn_debounced_d;
    always @(posedge clk_27M) begin
        btn_debounced_d <= btn_debounced;
        btn_pressed <= btn_debounced && !btn_debounced_d;
    end

    // --- 5. Heartbeat LED (toggles ~0.8 Hz) ---
    reg [24:0] heartbeat_cnt;  // 25-bit counter, 27M / 2^25 ≈ 0.8 Hz
    always @(posedge clk_27M or negedge sys_rst_n_sync) begin
        if (!sys_rst_n_sync)
            heartbeat_cnt <= 25'd0;
        else
            heartbeat_cnt <= heartbeat_cnt + 25'd1;
    end
    wire heartbeat = heartbeat_cnt[24];

    // --- 6. Main FSM ---
    always @(posedge clk_27M) begin
        if (!sys_rst_n_sync) begin
            state          <= STATE_IDLE;
            valid_in       <= 0;
            reg_activation <= 8'sd0;
            reg_weight     <= 2'b00;
            reg_acc_in     <= 32'sd0;
            led_r          <= 0;
            led_g          <= 0;
            led_b          <= 0;
        end else begin
            led_b <= heartbeat;  // always shows clock is alive

            case (state)
                STATE_IDLE: begin
                    valid_in <= 0;
                    if (btn_pressed) begin
                        state          <= STATE_RUN;
                        valid_in       <= 1;
                        reg_activation <= -8'sd5;   // activation = -5
                        reg_weight     <= 2'b10;    // weight = -1 (ternary)
                        reg_acc_in     <= 32'sd10;  // accumulator = 10
                    end
                end

                STATE_RUN: begin
                    valid_in <= 0;
                    state    <= STATE_CHECK;
                end

                STATE_CHECK: begin
                    if (mac_valid_out) begin
                        if (mac_out == 32'sd15) begin
                            led_r <= 1;   // red = pass
                            led_g <= 0;
                        end else begin
                            led_r <= 0;
                            led_g <= 1;   // green = fail
                        end
                        state <= STATE_IDLE;
                    end
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule
