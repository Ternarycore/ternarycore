#!/usr/bin/env python3
"""Mutation testing framework for TernaryCore Verilog RTL.

Usage:
    python3 tests/mutate.py ../rtl/ternary_dot.v <mutation> [args]
    python3 tests/mutate.py ../rtl/activation_quant.v <mutation> [args]

Outputs mutated source on stdout.
"""

import argparse
import re
import sys


def read_file(path):
    with open(path) as f:
        return f.read()


def mutate_swap_binop(content, old_op, new_op):
    pattern = re.escape(old_op) + r'(?=[^=])'
    count = 0
    def repl(m):
        nonlocal count
        count += 1
        return new_op
    result = re.sub(pattern, repl, content)
    if count == 0:
        print(f"// WARNING: swap-binop: '{old_op}' not found", file=sys.stderr)
    return result


def mutate_invert_cond(content, old_val, new_val):
    result = content.replace(f"== {old_val}", f"== {new_val}")
    if result == content:
        print(f"// WARNING: invert-cond: '== {old_val}' not found", file=sys.stderr)
    return result


def mutate_drop_reset(content):
    result = re.sub(
        r"(\s+)(count\s*<=)\s+\S+;",
        r"\1\2 count;",
        content,
    )
    return result


def mutate_sticky_valid(content):
    result = re.sub(
        r"(else begin\s*\n\s+)vector_done\s*<=\s*1'b0;",
        r"\1vector_done <= vector_done;",
        content,
    )
    return result


def mutate_swap_clip(content, old_min, old_max):
    # Swap two numeric values that appear as clip bounds.
    # Mark old_max with a sentinel, replace old_min with old_max,
    # then replace sentinel with old_min.
    sentinel = "__CLIP_SENTINEL__{}__".format(abs(hash(old_max + old_min)) % 1000000)
    result = content.replace(old_max, sentinel)
    result = result.replace(old_min, old_max)
    result = result.replace(sentinel, old_min)
    print(f"// swap-clip: swapped {old_min} <-> {old_max}", file=sys.stderr)
    if result == content:
        print(f"// WARNING: swap-clip: neither '{old_min}' nor '{old_max}' found", file=sys.stderr)
    return result


def mutate_change_param(content, name, value):
    # Match both "parameter name = value" declarations and ".name(value)" overrides
    param_decl = re.compile(rf'(parameter\s+{re.escape(name)}\s*=\s*)\d+')
    inst_override = re.compile(rf'(\.{re.escape(name)}\s*\(\s*)[^)]+(\s*\))')
    result = param_decl.sub(rf'\g<1>{value}', content)
    result = inst_override.sub(rf'\g<1>{value}\g<2>', result)
    if result == content:
        print(f"// WARNING: change-param: '{name}' not found in declaration or override", file=sys.stderr)
    return result


def mutate_negate_compare(content):
    result = re.sub(
        r"(\s+)if\s*\(\s*count\s*==\s*16'b1\s*\)",
        r"\1if (count != 16'b1)",
        content,
    )
    return result


def mutate_bias_off(content):
    result = content.replace("+ round_amt", "")
    return result


def mutate_trunc_round(content):
    result = content.replace("|trunc", "|trunc == 0")
    return result


def mutate_qmax_half(content):
    """Halve Q_MAX (clip bound) - e.g., Q_MAX = 127 -> Q_MAX = 63."""
    result = re.sub(
        r"(Q_MAX\s*=\s*\(1\s*<<\s*\(Q_WIDTH\s*-\s*1\)\)\s*-\s*)1",
        r"\g<1>0",
        content,
    )
    return result


MUTATIONS = {
    "swap-binop": mutate_swap_binop,
    "invert-cond": mutate_invert_cond,
    "drop-reset": mutate_drop_reset,
    "sticky-valid": mutate_sticky_valid,
    "swap-clip": mutate_swap_clip,
    "change-param": mutate_change_param,
    "negate-compare": mutate_negate_compare,
    "bias-off": mutate_bias_off,
    "trunc-round": mutate_trunc_round,
    "qmax-half": mutate_qmax_half,
}


def main():
    parser = argparse.ArgumentParser(description="Apply a mutation to a Verilog source file")
    parser.add_argument("source", help="Verilog source file path")
    parser.add_argument("mutation", choices=list(MUTATIONS.keys()), help="Mutation to apply")
    parser.add_argument("args", nargs="*", help="Additional arguments for the mutation")

    args = parser.parse_args()
    content = read_file(args.source)
    mutator = MUTATIONS[args.mutation]
    result = mutator(content, *args.args)
    sys.stdout.write(result)


if __name__ == "__main__":
    main()
