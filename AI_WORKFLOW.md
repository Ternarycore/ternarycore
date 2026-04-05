# AI Workflow Patterns for TernaryCore

This file documents context-efficient patterns for AI agents (Claude, Copilot, etc.) working on this repo via GitHub MCP and jcodemunch MCP. The goal is to minimise token usage while maximising accuracy.

---

## Golden Rules

1. **Never read a file you don't need to edit.** Use outlines and symbol search first.
2. **Never re-read a file you've already read in the same session.**
3. **Commit multi-file changes atomically** with `push_files`, not one file at a time.
4. **Index once per session** with jcodemunch, then query semantically.

---

## GitHub MCP Patterns

### Starting a session — understand recent state cheaply

```
# Check what changed recently (5 lines of context, not the full diff)
mcp: github list_commits owner=shepherdscientific repo=ternarycore

# Read only the file you are about to modify
mcp: github get_file_contents owner=shepherdscientific repo=ternarycore path=rtl/ternary_mac.v
```

Do **not** list the entire directory tree and read every file. Read only what you need.

### Finding a module or pattern without reading every file

```
# Find all Verilog module declarations
mcp: github search_code query="module ternary" repo=shepherdscientific/ternarycore

# Find where a module is instantiated
mcp: github search_code query="ternary_mac" repo=shepherdscientific/ternarycore

# Find all testbench files
mcp: github search_code query="tb_" repo=shepherdscientific/ternarycore
```

### Making changes — always batch into one commit

```
# If you are editing rtl/ternary_dot.v and tb/tb_ternary_dot.v together,
# push both in a single push_files call:
mcp: github push_files owner=shepherdscientific repo=ternarycore branch=main
  files=[
    {path: "rtl/ternary_dot.v",    content: "..."},
    {path: "tb/tb_ternary_dot.v",  content: "..."}
  ]
  message="Add ternary_dot module and testbench"
```

Never push a module without its testbench in the same commit.

### Branching for experimental changes

```
# Create a feature branch before risky changes
mcp: github create_branch owner=shepherdscientific repo=ternarycore
  branch=feature/pipelined-gemm from=main

# Push changes to feature branch, not main
mcp: github push_files ... branch=feature/pipelined-gemm

# Open a PR when ready
mcp: github create_pull_request owner=shepherdscientific repo=ternarycore
  head=feature/pipelined-gemm base=main
```

---

## jcodemunch MCP Patterns

jcodemunch provides semantic code intelligence — use it to understand the codebase structure before reading raw files.

### Session startup — index the repo once

```
# Index at start of session (do this once, not before every query)
mcp: jcodemunch index_repo repo_path=/path/to/ternarycore

# Or if already indexed, check session stats
mcp: jcodemunch get_session_stats
```

### Understanding structure without reading files

```
# Get outline of a file (ports, parameters, module name) without full content
mcp: jcodemunch get_file_outline file=rtl/ternary_gemm.v

# Get the full repo structure at a glance
mcp: jcodemunch get_repo_outline

# Get a ranked set of files relevant to a task
mcp: jcodemunch get_ranked_context query="ternary accumulator pipelining"
```

### Finding symbols and references (critical for HDL)

```
# Find a module by name
mcp: jcodemunch search_symbols query="ternary_mac" type=module

# Find all instantiations of ternary_mac (where is it used?)
mcp: jcodemunch find_references symbol=ternary_mac

# Get the source of a specific symbol without reading the whole file
mcp: jcodemunch get_symbol_source symbol=ternary_mac

# Understand what modules ternary_gemm depends on (blast radius)
mcp: jcodemunch get_blast_radius symbol=ternary_gemm
```

### Before making changes — understand the impact

```
# Before changing a parameter or port in ternary_mac, check what breaks
mcp: jcodemunch get_blast_radius symbol=ternary_mac

# Check if a rename is safe
mcp: jcodemunch check_rename_safe symbol=ternary_mac new_name=ternary_cell

# Get context bundle for a focused task
mcp: jcodemunch get_context_bundle task="add pipeline register to ternary_dot"
```

---

## HDL-Specific Workflow

Verilog modules have a natural hierarchy. Use jcodemunch to navigate it before reading files:

```
top.v
  └── ternary_gemm.v      ← tiled matrix multiply
        └── ternary_dot.v   ← vector dot product
              └── ternary_mac.v  ← single MAC cell  ← start here
```

**Rule:** When asked to modify behaviour, start at the leaf (`ternary_mac`) and check blast radius before touching parent modules.

### Simulation-driven development loop

```
1. get_context_bundle task="failing testbench: tb_ternary_dot"
2. get_symbol_source symbol=ternary_dot        # read only this module
3. get_symbol_source symbol=tb_ternary_dot     # read the failing testbench
4. propose fix
5. push_files [ternary_dot.v] with fix
6. instruct user to run: make tb_ternary_dot
7. iterate on failure output
```

### Never do this

```
# BAD: reads everything, wastes context
mcp: github get_file_contents path=rtl/ternary_mac.v
mcp: github get_file_contents path=rtl/ternary_dot.v
mcp: github get_file_contents path=rtl/ternary_gemm.v
mcp: github get_file_contents path=rtl/top.v

# GOOD: read only what you're changing, use outlines for the rest
mcp: jcodemunch get_repo_outline
mcp: jcodemunch get_symbol_source symbol=ternary_dot  # only the one you need
```

---

## Commit Message Convention

```
<scope>: <what changed>

[optional body: why]
```

| Scope | Use for |
|-------|---------|
| `rtl` | Changes to RTL source files |
| `tb` | Testbench changes |
| `sim` | Simulation scripts / Makefile |
| `synth` | Synthesis scripts / constraints |
| `bench` | Benchmark results |
| `docs` | build.md, README, this file |

Examples:
```
rtl: add pipeline register to ternary_mac for timing closure
tb: add signed activation test cases to tb_ternary_mac
bench: publish Arty A7 timing results at 100MHz
```

---

## File Ownership Quick Reference

| File | What it is | Read before editing? |
|------|-----------|---------------------|
| `rtl/ternary_mac.v` | Leaf MAC cell | Yes — check port list |
| `rtl/ternary_dot.v` | Vector dot product | Yes — instantiates ternary_mac |
| `rtl/ternary_gemm.v` | Matrix multiply | Yes — instantiates ternary_dot |
| `tb/tb_*.v` | Testbenches | Only if fixing a failing test |
| `sim/Makefile` | Simulation runner | Only if adding a new testbench |
| `build.md` | Project roadmap | No — append don't overwrite |
| `results/benchmarks.md` | Published numbers | Always — append only |
