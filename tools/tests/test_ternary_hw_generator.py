import unittest

from ternary_hw_generator import generate


class HardwareGeneratorTests(unittest.TestCase):
    def test_enumerates_and_ranks_deterministically(self):
        rows = generate(cols=[4, 8], depths=[64, 128], data_widths=[4, 8])
        self.assertEqual(len(rows), 8)
        self.assertEqual(rows, generate(cols=[4, 8], depths=[64, 128],
                                        data_widths=[4, 8]))
        self.assertGreaterEqual(rows[0].score, rows[-1].score)

    def test_limit_is_applied_after_ranking(self):
        full = generate(cols=[4, 8], depths=[64, 128], data_widths=[8])
        rows = generate(cols=[4, 8], depths=[64, 128], data_widths=[8], limit=1)
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0], full[0])

    def test_candidates_preserve_ternary_storage_properties(self):
        row = generate(cols=[4], depths=[576], data_widths=[8])[0]
        self.assertEqual(row.weight_bytes, 576)
        self.assertEqual(row.bram_blocks, 1)
        self.assertGreater(row.relative_lut_cost, 0)


if __name__ == "__main__":
    unittest.main()
