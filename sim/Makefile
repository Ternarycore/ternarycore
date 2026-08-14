# TernaryCore simulation Makefile
# Requires: icarus-verilog (brew install icarus-verilog)
# Waveforms: open .vcd files in VSCode with the WaveTrace extension

IVERILOG = iverilog -I../rtl
VVP      = vvp
SIMDIR   = .
VERILATOR = verilator

.PHONY: all extended tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram clean verify formal
.PHONY: tb_gemm_stream tb_int8_gemm tb_axi_gemm_gaps
.PHONY: verilator-mac verilator-dot verilator-gemm verilator-all
.PHONY: verilator-dot-fuzz

all: tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram

# Every Icarus regression currently shipped by the repository.
extended: all tb_gemm_stream tb_int8_gemm tb_axi_gemm_gaps

# ── MAC unit ──────────────────────────────────────────────────────────────────
tb_ternary_mac: ../tb/tb_ternary_mac.v ../rtl/ternary_mac.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_mac $^
	$(VVP) $(SIMDIR)/sim_mac

# ── Dot product ───────────────────────────────────────────────────────────────
tb_ternary_dot: ../tb/tb_ternary_dot.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_dot $^
	$(VVP) $(SIMDIR)/sim_dot

# ── Matrix multiply ───────────────────────────────────────────────────────────
tb_ternary_gemm: tb_ternary_gemm_depth4 tb_ternary_gemm_depth16 tb_ternary_gemm_depth64

tb_ternary_gemm_depth4: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=4 -o $(SIMDIR)/sim_gemm_d4 $^
	$(VVP) $(SIMDIR)/sim_gemm_d4

tb_ternary_gemm_depth16: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=16 -o $(SIMDIR)/sim_gemm_d16 $^
	$(VVP) $(SIMDIR)/sim_gemm_d16

tb_ternary_gemm_depth64: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=64 -o $(SIMDIR)/sim_gemm_d64 $^
	$(VVP) $(SIMDIR)/sim_gemm_d64

# ── AXI4-Lite GEMM wrapper ────────────────────────────────────────────────────
tb_axi_gemm_wrapper: tb_axi_gemm_wrapper_depth4 tb_axi_gemm_wrapper_depth16 tb_axi_gemm_wrapper_depth64

tb_axi_gemm_wrapper_depth4: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=4 -o $(SIMDIR)/sim_axi_gemm_d4 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d4

tb_axi_gemm_wrapper_depth16: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=16 -o $(SIMDIR)/sim_axi_gemm_d16 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d16

tb_axi_gemm_wrapper_depth64: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
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
tb_gemm_stream: ../tb/tb_gemm_stream.v ../rtl/ternary_gemm_stream.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -I../rtl -o $(SIMDIR)/sim_gemm_stream $^
	$(VVP) $(SIMDIR)/sim_gemm_stream

# ── INT8 baseline GEMM ───────────────────────────────────────────────────────
tb_int8_gemm: ../tb/tb_int8_gemm.v ../rtl/int8_gemm.v ../rtl/int8_dot.v
	$(IVERILOG) -g2012 -I../rtl -o $(SIMDIR)/sim_int8_gemm $^
	$(VVP) $(SIMDIR)/sim_int8_gemm

# ── AXI wrapper gap regression ───────────────────────────────────────────────
# Reproduces the on-hardware Tier-1 failure: CPU-fed AXI with idle gaps.
tb_axi_gemm_gaps: ../tb/tb_axi_gemm_gaps.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -I../rtl -o $(SIMDIR)/sim_axi_gaps $^
	$(VVP) $(SIMDIR)/sim_axi_gaps

# ── Python reference verification ─────────────────────────────────────────────
verify:
	python3 verify/verify_mac.py
	python3 verify/verify_dot.py
	python3 verify/verify_gemm.py

formal:
	bash ../formal/run_all.sh

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
	rm -rf obj_dir obj_dir_dot obj_dir_dot_fuzz

# ── Verilator C++ simulation (fast) ──────────────────────────────────────────
# Requirements: verilator (brew install verilator)
# Builds a standalone C++ simulator. Typically 10-100x faster than Icarus.
VERILATOR_SRCDIR = tests
# WIDTHTRUNC: intentional accumulator/width narrowing in ternary_dot tree reductions
# TIMESCALEMOD: ternary_weight.v has no timescale (shared cell)
# PINMISSING: optional debug_* ports on ternary_dot left unconnected by gemm
VERILATOR_FLAGS = -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-TIMESCALEMOD -Wno-PINMISSING -Wno-BLKSEQ -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL -I../rtl
# Shared ternary select cell (required after ternary_weight.v split on main)
TW = ../rtl/ternary_weight.v

verilator-mac: $(VERILATOR_SRCDIR)/verilator_mac.cpp ../rtl/ternary_mac.v $(TW)
	$(VERILATOR) --cc --build --exe -j --top-module ternary_mac \
		$(VERILATOR_FLAGS) $(TW) ../rtl/ternary_mac.v $< -o sim_mac_verilator
	./obj_dir/sim_mac_verilator

verilator-dot: $(VERILATOR_SRCDIR)/verilator_dot.cpp ../rtl/ternary_dot.v $(TW)
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		--Mdir obj_dir_dot \
		$(VERILATOR_FLAGS) $(TW) ../rtl/ternary_dot.v $< -o sim_dot_verilator
	./obj_dir_dot/sim_dot_verilator

verilator-gemm: $(VERILATOR_SRCDIR)/verilator_gemm.cpp ../rtl/ternary_gemm.v ../rtl/ternary_dot.v $(TW)
	$(VERILATOR) --cc --build --exe -j --top-module ternary_gemm \
		-GDEPTH=4 -GCOLS=4 \
		$(VERILATOR_FLAGS) $(TW) ../rtl/ternary_dot.v ../rtl/ternary_gemm.v $< -o sim_gemm_verilator
	./obj_dir/sim_gemm_verilator

# Run every Verilator test shipped by this PR.
verilator-all: verilator-mac verilator-dot verilator-dot-fuzz verilator-gemm

verilator-dot-fuzz: $(VERILATOR_SRCDIR)/verilator_dot_fuzz.cpp ../rtl/ternary_dot.v $(TW)
	$(VERILATOR) --cc --build --exe -j --top-module ternary_dot \
		-GVECTOR_LEN=8 \
		--Mdir obj_dir_dot_fuzz \
		$(VERILATOR_FLAGS) $(TW) ../rtl/ternary_dot.v $< -o sim_dot_fuzz_verilator
	./obj_dir_dot_fuzz/sim_dot_fuzz_verilator
