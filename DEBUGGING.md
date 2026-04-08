# DEBUGGING.md - TernaryCore Debugging Process

## Overview

This document describes the debugging process used to fix the TernaryCore test failures, including the tools, techniques, and lessons learned.

## The Problem

**Initial State (April 2026):**
- `ternary_mac`: 8/8 tests passing ✅
- `ternary_dot`: 7/7 tests passing ✅  
- `ternary_gemm`: 13/16 tests passing 🔧 (3 failures: row 0, columns 0, 1, 3)

**Symptoms:**
- Row 0 of GEMM produced `[-2, 1, 2, -1]` instead of expected `[2, -3, 2, 3]`
- `valid_out` timing mismatches between testbench expectations and RTL
- Intermittent failures that suggested timing/race conditions

## Debugging Process

### Phase 1: Root Cause Analysis

**Step 1: Verify Python Reference**
```bash
python3 verify/verify_gemm_simple.py
```
- Confirmed Python reference implementation produced correct results
- Isolated issue to RTL, not test vectors

**Step 2: Add Debug Statements**
Added `$display` statements to `ternary_dot.v`:
```verilog
$display("DBG[%0d]: activation=%0d weight_enc=%02b weighted=%0d acc=%0d next_acc=%0d count=%0d vec_done=%0d time=%0t", 
         DOT_ID, $signed(activation), weight_enc, $signed(weighted), $signed(acc), $signed(next_acc), count, vector_done, $time);
```

**Key Discovery:** Weight encodings were correct (`8'h19` = `{0, +1, -1, +1}`), but timing showed `weight_enc=00` on first cycle after reset.

### Phase 2: Timing Analysis

**Step 3: Create Minimal Test Cases**
Created `test_timing.v` and `test_timing2.v` to isolate the timing issue:
```verilog
// Simplified testbench to reproduce race condition
initial begin
    #1;  // Critical: delay before setting signals
    activation = 8'd1;
    weight_enc = 8'h19;
    valid_in = 1'b1;
    @(posedge clk);
    #1;
    valid_in = 1'b0;
end
```

**Key Discovery:** Testbench was setting signals at the same simulation time as clock edges, causing the DUT to sometimes see old values.

**Step 4: Fix Testbench Timing**
Modified `tb_ternary_gemm.v`:
```verilog
// BEFORE (race condition):
@(posedge clk);
activation = A[row][k];
weight_enc = weight_matrix_enc[k];

// AFTER (fixed):
#1;  // Delay before clock edge
activation = A[row][k];
weight_enc = weight_matrix_enc[k];
@(posedge clk);
```

**Step 5: Add Reset Stabilization**
Added extra cycle after reset:
```verilog
// Reset sequence
rst_n = 0;
#20;
rst_n = 1;
#20;  // Extra cycle for signal stabilization
@(posedge clk);
```

### Phase 3: Vector Done Logic

**Step 6: Analyze `vector_done` Behavior**
Debug output showed:
```
DBG[0] TIMING: vector_done=1 valid_in=0 vector_done_delayed=0
```

**Issue:** `vector_done` was being cleared immediately when `valid_in=0`, preventing `vector_done_delayed` from capturing it.

**Fix in `ternary_dot.v`:**
```verilog
// BEFORE (cleared immediately):
if (valid_in && (!vector_done || vector_done_delayed)) begin
    // ... logic
end else begin
    vector_done <= 1'b0;  // Problem: clears when valid_in=0
end

// AFTER (persists through valid_in=0):
if (valid_in && (!vector_done || vector_done_delayed)) begin
    // ... logic
end else begin
    vector_done <= vector_done;  // Keep current state
end
```

### Phase 4: Valid Out Timing

**Step 7: Testbench vs RTL Timing Mismatch**
Testbench expected `valid_out` to pulse **one cycle after last element**:
- Last element fed at time 75000
- Testbench checks `valid_out` at next clock edge (time 85000)
- RTL had `valid_out = vector_done_delayed` (registered, one cycle late)

**Fix:** Made `valid_out` combinatorial from `vector_done`:
```verilog
// BEFORE (registered, one cycle late):
assign valid_out = vector_done_delayed;

// AFTER (combinatorial, correct timing):
assign valid_out = vector_done;
```

**Step 8: Update `acc_out` Timing**
```verilog
// BEFORE (outputs one cycle late):
always @(posedge clk) begin
    if (vector_done_delayed) begin
        acc_out <= result_latch;
    end
end

// AFTER (outputs when valid_out is high):
always @(posedge clk) begin
    if (vector_done) begin
        acc_out <= result_latch;
    end
end
```

### Phase 5: Cleanup and Verification

**Step 9: Remove Debug Statements**
Removed all `$display` debug statements from production RTL for cleaner output.

