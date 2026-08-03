# Token budget

What one token actually costs on the Arty A7-100T, and where each number
came from. The previous version of this table totalled 593 ms and claimed
1.7 tok/s. It was wrong, and it was wrong in a specific way worth naming:
three of its rows were estimates formatted identically to its measurements,
so nothing distinguished a number that had touched silicon from one that
had not.

RoPE was estimated at 11 ms and measured at 120.5. RMSNorm was estimated
at 18 ms; its sum-of-squares alone measured 196.6. The activation
quantizer — which runs six times per block over roughly 315,000 elements
a token — had no row at all. It was never judged cheap. It was never
counted.

Hence the third column.

## Per token, 596M parameters, 512 context

| | ms | source |
|---|---|---|
| Weight paging, 420 pages × 0.8125 ms | 341.3 | measured, slope across 256/512/1024 pages |
| Sum of squares (RMSNorm, vector half) | 113.1 | measured, 32.05 cyc/elem × 286,720 |
| Softmax, table-driven | 89.0 | measured |
| Activation quantizer, absmax int8 | 70.0 | measured, 18.02 cyc/elem × 315,392 |
| Attention MACs on the array | 67.0 | **derived** from 8 MACs/cycle, 4-bit P·V |
| Per-head divides | 24.0 | measured |
| SiLU, table-driven | 20.0 | measured |
| RoPE | 19.7 | measured, 18.59 cyc/elem × 86,016 |
| **Subtotal** | **744.1** | **→ 1.34 tok/s** |
| RMSNorm gain multiply | ? | **not yet measured** |

The last row is left blank on purpose. It is one more pass over the same
286,720 elements and it is certainly not free, but writing a plausible
number there is exactly how this table broke the first time.

## What the 64-bit experiment found

Three operators used `long long`, and all three were slow. The obvious
hypothesis — that a 32-bit CPU synthesising 64-bit multiply-shift out of
parts is the cost — turned out to be right once, half right once, and
wrong once.

| | 64-bit | 32-bit | |
|---|---|---|---|
| RoPE | 113.78 | 18.59 | 6.1× — pure 64-bit overhead |
| Sum of squares | 55.71 | 32.05 | 1.7× — the rest is its two passes |
| Quantizer | 18.02 | 18.02 | no change; the compiler had already reduced it |

The quantizer result is the useful one. Its 18 cycles per element are
instruction count and two passes over the vector, not arithmetic width,
so no amount of narrowing will touch it. What would touch it is fusing
the max-scan into the loop that produces the vector in the first place —
a structural change to the firmware, not a change to the arithmetic.

## The inversion

Add it up by category:

| | ms | share |
|---|---|---|
| Memory (weight paging) | 341.3 | 46% |
| Soft CPU (everything non-matrix) | 335.8 | 45% |
| Array (all matmuls, attention included) | 67.0 | 9% |

Every article this project has published makes the same argument: the
array is never the bottleneck, it sits idle waiting for weights, and the
engineering is all about making it wait less. That was true, and the
pager now runs at 99.2% of what a 32-bit AXI bus can physically deliver.

It is no longer the whole story. Having made memory nearly optimal and
the matmuls nearly free, the 5% of a transformer that *isn't* matrix
multiplication has become as expensive as the 95% that is. The array
doesn't wait for weights any more. It waits for the CPU.

This also corrects the equation in article 05. **Parameters × tokens/second
≈ 3.6 billion** is the memory-bandwidth *ceiling*, and it is real — but it
describes a machine that spends zero time on softmax, normalisation and
quantization. Measured end to end this board sits near **0.8 billion**.
The gap between those two numbers is the soft CPU, and quoting only the
first one overstates the achievable rate by more than four times.

## Where the next win is

Widening the weight bus 32 → 128 bit takes paging from 341 ms to about
85 and the total to roughly 488 ms — 2.0 tok/s, not the ~3 previously
projected, because the CPU's 336 ms does not move. That campaign is now
worth less than it looked.

The larger target is the operator set:

1. **Fuse the passes.** The quantizer's max-scan and RMSNorm's
   sum-of-squares both re-read vectors that were just written by the
   operator before them. Folding them into the producing loop removes
   whole traversals rather than instructions inside one.
2. **Put the operators next to the array.** RMSNorm and the quantizer are
   streaming, elementwise and trivially pipelined — exactly the shape of
   thing the fabric is good at and a soft CPU is bad at.

Both should be measured before either is built, which is the discipline
this document exists to enforce.
