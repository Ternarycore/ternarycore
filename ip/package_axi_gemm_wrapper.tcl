# package_axi_gemm_wrapper.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# TernaryCore -- Open-Source FPGA Accelerator for BitNet Inference
#
# Vivado IP packaging script for axi_gemm_wrapper.
# Run in Vivado Tcl console: source package_axi_gemm_wrapper.tcl
#
# Usage (from Arty7/ project directory):
#   vivado -mode batch -source ../ip/package_axi_gemm_wrapper.tcl

set ip_name    "axi_gemm_wrapper"
set ip_vendor  "shepherdscientific.com"
set ip_library "user"
set ip_version "1.0"
set ip_display "AXI4-Lite GEMM Ternary Accelerator"
set ip_desc    "AXI4-Lite slave wrapping ternary_gemm with 2-bit ternary weight encoding. Register map: 0x00=CTRL | 0x04=ACTIVATION | 0x08=WEIGHT_ENC_LO | 0x0C=WEIGHT_ENC_HI | 0x10-0x1C=ACC_OUT[0:3]."

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ..]]

create_project -force ${ip_name}_pkg ${ip_name}_pkg -part xc7a100tcsg324-1

add_files -norecurse [file join $repo_root rtl ternary_gemm.v]
add_files -norecurse [file join $repo_root rtl ternary_dot.v]
add_files -norecurse [file join $repo_root rtl axi_gemm_wrapper.v]

set_property top axi_gemm_wrapper [current_fileset]

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

# Configure AXI4-Lite slave interface on the packaged core
# ipx::package_project already infers the AXI4-Lite bus interface from s_axi_*
# port names. Associate the inferred clock/reset and set FREQ_HZ.
ipx::associate_bus_interfaces -clock s_axi_aclk -reset s_axi_aresetn $core

set clk_bus [ipx::get_bus_interfaces s_axi_aclk -of_objects $core]
if {$clk_bus ne ""} {
    ipx::add_bus_parameter FREQ_HZ $clk_bus
    set_property value 100000000 \
        [ipx::get_bus_parameters FREQ_HZ -of_objects $clk_bus]
}

foreach param {DATA_WIDTH ACC_WIDTH ROWS COLS DEPTH} {
    set_property value_format long [ipx::get_user_parameters $param -of_objects $core]
    set_property value_resolve_type user [ipx::get_user_parameters $param -of_objects $core]
}

set_property value 8  [ipx::get_user_parameters DATA_WIDTH -of_objects $core]
set_property value 32 [ipx::get_user_parameters ACC_WIDTH  -of_objects $core]
set_property value 4  [ipx::get_user_parameters ROWS       -of_objects $core]
set_property value 4  [ipx::get_user_parameters COLS       -of_objects $core]
set_property value 4  [ipx::get_user_parameters DEPTH      -of_objects $core]

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::check_integrity $core
ipx::save_core $core

close_project

puts "axi_gemm_wrapper IP packaged to ip/axi_gemm_wrapper/"
