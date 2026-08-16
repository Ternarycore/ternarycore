#!/usr/bin/env python3
import unittest

from fpga_cost_model import estimate


class CostModelTests(unittest.TestCase):
    def test_default_shape(self):
        result = estimate(cols=4, depth=576)
        self.assertEqual(result.weight_bits, 4608)
        self.assertEqual(result.weight_bytes, 576)
        self.assertEqual(result.weight_bram18, 1)
        self.assertEqual(result.activation_bytes_per_vector, 576)
        self.assertEqual(result.output_bytes_per_vector, 16)
        self.assertEqual(result.cycles_per_vector, 577)
        self.assertGreater(result.stream_bandwidth_mib_s,
                           result.activation_bandwidth_mib_s)

    def test_scaling_is_monotonic(self):
        narrow = estimate(cols=4, depth=64)
        wide = estimate(cols=8, depth=64)
        deep = estimate(cols=4, depth=128)
        self.assertGreater(wide.weight_bits, narrow.weight_bits)
        self.assertGreater(deep.cycles_per_vector, narrow.cycles_per_vector)
        self.assertGreater(wide.relative_lut_cost, narrow.relative_lut_cost)

    def test_rejects_invalid_parameters(self):
        with self.assertRaises(ValueError):
            estimate(cols=0, depth=4)
        with self.assertRaises(ValueError):
            estimate(cols=4, depth=4, frequency_mhz=0)


if __name__ == "__main__":
    unittest.main()
