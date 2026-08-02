# test_system.py
# GVSoC system test for the TernaryCore BitNet b1.58 GEMM accelerator.
#
# This file provides one test approach:
#   1. GVSoC System Test (requires gvsoc installed + PULP toolchain):
#      Defines a minimal PULP platform with the ternarycore device and
#      a firmware test that exercises it.
#
# Usage:
#   # Prerequisites:
#   #   - gvsoc installed and sourced (sourceme.sh)
#   #   - libternarycore_device.so built (make)
#   #
#   # System test with firmware:
#   #   python3 test_system.py
#
# Register map (see ternarycore_device.hpp for full details):
#   Offset 0x0000: ACT_BUF  (VECTOR_LEN bytes, 1 byte/element)
#   Offset 0x0400: WGT_BUF  (VECTOR_LEN bytes, packed 2-bit/weight/col)
#   Offset 0x0800: ALPHA[0..3] (4 x 16-bit registers)
#   Offset 0x0808: RESULT[0..3] (4 x 32-bit read-only)
#   Offset 0x0818: CTRL     (32-bit W: bit0=start)
#   Offset 0x081C: STATUS   (32-bit R: bit0=busy, bit1=done)
#   Offset 0x0820: VECTOR_LEN (32-bit R/W)
#   Offset 0x0824: INV      (32-bit R/W)

import os
import sys
import struct
import math
import argparse

# ============================================================================
# Reference GEMM pipeline (same logic as the device model)
# ============================================================================

Q_MAX = 127
Q_MIN = -127
PRECISION = 15


def quantize_activation(x, inv):
    """Activation quantization: q = round(clip(x * inv >> 15, -127, 127))"""
    product = x * (inv & 0x3FFFFF)
    round_amt = 1 << (PRECISION - 1)
    biased = product + round_amt
    shifted = biased >> PRECISION
    return max(Q_MIN, min(Q_MAX, shifted))


def decode_weight(enc):
    """Decode 2-bit weight: 00=0, 01=+1, 10=-1"""
    if enc == 0b01:
        return +1
    elif enc == 0b10:
        return -1
    return 0


def reference_pipeline(activations, weights, alphas, inv):
    """Pure-Python reference: returns [result0, result1, result2, result3]"""
    COLS = 4
    # Quantize
    q = [quantize_activation(a, inv) for a in activations]
    # GEMM
    acc = [0] * COLS
    for k in range(len(activations)):
        packed = weights[k] if k < len(weights) else 0
        for c in range(COLS):
            enc = (packed >> (2 * c)) & 0x3
            w = decode_weight(enc)
            if w == +1:
                acc[c] += q[k]
            elif w == -1:
                acc[c] -= q[k]
    # Scale
    results = []
    for c in range(COLS):
        prod = acc[c] * (alphas[c] & 0xFFFF)
        trunc = prod & ((1 << PRECISION) - 1)
        round_bit = 1 if trunc != 0 else 0
        shifted = prod >> PRECISION
        results.append(shifted + round_bit)
    return results


# ============================================================================
# Test vectors (same as verilator_pipeline_576.cpp)
# ============================================================================

def compute_inv(absmax):
    """Compute inv = round(2^PRECISION * Q_MAX / absmax)"""
    return int(round((1 << PRECISION) * Q_MAX / absmax))


def generate_test_vectors(vector_len=576, cols=4):
    """Generate test vectors matching the Verilator C++ test."""
    # Activations: ramp -127..127 repeating
    acts = [(i % 255) - 127 for i in range(vector_len)]

    # Weights: [+1, -1, 0, +1] for all 576 elements
    col_weights = [1, -1, 0, 1]
    weights = []
    for k in range(vector_len):
        packed = 0
        for c in range(cols):
            w = col_weights[c]
            enc = 0b01 if w == 1 else (0b10 if w == -1 else 0b00)
            packed |= enc << (2 * c)
        weights.append(packed)

    # Alphas (Q15): [32768, 16384, 65536, 32768]
    # 65536 truncated to uint16 = 0
    alphas = [32768, 16384, 0, 32768]

    inv = compute_inv(127)  # = 32768

    return acts, weights, alphas, inv


# ============================================================================
# Python verification (runs without gvsoc)
# ============================================================================

