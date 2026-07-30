# package_weight_bram.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference
#
# Vivado IP packaging script for weight_bram.
# Run in Vivado Tcl console: source package_weight_bram.tcl
#
# Usage (from Arty7/ project directory):
#   vivado -mode batch -source ../ip/package_weight_bram.tcl

set ip_name    "weight_bram"
set ip_vendor  "shepherdscientific.com"
set ip_library "user"
set ip_version "1.0"
set ip_display "Ternary Weight BRAM Cache"
set ip_desc    "Dual-port BRAM for packed ternary weights. Write port: AXI4-Lite slave. Read port: combinatorial weight_byte output. 4 ternary weights per byte (2 bits each, 00=zero, 01=+1, 10=-1). Default 256 KB stores 1M params."

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ..]]

create_project -force ${ip_name}_pkg ${ip_name}_pkg -part xc7a100tcsg324-1

add_files -norecurse [file join $repo_root rtl weight_bram.v]

set_property top weight_bram [current_fileset]

ipx::package_project -root_dir [file join $repo_root ip $ip_name] \
    -vendor $ip_vendor \
    -library $ip_library \
    -taxonomy /UserIP \
    -import_files

set core [ipx::current_core]

set_property name               $ip_name    $core
set_property version            $ip_version $core
set_property display_name       $ip_display $core
set_property description        $ip_desc    $core
set_property vendor_display_name "Shepherd Scientific" $core
set_property company_url         "https://github.com/shepherdscientific/ternarycore" $core
set_property supported_families { artix7 Production } $core

# weight_bram uses clk/rst_n (not s_axi_aclk/aresetn).
# Associate clk with the auto-inferred AXI bus interface and set FREQ_HZ.
ipx::associate_bus_interfaces -clock clk -reset rst_n $core

set clk_bus [ipx::get_bus_interfaces clk -of_objects $core]
if {$clk_bus ne ""} {
    ipx::add_bus_parameter FREQ_HZ $clk_bus
    set_property value 100000000 \
        [ipx::get_bus_parameters FREQ_HZ -of_objects $clk_bus]
}

foreach param {ADDR_WIDTH DATA_WIDTH} {
    set_property value_format long [ipx::get_user_parameters $param -of_objects $core]
    set_property value_resolve_type user [ipx::get_user_parameters $param -of_objects $core]
}

set_property value 18 [ipx::get_user_parameters ADDR_WIDTH -of_objects $core]
set_property value 8  [ipx::get_user_parameters DATA_WIDTH -of_objects $core]

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::check_integrity $core
ipx::save_core $core

close_project

puts "weight_bram IP packaged to ip/weight_bram/"
