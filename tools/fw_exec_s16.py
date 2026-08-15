"""Block executor stage 16: attention on the board.

run_block has been running one position. At position 0 attention over a
single key is the value vector itself, so q and k were computed and
thrown away and v was broadcast across the query heads. That is correct
there and nowhere else, and it is the whole reason the board can predict
a token but not generate a second one.

This replaces it with the general path and drops the special case rather
than keeping both. A softmax over one key is 1.0, so the general path
subsumes position 0 and blk_check becomes a regression test for it.
Keeping two paths would mean the cheap one is what gets exercised and the
expensive one is what ships.

Every piece already exists and is already verified -- QKN at stage 3, the
cache at 4, Q.K^T at 6, softmax at 7, P.V at 8, the scale derivation at
14b. What is new is two things.

First, v goes through the same QK-norm operator as q and k, with a gain
of one and a rotation that does nothing. It gets a per-head absmax and a
scale in the same units, and there is no second operator to keep in step
with this one. qkn_norm is 0 for that call: v is absmax quantized and
never divided by a root-mean-square, so the accumulator's own scale does
not cancel and has to be handed in.

Second, the sixteen heads have to end up on one exponent. Each head's
numerator comes out of P.V on its own scale and they differ by orders of
magnitude, so the largest is picked and the rest are scaled into it. That
is resid_add's argument again, for resid_add's reason: a head that falls
off the bottom contributed nothing, and the block would still look
roughly right -- which is exactly how a dead MLP passed three times.

Position is a sticky command, POS, rather than an argument on BLK and
TOK. Not elegance: three host tools already send BLK and TOK, and
changing their arity mid-campaign would break all of them at the moment
the thing under test is the arithmetic.

Escaping caution: raw strings that become C, so a newline inside a C
string literal is written \n and stays that way.
"""

#  All of this is declared early because run_block is stage 13 and calls
#  it. The slot numbers live here for the same reason.
DEFS = r"""
/* ---- Stage 16 slots and forward declarations -------------------------
   Sixteen scratch slots were enough while the host held every
   intermediate. The block driver holds them all at once: q, k and v
   int8, their scales, the cache's scale record, the dot products, the
   probabilities and the numerator, all live together. */
#define S_CS   16u   /* cos and sin, 64 + 64, from the host once a token */
#define S_Q8   17u   /* q int8, 16 heads x 128                           */
#define S_K8   18u   /* k int8, 8 heads x 128                            */
#define S_V8   19u   /* v int8, 8 heads x 128                            */
#define S_QS   20u   /* per-head q scale, (mantissa, exponent) pairs     */
#define S_KVS  21u   /* the cache's record: km, ke, vm, ve per kv head   */
#define S_DOT  22u   /* Q.K^T, one int per key; QKN's scalars before it  */
#define S_PR   23u   /* probabilities, int8                              */
#define S_SO   24u   /* wmax, vemax, sume, npos                          */
#define S_NUM  25u   /* P.V numerator, 128 ints                          */
#define S_GN   26u   /* a gain copied out of the DDR record              */
#define S_ONE  27u   /* unit gain, for v                                 */
#define S_ID   28u   /* identity rotation, for v                         */
#define S_QH   29u   /* one query head, where qk_core expects it         */

static void attn_init(void);
static void qkn_run(unsigned long blk, unsigned long gi, unsigned long src,
                    unsigned long dst, unsigned long nh, int norm,
                    unsigned int am, int ae);
static int  attn_heads(unsigned long blk, unsigned long pos);

/* The position this token is being written at. Sticky, set by POS. */
static unsigned long blk_pos = 0;
"""

DEFS_ANCHOR = "static int nq_mx, nq_xs, nq_amx;"

SLOTS_OLD = "#define VS_SLOTS  16u"
SLOTS_NEW = """/* Thirty-two. VSLOT still takes its index modulo this, so every host
   command ever written against slots 0..15 addresses the same memory it
   always did; the driver uses 16..29 for the intermediates the host used
   to hold on its side of the wire. */
#define VS_SLOTS  32u"""

