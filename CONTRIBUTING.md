# Contributing to TernaryCore

## Commit Message Convention

```
<scope>: <what changed>

[optional body: why, not what]
```

| Scope | Use for |
|-------|---------|
| `rtl` | RTL source files |
| `tb` | Testbenches |
| `sim` | Simulation scripts / Makefile |
| `synth` | Synthesis scripts / constraints |
| `bench` | Benchmark results |
| `docs` | build.md, guides, this file |

Examples:
```
rtl: add pipeline register to ternary_mac for timing closure
tb: add signed activation edge cases to tb_ternary_mac
bench: publish Arty A7 timing results at 100 MHz
```

## Branch Strategy

- `main` — stable, simulation-passing only. Never push broken RTL here.
- `feature/<name>` — new modules or significant changes
- `fix/<name>` — bug fixes
- `bench/<name>` — benchmark runs and results

Open a PR from feature branches. Merge to main only after testbench passes locally.

## Rules

1. Never push a module without its testbench in the same commit.
2. Never push RTL to `main` with a failing testbench.
3. `results/benchmarks.md` is append-only — never edit previous entries.
4. All parameters must have comments explaining valid ranges.
