# TernaryCore simulation Makefile
# Requires: icarus-verilog (brew install icarus-verilog)
# Waveforms: open .vcd files in VSCode with the WaveTrace extension

IVERILOG = iverilog -I../rtl
VVP      = vvp
SIMDIR   = .
VERILATOR = verilator

.PHONY: all tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram clean verify
.PHONY: verilator-mac verilator-dot verilator-gemm verilator-pipeline-large verilator-all
.PHONY: verilator-dot-back2back verilator-dot-diff device-diff differential-fuzz mutations coverage

all: tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram

# ── MAC unit ──────────────────────────────────────────────────────────────────
tb_ternary_mac: ../tb/tb_ternary_mac.v ../rtl/ternary_mac.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_mac $^
	$(VVP) $(SIMDIR)/sim_mac

# ── Dot product ───────────────────────────────────────────────────────────────
tb_ternary_dot: ../tb/tb_ternary_dot.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_dot $^
	$(VVP) $(SIMDIR)/sim_dot

# ── Matrix multiply ───────────────────────────────────────────────────────────
tb_ternary_gemm: tb_ternary_gemm_depth4 tb_ternary_gemm_depth16 tb_ternary_gemm_depth64

tb_ternary_gemm_depth4: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=4 -o $(SIMDIR)/sim_gemm_d4 $^
	$(VVP) $(SIMDIR)/sim_gemm_d4

tb_ternary_gemm_depth16: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=16 -o $(SIMDIR)/sim_gemm_d16 $^
	$(VVP) $(SIMDIR)/sim_gemm_d16

tb_ternary_gemm_depth64: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=64 -o $(SIMDIR)/sim_gemm_d64 $^
	$(VVP) $(SIMDIR)/sim_gemm_d64

# ── AXI4-Lite GEMM wrapper ────────────────────────────────────────────────────
tb_axi_gemm_wrapper: tb_axi_gemm_wrapper_depth4 tb_axi_gemm_wrapper_depth16 tb_axi_gemm_wrapper_depth64

tb_axi_gemm_wrapper_depth4: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=4 -o $(SIMDIR)/sim_axi_gemm_d4 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d4

tb_axi_gemm_wrapper_depth16: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=16 -o $(SIMDIR)/sim_axi_gemm_d16 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d16

tb_axi_gemm_wrapper_depth64: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=64 -o $(SIMDIR)/sim_axi_gemm_d64 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d64

# ── BRAM weight cache ────────────────────────────────────────────────────────
tb_weight_bram: tb_weight_bram_d4 tb_weight_bram_d8

tb_weight_bram_d4: ../tb/tb_weight_bram.v ../rtl/weight_bram.v
	$(IVERILOG) -g2012 -DADDR_WIDTH_VAL=4 -o $(SIMDIR)/sim_weight_bram_d4 $^
	$(VVP) $(SIMDIR)/sim_weight_bram_d4

tb_weight_bram_d8: ../tb/tb_weight_bram.v ../rtl/weight_bram.v
	$(IVERILOG) -g2012 -DADDR_WIDTH_VAL=8 -o $(SIMDIR)/sim_weight_bram_d8 $^
	$(VVP) $(SIMDIR)/sim_weight_bram_d8

# ── Streaming feeder ─────────────────────────────────────────────────────────
tb_gemm_stream: ../tb/tb_gemm_stream.v ../rtl/ternary_gemm_stream.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -I../rtl -o $(SIMDIR)/sim_gemm_stream $^
	$(VVP) $(SIMDIR)/sim_gemm_stream

# ── INT8 baseline GEMM ───────────────────────────────────────────────────────
tb_int8_gemm: ../tb/tb_int8_gemm.v ../rtl/int8_gemm.v ../rtl/int8_dot.v
	$(IVERILOG) -g2012 -I../rtl -o $(SIMDIR)/sim_int8_gemm $^
	$(VVP) $(SIMDIR)/sim_int8_gemm

# ── AXI wrapper gap regression ───────────────────────────────────────────────
# Reproduces the on-hardware Tier-1 failure: CPU-fed AXI with idle gaps.
tb_axi_gemm_gaps: ../tb/tb_axi_gemm_gaps.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v
	$(IVERILOG) -g2012 -I../rtl -o $(SIMDIR)/sim_axi_gaps $^
	$(VVP) $(SIMDIR)/sim_axi_gaps

