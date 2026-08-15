# package_rmsnorm_quant.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# Vivado IP packaging for the fabric RMSNorm + int8 quantizer.
#   vivado -mode batch -source ../ip/package_rmsnorm_quant.tcl

set ip_name    "rmsnorm_quant_axi"
set ip_vendor  "shepherdscientific.com"
set ip_library "user"
set ip_version "1.0"
set ip_display "Fused RMSNorm + int8 Quantizer"
set ip_desc    "Streaming RMSNorm sum-of-squares and absmax int8 quantizer, bit-exact with the firmware's nq_core. Three passes at one element per cycle against the soft CPU's 32.05 + 18.02 cycles per element. AXI4 slave: the CDMA writes x and g, reads the int8 result; the CPU pokes n/start and reads back mx, ss and xs."

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ..]]

create_project -force ${ip_name}_pkg ${ip_name}_pkg -part xc7a100tcsg324-1

add_files -norecurse [list \
    [file join $repo_root rtl rmsnorm_quant_axi.v] \
    [file join $repo_root rtl rmsnorm_quant.v]]
set_property top rmsnorm_quant_axi [current_fileset]
update_compile_order -fileset sources_1

ipx::package_project -root_dir [file join $repo_root ip rmsnorm_quant] \
    -vendor $ip_vendor -library $ip_library -taxonomy /UserIP -import_files

set core [ipx::current_core]
set_property name               $ip_name    $core
set_property version            $ip_version $core
set_property display_name       $ip_display $core
set_property description        $ip_desc    $core
set_property vendor_display_name "Shepherd Scientific" $core
set_property company_url "https://github.com/Ternarycore/ternarycore" $core
set_property supported_families { artix7 Production } $core

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::save_core $core
close_project
puts "Packaged: $ip_name"
