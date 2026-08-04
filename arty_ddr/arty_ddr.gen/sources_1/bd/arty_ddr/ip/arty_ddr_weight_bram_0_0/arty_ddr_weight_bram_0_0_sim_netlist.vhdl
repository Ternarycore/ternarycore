-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Tue Aug  4 23:10:33 2026
-- Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_weight_bram_0_0/arty_ddr_weight_bram_0_0_sim_netlist.vhdl
-- Design      : arty_ddr_weight_bram_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity arty_ddr_weight_bram_0_0_weight_bram128 is
  port (
    s_axi_wready : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    w_word : out STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid_reg_0 : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_bvalid : out STD_LOGIC;
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    clk : in STD_LOGIC;
    w_word_addr : in STD_LOGIC_VECTOR ( 13 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_wlast : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 17 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of arty_ddr_weight_bram_0_0_weight_bram128 : entity is "weight_bram128";
end arty_ddr_weight_bram_0_0_weight_bram128;

architecture STRUCTURE of arty_ddr_weight_bram_0_0_weight_bram128 is
  signal A : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \FSM_onehot_wstate[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_wstate_reg_n_0_[2]\ : STD_LOGIC;
  signal bram_reg_0_3_i_1_n_0 : STD_LOGIC;
  signal bram_reg_12_1_i_1_n_0 : STD_LOGIC;
  signal bram_reg_14_3_i_1_n_0 : STD_LOGIC;
  signal bram_reg_15_3_i_1_n_0 : STD_LOGIC;
  signal bram_reg_2_1_i_1_n_0 : STD_LOGIC;
  signal bram_reg_4_3_i_1_n_0 : STD_LOGIC;
  signal bram_reg_7_1_i_1_n_0 : STD_LOGIC;
  signal bram_reg_9_3_i_1_n_0 : STD_LOGIC;
  signal \i__carry__0_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_5_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_6_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_7_n_0\ : STD_LOGIC;
  signal \i__carry_i_10_n_0\ : STD_LOGIC;
  signal \i__carry_i_11_n_0\ : STD_LOGIC;
  signal \i__carry_i_5_n_0\ : STD_LOGIC;
  signal \i__carry_i_6_n_0\ : STD_LOGIC;
  signal \i__carry_i_7_n_0\ : STD_LOGIC;
  signal \i__carry_i_8_n_0\ : STD_LOGIC;
  signal \i__carry_i_9_n_0\ : STD_LOGIC;
  signal in5 : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \p_0_out_inferred__0/i__carry__0_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry__0_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry__0_n_5\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry__0_n_6\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry__0_n_7\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_0\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_1\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_4\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_5\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_6\ : STD_LOGIC;
  signal \p_0_out_inferred__0/i__carry_n_7\ : STD_LOGIC;
  signal p_10_in : STD_LOGIC;
  signal p_11_in : STD_LOGIC;
  signal p_12_in : STD_LOGIC;
  signal p_13_in : STD_LOGIC;
  signal p_14_in : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal p_2_in : STD_LOGIC;
  signal p_3_in : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal p_5_in : STD_LOGIC;
  signal p_6_in : STD_LOGIC;
  signal p_7_in : STD_LOGIC;
  signal p_8_in : STD_LOGIC;
  signal p_9_in : STD_LOGIC;
  signal \rbeats[0]_i_1_n_0\ : STD_LOGIC;
  signal \rbeats[0]_i_2_n_0\ : STD_LOGIC;
  signal \rbeats[7]_i_1_n_0\ : STD_LOGIC;
  signal rbeats_reg : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \rid_r[3]_i_2_n_0\ : STD_LOGIC;
  signal s_axi_arready_INST_0_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  signal \^s_axi_bvalid\ : STD_LOGIC;
  signal s_axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal s_axi_bvalid_i_2_n_0 : STD_LOGIC;
  signal s_axi_rvalid0 : STD_LOGIC;
  signal s_axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal s_axi_rvalid_i_2_n_0 : STD_LOGIC;
  signal \^s_axi_rvalid_reg_0\ : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal waddr : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \waddr[0]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[10]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[10]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[11]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[11]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[12]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[12]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[13]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[13]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[14]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[14]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[15]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[15]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[16]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[16]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[17]_i_2_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[17]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[1]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[3]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[3]_i_3_n_0\ : STD_LOGIC;
  signal \waddr[3]_i_4_n_0\ : STD_LOGIC;
  signal \waddr[3]_i_5_n_0\ : STD_LOGIC;
  signal \waddr[3]_i_6_n_0\ : STD_LOGIC;
  signal \waddr[4]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[4]_rep__0_i_1_n_0\ : STD_LOGIC;
  signal \waddr[4]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[5]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[5]_rep__0_i_1_n_0\ : STD_LOGIC;
  signal \waddr[5]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[6]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[6]_rep__0_i_1_n_0\ : STD_LOGIC;
  signal \waddr[6]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[7]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[7]_i_3_n_0\ : STD_LOGIC;
  signal \waddr[7]_i_4_n_0\ : STD_LOGIC;
  signal \waddr[7]_i_5_n_0\ : STD_LOGIC;
  signal \waddr[7]_i_6_n_0\ : STD_LOGIC;
  signal \waddr[7]_rep__0_i_1_n_0\ : STD_LOGIC;
  signal \waddr[7]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep__0_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep__1_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep__2_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep__3_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep__4_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep__5_i_1_n_0\ : STD_LOGIC;
  signal \waddr[8]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr[9]_i_1_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1__0_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1__1_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1__2_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1__3_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1__4_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1__5_n_0\ : STD_LOGIC;
  signal \waddr[9]_rep_i_1_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[10]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_i_2_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_i_2_n_1\ : STD_LOGIC;
  signal \waddr_reg[11]_i_2_n_2\ : STD_LOGIC;
  signal \waddr_reg[11]_i_2_n_3\ : STD_LOGIC;
  signal \waddr_reg[11]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[11]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[12]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[13]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[14]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_i_2_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_i_2_n_1\ : STD_LOGIC;
  signal \waddr_reg[15]_i_2_n_2\ : STD_LOGIC;
  signal \waddr_reg[15]_i_2_n_3\ : STD_LOGIC;
  signal \waddr_reg[15]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[15]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[16]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_i_3_n_3\ : STD_LOGIC;
  signal \waddr_reg[17]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[17]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[3]_i_2_n_0\ : STD_LOGIC;
  signal \waddr_reg[3]_i_2_n_1\ : STD_LOGIC;
  signal \waddr_reg[3]_i_2_n_2\ : STD_LOGIC;
  signal \waddr_reg[3]_i_2_n_3\ : STD_LOGIC;
  signal \waddr_reg[4]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[4]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[5]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[5]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[6]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[6]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[7]_i_2_n_0\ : STD_LOGIC;
  signal \waddr_reg[7]_i_2_n_1\ : STD_LOGIC;
  signal \waddr_reg[7]_i_2_n_2\ : STD_LOGIC;
  signal \waddr_reg[7]_i_2_n_3\ : STD_LOGIC;
  signal \waddr_reg[7]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[7]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[8]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep__0_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep__1_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep__2_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep__3_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep__4_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep__5_n_0\ : STD_LOGIC;
  signal \waddr_reg[9]_rep_n_0\ : STD_LOGIC;
  signal \waddr_reg_n_0_[0]\ : STD_LOGIC;
  signal \waddr_reg_n_0_[1]\ : STD_LOGIC;
  signal wburst : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal wid : STD_LOGIC_VECTOR ( 0 to 0 );
  signal wr_word : STD_LOGIC_VECTOR ( 13 downto 0 );
  signal wsize : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal wstate : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \wstate[0]_i_1_n_0\ : STD_LOGIC;
  signal \wstate[1]_i_1_n_0\ : STD_LOGIC;
  signal NLW_bram_reg_0_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_0_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_0_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_0_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_0_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_0_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_0_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_0_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_0_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_0_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_0_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_0_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_0_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_0_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_0_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_0_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_0_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_0_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_10_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_10_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_10_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_10_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_10_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_10_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_10_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_10_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_10_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_10_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_10_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_10_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_10_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_10_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_10_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_10_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_10_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_10_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_11_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_11_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_11_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_11_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_11_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_11_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_11_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_11_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_11_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_11_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_11_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_11_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_11_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_11_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_11_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_11_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_11_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_11_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_12_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_12_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_12_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_12_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_12_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_12_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_12_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_12_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_12_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_12_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_12_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_12_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_12_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_12_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_12_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_12_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_12_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_12_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_13_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_13_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_13_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_13_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_13_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_13_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_13_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_13_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_13_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_13_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_13_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_13_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_13_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_13_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_13_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_13_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_13_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_13_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_14_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_14_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_14_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_14_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_14_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_14_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_14_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_14_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_14_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_14_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_14_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_14_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_14_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_14_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_14_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_14_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_14_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_14_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_15_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_15_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_15_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_15_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_15_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_15_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_15_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_15_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_15_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_15_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_15_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_15_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_15_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_15_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_15_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_15_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_15_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_15_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_1_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_1_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_1_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_1_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_1_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_1_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_1_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_1_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_1_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_1_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_1_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_1_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_1_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_1_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_1_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_1_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_1_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_1_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_2_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_2_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_2_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_2_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_2_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_2_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_2_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_2_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_2_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_2_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_2_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_2_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_2_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_2_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_2_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_2_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_2_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_2_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_3_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_3_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_3_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_3_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_3_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_3_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_3_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_3_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_3_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_3_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_3_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_3_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_3_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_3_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_3_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_3_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_3_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_3_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_4_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_4_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_4_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_4_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_4_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_4_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_4_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_4_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_4_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_4_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_4_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_4_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_4_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_4_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_4_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_4_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_4_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_4_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_5_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_5_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_5_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_5_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_5_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_5_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_5_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_5_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_5_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_5_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_5_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_5_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_5_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_5_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_5_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_5_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_5_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_5_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_6_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_6_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_6_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_6_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_6_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_6_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_6_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_6_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_6_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_6_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_6_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_6_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_6_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_6_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_6_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_6_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_6_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_6_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_7_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_7_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_7_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_7_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_7_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_7_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_7_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_7_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_7_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_7_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_7_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_7_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_7_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_7_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_7_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_7_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_7_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_7_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_8_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_8_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_8_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_8_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_8_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_8_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_8_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_8_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_8_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_8_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_8_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_8_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_8_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_8_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_8_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_8_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_8_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_8_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_9_0_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_0_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_0_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_0_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_0_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_0_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_0_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_9_0_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_9_0_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_0_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_0_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_9_0_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_9_1_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_1_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_1_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_1_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_1_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_1_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_1_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_9_1_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_9_1_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_1_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_1_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_9_1_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_9_2_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_2_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_2_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_2_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_2_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_2_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_2_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_9_2_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_9_2_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_2_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_2_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_9_2_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal NLW_bram_reg_9_3_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_3_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_3_DBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_3_INJECTDBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_3_INJECTSBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_3_SBITERR_UNCONNECTED : STD_LOGIC;
  signal NLW_bram_reg_9_3_DOADO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_bram_reg_9_3_DOBDO_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal NLW_bram_reg_9_3_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_3_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bram_reg_9_3_ECCPARITY_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bram_reg_9_3_RDADDRECC_UNCONNECTED : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \NLW_p_0_out_inferred__0/i__carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_p_0_out_inferred__0/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_waddr_reg[17]_i_3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_waddr_reg[17]_i_3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[0]\ : label is "W_IDLE:001,W_DATA:010,W_RESP:100,";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[1]\ : label is "W_IDLE:001,W_DATA:010,W_RESP:100,";
  attribute FSM_ENCODED_STATES of \FSM_onehot_wstate_reg[2]\ : label is "W_IDLE:001,W_DATA:010,W_RESP:100,";
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_0_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_0_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of bram_reg_0_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS : integer;
  attribute RTL_RAM_BITS of bram_reg_0_0 : label is 2097152;
  attribute RTL_RAM_NAME : string;
  attribute RTL_RAM_NAME of bram_reg_0_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE : string;
  attribute RTL_RAM_STYLE of bram_reg_0_0 : label is "block";
  attribute RTL_RAM_TYPE : string;
  attribute RTL_RAM_TYPE of bram_reg_0_0 : label is "RAM_SDP";
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of bram_reg_0_0 : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of bram_reg_0_0 : label is 16383;
  attribute ram_offset : integer;
  attribute ram_offset of bram_reg_0_0 : label is 0;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of bram_reg_0_0 : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of bram_reg_0_0 : label is 1;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_0_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_0_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_0_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_0_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_0_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_0_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_0_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_0_1 : label is 0;
  attribute ram_addr_end of bram_reg_0_1 : label is 16383;
  attribute ram_offset of bram_reg_0_1 : label is 0;
  attribute ram_slice_begin of bram_reg_0_1 : label is 2;
  attribute ram_slice_end of bram_reg_0_1 : label is 3;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_0_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_0_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_0_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_0_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_0_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_0_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_0_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_0_2 : label is 0;
  attribute ram_addr_end of bram_reg_0_2 : label is 16383;
  attribute ram_offset of bram_reg_0_2 : label is 0;
  attribute ram_slice_begin of bram_reg_0_2 : label is 4;
  attribute ram_slice_end of bram_reg_0_2 : label is 5;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_0_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_0_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_0_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_0_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_0_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_0_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_0_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_0_3 : label is 0;
  attribute ram_addr_end of bram_reg_0_3 : label is 16383;
  attribute ram_offset of bram_reg_0_3 : label is 0;
  attribute ram_slice_begin of bram_reg_0_3 : label is 6;
  attribute ram_slice_end of bram_reg_0_3 : label is 7;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_10_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_10_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_10_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_10_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_10_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_10_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_10_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_10_0 : label is 0;
  attribute ram_addr_end of bram_reg_10_0 : label is 16383;
  attribute ram_offset of bram_reg_10_0 : label is 0;
  attribute ram_slice_begin of bram_reg_10_0 : label is 80;
  attribute ram_slice_end of bram_reg_10_0 : label is 81;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_10_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_10_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_10_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_10_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_10_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_10_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_10_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_10_1 : label is 0;
  attribute ram_addr_end of bram_reg_10_1 : label is 16383;
  attribute ram_offset of bram_reg_10_1 : label is 0;
  attribute ram_slice_begin of bram_reg_10_1 : label is 82;
  attribute ram_slice_end of bram_reg_10_1 : label is 83;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_10_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_10_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_10_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_10_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_10_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_10_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_10_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_10_2 : label is 0;
  attribute ram_addr_end of bram_reg_10_2 : label is 16383;
  attribute ram_offset of bram_reg_10_2 : label is 0;
  attribute ram_slice_begin of bram_reg_10_2 : label is 84;
  attribute ram_slice_end of bram_reg_10_2 : label is 85;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_10_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_10_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_10_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_10_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_10_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_10_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_10_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_10_3 : label is 0;
  attribute ram_addr_end of bram_reg_10_3 : label is 16383;
  attribute ram_offset of bram_reg_10_3 : label is 0;
  attribute ram_slice_begin of bram_reg_10_3 : label is 86;
  attribute ram_slice_end of bram_reg_10_3 : label is 87;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_11_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_11_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_11_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_11_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_11_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_11_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_11_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_11_0 : label is 0;
  attribute ram_addr_end of bram_reg_11_0 : label is 16383;
  attribute ram_offset of bram_reg_11_0 : label is 0;
  attribute ram_slice_begin of bram_reg_11_0 : label is 88;
  attribute ram_slice_end of bram_reg_11_0 : label is 89;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_11_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_11_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_11_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_11_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_11_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_11_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_11_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_11_1 : label is 0;
  attribute ram_addr_end of bram_reg_11_1 : label is 16383;
  attribute ram_offset of bram_reg_11_1 : label is 0;
  attribute ram_slice_begin of bram_reg_11_1 : label is 90;
  attribute ram_slice_end of bram_reg_11_1 : label is 91;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_11_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_11_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_11_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_11_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_11_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_11_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_11_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_11_2 : label is 0;
  attribute ram_addr_end of bram_reg_11_2 : label is 16383;
  attribute ram_offset of bram_reg_11_2 : label is 0;
  attribute ram_slice_begin of bram_reg_11_2 : label is 92;
  attribute ram_slice_end of bram_reg_11_2 : label is 93;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_11_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_11_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_11_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_11_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_11_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_11_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_11_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_11_3 : label is 0;
  attribute ram_addr_end of bram_reg_11_3 : label is 16383;
  attribute ram_offset of bram_reg_11_3 : label is 0;
  attribute ram_slice_begin of bram_reg_11_3 : label is 94;
  attribute ram_slice_end of bram_reg_11_3 : label is 95;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_12_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_12_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_12_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_12_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_12_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_12_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_12_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_12_0 : label is 0;
  attribute ram_addr_end of bram_reg_12_0 : label is 16383;
  attribute ram_offset of bram_reg_12_0 : label is 0;
  attribute ram_slice_begin of bram_reg_12_0 : label is 96;
  attribute ram_slice_end of bram_reg_12_0 : label is 97;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_12_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_12_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_12_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_12_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_12_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_12_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_12_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_12_1 : label is 0;
  attribute ram_addr_end of bram_reg_12_1 : label is 16383;
  attribute ram_offset of bram_reg_12_1 : label is 0;
  attribute ram_slice_begin of bram_reg_12_1 : label is 98;
  attribute ram_slice_end of bram_reg_12_1 : label is 99;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_12_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_12_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_12_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_12_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_12_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_12_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_12_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_12_2 : label is 0;
  attribute ram_addr_end of bram_reg_12_2 : label is 16383;
  attribute ram_offset of bram_reg_12_2 : label is 0;
  attribute ram_slice_begin of bram_reg_12_2 : label is 100;
  attribute ram_slice_end of bram_reg_12_2 : label is 101;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_12_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_12_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_12_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_12_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_12_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_12_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_12_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_12_3 : label is 0;
  attribute ram_addr_end of bram_reg_12_3 : label is 16383;
  attribute ram_offset of bram_reg_12_3 : label is 0;
  attribute ram_slice_begin of bram_reg_12_3 : label is 102;
  attribute ram_slice_end of bram_reg_12_3 : label is 103;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_13_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_13_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_13_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_13_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_13_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_13_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_13_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_13_0 : label is 0;
  attribute ram_addr_end of bram_reg_13_0 : label is 16383;
  attribute ram_offset of bram_reg_13_0 : label is 0;
  attribute ram_slice_begin of bram_reg_13_0 : label is 104;
  attribute ram_slice_end of bram_reg_13_0 : label is 105;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_13_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_13_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_13_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_13_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_13_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_13_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_13_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_13_1 : label is 0;
  attribute ram_addr_end of bram_reg_13_1 : label is 16383;
  attribute ram_offset of bram_reg_13_1 : label is 0;
  attribute ram_slice_begin of bram_reg_13_1 : label is 106;
  attribute ram_slice_end of bram_reg_13_1 : label is 107;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_13_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_13_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_13_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_13_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_13_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_13_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_13_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_13_2 : label is 0;
  attribute ram_addr_end of bram_reg_13_2 : label is 16383;
  attribute ram_offset of bram_reg_13_2 : label is 0;
  attribute ram_slice_begin of bram_reg_13_2 : label is 108;
  attribute ram_slice_end of bram_reg_13_2 : label is 109;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_13_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_13_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_13_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_13_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_13_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_13_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_13_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_13_3 : label is 0;
  attribute ram_addr_end of bram_reg_13_3 : label is 16383;
  attribute ram_offset of bram_reg_13_3 : label is 0;
  attribute ram_slice_begin of bram_reg_13_3 : label is 110;
  attribute ram_slice_end of bram_reg_13_3 : label is 111;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_14_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_14_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_14_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_14_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_14_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_14_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_14_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_14_0 : label is 0;
  attribute ram_addr_end of bram_reg_14_0 : label is 16383;
  attribute ram_offset of bram_reg_14_0 : label is 0;
  attribute ram_slice_begin of bram_reg_14_0 : label is 112;
  attribute ram_slice_end of bram_reg_14_0 : label is 113;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_14_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_14_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_14_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_14_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_14_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_14_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_14_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_14_1 : label is 0;
  attribute ram_addr_end of bram_reg_14_1 : label is 16383;
  attribute ram_offset of bram_reg_14_1 : label is 0;
  attribute ram_slice_begin of bram_reg_14_1 : label is 114;
  attribute ram_slice_end of bram_reg_14_1 : label is 115;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_14_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_14_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_14_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_14_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_14_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_14_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_14_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_14_2 : label is 0;
  attribute ram_addr_end of bram_reg_14_2 : label is 16383;
  attribute ram_offset of bram_reg_14_2 : label is 0;
  attribute ram_slice_begin of bram_reg_14_2 : label is 116;
  attribute ram_slice_end of bram_reg_14_2 : label is 117;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_14_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_14_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_14_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_14_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_14_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_14_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_14_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_14_3 : label is 0;
  attribute ram_addr_end of bram_reg_14_3 : label is 16383;
  attribute ram_offset of bram_reg_14_3 : label is 0;
  attribute ram_slice_begin of bram_reg_14_3 : label is 118;
  attribute ram_slice_end of bram_reg_14_3 : label is 119;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_15_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_15_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_15_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_15_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_15_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_15_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_15_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_15_0 : label is 0;
  attribute ram_addr_end of bram_reg_15_0 : label is 16383;
  attribute ram_offset of bram_reg_15_0 : label is 0;
  attribute ram_slice_begin of bram_reg_15_0 : label is 120;
  attribute ram_slice_end of bram_reg_15_0 : label is 121;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_15_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_15_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_15_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_15_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_15_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_15_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_15_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_15_1 : label is 0;
  attribute ram_addr_end of bram_reg_15_1 : label is 16383;
  attribute ram_offset of bram_reg_15_1 : label is 0;
  attribute ram_slice_begin of bram_reg_15_1 : label is 122;
  attribute ram_slice_end of bram_reg_15_1 : label is 123;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_15_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_15_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_15_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_15_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_15_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_15_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_15_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_15_2 : label is 0;
  attribute ram_addr_end of bram_reg_15_2 : label is 16383;
  attribute ram_offset of bram_reg_15_2 : label is 0;
  attribute ram_slice_begin of bram_reg_15_2 : label is 124;
  attribute ram_slice_end of bram_reg_15_2 : label is 125;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_15_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_15_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_15_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_15_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_15_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_15_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_15_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_15_3 : label is 0;
  attribute ram_addr_end of bram_reg_15_3 : label is 16383;
  attribute ram_offset of bram_reg_15_3 : label is 0;
  attribute ram_slice_begin of bram_reg_15_3 : label is 126;
  attribute ram_slice_end of bram_reg_15_3 : label is 127;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_1_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_1_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_1_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_1_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_1_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_1_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_1_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_1_0 : label is 0;
  attribute ram_addr_end of bram_reg_1_0 : label is 16383;
  attribute ram_offset of bram_reg_1_0 : label is 0;
  attribute ram_slice_begin of bram_reg_1_0 : label is 8;
  attribute ram_slice_end of bram_reg_1_0 : label is 9;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_1_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_1_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_1_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_1_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_1_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_1_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_1_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_1_1 : label is 0;
  attribute ram_addr_end of bram_reg_1_1 : label is 16383;
  attribute ram_offset of bram_reg_1_1 : label is 0;
  attribute ram_slice_begin of bram_reg_1_1 : label is 10;
  attribute ram_slice_end of bram_reg_1_1 : label is 11;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_1_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_1_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_1_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_1_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_1_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_1_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_1_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_1_2 : label is 0;
  attribute ram_addr_end of bram_reg_1_2 : label is 16383;
  attribute ram_offset of bram_reg_1_2 : label is 0;
  attribute ram_slice_begin of bram_reg_1_2 : label is 12;
  attribute ram_slice_end of bram_reg_1_2 : label is 13;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_1_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_1_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_1_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_1_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_1_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_1_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_1_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_1_3 : label is 0;
  attribute ram_addr_end of bram_reg_1_3 : label is 16383;
  attribute ram_offset of bram_reg_1_3 : label is 0;
  attribute ram_slice_begin of bram_reg_1_3 : label is 14;
  attribute ram_slice_end of bram_reg_1_3 : label is 15;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_2_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_2_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_2_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_2_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_2_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_2_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_2_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_2_0 : label is 0;
  attribute ram_addr_end of bram_reg_2_0 : label is 16383;
  attribute ram_offset of bram_reg_2_0 : label is 0;
  attribute ram_slice_begin of bram_reg_2_0 : label is 16;
  attribute ram_slice_end of bram_reg_2_0 : label is 17;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_2_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_2_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_2_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_2_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_2_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_2_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_2_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_2_1 : label is 0;
  attribute ram_addr_end of bram_reg_2_1 : label is 16383;
  attribute ram_offset of bram_reg_2_1 : label is 0;
  attribute ram_slice_begin of bram_reg_2_1 : label is 18;
  attribute ram_slice_end of bram_reg_2_1 : label is 19;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_2_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_2_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_2_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_2_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_2_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_2_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_2_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_2_2 : label is 0;
  attribute ram_addr_end of bram_reg_2_2 : label is 16383;
  attribute ram_offset of bram_reg_2_2 : label is 0;
  attribute ram_slice_begin of bram_reg_2_2 : label is 20;
  attribute ram_slice_end of bram_reg_2_2 : label is 21;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_2_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_2_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_2_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_2_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_2_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_2_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_2_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_2_3 : label is 0;
  attribute ram_addr_end of bram_reg_2_3 : label is 16383;
  attribute ram_offset of bram_reg_2_3 : label is 0;
  attribute ram_slice_begin of bram_reg_2_3 : label is 22;
  attribute ram_slice_end of bram_reg_2_3 : label is 23;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_3_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_3_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_3_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_3_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_3_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_3_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_3_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_3_0 : label is 0;
  attribute ram_addr_end of bram_reg_3_0 : label is 16383;
  attribute ram_offset of bram_reg_3_0 : label is 0;
  attribute ram_slice_begin of bram_reg_3_0 : label is 24;
  attribute ram_slice_end of bram_reg_3_0 : label is 25;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_3_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_3_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_3_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_3_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_3_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_3_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_3_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_3_1 : label is 0;
  attribute ram_addr_end of bram_reg_3_1 : label is 16383;
  attribute ram_offset of bram_reg_3_1 : label is 0;
  attribute ram_slice_begin of bram_reg_3_1 : label is 26;
  attribute ram_slice_end of bram_reg_3_1 : label is 27;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_3_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_3_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_3_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_3_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_3_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_3_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_3_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_3_2 : label is 0;
  attribute ram_addr_end of bram_reg_3_2 : label is 16383;
  attribute ram_offset of bram_reg_3_2 : label is 0;
  attribute ram_slice_begin of bram_reg_3_2 : label is 28;
  attribute ram_slice_end of bram_reg_3_2 : label is 29;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_3_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_3_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_3_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_3_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_3_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_3_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_3_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_3_3 : label is 0;
  attribute ram_addr_end of bram_reg_3_3 : label is 16383;
  attribute ram_offset of bram_reg_3_3 : label is 0;
  attribute ram_slice_begin of bram_reg_3_3 : label is 30;
  attribute ram_slice_end of bram_reg_3_3 : label is 31;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_4_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_4_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_4_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_4_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_4_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_4_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_4_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_4_0 : label is 0;
  attribute ram_addr_end of bram_reg_4_0 : label is 16383;
  attribute ram_offset of bram_reg_4_0 : label is 0;
  attribute ram_slice_begin of bram_reg_4_0 : label is 32;
  attribute ram_slice_end of bram_reg_4_0 : label is 33;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_4_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_4_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_4_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_4_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_4_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_4_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_4_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_4_1 : label is 0;
  attribute ram_addr_end of bram_reg_4_1 : label is 16383;
  attribute ram_offset of bram_reg_4_1 : label is 0;
  attribute ram_slice_begin of bram_reg_4_1 : label is 34;
  attribute ram_slice_end of bram_reg_4_1 : label is 35;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_4_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_4_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_4_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_4_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_4_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_4_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_4_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_4_2 : label is 0;
  attribute ram_addr_end of bram_reg_4_2 : label is 16383;
  attribute ram_offset of bram_reg_4_2 : label is 0;
  attribute ram_slice_begin of bram_reg_4_2 : label is 36;
  attribute ram_slice_end of bram_reg_4_2 : label is 37;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_4_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_4_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_4_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_4_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_4_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_4_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_4_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_4_3 : label is 0;
  attribute ram_addr_end of bram_reg_4_3 : label is 16383;
  attribute ram_offset of bram_reg_4_3 : label is 0;
  attribute ram_slice_begin of bram_reg_4_3 : label is 38;
  attribute ram_slice_end of bram_reg_4_3 : label is 39;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_5_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_5_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_5_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_5_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_5_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_5_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_5_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_5_0 : label is 0;
  attribute ram_addr_end of bram_reg_5_0 : label is 16383;
  attribute ram_offset of bram_reg_5_0 : label is 0;
  attribute ram_slice_begin of bram_reg_5_0 : label is 40;
  attribute ram_slice_end of bram_reg_5_0 : label is 41;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_5_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_5_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_5_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_5_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_5_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_5_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_5_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_5_1 : label is 0;
  attribute ram_addr_end of bram_reg_5_1 : label is 16383;
  attribute ram_offset of bram_reg_5_1 : label is 0;
  attribute ram_slice_begin of bram_reg_5_1 : label is 42;
  attribute ram_slice_end of bram_reg_5_1 : label is 43;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_5_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_5_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_5_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_5_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_5_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_5_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_5_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_5_2 : label is 0;
  attribute ram_addr_end of bram_reg_5_2 : label is 16383;
  attribute ram_offset of bram_reg_5_2 : label is 0;
  attribute ram_slice_begin of bram_reg_5_2 : label is 44;
  attribute ram_slice_end of bram_reg_5_2 : label is 45;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_5_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_5_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_5_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_5_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_5_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_5_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_5_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_5_3 : label is 0;
  attribute ram_addr_end of bram_reg_5_3 : label is 16383;
  attribute ram_offset of bram_reg_5_3 : label is 0;
  attribute ram_slice_begin of bram_reg_5_3 : label is 46;
  attribute ram_slice_end of bram_reg_5_3 : label is 47;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_6_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_6_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_6_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_6_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_6_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_6_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_6_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_6_0 : label is 0;
  attribute ram_addr_end of bram_reg_6_0 : label is 16383;
  attribute ram_offset of bram_reg_6_0 : label is 0;
  attribute ram_slice_begin of bram_reg_6_0 : label is 48;
  attribute ram_slice_end of bram_reg_6_0 : label is 49;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_6_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_6_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_6_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_6_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_6_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_6_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_6_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_6_1 : label is 0;
  attribute ram_addr_end of bram_reg_6_1 : label is 16383;
  attribute ram_offset of bram_reg_6_1 : label is 0;
  attribute ram_slice_begin of bram_reg_6_1 : label is 50;
  attribute ram_slice_end of bram_reg_6_1 : label is 51;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_6_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_6_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_6_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_6_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_6_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_6_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_6_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_6_2 : label is 0;
  attribute ram_addr_end of bram_reg_6_2 : label is 16383;
  attribute ram_offset of bram_reg_6_2 : label is 0;
  attribute ram_slice_begin of bram_reg_6_2 : label is 52;
  attribute ram_slice_end of bram_reg_6_2 : label is 53;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_6_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_6_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_6_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_6_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_6_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_6_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_6_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_6_3 : label is 0;
  attribute ram_addr_end of bram_reg_6_3 : label is 16383;
  attribute ram_offset of bram_reg_6_3 : label is 0;
  attribute ram_slice_begin of bram_reg_6_3 : label is 54;
  attribute ram_slice_end of bram_reg_6_3 : label is 55;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_7_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_7_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_7_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_7_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_7_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_7_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_7_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_7_0 : label is 0;
  attribute ram_addr_end of bram_reg_7_0 : label is 16383;
  attribute ram_offset of bram_reg_7_0 : label is 0;
  attribute ram_slice_begin of bram_reg_7_0 : label is 56;
  attribute ram_slice_end of bram_reg_7_0 : label is 57;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_7_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_7_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_7_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_7_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_7_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_7_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_7_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_7_1 : label is 0;
  attribute ram_addr_end of bram_reg_7_1 : label is 16383;
  attribute ram_offset of bram_reg_7_1 : label is 0;
  attribute ram_slice_begin of bram_reg_7_1 : label is 58;
  attribute ram_slice_end of bram_reg_7_1 : label is 59;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_7_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_7_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_7_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_7_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_7_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_7_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_7_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_7_2 : label is 0;
  attribute ram_addr_end of bram_reg_7_2 : label is 16383;
  attribute ram_offset of bram_reg_7_2 : label is 0;
  attribute ram_slice_begin of bram_reg_7_2 : label is 60;
  attribute ram_slice_end of bram_reg_7_2 : label is 61;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_7_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_7_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_7_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_7_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_7_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_7_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_7_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_7_3 : label is 0;
  attribute ram_addr_end of bram_reg_7_3 : label is 16383;
  attribute ram_offset of bram_reg_7_3 : label is 0;
  attribute ram_slice_begin of bram_reg_7_3 : label is 62;
  attribute ram_slice_end of bram_reg_7_3 : label is 63;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_8_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_8_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_8_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_8_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_8_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_8_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_8_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_8_0 : label is 0;
  attribute ram_addr_end of bram_reg_8_0 : label is 16383;
  attribute ram_offset of bram_reg_8_0 : label is 0;
  attribute ram_slice_begin of bram_reg_8_0 : label is 64;
  attribute ram_slice_end of bram_reg_8_0 : label is 65;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_8_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_8_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_8_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_8_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_8_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_8_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_8_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_8_1 : label is 0;
  attribute ram_addr_end of bram_reg_8_1 : label is 16383;
  attribute ram_offset of bram_reg_8_1 : label is 0;
  attribute ram_slice_begin of bram_reg_8_1 : label is 66;
  attribute ram_slice_end of bram_reg_8_1 : label is 67;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_8_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_8_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_8_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_8_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_8_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_8_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_8_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_8_2 : label is 0;
  attribute ram_addr_end of bram_reg_8_2 : label is 16383;
  attribute ram_offset of bram_reg_8_2 : label is 0;
  attribute ram_slice_begin of bram_reg_8_2 : label is 68;
  attribute ram_slice_end of bram_reg_8_2 : label is 69;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_8_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_8_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_8_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_8_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_8_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_8_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_8_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_8_3 : label is 0;
  attribute ram_addr_end of bram_reg_8_3 : label is 16383;
  attribute ram_offset of bram_reg_8_3 : label is 0;
  attribute ram_slice_begin of bram_reg_8_3 : label is 70;
  attribute ram_slice_end of bram_reg_8_3 : label is 71;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_9_0 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_9_0 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_9_0 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_9_0 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_9_0 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_9_0 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_9_0 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_9_0 : label is 0;
  attribute ram_addr_end of bram_reg_9_0 : label is 16383;
  attribute ram_offset of bram_reg_9_0 : label is 0;
  attribute ram_slice_begin of bram_reg_9_0 : label is 72;
  attribute ram_slice_end of bram_reg_9_0 : label is 73;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_9_1 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_9_1 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_9_1 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_9_1 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_9_1 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_9_1 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_9_1 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_9_1 : label is 0;
  attribute ram_addr_end of bram_reg_9_1 : label is 16383;
  attribute ram_offset of bram_reg_9_1 : label is 0;
  attribute ram_slice_begin of bram_reg_9_1 : label is 74;
  attribute ram_slice_end of bram_reg_9_1 : label is 75;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_9_2 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_9_2 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_9_2 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_9_2 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_9_2 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_9_2 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_9_2 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_9_2 : label is 0;
  attribute ram_addr_end of bram_reg_9_2 : label is 16383;
  attribute ram_offset of bram_reg_9_2 : label is 0;
  attribute ram_slice_begin of bram_reg_9_2 : label is 76;
  attribute ram_slice_end of bram_reg_9_2 : label is 77;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of bram_reg_9_3 : label is "p0_d2";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of bram_reg_9_3 : label is "p0_d2";
  attribute METHODOLOGY_DRC_VIOS of bram_reg_9_3 : label is "{SYNTH-15 {cell *THIS*} {string {address width (14) is more than optimal threshold of 12. Implementing using BWWE will require more logic and timing would be suboptimal. Please use attribute ram_decomp = power if BWWE is desired.}}} {SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS of bram_reg_9_3 : label is 2097152;
  attribute RTL_RAM_NAME of bram_reg_9_3 : label is "arty_ddr_weight_bram_0_0/inst/bram_reg";
  attribute RTL_RAM_STYLE of bram_reg_9_3 : label is "block";
  attribute RTL_RAM_TYPE of bram_reg_9_3 : label is "RAM_SDP";
  attribute ram_addr_begin of bram_reg_9_3 : label is 0;
  attribute ram_addr_end of bram_reg_9_3 : label is 16383;
  attribute ram_offset of bram_reg_9_3 : label is 0;
  attribute ram_slice_begin of bram_reg_9_3 : label is 78;
  attribute ram_slice_end of bram_reg_9_3 : label is 79;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \i__carry__0_i_6\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \i__carry__0_i_7\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \i__carry_i_10\ : label is "soft_lutpair0";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \p_0_out_inferred__0/i__carry\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \p_0_out_inferred__0/i__carry\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute ADDER_THRESHOLD of \p_0_out_inferred__0/i__carry__0\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \p_0_out_inferred__0/i__carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \rbeats[0]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of s_axi_rlast_INST_0 : label is "soft_lutpair0";
  attribute ORIG_CELL_NAME : string;
  attribute ORIG_CELL_NAME of \waddr_reg[10]\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep__0\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep__1\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep__2\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep__3\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep__4\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[10]_rep__5\ : label is "waddr_reg[10]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]\ : label is "waddr_reg[11]";
  attribute ADDER_THRESHOLD of \waddr_reg[11]_i_2\ : label is 35;
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep__0\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep__1\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep__2\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep__3\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep__4\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[11]_rep__5\ : label is "waddr_reg[11]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep__0\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep__1\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep__2\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep__3\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep__4\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[12]_rep__5\ : label is "waddr_reg[12]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep__0\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep__1\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep__2\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep__3\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep__4\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[13]_rep__5\ : label is "waddr_reg[13]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep__0\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep__1\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep__2\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep__3\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep__4\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[14]_rep__5\ : label is "waddr_reg[14]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]\ : label is "waddr_reg[15]";
  attribute ADDER_THRESHOLD of \waddr_reg[15]_i_2\ : label is 35;
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep__0\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep__1\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep__2\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep__3\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep__4\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[15]_rep__5\ : label is "waddr_reg[15]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep__0\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep__1\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep__2\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep__3\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep__4\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[16]_rep__5\ : label is "waddr_reg[16]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]\ : label is "waddr_reg[17]";
  attribute ADDER_THRESHOLD of \waddr_reg[17]_i_3\ : label is 35;
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep\ : label is "waddr_reg[17]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep__0\ : label is "waddr_reg[17]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep__1\ : label is "waddr_reg[17]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep__2\ : label is "waddr_reg[17]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep__3\ : label is "waddr_reg[17]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep__4\ : label is "waddr_reg[17]";
  attribute ORIG_CELL_NAME of \waddr_reg[17]_rep__5\ : label is "waddr_reg[17]";
  attribute ADDER_THRESHOLD of \waddr_reg[3]_i_2\ : label is 35;
  attribute ORIG_CELL_NAME of \waddr_reg[4]\ : label is "waddr_reg[4]";
  attribute ORIG_CELL_NAME of \waddr_reg[4]_rep\ : label is "waddr_reg[4]";
  attribute ORIG_CELL_NAME of \waddr_reg[4]_rep__0\ : label is "waddr_reg[4]";
  attribute ORIG_CELL_NAME of \waddr_reg[5]\ : label is "waddr_reg[5]";
  attribute ORIG_CELL_NAME of \waddr_reg[5]_rep\ : label is "waddr_reg[5]";
  attribute ORIG_CELL_NAME of \waddr_reg[5]_rep__0\ : label is "waddr_reg[5]";
  attribute ORIG_CELL_NAME of \waddr_reg[6]\ : label is "waddr_reg[6]";
  attribute ORIG_CELL_NAME of \waddr_reg[6]_rep\ : label is "waddr_reg[6]";
  attribute ORIG_CELL_NAME of \waddr_reg[6]_rep__0\ : label is "waddr_reg[6]";
  attribute ORIG_CELL_NAME of \waddr_reg[7]\ : label is "waddr_reg[7]";
  attribute ADDER_THRESHOLD of \waddr_reg[7]_i_2\ : label is 35;
  attribute ORIG_CELL_NAME of \waddr_reg[7]_rep\ : label is "waddr_reg[7]";
  attribute ORIG_CELL_NAME of \waddr_reg[7]_rep__0\ : label is "waddr_reg[7]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep__0\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep__1\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep__2\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep__3\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep__4\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[8]_rep__5\ : label is "waddr_reg[8]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep__0\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep__1\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep__2\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep__3\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep__4\ : label is "waddr_reg[9]";
  attribute ORIG_CELL_NAME of \waddr_reg[9]_rep__5\ : label is "waddr_reg[9]";
  attribute SOFT_HLUTNM of \wstate[0]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \wstate[1]_i_1\ : label is "soft_lutpair3";
begin
  s_axi_awready <= \^s_axi_awready\;
  s_axi_bvalid <= \^s_axi_bvalid\;
  s_axi_rvalid_reg_0 <= \^s_axi_rvalid_reg_0\;
  s_axi_wready <= \^s_axi_wready\;
\FSM_onehot_wstate[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst_n,
      O => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\FSM_onehot_wstate[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEAEAEAEAEAEAEA"
    )
        port map (
      I0 => wid(0),
      I1 => s_axi_bready,
      I2 => \FSM_onehot_wstate_reg_n_0_[2]\,
      I3 => s_axi_wlast,
      I4 => s_axi_wvalid,
      I5 => \^s_axi_wready\,
      O => wstate(0)
    );
\FSM_onehot_wstate_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => wstate(0),
      D => \FSM_onehot_wstate_reg_n_0_[2]\,
      Q => \^s_axi_awready\,
      S => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\FSM_onehot_wstate_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => wstate(0),
      D => \^s_axi_awready\,
      Q => \^s_axi_wready\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\FSM_onehot_wstate_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => wstate(0),
      D => \^s_axi_wready\,
      Q => \FSM_onehot_wstate_reg_n_0_[2]\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
bram_reg_0_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_0_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_0_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_0_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(1 downto 0),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_0_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_0_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(1 downto 0),
      DOPADOP(3 downto 0) => NLW_bram_reg_0_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_0_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_0_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_0_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_0_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_0_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_0_0_SBITERR_UNCONNECTED,
      WEA(3) => bram_reg_0_3_i_1_n_0,
      WEA(2) => bram_reg_0_3_i_1_n_0,
      WEA(1) => bram_reg_0_3_i_1_n_0,
      WEA(0) => bram_reg_0_3_i_1_n_0,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_0_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_0_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_0_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_0_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(3 downto 2),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_0_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_0_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(3 downto 2),
      DOPADOP(3 downto 0) => NLW_bram_reg_0_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_0_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_0_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_0_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_0_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_0_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_0_1_SBITERR_UNCONNECTED,
      WEA(3) => bram_reg_0_3_i_1_n_0,
      WEA(2) => bram_reg_0_3_i_1_n_0,
      WEA(1) => bram_reg_0_3_i_1_n_0,
      WEA(0) => bram_reg_0_3_i_1_n_0,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_0_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_0_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_0_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_0_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(5 downto 4),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_0_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_0_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(5 downto 4),
      DOPADOP(3 downto 0) => NLW_bram_reg_0_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_0_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_0_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_0_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_0_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_0_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_0_2_SBITERR_UNCONNECTED,
      WEA(3) => bram_reg_0_3_i_1_n_0,
      WEA(2) => bram_reg_0_3_i_1_n_0,
      WEA(1) => bram_reg_0_3_i_1_n_0,
      WEA(0) => bram_reg_0_3_i_1_n_0,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_0_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_0_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_0_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_0_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(7 downto 6),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_0_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_0_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(7 downto 6),
      DOPADOP(3 downto 0) => NLW_bram_reg_0_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_0_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_0_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_0_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_0_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_0_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_0_3_SBITERR_UNCONNECTED,
      WEA(3) => bram_reg_0_3_i_1_n_0,
      WEA(2) => bram_reg_0_3_i_1_n_0,
      WEA(1) => bram_reg_0_3_i_1_n_0,
      WEA(0) => bram_reg_0_3_i_1_n_0,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_0_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(0),
      O => bram_reg_0_3_i_1_n_0
    );
bram_reg_10_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_10_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_10_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_10_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(17 downto 16),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_10_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_10_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(81 downto 80),
      DOPADOP(3 downto 0) => NLW_bram_reg_10_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_10_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_10_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_10_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_10_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_10_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_10_0_SBITERR_UNCONNECTED,
      WEA(3) => p_10_in,
      WEA(2) => p_10_in,
      WEA(1) => p_10_in,
      WEA(0) => p_10_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_10_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_10_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_10_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_10_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(19 downto 18),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_10_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_10_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(83 downto 82),
      DOPADOP(3 downto 0) => NLW_bram_reg_10_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_10_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_10_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_10_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_10_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_10_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_10_1_SBITERR_UNCONNECTED,
      WEA(3) => p_10_in,
      WEA(2) => p_10_in,
      WEA(1) => p_10_in,
      WEA(0) => p_10_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_10_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_10_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_10_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_10_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(21 downto 20),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_10_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_10_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(85 downto 84),
      DOPADOP(3 downto 0) => NLW_bram_reg_10_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_10_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_10_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_10_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_10_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_10_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_10_2_SBITERR_UNCONNECTED,
      WEA(3) => p_10_in,
      WEA(2) => p_10_in,
      WEA(1) => p_10_in,
      WEA(0) => p_10_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_10_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_10_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_10_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_10_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(23 downto 22),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_10_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_10_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(87 downto 86),
      DOPADOP(3 downto 0) => NLW_bram_reg_10_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_10_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_10_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_10_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_10_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_10_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_10_3_SBITERR_UNCONNECTED,
      WEA(3) => p_10_in,
      WEA(2) => p_10_in,
      WEA(1) => p_10_in,
      WEA(0) => p_10_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_10_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(2),
      I1 => \p_0_in__0\(3),
      I2 => s_axi_wstrb(2),
      O => p_10_in
    );