**Step 10: Final Verification**
```bash
make all
make verify
```
- All 31 tests passing
- RTL matches Python reference implementation

## Key Lessons Learned

### 1. **Race Conditions in Testbenches**
- **Problem:** Setting signals at same time as clock edge
- **Solution:** Always use `#1` delay before `@(posedge clk)`
- **Rule:** Signals should be stable before clock edge

### 2. **Reset Timing**
- **Problem:** DUT needs time to stabilize after reset
- **Solution:** Add extra cycle after `rst_n` assertion
- **Rule:** Don't assume immediate readiness after reset

### 3. **State Persistence**
- **Problem:** `vector_done` cleared too early
- **Solution:** Keep state through `valid_in=0` cycles
- **Rule:** Control signals should persist until consumed

### 4. **Combinatorial vs Registered Outputs**
- **Problem:** `valid_out` was registered (one cycle delay)
- **Solution:** Make it combinatorial from control signal
- **Rule:** Match testbench timing expectations

### 5. **Debug Strategy**
- **Add targeted debug statements** with module IDs and timestamps
- **Create minimal test cases** to isolate issues
- **Use waveform viewers** to visualize timing
- **Compare against reference implementation** (Python)

## Tools Used

### 1. **Simulation**
- **Icarus Verilog (`iverilog`)** - Primary simulator
- **Verilator** - Alternative for faster simulation

### 2. **Debugging**
- **`$display` statements** - Text-based debugging
- **VCD waveform files** - Visual timing analysis
- **Python reference** - Ground truth verification

### 3. **Waveform Viewers**
- **GTKWave** - Cross-platform open source
- **WaveTrace** - macOS app (recommended for macOS)
- **Verilog HDL VSCode Extension** - Integrated with VSCode

### 4. **Version Control**
- **Git** - Track changes and bisect issues
- **`.gitattributes`** - Exclude generated files

## Git Strategy for Generated Files

### Files to Exclude from Repository:

**Add to `.gitignore` or `.gitattributes`:**
```
# Simulation outputs
sim/*.vcd
sim/sim_*
sim/*.vvp

# Temporary test files
test_*.v

# Python cache
__pycache__/
*.pyc

# Editor files
*.swp
*.swo
*~
```

**Rationale:**
1. **VCD files** are large binary files (can be MBs to GBs)
2. **Simulation executables** are platform-specific
3. **Temporary test files** are for debugging only
4. **These files are generated** during development, not source code

### Files to Keep in Repository:

**Essential for development:**
- `rtl/` - RTL source files
- `tb/` - Testbenches  
- `sim/Makefile` - Build system
- `sim/verify/` - Python reference implementations
- `AGENTS.md`, `DEBUGGING.md`, `README.md` - Documentation

## Recommended Workflow

### 1. **Start Debugging**
```bash
cd sim
make tb_ternary_gemm  # Run failing test
```

### 2. **Add Debug Statements**
```verilog
// Temporary debug in RTL
if (valid_in) begin
    $display("DEBUG: time=%0t, activation=%0d", $time, $signed(activation));
end
```

### 3. **Generate Waveforms**
```bash
# VCD files are automatically generated by testbenches
# View with:
gtkwave tb_ternary_gemm.vcd
# or
open -a WaveTrace tb_ternary_gemm.vcd
```

### 4. **Create Minimal Test**
```bash
# Create test_timing.v to isolate issue
iverilog -o test_timing test_timing.v ../rtl/ternary_dot.v
vvp test_timing
```

### 5. **Verify Fix**
```bash
make all
make verify
```

### 6. **Clean Up**
```bash
make clean
rm -f test_*.v *.vcd
```

## Common Issues and Solutions

### Issue 1: "X" (Unknown) values in simulation
**Cause:** Uninitialized registers or race conditions
**Solution:** Ensure all registers have reset values, add `#1` delays

### Issue 2: Test passes intermittently  
**Cause:** Race condition
**Solution:** Use consistent timing (`#1` before clock edges)

### Issue 3: Wrong numerical results
**Cause:** Weight encoding mismatch or accumulation error
**Solution:** Compare with Python reference, check sign extension

### Issue 4: `valid_out` doesn't pulse
**Cause:** Timing mismatch between testbench and RTL
**Solution:** Check if `vector_done` logic persists through cycles

## Conclusion

The debugging process revealed that most issues were **timing-related**, not algorithmic. The key insights were:

1. **Testbench timing** must account for simulation delta cycles
2. **Control signals** need to persist until consumed  
3. **Output timing** must match testbench expectations
4. **Minimal test cases** are essential for isolating issues

By following this systematic approach and using the tools described, similar issues can be debugged efficiently in the future.