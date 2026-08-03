-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- -------------------------------------------------------------------------------
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-- DO NOT MODIFY THIS FILE.

-- MODULE VLNV: amd.com:blockdesign:arty_ddr:1.0

-- The following code must appear in the VHDL architecture header.

-- COMP_TAG     ------ Begin cut for COMPONENT Declaration ------
COMPONENT arty_ddr
  PORT (
    DDR3_0_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DDR3_0_dqs_p : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DDR3_0_dqs_n : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DDR3_0_addr : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
    DDR3_0_ba : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    DDR3_0_ras_n : OUT STD_LOGIC;
    DDR3_0_cas_n : OUT STD_LOGIC;
    DDR3_0_we_n : OUT STD_LOGIC;
    DDR3_0_reset_n : OUT STD_LOGIC;
    DDR3_0_ck_p : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    DDR3_0_ck_n : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    DDR3_0_cke : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    DDR3_0_cs_n : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    DDR3_0_dm : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DDR3_0_odt : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    eth_mdio_mdc : OUT STD_LOGIC;
    eth_mdio_mdio_i : IN STD_LOGIC;
    eth_mdio_mdio_o : OUT STD_LOGIC;
    eth_mdio_mdio_t : OUT STD_LOGIC;
    UART_0_baudoutn : OUT STD_LOGIC;
    UART_0_ctsn : IN STD_LOGIC;
    UART_0_dcdn : IN STD_LOGIC;
    UART_0_ddis : OUT STD_LOGIC;
    UART_0_dsrn : IN STD_LOGIC;
    UART_0_dtrn : OUT STD_LOGIC;
    UART_0_out1n : OUT STD_LOGIC;
    UART_0_out2n : OUT STD_LOGIC;
    UART_0_ri : IN STD_LOGIC;
    UART_0_rtsn : OUT STD_LOGIC;
    UART_0_rxd : IN STD_LOGIC;
    UART_0_rxrdyn : OUT STD_LOGIC;
    UART_0_txd : OUT STD_LOGIC;
    UART_0_txrdyn : OUT STD_LOGIC;
    sys_clk : IN STD_LOGIC;
    sys_rst_n : IN STD_LOGIC;
    eth_tx_clk : IN STD_LOGIC;
    eth_rx_clk : IN STD_LOGIC;
    eth_crs : IN STD_LOGIC;
    eth_col : IN STD_LOGIC;
    eth_rx_dv : IN STD_LOGIC;
    eth_rxd : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    eth_rxerr : IN STD_LOGIC;
    eth_tx_en : OUT STD_LOGIC;
    eth_txd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    eth_rstn : OUT STD_LOGIC;
    eth_ref_clk : OUT STD_LOGIC;
    gpio_io_o_0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------  End cut for COMPONENT Declaration  ------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

-- INST_TAG     ------ Begin cut for INSTANTIATION Template ------
your_instance_name : arty_ddr
  PORT MAP (
    DDR3_0_dq => DDR3_0_dq,
    DDR3_0_dqs_p => DDR3_0_dqs_p,
    DDR3_0_dqs_n => DDR3_0_dqs_n,
    DDR3_0_addr => DDR3_0_addr,
    DDR3_0_ba => DDR3_0_ba,
    DDR3_0_ras_n => DDR3_0_ras_n,
    DDR3_0_cas_n => DDR3_0_cas_n,
    DDR3_0_we_n => DDR3_0_we_n,
    DDR3_0_reset_n => DDR3_0_reset_n,
    DDR3_0_ck_p => DDR3_0_ck_p,
    DDR3_0_ck_n => DDR3_0_ck_n,
    DDR3_0_cke => DDR3_0_cke,
    DDR3_0_cs_n => DDR3_0_cs_n,
    DDR3_0_dm => DDR3_0_dm,
    DDR3_0_odt => DDR3_0_odt,
    eth_mdio_mdc => eth_mdio_mdc,
    eth_mdio_mdio_i => eth_mdio_mdio_i,
    eth_mdio_mdio_o => eth_mdio_mdio_o,
    eth_mdio_mdio_t => eth_mdio_mdio_t,
    UART_0_baudoutn => UART_0_baudoutn,
    UART_0_ctsn => UART_0_ctsn,
    UART_0_dcdn => UART_0_dcdn,
    UART_0_ddis => UART_0_ddis,
    UART_0_dsrn => UART_0_dsrn,
    UART_0_dtrn => UART_0_dtrn,
    UART_0_out1n => UART_0_out1n,
    UART_0_out2n => UART_0_out2n,
    UART_0_ri => UART_0_ri,
    UART_0_rtsn => UART_0_rtsn,
    UART_0_rxd => UART_0_rxd,
    UART_0_rxrdyn => UART_0_rxrdyn,
    UART_0_txd => UART_0_txd,
    UART_0_txrdyn => UART_0_txrdyn,
    sys_clk => sys_clk,
    sys_rst_n => sys_rst_n,
    eth_tx_clk => eth_tx_clk,
    eth_rx_clk => eth_rx_clk,
    eth_crs => eth_crs,
    eth_col => eth_col,
    eth_rx_dv => eth_rx_dv,
    eth_rxd => eth_rxd,
    eth_rxerr => eth_rxerr,
    eth_tx_en => eth_tx_en,
    eth_txd => eth_txd,
    eth_rstn => eth_rstn,
    eth_ref_clk => eth_ref_clk,
    gpio_io_o_0 => gpio_io_o_0
  );
-- INST_TAG_END ------  End cut for INSTANTIATION Template  ------

-- You must compile the wrapper file arty_ddr.vhd when simulating
-- the module, arty_ddr. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.
