# package_weight_bram128.tcl
# SPDX-License-Identifier: CERN-OHL-S-2.0
# Copyright (C) 2026 Ifedayo Oladapo
# Vivado IP packaging for weight_bram128 (Tier-2: 128-bit read port).
#   vivado -mode batch -source ../ip/package_weight_bram128.tcl

set ip_name    "weight_bram128"
set ip_vendor  "shepherdscientific.com"
set ip_library "user"
set ip_version "1.0"
set ip_display "Ternary Weight BRAM (128b read port)"
set ip_desc    "Dual-port BRAM for packed ternary weights. Write: AXI4 with INCR bursts. Read: 128-bit word port (16 packed bytes = 64 ternary columns/cycle) for the Tier-2 line-rate feeder. 256 KB."

set script_dir [file dirname [file normalize [info script]]]
set repo_root  [file normalize [file join $script_dir ..]]

create_project -force ${ip_name}_pkg ${ip_name}_pkg -part xc7a100tcsg324-1

add_files -norecurse [file join $repo_root rtl weight_bram128.v]
set_property top weight_bram128 [current_fileset]

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