bram_reg_11_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_11_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_11_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_11_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(25 downto 24),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_11_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_11_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(89 downto 88),
      DOPADOP(3 downto 0) => NLW_bram_reg_11_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_11_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_11_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_11_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_11_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_11_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_11_0_SBITERR_UNCONNECTED,
      WEA(3) => p_11_in,
      WEA(2) => p_11_in,
      WEA(1) => p_11_in,
      WEA(0) => p_11_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_11_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_11_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_11_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_11_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(27 downto 26),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_11_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_11_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(91 downto 90),
      DOPADOP(3 downto 0) => NLW_bram_reg_11_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_11_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_11_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_11_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_11_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_11_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_11_1_SBITERR_UNCONNECTED,
      WEA(3) => p_11_in,
      WEA(2) => p_11_in,
      WEA(1) => p_11_in,
      WEA(0) => p_11_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_11_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_11_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_11_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_11_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(29 downto 28),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_11_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_11_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(93 downto 92),
      DOPADOP(3 downto 0) => NLW_bram_reg_11_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_11_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_11_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_11_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_11_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_11_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_11_2_SBITERR_UNCONNECTED,
      WEA(3) => p_11_in,
      WEA(2) => p_11_in,
      WEA(1) => p_11_in,
      WEA(0) => p_11_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_11_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_11_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_11_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_11_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(31 downto 30),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_11_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_11_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(95 downto 94),
      DOPADOP(3 downto 0) => NLW_bram_reg_11_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_11_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_11_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_11_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_11_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_11_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_11_3_SBITERR_UNCONNECTED,
      WEA(3) => p_11_in,
      WEA(2) => p_11_in,
      WEA(1) => p_11_in,
      WEA(0) => p_11_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_11_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(2),
      I1 => \p_0_in__0\(3),
      I2 => s_axi_wstrb(3),
      O => p_11_in
    );
