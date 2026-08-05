# D2 — the pruned student, and what it cost

D1 passed both shapes through the gate and left one thing undecided:
Plan A, where the student *is* the teacher with SubLN inserted, against
Plan B, where the student is first pruned to L18 H1024 I2048 8q/8kv and
then distilled. The hardware answer favoured B by 2.43×. This is the
training answer, and it took four measurements to get to something
defensible.

## The first number was a disaster

`tools/prune_student.py` makes the three cuts D1 identified — 18 layers
of 28 by an angular criterion, one query head of each kv pair by output
norm, 2048 MLP channels of 3072 by mean activation magnitude. Every
selection is measured on DialogSum calibration data rather than assumed.
Nothing is trained; the point is to produce the initialisation D3's
warm-up starts from, and to record the damage before it.

The damage was **1,567,100,007** summary perplexity against the
teacher's **8.205**.

That is not a model, it is noise. And the decomposition said the cuts
were not equally to blame: dropping the ten layers *alone* cost 28,444,
so the head and channel cuts added another four and a half orders of
magnitude on top of a number that was already bad.

## It was a scale problem, not a selection problem

`o_proj` sums over sixteen query heads and now gets eight. `down_proj`
sums over 3072 MLP channels and now gets 2048. Slicing the weight matrix
keeps every surviving term at its original coefficient, so the sum comes
out systematically short — and every downstream RMSNorm gain was fitted
to the full one. Over eighteen layers that compounds into noise.

The fix is the reconstruction step every structured-pruning recipe has
and this project skipped. Do not slice the matrix, **refit** it:

    W_new = argmin || W X_kept − Y_full ||

The surviving coefficients move to cover for the missing ones. It is a
linear least squares in 1024 or 2048 dimensions, solved from normal
equations accumulated over calibration tokens, so memory is O(d²)
whatever the calibration size.

`tools/prune_reconstruct.py` does exactly that, with the teacher's own
activations on both sides. **1.567e9 → 81,174**, in under a minute.

Nineteen thousand times better on one linear solve per projection
settles the diagnosis: the information was still there and the
coefficients were wrong.

## Then it was a drift problem

81,174 is still worse than dropping the layers and doing nothing else
(28,444), and the reason is written into the method. Local reconstruction
takes X and Y both from the teacher, so layer 9 is fitted to reproduce
the teacher's layer 9 *given the teacher's inputs* — inputs the pruned
model will never produce.

`tools/prune_seq.py` changes one thing:

> **X comes from the student, Y still comes from the teacher.**

Each layer is now fitted to reproduce the teacher's output given the
input the pruned model will actually hand it, drift and all, so it
absorbs the error the layers before it introduced — including the error
from blocks that are not there any more. That only works in order,
because the student's hidden state at layer j depends on the refit at
every layer before it, so the two towers walk forward together: the
teacher through all 28 of its blocks, the student through its 18, solving
and writing back at each block the student keeps.

**81,174 → 3855** at 128 calibration examples, **3227** at 512. It beats
depth-only pruning, which local reconstruction never could.

The residual tables say why. Measured against the teacher's own
trajectory, `o_proj`'s sliced residual at block 17 is 0.22; measured
against the student's, it is 2.53. Local reconstruction could not see
that error because it never looked at the input the student produces.

### A negative result worth keeping

`--full` refits all seven projections instead of the two that lost a
summation dimension. It drives the intermediate residuals down hard —
block 17's `up_proj` goes 1.81 → 0.069, a factor of 26 — and moves the
end number by 0.2%: **3855.4 → 3848.3**.

So the drift that matters is concentrated at the two projections that sum
over the pruned axis. The other five are fine sliced. That is worth
knowing before anyone spends a week on a fancier reconstruction.

## The measurement that actually decides Plan B

Depth was fixed at 18 because the ladder said 2.43×. Nobody had checked
what depth costs in quality, so the sweep is the whole point:

