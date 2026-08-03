// axi_gemm_wrapper_b2b_formal.v
// Formal cover + bmc: back-to-back pipeline triggers through axi_gemm_wrapper.
//
// Drives complete AXI-Lite write transactions for:
//   Phase 1: DEPTH activation writes → CTRL write → wait for valid_out
//   Phase 2: DEPTH MORE activation writes → CTRL write → wait for valid_out again
//
// Asserts both pipelines complete: gemm_valid_out fires twice.
// Uses a counter-based tracker for which sub-transaction we're on (AW/W/B)
// rather than a large one-hot FSM, keeping solver tractable.

`timescale 1ns / 1ps

module axi_gemm_wrapper_b2b_formal(
    input wire clk
);
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter COLS       = 4;
    parameter DEPTH      = 4;
    parameter MORE       = 4;

    localparam ADDR_ACTIVATION = 8'h04;
    localparam ADDR_CTRL       = 8'h00;
    localparam ACTIV_DATA      = 8'h42;
    localparam CTRL_START_VAL  = 32'h00000001;

    // ── DUT ────────────────────────────────────────────────
    wire         s_axi_aclk;
    wire         s_axi_aresetn;
    wire [7:0]   s_axi_awaddr;
    wire [2:0]   s_axi_awprot;
    wire         s_axi_awvalid;
    wire         s_axi_awready;
    wire [31:0]  s_axi_wdata;
    wire [3:0]   s_axi_wstrb;
    wire         s_axi_wvalid;
    wire         s_axi_wready;
    wire [1:0]   s_axi_bresp;
    wire         s_axi_bvalid;
    wire         s_axi_bready;

    assign s_axi_aclk = clk;

    assign s_axi_arprot  = 3'b000;
    assign s_axi_araddr  = 8'h00;
    assign s_axi_arvalid = 1'b0;
    assign s_axi_rready  = 1'b0;

    axi_gemm_wrapper #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .COLS(COLS),
        .DEPTH(DEPTH)
    ) dut (
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_araddr (s_axi_araddr),
        .s_axi_arprot (s_axi_arprot),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_rready (s_axi_rready)
    );

    // ── Reset: 2 cycles active-low ─────────────────────────
    reg [1:0] reset_cnt;
    initial reset_cnt = 0;
    always @(posedge clk) begin
        if (reset_cnt < 2) begin
            assume(!s_axi_aresetn);
            reset_cnt <= reset_cnt + 1;
        end else begin
            assume(s_axi_aresetn);
        end
    end

    // ── Pipeline completion tracking ──────────────────────
    // Use hierarchical ref to gemm's valid_out (internal wire)
    reg gemm_vo_d1, gemm_vo_d2;
    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            gemm_vo_d1 <= 1'b0;
            gemm_vo_d2 <= 1'b0;
        end else begin
            gemm_vo_d1 <= dut.gemm_i.valid_out;
            gemm_vo_d2 <= gemm_vo_d1;
        end
    end
    wire result_pulse = gemm_vo_d1 && !gemm_vo_d2;

    reg [1:0] pipeline_count;
    always @(posedge clk) begin
        if (!s_axi_aresetn)
            pipeline_count <= 2'b00;
        else if (result_pulse && pipeline_count < 2'b11)
            pipeline_count <= pipeline_count + 1;
    end

    // ── Phase tracking helpers ─────────────────────────────
    reg        axiph_active;   // 1 during an AXI transaction
    reg [1:0]  axiph_sub;     // 0=idle, 1=AW, 2=W, 3=B
    reg [7:0]  elem_idx;      // element index within current block (0..DEPTH-1, 0..MORE-1)
    reg [3:0]  major;         // 0=reset, 1=phase1_act, 2=phase1_ctrl, 3=phase1_wait,
                              // 4=phase2_act, 5=phase2_ctrl, 6=phase2_wait, 7=done

    // Address/data for the current AXI transaction
    reg [7:0]  cur_addr;
    reg [31:0] cur_data;

    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            axiph_active <= 1'b0;
            axiph_sub    <= 2'd0;
            elem_idx     <= 8'd0;
            major        <= 4'd0;
            cur_addr     <= 8'h00;
            cur_data     <= 32'h00000000;
        end else begin
            case (major)
                4'd0: begin  // reset wait
                    if (reset_cnt >= 2) begin
                        major <= 4'd1;
                        axiph_active <= 1'b1;
                        axiph_sub <= 2'd1;  // AW phase
                        elem_idx <= 8'd0;
                        cur_addr <= ADDR_ACTIVATION;
                        cur_data <= {24'h000000, ACTIV_DATA};
                    end
                end

                4'd1: begin  // Phase 1: write DEPTH activations
                    axi_tick;
                    if (axiph_sub == 2'd3 && s_axi_bvalid && s_axi_bready) begin
                        // Transaction complete
                        if (elem_idx >= DEPTH-1) begin
                            major <= 4'd2;       // → CTRL write
                            elem_idx <= 8'd0;
                            cur_addr <= ADDR_CTRL;
                            cur_data <= CTRL_START_VAL;
                            axiph_sub <= 2'd1;
                        end else begin
                            elem_idx <= elem_idx + 1;
                            axiph_sub <= 2'd1;   // next activation
                        end
                    end
                end

                4'd2: begin  // Phase 1: write CTRL
                    axi_tick;
                    if (axiph_sub == 2'd3 && s_axi_bvalid && s_axi_bready) begin
                        major <= 4'd3;
                        axiph_active <= 1'b0;
                        axiph_sub <= 2'd0;
                    end
                end

                4'd3: begin  // Phase 1: wait for valid_out
                    axiph_active <= 1'b0;
                    axiph_sub <= 2'd0;
                    if (result_pulse) begin
                        major <= 4'd4;
                        elem_idx <= 8'd0;
                        axiph_active <= 1'b1;
                        axiph_sub <= 2'd1;
                        cur_addr <= ADDR_ACTIVATION;
                        cur_data <= {24'h000000, ACTIV_DATA};
                    end
                end

                4'd4: begin  // Phase 2: write DEPTH MORE activations
                    axi_tick;
                    if (axiph_sub == 2'd3 && s_axi_bvalid && s_axi_bready) begin
                        if (elem_idx >= MORE-1) begin
                            major <= 4'd5;
                            elem_idx <= 8'd0;
                            cur_addr <= ADDR_CTRL;
                            cur_data <= CTRL_START_VAL;
                            axiph_sub <= 2'd1;
                        end else begin
                            elem_idx <= elem_idx + 1;
                            axiph_sub <= 2'd1;
                        end
                    end
                end

                4'd5: begin  // Phase 2: write CTRL
                    axi_tick;
                    if (axiph_sub == 2'd3 && s_axi_bvalid && s_axi_bready) begin
                        major <= 4'd6;
                        axiph_active <= 1'b0;
                        axiph_sub <= 2'd0;
                    end
                end

                4'd6: begin  // Phase 2: wait for valid_out again
                    axiph_active <= 1'b0;
                    axiph_sub <= 2'd0;
                    if (result_pulse) begin
                        major <= 4'd7;
                    end
                end

                4'd7: begin  // done
                    // stay
                end
            endcase
        end
    end

    // ── AXI tick: advance the sub-phase through AW → W → B ──
    task axi_tick;
        begin
            case (axiph_sub)
                2'd1: begin  // AW phase: drive AW + W together (AXI-Lite style)
                    if (s_axi_awready && s_axi_wready)
                        axiph_sub <= 2'd3;  // both done, go to B
                end
                2'd3: begin  // B phase: wait for bvalid
                    if (s_axi_bvalid && s_axi_bready)
                        axiph_sub <= 2'd0;  // complete
                end
            endcase
        end
    endtask

    // ── AXI signal generation ──────────────────────────────
    assign s_axi_awprot = 3'b000;
    assign s_axi_wstrb  = 4'b1111;

    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            s_axi_awaddr  <= 8'h00;
            s_axi_awvalid <= 1'b0;
            s_axi_wdata   <= 32'h00000000;
            s_axi_wvalid  <= 1'b0;
            s_axi_bready  <= 1'b0;
        end else begin
            // AW: drive when in AW phase
            if (axiph_active && axiph_sub == 2'd1) begin
                s_axi_awaddr  <= cur_addr;
                s_axi_awvalid <= 1'b1;
                s_axi_wdata   <= cur_data;
                s_axi_wvalid  <= 1'b1;
            end else begin
                if (s_axi_awready)
                    s_axi_awvalid <= 1'b0;
                if (s_axi_wready)
                    s_axi_wvalid <= 1'b0;
            end

            // B: drive bready when in B phase
            if (axiph_active && axiph_sub == 2'd3) begin
                s_axi_bready <= 1'b1;
            end else begin
                if (s_axi_bvalid)
                    s_axi_bready <= 1'b0;
            end
        end
    end

    // ── Assertions ─────────────────────────────────────────
    reg run_done;
    always @(posedge clk) begin
        if (!s_axi_aresetn)
            run_done <= 1'b0;
        else if (major == 4'd7)
            run_done <= 1'b1;
    end

    always @(posedge clk) begin
        if (reset_cnt >= 2 && run_done) begin
            assert(pipeline_count >= 2);
        end
    end

    // ── Cover points ───────────────────────────────────────
    always @(posedge clk) begin
        if (reset_cnt >= 2) begin
            cover(major == 4'd7);                      // test completes
            cover(pipeline_count >= 2);                 // both pipelines done
            cover(pipeline_count >= 1);                 // at least one pipeline
            cover(major == 4'd3 && result_pulse);       // first valid_out
            cover(major == 4'd6 && result_pulse);       // second valid_out
        end
    end

endmodule