bram_reg_12_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_12_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_12_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_12_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(1 downto 0),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_12_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_12_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(97 downto 96),
      DOPADOP(3 downto 0) => NLW_bram_reg_12_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_12_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_12_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_12_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_12_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_12_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_12_0_SBITERR_UNCONNECTED,
      WEA(3) => p_12_in,
      WEA(2) => p_12_in,
      WEA(1) => p_12_in,
      WEA(0) => p_12_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_12_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__3_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__3_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__3_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__3_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__3_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__3_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__3_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__3_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__3_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__3_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_12_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_12_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_12_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(3 downto 2),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_12_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_12_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(99 downto 98),
      DOPADOP(3 downto 0) => NLW_bram_reg_12_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_12_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_12_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_12_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_12_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_12_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_12_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_12_1_SBITERR_UNCONNECTED,
      WEA(3) => p_12_in,
      WEA(2) => p_12_in,
      WEA(1) => p_12_in,
      WEA(0) => p_12_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_12_1_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_12_1_i_1_n_0
    );
bram_reg_12_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_12_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_12_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_12_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(5 downto 4),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_12_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_12_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(101 downto 100),
      DOPADOP(3 downto 0) => NLW_bram_reg_12_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_12_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_12_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_12_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_12_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_12_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_12_2_SBITERR_UNCONNECTED,
      WEA(3) => p_12_in,
      WEA(2) => p_12_in,
      WEA(1) => p_12_in,
      WEA(0) => p_12_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_12_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_12_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_12_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_12_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(7 downto 6),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_12_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_12_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(103 downto 102),
      DOPADOP(3 downto 0) => NLW_bram_reg_12_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_12_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_12_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_12_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_12_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_12_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_12_3_SBITERR_UNCONNECTED,
      WEA(3) => p_12_in,
      WEA(2) => p_12_in,
      WEA(1) => p_12_in,
      WEA(0) => p_12_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_12_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(0),
      O => p_12_in
    );