# ── Python reference verification ─────────────────────────────────────────────
verify:
	python3 verify/verify_mac.py
	python3 verify/verify_dot.py
	python3 verify/verify_gemm.py

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
	rm -rf obj_dir obj_dir_dot obj_dir_dot_b2b obj_dir_dot_fuzz obj_dir_dot_diff
	rm -rf build

# ── Verilator C++ simulation (fast) ──────────────────────────────────────────
# Requirements: verilator (brew install verilator)
# Builds a standalone C++ simulator. Typically 10-100x faster than Icarus.
# Dot variants share the same structure (ternary_dot top, .cpp per variant);
# each one varies --Mdir, -GVECTOR_LEN, and whether it runs after build.
# The 3 suffixed variants (back2back/fuzz/diff) could use a pattern rule but
# their unique Mdirs and build/run split make explicit rules clearer.
VERILATOR_SRCDIR = tests
VERILATOR_FLAGS = -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -I../rtl
CXX ?= g++

verilator-mac: $(VERILATOR_SRCDIR)/verilator_mac.cpp ../rtl/ternary_mac.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_mac \
		$(VERILATOR_FLAGS) ../rtl/ternary_mac.v $< -o sim_mac_verilator
	./obj_dir/sim_mac_verilator

# ── Dot-product variants ─────────────────────────────────────────────────────
verilator-dot: $(VERILATOR_SRCDIR)/verilator_dot.cpp ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		--Mdir obj_dir_dot \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v $< -o sim_dot_verilator
	./obj_dir_dot/sim_dot_verilator

verilator-dot-back2back: $(VERILATOR_SRCDIR)/verilator_dot_back2back.cpp ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=4 \
		--Mdir obj_dir_dot_b2b \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v $< -o sim_dot_back2back_verilator
	./obj_dir_dot_b2b/sim_dot_back2back_verilator

verilator-dot-fuzz: $(VERILATOR_SRCDIR)/verilator_dot_fuzz.cpp ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		--Mdir obj_dir_dot_fuzz \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v $< -o sim_dot_fuzz_verilator
	./obj_dir_dot_fuzz/sim_dot_fuzz_verilator

# ── GEMM and pipeline ────────────────────────────────────────────────────────
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

verilator-all:\
  verilator-mac verilator-dot verilator-dot-back2back verilator-dot-fuzz\
  verilator-gemm verilator-pipeline-large

# ── Differential fuzzing (build-only targets) ───────────────────────────────
# These are cross-verification tools (+ device model, Python orchestration)
# that compare RTL vs GVSoC device model. Consider splitting off into a
# separate PR if they grow further — they're testing infrastructure, not RTL.
DIFF_BUILD = build

verilator-dot-diff: $(VERILATOR_SRCDIR)/verilator_dot_diff.cpp ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		--Mdir obj_dir_dot_diff \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v $< -o sim_dot_diff_verilator

device-diff: $(VERILATOR_SRCDIR)/device_diff.cpp
	mkdir -p $(DIFF_BUILD)
	$(CXX) -std=c++17 -O2 -o $(DIFF_BUILD)/device_diff $<

differential-fuzz: verilator-dot-diff device-diff
	python3 $(VERILATOR_SRCDIR)/differential_fuzz.py $(TRIALS)

# ── Coverage (toggle/branch via Verilator) ─────────────────────────────────────
coverage: $(VERILATOR_SRCDIR)/verilator_dot_fuzz.cpp ../rtl/ternary_dot.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		--Mdir obj_dir_coverage \
		--coverage \
		$(VERILATOR_FLAGS) ../rtl/ternary_dot.v $< -o sim_dot_coverage
	./obj_dir_coverage/sim_dot_coverage 42 10000
	mkdir -p coverage
	verilator_coverage --annotate-min 1 \
		--annotate coverage/ \
		coverage.dat
	@echo "=== Coverage summary ==="
	@verilator_coverage --report summary coverage.dat 2>&1 | \
	  awk '/toggle/{gsub(/[()]/,"",$$4); split($$4,b,"/"); \
	       printf "%s/%s signals toggled (%.0f%%)\n", b[1], b[2], 100*b[1]/b[2]}' \
	  || echo "(coverage report pending)"

mutations:
	bash tests/run_mutations.sh
