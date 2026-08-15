"""Block executor stage 13: BLK and TOK -- the block runs on the board.

Everything up to here has been the host driving one operator at a time
over a serial line. token_loop.py takes 574.8 seconds a token, and
almost none of that is arithmetic: it is roughly 130 KB of operands and
results crossing 115200 baud, twenty-eight times. The measured cost of
the operators themselves is 4.47 seconds.

So this is the step that removes the host from the inner loop. BLK runs
one complete transformer block at position 0 -- normalize, quantize,
seven projections off DDR-resident weights, the residual adds, SiLU --
and TOK runs twenty-eight of them. Nothing crosses the wire except the
input vector, the output vector, and one block-float scale.

Two things had to be built rather than reused.

The residual adds need block-float bookkeeping. On the host the residual
stream is float64 and x + delta is one operator; here x is int32 with a
scale and delta is int32 with a different scale, and adding them means
choosing a common exponent that neither overflows nor throws away the
smaller term. sc_mul, sc_div, sc_sqrt and sc_norm already exist from
stage 5, where they were built for softmax; resid_add is four calls to
them and one 64-bit multiply per element.

And the nq output scale, which the host used to read off a UART line and
compute in Python. There is no round trip left to read it from, so
nq_scale computes gmax * mx / (32768 * 127 * rms) on the board, with
rms = sqrt(ss * 4^xs / n), out of the same DDR record the gain came
from.

What is NOT here: attention. At position 0 attention over a single key
is the value vector itself, so q and k are computed and discarded --
their pages are still fetched, so the page sequence and the cost are the
real ones. Softmax, P.V and the KV cache are verified separately at four
positions by block_multi.py and are the next step, not this one.

Escaping caution: EXEC13 becomes C, and it is a raw string, so a newline
inside a C string literal is written \n and stays that way.
"""

