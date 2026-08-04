"""Block executor stage 12: OPB -- let the board time the real operators.

Stage 11 needed NQBENCH because a single normalizer call is 0.08 ms and
the UART line reporting it is 16 ms; timing one call over the wire times
the wire. Repetitions between two MARK lines let the host take a slope
and the fixed latency cancels.

That worked, and then it exposed something worse. TOKEN-BUDGET.md's CPU
rows came from BENCH, whose operators are hand-written micro-loops living
beside the real ones -- bench_sumsq is not the sum of squares nq_core
runs, bench_quant is not the quantizer it runs. The two drifted, and the
budget understated the fused normalizer by 2.7x: 183.1 ms listed against
488 measured. A benchmark that is a copy of the thing measures the copy.

So OPB does not benchmark anything. It repeats the *actual command
handler*, byte for byte the one the block driver will call, with the UART
muted so the operator's own reports do not become the measurement again.
Muting is at uart_putc, which is the one place every report passes
through, so no handler needs to know it is being timed.

  OPB <reps> <CMD and its arguments>

MARK OPB_START, then reps muted calls, then MARK OPB_END -- and one final
unmuted call outside the bracket, so a handler that is erroring says so
rather than looping silently and reporting a very fast zero.

Escaping caution: EXEC12 is a raw string that becomes C, so a newline
inside a C string literal is written \n and stays that way.
"""

# uart_putc is the single choke point that puts, putdec and puthex all
# pass through, so muting it there means no handler needs to know.
MUTE_OLD = "static void uart_putc(char c) {"
MUTE_NEW = """static int uart_mute = 0;

static void uart_putc(char c) {
    if (uart_mute) return;"""

EXEC12 = r"""
/* ---- Stage 12: OPB, the board times its own operators ----------------

   The rule this exists to enforce: a number in the token budget must
   come from the code that runs in the token, not from a micro-loop
   written to resemble it. Every operator below is reached by the same
   name and the same argument string the host would send normally.

   Handlers that transform their input in place -- NQD's auto-range
   shift -- see different data on the second repetition. That is
   acceptable here and only here: these loops are fixed-trip with no
   data-dependent branch beyond a max comparison, so cycles per element
   do not move with the values. An operator that later gains a
   data-dependent branch stops being measurable this way, and the honest
   thing then is to say so rather than keep quoting the slope.        */
static void cmd_opb(const char *p) {
    unsigned long reps = parse_u(&p), r;
    const char *c = skip_ws(p);

    if (reps == 0u || reps > 100000u) { uart_puts("ERR reps\n"); return; }

    uart_puts("MARK OPB_START\n");
    for (r = 0; r <= reps; r++) {
        uart_mute = (r < reps);              /* the last pass speaks */
        if      (starts(c, "NQD "))  cmd_nqd(c + 4);
        else if (starts(c, "NQF "))  cmd_nqf(c + 4);
        else if (starts(c, "NQ "))   cmd_nq(c + 3);
        else if (starts(c, "QKN "))  cmd_qkn(c + 4);
        else if (starts(c, "SM "))   cmd_sm(c + 3);
        else if (starts(c, "PV "))   cmd_pv(c + 3);
        else if (starts(c, "MLP "))  cmd_mlp(c + 4);
        else if (starts(c, "SCT "))  cmd_sct(c + 4);
        else if (starts(c, "QKD "))  cmd_qk(c + 4);
        else if (starts(c, "KVW "))  cmd_kvw(c + 4);
        else if (starts(c, "PJO "))  cmd_projo(c + 4);
        else if (starts(c, "PAGEDMA ")) cmd_pagedma(c + 8);
        else { uart_mute = 0; uart_puts("ERR opb cmd\n"); return; }

        /* The bracket closes before the one call allowed to print, so
           the operator's own report never lands inside the timing. */
        if (r + 1u == reps) { uart_mute = 0; uart_puts("MARK OPB_END\n"); }
    }
    uart_mute = 0;
    uart_puts("OK OPB\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "NQBENCH ")) cmd_nqbench(line + 8);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "OPB ")) cmd_opb(line + 4);'
