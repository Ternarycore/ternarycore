#!/usr/bin/env python3
"""
verify_mac.py
Python reference implementation for ternary_mac.
Outputs should match tb_ternary_mac.v simulation line-for-line.
"""

def ternary_mac(activation: int, weight_enc: int, acc_in: int) -> int:
    """
    Single ternary MAC cell.
    weight_enc: 0b00 = zero, 0b01 = +1, 0b10 = -1
    activation: signed 8-bit integer (-128 to 127)
    """
    if weight_enc == 0b00:
        weighted = 0
    elif weight_enc == 0b01:
        weighted = activation
    else:  # 0b10
        weighted = -activation
    return acc_in + weighted


# Same test vectors as tb_ternary_mac.v
test_vectors = [
    # (activation, weight_enc, acc_in, expected_acc_out)
    (10,    0b01, 0,   10),   # w=+1, fresh accumulator
    (25,    0b01, 10,  35),   # w=+1, running accumulator
    (10,    0b10, 35,  25),   # w=-1
    (25,    0b10, 25,  0),    # w=-1, back to zero
    (99,    0b00, 42,  42),   # w=0,  acc unchanged
    (127,   0b00, 0,   0),    # w=0,  max activation ignored
    (-5,    0b01, 0,   -5),   # signed activation, w=+1
    (-5,    0b10, 0,   5),    # signed activation, w=-1 => +5
]

errors = 0
print("--- TernaryCore MAC Python Reference ---")
for act, wenc, acc_in, expected in test_vectors:
    result = ternary_mac(act, wenc, acc_in)
    status = "PASS" if result == expected else "FAIL"
    if result != expected:
        errors += 1
    print(f"{status}: act={act:4d}  w={wenc:02b}  acc_in={acc_in:4d}  => {result}  (expected {expected})")

print(f"\n--- {errors} error(s) ---")
if errors == 0:
    print("ALL TESTS PASSED")
else:
    print("FAILURES DETECTED — check test vector definitions")
    raise SystemExit(1)
