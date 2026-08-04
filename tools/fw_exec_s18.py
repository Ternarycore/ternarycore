"""Block executor stage 18: the QK-norm checksum becomes optional.

qkn_core ends by walking its own output and accumulating a
position-weighted checksum. That exists for the host: QKN is a command,
block_multi.py compares QCHK against a NumPy reference, and it is how the
operator was verified in the first place.

The block driver has no use for it. It calls qkn_core three times a block
-- q at 16 heads, k and v at 8 -- so 4096 elements per block, 114,688 per
token, each a 64-bit multiply and add on a 32-bit soft CPU, and then
throws the answer away. Grading the fused budget against the machine is
what made it visible: 246 ms of a token at position 0 is driver
bookkeeping that no operator row covers, and this is the largest single
piece of it that can simply stop happening.

The loop is guarded, not deleted, and the reason is weaker than it first
looked. Grep says nothing in the host tools compares QCHK -- so this is
not an automated check that deleting the loop would break. It is a
diagnostic a human reads when an operator misbehaves, on a path that is
host-driven and slow anyway. Keeping it there costs nothing that matters
and taking it out of the driver costs nothing at all, so it stays and
gets a guard. cmd_qkn clears core_quiet, so every host-driven QKN still
reports; qkn_run sets it, so the driver does not.

That asymmetry has to be explicit in both places. If cmd_qkn only relied
on core_quiet starting at zero, then the first QKN after any BLK would
report a checksum of zero and block_multi would fail with a number that
looks like an arithmetic bug. regress.sh runs blk_check before
block_multi, so it exercises exactly that order.

What it is worth, A/B on the same board with the same input, previous ELF
against this one, tools/tokrep.py at 15 and 8 runs:

    position    0    2879.6 ms -> 2863.5 ms    -16.1 ms
    position  511    4655.4 ms -> 4639.9 ms    -15.5 ms

Position-independent, as it should be -- the checksum walks the operator's
output and does not care how long the context is. 114,688 elements a
token at about 14 cycles each.

Two claims made before this was measured were wrong, and both were mine.

It is not "nearly free": 16 ms is 0.56% of a token, not a large piece of
the 246 ms of driver bookkeeping the graded budget exposed. Most of that
246 ms is still the residual adds' 64-bit multiply per element and the
sixteen attention heads brought onto a common exponent.

And it does not buy LMB, it costs it. A guard is a branch, not a
deletion: 64,292 bytes to 64,332, so 1,204 free rather than 1,244. The
space has to come from somewhere else.

Worth keeping anyway -- it is permanent, it is measured, and it is
correct. But the number is 16 ms.

Escaping caution: raw strings that become C.
"""

DECL_OLD = "static unsigned long core_chk, core_n, core_p;"
DECL_NEW = """/* Set by a caller that will not read core_chk, so the cores can skip
   computing it. The driver sets it; every command handler clears it. */
static int core_quiet;
static unsigned long core_chk, core_n, core_p;"""

#  qkn_core's tail. chk is initialised at its declaration, so a skipped
#  loop reports zero rather than garbage.
CHK_OLD = """    for (i = 0; i < nh * hd; i++)
        chk += (unsigned long)(long)o8[i] * (unsigned long)(i + 1u);
    core_chk = chk; core_ok = 1;"""
CHK_NEW = """    if (!core_quiet)
        for (i = 0; i < nh * hd; i++)
            chk += (unsigned long)(long)o8[i] * (unsigned long)(i + 1u);
    core_chk = chk; core_ok = 1;"""

#  The host asked, so the host gets a real number.
CMD_OLD = """    core_ok = 0;
    qkn_core(src, gsl, cs, dst, ssl, nh, hd);"""
CMD_NEW = """    core_ok = 0; core_quiet = 0;
    qkn_core(src, gsl, cs, dst, ssl, nh, hd);"""

#  The driver did not.
RUN_OLD = """    qkn_norm = norm;
    qkn_am = am; qkn_ae = ae;"""
RUN_NEW = """    qkn_norm = norm;
    qkn_am = am; qkn_ae = ae;
    core_quiet = 1;"""

EDITS = [(DECL_OLD, DECL_NEW), (CHK_OLD, CHK_NEW),
         (CMD_OLD, CMD_NEW), (RUN_OLD, RUN_NEW)]
