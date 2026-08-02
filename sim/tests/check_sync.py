#!/usr/bin/env python3
"""Check or fix RTL file sync across worktrees.

Usage:
  python3 check_sync.py [--fix] [file1.v file2.v ...]

If no files are specified, checks all tracked RTL files.
Exit code 0 = all in sync, 1 = differences found.
"""

import argparse
import hashlib
import os
import subprocess
import sys

WORKTREE_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
WORKTREES = ["rtl", "verification", "tooling", "gvsoc"]
TRACKED_FILES = [
    "rtl/ternary_dot.v",
    "rtl/ternary_gemm.v",
    "rtl/ternary_pipeline.v",
    "rtl/ternary_scale.v",
    "rtl/activation_quant.v",
]


def sha256(path):
    sha = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            sha.update(chunk)
    return sha.hexdigest()


def check_files(files, worktree_dir):
    errors = []
    for f in files:
        canonical = os.path.join(worktree_dir, "rtl", f)
        if not os.path.exists(canonical):
            errors.append(f"rtl/{f}: canonical file missing in rtl/ worktree")
            continue
        canonical_hash = sha256(canonical)

        for wt in WORKTREES:
            if wt == "rtl":
                continue
            copy_path = os.path.join(worktree_dir, wt, "rtl", f)
            if not os.path.exists(copy_path):
                errors.append(f"rtl/{f}: missing in {wt}/ worktree")
                continue
            copy_hash = sha256(copy_path)
            if canonical_hash != copy_hash:
                errors.append(f"rtl/{f}: MISMATCH between rtl/ and {wt}/")
    return errors


def fix_files(files, worktree_dir):
    for f in files:
        canonical = os.path.join(worktree_dir, "rtl", f)
        for wt in WORKTREES:
            if wt == "rtl":
                continue
            copy_path = os.path.join(worktree_dir, wt, "rtl", f)
            os.makedirs(os.path.dirname(copy_path), exist_ok=True)
            subprocess.run(["cp", canonical, copy_path], check=True)
            print(f"  Copied rtl/{f} -> {wt}/rtl/{f}")


def main():
    parser = argparse.ArgumentParser(description="Check or fix RTL sync across worktrees")
    parser.add_argument("files", nargs="*", help="RTL files to check (relative to rtl/)")
    parser.add_argument("--fix", action="store_true", help="Copy canonical rtl/ copies to all worktrees")
    args = parser.parse_args()

    files = args.files or [os.path.relpath(p, "rtl") for p in TRACKED_FILES]

    worktree_dir = WORKTREE_ROOT

    if args.fix:
        fix_files(files, worktree_dir)
        print("Sync complete.")
        return

    errors = check_files(files, worktree_dir)
    if errors:
        for e in errors:
            print(f"FAIL: {e}")
        sys.exit(1)
    else:
        count = len(files)
        plural = f"{count} file{'s' if count != 1 else ''}"
        print(f"All {plural} in sync across {len(WORKTREES)} worktrees")


if __name__ == "__main__":
    main()
