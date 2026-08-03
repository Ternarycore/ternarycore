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
   six times a block on vectors up to 3072 wide -- about 300,000 elements
   per token -- and RoPE's 11 ms was an estimate.

   Measured, they came back at 63.6, 120.5 and 176.5 ms a token against 29
   ms budgeted for all of them together. Ops 12-14 below are the same three
   with every 64-bit intermediate removed, to find out whether that is the
   operators or the 32-bit CPU synthesising long long out of parts. */

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
   tabled for every position, which would want 256 KB. */
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
   well before the end, so this accumulator is 64-bit. */
static void bench_sumsq(int n) {
    int i;
    long long s = 0;
    for (i = 0; i < n; i++) s += (long long)bench_buf[i] * bench_buf[i];
    bench_out[0] = (int)(s >> 20);
}

/* ---- The same three, with no 64-bit arithmetic anywhere --------------
   Each shifts its operands into 16 bits first, so every product is a
   32-bit multiply the hardware multiplier does in one go. What that costs
   is precision, and the honest question is whether these three consumers
   need it: an int8 quantizer emits seven bits, a reciprocal square root
   feeds a scale factor, and RoPE's rotation is bounded by construction.
   None of them are carrying 30 significant bits anywhere useful. */

static void bench_quant32(int n) {
    int i, v, mx = 0, inv, sh = 0;
    for (i = 0; i < n; i++) {
        v = bench_buf[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    if (mx == 0) mx = 1;
    while ((mx >> sh) > 32767) sh++;            /* max into 16 bits */
    v = mx >> sh; if (v == 0) v = 1;
    inv = (127 << 15) / v;
    for (i = 0; i < n; i++)
        bench_i8[i] = (signed char)(((bench_buf[i] >> sh) * inv) >> 15);
    bench_out[0] = mx;
}

/* Q1.15 rotation: cos and sin drop to 16 bits, activations shift into 16,
   and every product stays 32-bit. */
static void bench_rope32(int n) {
    int h, i, a, b, c, s;
    rope_init();
    for (h = 0; h + 128 <= n; h += 128) {
        for (i = 0; i < 64; i++) {
            a = bench_buf[h + i] >> 8;
            b = bench_buf[h + 64 + i] >> 8;
            c = rope_cos[i] >> 1;
            s = rope_sin[i] >> 1;
            bench_out[h + i]      = ((a * c - b * s) >> 15) << 8;
            bench_out[h + 64 + i] = ((b * c + a * s) >> 15) << 8;
        }
    }
}

/* Sum of squares in 32 bits: shift the vector until 1024 squares cannot
   overflow. Costs low bits the scale factor never sees. */
static void bench_sumsq32(int n) {
    int i, v, mx = 0, sh = 0;
    unsigned int s = 0u;
    for (i = 0; i < n; i++) {
        v = bench_buf[i];
        if (v < 0) v = -v;
        if (v > mx) mx = v;
    }
    while ((mx >> sh) > 2047) sh++;        /* x*x <= 2^22, 1024 of them fit */
    for (i = 0; i < n; i++) {
        v = bench_buf[i] >> sh;
        s += (unsigned int)(v * v);
    }
    bench_out[0] = (int)(s >> 4);
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
        else               bench_mac((int)n);"""

ANCHOR = "static void bench_mac(int n) {"
