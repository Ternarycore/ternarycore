"""Phase-5 operator primitives, injected into ddr_host.c by make_ddr_fw.py.

Kept in its own file because make_ddr_fw.py is already a wall of C-inside-
Python, and because these functions are the ones whose cost decides whether
the token budget survives contact with a real block.

Careful with escapes: these strings become C, so a newline inside a C
string literal must be written \\n here. Getting that wrong produces
firmware that compiles and prints garbage.
"""

OPS = r"""
/* ---- Phase-5: the operators the budget never counted -----------------
   The token budget has measured lines for the pager, softmax, SiLU and
   RMSNorm. It had no line at all for the activation quantizer, which runs
   six times a block on vectors up to 3072 wide -- about 315,000 elements
   per token -- and RoPE's 11 ms was an estimate.

   Measured, they came back at 70.0, 120.5 and 196.6 ms a token against 29
   ms budgeted for all of them together. Ops 12-14 are the same three with
   every 64-bit intermediate removed. Ops 15-20 are the winners of that
   comparison, moved to DDR where they will actually run. */

static signed char bench_i8[BN];
static int rope_cos[64], rope_sin[64];
static int rope_ready = 0;

/* Per-token absmax int8, exactly BitLinear's definition: one pass for the
   maximum, one reciprocal, one pass to scale. The reciprocal is deliberate
   -- a divide per element is the trap softmax fell into, and MicroBlaze's
   hardware divider is 30-odd cycles. */
static void bench_quant(int n) {
    int i, v, mx = 0, inv;
    for (i = 0; i < n; i++) {
        v = bench_buf[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    if (mx == 0) mx = 1;
    inv = (int)(((unsigned int)127u << 24) / (unsigned int)mx);
    for (i = 0; i < n; i++)
        bench_i8[i] = (signed char)(((long long)bench_buf[i] * inv) >> 24);
    bench_out[0] = mx;
}

static void rope_init(void) {
    int i;
    if (rope_ready) return;
    for (i = 0; i < 64; i++) {
        rope_cos[i] = 60000 - i * 37;
        rope_sin[i] = 12000 + i * 41;
    }
    rope_ready = 1;
}

/* RoPE over 128-wide heads: q' = q*cos + rot(q)*sin, rot([a,b]) = [-b,a]
   across the halves. cos and sin come from the host for the current
   position -- 512 bytes a token -- rather than being tabled for every
   position, which would want 256 KB. */
static void bench_rope(int n) {
    int h, i, a, b;
    rope_init();
    for (h = 0; h + 128 <= n; h += 128) {
        for (i = 0; i < 64; i++) {
            a = bench_buf[h + i];
            b = bench_buf[h + 64 + i];
            bench_out[h + i] = (int)((((long long)a * rope_cos[i])
                                    - ((long long)b * rope_sin[i])) >> 16);
            bench_out[h + 64 + i] = (int)((((long long)b * rope_cos[i])
                                         + ((long long)a * rope_sin[i])) >> 16);
        }
    }
}

static void bench_sumsq(int n) {
    int i;
    long long s = 0;
    for (i = 0; i < n; i++) s += (long long)bench_buf[i] * bench_buf[i];
    bench_out[0] = (int)(s >> 20);
}

/* ---- The same three, with no 64-bit arithmetic anywhere -------------- */

static void op_quant_p(const int *in, signed char *o8, int n) {
    int i, v, mx = 0, inv, sh = 0;
    for (i = 0; i < n; i++) {
        v = in[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    if (mx == 0) mx = 1;
    while ((mx >> sh) > 32767) sh++;
    v = mx >> sh; if (v == 0) v = 1;
    inv = (127 << 15) / v;
    for (i = 0; i < n; i++)
        o8[i] = (signed char)(((in[i] >> sh) * inv) >> 15);
    bench_out[0] = mx;
}

static void op_rope_p(const int *in, int *out, int n) {
    int h, i, a, b, c, s;
    rope_init();
    for (h = 0; h + 128 <= n; h += 128) {
        for (i = 0; i < 64; i++) {
            a = in[h + i] >> 8;
            b = in[h + 64 + i] >> 8;
            c = rope_cos[i] >> 1;
            s = rope_sin[i] >> 1;
            out[h + i]      = ((a * c - b * s) >> 15) << 8;
            out[h + 64 + i] = ((b * c + a * s) >> 15) << 8;
        }
    }
}

static void op_sumsq_p(const int *in, int n) {
    int i, v, mx = 0, sh = 0;
    unsigned int s = 0u;
    for (i = 0; i < n; i++) {
        v = in[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    while ((mx >> sh) > 2047) sh++;
    for (i = 0; i < n; i++) {
        v = in[i] >> sh;
        s += (unsigned int)(v * v);
    }
    bench_out[0] = (int)(s >> 4);
}

static void bench_quant32(int n) { op_quant_p(bench_buf, bench_i8, n); }
static void bench_rope32(int n)  { op_rope_p(bench_buf, bench_out, n); }
static void bench_sumsq32(int n) { op_sumsq_p(bench_buf, n); }

/* ---- The same operators, on DDR-resident vectors ---------------------
   Everything above runs in local memory: single cycle, no cache, the
   fastest memory this CPU will ever address. The block executor cannot
   use it. LMB is 64 KB, the firmware already holds 54 KB, and one block's
   working set -- residual, normed copy, Q, K, V, attention output, gate
   and up -- is about 56 KB. All of it lives in DDR behind a 16 KB cache.

   So the budget is currently built on numbers taken under conditions the
   real system will not run in.

   HOT reuses one buffer, so after the first repetition everything is
   resident: the best case, and what a fused producer-consumer pair would
   see. COLD walks a 256 KB region so no repetition finds its data cached:
   the worst case, and what a vector written early in a block and read
   late actually gets. The executor lives between them. */

#define DDRB_BASE   (DDR_BASE + 0x0C000000u)  /* 192 MB in, clear of weights */
#define DDRB_STRIDE 0x4000u                   /* 16 KB, one D-cache worth    */
#define DDRB_SLOTS  16u                       /* 256 KB total, 16x the cache */
#define DDRB_OUT    0x00100000u               /* outputs a megabyte further  */
#define DDRB_I8     0x00200000u

static unsigned int ddrb_rep = 0u;
static int ddrb_ready = 0;

static void ddrb_init(void) {
    unsigned int i;
    if (ddrb_ready) return;
    for (i = 0; i < DDRB_SLOTS * DDRB_STRIDE; i += 4u)
        IO32(DDRB_BASE + i) = (unsigned int)(i * 2654435761u) & 0x3FFFu;
    ddrb_ready = 1;
}

static unsigned int ddrb_slot(int cold) {
    unsigned int s = cold ? ((ddrb_rep % DDRB_SLOTS) * DDRB_STRIDE) : 0u;
    ddrb_rep++;
    return s;
}

static void bench_quant_ddr(int n, int cold) {
    unsigned int s = ddrb_slot(cold);
    ddrb_init();
    op_quant_p((const int *)(DDRB_BASE + s),
               (signed char *)(DDRB_BASE + DDRB_I8 + s), n);
}

static void bench_rope_ddr(int n, int cold) {
    unsigned int s = ddrb_slot(cold);
    ddrb_init();
    op_rope_p((const int *)(DDRB_BASE + s),
              (int *)(DDRB_BASE + DDRB_OUT + s), n);
}

static void bench_sumsq_ddr(int n, int cold) {
    unsigned int s = ddrb_slot(cold);
    ddrb_init();
    op_sumsq_p((const int *)(DDRB_BASE + s), n);
}

"""

# cmd_bench's dispatch chain; the final else must stay last.
DISPATCH_OLD = "        else               bench_mac((int)n);"
DISPATCH_NEW = """        else if (op == 9u)  bench_quant((int)n);
        else if (op == 10u) bench_rope((int)n);
        else if (op == 11u) bench_sumsq((int)n);
        else if (op == 12u) bench_quant32((int)n);
        else if (op == 13u) bench_rope32((int)n);
        else if (op == 14u) bench_sumsq32((int)n);
        else if (op == 15u) bench_quant_ddr((int)n, 0);
        else if (op == 16u) bench_quant_ddr((int)n, 1);
        else if (op == 17u) bench_rope_ddr((int)n, 0);
        else if (op == 18u) bench_rope_ddr((int)n, 1);
        else if (op == 19u) bench_sumsq_ddr((int)n, 0);
        else if (op == 20u) bench_sumsq_ddr((int)n, 1);
        else               bench_mac((int)n);"""

ANCHOR = "static void bench_mac(int n) {"
