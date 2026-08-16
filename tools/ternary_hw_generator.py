#!/usr/bin/env python3
"""Generate and rank technology-neutral ternary FPGA configurations.

The generator deliberately emits declarative JSON rather than vendor project
files.  This keeps the search reproducible and lets a later synthesis adapter
consume exactly the same configurations.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from itertools import product

from fpga_cost_model import estimate


@dataclass(frozen=True)
class Candidate:
    cols: int
    depth: int
    data_width: int
    acc_width: int
    frequency_mhz: float
    score: float
    cycles_per_vector: int
    weight_bytes: int
    bram_blocks: int
    relative_lut_cost: int


def generate(*, cols: list[int], depths: list[int], data_widths: list[int],
             acc_width: int = 32, frequency_mhz: float = 100.0,
             bram_bits: int = 18 * 1024, limit: int | None = None) -> list[Candidate]:
    """Return candidates ranked by throughput per relative LUT cost.

    Every candidate is derived from the shared analytical model.  ``limit``
    is applied only after ranking, so repeated runs remain deterministic.
    """
    candidates: list[Candidate] = []
    for col, depth, width in product(cols, depths, data_widths):
        result = estimate(cols=col, depth=depth, data_width=width,
                          acc_width=acc_width, frequency_mhz=frequency_mhz,
                          bram_bits=bram_bits)
        score = result.vectors_per_second / max(result.relative_lut_cost, 1)
        candidates.append(Candidate(
            cols=col, depth=depth, data_width=width, acc_width=acc_width,
            frequency_mhz=frequency_mhz, score=score,
            cycles_per_vector=result.cycles_per_vector,
            weight_bytes=result.weight_bytes, bram_blocks=result.bram_blocks,
            relative_lut_cost=result.relative_lut_cost,
        ))
    candidates.sort(key=lambda item: (-item.score, item.cols, item.depth,
                                      item.data_width))
    return candidates if limit is None else candidates[:limit]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cols", nargs="+", type=int, default=[4, 8])
    parser.add_argument("--depths", nargs="+", type=int, default=[64, 128, 576])
    parser.add_argument("--data-widths", nargs="+", type=int, default=[4, 8])
    parser.add_argument("--acc-width", type=int, default=32)
    parser.add_argument("--frequency-mhz", type=float, default=100.0)
    parser.add_argument("--bram-kib", type=int, default=18)
    parser.add_argument("--limit", type=int)
    args = parser.parse_args()
    rows = generate(cols=args.cols, depths=args.depths,
                    data_widths=args.data_widths, acc_width=args.acc_width,
                    frequency_mhz=args.frequency_mhz,
                    bram_bits=args.bram_kib * 1024, limit=args.limit)
    print(json.dumps([asdict(row) for row in rows], indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
