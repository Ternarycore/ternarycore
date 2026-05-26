# arty_a7_100t_mb.xdc
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference
#
# Constraints for the Arty A7-100T MicroBlaze + GEMM system.
# Matches the block design created by create_bd.tcl.

## ── 100 MHz System Clock (Pin E3) ──────────────────────────────────────────
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sys_clock]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports sys_clock]

## ── System Reset (Red CPU RESET Button - Active Low, Pin C2) ───────────────
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports reset]

## ── UART (USB-UART bridge on Arty A7) ──────────────────────────────────────
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports uart_txd]
set_property -dict {PACKAGE_PIN A9  IOSTANDARD LVCMOS33} [get_ports uart_rxd]

## ── LEDs (LD0-LD3) ─────────────────────────────────────────────────────────
set_property -dict {PACKAGE_PIN H5  IOSTANDARD LVCMOS33} [get_ports {gpio_leds_tri_o[0]}]
set_property -dict {PACKAGE_PIN J5  IOSTANDARD LVCMOS33} [get_ports {gpio_leds_tri_o[1]}]
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {gpio_leds_tri_o[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {gpio_leds_tri_o[3]}]

## ── Configuration Constraints ──────────────────────────────────────────────
set_property BITSTREAM.GENERAL.COMPRESS TRUE  [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33    [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