EXEC16 = r"""
/* ---- Stage 16: attention on the board -------------------------------- */

static int attn_ready = 0;

/* v is quantized by the same operator as q and k, with a gain of one and
   a rotation that does nothing -- which is how it gets a per-head absmax
   and a scale in the same units, with no second operator to keep in step
   with this one. Q15 is 32767, not 32768, because that is what q15v
   clips to and the scale derivation is written against it. */
static void attn_init(void) {
    int *o = (int *)VSLOT(S_ONE);
    int *r = (int *)VSLOT(S_ID);
    unsigned long i;
    if (attn_ready) return;
    for (i = 0; i < 128u; i++) o[i] = 32767;          /* gain of one    */
    for (i = 0; i < 64u; i++)  r[i] = 32767;          /* cos = 1        */
    for (i = 0; i < 64u; i++)  r[64u + i] = 0;        /* sin = 0        */
    attn_ready = 1;
}

/* One gain out of the block's DDR record and into a slot, because
   qkn_core addresses its operands by slot index. 128 words. */
static void meta_gain(unsigned long blk, unsigned long gi) {
    const int *g = (const int *)(meta_rec(blk) + gain_off[gi]);
    int *o = (int *)VSLOT(S_GN);
    unsigned long i;
    for (i = 0; i < gain_len[gi]; i++) o[i] = g[i];
}

/* q, k or v through the QK-norm, carrying stage 14b's scale bookkeeping.
   norm is 1 for q and k, whose deferred root-mean-square makes the result
   absolute, and 0 for v -- absmax quantized, never normalized, so the
   accumulator's own scale survives and has to be handed in. */
static void qkn_run(unsigned long blk, unsigned long gi, unsigned long src,
                    unsigned long dst, unsigned long nh, int norm,
                    unsigned int am, int ae) {
    unsigned int gm;
    int ge;
    if (norm) {
        meta_gain(blk, gi);
        meta_bf(blk, META_GMAX, gi, &gm, &ge);
        qkn_gm = gm; qkn_ge = ge;
    } else {
        qkn_gm = 1u << 30; qkn_ge = -30;              /* a gain of one */
    }
    qkn_norm = norm;
    qkn_am = am; qkn_ae = ae;
    qkn_core(src, norm ? S_GN : S_ONE, norm ? S_CS : S_ID,
             dst, S_DOT, nh, 128u);
}

/* All sixteen query heads at `pos`, over a cache already written there.
   Leaves the result in S_ATT on one common scale, which the o_proj
   normalization downstream is then free to ignore. */
static int attn_heads(unsigned long blk, unsigned long pos) {
    int *att = (int *)VSLOT(S_ATT);
    const int *num = (const int *)VSLOT(S_NUM);
    const int *so  = (const int *)VSLOT(S_SO);
    const int *qs  = (const int *)VSLOT(S_QS);
    const signed char *q8 = (const signed char *)VSLOT(S_Q8);
    signed char *qh = (signed char *)VSLOT(S_QH);
    unsigned int fm[16], Mm, t, dm;
    int fe[16], Me, te, de, amx, v;
    unsigned long h, i;

    for (h = 0; h < 16u; h++) {
        for (i = 0; i < 128u; i++) qh[i] = q8[(h << 7) + i];

        core_ok = 0; qk_core(blk, h >> 1, pos, S_QH, S_DOT);
        if (!core_ok) { uart_puts("ERR qk\n"); return 0; }

        core_ok = 0;
        sm_core(blk, h >> 1, pos, S_DOT,
                (unsigned long)(unsigned int)qs[h * 2u],
                (unsigned long)(long)(qs[h * 2u + 1u] + 512),
                S_PR, S_SO);
        if (!core_ok) { uart_puts("ERR sm\n"); return 0; }

        core_ok = 0; pv_core(blk, h >> 1, pos, S_PR, S_NUM);
        if (!core_ok) { uart_puts("ERR pv\n"); return 0; }

        /* num * wmax * 2^vemax / (127 * sume / 65536): the softmax
           denominator stage 7 deferred, in block float rather than in
           the host's float64. sume reaches 2^25 over a full context, so
           127*sume would not fit 32 bits and the product is formed as a
           block float instead of as an integer. */
        sc_mul((unsigned int)so[2], 0, 127u, 0, &dm, &de);
        sc_div((unsigned int)so[0], so[1] + 16, dm, de, &fm[h], &fe[h]);

        for (i = 0; i < 128u; i++) att[(h << 7) + i] = num[i];
    }

    /* One exponent for all sixteen. */
    Mm = 0u; Me = 0;
    for (h = 0; h < 16u; h++) {
        amx = 0;
        for (i = 0; i < 128u; i++) {
            v = att[(h << 7) + i]; if (v < 0) v = -v;
            if (v > amx) amx = v;
        }
        sc_mul((unsigned int)amx, 0, fm[h], fe[h], &t, &te);
        sc_max2(Mm, Me, t, te, &Mm, &Me);
    }
    if (Mm == 0u) {
        for (i = 0; i < 2048u; i++) att[i] = 0;
        return 1;
    }
    Me += 1 - 29;
    for (h = 0; h < 16u; h++) {
        sc_div(fm[h], fe[h], Mm, Me, &t, &te);
        for (i = 0; i < 128u; i++)
            att[(h << 7) + i] = mul_bf(att[(h << 7) + i], t, te);
    }
    return 1;
}

/* POS <p> -- the position the next BLK or TOK writes the cache at. The
   rotation for it goes into slot 16 with an ordinary LOADV: it is 512
   bytes, it is the same for all twenty-eight blocks, and a 512-entry
   table in DDR is a better idea that can wait until something is
   measured to want it. */
static void cmd_pos(const char *p) {
    unsigned long v = parse_u(&p);
    if (v >= KV_MAXP) { uart_puts("ERR range\n"); return; }
    blk_pos = v;
    uart_puts("OK POS\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "QSC ")) cmd_qsc(line + 4);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "POS ")) cmd_pos(line + 4);'