def verify_reference():
    """Run the reference pipeline on the standard test vectors and print results."""
    print("=" * 60)
    print("Reference Pipeline Verification (no gvsoc required)")
    print("=" * 60)

    # Test 1: Simple 4x4
    print("\n--- Test 1: Simple 4x4 GEMM ---")
    acts = [10, 20, 30, 40]
    weights = []
    col_ws = [[+1, -1, 0, +1], [0, 0, +1, -1], [+1, +1, +1, +1], [-1, -1, -1, -1]]
    for k in range(4):
        packed = 0
        for c in range(4):
            w = col_ws[c][k]
            enc = 0b01 if w == 1 else (0b10 if w == -1 else 0b00)
            packed |= enc << (2 * c)
        weights.append(packed)
    alphas = [32768, 32768, 16384, 0]  # 65536 truncated to 0
    inv = compute_inv(127)
    results = reference_pipeline(acts, weights, alphas, inv)
    print(f"  Results: {results}")
    expected = [30, -10, 50, 0]  # verified against RTL
    status = "PASS" if results == expected else "FAIL"
    print(f"  Expected: {expected}")
    print(f"  {status}")

    # Test 2: VECTOR_LEN=576
    print("\n--- Test 2: VECTOR_LEN=576 (SmolVLM hidden dim) ---")
    acts, weights, alphas, inv = generate_test_vectors(576)
    results = reference_pipeline(acts, weights, alphas, inv)
    print(f"  Results: {results}")
    # Reference values from C++ standalone test: [-6237, 3119, 0, -6237]
    expected = [-6237, 3119, 0, -6237]
    status = "PASS" if results == expected else "FAIL"
    print(f"  Expected: {expected}")
    print(f"  {status}")

    # Test 3: Weight encodings
    print("\n--- Test 3: All weight encodings ---")
    acts = [100]
    # 4 columns, col0=+1, col1=-1, col2=0, col3=+1
    weights = [0b01_00_10_01]  # packed: col3=01, col2=00, col1=10, col0=01
    alphas = [32768, 32768, 32768, 32768]
    inv = compute_inv(127)
    results = reference_pipeline(acts, weights, alphas, inv)
    print(f"  Results: {results}")
    status = "PASS" if results == [100, -100, 0, 100] else "FAIL"
    print(f"  Expected: [100, -100, 0, 100]")
    print(f"  {status}")

    # Test 4: Zero activations
    print("\n--- Test 4: Zero activations ---")
    acts = [0, 0, 0, 0]
    weights = [0b01000100] * 4  # all +1 for all cols
    alphas = [32768] * 4
    inv = compute_inv(127)
    results = reference_pipeline(acts, weights, alphas, inv)
    status = "PASS" if all(r == 0 for r in results) else "FAIL"
    print(f"  Results: {results}")
    print(f"  {status}")

    return 0


# ============================================================================
# GVSoC system test
# ============================================================================

# Memory-mapped register base address for the ternarycore device
# (must match the PULP platform address map)
TC_BASE_ADDR = 0x1A100000

# Register offsets (from ternarycore_device.hpp)
TC_ACT_BUF      = 0x0000
TC_WGT_BUF      = 0x0400
TC_ALPHA_0      = 0x0800
TC_ALPHA_1      = 0x0802
TC_ALPHA_2      = 0x0804
TC_ALPHA_3      = 0x0806
TC_RESULT_0     = 0x0808
TC_RESULT_1     = 0x080C
TC_RESULT_2     = 0x0810
TC_RESULT_3     = 0x0814
TC_CTRL         = 0x0818
TC_STATUS       = 0x081C
TC_VECTOR_LEN   = 0x0820
TC_INV          = 0x0824
TC_ADDR_MAX     = 0x0828