bram_reg_13_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_13_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_13_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_13_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(9 downto 8),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_13_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_13_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(105 downto 104),
      DOPADOP(3 downto 0) => NLW_bram_reg_13_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_13_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_13_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_13_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_13_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_13_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_13_0_SBITERR_UNCONNECTED,
      WEA(3) => p_13_in,
      WEA(2) => p_13_in,
      WEA(1) => p_13_in,
      WEA(0) => p_13_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_13_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_13_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_13_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_13_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(11 downto 10),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_13_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_13_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(107 downto 106),
      DOPADOP(3 downto 0) => NLW_bram_reg_13_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_13_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_13_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_13_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_13_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_13_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_13_1_SBITERR_UNCONNECTED,
      WEA(3) => p_13_in,
      WEA(2) => p_13_in,
      WEA(1) => p_13_in,
      WEA(0) => p_13_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_13_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_13_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_13_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_13_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(13 downto 12),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_13_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_13_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(109 downto 108),
      DOPADOP(3 downto 0) => NLW_bram_reg_13_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_13_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_13_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_13_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_13_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_13_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_13_2_SBITERR_UNCONNECTED,
      WEA(3) => p_13_in,
      WEA(2) => p_13_in,
      WEA(1) => p_13_in,
      WEA(0) => p_13_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_13_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_13_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_13_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_13_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(15 downto 14),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_13_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_13_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(111 downto 110),
      DOPADOP(3 downto 0) => NLW_bram_reg_13_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_13_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_13_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_13_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_13_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_13_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_13_3_SBITERR_UNCONNECTED,
      WEA(3) => p_13_in,
      WEA(2) => p_13_in,
      WEA(1) => p_13_in,
      WEA(0) => p_13_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_13_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(1),
      O => p_13_in
    );
bram_reg_14_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_14_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_14_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_14_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(17 downto 16),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_14_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_14_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(113 downto 112),
      DOPADOP(3 downto 0) => NLW_bram_reg_14_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_14_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_14_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_14_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_14_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_14_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_14_0_SBITERR_UNCONNECTED,
      WEA(3) => p_14_in,
      WEA(2) => p_14_in,
      WEA(1) => p_14_in,
      WEA(0) => p_14_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_14_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_14_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_14_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_14_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(19 downto 18),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_14_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_14_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(115 downto 114),
      DOPADOP(3 downto 0) => NLW_bram_reg_14_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_14_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_14_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_14_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_14_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_14_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_14_1_SBITERR_UNCONNECTED,
      WEA(3) => p_14_in,
      WEA(2) => p_14_in,
      WEA(1) => p_14_in,
      WEA(0) => p_14_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_14_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_14_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_14_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_14_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(21 downto 20),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_14_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_14_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(117 downto 116),
      DOPADOP(3 downto 0) => NLW_bram_reg_14_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_14_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_14_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_14_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_14_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_14_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_14_2_SBITERR_UNCONNECTED,
      WEA(3) => p_14_in,
      WEA(2) => p_14_in,
      WEA(1) => p_14_in,
      WEA(0) => p_14_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_14_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__4_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__4_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__4_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__4_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__4_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__4_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__4_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__4_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__4_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__4_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_14_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_14_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_14_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(23 downto 22),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_14_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_14_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(119 downto 118),
      DOPADOP(3 downto 0) => NLW_bram_reg_14_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_14_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_14_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_14_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_14_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_14_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_14_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_14_3_SBITERR_UNCONNECTED,
      WEA(3) => p_14_in,
      WEA(2) => p_14_in,
      WEA(1) => p_14_in,
      WEA(0) => p_14_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_14_3_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_14_3_i_1_n_0
    );
bram_reg_14_3_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(2),
      O => p_14_in
    );
bram_reg_15_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__5_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__5_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__5_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__5_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__5_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__5_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__5_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__5_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__5_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__5_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_15_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_15_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_15_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(25 downto 24),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_15_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_15_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(121 downto 120),
      DOPADOP(3 downto 0) => NLW_bram_reg_15_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_15_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_15_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_15_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_15_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_15_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_15_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_15_0_SBITERR_UNCONNECTED,
      WEA(3) => p_0_in(0),
      WEA(2) => p_0_in(0),
      WEA(1) => p_0_in(0),
      WEA(0) => p_0_in(0),
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_15_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__5_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__5_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__5_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__5_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__5_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__5_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__5_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__5_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__5_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__5_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_15_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_15_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_15_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(27 downto 26),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_15_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_15_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(123 downto 122),
      DOPADOP(3 downto 0) => NLW_bram_reg_15_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_15_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_15_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_15_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_15_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_15_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_15_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_15_1_SBITERR_UNCONNECTED,
      WEA(3) => p_0_in(0),
      WEA(2) => p_0_in(0),
      WEA(1) => p_0_in(0),
      WEA(0) => p_0_in(0),
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_15_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__5_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__5_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__5_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__5_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__5_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__5_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__5_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__5_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__5_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__5_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_15_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_15_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_15_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(29 downto 28),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_15_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_15_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(125 downto 124),
      DOPADOP(3 downto 0) => NLW_bram_reg_15_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_15_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_15_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_15_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_15_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_15_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_15_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_15_2_SBITERR_UNCONNECTED,
      WEA(3) => p_0_in(0),
      WEA(2) => p_0_in(0),
      WEA(1) => p_0_in(0),
      WEA(0) => p_0_in(0),
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_15_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__5_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__5_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__5_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__5_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__5_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__5_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__5_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__5_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__5_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__5_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep__0_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep__0_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep__0_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep__0_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_15_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_15_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_15_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(31 downto 30),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_15_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_15_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(127 downto 126),
      DOPADOP(3 downto 0) => NLW_bram_reg_15_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_15_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_15_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_15_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_15_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_15_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_15_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_15_3_SBITERR_UNCONNECTED,
      WEA(3) => p_0_in(0),
      WEA(2) => p_0_in(0),
      WEA(1) => p_0_in(0),
      WEA(0) => p_0_in(0),
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_15_3_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_15_3_i_1_n_0
    );
bram_reg_15_3_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(3),
      O => p_0_in(0)
    );
bram_reg_1_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_1_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_1_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_1_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(9 downto 8),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_1_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_1_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(9 downto 8),
      DOPADOP(3 downto 0) => NLW_bram_reg_1_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_1_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_1_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_1_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_1_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_1_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_1_0_SBITERR_UNCONNECTED,
      WEA(3) => p_1_in,
      WEA(2) => p_1_in,
      WEA(1) => p_1_in,
      WEA(0) => p_1_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_1_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_1_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_1_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_1_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(11 downto 10),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_1_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_1_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(11 downto 10),
      DOPADOP(3 downto 0) => NLW_bram_reg_1_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_1_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_1_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_1_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_1_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_1_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_1_1_SBITERR_UNCONNECTED,
      WEA(3) => p_1_in,
      WEA(2) => p_1_in,
      WEA(1) => p_1_in,
      WEA(0) => p_1_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_1_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_1_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_1_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_1_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(13 downto 12),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_1_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_1_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(13 downto 12),
      DOPADOP(3 downto 0) => NLW_bram_reg_1_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_1_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_1_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_1_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_1_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_1_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_1_2_SBITERR_UNCONNECTED,
      WEA(3) => p_1_in,
      WEA(2) => p_1_in,
      WEA(1) => p_1_in,
      WEA(0) => p_1_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_1_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_1_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_1_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_1_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(15 downto 14),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_1_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_1_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(15 downto 14),
      DOPADOP(3 downto 0) => NLW_bram_reg_1_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_1_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_1_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_1_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_1_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_1_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_1_3_SBITERR_UNCONNECTED,
      WEA(3) => p_1_in,
      WEA(2) => p_1_in,
      WEA(1) => p_1_in,
      WEA(0) => p_1_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_1_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(1),
      O => p_1_in
    );
