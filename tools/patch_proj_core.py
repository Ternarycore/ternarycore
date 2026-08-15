#!/usr/bin/env python3
"""patch_proj_core.py -- split cmd_proj into a callable core and a command.

Same move as nq_core, for the same reason: the block driver issues
fifteen projections per block and cannot afford a UART round trip per
page. And PJO needs one thing cmd_proj does not have -- an activation
offset.

o_proj reads 2048 inputs and down_proj 3072, so both run in 1024-deep
segments. The activations for segment s live at s*1024 in the slot nq
already wrote; the host has been reading them back and sending exactly
those bytes down again. proj_core takes a pointer, so the offset is the
caller's business and cmd_proj keeps passing zero.

Copied unchanged, including `o[j] = seg ? (o[j] + v) : v` -- segment 0
writes and later segments accumulate, which is the whole reason a
multi-segment projection works at all. This is a refactor. stage2_check
exercises PROJ and has to give identical answers afterwards.

  python tools/patch_proj_core.py
"""
import os
import sys

p = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fw_exec.py")
s = open(p).read()

if "proj_core" in s:
    sys.exit("already patched")

OLD = '''static void cmd_proj(const char *p) {
    unsigned long asrc = parse_u(&p), dst = parse_u(&p), ntile = parse_u(&p),
                  seg = parse_u(&p), j;
    const signed char *a = (const signed char *)VSLOT(asrc);
    int *o = (int *)VSLOT(dst);
    unsigned long k;
    unsigned int ct;
    int c, v;
    unsigned long chk = 0;

    if (ntile == 0u || ntile > 16u) { uart_puts("ERR range\\n"); return; }

    IO32(STREAM_BASE + S_CTRL) = 0x4u;               /* act ptr reset */
    for (k = 0; k < DEPTH; k++)
        IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)a[k];

    for (ct = 0; ct < (unsigned int)ntile; ct++) {
        stream_tile(ct);
        for (c = 0; c < 64; c++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
            v = (int)IO32(STREAM_BASE + S_RDATA);
            j = (unsigned long)ct * 64u + (unsigned long)c;
            o[j] = seg ? (o[j] + v) : v;
        }
    }
    for (j = 0; j < ntile * 64u; j++)
        chk += (unsigned long)o[j] * (unsigned long)(j + 1u);
    uart_puts("PCHK "); uart_puthex(chk);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\\nOK PJ\\n");
}'''

NEW = '''/* The activations are a pointer, not a slot index, so the caller can
   start a segment part-way into a vector. cmd_proj passes offset zero
   and behaves exactly as before. */
static void proj_core(const signed char *a, int *o,
                      unsigned long ntile, unsigned long seg) {
    unsigned long k, j;
    unsigned int ct;
    int c, v;

    IO32(STREAM_BASE + S_CTRL) = 0x4u;               /* act ptr reset */
    for (k = 0; k < DEPTH; k++)
        IO32(STREAM_BASE + S_ACTWR) = (unsigned int)(unsigned char)a[k];

    for (ct = 0; ct < (unsigned int)ntile; ct++) {
        stream_tile(ct);
        for (c = 0; c < 64; c++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
            v = (int)IO32(STREAM_BASE + S_RDATA);
            j = (unsigned long)ct * 64u + (unsigned long)c;
            o[j] = seg ? (o[j] + v) : v;
        }
    }
}

static void cmd_proj(const char *p) {
    unsigned long asrc = parse_u(&p), dst = parse_u(&p), ntile = parse_u(&p),
                  seg = parse_u(&p), j;
    const int *o;
    unsigned long chk = 0;

    if (ntile == 0u || ntile > 16u) { uart_puts("ERR range\\n"); return; }

    proj_core((const signed char *)VSLOT(asrc), (int *)VSLOT(dst),
              ntile, seg);

    o = (const int *)VSLOT(dst);
    for (j = 0; j < ntile * 64u; j++)
        chk += (unsigned long)o[j] * (unsigned long)(j + 1u);
    uart_puts("PCHK "); uart_puthex(chk);
    uart_puts(" CYC "); uart_putdec((long)IO32(STREAM_BASE + S_CYC));
    uart_puts("\\nOK PJ\\n");
}'''

if OLD not in s:
    sys.exit("anchor missing: cmd_proj is not the text this patch expects")
open(p, "w").write(s.replace(OLD, NEW, 1))
print("fw_exec.py: proj_core extracted, cmd_proj is now a wrapper")
