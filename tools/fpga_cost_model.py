#!/usr/bin/env python3
"""Small analytical model for ternary FPGA design-space exploration.

The model is intentionally technology-neutral: it estimates storage,
bandwidth, latency, and a relative LUT cost before committing to RTL.
It is useful for comparing COLS/DEPTH/precision choices, not for replacing
post-synthesis reports.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass


@dataclass(frozen=True)
class Estimate:
    cols: int
    depth: int
    data_width: int
    acc_width: int
    frequency_mhz: float
    weight_bits: int
    weight_bytes: int
    weight_bram18: int
    activation_bytes_per_vector: int
    output_bytes_per_vector: int
    cycles_per_vector: int
    vectors_per_second: float
    activation_bandwidth_mib_s: float
    output_bandwidth_mib_s: float
    stream_bandwidth_mib_s: float
    relative_lut_cost: int


def estimate(*, cols: int, depth: int, data_width: int = 8,
             acc_width: int = 32, frequency_mhz: float = 100.0,
             bram_bits: int = 18 * 1024) -> Estimate:
    """Estimate one streamed ternary GEMM row.

    ``relative_lut_cost`` is a comparable proxy, not a vendor-specific LUT
    count: each column pays for an accumulator and an add/sub/skip selector.
    """
    for name, value in (("cols", cols), ("depth", depth),
                        ("data_width", data_width), ("acc_width", acc_width),
                        ("bram_bits", bram_bits)):
        if value <= 0:
            raise ValueError(f"{name} must be positive")
    if frequency_mhz <= 0:
        raise ValueError("frequency_mhz must be positive")

    weight_bits = cols * depth * 2
    activation_bytes = math.ceil(depth * data_width / 8)
    output_bytes = math.ceil(cols * acc_width / 8)
    cycles = depth + 1  # one finalization cycle after the streamed depth
    vectors_per_second = frequency_mhz * 1_000_000 / cycles
    bandwidth = activation_bytes * vectors_per_second / (1024 * 1024)
    output_bandwidth = output_bytes * vectors_per_second / (1024 * 1024)
    lut_proxy = cols * (acc_width + data_width + 2)
    return Estimate(
        cols=cols, depth=depth, data_width=data_width, acc_width=acc_width,
        frequency_mhz=frequency_mhz, weight_bits=weight_bits,
        weight_bytes=math.ceil(weight_bits / 8),
        weight_bram18=math.ceil(weight_bits / bram_bits),
        activation_bytes_per_vector=activation_bytes,
        output_bytes_per_vector=output_bytes,
        cycles_per_vector=cycles,
        vectors_per_second=vectors_per_second,
        activation_bandwidth_mib_s=bandwidth,
        output_bandwidth_mib_s=output_bandwidth,
        stream_bandwidth_mib_s=bandwidth + output_bandwidth,
        relative_lut_cost=lut_proxy,
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cols", type=int, default=4)
    parser.add_argument("--depth", type=int, default=576)
    parser.add_argument("--data-width", type=int, default=8)
    parser.add_argument("--acc-width", type=int, default=32)
    parser.add_argument("--frequency-mhz", type=float, default=100.0)
    parser.add_argument("--bram-kib", type=int, default=18)
    args = parser.parse_args()
    print(json.dumps(asdict(estimate(
        cols=args.cols, depth=args.depth, data_width=args.data_width,
        acc_width=args.acc_width, frequency_mhz=args.frequency_mhz,
        bram_bits=args.bram_kib * 1024,
    )), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