bram_reg_2_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_2_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_2_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_2_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(17 downto 16),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_2_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_2_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(17 downto 16),
      DOPADOP(3 downto 0) => NLW_bram_reg_2_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_2_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_2_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_2_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_2_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_2_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_2_0_SBITERR_UNCONNECTED,
      WEA(3) => p_2_in,
      WEA(2) => p_2_in,
      WEA(1) => p_2_in,
      WEA(0) => p_2_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_2_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_2_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_2_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_2_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(19 downto 18),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_2_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_2_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(19 downto 18),
      DOPADOP(3 downto 0) => NLW_bram_reg_2_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_2_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_2_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_2_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_2_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_2_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_2_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_2_1_SBITERR_UNCONNECTED,
      WEA(3) => p_2_in,
      WEA(2) => p_2_in,
      WEA(1) => p_2_in,
      WEA(0) => p_2_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_2_1_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_2_1_i_1_n_0
    );
bram_reg_2_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_2_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_2_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_2_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(21 downto 20),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_2_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_2_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(21 downto 20),
      DOPADOP(3 downto 0) => NLW_bram_reg_2_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_2_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_2_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_2_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_2_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_2_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_2_2_SBITERR_UNCONNECTED,
      WEA(3) => p_2_in,
      WEA(2) => p_2_in,
      WEA(1) => p_2_in,
      WEA(0) => p_2_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_2_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_2_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_2_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_2_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(23 downto 22),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_2_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_2_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(23 downto 22),
      DOPADOP(3 downto 0) => NLW_bram_reg_2_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_2_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_2_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_2_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_2_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_2_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_2_3_SBITERR_UNCONNECTED,
      WEA(3) => p_2_in,
      WEA(2) => p_2_in,
      WEA(1) => p_2_in,
      WEA(0) => p_2_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_2_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(2),
      O => p_2_in
    );
bram_reg_3_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_3_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_3_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_3_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(25 downto 24),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_3_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_3_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(25 downto 24),
      DOPADOP(3 downto 0) => NLW_bram_reg_3_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_3_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_3_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_3_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_3_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_3_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_3_0_SBITERR_UNCONNECTED,
      WEA(3) => p_3_in,
      WEA(2) => p_3_in,
      WEA(1) => p_3_in,
      WEA(0) => p_3_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_3_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_3_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_3_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_3_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(27 downto 26),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_3_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_3_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(27 downto 26),
      DOPADOP(3 downto 0) => NLW_bram_reg_3_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_3_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_3_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_3_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_3_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_3_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_3_1_SBITERR_UNCONNECTED,
      WEA(3) => p_3_in,
      WEA(2) => p_3_in,
      WEA(1) => p_3_in,
      WEA(0) => p_3_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_3_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_3_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_3_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_3_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(29 downto 28),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_3_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_3_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(29 downto 28),
      DOPADOP(3 downto 0) => NLW_bram_reg_3_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_3_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_3_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_3_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_3_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_3_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_3_2_SBITERR_UNCONNECTED,
      WEA(3) => p_3_in,
      WEA(2) => p_3_in,
      WEA(1) => p_3_in,
      WEA(0) => p_3_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_3_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_3_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_3_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_3_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(31 downto 30),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_3_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_3_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(31 downto 30),
      DOPADOP(3 downto 0) => NLW_bram_reg_3_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_3_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_3_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_3_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_3_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_3_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_3_3_SBITERR_UNCONNECTED,
      WEA(3) => p_3_in,
      WEA(2) => p_3_in,
      WEA(1) => p_3_in,
      WEA(0) => p_3_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_3_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(3),
      O => p_3_in
    );
bram_reg_4_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_4_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_4_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_4_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(1 downto 0),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_4_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_4_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(33 downto 32),
      DOPADOP(3 downto 0) => NLW_bram_reg_4_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_4_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_4_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_4_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_4_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_4_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_4_0_SBITERR_UNCONNECTED,
      WEA(3) => p_4_in,
      WEA(2) => p_4_in,
      WEA(1) => p_4_in,
      WEA(0) => p_4_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_4_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_4_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_4_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_4_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(3 downto 2),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_4_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_4_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(35 downto 34),
      DOPADOP(3 downto 0) => NLW_bram_reg_4_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_4_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_4_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_4_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_4_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_4_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_4_1_SBITERR_UNCONNECTED,
      WEA(3) => p_4_in,
      WEA(2) => p_4_in,
      WEA(1) => p_4_in,
      WEA(0) => p_4_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_4_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_4_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_4_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_4_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(5 downto 4),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_4_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_4_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(37 downto 36),
      DOPADOP(3 downto 0) => NLW_bram_reg_4_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_4_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_4_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_4_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_4_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_4_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_4_2_SBITERR_UNCONNECTED,
      WEA(3) => p_4_in,
      WEA(2) => p_4_in,
      WEA(1) => p_4_in,
      WEA(0) => p_4_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_4_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__0_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__0_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__0_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__0_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__0_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__0_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__0_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__0_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__0_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__0_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_4_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_4_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_4_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(7 downto 6),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_4_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_4_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(39 downto 38),
      DOPADOP(3 downto 0) => NLW_bram_reg_4_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_4_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_4_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_4_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_4_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_4_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_4_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_4_3_SBITERR_UNCONNECTED,
      WEA(3) => p_4_in,
      WEA(2) => p_4_in,
      WEA(1) => p_4_in,
      WEA(0) => p_4_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_4_3_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_4_3_i_1_n_0
    );
bram_reg_4_3_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(0),
      O => p_4_in
    );
bram_reg_5_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4 downto 1) => wr_word(3 downto 0),
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_5_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_5_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_5_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(9 downto 8),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_5_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_5_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(41 downto 40),
      DOPADOP(3 downto 0) => NLW_bram_reg_5_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_5_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_5_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_5_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_5_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_5_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_5_0_SBITERR_UNCONNECTED,
      WEA(3) => p_5_in,
      WEA(2) => p_5_in,
      WEA(1) => p_5_in,
      WEA(0) => p_5_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_5_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_5_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_5_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_5_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(11 downto 10),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_5_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_5_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(43 downto 42),
      DOPADOP(3 downto 0) => NLW_bram_reg_5_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_5_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_5_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_5_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_5_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_5_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_5_1_SBITERR_UNCONNECTED,
      WEA(3) => p_5_in,
      WEA(2) => p_5_in,
      WEA(1) => p_5_in,
      WEA(0) => p_5_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_5_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_5_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_5_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_5_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(13 downto 12),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_5_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_5_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(45 downto 44),
      DOPADOP(3 downto 0) => NLW_bram_reg_5_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_5_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_5_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_5_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_5_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_5_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_5_2_SBITERR_UNCONNECTED,
      WEA(3) => p_5_in,
      WEA(2) => p_5_in,
      WEA(1) => p_5_in,
      WEA(0) => p_5_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_5_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_5_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_5_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_5_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(15 downto 14),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_5_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_5_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(47 downto 46),
      DOPADOP(3 downto 0) => NLW_bram_reg_5_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_5_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_5_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_5_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_5_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_5_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_5_3_SBITERR_UNCONNECTED,
      WEA(3) => p_5_in,
      WEA(2) => p_5_in,
      WEA(1) => p_5_in,
      WEA(0) => p_5_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_5_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(1),
      O => p_5_in
    );
bram_reg_6_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_6_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_6_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_6_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(17 downto 16),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_6_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_6_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(49 downto 48),
      DOPADOP(3 downto 0) => NLW_bram_reg_6_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_6_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_6_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_6_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_6_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_6_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_6_0_SBITERR_UNCONNECTED,
      WEA(3) => p_6_in,
      WEA(2) => p_6_in,
      WEA(1) => p_6_in,
      WEA(0) => p_6_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_6_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_6_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_6_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_6_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(19 downto 18),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_6_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_6_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(51 downto 50),
      DOPADOP(3 downto 0) => NLW_bram_reg_6_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_6_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_6_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_6_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_6_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_6_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_6_1_SBITERR_UNCONNECTED,
      WEA(3) => p_6_in,
      WEA(2) => p_6_in,
      WEA(1) => p_6_in,
      WEA(0) => p_6_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_6_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_6_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_6_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_6_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(21 downto 20),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_6_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_6_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(53 downto 52),
      DOPADOP(3 downto 0) => NLW_bram_reg_6_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_6_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_6_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_6_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_6_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_6_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_6_2_SBITERR_UNCONNECTED,
      WEA(3) => p_6_in,
      WEA(2) => p_6_in,
      WEA(1) => p_6_in,
      WEA(0) => p_6_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_6_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_6_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_6_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_6_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(23 downto 22),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_6_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_6_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(55 downto 54),
      DOPADOP(3 downto 0) => NLW_bram_reg_6_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_6_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_6_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_6_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_6_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_6_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_6_3_SBITERR_UNCONNECTED,
      WEA(3) => p_6_in,
      WEA(2) => p_6_in,
      WEA(1) => p_6_in,
      WEA(0) => p_6_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_6_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(2),
      O => p_6_in
    );
bram_reg_7_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_7_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_7_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_7_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(25 downto 24),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_7_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_7_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(57 downto 56),
      DOPADOP(3 downto 0) => NLW_bram_reg_7_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_7_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_7_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_7_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_7_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_7_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_7_0_SBITERR_UNCONNECTED,
      WEA(3) => p_7_in,
      WEA(2) => p_7_in,
      WEA(1) => p_7_in,
      WEA(0) => p_7_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_7_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__1_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__1_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__1_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__1_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__1_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__1_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__1_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__1_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__1_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__1_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_7_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_7_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_7_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(27 downto 26),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_7_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_7_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(59 downto 58),
      DOPADOP(3 downto 0) => NLW_bram_reg_7_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_7_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_7_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_7_1_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_7_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_7_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_7_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_7_1_SBITERR_UNCONNECTED,
      WEA(3) => p_7_in,
      WEA(2) => p_7_in,
      WEA(1) => p_7_in,
      WEA(0) => p_7_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_7_1_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_7_1_i_1_n_0
    );
bram_reg_7_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_7_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_7_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_7_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(29 downto 28),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_7_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_7_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(61 downto 60),
      DOPADOP(3 downto 0) => NLW_bram_reg_7_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_7_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_7_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_7_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_7_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_7_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_7_2_SBITERR_UNCONNECTED,
      WEA(3) => p_7_in,
      WEA(2) => p_7_in,
      WEA(1) => p_7_in,
      WEA(0) => p_7_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_7_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_7_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_7_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_7_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(31 downto 30),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_7_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_7_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(63 downto 62),
      DOPADOP(3 downto 0) => NLW_bram_reg_7_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_7_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_7_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_7_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_7_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_7_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_7_3_SBITERR_UNCONNECTED,
      WEA(3) => p_7_in,
      WEA(2) => p_7_in,
      WEA(1) => p_7_in,
      WEA(0) => p_7_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_7_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => \p_0_in__0\(2),
      I2 => s_axi_wstrb(3),
      O => p_7_in
    );
bram_reg_8_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_8_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_8_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_8_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(1 downto 0),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_8_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_8_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(65 downto 64),
      DOPADOP(3 downto 0) => NLW_bram_reg_8_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_8_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_8_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_8_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_8_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_8_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_8_0_SBITERR_UNCONNECTED,
      WEA(3) => p_8_in,
      WEA(2) => p_8_in,
      WEA(1) => p_8_in,
      WEA(0) => p_8_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_8_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_8_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_8_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_8_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(3 downto 2),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_8_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_8_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(67 downto 66),
      DOPADOP(3 downto 0) => NLW_bram_reg_8_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_8_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_8_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_8_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_8_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_8_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_8_1_SBITERR_UNCONNECTED,
      WEA(3) => p_8_in,
      WEA(2) => p_8_in,
      WEA(1) => p_8_in,
      WEA(0) => p_8_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_8_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_8_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_8_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_8_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(5 downto 4),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_8_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_8_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(69 downto 68),
      DOPADOP(3 downto 0) => NLW_bram_reg_8_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_8_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_8_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_8_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_8_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_8_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_8_2_SBITERR_UNCONNECTED,
      WEA(3) => p_8_in,
      WEA(2) => p_8_in,
      WEA(1) => p_8_in,
      WEA(0) => p_8_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_8_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_8_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_8_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_8_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(7 downto 6),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_8_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_8_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(71 downto 70),
      DOPADOP(3 downto 0) => NLW_bram_reg_8_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_8_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_8_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_8_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_8_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_8_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_8_3_SBITERR_UNCONNECTED,
      WEA(3) => p_8_in,
      WEA(2) => p_8_in,
      WEA(1) => p_8_in,
      WEA(0) => p_8_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_8_3_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(2),
      I1 => \p_0_in__0\(3),
      I2 => s_axi_wstrb(0),
      O => p_8_in
    );
