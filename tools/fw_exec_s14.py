"""Block executor stage 14: the attention handlers become callable cores.

BLK runs a block at position 0, where attention over a single key is the
value vector and q, k, the KV cache, the softmax and P.V contribute
nothing. Generation needs all of them, and the block driver has to call
them without a host in the middle.

They already exist and are already verified -- QKN at stage 3, KVW at 4,
Q.K^T at 6, softmax at 7, P.V at 8, and block_multi.py checks the whole
chain at four positions. What they are not is callable: each is a command
handler that parses a line and reports over the UART.

So this splits them the way cmd_mlp was split into mlp_core. It does not
copy them. Copying an operator so a second caller can have one is exactly
the failure the fused budget diagnosed one level down -- BENCH's
micro-loops had drifted from the operators they were written beside, and
the budget was 2.7x wrong for four months because nothing forced them to
stay equal.

Two rules make these edits low-risk, and both were chosen after looking
at what actually breaks in string surgery against generated C:

  * The cores take slot indices, not pointers, so the pointer
    declarations under each signature are untouched. Only the signature
    line and the report block move.
  * Failure is signalled by a global set at the end of a successful run,
    not by a return value. Every one of these functions has a range check
    that prints and returns early, and `uart_puts("ERR range\n"); return;`
    is not a unique string anywhere in this firmware. A flag cleared by
    the caller and set only on success catches every early exit without
    touching one of them.

Escaping caution: these are raw strings that become C, so a newline
inside a C string literal is written \n and stays that way.
"""

DEFS = r"""
/* Results of the last *_core call, for callers that have no UART to read
   a report from. core_ok is cleared by the caller and set only where a
   core runs to completion, so every early return -- including the range
   checks, which are untouched -- reads as failure. */
static int core_ok;
static unsigned long core_chk, core_n, core_p;
"""

