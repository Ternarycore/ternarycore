# package_axi_gemm_stream.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# Vivado IP packaging for the Tier-2 streaming GEMM (COLS=64 line-rate).
#   vivado -mode batch -source ../ip/package_axi_gemm_stream.tcl

set ip_name    "axi_gemm_stream"
set ip_vendor  "shepherdscientific.com"
set ip_library "user"
set ip_version "1.0"
set ip_display "Ternary Streaming GEMM (Tier-2)"
set ip_desc    "COLS=64 multiplier-free ternary GEMM fed at one element/clock from internal activation RAM + external 128-bit weight port. ~1031 cycles per 1024-element pass; 12.8 GOPS at 100 MHz."

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ..]]

create_project -force ${ip_name}_pkg ${ip_name}_pkg -part xc7a100tcsg324-1

add_files -norecurse [file join $repo_root rtl ternary_mac.v]
add_files -norecurse [file join $repo_root rtl ternary_dot.v]
add_files -norecurse [file join $repo_root rtl ternary_gemm.v]
add_files -norecurse [file join $repo_root rtl axi_gemm_stream.v]
set_property top axi_gemm_stream [current_fileset]

ipx::package_project -root_dir [file join $repo_root ip $ip_name] \
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