bram_reg_9_0: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_9_0_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_9_0_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_9_0_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(9 downto 8),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_9_0_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_9_0_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(73 downto 72),
      DOPADOP(3 downto 0) => NLW_bram_reg_9_0_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_9_0_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_9_0_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_9_0_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_9_0_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_9_0_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_9_0_SBITERR_UNCONNECTED,
      WEA(3) => p_9_in,
      WEA(2) => p_9_in,
      WEA(1) => p_9_in,
      WEA(0) => p_9_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_9_1: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_9_1_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_9_1_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_9_1_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(11 downto 10),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_9_1_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_9_1_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(75 downto 74),
      DOPADOP(3 downto 0) => NLW_bram_reg_9_1_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_9_1_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_9_1_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_9_1_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_9_1_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_9_1_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_9_1_SBITERR_UNCONNECTED,
      WEA(3) => p_9_in,
      WEA(2) => p_9_in,
      WEA(1) => p_9_in,
      WEA(0) => p_9_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_9_2: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_9_2_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_9_2_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_9_2_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(13 downto 12),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_9_2_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_9_2_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(77 downto 76),
      DOPADOP(3 downto 0) => NLW_bram_reg_9_2_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_9_2_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_9_2_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_9_2_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_9_2_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_9_2_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_9_2_SBITERR_UNCONNECTED,
      WEA(3) => p_9_in,
      WEA(2) => p_9_in,
      WEA(1) => p_9_in,
      WEA(0) => p_9_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_9_3: unisim.vcomponents.RAMB36E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      EN_ECC_READ => false,
      EN_ECC_WRITE => false,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      RAM_MODE => "TDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2
    )
        port map (
      ADDRARDADDR(15) => '1',
      ADDRARDADDR(14) => \waddr_reg[17]_rep__2_n_0\,
      ADDRARDADDR(13) => \waddr_reg[16]_rep__2_n_0\,
      ADDRARDADDR(12) => \waddr_reg[15]_rep__2_n_0\,
      ADDRARDADDR(11) => \waddr_reg[14]_rep__2_n_0\,
      ADDRARDADDR(10) => \waddr_reg[13]_rep__2_n_0\,
      ADDRARDADDR(9) => \waddr_reg[12]_rep__2_n_0\,
      ADDRARDADDR(8) => \waddr_reg[11]_rep__2_n_0\,
      ADDRARDADDR(7) => \waddr_reg[10]_rep__2_n_0\,
      ADDRARDADDR(6) => \waddr_reg[9]_rep__2_n_0\,
      ADDRARDADDR(5) => \waddr_reg[8]_rep__2_n_0\,
      ADDRARDADDR(4) => \waddr_reg[7]_rep_n_0\,
      ADDRARDADDR(3) => \waddr_reg[6]_rep_n_0\,
      ADDRARDADDR(2) => \waddr_reg[5]_rep_n_0\,
      ADDRARDADDR(1) => \waddr_reg[4]_rep_n_0\,
      ADDRARDADDR(0) => '1',
      ADDRBWRADDR(15) => '1',
      ADDRBWRADDR(14 downto 1) => w_word_addr(13 downto 0),
      ADDRBWRADDR(0) => '1',
      CASCADEINA => '1',
      CASCADEINB => '1',
      CASCADEOUTA => NLW_bram_reg_9_3_CASCADEOUTA_UNCONNECTED,
      CASCADEOUTB => NLW_bram_reg_9_3_CASCADEOUTB_UNCONNECTED,
      CLKARDCLK => clk,
      CLKBWRCLK => clk,
      DBITERR => NLW_bram_reg_9_3_DBITERR_UNCONNECTED,
      DIADI(31 downto 2) => B"000000000000000000000000000000",
      DIADI(1 downto 0) => s_axi_wdata(15 downto 14),
      DIBDI(31 downto 0) => B"00000000000000000000000000000011",
      DIPADIP(3 downto 0) => B"0000",
      DIPBDIP(3 downto 0) => B"0000",
      DOADO(31 downto 0) => NLW_bram_reg_9_3_DOADO_UNCONNECTED(31 downto 0),
      DOBDO(31 downto 2) => NLW_bram_reg_9_3_DOBDO_UNCONNECTED(31 downto 2),
      DOBDO(1 downto 0) => w_word(79 downto 78),
      DOPADOP(3 downto 0) => NLW_bram_reg_9_3_DOPADOP_UNCONNECTED(3 downto 0),
      DOPBDOP(3 downto 0) => NLW_bram_reg_9_3_DOPBDOP_UNCONNECTED(3 downto 0),
      ECCPARITY(7 downto 0) => NLW_bram_reg_9_3_ECCPARITY_UNCONNECTED(7 downto 0),
      ENARDEN => bram_reg_9_3_i_1_n_0,
      ENBWREN => '1',
      INJECTDBITERR => NLW_bram_reg_9_3_INJECTDBITERR_UNCONNECTED,
      INJECTSBITERR => NLW_bram_reg_9_3_INJECTSBITERR_UNCONNECTED,
      RDADDRECC(8 downto 0) => NLW_bram_reg_9_3_RDADDRECC_UNCONNECTED(8 downto 0),
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      SBITERR => NLW_bram_reg_9_3_SBITERR_UNCONNECTED,
      WEA(3) => p_9_in,
      WEA(2) => p_9_in,
      WEA(1) => p_9_in,
      WEA(0) => p_9_in,
      WEBWE(7 downto 0) => B"00000000"
    );
bram_reg_9_3_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => p_0_in(3),
      I1 => s_axi_wvalid,
      I2 => rst_n,
      I3 => p_0_in(2),
      O => bram_reg_9_3_i_1_n_0
    );
bram_reg_9_3_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \p_0_in__0\(2),
      I1 => \p_0_in__0\(3),
      I2 => s_axi_wstrb(1),
      O => p_9_in
    );
\i__carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAABAAAAAAAA"
    )
        port map (
      I0 => rbeats_reg(5),
      I1 => \rid_r[3]_i_2_n_0\,
      I2 => rbeats_reg(3),
      I3 => rbeats_reg(2),
      I4 => rbeats_reg(4),
      I5 => s_axi_arlen(5),
      O => A(5)
    );
\i__carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAABAAAAAAAA"
    )
        port map (
      I0 => rbeats_reg(4),
      I1 => \rid_r[3]_i_2_n_0\,
      I2 => rbeats_reg(3),
      I3 => rbeats_reg(2),
      I4 => rbeats_reg(5),
      I5 => s_axi_arlen(4),
      O => A(4)
    );
\i__carry__0_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"C3C2C2C3"
    )
        port map (
      I0 => \i__carry__0_i_6_n_0\,
      I1 => rbeats_reg(7),
      I2 => rbeats_reg(6),
      I3 => s_axi_arlen(7),
      I4 => s_axi_arlen(6),
      O => \i__carry__0_i_3_n_0\
    );
\i__carry__0_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A5A5A6A5"
    )
        port map (
      I0 => A(5),
      I1 => \i__carry__0_i_6_n_0\,
      I2 => rbeats_reg(6),
      I3 => s_axi_arlen(6),
      I4 => rbeats_reg(7),
      O => \i__carry__0_i_4_n_0\
    );
\i__carry__0_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0F00F09"
    )
        port map (
      I0 => s_axi_arlen(4),
      I1 => s_axi_arlen(5),
      I2 => rbeats_reg(4),
      I3 => \i__carry__0_i_7_n_0\,
      I4 => rbeats_reg(5),
      O => \i__carry__0_i_5_n_0\
    );
\i__carry__0_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFD"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^s_axi_rvalid_reg_0\,
      I2 => rbeats_reg(1),
      I3 => s_axi_arready_INST_0_i_1_n_0,
      I4 => rbeats_reg(0),
      O => \i__carry__0_i_6_n_0\
    );
\i__carry__0_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \rid_r[3]_i_2_n_0\,
      I1 => rbeats_reg(3),
      I2 => rbeats_reg(2),
      O => \i__carry__0_i_7_n_0\
    );
\i__carry_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAAAAAAE"
    )
        port map (
      I0 => rbeats_reg(0),
      I1 => s_axi_arlen(0),
      I2 => rbeats_reg(6),
      I3 => rbeats_reg(7),
      I4 => \rbeats[0]_i_2_n_0\,
      O => A(0)
    );
\i__carry_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => rbeats_reg(7),
      I1 => rbeats_reg(6),
      I2 => rbeats_reg(0),
      O => \i__carry_i_10_n_0\
    );
\i__carry_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \rid_r[3]_i_2_n_0\,
      I1 => rbeats_reg(5),
      I2 => rbeats_reg(4),
      O => \i__carry_i_11_n_0\
    );
\i__carry_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAABAAAAAAAA"
    )
        port map (
      I0 => rbeats_reg(3),
      I1 => \rid_r[3]_i_2_n_0\,
      I2 => rbeats_reg(5),
      I3 => rbeats_reg(4),
      I4 => rbeats_reg(2),
      I5 => s_axi_arlen(3),
      O => A(3)
    );
\i__carry_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAABAAAAAAAA"
    )
        port map (
      I0 => rbeats_reg(2),
      I1 => \rid_r[3]_i_2_n_0\,
      I2 => rbeats_reg(5),
      I3 => rbeats_reg(4),
      I4 => rbeats_reg(3),
      I5 => s_axi_arlen(2),
      O => A(2)
    );
\i__carry_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAABAAAAAAAAAA"
    )
        port map (
      I0 => rbeats_reg(1),
      I1 => s_axi_arready_INST_0_i_1_n_0,
      I2 => \i__carry_i_10_n_0\,
      I3 => s_axi_arvalid,
      I4 => \^s_axi_rvalid_reg_0\,
      I5 => s_axi_arlen(1),
      O => A(1)
    );
\i__carry_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => A(1),
      O => \i__carry_i_5_n_0\
    );
\i__carry_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => A(3),
      I1 => A(4),
      O => \i__carry_i_6_n_0\
    );
\i__carry_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0F00F09"
    )
        port map (
      I0 => s_axi_arlen(2),
      I1 => s_axi_arlen(3),
      I2 => rbeats_reg(2),
      I3 => \i__carry_i_11_n_0\,
      I4 => rbeats_reg(3),
      O => \i__carry_i_7_n_0\
    );
\i__carry_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => A(1),
      I1 => A(2),
      O => \i__carry_i_8_n_0\
    );
\i__carry_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => A(1),
      I1 => s_axi_rvalid0,
      O => \i__carry_i_9_n_0\
    );
\p_0_out_inferred__0/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \p_0_out_inferred__0/i__carry_n_0\,
      CO(2) => \p_0_out_inferred__0/i__carry_n_1\,
      CO(1) => \p_0_out_inferred__0/i__carry_n_2\,
      CO(0) => \p_0_out_inferred__0/i__carry_n_3\,
      CYINIT => A(0),
      DI(3 downto 1) => A(3 downto 1),
      DI(0) => \i__carry_i_5_n_0\,
      O(3) => \p_0_out_inferred__0/i__carry_n_4\,
      O(2) => \p_0_out_inferred__0/i__carry_n_5\,
      O(1) => \p_0_out_inferred__0/i__carry_n_6\,
      O(0) => \p_0_out_inferred__0/i__carry_n_7\,
      S(3) => \i__carry_i_6_n_0\,
      S(2) => \i__carry_i_7_n_0\,
      S(1) => \i__carry_i_8_n_0\,
      S(0) => \i__carry_i_9_n_0\
    );
\p_0_out_inferred__0/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out_inferred__0/i__carry_n_0\,
      CO(3 downto 2) => \NLW_p_0_out_inferred__0/i__carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \p_0_out_inferred__0/i__carry__0_n_2\,
      CO(0) => \p_0_out_inferred__0/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => A(5 downto 4),
      O(3) => \NLW_p_0_out_inferred__0/i__carry__0_O_UNCONNECTED\(3),
      O(2) => \p_0_out_inferred__0/i__carry__0_n_5\,
      O(1) => \p_0_out_inferred__0/i__carry__0_n_6\,
      O(0) => \p_0_out_inferred__0/i__carry__0_n_7\,
      S(3) => '0',
      S(2) => \i__carry__0_i_3_n_0\,
      S(1) => \i__carry__0_i_4_n_0\,
      S(0) => \i__carry__0_i_5_n_0\
    );
\rbeats[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000FEFF"
    )
        port map (
      I0 => \rbeats[0]_i_2_n_0\,
      I1 => rbeats_reg(7),
      I2 => rbeats_reg(6),
      I3 => s_axi_arlen(0),
      I4 => rbeats_reg(0),
      O => \rbeats[0]_i_1_n_0\
    );
\rbeats[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEFF"
    )
        port map (
      I0 => s_axi_arready_INST_0_i_1_n_0,
      I1 => rbeats_reg(1),
      I2 => \^s_axi_rvalid_reg_0\,
      I3 => s_axi_arvalid,
      O => \rbeats[0]_i_2_n_0\
    );
\rbeats[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F8"
    )
        port map (
      I0 => s_axi_rready,
      I1 => \^s_axi_rvalid_reg_0\,
      I2 => s_axi_rvalid0,
      O => \rbeats[7]_i_1_n_0\
    );
\rbeats_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \rbeats[0]_i_1_n_0\,
      Q => rbeats_reg(0),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry_n_7\,
      Q => rbeats_reg(1),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry_n_6\,
      Q => rbeats_reg(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry_n_5\,
      Q => rbeats_reg(3),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry_n_4\,
      Q => rbeats_reg(4),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry__0_n_7\,
      Q => rbeats_reg(5),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry__0_n_6\,
      Q => rbeats_reg(6),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rbeats_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \rbeats[7]_i_1_n_0\,
      D => \p_0_out_inferred__0/i__carry__0_n_5\,
      Q => rbeats_reg(7),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rid_r[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \rid_r[3]_i_2_n_0\,
      I1 => rbeats_reg(4),
      I2 => rbeats_reg(5),
      I3 => rbeats_reg(2),
      I4 => rbeats_reg(3),
      O => s_axi_rvalid0
    );
\rid_r[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFEFFFFFFFF"
    )
        port map (
      I0 => rbeats_reg(0),
      I1 => rbeats_reg(6),
      I2 => rbeats_reg(7),
      I3 => rbeats_reg(1),
      I4 => \^s_axi_rvalid_reg_0\,
      I5 => s_axi_arvalid,
      O => \rid_r[3]_i_2_n_0\
    );
\rid_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => s_axi_rvalid0,
      D => s_axi_arid(0),
      Q => s_axi_rid(0),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rid_r_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => s_axi_rvalid0,
      D => s_axi_arid(1),
      Q => s_axi_rid(1),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rid_r_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => s_axi_rvalid0,
      D => s_axi_arid(2),
      Q => s_axi_rid(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\rid_r_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => s_axi_rvalid0,
      D => s_axi_arid(3),
      Q => s_axi_rid(3),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \^s_axi_rvalid_reg_0\,
      I1 => rbeats_reg(1),
      I2 => rbeats_reg(7),
      I3 => rbeats_reg(6),
      I4 => rbeats_reg(0),
      I5 => s_axi_arready_INST_0_i_1_n_0,
      O => s_axi_arready
    );
s_axi_arready_INST_0_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => rbeats_reg(3),
      I1 => rbeats_reg(2),
      I2 => rbeats_reg(5),
      I3 => rbeats_reg(4),
      O => s_axi_arready_INST_0_i_1_n_0
    );
s_axi_bvalid_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E2220000"
    )
        port map (
      I0 => \^s_axi_bvalid\,
      I1 => s_axi_bvalid_i_2_n_0,
      I2 => s_axi_wlast,
      I3 => \^s_axi_wready\,
      I4 => rst_n,
      O => s_axi_bvalid_i_1_n_0
    );
s_axi_bvalid_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF808080"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => s_axi_wvalid,
      I2 => s_axi_wlast,
      I3 => \FSM_onehot_wstate_reg_n_0_[2]\,
      I4 => s_axi_bready,
      O => s_axi_bvalid_i_2_n_0
    );
s_axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => s_axi_bvalid_i_1_n_0,
      Q => \^s_axi_bvalid\,
      R => '0'
    );
s_axi_rlast_INST_0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000010"
    )
        port map (
      I0 => rbeats_reg(6),
      I1 => rbeats_reg(7),
      I2 => rbeats_reg(0),
      I3 => rbeats_reg(1),
      I4 => s_axi_arready_INST_0_i_1_n_0,
      O => s_axi_rlast
    );
