# Desktop inference: where it actually stands

Short version: the model runs on the board and predicts the right token.
It does not yet generate a second one, and the reason is specific rather
than general.

## What works

All twenty-eight transformer blocks execute on the Arty A7-100T, reading
their weights out of the board's own DDR3. The host does three things and
no others: turn the prompt into a token, look up its embedding, and turn
the final hidden state back into logits through the tied embedding table.
What crosses the serial line is one vector each way and one block-float
scale.

```
$ python tools/ternary.py "The" --compare

  'The' -> token 785 ('The')

     1. ' positive'                 16.7912
     2. ' negative'                 15.7042
     3. ' '                          8.2909
     4. ' Positive'                  7.7847
     5. ' positives'                 7.5937

  next token   ' positive'
  28 blocks on the board   1.50 s   (54 ms/block, normalizer in fabric)
  total incl. the wire and the host's lm_head   1.90 s

  float64 reference on the host: ' positive'
  logits rel 0.009246   argmax agrees
```

The model is a Qwen3-0.6B-shaped student: 28 blocks, hidden 1024, 16
query heads over 8 key/value heads at head_dim 128, MLP intermediate
3072, tied embeddings, 596M parameters. 440M of those are ternary
projection weights — 110.1 MB packed four to a byte — and they are
resident in DDR. The other 156M are the tied embedding table, which is
touched twice a token rather than streamed, and stays in float on the
host.

## What it costs

| | |
|---|---|
| One block, fabric normalizer | 52.0 ms |
| One block, soft-CPU normalizer | 66.3 ms |
| Twenty-eight blocks | 1.46 s |
| Plus the wire and the host's lm_head | 1.90 s |
| The same token before the block driver existed | 574.8 s |

That last row is the honest comparison. The old path drove one operator
at a time from the host, and about 130 KB of operands and accumulators
crossed 115200 baud per block. Almost nothing that went away was
arithmetic.

## How far it is from the reference

Two levels, both against the float64 model on the host.

Per block, on `tc_ref`'s own test input:

| block | rel | perturbed input | sensitivity |
|---|---|---|---|
| 0 | 0.003136 | 0.014635 | 232.5x |
| 13 | 0.001635 | 0.008308 | 457.2x |
| 27 | 0.002896 | 0.014662 | 264.8x |

The sensitivity column is not decoration. A relative error alone once
passed this block three times while its MLP contributed nothing at all —
0.028 was exactly the size of the missing half, and it sat under the
threshold. So the input is scaled and the output has to follow.

End to end, one token: **logits rel 0.009246, identical top-5, same
argmax.** The residual stream on the board is int32 with a block-float
scale rather than float64, so the two residual adds quantize; that is
where essentially all of the 0.009 comes from.

The soft-CPU and fabric normalizers agree to the last digit across all
three blocks. Stage 11 proved they matched on five distributions in
isolation; this is the same equality holding inside a block that feeds
its own output through fifteen more operators.

## What does not work

**Generation.** This predicts one token, at position 0.

At position 0 attention over a single key is the value vector itself, so
the KV cache, the softmax and P·V contribute nothing to the result above
— they are not exercised, and they are not wired into the block driver.
Each of them is verified separately at four positions by
`block_multi.py`, which passes: probabilities exact, head output rel
0.000047. What is missing is the plumbing between them and the driver,
and one derivation.

The derivation is the interesting part. The KV cache stores a block-float
scale per key and per value, and today the *host* computes those from the
float64 reference and hands them to the board. On-board they have to come
out of what QKN already knows:

```
scale = mx * 2^(s1+st) * (gmax/32768) / (127 * sqrt(ss * 4^(s1+sq) / hd))
```

with the accumulator's own scale cancelling for q and k, because the
QK-norm defers its division by the root-mean-square — and *not*
cancelling for v, which is absmax-quantized without normalization. `st`
is the gain-product shift; QKN computes it and does not currently report
it.

That formula is where this will go wrong if it goes wrong. A scale that
is off by a constant factor corrupts a term that is small, passes a
relative-error threshold, and looks like rounding. It has happened here
three times — the MLP's spurious multiply, the QK-norm's fixed shift
sized for a theoretical maximum rather than for the data, and the
truncate-versus-round mismatch in the auto-range. So it gets accepted
against `block_multi` at four positions with a sensitivity check, not
against a single number.

## Where the time goes, and where it goes next

The measured budget (`docs/TOKEN-BUDGET.md`, and `tools/op_bench_fused.py`
regenerates it) says the thing this project is about is not the thing
costing the time:

| | share of a token |
|---|---|
| Soft CPU, elementwise | 45% |
| Feeding the array through AXI-lite | 41% |
| Weight memory | 14% |
| **The ternary array doing arithmetic** | **0.11%** |

A projection is 1,048,576 ternary MACs in 827 µs, of which the array's
own share is 1031 cycles — 12.7 µs. The rest is 1024 activation bytes in
and 1024 results out, one 32-bit register access at a time, at about 11
cycles each. The array is not waiting for weights any more. It is waiting
for the CPU to hand it bytes.

So, in measured order of value:

1. **Attention and the KV cache** — worth more than any of the below,
   because without it there is no second token at any speed.
2. **DMA the array's operands and results** instead of poking registers.
   Order 320 ms of the current 1.46 s.
3. **Widen the weight bus 32 → 128 bit.** The RTL and testbench pass at
   15.8 B/cycle; it needs its own build. Order 250 ms.

Items 2 and 3 are both smaller than they look, which is itself the
finding: the pager now runs at 98.9% of what a 32-bit AXI bus can
physically deliver, and making it faster no longer moves the number much.

## Running it

The board must be programmed and the weight image resident in DDR.
`tools/ternary.py` checks both before it computes anything — an empty DDR
produces zeros through every projection, and the argmax of a constant
vector is still a token, which looks exactly like an answer.

```
python tools/eth_load.py            # 110.1 MB into DDR, 20.2 s
python tools/build_ddr_meta.py      # the block constants
python tools/ternary.py "The" --compare
```

Iterating on firmware without losing the weights:

```
~/Applications/2025.2/Vivado/bin/xsdb Arty7/reload.tcl firmware/ddr_host.elf
```

`Arty7/program.tcl` reconfigures the fabric and takes the DDR3 controller
down with it, which costs the entire 110 MB. Use it only when the
bitstream itself changed.
