# TernaryCore simulation Makefile
# Requires: icarus-verilog, Python 3, and Verilator for C++ simulation.

IVERILOG = iverilog -I../rtl
VVP      = vvp
SIMDIR   = .
VERILATOR = verilator

.PHONY: all extended clean verify formal
.PHONY: tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram
.PHONY: tb_gemm_stream tb_int8_gemm tb_axi_gemm_gaps
.PHONY: verilator-pipeline-large verilator-all

all: tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram

# Every Icarus regression currently exposed by this Makefile.
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

# ── BRAM weight cache ─────────────────────────────────────────────────────────
tb_weight_bram: tb_weight_bram_d4 tb_weight_bram_d8

tb_weight_bram_d4: ../tb/tb_weight_bram.v ../rtl/weight_bram.v
	$(IVERILOG) -g2012 -DADDR_WIDTH_VAL=4 -o $(SIMDIR)/sim_weight_bram_d4 $^
	$(VVP) $(SIMDIR)/sim_weight_bram_d4

tb_weight_bram_d8: ../tb/tb_weight_bram.v ../rtl/weight_bram.v
	$(IVERILOG) -g2012 -DADDR_WIDTH_VAL=8 -o $(SIMDIR)/sim_weight_bram_d8 $^
	$(VVP) $(SIMDIR)/sim_weight_bram_d8

# ── Additional regressions ────────────────────────────────────────────────────
tb_gemm_stream: ../tb/tb_gemm_stream.v ../rtl/ternary_gemm_stream.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_gemm_stream $^
	$(VVP) $(SIMDIR)/sim_gemm_stream

tb_int8_gemm: ../tb/tb_int8_gemm.v ../rtl/int8_gemm.v ../rtl/int8_dot.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_int8_gemm $^
	$(VVP) $(SIMDIR)/sim_int8_gemm

tb_axi_gemm_gaps: ../tb/tb_axi_gemm_gaps.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_axi_gaps $^
	$(VVP) $(SIMDIR)/sim_axi_gaps

# ── Reference and formal verification ─────────────────────────────────────────
verify:
	python3 verify/verify_mac.py
	python3 verify/verify_dot.py
	python3 verify/verify_gemm.py

formal:
	bash ../formal/run_all.sh

# ── Verilator full-pipeline simulation ────────────────────────────────────────
VERILATOR_SRCDIR = tests
VERILATOR_FLAGS = -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC
VERILATOR_FLAGS += -Wno-PINMISSING -Wno-TIMESCALEMOD -Wno-BLKSEQ
VERILATOR_FLAGS += -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL -I../rtl

verilator-pipeline-large: $(VERILATOR_SRCDIR)/verilator_pipeline_576.cpp \
                           ../rtl/ternary_pipeline.v ../rtl/activation_quant.v \
                           ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v \
                           ../rtl/ternary_scale.v
	$(VERILATOR) --cc --build --exe -j --top-module ternary_pipeline \
		-GVECTOR_LEN=576 -GCOLS=4 --Mdir obj_dir_pipeline \
		$(VERILATOR_FLAGS) \
		../rtl/activation_quant.v ../rtl/ternary_weight.v ../rtl/ternary_dot.v \
		../rtl/ternary_gemm.v ../rtl/ternary_scale.v ../rtl/ternary_pipeline.v \
		$< -o sim_pipeline_576_verilator
	./obj_dir_pipeline/sim_pipeline_576_verilator

# Run every Verilator test shipped by this PR.
verilator-all: verilator-pipeline-large

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
	rm -rf obj_dir*