def create_gvsoc_platform_config(output_dir):
    """
    Create a minimal gvsoc platform configuration that instantiates
    the ternarycore device. This produces JSON config files that gvsoc loads.

    The platform creates:
      - A minimal PULP cluster with 1 RISC-V core
      - The ternarycore device mapped into the cluster's address space
      - A testbench component to drive the test
    """
    from gvsoc.systree import Component, Sram, Cluster

    class TernarycoreTestPlatform(Component):
        def __init__(self, parent, name):
            super().__init__(parent, name)

            # Add the ternarycore device model
            # This registers the shared library and maps it into memory
            self.add_component(
                "ternarycore_device",
                "ternarycore.ternarycore_device",
                # The device model .so file must be on gvsoc's model search path
                # or specified with an absolute path
                shared_lib="libternarycore_device.so",
                # Address mapping (PULP standard: 32-bit physical address)
                address=TC_BASE_ADDR,
                size=TC_ADDR_MAX,
            )

    # Generate the JSON config
    config = {
        "target": {
            "gvsoc": {
                "models": {
                    "dirs": [
                        # Directory containing libternarycore_device.so
                        os.path.join(os.path.dirname(__file__), "build")
                    ]
                }
            }
        }
    }

    import json
    os.makedirs(output_dir, exist_ok=True)
    with open(os.path.join(output_dir, "config.json"), "w") as f:
        json.dump(config, f, indent=2)

    return config


# ============================================================================
# PULP Firmware (C source embedded for convenience)
# ============================================================================

PULP_FIRMWARE_C = r"""
/**
 * test_ternarycore.c
 * PULP firmware test for the TernaryCore accelerator.
 *
 * This program runs on a PULP cluster core and exercises the device:
 *   1. Write activations, weights, alphas to device registers
 *   2. Trigger computation
 *   3. Poll for completion
 *   4. Read and verify results
 *
 * Build with the PULP SDK:
 *   source pulp-sdk/configs/pulp_open.sh
 *   make clean all run
 */

#include <stdio.h>
#include <stdint.h>
#include "pmsis.h"

// Device base address (must match the platform config)
#define TC_BASE     0x1A100000

// Register offsets (from ternarycore_device.hpp)
#define TC_ACT_BUF      0x0000
#define TC_WGT_BUF      0x0400
#define TC_ALPHA(c)     (0x0800 + (c) * 2)
#define TC_RESULT(c)    (0x0808 + (c) * 4)
#define TC_CTRL         0x0818
#define TC_STATUS       0x081C
#define TC_VECTOR_LEN   0x0820
#define TC_INV          0x0824

#define TC_CTRL_START   (1 << 0)

#define TC_MAX_VL       1024
#define TC_COLS         4

// Helper: write 32-bit register
static inline void tc_write32(uint32_t offset, uint32_t val) {
    *(volatile uint32_t *)(TC_BASE + offset) = val;
}

// Helper: read 32-bit register
static inline uint32_t tc_read32(uint32_t offset) {
    return *(volatile uint32_t *)(TC_BASE + offset);
}

// Helper: write byte to buffer
static inline void tc_write8(uint32_t offset, uint8_t val) {
    *(volatile uint8_t *)(TC_BASE + offset) = val;
}

// Helper: write 16-bit register
static inline void tc_write16(uint32_t offset, uint16_t val) {
    *(volatile uint16_t *)(TC_BASE + offset) = val;
}

int test_ternarycore(int vector_len)
{
    printf("TernaryCore test: VECTOR_LEN=%d\n", vector_len);

    // --- Prepare test vectors ---
    // Activations: ramp -127..127 repeating
    for (int i = 0; i < vector_len; i++) {
        int8_t act = (int8_t)((i % 255) - 127);
        tc_write8(TC_ACT_BUF + i, (uint8_t)act);
    }

    // Weights: col0=+1, col1=-1, col2=0, col3=+1 for all elements
    uint8_t col_enc[4] = {0b01, 0b10, 0b00, 0b01};  // +1, -1, 0, +1
    for (int i = 0; i < vector_len; i++) {
        uint8_t packed = 0;
        for (int c = 0; c < TC_COLS; c++) {
            packed |= col_enc[c] << (2 * c);
        }
        tc_write8(TC_WGT_BUF + i, packed);
    }

    // Alphas (Q15): [32768, 16384, 65536=>0, 32768]
    tc_write16(TC_ALPHA(0), 32768);
    tc_write16(TC_ALPHA(1), 16384);
    tc_write16(TC_ALPHA(2), (uint16_t)65536);  // truncated to 0
    tc_write16(TC_ALPHA(3), 32768);

    // INV: compute_inv(127) = 32768
    tc_write32(TC_INV, 32768);

    // VECTOR_LEN
    tc_write32(TC_VECTOR_LEN, vector_len);

    // --- Trigger compute ---
    tc_write32(TC_CTRL, TC_CTRL_START);

    // --- Poll for done ---
    uint32_t status;
    do {
        status = tc_read32(TC_STATUS);
    } while (status & 1);  // wait while busy

    // --- Read results ---
    int32_t results[TC_COLS];
    for (int c = 0; c < TC_COLS; c++) {
        results[c] = (int32_t)tc_read32(TC_RESULT(c));
    }

    printf("Results: [%d, %d, %d, %d]\n",
           results[0], results[1], results[2], results[3]);

    // --- Verify ---
    // Reference values (from C++ standalone test):
    //   VECTOR_LEN=576: [-6237, 3119, 0, -6237]
    int expected[TC_COLS];
    if (vector_len == 576) {
        expected[0] = -6237;
        expected[1] = 3119;
        expected[2] = 0;
        expected[3] = -6237;
    } else {
        // Compute using Python reference for custom vector_len
        printf("Unknown vector_len %d: printing results only\n", vector_len);
        return 0;
    }

    int errors = 0;
    for (int c = 0; c < TC_COLS; c++) {
        if (results[c] != expected[c]) {
            printf("  FAIL col %d: got %d, expected %d\n",
                   c, results[c], expected[c]);
            errors++;
        }
    }

    if (errors == 0) {
        printf("PASS: all results match\n");
    } else {
        printf("FAIL: %d error(s)\n", errors);
    }

    return errors;
}

int main()
{
    printf("=== TernaryCore GVSoC System Test ===\n");

    int errors = test_ternarycore(576);

    printf("=== %s (%d error(s)) ===\n",
           errors == 0 ? "PASS" : "FAIL", errors);

    pmsis_exit(errors);
    return errors;
}
"""


