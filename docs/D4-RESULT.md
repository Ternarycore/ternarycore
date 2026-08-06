# D4 result: 30.86 ROUGE-L, short of the 33.4 bar, and the ternary path is the real one

The pipeline runs end to end. A structurally pruned, SubLN-surgered,
ternary Qwen3-0.6B, warmed up on 200 M tokens and distilled on DialogSum
from a teacher that can do the task:

  teacher (FP, SFT on the bare cue)   ROUGE-L 35.16
  student (W1.58 A8)                  ROUGE-L 30.86   87.8% of teacher
  bar (95% of teacher)                        33.4   MISSED

The same checkpoint scored without --quant gets 4.59, which looks like a
bug and is not one. Straight-through trains a shadow weight whose
*rounding* is the model; the shadow weight itself was never a working
network and running it un-rounded runs something that was never trained.
So there is no better full-precision version sitting behind this number.
30.86 is the model, and the 12% gap to the teacher is the whole pipeline
-- pruning, ternarization and distillation together -- not a quantization
tax on top of something else.

Where the 2.5 points went is visible in the generations. The student
rambles and gets cut at 64 new tokens mid-sentence, while the references
average 34.6 tokens. It has the content and not the brevity, and ROUGE-L
F-measure charges for both. The likely cause is the loss weighting:
alpha 0.3 puts most of the gradient on the teacher soft targets, and EOS
is a hard-reference fact. Raising alpha is the next experiment, and it is
an hour.

D4 validation summary perplexity went 20.437 -> 4.185 and plateaued from
step 1800, so more epochs of the same will not close it.
