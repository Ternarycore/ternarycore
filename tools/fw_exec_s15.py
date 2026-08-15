"""Block executor stage 15: what QK-norm's int8 is actually worth.

The KV cache stores a block-float scale per key and per value, and today
the *host* computes them -- in float64, from the reference model -- and
hands them to the board. That is fine for a check and impossible for a
block driver, which has no host to ask.

They have to come out of what qkn_core already knows. It does not know
them today, and the derivation is the whole risk in putting attention on
the board, so it is written out here rather than in a commit message.

    u[i]  = rsh(rsh(qh[i], s1) * g[i], st), rotated
    o8[i] = u[i] * 127 / mx

The rotation is by cos and sin in Q15 with a >>15, so it preserves
magnitude. That makes one unit of o8 worth

    mx * 2^(s1+st) * (gmax/32767) / 127

of the *unnormalized* product qh*g, in the accumulator's own units --
gmax/32767 because the gain was stored Q15-normalized against its own
maximum, and 32767 rather than 32768 because q15v clips to Q15.

Then the two operators diverge, and this is the part that matters.

For q and k the QK-norm's division by the root-mean-square is deferred:
nothing in the data is divided by it, which is why `ss` is reported at
all. So it belongs in the scale --

    rms = sqrt(ss * 4^(s1+sq) / hd)

-- and because that rms is in the accumulator's own units too, the
accumulator's scale cancels against it. The answer is absolute. That is
the same invariance the block driver already relies on at every
normalization, and it is why run_block can forget its input's scale four
times a block without losing anything.

For v there is no normalization at all. It is absmax-quantized and
nothing divides it, so the accumulator's scale does not cancel and has to
be multiplied back in.

Two calls into the same function, identical from the outside, differing
in whether one factor survives. The `norm` flag is not a convenience, and
getting it backwards would produce a scale wrong by a factor that varies
per head -- which is exactly the shape of the three bugs this project has
already shipped and caught: a spurious multiply that made the MLP
contribute nothing while the block still scored 0.028 and passed, a shift
sized for a theoretical maximum rather than for the data, and a bound
computed with truncation and applied with rounding.

So QSC exists: it reads the scales back out so the host can compare them
against the float64 ones it has been computing all along. The formula is
not trusted until that comparison is made.

Escaping caution: raw strings that become C, so a newline inside a C
string literal is written \n and stays that way.
"""

#  sc_mul and friends are stage 5 and are defined below QKN, which is
#  stage 3. Prototypes rather than moving them: the definitions are
#  load-bearing for softmax and this is not the moment to re-verify it.
DEFS = r"""
/* Stage 5's block-float helpers, declared early because QKN needs them
   and QKN is two stages older. */
static void sc_mul(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo);
static void sc_div(unsigned int ma, int ea, unsigned int mb, int eb,
                   unsigned int *mo, int *eo);
static void sc_sqrt(unsigned int m, int e, unsigned int *mo, int *eo);

/* What qkn_core needs and cannot parse for itself, and what it returns
   beyond the int8. qkn_norm picks which of the two operators this call
   is: 1 divides by the deferred root-mean-square and the input's own
   scale cancels, 0 does not and it does not. */
static unsigned int qkn_gm = 1u, qkn_am = 1u;
static int          qkn_ge = 0,  qkn_ae = 0;
static int          qkn_norm = 1;
static unsigned int qkn_sm[16];
static int          qkn_se[16];
"""

DEFS_ANCHOR = "static int nq_mx, nq_xs, nq_amx;"

#  Inserted where qkn_core finishes a head, so every quantity it uses is
#  still the one that head just produced.
SCALE_OLD = r"""        sc[h * 4u + 0u] = (int)ss;
        sc[h * 4u + 1u] = s1;
        sc[h * 4u + 2u] = sq;
        sc[h * 4u + 3u] = mx;"""

SCALE_NEW = r"""        sc[h * 4u + 0u] = (int)ss;
        sc[h * 4u + 1u] = s1;
        sc[h * 4u + 2u] = sq;
        sc[h * 4u + 3u] = mx;

        /* This head's int8 in true units. See the stage 15 note: one
           unit of o8 is mx * 2^(s1+st) * (gmax/32767) / 127 of the
           unnormalized product, then divided by the deferred rms for q
           and k -- against which the input's own scale cancels -- or
           multiplied by that input scale for v, which is absmax
           quantized and never normalized at all. */
        {
            unsigned int t, r;
            int te, re;
            sc_mul(qkn_gm, qkn_ge, (unsigned int)mx, s1 + st, &t, &te);
            sc_div(t, te, 4161409u, 0, &t, &te);       /* 32767 * 127 */
            if (qkn_norm) {
                sc_div((unsigned int)ss, 2 * (s1 + sq),
                       (unsigned int)hd, 0, &r, &re);
                sc_sqrt(r, re, &r, &re);
                sc_div(t, te, r, re, &t, &te);
            } else {
                sc_mul(t, te, qkn_am, qkn_ae, &t, &te);
            }
            qkn_sm[h] = t;
            qkn_se[h] = te;
        }"""

EXEC15 = r"""
/* ---- Stage 15: reading the QK-norm scales back ----------------------- */

/* QGX <gm> <ge+512> <norm> <am> <ae+512> -- the inputs qkn_core cannot
   parse for itself. The exponent bias keeps it unsigned on the wire, the
   same convention MLP, SM and XSC already use. */
static void cmd_qgx(const char *p) {
    qkn_gm   = (unsigned int)parse_u(&p);
    qkn_ge   = (int)(long)parse_u(&p) - 512;
    qkn_norm = (int)parse_u(&p);
    qkn_am   = (unsigned int)parse_u(&p);
    qkn_ae   = (int)(long)parse_u(&p) - 512;
    uart_puts("OK QGX\n");
}

/* QSC <nh> -- the per-head scales, so the host can check a derivation
   against the float64 one it has been computing all along. */
static void cmd_qsc(const char *p) {
    unsigned long nh = parse_u(&p), h;
    if (nh == 0u || nh > 16u) { uart_puts("ERR range\n"); return; }
    for (h = 0; h < nh; h++) {
        uart_puts("QSC "); uart_putdec((long)h);
        uart_puts(" m "); uart_puthex(qkn_sm[h]);
        uart_puts(" e "); uart_putdec((long)qkn_se[h]);
        uart_puts("\n");
    }
    uart_puts("OK QSC\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "TOK ")) cmd_tok(line + 4);'
CMD_NEW = (CMD_OLD
           + '\n        else if (starts(line, "QGX ")) cmd_qgx(line + 4);'
           + '\n        else if (starts(line, "QSC ")) cmd_qsc(line + 4);')
