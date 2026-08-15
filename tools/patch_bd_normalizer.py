#!/usr/bin/env python3
"""patch_bd_normalizer.py -- put the fabric normalizer in the block design.

Two masters need to reach it: the MicroBlaze for the control registers,
and the CDMA for x, g and the int8 result. That is exactly the situation
weight_bram is in, and the topology it ended up with was not arrived at
by taste -- it is what two shipped bitstreams cost.

Build 12 routed the CDMA to weight_bram through axi_smc, which handed the
MicroBlaze a *second* path to the same memory. Vivado bound the CPU
segment to that path; the CPU sends non-cacheable addresses out the other
port, which had no decode; every weight write was silently dropped and
the array computed zeros. Build 13 used an axi_interconnect for the
merge, and Vivado would not propagate reachability through its second
slave port, so the CDMA had no route at all.

The answer both times was a private SmartConnect in front of the slave
with exactly one route per master. So the normalizer gets norm_ic, the
same way weight_bram has bram_ic:

    periph  M06 ---.
                    >--- norm_ic ---> rmsnorm_quant_axi
    cdma_ic M02 ---'

and the address map is asserted for both masters rather than assumed,
because the failure mode here is a build that reports zero errors.

  python tools/patch_bd_normalizer.py
"""
import os
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
bd = os.path.join(root, "Arty7", "create_bd_ddr.tcl")
eth = os.path.join(root, "Arty7", "eth_dma_block.tcl")

s_bd = open(bd).read()
s_eth = open(eth).read()

if "rmsnorm" in s_bd or "rmsnorm" in s_eth:
    sys.exit("already patched")

# ---- 1. the IP is in the catalog -------------------------------------
OLD_REPO = """    [file join $repo_root ip weight_bram128] \\
    [file join $repo_root ip axi_gemm_stream] \\"""
NEW_REPO = """    [file join $repo_root ip weight_bram128] \\
    [file join $repo_root ip axi_gemm_stream] \\
    [file join $repo_root ip rmsnorm_quant] \\"""

# ---- 2. one more peripheral master, and its clock ---------------------
OLD_NMI = "set_property CONFIG.NUM_MI {6} [get_bd_cells periph]"
NEW_NMI = "set_property CONFIG.NUM_MI {7} [get_bd_cells periph]"

OLD_CLK = """connect_bd_net $UICLK [get_bd_pins periph/M04_ACLK] [get_bd_pins periph/M05_ACLK]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] \\
    [get_bd_pins periph/M04_ARESETN] [get_bd_pins periph/M05_ARESETN]"""
NEW_CLK = """connect_bd_net $UICLK [get_bd_pins periph/M04_ACLK] \\
    [get_bd_pins periph/M05_ACLK] [get_bd_pins periph/M06_ACLK]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] \\
    [get_bd_pins periph/M04_ARESETN] [get_bd_pins periph/M05_ARESETN] \\
    [get_bd_pins periph/M06_ARESETN]"""

# ---- 3. the normalizer, behind its own private merge ------------------
OLD_CDMA_IC = """set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] [get_bd_cells cdma_ic]"""
NEW_CDMA_IC = """set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {3}] [get_bd_cells cdma_ic]"""

ANCHOR_ETH = """# ── EthernetLite (MII to the DP83848) ─────────────────────────────────"""

NORM_BLOCK = """# ── fabric RMSNorm + int8 quantizer ───────────────────────────────────
# Same topology as weight_bram, for the same reason. Two masters reach it
# -- the MicroBlaze for control, the CDMA for the vectors -- and giving
# either of them a second route is precisely what made build 12 compute
# zeros while reporting success. norm_ic is a private merge: one route per
# master, and the address map asserted below rather than assumed.
create_bd_cell -type ip -vlnv shepherdscientific.com:user:rmsnorm_quant_axi:1.0 rmsnorm_0
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 norm_ic
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1}] [get_bd_cells norm_ic]
connect_bd_net $UICLK [get_bd_pins norm_ic/aclk] [get_bd_pins rmsnorm_0/clk]
connect_bd_net [get_bd_pins rst_ui/peripheral_aresetn] \\
    [get_bd_pins norm_ic/aresetn] [get_bd_pins rmsnorm_0/rst_n]
connect_bd_intf_net [get_bd_intf_pins periph/M06_AXI]  [get_bd_intf_pins norm_ic/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins cdma_ic/M02_AXI] [get_bd_intf_pins norm_ic/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins norm_ic/M00_AXI] [get_bd_intf_pins rmsnorm_0/s_axi]

""" + ANCHOR_ETH

# ---- 4. address map, asserted for both masters ------------------------
OLD_OK = 'puts "ADDRMAP OK: microblaze + cdma both reach weight_bram @ 0x44100000"'
NEW_OK = OLD_OK + """

# The same assertion for the normalizer. A missing segment here is not a
# build error -- it is a DECERR at run time on a bus nobody is checking,
# which is how build 12 and build 13 both shipped.
catch {assign_bd_address -target_address_space /microblaze_0/Data -offset 0x44400000 -range 128K [get_bd_addr_segs rmsnorm_0/s_axi/reg0]}
catch {assign_bd_address -target_address_space /axi_cdma_0/Data  -offset 0x44400000 -range 128K [get_bd_addr_segs rmsnorm_0/s_axi/reg0]}
catch {include_bd_addr_seg [get_bd_addr_segs -quiet -excluded axi_cdma_0/Data/SEG_rmsnorm_0_reg0]}
catch {include_bd_addr_seg [get_bd_addr_segs -quiet -excluded microblaze_0/Data/SEG_rmsnorm_0_reg0]}
catch {delete_bd_objs [get_bd_addr_segs -quiet microblaze_0/Instruction/SEG_rmsnorm_0_reg0]}

foreach {space label} {microblaze_0/Data MicroBlaze axi_cdma_0/Data CDMA} {
    set segs [get_bd_addr_segs -quiet -of_objects [get_bd_addr_spaces $space]]
    set hit ""
    foreach g $segs { if {[string match *rmsnorm* $g]} { set hit $g } }
    if {$hit eq ""} {
        error "ADDRMAP: $label has no rmsnorm segment (has: $segs)"
    }
    set_property offset 0x44400000 [get_bd_addr_segs $hit]
    set_property range  128K       [get_bd_addr_segs $hit]
}
puts "ADDRMAP OK: microblaze + cdma both reach rmsnorm @ 0x44400000\""""

for path, txt, edits in ((bd, s_bd, ((OLD_REPO, NEW_REPO), (OLD_OK, NEW_OK))),
                         (eth, s_eth, ((OLD_NMI, NEW_NMI), (OLD_CLK, NEW_CLK),
                                       (OLD_CDMA_IC, NEW_CDMA_IC),
                                       (ANCHOR_ETH, NORM_BLOCK)))):
    for old, new in edits:
        if old not in txt:
            sys.exit(f"anchor missing in {os.path.basename(path)}:\n{old[:120]}")
        txt = txt.replace(old, new, 1)
    open(path, "w").write(txt)

print("block design: rmsnorm_quant_axi @ 0x44400000, behind norm_ic,")
print("              reachable from MicroBlaze and CDMA, both asserted")
