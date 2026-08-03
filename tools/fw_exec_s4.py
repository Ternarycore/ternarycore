"""Block executor stage 4: the KV cache.

Stored bit-sliced, because that is the form AMAC reads and slicing on
demand costs 8.7 s a token against 17 ms for slicing on append.

Same escaping caution: these strings become C, so a newline inside a C
string literal is written \\n here.
"""

EXEC4 = r"""
/* ---- Stage 4: the KV cache -------------------------------------------
   Laid out in the form attention will read it, which is bit-sliced,
   because the alternative was measured and is not close. AMAC takes its
   second operand from the weight BRAM as bit planes -- word 8i+b holding
   bit b of element i across 64 columns -- and slicing 64 keys on demand
   is 3,584 chunks of 1024 word-gathers per token, about 8.7 seconds.
   Slicing each vector once when it is appended is 224 keys times 1024
   word updates, about 17 ms. So nothing is ever stored unsliced.

   K and V slice along opposite axes and this is the easy thing to get
   wrong. Q.K^T sums over head_dim and yields one number per key, so keys
   are the array's 64 columns and dims are its depth: appending a key sets
   a single bit in each of 128*8 words. P.V sums over keys and yields one
   number per dim, so dims are the columns and keys are the depth:
   appending a value writes eight whole words per 64-dim chunk. The same
   operator with its operands transposed, and two completely different
   write patterns.

   Sizes, at 28 blocks x 8 KV heads x 512 positions x 128 dims:
     K   8 chunks of 64 keys, 128*8 words of 64 bits = 8 KB per chunk
         -> 64 KB per (block, head), 14.7 MB total
     V   2 chunks of 64 dims, 512*8 words of 64 bits = 32 KB per chunk
         -> 64 KB per (block, head), 14.7 MB total
   Both sit above the 110 MB model and below the scratch vectors at 208 MB.

   No zeroing is needed on a fresh chunk: every bit is explicitly set or
   cleared, never OR-ed in. */

#define KV_K    (DDR_BASE + 0x08000000u)      /* 128 MB */
#define KV_V    (DDR_BASE + 0x0A000000u)      /* 160 MB */
#define KV_S    (DDR_BASE + 0x0C000000u)      /* 192 MB, scales */
#define KV_NKV  8u
#define KV_HD   128u
#define KV_MAXP 512u

/* One 64-key chunk of sliced K for (blk, head): 128 dims x 8 bits x 8 B. */
static unsigned int kv_kbase(unsigned long blk, unsigned long h,
                             unsigned long chunk) {
    return KV_K + (((unsigned int)blk * KV_NKV + (unsigned int)h) * 8u
                   + (unsigned int)chunk) * 8192u;
}

/* One 64-dim chunk of sliced V for (blk, head): 512 positions x 8 bits. */
static unsigned int kv_vbase(unsigned long blk, unsigned long h,
                             unsigned long chunk) {
    return KV_V + (((unsigned int)blk * KV_NKV + (unsigned int)h) * 2u
                   + (unsigned int)chunk) * 32768u;
}

/* Four int32 per (blk, head, pos): k mantissa, k exponent, v mantissa,
   v exponent. The host computes them; the board only stores and returns
   them, so the scale convention stays in one place. */
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
    unsigned long h, d, b, ch;
    unsigned int j, c, base, addr, word, bit, kb;

    if (blk >= 28u || pos >= KV_MAXP || nkv > KV_NKV || hd != KV_HD) {
        uart_puts("ERR range\n"); return;
    }
    c = (unsigned int)(pos >> 6);
    j = (unsigned int)(pos & 63u);

    for (h = 0; h < nkv; h++) {
        /* K: one bit per (dim, bitplane), 1024 read-modify-writes. */
        base = kv_kbase(blk, h, c);
        for (d = 0; d < hd; d++) {
            kb = (unsigned int)(unsigned char)k[h * hd + d];
            for (b = 0; b < 8u; b++) {
                addr = base + (((unsigned int)d * 8u + (unsigned int)b) * 2u
                               + (j >> 5)) * 4u;
                bit  = 1u << (j & 31u);
                word = IO32(addr);
                IO32(addr) = ((kb >> b) & 1u) ? (word | bit) : (word & ~bit);
            }
        }
        /* V: whole words, one depth row per position. */
        for (ch = 0; ch < 2u; ch++) {
            base = kv_vbase(blk, h, ch);
            for (b = 0; b < 8u; b++) {
                unsigned int lo = 0u, hi = 0u, dd;
                for (dd = 0; dd < 64u; dd++) {
                    kb = (unsigned int)(unsigned char)
                         v[h * hd + ch * 64u + dd];
                    if ((kb >> b) & 1u) {
                        if (dd < 32u) lo |= 1u << dd;
                        else          hi |= 1u << (dd - 32u);
                    }
                }
                addr = base + (((unsigned int)pos * 8u
                                + (unsigned int)b) * 8u);
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
    unsigned int j, c, base, addr, val, dd, ch;

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
                addr = base + (((unsigned int)d * 8u + (unsigned int)b) * 2u
                               + (j >> 5)) * 4u;
                if ((IO32(addr) >> (j & 31u)) & 1u) val |= 1u << b;
            }
            o[d] = (signed char)(unsigned char)val;
        }
    } else {
        for (d = 0; d < KV_HD; d++) {
            ch = (unsigned int)(d >> 6);
            dd = (unsigned int)(d & 63u);
            base = kv_vbase(blk, h, ch);
            val = 0u;
            for (b = 0; b < 8u; b++) {
                addr = base + (((unsigned int)pos * 8u + (unsigned int)b) * 8u)
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
