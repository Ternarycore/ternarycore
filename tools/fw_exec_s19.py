"""Block executor stage 19: price the DMA campaign before building it.

The budget says feeding the array is 1954.8 ms of a token and the array
itself is 5.3, so "hand the array its operands and results by DMA" is the
largest item on the ladder. It has never been costed, and the ladder's
figure for it is a projection -- which is exactly the kind of number this
project has now been burned by twice.

Before costing it, a look at what proj_core actually does made the shape
of the campaign clearer and worse:

  * activations go in through S_ACTWR, ONE register that auto-increments
    an internal pointer. That is a FIFO, not an address range, and the
    AXI CDMA has no keyhole mode. DMA into it is not a firmware change;
    it needs the activation BRAM exposed as an AXI4 range, the way
    weight_bram128 already is.
  * results come out as 64 accumulators per tile read through an index
    register: write S_RIDX, read S_RDATA, twice per result. 1024 results
    cost 2048 accesses.

So there are two candidate changes, not one, and they are very different
sizes. Exposing the activation BRAM is RTL plus a block design plus a
build. Making S_RDATA auto-increment ridx on read is about three lines of
Verilog and would halve the result traffic.

PPH prices all of it without building any of it. It runs each phase of a
projection in isolation, repeated, and the host differences two rep
counts so the round trip subtracts out:

    0  activations in     -- 1 ctrl write + 1024 writes to S_ACTWR
    1  the array          -- 16 tile launches and their done polls
    2  results out        -- 2048 accesses, as the driver does it now
    3  results out, read only -- 1024 accesses, no S_RIDX write

Phase 3 is the useful one and it is free: it returns the wrong numbers,
because without the index write every read hits the same accumulator, but
it costs exactly what an auto-incrementing read port would cost. The RTL
change can be priced before it is written.

Escaping caution: raw string, becomes C.
"""

EXEC19 = r"""
/* ---- Stage 19: PPH, where a projection's time goes ------------------- */
static void cmd_pph(const char *p) {
    unsigned long ph = parse_u(&p), reps = parse_u(&p), r, k;
    const signed char *a = (const signed char *)VSLOT(3);
    volatile int sink = 0;
    unsigned int c;

    if (ph > 3u || reps == 0u || reps > 100000u) {
        uart_puts("ERR range\n"); return;
    }
    for (r = 0; r < reps; r++) {
        if (ph == 0u) {
            IO32(STREAM_BASE + S_CTRL) = 0x4u;
            for (k = 0; k < DEPTH; k++)
                IO32(STREAM_BASE + S_ACTWR) =
                    (unsigned int)(unsigned char)a[k];
        } else if (ph == 1u) {
            for (c = 0; c < 16u; c++) stream_tile(c);
        } else if (ph == 2u) {
            for (c = 0; c < 1024u; c++) {
                IO32(STREAM_BASE + S_RIDX) = c & 63u;
                sink += (int)IO32(STREAM_BASE + S_RDATA);
            }
        } else {
            for (c = 0; c < 1024u; c++)
                sink += (int)IO32(STREAM_BASE + S_RDATA);
        }
    }
    uart_puts("OK PPH\n");
}
"""

ANCHOR = "int main(void) {"
CMD_OLD = '        else if (starts(line, "DSUM ")) cmd_dsum(line + 5);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "PPH ")) cmd_pph(line + 4);'