| depth | board ms/token | vs today | pages | sliced | after reconstruction | vs teacher |
|---:|---:|---:|---:|---:|---:|---:|
| L18 | 1843 | 2.43× | 180 | 1.567e9 | 3227 | 393× |
| L20 | 2047 | 2.18× | 200 | 4.173e8 | 266 | 32× |
| L22 | 2252 | 1.98× | 220 | 1.437e8 | 157 | 19× |
| L24 | 2457 | 1.82× | 240 | 8.689e7 | 144 | 17× |
| **L28** | **2866** | **1.56×** | **280** | 5.271e8 | **14.9** | **1.8×** |

Every row is the same head and channel cuts and the same 512-example
sequential reconstruction; only the depth moves. The teacher is 8.205.

The last row keeps every block, so it is a **width-only** student: 8 query
heads of 16, 2048 MLP channels of 3072, and nothing dropped. It
reconstructs to **14.9** — 1.8× the teacher, with no training of any
kind — and still runs 1.56× faster than what is resident on the board
today.

So the finding is not the one the ladder was built to answer. Width
pruning is nearly free once you reconstruct. **Depth pruning is what was
destroying the model**, and the two effects had been measured together
and blamed on the wrong one.

The curve says the rest. There is a cliff between 18 and 20 layers —
two blocks are worth a factor of twelve — then a plateau from 20 to 24
where quality barely moves, then everything left is recovered by the last
four blocks. There is no depth between 18 and 28 that is a good trade:
the plateau rows all sit an order of magnitude worse than L28 while
giving up under half the speed advantage.

**L28 width-only is the shape to build.** 1.56× on the board, and an
initialisation D3 starts from at 14.9 instead of 3227.

## What changes downstream

The width-only student needs the same firmware change D1 already costed:
`SLOTS` goes from 15 to 10, because 10 is the number of pages one block's
seven projections need at I2048 with 8 query heads. Nothing in the
datapath, the loader, the pager or the block driver moves. The image is
280 pages and 73.4 MB against today's 420 and 110.1, so it fits inside
the existing allocation with room that has never existed before.

`q_proj` stops needing re-packing at export — at 8 query heads its output
is exactly 1024, which is the only width the exporter's `GROUPS = out/4`
gets right on its own. `gate_proj` and `up_proj` still need two slices
each instead of three.

## What this does not settle

Reconstruction is not training. 14.9 against 8.205 is close enough to be
interesting and not close enough to ship, and the whole point of D3 is to
close that gap while also absorbing ternarization, which this has not
touched at all. Every number here is a full-precision model.

Two limits are structural rather than fixable by more calibration data:

- Reconstruction cannot recover a dropped block. Removing one is not a
  linear operation on anything, which is exactly why the depth column
  behaves the way it does — the method has no purchase on it.
- Everything is fitted against DialogSum. A student reconstructed on
  summarization data is not a general model and should not be described
  as one. The perplexities above are summary-token perplexities on one
  corpus and transfer to nothing without being re-measured.

Going from 128 to 512 calibration examples bought 19% (3855 → 3227 at
L18), so more data is a real but small lever compared to depth.

## Reproducing it

    python tools/prune_student.py --layers 28 --inter 2048 --out ~/tc-ckpt/student-L28
    python tools/prune_seq.py --ckpt ~/tc-ckpt/student-L28 --calib 512
    python tools/eval_ppl.py --model ~/tc-ckpt/student-L28-seq

Perplexity is measured over **summary tokens only**. Whole-sequence
perplexity on DialogSum is dominated by the dialogue, which neither model
is being asked to produce, and it flatters every checkpoint here by an
order of magnitude.

Both tools solve on the host deliberately. The matrices are at most
2048×2048 in float64 — a fraction of a second either way — and cuSOLVER
could not reliably get a workspace with an inference server holding 11 GB
of the card. `prune_seq.py` also streams the teacher one block at a time
for the same reason: it is only ever used one layer deep, so keeping all
28 resident bought nothing and cost 2.2 GB.

## Exit

D1 asked whether the hardware could take the shape. D2 asks whether the
shape can take the model, and the answer is that it depends entirely on
which dimension you cut. Narrow it and reconstruct: nearly free. Shorten
it: catastrophic, and no amount of least squares helps.

Plan B survives, at 1.56× rather than 2.43×, and the 2.43× was never
available at any quality worth having. The next number that matters is a
warm-up curve, not another reconstruction.
