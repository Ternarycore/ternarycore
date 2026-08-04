# Desktop inference: where it actually stands

Short version: the model runs on the board and generates. Prompt tokens
are prefilled, each position writes the KV cache on the board as it goes,
and the sequence that comes out matches the float64 reference token for
token.

## What works

All twenty-eight transformer blocks execute on the Arty A7-100T, reading
their weights out of the board's own DDR3. The host does three things and
no others: turn the prompt into a token, look up its embedding, and turn
the final hidden state back into logits through the tied embedding table.
What crosses the serial line is one vector each way and one block-float
scale.

```
$ python tools/ternary.py "The movie was" -n 6 --compare

  'The movie was' -> 3 tokens, then 6 generated

    The movie was positive positive positive positive positive positive

  generated    ' positive positive positive positive positive positive'
  8 positions x 28 blocks   37.06 s   (4.63 s/token, normalizer in fabric)

  float64 reference on the host: ' positive positive positive positive positive positive'
  token ids  board [6785, 6785, 6785, 6785, 6785, 6785]
             host  [6785, 6785, 6785, 6785, 6785, 6785]
  AGREE
```

The output is degenerate -- it repeats one word -- and that is the model,
not the machine. The student was distilled on SST-2 and this is what it
has to say. The claim here is that the board reproduces the reference
exactly, token for token, not that the reference is interesting.

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

## What broke, and why nothing caught it

Attention was written, verified at position 0, and then failed at every
position after it -- 4 to 6% out on the block output, with the worst head
orthogonal to the reference. Three days of the diagnosis are worth one
paragraph because the shape recurs.

The attention code was correct as written. The DDR weight image was not:
it held q_proj's page 1 bytes at page 0's address, so both of that
projection's output blocks were computed from the same weights. What
separated data from code was running the same test through both pagers --
the DMA engine and the original CPU for-loop -- and getting identical
aliasing. That single comparison eliminated the DMA, the page loader and
the projection loop at once, and pointed at the bytes.

Position 0 hid it completely, because a softmax over one key returns 1.0
regardless of what q says. And nothing else had ever looked: **q_proj's
pages are the only pages in the image no test reads**, since the old block
driver computed q and discarded it -- attention over a single key is the
value vector. `block_check` verifies q_proj against host-packed weights
sent over the wire, never out of DDR.

So the audit now exists, and it is the real lesson:

```
$ python tools/ddr_audit.py --meta
  420 pages in 13.9 s
  28 constant records checked
  every page matches the file
```

`eth_load` has always verified each transfer as it writes it. That is a
check on the wire -- it says the bytes arrived, and nothing about what is
in memory an hour later. DSUM computes the same weighted sum on the
board, so 110 MB can be checked against the file in fourteen seconds.

Two smaller corrections from the same hunt, recorded because both were
reported as facts before they were checked. The board is fully
deterministic; an apparent non-determinism came from comparing two probe
runs whose *host* code differed. And three separate probes read a slot
after `BLK` returned and got whatever wrote that slot last -- the driver
reuses them, which is a property of the driver and a trap for anything
that inspects it.

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

1. ~~**Attention and the KV cache**~~ — done. The block output is within
   0.0011 to 0.0106 of the golden model at four positions on three
   blocks, sensitivity 73x to 678x throughout.
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
