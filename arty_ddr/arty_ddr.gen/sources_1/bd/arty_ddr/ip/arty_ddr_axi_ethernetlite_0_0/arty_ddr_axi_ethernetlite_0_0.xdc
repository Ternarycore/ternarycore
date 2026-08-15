# file: arty_ddr_axi_ethernetlite_0_0.xdc
# (c) Copyright 2009 - 2011 Advanced Micro Devices, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Advanced Micro Devices, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Advanced Micro Devices, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND Advanced Micro Devices HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Advanced Micro Devices shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Advanced Micro Devices had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Advanced Micro Devices products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Advanced Micro Devices products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.

create_clock -period 40 [get_ports phy_tx_clk] 
create_clock -period 40 [get_ports phy_rx_clk]

## INFO: AXI-Lite to&fro MMAP clock domain Register & Misc crossings in axi_ethernetlite

##set_false_path -to [get_cells -hierarchical -filter {NAME =~*TX_FF_I}]
##set_false_path -to [get_cells -hierarchical -filter {NAME =~*TEN_FF}]
set_false_path -through [get_cells -hierarchical -filter {NAME =~*loopback_en_reg}]

#set_property IOB true [get_cells -hierarchical -filter {NAME =~*RX_FF_I}]
#set_property IOB true [get_cells -hierarchical -filter {NAME =~*TX_FF_I}]
#set_property IOB true [get_cells -hierarchical -filter {NAME =~*DVD_FF}]
#set_property IOB true [get_cells -hierarchical -filter {NAME =~*RER_FF}]
#set_property IOB true [get_cells -hierarchical -filter {NAME =~*TEN_FF}]


################################ Waivers #################################
create_waiver -internal -scope -type CDC -id {CDC-10} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */TX/axi_phy_tx_en_i_p_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-12} -user "axi_ethernetlite" -desc "Waiving the CDC-12 As all the reported failures are in Loopback mode where tx_clk and rx_clk are same but tool is treating them as different clocks" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */TX/axi_phy_tx_en_i_p_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-10} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */INST_TX_STATE_MACHINE/STATE*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-13} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */loopback_en_reg*}] -filter {name =~ *C}] -to [list [get_pins -of [get_cells -hier -filter {name =~ */LOOPBACK_GEN.*.CLOCK_MUX*}] -filter {name =~ *CE*}] [get_pins -of [get_cells -hier -filter {name =~ */gen_wr_a.gen_word_narrow.mem_reg_0_15_0_5/RAMA*}] -filter {name =~ *I}]]

create_waiver -internal -scope -type CDC -id {CDC-10} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */loopback_en_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-12} -user "axi_ethernetlite" -desc "Waiving the CDC-12 As all the reported failures are in Loopback mode where tx_clk and rx_clk are same but tool is treating them as diffrent clocks" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */loopback_en_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-10} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */TX/INST_TX_STATE_MACHINE/phytx_en_reg_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-10} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */TX/tx3_generate.INST_JAMTXNIBCNT/PERBIT_GEN[*].FF_RST*_GEN.*_i1*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

create_waiver -internal -scope -type CDC -id {CDC-10} -user "axi_ethernetlite" -desc "This is sustaining IP so there is no core level change hence waived" -tags "11999" -from [get_pins -of [get_cells -hier -filter {name =~ */TX/INST_TX_STATE_MACHINE/PRE_SFD_count/zero_i_reg*}] -filter {name =~ *C}] -to [get_pins -of [get_cells -hier -filter {name =~ *CDC_*/syncstages_ff_reg*}] -filter {name =~ *D}]

