-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Mon Aug  3 14:22:31 2026
-- Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_clk_eth_0/arty_ddr_clk_eth_0_stub.vhdl
-- Design      : arty_ddr_clk_eth_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arty_ddr_clk_eth_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of arty_ddr_clk_eth_0 : entity is "arty_ddr_clk_eth_0,clk_wiz_v6_0_17_0_0,{component_name=arty_ddr_clk_eth_0,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=1,clkin1_period=12.308,clkin2_period=10.0,use_power_down=false,use_reset=false,use_locked=false,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}";
end arty_ddr_clk_eth_0;

architecture stub of arty_ddr_clk_eth_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