#  (anchor, replacement) pairs. Signature first, report second, per
#  handler. Every anchor is short enough to have been read verbatim.
EDITS = [

    # ---- QKN: QK-norm + RoPE + quantize --------------------------------
    (r"""static void cmd_qkn(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), cs = parse_u(&p),
                  dst = parse_u(&p), ssl = parse_u(&p),
                  nh = parse_u(&p), hd = parse_u(&p);""",
     r"""static void qkn_core(unsigned long src, unsigned long gsl,
                     unsigned long cs, unsigned long dst, unsigned long ssl,
                     unsigned long nh, unsigned long hd) {"""),

    (r"""    uart_puts("QCHK "); uart_puthex(chk); uart_puts("\nOK QK\n");
}""",
     r"""    core_chk = chk; core_ok = 1;
}

static void cmd_qkn(const char *p) {
    unsigned long src = parse_u(&p), gsl = parse_u(&p), cs = parse_u(&p),
                  dst = parse_u(&p), ssl = parse_u(&p),
                  nh = parse_u(&p), hd = parse_u(&p);
    core_ok = 0;
    qkn_core(src, gsl, cs, dst, ssl, nh, hd);
    if (!core_ok) return;
    uart_puts("QCHK "); uart_puthex(core_chk); uart_puts("\nOK QK\n");
}"""),

    # ---- KVW: bit-slice and append K and V ------------------------------
    (r"""static void cmd_kvw(const char *p) {
    unsigned long blk = parse_u(&p), pos = parse_u(&p), ksl = parse_u(&p),
                  vsl = parse_u(&p), scl = parse_u(&p),
                  nkv = parse_u(&p), hd = parse_u(&p);""",
     r"""static void kvw_core(unsigned long blk, unsigned long pos,
                     unsigned long ksl, unsigned long vsl, unsigned long scl,
                     unsigned long nkv, unsigned long hd) {"""),

    (r"""    uart_puts("OK KVW\n");
}""",
     r"""    core_ok = 1;
}

static void cmd_kvw(const char *p) {
    unsigned long blk = parse_u(&p), pos = parse_u(&p), ksl = parse_u(&p),
                  vsl = parse_u(&p), scl = parse_u(&p),
                  nkv = parse_u(&p), hd = parse_u(&p);
    core_ok = 0;
    kvw_core(blk, pos, ksl, vsl, scl, nkv, hd);
    if (core_ok) uart_puts("OK KVW\n");
}"""),

    # ---- Q.K^T on the array ---------------------------------------------
    (r"""static void cmd_qk(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  qsl = parse_u(&p), dsl = parse_u(&p);""",
     r"""static void qk_core(unsigned long blk, unsigned long kvh,
                    unsigned long pos, unsigned long qsl, unsigned long dsl) {"""),

    (r"""    uart_puts("QKCHK "); uart_puthex(chk);
    uart_puts(" N "); uart_putdec((long)npos);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nOK QKD\n");
}""",
     r"""    core_chk = chk; core_n = npos; core_ok = 1;
}

static void cmd_qk(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  qsl = parse_u(&p), dsl = parse_u(&p);
    core_ok = 0;
    qk_core(blk, kvh, pos, qsl, dsl);
    if (!core_ok) return;
    uart_puts("QKCHK "); uart_puthex(core_chk);
    uart_puts(" N "); uart_putdec((long)core_n);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\nOK QKD\n");
}"""),

    # ---- softmax ---------------------------------------------------------
    (r"""static void cmd_sm(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  dsl = parse_u(&p), qmu = parse_u(&p), qeb = parse_u(&p),
                  psl = parse_u(&p), ssl = parse_u(&p);""",
     r"""static void sm_core(unsigned long blk, unsigned long kvh,
                    unsigned long pos, unsigned long dsl, unsigned long qmu,
                    unsigned long qeb, unsigned long psl, unsigned long ssl) {"""),

    # The report is rebuilt from the scalar slot the core writes, rather
    # than from its locals. Same four numbers, and it now proves the write
    # landed instead of only that the values existed.
    (r"""    uart_puts("SM wmax "); uart_puthex(wmax);
    uart_puts(" ve "); uart_putdec((long)vemax);
    uart_puts(" sume "); uart_puthex(sume);
    uart_puts(" n "); uart_putdec((long)npos);
    uart_puts("\nOK SM\n");
}""",
     r"""    core_ok = 1;
}

static void cmd_sm(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  dsl = parse_u(&p), qmu = parse_u(&p), qeb = parse_u(&p),
                  psl = parse_u(&p), ssl = parse_u(&p);
    const int *so;
    core_ok = 0;
    sm_core(blk, kvh, pos, dsl, qmu, qeb, psl, ssl);
    if (!core_ok) return;
    so = (const int *)VSLOT(ssl);
    uart_puts("SM wmax "); uart_puthex((unsigned long)so[0]);
    uart_puts(" ve "); uart_putdec((long)so[1]);
    uart_puts(" sume "); uart_puthex((unsigned long)so[2]);
    uart_puts(" n "); uart_putdec((long)so[3]);
    uart_puts("\nOK SM\n");
}"""),

    # ---- P.V on the array ------------------------------------------------
    (r"""static void cmd_pv(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  psl = parse_u(&p), osl = parse_u(&p);""",
     r"""static void pv_core(unsigned long blk, unsigned long kvh,
                    unsigned long pos, unsigned long psl, unsigned long osl) {"""),

    (r"""    uart_puts("PVCHK "); uart_puthex(chk);
    uart_puts(" N "); uart_putdec((long)npos);
    uart_puts(" P "); uart_putdec((long)npch);
    uart_puts("\nOK PV\n");
}""",
     r"""    core_chk = chk; core_n = npos; core_p = npch; core_ok = 1;
}

static void cmd_pv(const char *p) {
    unsigned long blk = parse_u(&p), kvh = parse_u(&p), pos = parse_u(&p),
                  psl = parse_u(&p), osl = parse_u(&p);
    core_ok = 0;
    pv_core(blk, kvh, pos, psl, osl);
    if (!core_ok) return;
    uart_puts("PVCHK "); uart_puthex(core_chk);
    uart_puts(" N "); uart_putdec((long)core_n);
    uart_puts(" P "); uart_putdec((long)core_p);
    uart_puts("\nOK PV\n");
}"""),
]

#  core_ok and friends must exist before the first core sets them, and the
#  first of these is stage 3. This anchor is stage 1's, which is earlier
#  than all of them.
DEFS_ANCHOR = "static int nq_mx, nq_xs, nq_amx;"
