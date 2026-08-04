# The next student: shape, task, and why they are one decision

The question was whether to spend the next campaign on tokens per second
or on model quality. The answer is that at this point in the project they
are the same knob, and the measured budget says which way to turn it.

## What the budget actually says about model shape

`tools/shape_budget.py` takes the fused-operator table apart into terms
that scale with something about the model, and re-adds it for shapes that
do not exist yet. Two results, both against intuition:

**Parameter count is 16% of a token.** Weight paging and the seven
projections together are 698 of 4469 ms. Everything else scales with
depth, width and head count. A student with half the parameters is not
twice as fast — the claim "halve the model, double the rate" follows from
the bandwidth ceiling, and this machine has not been anywhere near the
bandwidth ceiling since the pager was finished.

**Query heads are the largest single lever.** Sixteen of them cost 1113
ms — a quarter of a token — for 13% of the parameters. Nothing else in
the model has that ratio. Q·Kᵀ, softmax and P·V all run once per query
head per block, and the only parameters a query head owns are its slice
of `q_proj` and `o_proj`.

| shape | ternary | ms/token @512 | on the board | warm-up tokens per GPU-hour |
|---|---:|---:|---:|---:|
| L28 H1024 I3072 16q/8kv — current | 440 M | 4469 | 1.00× | 1.00× |
| L28 H1024 I3072 **8q**/8kv | 382 M | 3129 | 1.43× | 1.15× |
| L28 H1024 **I2048** 8q/8kv | 294 M | 2866 | 1.56× | 1.50× |
| **L14** H1024 I3072 16q/8kv | 220 M | 2234 | 2.00× | 2.00× |
| L20 H1024 I2048 8q/8kv | 210 M | 2047 | 2.18× | 2.10× |
| **L18 H1024 I2048 8q/8kv** | **189 M** | **1843** | **2.43×** | **2.33×** |

The last column is the point. The same shrink that makes the board 2.4×
faster makes the 5070 Ti 2.3× faster, and `docs/DISTILLATION_PLAN.md`
already records that D3 warm-up was cut from the paper's 10 B tokens to
1–2 B because a single card made it a two-week run. At the recommended
shape, two weeks buys 4–5 B tokens instead. Warm-up tokens, not parameter
count, are what a ternary student at this scale is short of.

So: **shrink the student and spend the savings on warm-up.** Speed and
quality are the same campaign, and the smaller model is better on both.

## The constraint that kills the obvious answers

The array is 1024 wide and 1024 deep and the exporter packs
`GROUPS = out/4`. Every projection's *both* dimensions have to be whole
tiles of 1024, and this project has already lost a week to that
arithmetic on `q_proj`, whose 2048 outputs are the one layer where the
export stride and the array's columns disagree.

`shape_budget.check()` enforces it, and it rejects the three shapes that
otherwise look best:

- **H = 768.** The natural "make it narrower" move. Not a multiple of
  1024, so every projection is a partial tile and a quarter of the array
  idles on every call.
- **4 kv heads at head_dim 128.** GQA 8:4 is the standard modern choice
  and gives 512-wide `k_proj`/`v_proj`. Half a tile.
- **Intermediate 2560.** Between 2048 and 3072 and a multiple of neither.

Width is therefore not available as a lever at all. Depth and query heads
are, which is convenient, because they are the two the budget says are
worth the most.

## Recommendation

**L18, H1024, I2048, 8 query heads over 8 kv heads, head_dim 128.**

189 M ternary parameters, 47.2 MB packed — 180 pages instead of 420. Plus
the tied embedding table, which stays float on the host and does not
change. Predicted 1843 ms/token at a 512-token context, 0.54 tok/s,
against 4469 and 0.22 today.

Three things this deliberately does not do. It does not go below H=1024,
because of the tiling. It does not drop to 4 kv heads, for the same
reason — the memory saving is real and the tile is not. And it does not
chase a general-purpose model: `DISTILLATION_PLAN.md` makes that a
non-goal for good reasons and nothing here changes them.

## The task should produce text

The v1 student was distilled on SST-2, which the plan lists as the easier
of its two candidate tasks. It works — it classifies sentiment, and
`tools/tc_serve.py` now demonstrates exactly that. But it means the
project's only demo of *generation* is a classifier repeating one word,
which reads as a broken machine when the machine is exactly right.

**Summarization for v2** — the plan's other candidate, and the paper's
other demonstrated win. It has published baselines, it is still
task-specialized rather than general chat, and its output is sentences.
The demo becomes a board that reads a paragraph and writes a sentence
about it, which is the same hardware claim told in a form that survives
being shown to someone.

That also changes what the position curve means in public. A classifier
prefills and stops; a summarizer generates, so the 2.9 → 4.7 s curve
across the context is something the audience watches happen rather than
something they read in a table.

## What does not change

The board, and that is the point of having spent this long on it. Same
exporter, same 2-bit packing, same Ethernet loader, same firmware, same
`LOADM`/`PAGEDMA`/`TOK` commands. A new student is a new `weights.bin`
and a new `meta.bin`.

Two shape-dependent constants do need checking on export, and both are
already computed rather than assumed: `PAGE_BYTES × 15` slots per block
assumes seven projections at the current widths, so the page geometry in
`pages.json` changes with I and the head count; and `blk_proj`'s
`nc = nout >> 10, ns = nin >> 10` is exactly the tiling rule above, so a
shape that clears `check()` clears the driver.

## Acceptance

The machinery already exists and it is the reason a model swap is now a
low-risk operation rather than a week:

```
python tools/eth_load.py --image ~/tc-ddr/weights.bin
python tools/ddr_audit.py --meta          # the image is what the file says
bash tools/regress.sh                     # operators, block, token, image
python tools/tokcurve.py                  # and the prediction gets graded
```

`tokcurve.py` against the table above is the honest test of
`shape_budget.py`. The current predictions are a linear model fitted to
two points; the first new shape either confirms them or improves them,
and either way the number that gets published is the measured one.

## Sequence

1. Lock the shape and the task; re-run the D1 teacher audit against the
   tiling rules rather than the old constraints table, which permits
   shapes the array does not.
2. D2/D3 on the new shape — SubLN surgery, then warm-up with the token
   budget the smaller model buys.
3. D4 distillation on summarization.
4. Export, load, audit, regress, `tokcurve`.
5. Then the hardware backlog, in the order the budget gives: DMA for the
   array's operands (~1500 ms at the current shape, and still the largest
   item at the new one), the driver's glue, the fabric normalizer, the
   128-bit weight bus.

The hardware work is worth the same whenever it happens. The shape
decision is worth more the earlier it happens, because everything
downstream of it — warm-up tokens, article 6, the paper's tok/s number —
is priced by it.
