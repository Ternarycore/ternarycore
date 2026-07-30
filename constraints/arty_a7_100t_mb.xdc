# arty_a7_100t_mb.xdc
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference

## ── 100 MHz System Clock (E3) ───────────────────────────────────────────────
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sys_clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports sys_clk]

## ── Active-Low Reset (CPU RESET button, C2) ─────────────────────────────────
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]

## ── UART (USB-UART via FTDI FT2232) ─────────────────────────────────────────
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports UART_0_txd]
set_property -dict {PACKAGE_PIN A9  IOSTANDARD LVCMOS33} [get_ports UART_0_rxd]
# Modem control signals not connected on Arty A7 PCB; routed to PMOD JA/JB
# to satisfy DRC. Nothing is electrically connected to these PMOD pins.
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports UART_0_rtsn]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports UART_0_ctsn]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports UART_0_dtrn]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports UART_0_dcdn]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports UART_0_dsrn]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports UART_0_ri]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports UART_0_out1n]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports UART_0_out2n]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports UART_0_baudoutn]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports UART_0_ddis]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports UART_0_txrdyn]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports UART_0_rxrdyn]

## ── LEDs LD0-LD3 ─────────────────────────────────────────────────────────────
set_property -dict {PACKAGE_PIN H5  IOSTANDARD LVCMOS33} [get_ports {gpio_io_o_0[0]}]
set_property -dict {PACKAGE_PIN J5  IOSTANDARD LVCMOS33} [get_ports {gpio_io_o_0[1]}]
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {gpio_io_o_0[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {gpio_io_o_0[3]}]

## ── Bitstream config ─────────────────────────────────────────────────────────
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33  [current_design]
set_property CONFIG_VOLTAGE 3.3              [current_design]
set_property CFGBVS VCCO                    [current_design]
