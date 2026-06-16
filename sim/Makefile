# TernaryCore simulation Makefile
# Requires: icarus-verilog (brew install icarus-verilog)
# Lint:     verilator (brew install verilator)
# Formal:   yosys + symbiyosys (brew install yosys symbiyosys)
# Waveforms: surfer (cargo install surfer), WaveTrace, or gtkwave

IVERILOG = iverilog
VVP      = vvp
SIMDIR   = .
VERILATOR = verilator
YOSYS    = yosys
VLT_CONFIG = ../ternarycore.vlt

.PHONY: all tb_ternary_mac tb_ternary_dot tb_ternary_gemm clean verify verify-simple verify-all lint formal
.PHONY: view-mac view-dot view-gemm

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

# No-numpy reference (portable, no deps)
verify-simple:
	python3 verify/verify_mac.py
	python3 verify/verify_dot.py
	python3 verify/verify_gemm_simple.py

# Run both numpy and no-numpy verification paths (no redundant mac/dot runs)
verify-all: verify
	python3 verify/verify_gemm_simple.py

# ── Verilator lint ────────────────────────────────────────────────────────────
# Lints each RTL module independently with its source directory on the
# include path so cross-module references resolve correctly.
#
# Suppression rules live in ternarycore.vlt at the project root.
LINT_FLAGS = -Wno-EOFNEWLINE

lint:
	$(VERILATOR) --lint-only -Wall $(LINT_FLAGS) $(VLT_CONFIG) --top-module ternary_mac    ../rtl/ternary_mac.v
	$(VERILATOR) --lint-only -Wall $(LINT_FLAGS) $(VLT_CONFIG) --top-module ternary_dot    ../rtl/ternary_dot.v
	$(VERILATOR) --lint-only -Wall $(LINT_FLAGS) $(VLT_CONFIG) --top-module ternary_gemm   -I../rtl ../rtl/ternary_gemm.v ../rtl/ternary_dot.v

# ── Formal verification (SymbiYosys) ─────────────────────────────────────────
formal:
	@if [ -d ../formal ]; then \
		cd ../formal && bash run_all.sh; \
	else \
		echo "Formal verification not available (formal/ directory missing)."; \
		echo "This target requires the formal verification PR to be merged first."; \
	fi

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
	rm -rf ../formal/ternary_mac ../formal/ternary_dot ../formal/ternary_gemm
