# Token budget

What one token actually costs on the Arty A7-100T, and where each number
came from.

This is the second time this table has been wrong, and the two failures
are worth keeping side by side because the second one hides inside the
fix for the first.

The first version totalled 593 ms and claimed 1.7 tok/s. Three of its
rows were estimates formatted identically to its measurements, so nothing
distinguished a number that had touched silicon from one that had not.
RoPE was estimated at 11 ms and measured at 120.5. The activation
quantizer had no row at all. The fix was a third column: say where every
number came from.

The second version totalled 744.1 ms and claimed 1.34 tok/s, and every
row said "measured". They were. They were measured on the wrong code.
Those numbers came from `BENCH`, whose operators — `bench_sumsq`,
`bench_quant`, `bench_rope` — are hand-written micro-loops living beside
the real ones. `nq_core` is what actually runs, it is those first two
fused, and it costs 505 ms a token against the 183.1 the table
attributed to them. A benchmark that is a copy of the thing measures the
copy, and the provenance column faithfully recorded that a measurement
had happened without recording what it had been performed on.

So the numbers below come from `OPB`, which does not benchmark anything.
It repeats the actual command handler — byte for byte the one the block
driver calls — with the UART muted so the operator's own report never
lands inside the timing, and the host differences two repetition counts
so the serial round trip subtracts out. `tools/op_bench_fused.py` drives
it and prints the table.

Everything got worse. The token is 4.76 seconds, not 744 ms.

## Per token, 596M parameters, context 512

| | ms | source |
|---|---|---|
| RMSNorm + absmax quantize, fused (NQD) | 505.4 | OPB slope: 3.307 ms × 56 at n=1024, 4.233 × 28 at 2048, 7.204 × 28 at 3072 |
| P·V (PV) | 1035.0 | OPB slope: 2.310 ms × 448 |
| Softmax, table-driven (SM) | 617.4 | OPB slope: 1.378 ms × 448 |
| Weight paging (PAGEDMA) | 645.7 | OPB slope: 1.537 ms × 420 |
| Q·Kᵀ (QKD) | 573.9 | OPB slope: 1.281 ms × 448 |
| QK-norm + RoPE + quantize, fused (QKN) | 401.8 | OPB slope: 9.537 ms × 28 for 16 q-heads, 4.815 × 28 for 8 kv-heads |
| SiLU + gate product (MLP) | 368.5 | OPB slope: 13.160 ms × 28 |
| Projections (PJO) | 345.9 | OPB slope: 0.824 ms × 420 |
| KV append, bit-sliced (KVW) | 268.7 | OPB slope: 9.598 ms × 28 |
| **Total** | **4762.3** | **→ 0.21 tok/s** |
| Same, with the fabric normalizer in place of NQD | 4278.3 | NQF measured at 0.121 / 0.214 / 0.306 ms — 21.4 ms a token, 23.6× |

Call counts come from the block structure, not from assumption: 28
blocks, four normalizations a block at 1024, 1024, 2048 and 3072, one
QKN over all 16 q-heads and one over all 8 kv-heads, sixteen q-heads
through QKD, SM and PV, and fifteen weight pages — 2+1+1+2+3+3+3 for q,
k, v, o, gate, up and down.

Two caveats travel with these numbers, and `op_bench_fused.py` prints
them so they cannot be separated from the table. Repeated calls see
drifting data where a handler transforms its input in place; every loop
here is fixed-trip with no data-dependent branch beyond a max
comparison, which is why that is allowed and why it stops being allowed
the moment one of them is not. And QKD, SM and PV run over whatever the
KV cache currently holds — the trip counts over 512 positions are real,
the values in it are not.

## It depends on where you are in the context

Three of the rows scale with position and six do not, so a single number
for "a token" is a fiction unless the context length is attached to it.

| | attention (QKD+SM+PV) | everything else | total | tok/s |
|---|---|---|---|---|
| position 0 | 391.4 | 2536.0 | 2927.4 | 0.34 |
| position 127 | 608.9 | 2536.0 | 3144.9 | 0.32 |
| position 511 | 2186.5 | 2536.0 | 4722.5 | 0.21 |

(The 4722.5 and the table's 4762.3 are the same three rows measured
twice, twenty minutes apart. The 0.8% between them is the honest noise
floor of this method.)

