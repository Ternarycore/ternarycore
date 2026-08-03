"""Phase-5 operator primitives, injected into ddr_host.c by make_ddr_fw.py.

Kept in its own file because make_ddr_fw.py is already a wall of C-inside-
Python, and because these three functions are the ones whose cost decides
whether the 593 ms token budget survives contact with a real block.

Careful with escapes: these strings become C, so a newline inside a C
string literal must be written \\n here, not \\n's evaluated form. Getting
that wrong produces firmware that compiles and prints garbage.
"""

OPS = r"""
/* ---- Phase-5: the operators the budget never counted -----------------
   The token budget has measured lines for the pager, softmax, SiLU and
   RMSNorm. It has no line at all for the activation quantizer, which runs
   six times a block on vectors up to 3072 wide -- about 336,000 elements
   per token -- and RoPE's 11 ms was an estimate. Neither has ever been
   timed on this CPU.

   That is exactly the shape of the mistake that hid a 9.2-second wall in
   attention until it was measured, so measure first and design after. */

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

/* RoPE over 128-wide heads: q' = q*cos + rot(q)*sin, rot([a,b]) = [-b,a]
   across the halves. cos and sin come from the host for the current
   position -- 512 bytes a token -- rather than being recomputed here or
   tabled for every position, which would want 256 KB. The table below is
   a stand-in with the right shape and cost. */
static void rope_init(void) {
    int i;
    if (rope_ready) return;
    for (i = 0; i < 64; i++) {
        rope_cos[i] = 60000 - i * 37;
        rope_sin[i] = 12000 + i * 41;
    }
    rope_ready = 1;
}

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

/* RMSNorm's vector half. 1024 squares of Q16.16 values overflow 32 bits
   well before the end, so the accumulator is 64-bit -- on a 32-bit CPU
   that is a real cost and worth separating from the rest of the norm. */
static void bench_sumsq(int n) {
    int i;
    long long s = 0;
    for (i = 0; i < n; i++) s += (long long)bench_buf[i] * bench_buf[i];
    bench_out[0] = (int)(s >> 20);
}

"""

# cmd_bench's dispatch chain; the final else must stay last.
DISPATCH_OLD = "        else               bench_mac((int)n);"
DISPATCH_NEW = """        else if (op == 9u)  bench_quant((int)n);
        else if (op == 10u) bench_rope((int)n);
        else if (op == 11u) bench_sumsq((int)n);
        else               bench_mac((int)n);"""

ANCHOR = "static void bench_mac(int n) {"
