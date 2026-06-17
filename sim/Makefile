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
.PHONY: verilator-mac verilator-dot verilator-gemm verilator-all

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
	fi

# ── Waveform viewer (auto-detect) ────────────────────────────────────────────
# Supported viewers (in priority order):
#   surfer    — cargo install surfer   (modern, cross-platform, TUI+GUI)
#   WaveTrace — open -a WaveTrace     (macOS native app)
#   gtkwave   — brew install gtkwave  (legacy, cross-platform)

VIEWER_SCRIPT = open_vcd.sh

view-mac: tb_ternary_mac
	@bash ./$(VIEWER_SCRIPT) tb_ternary_mac.vcd

view-dot: tb_ternary_dot
	@bash ./$(VIEWER_SCRIPT) tb_ternary_dot.vcd

view-gemm: tb_ternary_gemm
	@bash ./$(VIEWER_SCRIPT) tb_ternary_gemm.vcd

# ── Verilator C++ simulation (fast) ──────────────────────────────────────────
# Requirements: verilator (brew install verilator)
# Builds a standalone C++ simulator. Typically 10-100x faster than Icarus.
VERILATOR_SRCDIR = tests
VERILATOR_FLAGS = -Wno-BLKSEQ -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL -Wno-PINMISSING
VERILATOR_FLAGS += -Wno-EOFNEWLINE -Wno-WIDTHTRUNC -Wno-UNOPTFLAT

verilator-mac: $(VERILATOR_SRCDIR)/verilator_mac.cpp ../rtl/ternary_mac.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_mac \
		$(VERILATOR_FLAGS) ../rtl/ternary_mac.v $< -o sim_mac_verilator
	./obj_dir/sim_mac_verilator

verilator-dot: $(VERILATOR_SRCDIR)/verilator_dot.cpp ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v $< -o sim_dot_verilator
	./obj_dir/sim_dot_verilator

verilator-gemm: $(VERILATOR_SRCDIR)/verilator_gemm.cpp ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_gemm \
		-GDEPTH=4 -GCOLS=4 \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v ../rtl/ternary_gemm.v $< -o sim_gemm_verilator
	./obj_dir/sim_gemm_verilator

verilator-pipeline-large: $(VERILATOR_SRCDIR)/verilator_pipeline_576.cpp \
                           ../rtl/ternary_pipeline.v ../rtl/activation_quant.v \
                           ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_scale.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_pipeline \
		-GVECTOR_LEN=576 -GCOLS=4 \
		$(VERILATOR_FLAGS) \
		../rtl/activation_quant.v ../rtl/ternary_dot.v ../rtl/ternary_gemm.v \
		../rtl/ternary_scale.v ../rtl/ternary_pipeline.v $< -o sim_pipeline_576_verilator
	./obj_dir/sim_pipeline_576_verilator

verilator-all: verilator-mac verilator-dot verilator-gemm verilator-pipeline-large

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
	rm -rf obj_dir
	rm -rf ../formal/ternary_mac ../formal/ternary_dot ../formal/ternary_gemm
