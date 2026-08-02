// axi_gemm_write_order_formal.v
// Bug Hunt: Write same address twice — which value persists?
//
// Writes 0xAA to ACTIVATION (0x04), then overwrites with 0xBB.
// Reads ACTIVATION back via AR channel and asserts read data is 0xBB.

`timescale 1ns / 1ps

module axi_gemm_write_order_formal(
    input wire clk
);
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter COLS       = 4;
    parameter DEPTH      = 4;

    localparam ADDR_ACTIVATION = 8'h04;
    localparam FIRST_VAL       = 32'h000000AA;
    localparam SECOND_VAL      = 32'h000000BB;

    wire s_axi_aclk;
    wire s_axi_aresetn;
    reg  [7:0]   s_axi_awaddr;
    wire [2:0]   s_axi_awprot;
    reg          s_axi_awvalid;
    wire         s_axi_awready;
    reg  [31:0]  s_axi_wdata;
    wire [3:0]   s_axi_wstrb;
    reg          s_axi_wvalid;
    wire         s_axi_wready;
    wire [1:0]   s_axi_bresp;
    wire         s_axi_bvalid;
    reg          s_axi_bready;
    reg  [7:0]   s_axi_araddr;
    wire [2:0]   s_axi_arprot;
    reg          s_axi_arvalid;
    wire         s_axi_arready;
    wire [31:0]  s_axi_rdata;
    wire [1:0]   s_axi_rresp;
    wire         s_axi_rvalid;
    reg          s_axi_rready;

    assign s_axi_aclk = clk;
    assign s_axi_awprot = 3'b000;
    assign s_axi_wstrb  = 4'b1111;
    assign s_axi_arprot = 3'b000;

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
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );

    // ── Reset: 2 cycles active-low (same pattern as axi_gemm_wrapper_formal) ──
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

    // ── Test state machine ───────────────────────────────────
    localparam ST_IDLE     = 3'd0;
    localparam ST_WR_FIRST = 3'd1;
    localparam ST_WR_SEC   = 3'd2;
    localparam ST_RD       = 3'd3;
    localparam ST_DONE     = 3'd4;

    reg [2:0] state;
    reg [1:0] sub_state;
    reg       transaction_done;

    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            state            <= ST_IDLE;
            sub_state        <= 2'd0;
            transaction_done <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (reset_cnt >= 2) begin
                        state     <= ST_WR_FIRST;
                        sub_state <= 2'd1;
                    end
                end

                ST_WR_FIRST: begin
                    wr_tick;
                    if (sub_state == 2'd2 && s_axi_bvalid && s_axi_bready) begin
                        state     <= ST_WR_SEC;
                        sub_state <= 2'd1;
                    end
                end

                ST_WR_SEC: begin
                    wr_tick;
                    if (sub_state == 2'd2 && s_axi_bvalid && s_axi_bready) begin
                        state     <= ST_RD;
                        sub_state <= 2'd3;
                    end
                end

                ST_RD: begin
                    rd_tick;
                    if (sub_state == 2'd4 && s_axi_rvalid && s_axi_rready) begin
                        state     <= ST_DONE;
                        sub_state <= 2'd0;
                        transaction_done <= 1'b1;
                    end
                end

                ST_DONE: begin
                end
            endcase
        end
    end

    task wr_tick;
        begin
            case (sub_state)
                2'd1: begin
                    if (s_axi_awready && s_axi_wready)
                        sub_state <= 2'd2;
                end
                2'd2: begin
                    if (s_axi_bvalid && s_axi_bready)
                        sub_state <= 2'd0;
                end
            endcase
        end
    endtask

    task rd_tick;
        begin
            case (sub_state)
                2'd3: begin
                    if (s_axi_arready)
                        sub_state <= 2'd4;
                end
                2'd4: begin
                    if (s_axi_rvalid && s_axi_rready)
                        sub_state <= 2'd0;
                end
            endcase
        end
    endtask

    // ── AXI signal drives ────────────────────────────────────
    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            s_axi_awaddr  <= 8'h00;
            s_axi_awvalid <= 1'b0;
            s_axi_wdata   <= 32'h00000000;
            s_axi_wvalid  <= 1'b0;
            s_axi_bready  <= 1'b0;
            s_axi_araddr  <= 8'h00;
            s_axi_arvalid <= 1'b0;
            s_axi_rready  <= 1'b0;
        end else begin
            if (state == ST_WR_FIRST && sub_state == 2'd1) begin
                s_axi_awaddr  <= ADDR_ACTIVATION;
                s_axi_awvalid <= 1'b1;
                s_axi_wdata   <= FIRST_VAL;
                s_axi_wvalid  <= 1'b1;
            end else if (state == ST_WR_SEC && sub_state == 2'd1) begin
                s_axi_awaddr  <= ADDR_ACTIVATION;
                s_axi_awvalid <= 1'b1;
                s_axi_wdata   <= SECOND_VAL;
                s_axi_wvalid  <= 1'b1;
            end else begin
                if (s_axi_awready)
                    s_axi_awvalid <= 1'b0;
                if (s_axi_wready)
                    s_axi_wvalid <= 1'b0;
            end

            if (sub_state == 2'd2) begin
                s_axi_bready <= 1'b1;
            end else begin
                if (s_axi_bvalid)
                    s_axi_bready <= 1'b0;
            end

            if (state == ST_RD && sub_state == 2'd3) begin
                s_axi_araddr  <= ADDR_ACTIVATION;
                s_axi_arvalid <= 1'b1;
            end else begin
                if (s_axi_arready)
                    s_axi_arvalid <= 1'b0;
            end

            if (state == ST_RD && sub_state == 2'd4) begin
                s_axi_rready <= 1'b1;
            end else begin
                if (s_axi_rvalid)
                    s_axi_rready <= 1'b0;
            end
        end
    end

    // ── Assertion: last write wins ───────────────────────────
    reg [31:0] readback_data;
    always @(posedge clk) begin
        if (!s_axi_aresetn)
            readback_data <= 32'h00000000;
        else if (state == ST_RD && sub_state == 2'd4 && s_axi_rvalid && s_axi_rready)
            readback_data <= s_axi_rdata;
    end

    reg [3:0] run_cnt;
    initial run_cnt = 4'd0;
    always @(posedge clk) begin
        if (!s_axi_aresetn) run_cnt <= 4'd0;
        else if (run_cnt < 4'd15) run_cnt <= run_cnt + 1;
    end

    always @(posedge clk) begin
        if (run_cnt >= 4'd4 && transaction_done) begin
            assert(readback_data[7:0] == SECOND_VAL[7:0]);
        end
    end

    // ── Cover points ────────────────────────────────────────
    always @(posedge clk) begin
        if (reset_cnt >= 2) begin
            cover(state == ST_DONE);
            cover(transaction_done);
            cover(state == ST_RD && sub_state == 2'd4 && s_axi_rvalid && s_axi_rready);
        end
    end

endmodule
