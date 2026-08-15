"""Block executor stage 10a: reach the constants in DDR.

The block driver rests entirely on the firmware being able to read the
gains and scales build_ddr_meta.py placed at 0x07000000. Everything
after this -- nq without a host upload, the SiLU scale assembled on the
board, the residual adds -- assumes that record layout is right.

So establish it on its own, first, with a command that does nothing but
fetch. MREAD copies one gain vector out of a block's record into a slot
and reports the two block-float scalars beside it, and the host compares
all three against meta.bin. If the stride, the offsets, or the byte
order are wrong, this says so in two seconds rather than surfacing later
as a block that is quietly 6% off.

That is worth its own build. Every scale bug this project has had was
cheap to find in isolation and expensive to find underneath four other
things.

Escaping caution: these strings become C, so a newline inside a C string
literal is written \\n here.
"""

EXEC10 = r"""
/* ---- Stage 10a: the block's constants, in DDR ------------------------
   The gains are constants and the host has been re-uploading them on
   every nq call, on every block, on every token -- 28 KB a block to
   repeat what the previous token already said. build_ddr_meta.py puts
   them at 0x07000000, in the gap between the weight image ending at
   110.1 MB and the KV cache starting at 128 MB: 28 records of 32 KB.

   Reading them here rather than receiving them is worth more than the
   bytes. It is the difference between the host driving the block and
   the board owning it. */

#define META_BASE    (DDR_BASE + 0x07000000u)
#define META_STRIDE  0x8000u
#define META_SCALES  0x7400u          /* 7 x (mantissa u32, exp i32) */
#define META_GMAX    0x7440u          /* 6 x (mantissa u32, exp i32) */

/* Byte offset and length of each gain within a record. This is
   build_ddr_meta.py's GAINS order and nothing may reorder it: the two
   tables are one layout written twice, in different languages, and
   MREAD exists to prove they still agree. */
static const unsigned int gain_off[6] =
    { 0x0000u, 0x1000u, 0x2000u, 0x2200u, 0x2400u, 0x4400u };
static const unsigned int gain_len[6] =
    { 1024u, 1024u, 128u, 128u, 2048u, 3072u };

static unsigned int meta_rec(unsigned long blk) {
    return META_BASE + (unsigned int)blk * META_STRIDE;
}

/* A block-float pair out of a record. A helper because reading two words
   at a computed offset is precisely where an off-by-one buys a silently
   wrong scale instead of a fault. */
static void meta_bf(unsigned long blk, unsigned int base, unsigned long i,
                    unsigned int *m, int *e) {
    unsigned int a = meta_rec(blk) + base + (unsigned int)i * 8u;
    *m = IO32(a);
    *e = (int)IO32(a + 4u);
}

/* MREAD <blk> <gidx> <dst> -- one gain into a slot, plus the scalars.

   Deliberately does no arithmetic. If this disagrees with meta.bin the
   fault is in the layout, and mixing a computation into the test would
   only give it a second place to hide. */
static void cmd_mread(const char *p) {
    unsigned long blk = parse_u(&p), gi = parse_u(&p), dst = parse_u(&p), i;
    const int *g;
    int *o;
    unsigned int m;
    int e;

    if (blk >= 28u || gi >= 6u) { uart_puts("ERR range\n"); return; }
    g = (const int *)(meta_rec(blk) + gain_off[gi]);
    o = (int *)VSLOT(dst);
    for (i = 0; i < gain_len[gi]; i++) o[i] = g[i];

    uart_puts("MREAD n "); uart_putdec((long)gain_len[gi]);
    meta_bf(blk, META_GMAX, gi, &m, &e);
    uart_puts(" gmax "); uart_puthex(m);
    uart_puts(" "); uart_putdec((long)e);
    meta_bf(blk, META_SCALES, gi, &m, &e);
    uart_puts(" wscale "); uart_puthex(m);
    uart_puts(" "); uart_putdec((long)e);
    uart_puts("\nOK MR\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "MLP ")) cmd_mlp(line + 4);'
CMD_NEW = (CMD_OLD
           + '\n        else if (starts(line, "MREAD ")) cmd_mread(line + 6);')
