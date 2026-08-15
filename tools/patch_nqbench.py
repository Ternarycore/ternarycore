#!/usr/bin/env python3
"""patch_nqbench.py -- let the board time the normalizer itself.

stage11_check reported 1.0x, at a flat 16 ms for both paths whether n was
1024 or 3072. That is not a result, it is the UART round trip. One call
is roughly 0.5 ms on the soft CPU and 0.05 ms in fabric; the serial line
that reports it is thirty times slower than either.

Article 05 already records this exact trap about the pager -- "a single
page now completes faster than one line of serial output can be printed,
the instrumentation became the bottleneck before the hardware did" -- and
the answer there was to measure a slope across repetitions so the fixed
latency cancels. Same answer here.

NQBENCH <fab> <gidx> <blk> <n> <reps> runs either path `reps` times
between two MARK lines. The host takes the difference between two
repetition counts, which subtracts the UART entirely.

  python tools/patch_nqbench.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fw_exec_s11.py")
s = open(p).read()

if "cmd_nqbench" in s:
    sys.exit("already patched")

OLD_TAIL = '''    nq_report();
}
"""'''

NEW_TAIL = '''    nq_report();
}

/* NQBENCH <fab> <gidx> <blk> <n> <reps> -- the board times itself.

   One call is ~0.5 ms on the CPU and ~0.05 ms in fabric, and the UART
   round trip that would report it is 16 ms. Timing a single call over
   the wire times the wire. Repetitions bracketed by MARK lines let the
   host take a slope, which is exactly what the pager needed once a page
   completed faster than one line of serial output could be printed. */
static void cmd_nqbench(const char *p) {
    unsigned long fab = parse_u(&p), gi = parse_u(&p), blk = parse_u(&p),
                  n = parse_u(&p), reps = parse_u(&p), r;

    if (gi >= 6u || blk >= 28u || n != gain_len[gi]) {
        uart_puts("ERR range\\n"); return;
    }
    uart_puts("MARK NQB_START\\n");
    for (r = 0; r < reps; r++) {
        if (fab) {
            cdma_move(VSLOT(0), NORM_X, (unsigned int)n * 4u);
            cdma_move(meta_rec(blk) + gain_off[gi], NORM_G,
                      (unsigned int)n * 4u);
            IO32(NORM_CTRL) = (unsigned int)n | 0x80000000u;
            while (!(IO32(NORM_STAT) & 0x2u)) { }
            cdma_move(NORM_O8, VSLOT(3), (unsigned int)n);
        } else {
            nq_core((const int *)VSLOT(0),
                    (const int *)(meta_rec(blk) + gain_off[gi]),
                    (signed char *)VSLOT(3), n);
        }
    }
    uart_puts("MARK NQB_END\\nOK NQB\\n");
}
"""'''

OLD_CMD = ("CMD_NEW = CMD_OLD + '\\n        else if "
           "(starts(line, \"NQF \")) cmd_nqf(line + 4);'")
NEW_CMD = ("CMD_NEW = (CMD_OLD\n"
           "           + '\\n        else if (starts(line, \"NQF \")) "
           "cmd_nqf(line + 4);'\n"
           "           + '\\n        else if (starts(line, \"NQBENCH \")) "
           "cmd_nqbench(line + 8);')")

for old, new in ((OLD_TAIL, NEW_TAIL), (OLD_CMD, NEW_CMD)):
    if old not in s:
        sys.exit(f"anchor missing:\n{old[:120]}")
    s = s.replace(old, new, 1)

open(p, "w").write(s)
print("fw_exec_s11: NQBENCH added, board times itself over repetitions")
