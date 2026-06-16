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

.PHONY: all tb_ternary_mac tb_ternary_dot tb_ternary_gemm clean verify lint formal

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

# ── Verilator lint ────────────────────────────────────────────────────────────
# Lints each RTL module independently with its source directory on the
# include path so cross-module references resolve correctly.
#
# Warning suppressions (all intentional — see .verilator_config for rationale):
#   BLKSEQ       — blocking assigns for intermediate combinational values
#                  within a clocked always block (weighted, weighted_ext, next_acc)
#   UNUSEDPARAM  — DOT_ID reserved for ILA debug identification
#   UNUSEDSIGNAL — debug_*/debug_tap_* signals are ILA capture taps for FPGA
#                  probing, marked (* keep, dont_touch *)
LINT_FLAGS = -Wno-BLKSEQ -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL -Wno-PINMISSING

lint:
	$(VERILATOR) --lint-only -Wall $(LINT_FLAGS) --top-module ternary_mac    ../rtl/ternary_mac.v
	$(VERILATOR) --lint-only -Wall $(LINT_FLAGS) --top-module ternary_dot    ../rtl/ternary_dot.v
	$(VERILATOR) --lint-only -Wall $(LINT_FLAGS) --top-module ternary_gemm   -I../rtl ../rtl/ternary_gemm.v ../rtl/ternary_dot.v

# ── Formal verification (SymbiYosys) ─────────────────────────────────────────
formal:
	$(YOSYS) -Q -c ../formal/run_all.tcl
	@echo ""
	@echo "─── Formal verification results ───"
	@for f in mac dot gemm; do \
	    if [ -f formal_$$f/results.txt ]; then \
	        result=$$(head -1 formal_$$f/results.txt); \
	        echo "  $$f: $$result"; \
	    fi; \
	done

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
	rm -rf formal_mac formal_dot formal_gemm
