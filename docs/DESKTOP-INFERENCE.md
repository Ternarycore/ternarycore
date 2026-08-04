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

The output is degenerate — it repeats one word — and that is the model,
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

`TOK` is one command in and one line out, so timing it is the board
alone, with the wire and the host's `lm_head` excluded:

| position | s/token | ms/block |
|---:|---:|---:|
| 0 | 2.880 | 102.8 |
| 63 | 2.880 | 102.8 |
| 127 | 3.023 | 108.0 |
| 255 | 3.568 | 127.4 |
| 511 | 4.656 | 166.3 |

Six of the nine operators in a block do not depend on position and three
do, so the flat part is everything except attention and the slope is
Q·Kᵀ, softmax and P·V walking the context.

`tools/ternary.py` reports about 4.63 s/token on a short prompt, which is
the board plus roughly 1.75 s of wire — of which 0.4 s is deliberate
settling delay in the host loader.

For the record, the same token before the block driver existed: **574.8
s**. Almost nothing that went away was arithmetic. It was about 130 KB of
operands and accumulators crossing 115200 baud per block.

The measured budget in `docs/TOKEN-BUDGET.md` predicted 4469 ms at a
512-token context against 4656 measured — 4.2% out, from a table
assembled before the thing it describes could run. At position 0 the gap
is wider and more useful: 2634 predicted against 2880 measured, 9.3% out.
The missing 246 ms is not in any operator row because it is not an
operator. It is the driver's own bookkeeping — the residual adds' 64-bit
multiply per element, sixteen attention heads brought onto a common
exponent, a gain copied out of DDR, a query head copied into place, and a
checksum loop inside the QK-norm that the driver does not need. The
operators are 91% of a token at position 0 and 96% at 512.

## How far it is from the reference

Two levels, both against the float64 model on the host.

Per block, at four positions, with the input scaled by 0.25 and the
output required to follow:

| block | pos 0 | pos 1 | pos 2 | pos 3 | sensitivity |
|---|---|---|---|---|---|
| 0 | 0.002367 | 0.001094 | 0.006586 | 0.006650 | 111x – 678x |
| 13 | 0.001545 | 0.002054 | 0.003105 | 0.005629 | 135x – 484x |
| 27 | 0.002898 | 0.008532 | 0.010589 | 0.008300 | 73x – 265x |

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

## What broke, and what was actually causing it

Attention was written, verified at position 0, and then failed at every
position after it — 4 to 6% out on the block output, with the worst head
orthogonal to the reference. The attention code was correct as written.
The DDR weight image was not: page 0, which is block 0's `q_proj`, held
bytes that did not match the file.

What separated data from code was running the same test through both
pagers — the DMA engine and the original CPU for-loop — and getting
identical wrong answers. That single comparison eliminated the DMA, the
page loader and the projection loop at once, and pointed at the bytes.

Rewriting the page from the file fixed it. Then it came back, with the
same three failing positions and the same numbers, and the second time
the cause was findable:

**the test suite was writing the corruption.** `block_check.load_bytes`
and `stage2_check.load_page` both took `ddr_off=0` by default, and 0 is
page 0. Every run of `block_check` or `block_multi` sent host-packed
weights — packed for a 1024-output slice, not for the image's 2048-output
`q_proj` layout — to that address and left them there.

It went unseen for months for a specific reason. Until attention was
wired in, the block driver computed q and threw it away, because at
position 0 attention over a single key collapses to the value vector. So
the one page the suite corrupted was the one page nothing read. And
`block_check` verifies `q_proj` against host-packed weights sent over the
wire, never out of DDR — it could not have noticed either. The moment q
started mattering, the suite began breaking the thing it was there to
verify, once per run, and the failure looked exactly like an arithmetic
bug in attention.

Two changes. Tests load at `SCRATCH = 0x0D800000`, clear of the image,
the KV cache, the vector slots and the benchmark buffer. And
`stage2_check.scratch_only` refuses any `LOADM` below the end of the
image, so the next tool that tries this gets an error rather than a
silent success.

The audit that would have caught it in seconds now exists:

```
$ python tools/ddr_audit.py --meta
  420 pages in 13.4 s
  28 constant records checked
  every page matches the file
```

`eth_load` has always verified each transfer as it writes it. That is a
check on the wire — it says the bytes arrived, and nothing about what is
in memory an hour later. DSUM computes the same weighted sum on the
board, so 110 MB can be checked against the file in fourteen seconds. The
weighting matters: a plain byte sum is order-blind, and one once reported
a perfect match on a page whose weights had been scrambled.

Two smaller corrections from the same hunt, recorded because both were
reported as facts before they were checked. The board is fully
deterministic; an apparent non-determinism came from comparing two probe
runs whose *host* code differed. And three separate probes read a slot
after `BLK` returned and got whatever wrote that slot last — the driver
reuses them, which is a property of the driver and a trap for anything
that inspects it.

## The regression

One command, and the order is deliberate:

```
$ bash tools/regress.sh

  === the resident image against the file            ok
  === the fabric normalizer against the soft CPU     ok
  === attention at four positions, three blocks      ok
  === the attention operators at four positions      ok
  === a generated sequence against the golden model  ok
  === the resident image again, after all of the above   ok

  ALL PASS
```

The image is checked first because every other result is downstream of
it, and a wrong image makes all of them lies. It is checked again at the
end because "the suite left the machine as it found it" is a property
worth testing, and this suite did not have it.

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
   Order 1500 ms of a token, and now by some distance the largest single
   item.
3. **The driver's own glue**, 246 ms at position 0 and unmeasured until
   the budget was graded against the machine. The checksum loop inside
   the QK-norm is free to delete and also buys LMB, which is at
   64,292 of 65,536 bytes and is now the binding constraint on firmware
   growth.
4. **Widen the weight bus 32 → 128 bit.** The RTL and testbench pass at
   15.8 B/cycle; it needs its own build. Order 250 ms.

Item 4 is smaller than it looks, which is itself the finding: the pager
now runs at 98.9% of what a 32-bit AXI bus can physically deliver, and
making it faster no longer moves the number much.

## Running it

The board must be programmed and the weight image resident in DDR.
`tools/ternary.py` and `tools/tc_serve.py` both check before they compute
anything — an empty DDR produces zeros through every projection, and the
argmax of a constant vector is still a token, which looks exactly like an
answer.

```
python tools/eth_load.py            # 110.1 MB into DDR, 20.2 s
python tools/build_ddr_meta.py      # the block constants
python tools/ternary.py "The movie was" -n 6 --compare
bash tools/regress.sh               # everything that has to still be true
```

To show someone, rather than to test it:

```
python tools/tc_serve.py            # http://127.0.0.1:8080
tailscale serve --bg 8080           # and now it is on your tailnet
```

`tc_serve.py` streams tokens as they are produced, holds the board under
a lock so two requests cannot interleave commands on one UART, and binds
to localhost by default — `tailscale serve` puts TLS and tailnet identity
in front of it without this process ever listening on anything routable.

Iterating on firmware without losing the weights:

```
~/Applications/2025.2/Vivado/bin/xsdb Arty7/reload.tcl firmware/ddr_host.elf
```

`Arty7/program.tcl` reconfigures the fabric and takes the DDR3 controller
down with it, which costs the entire 110 MB. Use it only when the
bitstream itself changed.
