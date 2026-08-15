# TernaryCore simulation Makefile
# Requires: icarus-verilog (brew install icarus-verilog)
# Waveforms: open .vcd files in VSCode with the WaveTrace extension

IVERILOG = iverilog
VVP      = vvp
SIMDIR   = .

.PHONY: all tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram tb_weight_bram128 tb_axi_gemm_stream tb_axi_gemm_stream_full tb_axi_gemm_stream_depth1 tb_axi_gemm_stream_depth7 tb_axi_gemm_stream_depth128 tb_axi_gemm_stream_depth768 clean verify

all: tb_ternary_mac tb_ternary_dot tb_ternary_gemm tb_axi_gemm_wrapper tb_weight_bram tb_weight_bram128 tb_axi_gemm_stream

# ── MAC unit ──────────────────────────────────────────────────────────────────
tb_ternary_mac: ../tb/tb_ternary_mac.v ../rtl/ternary_mac.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_mac $^
	$(VVP) $(SIMDIR)/sim_mac

# ── Dot product ───────────────────────────────────────────────────────────────
tb_ternary_dot: ../tb/tb_ternary_dot.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_dot $^
	$(VVP) $(SIMDIR)/sim_dot

# ── Matrix multiply ───────────────────────────────────────────────────────────
tb_ternary_gemm: tb_ternary_gemm_depth4 tb_ternary_gemm_depth16 tb_ternary_gemm_depth64

tb_ternary_gemm_depth4: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=4 -o $(SIMDIR)/sim_gemm_d4 $^
	$(VVP) $(SIMDIR)/sim_gemm_d4

tb_ternary_gemm_depth16: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=16 -o $(SIMDIR)/sim_gemm_d16 $^
	$(VVP) $(SIMDIR)/sim_gemm_d16

tb_ternary_gemm_depth64: ../tb/tb_ternary_gemm.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=64 -o $(SIMDIR)/sim_gemm_d64 $^
	$(VVP) $(SIMDIR)/sim_gemm_d64

# ── AXI4-Lite GEMM wrapper ────────────────────────────────────────────────────
tb_axi_gemm_wrapper: tb_axi_gemm_wrapper_depth4 tb_axi_gemm_wrapper_depth16 tb_axi_gemm_wrapper_depth64

tb_axi_gemm_wrapper_depth4: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=4 -o $(SIMDIR)/sim_axi_gemm_d4 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d4

tb_axi_gemm_wrapper_depth16: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DDEPTH_VAL=16 -o $(SIMDIR)/sim_axi_gemm_d16 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_d16

tb_axi_gemm_wrapper_depth64: ../tb/tb_axi_gemm_wrapper.v ../rtl/axi_gemm_wrapper.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v ../rtl/ternary_weight.v
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

# ── Tier-2 streaming weight store and GEMM -------------------------------
# Exercise the AXI4 burst path and 128-bit read path used by the DDR pager.
tb_weight_bram128: tb_weight_bram128_burst tb_weight_bram128_wide

tb_weight_bram128_burst: ../tb/tb_weight_bram128_burst.v ../rtl/weight_bram128.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_weight_bram128_burst $^
	$(VVP) $(SIMDIR)/sim_weight_bram128_burst

tb_weight_bram128_wide: ../tb/tb_weight_bram128_wide.v ../rtl/weight_bram128.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_weight_bram128_wide $^
	$(VVP) $(SIMDIR)/sim_weight_bram128_wide

tb_axi_gemm_stream: tb_axi_gemm_stream_full tb_axi_gemm_stream_depth1 tb_axi_gemm_stream_depth7 tb_axi_gemm_stream_depth128 tb_axi_gemm_stream_depth768

tb_axi_gemm_stream_full: ../tb/tb_axi_gemm_stream.v ../rtl/axi_gemm_stream.v ../rtl/weight_bram128.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -o $(SIMDIR)/sim_axi_gemm_stream $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_stream

tb_axi_gemm_stream_depth1: ../tb/tb_axi_gemm_stream.v ../rtl/axi_gemm_stream.v ../rtl/weight_bram128.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DSTREAM_TEST_DEPTH=1 -o $(SIMDIR)/sim_axi_gemm_stream_d1 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_stream_d1

tb_axi_gemm_stream_depth7: ../tb/tb_axi_gemm_stream.v ../rtl/axi_gemm_stream.v ../rtl/weight_bram128.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DSTREAM_TEST_DEPTH=7 -o $(SIMDIR)/sim_axi_gemm_stream_d7 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_stream_d7

tb_axi_gemm_stream_depth128: ../tb/tb_axi_gemm_stream.v ../rtl/axi_gemm_stream.v ../rtl/weight_bram128.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DSTREAM_TEST_DEPTH=128 -o $(SIMDIR)/sim_axi_gemm_stream_d128 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_stream_d128

tb_axi_gemm_stream_depth768: ../tb/tb_axi_gemm_stream.v ../rtl/axi_gemm_stream.v ../rtl/weight_bram128.v ../rtl/ternary_gemm.v ../rtl/ternary_dot.v ../rtl/ternary_weight.v
	$(IVERILOG) -g2012 -DSTREAM_TEST_DEPTH=768 -o $(SIMDIR)/sim_axi_gemm_stream_d768 $^
	$(VVP) $(SIMDIR)/sim_axi_gemm_stream_d768

# ── Python reference verification ─────────────────────────────────────────────
verify:
	python3 verify/verify_mac.py
	python3 verify/verify_dot.py
	python3 verify/verify_gemm.py

clean:
	rm -f $(SIMDIR)/sim_* $(SIMDIR)/*.vcd
