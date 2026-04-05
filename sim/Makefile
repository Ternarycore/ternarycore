# TernaryCore simulation Makefile
# Requires: icarus-verilog (brew install icarus-verilog)
# Optional: gtkwave (brew install gtkwave) for waveform viewing

IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Simulation output directory
SIMDIR = .

.PHONY: all tb_ternary_mac clean waves

all: tb_ternary_mac

# --- MAC unit testbench ---
tb_ternary_mac: ../tb/tb_ternary_mac.v ../rtl/ternary_mac.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_mac $^
	$(VVP) $(SIMDIR)/sim_mac

waves_mac: tb_ternary_mac
	$(GTKWAVE) $(SIMDIR)/tb_ternary_mac.vcd &

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
