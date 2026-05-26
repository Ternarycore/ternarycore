## Clock Signal (100 MHz System Clock)
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk_100M]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100M]

## Reset Button (Red CPU RESET Button - Active Low)
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]

## Button 0 (To Trigger Test Run)
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports btn0]

## LEDs
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports led_pass]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports led_fail]

## ── ILA Debug Core (81-bit probes, 4096 samples) ───────────────────────

# ── probe0: mac_out[31:0] — the full 32-bit MAC result (auto-created) ──


# ── probe1: reg_acc_in[31:0] — the 32-bit accumulator input ────────────


# ── probe2: reg_activation[7:0] — full 8-bit signed activation ─────────


# ── probe3: reg_weight[1:0] — full 2-bit weight encoding ───────────────

# ── probe4: mac_valid_out — MAC output valid strobe ────────────────────

# ── probe5: valid_in — input data valid ────────────────────────────────

# ── probe6: sys_rst_n_sync — synchronized active-low reset ─────────────

# ── probe7: state[1:0] — FSM state (IDLE=00, RUN=01, CHECK=10) ────────

# ── probe8: btn0_pressed — debounced rising-edge pulse ─────────────────

# ── probe9: btn0_debounced — raw debounced button state ────────────────

## ── JTAG Hub ───────────────────────────────────────────────────────────

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_100M_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {reg_acc_in[0]} {reg_acc_in[1]} {reg_acc_in[2]} {reg_acc_in[3]} {reg_acc_in[4]} {reg_acc_in[5]} {reg_acc_in[6]} {reg_acc_in[7]} {reg_acc_in[8]} {reg_acc_in[9]} {reg_acc_in[10]} {reg_acc_in[11]} {reg_acc_in[12]} {reg_acc_in[13]} {reg_acc_in[14]} {reg_acc_in[15]} {reg_acc_in[16]} {reg_acc_in[17]} {reg_acc_in[18]} {reg_acc_in[19]} {reg_acc_in[20]} {reg_acc_in[21]} {reg_acc_in[22]} {reg_acc_in[23]} {reg_acc_in[24]} {reg_acc_in[25]} {reg_acc_in[26]} {reg_acc_in[27]} {reg_acc_in[28]} {reg_acc_in[29]} {reg_acc_in[30]} {reg_acc_in[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {mac_out[0]} {mac_out[1]} {mac_out[2]} {mac_out[3]} {mac_out[4]} {mac_out[5]} {mac_out[6]} {mac_out[7]} {mac_out[8]} {mac_out[9]} {mac_out[10]} {mac_out[11]} {mac_out[12]} {mac_out[13]} {mac_out[14]} {mac_out[15]} {mac_out[16]} {mac_out[17]} {mac_out[18]} {mac_out[19]} {mac_out[20]} {mac_out[21]} {mac_out[22]} {mac_out[23]} {mac_out[24]} {mac_out[25]} {mac_out[26]} {mac_out[27]} {mac_out[28]} {mac_out[29]} {mac_out[30]} {mac_out[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {state[0]} {state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {reg_weight[0]} {reg_weight[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {reg_activation[0]} {reg_activation[1]} {reg_activation[2]} {reg_activation[3]} {reg_activation[4]} {reg_activation[5]} {reg_activation[6]} {reg_activation[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list btn0_debounced]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list btn0_pressed]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list led_fail_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list led_pass_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list mac_valid_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list sys_rst_n_sync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list valid_in]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_100M_IBUF_BUFG]
