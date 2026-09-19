#!/usr/bin/env python3
"""Run reproducible resource sweeps for ternary RTL configurations.

Without ``--source`` this emits analytical candidates from the shared model.
With source files it invokes Yosys for each candidate and adds parsed cell
counts. Vendor timing and power remain intentionally outside this adapter.
"""

from __future__ import annotations

import argparse
import json
import re
import shlex
import shutil
import subprocess
import tempfile
from pathlib import Path

from ternary_hw_generator import generate


def parse_stat(output: str) -> dict[str, int]:
    """Parse stable summary fields from Yosys ``stat`` output."""
    def find(*patterns: str) -> int:
        for pattern in patterns:
            match = re.search(pattern, output)
            if match:
                return int(match.group(1))
        return 0

    cells = find(r"Number of cells:\s+(\d+)", r"(?:^|\n)\s*(\d+) cells")
    wires = find(r"Number of wires:\s+(\d+)", r"(?:^|\n)\s*(\d+) wires")
    bits = find(r"Number of wire bits:\s+(\d+)", r"(?:^|\n)\s*(\d+) wire bits")
    return {
        "cells": cells, "wires": wires, "wire_bits": bits,
    }


def synthesize(*, sources: list[Path], top: str, params: dict[str, int],
               yosys: str = "yosys") -> dict[str, int]:
    if shutil.which(yosys) is None:
        raise RuntimeError(f"{yosys!r} is not installed; omit --source for analytical mode")
    lines = [f"read_verilog -sv {shlex.quote(str(path.resolve()))}" for path in sources]
    lines.append(f"hierarchy -top {top}")
    if params:
        settings = " ".join(f"-set {name} {value}" for name, value in params.items())
        lines.append(f"chparam {settings} {top}")
    lines += [f"synth -top {top}", "stat"]
    with tempfile.NamedTemporaryFile("w", suffix=".ys", delete=False) as script:
        script.write("\n".join(lines) + "\n")
        script_path = script.name
    try:
        try:
            completed = subprocess.run([yosys, script_path],
                                       check=True, text=True,
                                       capture_output=True)
        except subprocess.CalledProcessError as error:
            detail = (error.stderr or error.stdout or "Yosys returned no diagnostics").strip()
            raise RuntimeError(f"Yosys synthesis failed for {top}: {detail}") from error
    finally:
        Path(script_path).unlink(missing_ok=True)
    return parse_stat(completed.stdout + completed.stderr)


def sweep(*, cols: list[int], depths: list[int], data_widths: list[int],
          source: list[Path] | None = None, top: str = "ternary_lut24_bram",
          yosys: str = "yosys", synth_params: dict[str, int] | None = None) -> list[dict]:
    rows = []
    for candidate in generate(cols=cols, depths=depths, data_widths=data_widths):
        row = {"configuration": candidate.__dict__}
        if source:
            params = {"DATA_WIDTH": candidate.data_width,
                      "ACC_WIDTH": candidate.acc_width}
            params.update(synth_params or {})
            row["synthesis"] = synthesize(
                sources=source, top=top,
                params=params, yosys=yosys)
        rows.append(row)
    return rows


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cols", nargs="+", type=int, default=[4, 8])
    parser.add_argument("--depths", nargs="+", type=int, default=[64, 576])
    parser.add_argument("--data-widths", nargs="+", type=int, default=[4, 8])
    parser.add_argument("--source", nargs="+", type=Path)
    parser.add_argument("--top", default="ternary_lut24_bram")
    parser.add_argument("--yosys", default="yosys")
    parser.add_argument("--synth-param", action="append", default=[], metavar="NAME=VALUE",
                        help="explicit RTL parameter override; repeatable")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    synth_params = {}
    for item in args.synth_param:
        name, separator, value = item.partition("=")
        if not separator or not name:
            parser.error(f"--synth-param must use NAME=VALUE: {item!r}")
        try:
            synth_params[name] = int(value)
        except ValueError:
            parser.error(f"synthesis parameter values must be integers: {item!r}")
    rows = sweep(cols=args.cols, depths=args.depths,
                 data_widths=args.data_widths, source=args.source,
                 top=args.top, yosys=args.yosys, synth_params=synth_params)
    rendered = json.dumps(rows, indent=2, sort_keys=True)
    if args.output:
        args.output.write_text(rendered + "\n")
    else:
        print(rendered)


if __name__ == "__main__":
    main()
