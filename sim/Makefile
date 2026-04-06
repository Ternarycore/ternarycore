# TernaryCore simulation Makefile
# Requires: icarus-verilog (brew install icarus-verilog)
# Waveforms: open .vcd files in VSCode with the WaveTrace extension

IVERILOG = iverilog
VVP      = vvp
SIMDIR   = .

.PHONY: all tb_ternary_mac tb_ternary_dot tb_ternary_gemm clean verify

all: tb_ternary_mac tb_ternary_dot tb_ternary_gemm

# ── MAC unit ──────────────────────────────────────────────────────────────────
tb_ternary_mac: ../tb/tb_ternary_mac.v ../rtl/ternary_mac.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_mac $^
	$(VVP) $(SIMDIR)/sim_mac

# ── Dot product ───────────────────────────────────────────────────────────────
tb_ternary_dot: ../tb/tb_ternary_dot.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_dot $^
	$(VVP) $(SIMDIR)/sim_dot

# ── Matrix multiply ───────────────────────────────────────────────────────────
tb_ternary_gemm: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_gemm $^
	$(VVP) $(SIMDIR)/sim_gemm

# ── Python reference verification ─────────────────────────────────────────────
verify:
	python3 verify/verify_mac.py
	python3 verify/verify_dot.py
	python3 verify/verify_gemm.py

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
