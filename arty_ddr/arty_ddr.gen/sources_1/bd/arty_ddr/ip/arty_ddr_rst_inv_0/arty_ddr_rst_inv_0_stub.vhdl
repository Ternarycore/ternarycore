-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Mon Aug  3 14:20:56 2026
-- Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_rst_inv_0/arty_ddr_rst_inv_0_stub.vhdl
-- Design      : arty_ddr_rst_inv_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arty_ddr_rst_inv_0 is
  Port ( 
    Op1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    Res : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of arty_ddr_rst_inv_0 : entity is "arty_ddr_rst_inv_0,util_vector_logic_v2_0_5_util_vector_logic,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of arty_ddr_rst_inv_0 : entity is "arty_ddr_rst_inv_0,util_vector_logic_v2_0_5_util_vector_logic,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=util_vector_logic,x_ipVersion=2.0,x_ipCoreRevision=5,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_OPERATION=not,C_SIZE=1}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of arty_ddr_rst_inv_0 : entity is "yes";
end arty_ddr_rst_inv_0;

architecture stub of arty_ddr_rst_inv_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "Op1[0:0],Res[0:0]";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "util_vector_logic_v2_0_5_util_vector_logic,Vivado 2025.2";
begin
end;
