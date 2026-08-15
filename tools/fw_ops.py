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
   per token -- and RoPE's 11 ms was an estimate. */

static signed char bench_i8[BN];
static int rope_cos[64], rope_sin[64];
static int rope_ready = 0;

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
   use it. LMB is 64 KB, the firmware already holds 56 KB, and one block's
   working set -- residual, normed copy, Q, K, V, attention output, gate
   and up -- is about 56 KB. All of it lives in DDR.

   HOT reuses one buffer; COLD walks a 256 KB region. With a working cache
   those two must differ. Measured, they did not. */

#define DDRB_BASE   (DDR_BASE + 0x0C000000u)  /* 192 MB in, clear of weights */
#define DDRB_STRIDE 0x4000u                   /* 16 KB, one D-cache worth    */
#define DDRB_SLOTS  16u                       /* 256 KB total, 16x the cache */
#define DDRB_OUT    0x00100000u
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

/* ---- The data cache, which has never been switched on ----------------
   create_bd_ddr.tcl gives this MicroBlaze 16 KB of D-cache. main() has
   never executed the msrset that enables it, so every DDR access this
   project has made went to the MIG uncached -- the CPU pager's 48 ms per
   page, and every operator above at roughly 4.5x its local-memory cost.

   The benchmark said so before the source did: DDR hot and DDR cold came
   back within 1% on all three operators. One 4 KB buffer reused and a
   256 KB region walked cannot cost the same through a cache.

   Toggleable rather than always-on. Switching it on makes the flush in
   cmd_pagedma load-bearing for the first time -- until now it has been
   flushing a cache that was not there -- so the ternary and int8
   verifications have to be re-run with it enabled before anything here
   is believed. An A/B inside one firmware build settles the size of the
   effect without a second variable. */

static int dcache_on = 0;

static void dcache_invalidate_all(void) {
    unsigned long i, zero = 0;
    for (i = 0; i < 16384u; i += 32u)
        __asm__ __volatile__ ("wdc %0, %1" :: "r"(DDR_BASE + i), "r"(zero));
    __asm__ __volatile__ ("mbar 1");
}

static void cmd_cache(const char *p) {
    p = skip_ws(p);
    if (*p == '1') {
        if (!dcache_on) {
            dcache_invalidate_all();
            __asm__ __volatile__ ("msrset r0, 0x80" ::: "memory");
            dcache_on = 1;
        }
    } else if (*p == '0') {
        if (dcache_on) {
            __asm__ __volatile__ ("msrclr r0, 0x80" ::: "memory");
            dcache_on = 0;
        }
    }
    uart_puts(dcache_on ? "OK CACHE 1\n" : "OK CACHE 0\n");
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

# The top-level command chain. No existing command is a prefix of "CACHE",
# which is the check SL8 had to learn the hard way after SLOAD8 collided
# with SLOAD and the dispatcher matched the earlier entry.
CMD_OLD = '        else if (starts(line, "MEMTEST")) cmd_memtest();'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "CACHE")) cmd_cache(line + 5);'
