"""Block executor stage 4: the KV cache.

Stored bit-sliced at the stride the weight BRAM reads, because that is
what lets a chunk reach the array as a straight DMA burst.

Same escaping caution: these strings become C, so a newline inside a C
string literal is written \\n here.
"""

EXEC4 = r"""
/* ---- Stage 4: the KV cache -------------------------------------------
   Laid out in the form attention will read it, which is bit-sliced at the
   weight BRAM's own stride. Two facts fix the geometry.

   First, slicing on demand was measured against slicing on append:
   3,584 chunks of 1024 word-gathers per token is about 8.7 s, against
   17 ms for slicing each vector once as it arrives. So nothing is ever
   stored unsliced.

   Second, the weight BRAM is 128 bits wide -- 16384 words of 16 bytes --
   and AMAC reads the low 64 bits of each. Packing the planes at 8-byte
   stride round-trips perfectly through KVR and still cannot be DMA'd into
   the array without an expanding copy, so the stride is 16 with the upper
   half unused. Twice the memory, and every load becomes a straight burst.

   K and V slice along opposite axes, which is the easy thing to get
   wrong. Q.K^T sums over head_dim and yields one number per key, so keys
   are the array's 64 columns and dims are its depth: appending a key sets
   one bit in each of 128*8 words. P.V sums over keys and yields one
   number per dim, so dims are the columns and keys are the depth:
   appending a value writes eight whole words per 64-dim group.

   That transposition also sets the chunk sizes. Bit-serial int8 spends
   eight depth slots per element and the array is 1024 deep, so a pass
   covers 128 depth elements. For K the depth is head_dim = 128, which
   fits exactly once. For V the depth is the key index, so a chunk holds
   128 positions and a 512-token context takes four accumulating passes.

     K   8 chunks of 64 keys, 128 dims x 8 bits x 16 B = 16 KB per chunk
     V   4 position-chunks x 2 dim-chunks, 128 pos x 8 bits x 16 B
   Both come to 128 KB per (block, head) and 29.4 MB overall.

   No zeroing is needed on a fresh chunk: every bit is explicitly set or
   cleared, never OR-ed in. */

#define KV_K    (DDR_BASE + 0x08000000u)      /* 128 MB, 29.4 MB */
#define KV_V    (DDR_BASE + 0x0A000000u)      /* 160 MB, 29.4 MB */
#define KV_S    (DDR_BASE + 0x0C000000u)      /* 192 MB, scales  */
#define KV_NKV  8u
#define KV_HD   128u
#define KV_MAXP 512u
#define KV_CH   16384u                        /* one AMAC load, 1024 x 16 B */

/* K: one 64-key chunk for (blk, head). Depth is head_dim. */
static unsigned int kv_kbase(unsigned long blk, unsigned long h,
                             unsigned long chunk) {
    return KV_K + (((unsigned int)blk * KV_NKV + (unsigned int)h) * 8u
                   + (unsigned int)chunk) * KV_CH;
}

/* V: one (128-position, 64-dim) chunk for (blk, head). Depth is position. */
static unsigned int kv_vbase(unsigned long blk, unsigned long h,
                             unsigned long pch, unsigned long dch) {
    return KV_V + ((((unsigned int)blk * KV_NKV + (unsigned int)h) * 4u
                    + (unsigned int)pch) * 2u + (unsigned int)dch) * KV_CH;
}

/* Four int32 per (blk, head, pos): k mantissa, k exponent, v mantissa,
   v exponent. The host computes them; the board stores and returns them,
   so the scale convention lives in exactly one place. */
static unsigned int kv_sbase(unsigned long blk, unsigned long h,
                             unsigned long pos) {
    return KV_S + ((((unsigned int)blk * KV_NKV + (unsigned int)h)
                    * KV_MAXP + (unsigned int)pos) * 16u);
}

static void cmd_kvw(const char *p) {
    unsigned long blk = parse_u(&p), pos = parse_u(&p), ksl = parse_u(&p),
                  vsl = parse_u(&p), scl = parse_u(&p),
                  nkv = parse_u(&p), hd = parse_u(&p);
    const signed char *k = (const signed char *)VSLOT(ksl);
    const signed char *v = (const signed char *)VSLOT(vsl);
    const int *sc = (const int *)VSLOT(scl);
    unsigned long h, d, b, dch;
    unsigned int j, c, pch, pj, base, addr, word, bit, kb;

    if (blk >= 28u || pos >= KV_MAXP || nkv > KV_NKV || hd != KV_HD) {
        uart_puts("ERR range\n"); return;
    }
    c   = (unsigned int)(pos >> 6);          /* K chunk: 64 keys   */
    j   = (unsigned int)(pos & 63u);
    pch = (unsigned int)(pos >> 7);          /* V chunk: 128 depth */
    pj  = (unsigned int)(pos & 127u);

    for (h = 0; h < nkv; h++) {
        /* K: one bit per (dim, plane) -- 1024 read-modify-writes. */
        base = kv_kbase(blk, h, c);
        for (d = 0; d < hd; d++) {
            kb = (unsigned int)(unsigned char)k[h * hd + d];
            for (b = 0; b < 8u; b++) {
                addr = base + ((unsigned int)d * 8u + (unsigned int)b) * 16u
                       + (j >> 5) * 4u;
                bit  = 1u << (j & 31u);
                word = IO32(addr);
                IO32(addr) = ((kb >> b) & 1u) ? (word | bit) : (word & ~bit);
            }
        }
        /* V: whole words -- one depth row per position, per dim group. */
        for (dch = 0; dch < 2u; dch++) {
            base = kv_vbase(blk, h, pch, dch);
            for (b = 0; b < 8u; b++) {
                unsigned int lo = 0u, hi = 0u, dd;
                for (dd = 0; dd < 64u; dd++) {
                    kb = (unsigned int)(unsigned char)
                         v[h * hd + dch * 64u + dd];
                    if ((kb >> b) & 1u) {
                        if (dd < 32u) lo |= 1u << dd;
                        else          hi |= 1u << (dd - 32u);
                    }
                }
                addr = base + (pj * 8u + (unsigned int)b) * 16u;
                IO32(addr)      = lo;
                IO32(addr + 4u) = hi;
            }
        }
        addr = kv_sbase(blk, h, pos);
        IO32(addr)       = (unsigned int)sc[h * 4u + 0u];
        IO32(addr + 4u)  = (unsigned int)sc[h * 4u + 1u];
        IO32(addr + 8u)  = (unsigned int)sc[h * 4u + 2u];
        IO32(addr + 12u) = (unsigned int)sc[h * 4u + 3u];
    }
    uart_puts("OK KVW\n");
}

/* Reconstruct one cached vector from the sliced form. A slicing bug would
   otherwise appear as wrong scores twenty operators downstream. */
static void cmd_kvr(const char *p) {
    unsigned long blk = parse_u(&p), pos = parse_u(&p), h = parse_u(&p),
                  dst = parse_u(&p), which = parse_u(&p);
    signed char *o = (signed char *)VSLOT(dst);
    unsigned long d, b;
    unsigned int j, c, base, addr, val, dd, dch, pch, pj;

    if (blk >= 28u || pos >= KV_MAXP || h >= KV_NKV) {
        uart_puts("ERR range\n"); return;
    }
    if (which == 0u) {
        c = (unsigned int)(pos >> 6);
        j = (unsigned int)(pos & 63u);
        base = kv_kbase(blk, h, c);
        for (d = 0; d < KV_HD; d++) {
            val = 0u;
            for (b = 0; b < 8u; b++) {
                addr = base + ((unsigned int)d * 8u + (unsigned int)b) * 16u
                       + (j >> 5) * 4u;
                if ((IO32(addr) >> (j & 31u)) & 1u) val |= 1u << b;
            }
            o[d] = (signed char)(unsigned char)val;
        }
    } else {
        pch = (unsigned int)(pos >> 7);
        pj  = (unsigned int)(pos & 127u);
        for (d = 0; d < KV_HD; d++) {
            dch = (unsigned int)(d >> 6);
            dd  = (unsigned int)(d & 63u);
            base = kv_vbase(blk, h, pch, dch);
            val = 0u;
            for (b = 0; b < 8u; b++) {
                addr = base + (pj * 8u + (unsigned int)b) * 16u
                       + ((dd < 32u) ? 0u : 4u);
                if ((IO32(addr) >> (dd & 31u)) & 1u) val |= 1u << b;
            }
            o[d] = (signed char)(unsigned char)val;
        }
    }
    addr = kv_sbase(blk, h, pos);
    uart_puts("KVS ");
    uart_putdec((long)(int)IO32(addr));      uart_puts(" ");
    uart_putdec((long)(int)IO32(addr + 4u)); uart_puts(" ");
    uart_putdec((long)(int)IO32(addr + 8u)); uart_puts(" ");
    uart_putdec((long)(int)IO32(addr + 12u));
    uart_puts("\nOK KVR\n");
}

"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "QKN ")) cmd_qkn(line + 4);'
CMD_NEW = (CMD_OLD +
           '\n        else if (starts(line, "KVW ")) cmd_kvw(line + 4);'
           '\n        else if (starts(line, "KVR ")) cmd_kvr(line + 4);')
