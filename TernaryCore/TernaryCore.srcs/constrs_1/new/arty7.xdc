## Clock Signal (100 MHz System Clock)
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk_100M }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk_100M }];

## Reset Button (Red CPU RESET Button - Active Low)
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { sys_rst_n }];

## Button 0 (To Trigger Test Run)
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn0 }];

## LEDs
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led_pass }]; # LD4
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led_fail }]; # LD5