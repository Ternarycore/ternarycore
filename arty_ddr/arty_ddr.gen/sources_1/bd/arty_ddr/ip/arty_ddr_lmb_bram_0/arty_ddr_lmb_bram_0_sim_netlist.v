// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Sun Aug  2 11:17:05 2026
// Host        : fort-silicon running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/yoda/hwsw/tcore/tc-arty/arty_ddr/arty_ddr.gen/sources_1/bd/arty_ddr/ip/arty_ddr_lmb_bram_0/arty_ddr_lmb_bram_0_sim_netlist.v
// Design      : arty_ddr_lmb_bram_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "arty_ddr_lmb_bram_0,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module arty_ddr_lmb_bram_0
   (clka,
    rsta,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    web,
    addrb,
    dinb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [3:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [31:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [31:0]addra;
  wire [31:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire rsta;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [3:0]wea;
  wire [3:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.7492 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "arty_ddr_lmb_bram_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "1" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  arty_ddr_lmb_bram_0_blk_mem_gen_v8_4_12 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[12:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addrb[12:2],1'b0,1'b0}),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 61248)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
