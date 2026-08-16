import unittest
from fpga_synthesis_sweep import parse_stat, sweep


class SynthesisSweepTests(unittest.TestCase):
    def test_parse_yosys_stat(self):
        report = "12 wires\n88 wire bits\n34 cells\n"
        self.assertEqual(parse_stat(report), {"cells": 34, "wires": 12, "wire_bits": 88})

    def test_missing_stat_fields_are_explicit(self):
        self.assertEqual(parse_stat("Number of cells: 7"),
                         {"cells": 7, "wires": 0, "wire_bits": 0})

    def test_analytical_mode_is_reproducible_without_yosys(self):
        kwargs = {"cols": [4], "depths": [64], "data_widths": [8]}
        first = sweep(**kwargs)
        self.assertEqual(first, sweep(**kwargs))
        self.assertEqual(first[0]["configuration"]["weight_bytes"], 64)
        self.assertNotIn("synthesis", first[0])


if __name__ == "__main__":
    unittest.main()