s_axi_rvalid_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFA20000"
    )
        port map (
      I0 => \^s_axi_rvalid_reg_0\,
      I1 => s_axi_rvalid_i_2_n_0,
      I2 => s_axi_arready_INST_0_i_1_n_0,
      I3 => s_axi_rvalid0,
      I4 => rst_n,
      O => s_axi_rvalid_i_1_n_0
    );
s_axi_rvalid_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \^s_axi_rvalid_reg_0\,
      I1 => s_axi_rready,
      I2 => rbeats_reg(0),
      I3 => rbeats_reg(1),
      I4 => rbeats_reg(7),
      I5 => rbeats_reg(6),
      O => s_axi_rvalid_i_2_n_0
    );
s_axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => s_axi_rvalid_i_1_n_0,
      Q => \^s_axi_rvalid_reg_0\,
      R => '0'
    );
\waddr[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(0),
      I2 => \^s_axi_wready\,
      I3 => in5(0),
      O => \waddr[0]_i_1_n_0\
    );
\waddr[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_i_1_n_0\
    );
\waddr[10]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1_n_0\
    );
\waddr[10]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1__0_n_0\
    );
\waddr[10]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1__1_n_0\
    );
\waddr[10]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1__2_n_0\
    );
\waddr[10]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1__3_n_0\
    );
\waddr[10]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1__4_n_0\
    );
\waddr[10]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(10),
      I2 => \^s_axi_wready\,
      I3 => in5(10),
      O => \waddr[10]_rep_i_1__5_n_0\
    );
\waddr[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_i_1_n_0\
    );
\waddr[11]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1_n_0\
    );
\waddr[11]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1__0_n_0\
    );
\waddr[11]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1__1_n_0\
    );
\waddr[11]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1__2_n_0\
    );
\waddr[11]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1__3_n_0\
    );
\waddr[11]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1__4_n_0\
    );
\waddr[11]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(11),
      I2 => \^s_axi_wready\,
      I3 => in5(11),
      O => \waddr[11]_rep_i_1__5_n_0\
    );
\waddr[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_i_1_n_0\
    );
\waddr[12]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1_n_0\
    );
\waddr[12]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1__0_n_0\
    );
\waddr[12]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1__1_n_0\
    );
\waddr[12]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1__2_n_0\
    );
\waddr[12]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1__3_n_0\
    );
\waddr[12]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1__4_n_0\
    );
\waddr[12]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(12),
      I2 => \^s_axi_wready\,
      I3 => in5(12),
      O => \waddr[12]_rep_i_1__5_n_0\
    );
\waddr[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_i_1_n_0\
    );
\waddr[13]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1_n_0\
    );
\waddr[13]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1__0_n_0\
    );
\waddr[13]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1__1_n_0\
    );
\waddr[13]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1__2_n_0\
    );
\waddr[13]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1__3_n_0\
    );
\waddr[13]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1__4_n_0\
    );
\waddr[13]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(13),
      I2 => \^s_axi_wready\,
      I3 => in5(13),
      O => \waddr[13]_rep_i_1__5_n_0\
    );
\waddr[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_i_1_n_0\
    );
\waddr[14]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1_n_0\
    );
\waddr[14]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1__0_n_0\
    );
\waddr[14]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1__1_n_0\
    );
\waddr[14]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1__2_n_0\
    );
\waddr[14]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1__3_n_0\
    );
\waddr[14]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1__4_n_0\
    );
\waddr[14]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(14),
      I2 => \^s_axi_wready\,
      I3 => in5(14),
      O => \waddr[14]_rep_i_1__5_n_0\
    );
\waddr[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_i_1_n_0\
    );
\waddr[15]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1_n_0\
    );
\waddr[15]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1__0_n_0\
    );
\waddr[15]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1__1_n_0\
    );
\waddr[15]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1__2_n_0\
    );
\waddr[15]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1__3_n_0\
    );
\waddr[15]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1__4_n_0\
    );
\waddr[15]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(15),
      I2 => \^s_axi_wready\,
      I3 => in5(15),
      O => \waddr[15]_rep_i_1__5_n_0\
    );
\waddr[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_i_1_n_0\
    );
\waddr[16]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1_n_0\
    );
\waddr[16]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1__0_n_0\
    );
\waddr[16]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1__1_n_0\
    );
\waddr[16]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1__2_n_0\
    );
\waddr[16]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1__3_n_0\
    );
\waddr[16]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1__4_n_0\
    );
\waddr[16]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(16),
      I2 => \^s_axi_wready\,
      I3 => in5(16),
      O => \waddr[16]_rep_i_1__5_n_0\
    );
\waddr[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFF8888888888888"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => \^s_axi_awready\,
      I2 => wburst(0),
      I3 => wburst(1),
      I4 => \^s_axi_wready\,
      I5 => s_axi_wvalid,
      O => waddr(0)
    );
\waddr[17]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_i_2_n_0\
    );
\waddr[17]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1_n_0\
    );
\waddr[17]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1__0_n_0\
    );
\waddr[17]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1__1_n_0\
    );
\waddr[17]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1__2_n_0\
    );
\waddr[17]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1__3_n_0\
    );
\waddr[17]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1__4_n_0\
    );
\waddr[17]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(17),
      I2 => \^s_axi_wready\,
      I3 => in5(17),
      O => \waddr[17]_rep_i_1__5_n_0\
    );
\waddr[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(1),
      I2 => \^s_axi_wready\,
      I3 => in5(1),
      O => \waddr[1]_i_1_n_0\
    );
\waddr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(2),
      I2 => \^s_axi_wready\,
      I3 => in5(2),
      O => \waddr[2]_i_1_n_0\
    );
\waddr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(3),
      I2 => \^s_axi_wready\,
      I3 => in5(3),
      O => \waddr[3]_i_1_n_0\
    );
\waddr[3]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AA6A"
    )
        port map (
      I0 => \p_0_in__0\(3),
      I1 => wsize(0),
      I2 => wsize(1),
      I3 => wsize(2),
      O => \waddr[3]_i_3_n_0\
    );
\waddr[3]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AA9A"
    )
        port map (
      I0 => \p_0_in__0\(2),
      I1 => wsize(0),
      I2 => wsize(1),
      I3 => wsize(2),
      O => \waddr[3]_i_4_n_0\
    );
\waddr[3]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAA6"
    )
        port map (
      I0 => \waddr_reg_n_0_[1]\,
      I1 => wsize(0),
      I2 => wsize(1),
      I3 => wsize(2),
      O => \waddr[3]_i_5_n_0\
    );
\waddr[3]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAA9"
    )
        port map (
      I0 => \waddr_reg_n_0_[0]\,
      I1 => wsize(0),
      I2 => wsize(1),
      I3 => wsize(2),
      O => \waddr[3]_i_6_n_0\
    );
\waddr[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(4),
      I2 => \^s_axi_wready\,
      I3 => in5(4),
      O => \waddr[4]_i_1_n_0\
    );
\waddr[4]_rep__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(4),
      I2 => \^s_axi_wready\,
      I3 => in5(4),
      O => \waddr[4]_rep__0_i_1_n_0\
    );
\waddr[4]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(4),
      I2 => \^s_axi_wready\,
      I3 => in5(4),
      O => \waddr[4]_rep_i_1_n_0\
    );
\waddr[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(5),
      I2 => \^s_axi_wready\,
      I3 => in5(5),
      O => \waddr[5]_i_1_n_0\
    );
\waddr[5]_rep__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(5),
      I2 => \^s_axi_wready\,
      I3 => in5(5),
      O => \waddr[5]_rep__0_i_1_n_0\
    );
\waddr[5]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(5),
      I2 => \^s_axi_wready\,
      I3 => in5(5),
      O => \waddr[5]_rep_i_1_n_0\
    );
\waddr[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(6),
      I2 => \^s_axi_wready\,
      I3 => in5(6),
      O => \waddr[6]_i_1_n_0\
    );
\waddr[6]_rep__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(6),
      I2 => \^s_axi_wready\,
      I3 => in5(6),
      O => \waddr[6]_rep__0_i_1_n_0\
    );
\waddr[6]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(6),
      I2 => \^s_axi_wready\,
      I3 => in5(6),
      O => \waddr[6]_rep_i_1_n_0\
    );
\waddr[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(7),
      I2 => \^s_axi_wready\,
      I3 => in5(7),
      O => \waddr[7]_i_1_n_0\
    );
\waddr[7]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => wr_word(3),
      I1 => wsize(0),
      I2 => wsize(1),
      I3 => wsize(2),
      O => \waddr[7]_i_3_n_0\
    );
\waddr[7]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9AAA"
    )
        port map (
      I0 => wr_word(2),
      I1 => wsize(0),
      I2 => wsize(1),
      I3 => wsize(2),
      O => \waddr[7]_i_4_n_0\
    );
\waddr[7]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AA6A"
    )
        port map (
      I0 => wr_word(1),
      I1 => wsize(0),
      I2 => wsize(2),
      I3 => wsize(1),
      O => \waddr[7]_i_5_n_0\
    );
\waddr[7]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AA9A"
    )
        port map (
      I0 => wr_word(0),
      I1 => wsize(0),
      I2 => wsize(2),
      I3 => wsize(1),
      O => \waddr[7]_i_6_n_0\
    );
\waddr[7]_rep__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(7),
      I2 => \^s_axi_wready\,
      I3 => in5(7),
      O => \waddr[7]_rep__0_i_1_n_0\
    );
\waddr[7]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(7),
      I2 => \^s_axi_wready\,
      I3 => in5(7),
      O => \waddr[7]_rep_i_1_n_0\
    );
\waddr[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_i_1_n_0\
    );
\waddr[8]_rep__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep__0_i_1_n_0\
    );
\waddr[8]_rep__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep__1_i_1_n_0\
    );
\waddr[8]_rep__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep__2_i_1_n_0\
    );
\waddr[8]_rep__3_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep__3_i_1_n_0\
    );
\waddr[8]_rep__4_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep__4_i_1_n_0\
    );
\waddr[8]_rep__5_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep__5_i_1_n_0\
    );
\waddr[8]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(8),
      I2 => \^s_axi_wready\,
      I3 => in5(8),
      O => \waddr[8]_rep_i_1_n_0\
    );
\waddr[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_i_1_n_0\
    );
\waddr[9]_rep_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1_n_0\
    );
\waddr[9]_rep_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1__0_n_0\
    );
\waddr[9]_rep_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1__1_n_0\
    );
\waddr[9]_rep_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1__2_n_0\
    );
\waddr[9]_rep_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1__3_n_0\
    );
\waddr[9]_rep_i_1__4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1__4_n_0\
    );
\waddr[9]_rep_i_1__5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awaddr(9),
      I2 => \^s_axi_wready\,
      I3 => in5(9),
      O => \waddr[9]_rep_i_1__5_n_0\
    );
\waddr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[0]_i_1_n_0\,
      Q => \waddr_reg_n_0_[0]\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_i_1_n_0\,
      Q => wr_word(6),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1_n_0\,
      Q => \waddr_reg[10]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1__0_n_0\,
      Q => \waddr_reg[10]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1__1_n_0\,
      Q => \waddr_reg[10]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1__2_n_0\,
      Q => \waddr_reg[10]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1__3_n_0\,
      Q => \waddr_reg[10]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1__4_n_0\,
      Q => \waddr_reg[10]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[10]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[10]_rep_i_1__5_n_0\,
      Q => \waddr_reg[10]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_i_1_n_0\,
      Q => wr_word(7),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \waddr_reg[7]_i_2_n_0\,
      CO(3) => \waddr_reg[11]_i_2_n_0\,
      CO(2) => \waddr_reg[11]_i_2_n_1\,
      CO(1) => \waddr_reg[11]_i_2_n_2\,
      CO(0) => \waddr_reg[11]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => in5(11 downto 8),
      S(3 downto 0) => wr_word(7 downto 4)
    );
\waddr_reg[11]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1_n_0\,
      Q => \waddr_reg[11]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1__0_n_0\,
      Q => \waddr_reg[11]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1__1_n_0\,
      Q => \waddr_reg[11]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1__2_n_0\,
      Q => \waddr_reg[11]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1__3_n_0\,
      Q => \waddr_reg[11]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1__4_n_0\,
      Q => \waddr_reg[11]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[11]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[11]_rep_i_1__5_n_0\,
      Q => \waddr_reg[11]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_i_1_n_0\,
      Q => wr_word(8),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1_n_0\,
      Q => \waddr_reg[12]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1__0_n_0\,
      Q => \waddr_reg[12]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1__1_n_0\,
      Q => \waddr_reg[12]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1__2_n_0\,
      Q => \waddr_reg[12]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1__3_n_0\,
      Q => \waddr_reg[12]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1__4_n_0\,
      Q => \waddr_reg[12]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[12]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[12]_rep_i_1__5_n_0\,
      Q => \waddr_reg[12]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_i_1_n_0\,
      Q => wr_word(9),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1_n_0\,
      Q => \waddr_reg[13]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1__0_n_0\,
      Q => \waddr_reg[13]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1__1_n_0\,
      Q => \waddr_reg[13]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1__2_n_0\,
      Q => \waddr_reg[13]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1__3_n_0\,
      Q => \waddr_reg[13]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1__4_n_0\,
      Q => \waddr_reg[13]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[13]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[13]_rep_i_1__5_n_0\,
      Q => \waddr_reg[13]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_i_1_n_0\,
      Q => wr_word(10),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1_n_0\,
      Q => \waddr_reg[14]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1__0_n_0\,
      Q => \waddr_reg[14]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1__1_n_0\,
      Q => \waddr_reg[14]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1__2_n_0\,
      Q => \waddr_reg[14]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1__3_n_0\,
      Q => \waddr_reg[14]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1__4_n_0\,
      Q => \waddr_reg[14]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[14]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[14]_rep_i_1__5_n_0\,
      Q => \waddr_reg[14]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_i_1_n_0\,
      Q => wr_word(11),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \waddr_reg[11]_i_2_n_0\,
      CO(3) => \waddr_reg[15]_i_2_n_0\,
      CO(2) => \waddr_reg[15]_i_2_n_1\,
      CO(1) => \waddr_reg[15]_i_2_n_2\,
      CO(0) => \waddr_reg[15]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => in5(15 downto 12),
      S(3 downto 0) => wr_word(11 downto 8)
    );