EXEC13 = r"""
/* ---- Stage 13: the block driver --------------------------------------

   Page slots within a block, in the order build_ddr_image.py wrote them
   and the order blk_proj must request them: q takes two (2048 outputs),
   k and v one each, o two (2048 inputs), gate and up three each (3072
   outputs), down three (3072 inputs). Fifteen, and the image's rule is
   page = blk*15 + slot.                                              */
#define P_Q    0u
#define P_K    2u
#define P_V    3u
#define P_O    4u
#define P_G    6u
#define P_U    9u
#define P_D   12u

/* Scratch slots. Sixteen exist at 16 KB each; these are the seven the
   block needs, named rather than numbered because a projection writing
   into the slot still holding the residual stream would be silent. */
#define S_X    0u          /* residual stream, int32, 1024             */
#define S_X1   1u          /* after the attention residual             */
#define S_A8   2u          /* int8 activations, up to 3072             */
#define S_P0   3u          /* projection output, up to 3072            */
#define S_P1   4u          /* up_proj, so gate and up coexist          */
#define S_M    5u          /* the MLP product, 3072                    */
#define S_ATT  6u          /* attention output, 2048                   */

/* The residual stream's scale. A global because it is the one piece of
   state that survives from block to block, and threading it through
   every signature would only give it more places to be dropped. */
static unsigned int blk_xm = 1u;
static int          blk_xe = 0;

/* One 256 KB page, DDR to weight BRAM. cmd_pagedma with the parsing,
   the repeat count and the reporting taken out -- and, as of the
   measurement that found it, without the 8192-instruction cache flush
   that used to be 312 ms of every token. */
static int page_load(unsigned long page) {
    unsigned long spin = 0;
    IO32(CDMA_CR) = 0x04u;
    while (IO32(CDMA_CR) & 0x04u)
        if (++spin > 1000000u) { uart_puts("ERR page reset\n"); return 0; }
    IO32(CDMA_SA)  = DDR_BASE + (unsigned int)page * PAGE_BYTES;
    IO32(CDMA_DA)  = WEIGHT_BRAM;
    IO32(CDMA_BTT) = PAGE_BYTES;
    spin = 0;
    while (!(IO32(CDMA_SR) & 0x02u))
        if (++spin > 40000000u) { uart_puts("ERR page dma\n"); return 0; }
    return 1;
}

/* A whole projection: every output block against every input slice.
   Input slices accumulate (seg != 0 on all but the first), output blocks
   land in their own thousand of the destination. proj_core takes a
   pointer rather than a slot index precisely so this can offset both
   ends without copying. */
static int blk_proj(unsigned long blk, unsigned long slot0,
                    unsigned long nout, unsigned long nin,
                    const signed char *a, int *o) {
    unsigned long nc = nout >> 10, ns = nin >> 10, c, s;
    for (c = 0; c < nc; c++)
        for (s = 0; s < ns; s++) {
            if (!page_load(blk * 15u + slot0 + c * ns + s)) return 0;
            proj_core(a + (s << 10), o + (c << 10), 16u, s != 0u);
        }
    return 1;
}

/* RMSNorm and quantize, either path, with the auto-range shift in front
   of both. cmd_nqf does not shift -- stage 11 fed it vectors already
   inside 16 bits and verified against that precondition -- but a
   projection accumulator reaches 1024*127, and the fabric's pass 2 takes
   x as sixteen signed bits. Shifting first is what makes the two paths
   interchangeable on real data rather than only on the test vectors. */
static int nq_run(int fab, const int *x, unsigned long blk,
                  unsigned long gi, signed char *o8, unsigned long n) {
    int *w = (int *)VS_TMP;
    unsigned long i;
    int v, amx = 0, sh = 0;

    for (i = 0; i < n; i++) { v = x[i]; if (v < 0) v = -v;
                              if (v > amx) amx = v; }
    while (sh < 31 && rsh(amx, sh) > 32767) sh++;

    /* The shift goes to scratch, not in place. cmd_nqd applies it to the
       caller's vector and says so -- "safe only because every vector this
       runs on is scratch the host does not read afterwards" -- and the
       block driver is the first caller for which that is false. x here is
       the residual stream, which is normalized and then added to fifteen
       operators later; shifting it in place divided it by 2^14 behind the
       add's back and cost a whole block. */
    for (i = 0; i < n; i++) w[i] = rsh(x[i], sh);

    if (fab) {
        cdma_move((unsigned int)(unsigned long)w, NORM_X,
                  (unsigned int)n * 4u);
        cdma_move(meta_rec(blk) + gain_off[gi], NORM_G,
                  (unsigned int)n * 4u);
        IO32(NORM_CTRL) = (unsigned int)n | 0x80000000u;
        i = 0;
        while (!(IO32(NORM_STAT) & 0x2u))
            if (++i > 20000000u) { uart_puts("ERR nqf hang\n"); return 0; }
        cdma_move(NORM_O8, (unsigned int)(unsigned long)o8, (unsigned int)n);
        nq_mx = (int)IO32(NORM_MX);
        nq_ss = IO32(NORM_SS);
        nq_xs = (int)IO32(NORM_XS);
        return 1;
    }
    if (!nq_core(w, (const int *)(meta_rec(blk) + gain_off[gi]), o8, n)) {
        uart_puts("ERR nq range "); uart_putdec((long)nq_amx);
        uart_puts("\n"); return 0;
    }
    return 1;
}

/* The scale of what nq just wrote:  gmax * mx / (32768 * 127 * rms),
   rms = sqrt(ss * 4^xs / n).

   This is absolute, and that is the whole reason the block driver can
   forget its input's scale at every normalization. RMSNorm divides by
   the vector's own root-mean-square, so its output does not depend on
   how the input was scaled, and neither does the absmax quantizer in
   front of it. Getting that wrong in the other direction -- multiplying
   by a scale that had already cancelled -- is what made the MLP
   contribute nothing while the block still reported a pass. */
static void nq_scale(unsigned long blk, unsigned long gi, unsigned long n,
                     unsigned int *sm, int *se) {
    unsigned int gm, t, r;
    int ge, te, re;

    if (nq_ss == 0u || nq_mx == 0) { *sm = 0u; *se = 0; return; }
    meta_bf(blk, META_GMAX, gi, &gm, &ge);
    sc_div(nq_ss, 2 * nq_xs, (unsigned int)n, 0, &t, &te);
    sc_sqrt(t, te, &r, &re);
    sc_mul(r, re, 4161536u, 0, &r, &re);              /* 32768 * 127 */
    sc_mul(gm, ge, (unsigned int)nq_mx, 0, &t, &te);
    sc_div(t, te, r, re, sm, se);
}

/* round(v * m * 2^e), for m normalized and the product known to fit.
   |v| < 2^31 and m < 2^31, so the 64-bit product cannot overflow. */
static int mul_bf(int v, unsigned int m, int e) {
    long long p;
    int sh = -e;
    if (m == 0u || v == 0) return 0;
    if (sh >= 63) return 0;
    p = (long long)v * (long long)(unsigned long long)m;
    if (sh <= 0) return (int)(p << (-sh));
    p = (p >= 0) ? ((p + ((long long)1 << (sh - 1))) >> sh)
                 : -((((-p) + ((long long)1 << (sh - 1))) >> sh));
    return (int)p;
}

static void sc_max2(unsigned int am, int ae, unsigned int bm, int be,
                    unsigned int *om, int *oe) {
    sc_norm(&am, &ae); sc_norm(&bm, &be);
    if (am == 0u)      { *om = bm; *oe = be; return; }
    if (bm == 0u)      { *om = am; *oe = ae; return; }
    if (ae > be || (ae == be && am >= bm)) { *om = am; *oe = ae; }
    else                                   { *om = bm; *oe = be; }
}

/* o = x*Sx + d*Sd, renormalized so the result peaks near 2^29.

   Both terms are carried, not the larger one: the attention residual is
   often an order of magnitude below the stream it is added to, and a
   scheme that aligned on the larger exponent and let the smaller fall
   off the bottom would produce a block that passes every shape check
   and contributes nothing. Choosing the output scale from twice the
   larger magnitude leaves each term at most 2^28 and their sum at most
   2^29, so nothing saturates and the smaller term keeps every bit that
   fits under it. */
static void resid_add(const int *x, unsigned int xm, int xe,
                      const int *d, unsigned int dm, int de,
                      int *o, unsigned long n,
                      unsigned int *om, int *oe) {
    unsigned long i;
    int v, ax = 0, ad = 0;
    unsigned int Mx, Md, M, Rx, Rd;
    int Ex, Ed, E, ex, ed;

    for (i = 0; i < n; i++) {
        v = x[i]; if (v < 0) v = -v; if (v > ax) ax = v;
        v = d[i]; if (v < 0) v = -v; if (v > ad) ad = v;
    }
    sc_mul((unsigned int)ax, 0, xm, xe, &Mx, &Ex);
    sc_mul((unsigned int)ad, 0, dm, de, &Md, &Ed);
    sc_max2(Mx, Ex, Md, Ed, &M, &E);
    if (M == 0u) {
        for (i = 0; i < n; i++) o[i] = 0;
        *om = 0u; *oe = 0; return;
    }
    E += 1 - 29;                                   /* So = 2M / 2^29 */
    sc_div(xm, xe, M, E, &Rx, &ex);
    sc_div(dm, de, M, E, &Rd, &ed);
    for (i = 0; i < n; i++)
        o[i] = mul_bf(x[i], Rx, ex) + mul_bf(d[i], Rd, ed);
    *om = M; *oe = E;
}

/* One transformer block at position 0, reading everything it needs from
   DDR and leaving the result in S_X with blk_xm/blk_xe updated. */
static int run_block(unsigned long blk, unsigned long pos, int fab) {
    int *x   = (int *)VSLOT(S_X);
    int *x1  = (int *)VSLOT(S_X1);
    int *p0  = (int *)VSLOT(S_P0);
    int *p1  = (int *)VSLOT(S_P1);
    int *m   = (int *)VSLOT(S_M);
    int *att = (int *)VSLOT(S_ATT);
    int *qs  = (int *)VSLOT(S_QS);
    int *kvs = (int *)VSLOT(S_KVS);
    signed char *a8 = (signed char *)VSLOT(S_A8);
    unsigned int sa, sw, tm;
    int ea, ew, te;
    unsigned long h;

    attn_init();

    if (!nq_run(fab, x, blk, 0u, a8, 1024u)) return 0;
    nq_scale(blk, 0u, 1024u, &sa, &ea);

    /* q and k through the QK-norm and the rotation; v through the same
       operator with a gain of one, so it gets a per-head absmax on the
       same terms and there is no second quantizer to keep in step.

       The scales are saved as each is produced, because qkn_core writes
       them into one set of globals and the next call overwrites them. */
    if (!blk_proj(blk, P_Q, 2048u, 1024u, a8, p0)) return 0;
    qkn_run(blk, 2u, S_P0, S_Q8, 16u, 1, 0u, 0);
    for (h = 0; h < 16u; h++) {
        qs[h * 2u]      = (int)qkn_sm[h];
        qs[h * 2u + 1u] = qkn_se[h];
    }

    if (!blk_proj(blk, P_K, 1024u, 1024u, a8, p0)) return 0;
    qkn_run(blk, 3u, S_P0, S_K8, 8u, 1, 0u, 0);
    for (h = 0; h < 8u; h++) {
        kvs[h * 4u]      = (int)qkn_sm[h];
        kvs[h * 4u + 1u] = qkn_se[h];
    }

    /* v is the one that needs its input's scale handed in, because
       nothing normalizes it away again. */
    if (!blk_proj(blk, P_V, 1024u, 1024u, a8, p0)) return 0;
    meta_bf(blk, META_SCALES, 2u, &sw, &ew);            /* v_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    qkn_run(blk, 0u, S_P0, S_V8, 8u, 0, tm, te);
    for (h = 0; h < 8u; h++) {
        kvs[h * 4u + 2u] = (int)qkn_sm[h];
        kvs[h * 4u + 3u] = qkn_se[h];
    }

    core_ok = 0;
    kvw_core(blk, pos, S_K8, S_V8, S_KVS, 8u, 128u);
    if (!core_ok) { uart_puts("ERR kvw\n"); return 0; }

    if (!attn_heads(blk, pos)) return 0;

    if (!nq_run(fab, att, blk, 4u, a8, 2048u)) return 0;
    nq_scale(blk, 4u, 2048u, &sa, &ea);
    if (!blk_proj(blk, P_O, 1024u, 2048u, a8, p0)) return 0;
    meta_bf(blk, META_SCALES, 3u, &sw, &ew);            /* o_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    resid_add(x, blk_xm, blk_xe, p0, tm, te, x1, 1024u, &blk_xm, &blk_xe);

    if (!nq_run(fab, x1, blk, 1u, a8, 1024u)) return 0;
    nq_scale(blk, 1u, 1024u, &sa, &ea);
    if (!blk_proj(blk, P_G, 3072u, 1024u, a8, p0)) return 0;
    if (!blk_proj(blk, P_U, 3072u, 1024u, a8, p1)) return 0;
    meta_bf(blk, META_SCALES, 4u, &sw, &ew);            /* gate_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    mlp_core(p0, p1, m, tm, (long)te + 512, 3072u);

    if (!nq_run(fab, m, blk, 5u, a8, 3072u)) return 0;
    nq_scale(blk, 5u, 3072u, &sa, &ea);
    if (!blk_proj(blk, P_D, 1024u, 3072u, a8, p0)) return 0;
    meta_bf(blk, META_SCALES, 6u, &sw, &ew);            /* down_proj */
    sc_mul(sw, ew, sa, ea, &tm, &te);
    resid_add(x1, blk_xm, blk_xe, p0, tm, te, x, 1024u, &blk_xm, &blk_xe);
    return 1;
}

/* XSC <mantissa> <exponent+512> -- the scale of the vector in slot 0.
   The bias keeps the exponent unsigned on the wire, the same convention
   MLP and SM already use for theirs. */
static void cmd_xsc(const char *p) {
    blk_xm = (unsigned int)parse_u(&p);
    blk_xe = (int)(long)parse_u(&p) - 512;
    uart_puts("OK XSC\n");
}

static void blk_report(const char *tag) {
    uart_puts(tag);
    uart_puts(" m "); uart_puthex(blk_xm);
    uart_puts(" e "); uart_putdec((long)blk_xe);
    uart_puts("\n");
}

/* BLK <blk> <fab> -- one block. TOK <nblk> <fab> -- all of them. */
static void cmd_blk(const char *p) {
    unsigned long blk = parse_u(&p), fab = parse_u(&p);
    if (blk >= 28u) { uart_puts("ERR range\n"); return; }
    if (!run_block(blk, blk_pos, (int)fab)) return;
    blk_report("BLK");
    uart_puts("OK BLK\n");
}

static void cmd_tok(const char *p) {
    unsigned long nb = parse_u(&p), fab = parse_u(&p), b;
    if (nb == 0u || nb > 28u) { uart_puts("ERR range\n"); return; }
    for (b = 0; b < nb; b++)
        if (!run_block(b, blk_pos, (int)fab)) {
            uart_puts("ERR at block "); uart_putdec((long)b);
            uart_puts("\n"); return;
        }
    blk_report("TOK");
    uart_puts("OK TOK\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "OPB ")) cmd_opb(line + 4);'
CMD_NEW = (CMD_OLD
           + '\n        else if (starts(line, "XSC ")) cmd_xsc(line + 4);'
           + '\n        else if (starts(line, "BLK ")) cmd_blk(line + 4);'
           + '\n        else if (starts(line, "TOK ")) cmd_tok(line + 4);')

#  OPB gains the two new operators, so the budget can be re-measured
#  against the driver rather than against the pieces it is made of.
OPB_OLD = '        else if (starts(c, "PAGEDMA ")) cmd_pagedma(c + 8);'
OPB_NEW = (OPB_OLD
           + '\n        else if (starts(c, "BLK ")) cmd_blk(c + 4);')

#  cmd_mlp is split so the block driver calls the same code the host
#  command does. Duplicating its body here is exactly the failure the
#  fused budget just diagnosed one level down.
MLP_OLD = """static void cmd_mlp(const char *p) {
    unsigned long gsl = parse_u(&p), usl = parse_u(&p), osl = parse_u(&p),
                  gmu = parse_u(&p), geb = parse_u(&p), n = parse_u(&p), i;
    const int *g = (const int *)VSLOT(gsl);
    const int *up = (const int *)VSLOT(usl);
    int *o = (int *)VSLOT(osl);"""

MLP_NEW = """/* mlp_core reports through globals rather than the UART, because the
   block driver calls it twenty-eight times a token and twenty-eight
   thirty-character lines is 73 ms of a 1.5-second token spent telling
   nobody what the shifts were. cmd_mlp still prints them, so every host
   parser written against MLP is unchanged. */
static int mlp_sa, mlp_su, mlp_ss, mlp_sm;

static void mlp_core(const int *g, const int *up, int *o,
                     unsigned long gmu, long geb, unsigned long n) {
    unsigned long i;"""

MLP_TAIL_OLD = """    uart_puts("MLP sa "); uart_putdec((long)sa);
    uart_puts(" su "); uart_putdec((long)su);
    uart_puts(" ss "); uart_putdec((long)ss);
    uart_puts(" sm "); uart_putdec((long)sm);
    uart_puts("\\nOK MLP\\n");
}"""

MLP_TAIL_NEW = """    mlp_sa = sa; mlp_su = su; mlp_ss = ss; mlp_sm = sm;
}

static void cmd_mlp(const char *p) {
    unsigned long gsl = parse_u(&p), usl = parse_u(&p), osl = parse_u(&p),
                  gmu = parse_u(&p), geb = parse_u(&p), n = parse_u(&p);
    mlp_core((const int *)VSLOT(gsl), (const int *)VSLOT(usl),
             (int *)VSLOT(osl), gmu, (long)geb, n);
    uart_puts("MLP sa "); uart_putdec((long)mlp_sa);
    uart_puts(" su "); uart_putdec((long)mlp_su);
    uart_puts(" ss "); uart_putdec((long)mlp_ss);
    uart_puts(" sm "); uart_putdec((long)mlp_sm);
    uart_puts("\\nOK MLP\\n");
}"""

#  geb arrives biased on the wire and mlp_core now takes it already
#  biased, so the one place that removed the bias moves with it.
MLP_BIAS_OLD = "sc_mul((unsigned int)gmu, (int)(long)geb - 512, 1u << 30, -30, &Gm, &Ge);"
MLP_BIAS_NEW = "sc_mul((unsigned int)gmu, (int)(geb - 512), 1u << 30, -30, &Gm, &Ge);"