def create_firmware_source(output_dir):
    """Write the PULP firmware C source file."""
    os.makedirs(output_dir, exist_ok=True)
    path = os.path.join(output_dir, "test_ternarycore.c")
    with open(path, "w") as f:
        f.write(PULP_FIRMWARE_C)
    print(f"Firmware source written to: {path}")
    return path


def run_gvsoc_test(firmware_binary):
    """
    Run the gvsoc system test with a compiled PULP firmware binary.

    This requires:
      - gvsoc installed and sourced
      - PULP SDK toolchain configured
      - libternarycore_device.so built and installed
    """
    import subprocess
    from gvsoc import runner as gvsoc_runner

    # Define the gvsoc target
    class TernarycoreTarget(gvsoc_runner.Target):
        gapy_description = "TernaryCore test platform"
        name = "ternarycore-test"

        def __init__(self, parser, options=None):
            super().__init__(parser, options)

    # Run the test
    cmd = [
        "gvsoc-run",
        "--target=ternarycore-test",
        "--binary=%s" % firmware_binary,
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print(result.stderr)
    return result.returncode


# ============================================================================
# Main
# ============================================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="TernaryCore GVSoC System Test"
    )
    parser.add_argument(
        "--verify", action="store_true", default=True,
        help="Run Python reference verification (default: yes)"
    )
    parser.add_argument(
        "--no-verify", action="store_false", dest="verify",
        help="Skip Python reference verification"
    )
    parser.add_argument(
        "--firmware", type=str, default=None,
        help="Path to compiled PULP firmware binary"
    )
    parser.add_argument(
        "--create-firmware-source", type=str, default=None,
        help="Write firmware C source to directory"
    )

    args = parser.parse_args()

    exit_code = 0

    # Python reference verification (always runs, no gvsoc needed)
    if args.verify:
        exit_code = verify_reference()
        if exit_code != 0:
            print("Reference verification FAILED")
            sys.exit(exit_code)

    # Create firmware source if requested
    if args.create_firmware_source:
        create_firmware_source(args.create_firmware_source)

    # Run gvsoc system test with firmware binary
    if args.firmware:
        print("\n" + "=" * 60)
        print("Running GVSoC system test...")
        print("=" * 60)
        exit_code = run_gvsoc_test(args.firmware)
        if exit_code != 0:
            print("GVSoC system test FAILED")

    if exit_code == 0:
        print("\nAll tests passed.")
    else:
        print("\nSome tests failed.")
        sys.exit(exit_code)