\waddr_reg[15]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1_n_0\,
      Q => \waddr_reg[15]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1__0_n_0\,
      Q => \waddr_reg[15]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1__1_n_0\,
      Q => \waddr_reg[15]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1__2_n_0\,
      Q => \waddr_reg[15]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1__3_n_0\,
      Q => \waddr_reg[15]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1__4_n_0\,
      Q => \waddr_reg[15]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[15]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[15]_rep_i_1__5_n_0\,
      Q => \waddr_reg[15]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_i_1_n_0\,
      Q => wr_word(12),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1_n_0\,
      Q => \waddr_reg[16]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1__0_n_0\,
      Q => \waddr_reg[16]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1__1_n_0\,
      Q => \waddr_reg[16]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1__2_n_0\,
      Q => \waddr_reg[16]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1__3_n_0\,
      Q => \waddr_reg[16]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1__4_n_0\,
      Q => \waddr_reg[16]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[16]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[16]_rep_i_1__5_n_0\,
      Q => \waddr_reg[16]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_i_2_n_0\,
      Q => wr_word(13),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => \waddr_reg[15]_i_2_n_0\,
      CO(3 downto 1) => \NLW_waddr_reg[17]_i_3_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \waddr_reg[17]_i_3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 2) => \NLW_waddr_reg[17]_i_3_O_UNCONNECTED\(3 downto 2),
      O(1 downto 0) => in5(17 downto 16),
      S(3 downto 2) => B"00",
      S(1 downto 0) => wr_word(13 downto 12)
    );
\waddr_reg[17]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1_n_0\,
      Q => \waddr_reg[17]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1__0_n_0\,
      Q => \waddr_reg[17]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1__1_n_0\,
      Q => \waddr_reg[17]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1__2_n_0\,
      Q => \waddr_reg[17]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1__3_n_0\,
      Q => \waddr_reg[17]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1__4_n_0\,
      Q => \waddr_reg[17]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[17]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[17]_rep_i_1__5_n_0\,
      Q => \waddr_reg[17]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[1]_i_1_n_0\,
      Q => \waddr_reg_n_0_[1]\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[2]_i_1_n_0\,
      Q => \p_0_in__0\(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[3]_i_1_n_0\,
      Q => \p_0_in__0\(3),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[3]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \waddr_reg[3]_i_2_n_0\,
      CO(2) => \waddr_reg[3]_i_2_n_1\,
      CO(1) => \waddr_reg[3]_i_2_n_2\,
      CO(0) => \waddr_reg[3]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => \p_0_in__0\(3 downto 2),
      DI(1) => \waddr_reg_n_0_[1]\,
      DI(0) => \waddr_reg_n_0_[0]\,
      O(3 downto 0) => in5(3 downto 0),
      S(3) => \waddr[3]_i_3_n_0\,
      S(2) => \waddr[3]_i_4_n_0\,
      S(1) => \waddr[3]_i_5_n_0\,
      S(0) => \waddr[3]_i_6_n_0\
    );
\waddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[4]_i_1_n_0\,
      Q => wr_word(0),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[4]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[4]_rep_i_1_n_0\,
      Q => \waddr_reg[4]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[4]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[4]_rep__0_i_1_n_0\,
      Q => \waddr_reg[4]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[5]_i_1_n_0\,
      Q => wr_word(1),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[5]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[5]_rep_i_1_n_0\,
      Q => \waddr_reg[5]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[5]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[5]_rep__0_i_1_n_0\,
      Q => \waddr_reg[5]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[6]_i_1_n_0\,
      Q => wr_word(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[6]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[6]_rep_i_1_n_0\,
      Q => \waddr_reg[6]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[6]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[6]_rep__0_i_1_n_0\,
      Q => \waddr_reg[6]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[7]_i_1_n_0\,
      Q => wr_word(3),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[7]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \waddr_reg[3]_i_2_n_0\,
      CO(3) => \waddr_reg[7]_i_2_n_0\,
      CO(2) => \waddr_reg[7]_i_2_n_1\,
      CO(1) => \waddr_reg[7]_i_2_n_2\,
      CO(0) => \waddr_reg[7]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => wr_word(3 downto 0),
      O(3 downto 0) => in5(7 downto 4),
      S(3) => \waddr[7]_i_3_n_0\,
      S(2) => \waddr[7]_i_4_n_0\,
      S(1) => \waddr[7]_i_5_n_0\,
      S(0) => \waddr[7]_i_6_n_0\
    );
\waddr_reg[7]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[7]_rep_i_1_n_0\,
      Q => \waddr_reg[7]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[7]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[7]_rep__0_i_1_n_0\,
      Q => \waddr_reg[7]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_i_1_n_0\,
      Q => wr_word(4),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep_i_1_n_0\,
      Q => \waddr_reg[8]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep__0_i_1_n_0\,
      Q => \waddr_reg[8]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep__1_i_1_n_0\,
      Q => \waddr_reg[8]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep__2_i_1_n_0\,
      Q => \waddr_reg[8]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep__3_i_1_n_0\,
      Q => \waddr_reg[8]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep__4_i_1_n_0\,
      Q => \waddr_reg[8]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[8]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[8]_rep__5_i_1_n_0\,
      Q => \waddr_reg[8]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_i_1_n_0\,
      Q => wr_word(5),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1_n_0\,
      Q => \waddr_reg[9]_rep_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep__0\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1__0_n_0\,
      Q => \waddr_reg[9]_rep__0_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep__1\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1__1_n_0\,
      Q => \waddr_reg[9]_rep__1_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep__2\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1__2_n_0\,
      Q => \waddr_reg[9]_rep__2_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep__3\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1__3_n_0\,
      Q => \waddr_reg[9]_rep__3_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep__4\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1__4_n_0\,
      Q => \waddr_reg[9]_rep__4_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\waddr_reg[9]_rep__5\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => waddr(0),
      D => \waddr[9]_rep_i_1__5_n_0\,
      Q => \waddr_reg[9]_rep__5_n_0\,
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wburst_reg[0]\: unisim.vcomponents.FDSE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awburst(0),
      Q => wburst(0),
      S => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wburst_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awburst(1),
      Q => wburst(1),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wid[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^s_axi_awready\,
      I1 => s_axi_awvalid,
      O => wid(0)
    );
\wid_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awid(0),
      Q => s_axi_bid(0),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wid_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awid(1),
      Q => s_axi_bid(1),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wid_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awid(2),
      Q => s_axi_bid(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wid_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awid(3),
      Q => s_axi_bid(3),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wsize_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awsize(0),
      Q => wsize(0),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wsize_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awsize(1),
      Q => wsize(1),
      S => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wsize_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wid(0),
      D => s_axi_awsize(2),
      Q => wsize(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wstate[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_0_in(2),
      I1 => p_0_in(3),
      O => \wstate[0]_i_1_n_0\
    );
\wstate[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => p_0_in(2),
      I1 => p_0_in(3),
      O => \wstate[1]_i_1_n_0\
    );
\wstate_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wstate(0),
      D => \wstate[0]_i_1_n_0\,
      Q => p_0_in(2),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
\wstate_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => wstate(0),
      D => \wstate[1]_i_1_n_0\,
      Q => p_0_in(3),
      R => \FSM_onehot_wstate[0]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity arty_ddr_weight_bram_0_0 is
  port (
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 17 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC;
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 17 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC;
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    w_word_addr : in STD_LOGIC_VECTOR ( 13 downto 0 );
    w_word : out STD_LOGIC_VECTOR ( 127 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of arty_ddr_weight_bram_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of arty_ddr_weight_bram_0_0 : entity is "arty_ddr_weight_bram_0_0,weight_bram128,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of arty_ddr_weight_bram_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of arty_ddr_weight_bram_0_0 : entity is "package_project";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of arty_ddr_weight_bram_0_0 : entity is "weight_bram128,Vivado 2025.2";
end arty_ddr_weight_bram_0_0;

architecture STRUCTURE of arty_ddr_weight_bram_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF s_axi, FREQ_HZ 81247969, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rst_n : signal is "xilinx.com:signal:reset:1.0 rst_n RST";
  attribute X_INTERFACE_MODE of rst_n : signal is "slave";
  attribute X_INTERFACE_PARAMETER of rst_n : signal is "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_arlock : signal is "xilinx.com:interface:aximm:1.0 s_axi ARLOCK";
  attribute X_INTERFACE_INFO of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 s_axi ARREADY";
  attribute X_INTERFACE_INFO of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi ARVALID";
  attribute X_INTERFACE_INFO of s_axi_awlock : signal is "xilinx.com:interface:aximm:1.0 s_axi AWLOCK";
  attribute X_INTERFACE_INFO of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 s_axi AWREADY";
  attribute X_INTERFACE_INFO of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi AWVALID";
  attribute X_INTERFACE_INFO of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 s_axi BREADY";
  attribute X_INTERFACE_INFO of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi BVALID";
  attribute X_INTERFACE_INFO of s_axi_rlast : signal is "xilinx.com:interface:aximm:1.0 s_axi RLAST";
  attribute X_INTERFACE_INFO of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 s_axi RREADY";
  attribute X_INTERFACE_INFO of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi RVALID";
  attribute X_INTERFACE_INFO of s_axi_wlast : signal is "xilinx.com:interface:aximm:1.0 s_axi WLAST";
  attribute X_INTERFACE_INFO of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 s_axi WREADY";
  attribute X_INTERFACE_INFO of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi WVALID";
  attribute X_INTERFACE_INFO of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 s_axi ARADDR";
  attribute X_INTERFACE_INFO of s_axi_arburst : signal is "xilinx.com:interface:aximm:1.0 s_axi ARBURST";
  attribute X_INTERFACE_INFO of s_axi_arcache : signal is "xilinx.com:interface:aximm:1.0 s_axi ARCACHE";
  attribute X_INTERFACE_INFO of s_axi_arid : signal is "xilinx.com:interface:aximm:1.0 s_axi ARID";
  attribute X_INTERFACE_INFO of s_axi_arlen : signal is "xilinx.com:interface:aximm:1.0 s_axi ARLEN";
  attribute X_INTERFACE_INFO of s_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 s_axi ARPROT";
  attribute X_INTERFACE_INFO of s_axi_arqos : signal is "xilinx.com:interface:aximm:1.0 s_axi ARQOS";
  attribute X_INTERFACE_INFO of s_axi_arsize : signal is "xilinx.com:interface:aximm:1.0 s_axi ARSIZE";
  attribute X_INTERFACE_INFO of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 s_axi AWADDR";
  attribute X_INTERFACE_INFO of s_axi_awburst : signal is "xilinx.com:interface:aximm:1.0 s_axi AWBURST";
  attribute X_INTERFACE_INFO of s_axi_awcache : signal is "xilinx.com:interface:aximm:1.0 s_axi AWCACHE";
  attribute X_INTERFACE_INFO of s_axi_awid : signal is "xilinx.com:interface:aximm:1.0 s_axi AWID";
  attribute X_INTERFACE_MODE of s_axi_awid : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_awid : signal is "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 81247969, ID_WIDTH 4, ADDR_WIDTH 18, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0, CLK_DOMAIN arty_ddr_mig_7series_0_0_ui_clk, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_awlen : signal is "xilinx.com:interface:aximm:1.0 s_axi AWLEN";
  attribute X_INTERFACE_INFO of s_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 s_axi AWPROT";
  attribute X_INTERFACE_INFO of s_axi_awqos : signal is "xilinx.com:interface:aximm:1.0 s_axi AWQOS";
  attribute X_INTERFACE_INFO of s_axi_awsize : signal is "xilinx.com:interface:aximm:1.0 s_axi AWSIZE";
  attribute X_INTERFACE_INFO of s_axi_bid : signal is "xilinx.com:interface:aximm:1.0 s_axi BID";
  attribute X_INTERFACE_INFO of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 s_axi BRESP";
  attribute X_INTERFACE_INFO of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 s_axi RDATA";
  attribute X_INTERFACE_INFO of s_axi_rid : signal is "xilinx.com:interface:aximm:1.0 s_axi RID";
  attribute X_INTERFACE_INFO of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 s_axi RRESP";
  attribute X_INTERFACE_INFO of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 s_axi WDATA";
  attribute X_INTERFACE_INFO of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 s_axi WSTRB";
begin
  s_axi_bresp(1) <= \<const0>\;
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rdata(31) <= \<const1>\;
  s_axi_rdata(30) <= \<const1>\;
  s_axi_rdata(29) <= \<const0>\;
  s_axi_rdata(28) <= \<const1>\;
  s_axi_rdata(27) <= \<const1>\;
  s_axi_rdata(26) <= \<const1>\;
  s_axi_rdata(25) <= \<const1>\;
  s_axi_rdata(24) <= \<const0>\;
  s_axi_rdata(23) <= \<const1>\;
  s_axi_rdata(22) <= \<const0>\;
  s_axi_rdata(21) <= \<const1>\;
  s_axi_rdata(20) <= \<const0>\;
  s_axi_rdata(19) <= \<const1>\;
  s_axi_rdata(18) <= \<const1>\;
  s_axi_rdata(17) <= \<const0>\;
  s_axi_rdata(16) <= \<const1>\;
  s_axi_rdata(15) <= \<const1>\;
  s_axi_rdata(14) <= \<const0>\;
  s_axi_rdata(13) <= \<const1>\;
  s_axi_rdata(12) <= \<const1>\;
  s_axi_rdata(11) <= \<const1>\;
  s_axi_rdata(10) <= \<const1>\;
  s_axi_rdata(9) <= \<const1>\;
  s_axi_rdata(8) <= \<const0>\;
  s_axi_rdata(7) <= \<const1>\;
  s_axi_rdata(6) <= \<const1>\;
  s_axi_rdata(5) <= \<const1>\;
  s_axi_rdata(4) <= \<const0>\;
  s_axi_rdata(3) <= \<const1>\;
  s_axi_rdata(2) <= \<const1>\;
  s_axi_rdata(1) <= \<const1>\;
  s_axi_rdata(0) <= \<const1>\;
  s_axi_rresp(1) <= \<const0>\;
  s_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.arty_ddr_weight_bram_0_0_weight_bram128
     port map (
      clk => clk,
      rst_n => rst_n,
      s_axi_arid(3 downto 0) => s_axi_arid(3 downto 0),
      s_axi_arlen(7 downto 0) => s_axi_arlen(7 downto 0),
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(17 downto 0) => s_axi_awaddr(17 downto 0),
      s_axi_awburst(1 downto 0) => s_axi_awburst(1 downto 0),
      s_axi_awid(3 downto 0) => s_axi_awid(3 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awsize(2 downto 0) => s_axi_awsize(2 downto 0),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bid(3 downto 0) => s_axi_bid(3 downto 0),
      s_axi_bready => s_axi_bready,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_rid(3 downto 0) => s_axi_rid(3 downto 0),
      s_axi_rlast => s_axi_rlast,
      s_axi_rready => s_axi_rready,
      s_axi_rvalid_reg_0 => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wlast => s_axi_wlast,
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid,
      w_word(127 downto 0) => w_word(127 downto 0),
      w_word_addr(13 downto 0) => w_word_addr(13 downto 0)
    );
end STRUCTURE;