Position 0 is what `token_loop.py` runs, and it is the cheapest token
this machine will ever produce. Quoting it as the rate would be the
third version of the same mistake.

## Where the time actually goes

Three rows were decomposed further, and all three tell the same story.

**The pager.** One PAGEDMA is 1.537 ms, of which 0.815 is the transfer
and 0.744 is what surrounds it. The transfer moves 256 KB at 321.6 MB/s
against the 325.0 a 32-bit bus at 81.25 MHz can physically deliver, so
the published claim that the pager runs at 99.2% of the bus is true — of
the transfer, which is 53% of the call. The other 0.744 ms is a CDMA
soft reset and 8,192 `wdc.flush` instructions over a 256 KB range. Per
token that is 342.3 ms of transfer and **312.4 ms of setup that has
never appeared in any version of this table.**

**The projections.** PJO computes 1,048,576 ternary MACs and takes 827
µs. Measured against tile count, that is 143 µs to push 1024 activation
bytes in — one AXI-lite write each, 11.4 cycles apiece — and 16 × 42.7
µs for the tiles, each of which is 64 single-word result reads and one
array pass. The array's own share is 1031 cycles: **12.7 µs, or 1.5% of
the call.** The effective rate is 1.27 GMAC/s against the 102 GMAC/s the
array sustains when something keeps it fed.

Across a token the ternary array — the thing this entire project is
about, holding 440M of the model's 596M parameters — is doing arithmetic
for about **5.3 ms of 4762.** That is 0.11%.

**Attention.** PV at position 511 is 2.31 ms per head per block: eight
chunks, each feeding 1024 bytes through a single register, DMA-ing 16 KB
of bit-sliced values, running the array, and reading 64 results back one
word at a time. Same shape, same cause.

## The inversion, restated

| | ms | share |
|---|---|---|
| Soft CPU, elementwise (NQD, QKN, KVW, SM, MLP) | 2161.8 | 45.4% |
| Feeding the array through AXI-lite (PJO, QKD, PV) | 1954.8 | 41.0% |
| Weight memory (PAGEDMA) | 645.7 | 13.6% |
| The array doing arithmetic | ~5.3 | 0.11% |

The previous version of this document said the array no longer waits for
weights, it waits for the CPU. That was right and the split it gave —
46% memory, 45% CPU, 9% array — was wrong in a way that flattered the
design. Memory is 14%, not 46%. The array's 9% was never the array; it
was the CPU handing bytes to the array one AXI-lite word at a time.

This also corrects the equation in article 05. **Parameters ×
tokens/second ≈ 3.6 billion** remains the memory-bandwidth ceiling and
remains real. Measured end to end at context 512 this board sits at
596M × 0.21 = **0.125 billion**. The gap is 29×, not the 4.5× the
previous version reported, and every bit of that gap is now attributable
to a named row.

## Where the next win is, re-ranked

The old version put the 32→128 bit weight bus first. On these numbers it
is fifth, and it is the most expensive of the five to build. That
reversal is the point of having measured.

1. **Delete the per-page cache flush.** 312 ms, one line, no new
   hardware. The weight image is written by the Ethernet DMA and read by
   the CDMA; the CPU never touches it, so no line can be dirty. That
   argument has to be proven against a block check rather than asserted,
   which is the whole cost of this item.
2. **DMA the array's operands and results.** PJO 345.9 → order 30, and
   QKD and PV are the same change. Order 1500 ms — by far the largest
   single item, and it is the identical argument that justified moving
   the normalizer into fabric, now with a measurement behind it instead
   of an intuition.
3. **Use the fabric normalizer.** 484 ms, already built, already closed
   at +0.252 ns, already 15/15 exact against the soft-CPU path. It needs
   the block driver to call NQF instead of NQD and nothing else.
4. **The remaining elementwise operators.** SM 617, QKN 402, MLP 368,
   KVW 269. Streaming, elementwise, trivially pipelined — the shape of
   thing the fabric is good at and a soft CPU is bad at. 1656 ms sitting
   in four operators that resemble the one already proven.
5. **Widen the weight bus 32 → 128 bit.** The transfer goes 342.3 → 85.6,
   saving 257 ms. Real, but smaller than item 1, which is a line of code.

Items 1 through 3 are 2296 ms of a 4762 ms token and require no new
RTL. That is where this goes next.
