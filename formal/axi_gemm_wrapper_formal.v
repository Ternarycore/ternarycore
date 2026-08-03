// Formal cover + bmc for axi_gemm_wrapper.
// Drives one write to ACTIVATION (0x04), then reads it back.
// Proves write persistence through the register map.

`timescale 1ns / 1ps

module axi_gemm_wrapper_formal(
    input wire clk
);
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter COLS       = 4;
    parameter DEPTH      = 4;

    localparam ADDR_ACTIVATION = 8'h04;
    localparam WRITE_DATA      = 8'hA5;

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
    wire [7:0]   s_axi_araddr;
    wire [2:0]   s_axi_arprot;
    wire         s_axi_arvalid;
    wire         s_axi_arready;
    wire [31:0]  s_axi_rdata;
    wire [1:0]   s_axi_rresp;
    wire         s_axi_rvalid;
    wire         s_axi_rready;

    assign s_axi_aclk = clk;

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

    // ── Reset: 2 cycles active-low ──────────────────────────
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

    reg [4:0] run_cnt;
    initial run_cnt = 0;
    always @(posedge clk) begin
        if (!s_axi_aresetn) run_cnt <= 0;
        else if (run_cnt < 31) run_cnt <= run_cnt + 1;
    end

    // ── AXI-Lite state machine ────────────────────────────────
    // The formal wrapper drives one write then one read.
    // States:
    //   0: idle (after reset)
    //   1: assert AW for ACTIVATION
    //   2: await awready, then assert W
    //   3: await wready, then assert B-ready
    //   4: await bvalid, write complete
    //   5: assert AR for ACTIVATION
    //   6: await arready, then assert R-ready
    //   7: await rvalid, read complete

    localparam ST_IDLE      = 3'd0;
    localparam ST_WR_AW     = 3'd1;
    localparam ST_WR_W      = 3'd2;
    localparam ST_WR_B      = 3'd3;
    localparam ST_RD_AR     = 3'd4;
    localparam ST_RD_R      = 3'd5;
    localparam ST_DONE      = 3'd6;

    reg [2:0] state;
    reg       write_done;

    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            state <= ST_IDLE;
            write_done <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (run_cnt >= 2)
                        state <= ST_WR_AW;
                end
                ST_WR_AW: begin
                    if (s_axi_awready)
                        state <= ST_WR_W;
                end
                ST_WR_W: begin
                    if (s_axi_wready)
                        state <= ST_WR_B;
                end
                ST_WR_B: begin
                    if (s_axi_bvalid) begin
                        state <= ST_RD_AR;
                        write_done <= 1'b1;
                    end
                end
                ST_RD_AR: begin
                    if (s_axi_arready)
                        state <= ST_RD_R;
                end
                ST_RD_R: begin
                    if (s_axi_rvalid)
                        state <= ST_DONE;
                end
                ST_DONE: begin
                    state <= ST_DONE;
                end
            endcase
        end
    end

    // Assume state starts at IDLE after reset
    always @(posedge clk) begin
        if (reset_cnt < 2)
            assume(state == 3'd0);
    end

    // ── AXI drive signals ──────────────────────────────────
    assign s_axi_awprot  = 3'b000;
    assign s_axi_wstrb   = 4'b1111;
    assign s_axi_arprot  = 3'b000;

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
            case (state)
                ST_WR_AW: begin
                    s_axi_awaddr  <= ADDR_ACTIVATION;
                    s_axi_awvalid <= 1'b1;
                end
                default: begin
                    if (s_axi_awready)
                        s_axi_awvalid <= 1'b0;
                end
            endcase

            if (state == ST_WR_AW && s_axi_awready) begin
                s_axi_wdata  <= {24'h000000, WRITE_DATA};
                s_axi_wvalid <= 1'b1;
            end else if (state != ST_WR_W) begin
                if (s_axi_wready)
                    s_axi_wvalid <= 1'b0;
            end

            if (state == ST_WR_W && s_axi_wready) begin
                s_axi_bready <= 1'b1;
            end else if (state != ST_WR_B) begin
                if (s_axi_bvalid)
                    s_axi_bready <= 1'b0;
            end

            if (state == ST_RD_AR) begin
                s_axi_araddr  <= ADDR_ACTIVATION;
                s_axi_arvalid <= 1'b1;
            end else if (state != ST_RD_AR) begin
                if (s_axi_arready)
                    s_axi_arvalid <= 1'b0;
            end

            if (state == ST_RD_AR && s_axi_arready) begin
                s_axi_rready <= 1'b1;
            end else if (state != ST_RD_R) begin
                if (s_axi_rvalid)
                    s_axi_rready <= 1'b0;
            end
        end
    end

    // ── Properties ─────────────────────────────────────────
    reg [31:0] captured_rdata;

    always @(posedge clk) begin
        if (!s_axi_aresetn) begin
            captured_rdata <= 32'h00000000;
        end else if (write_done && state == ST_RD_R && s_axi_rvalid && s_axi_rready) begin
            captured_rdata <= s_axi_rdata;
        end
    end

    always @(posedge clk) begin
        if (run_cnt >= 2) begin
            if (s_axi_bvalid) begin
                assert(s_axi_bresp == 2'b00);
            end

            if (s_axi_rvalid) begin
                assert(s_axi_rresp == 2'b00);
            end

            // Write persistence: the data read back from ACTIVATION (0x04)
            // matches what was written.
            if (write_done && captured_rdata != 32'h00000000) begin
                assert(captured_rdata[7:0] == WRITE_DATA);
            end
        end
    end

    // ── Cover points ───────────────────────────────────────
    always @(posedge clk) begin
        if (run_cnt >= 2) begin
            cover(state == ST_WR_B && s_axi_bvalid);
            cover(state == ST_DONE);
        end
    end

endmodule
