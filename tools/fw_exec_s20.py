"""Block executor stage 20: read the results without addressing them.

axi_gemm_stream's RDATA port now advances RIDX on a read, so a caller can
set the index once and read the whole pass. Until this stage nothing did:
every result loop still wrote the index first, so the RTL change was live
and worth nothing.

tools/pph.py priced it. A projection spends 320.4 us of 827 reading
results back, and reading them without the index writes is 213.9 -- 106.5
us a call, 12.9% of a projection. Four loops do this, and two of them are
the attention path, so the same saving lands on Q.K^T and P.V.

The write stays, once per pass rather than once per column. It is not
needed -- RIDX is six bits and COLS is 64, so it wraps exactly and a
caller could read forever -- but a pass that begins by saying where it
starts is a pass that cannot be desynchronised by anything that touched
the index in between, and one write in sixty-four is not worth the
argument.

The diagnostic loop in cmd_gemm is deliberately left alone. It runs once
per host command, it prints, and it is the last thing in the firmware
that still demonstrates the old two-access idiom.

Escaping caution: raw strings that become C.
"""

#  Each anchor is a whole loop head, which is what makes them unique --
#  the S_RIDX line on its own appears six times.
EDITS = [
    # ---- proj_core: the seven projections -----------------------------
    (r"""        stream_tile(ct);
        for (c = 0; c < 64; c++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
            v = (int)IO32(STREAM_BASE + S_RDATA);""",
     r"""        stream_tile(ct);
        IO32(STREAM_BASE + S_RIDX) = 0u;   /* reads walk it from here */
        for (c = 0; c < 64; c++) {
            v = (int)IO32(STREAM_BASE + S_RDATA);"""),

    # ---- the tier-1 accelerator path ----------------------------------
    (r"""        stream_tile(ct);
        for (c = 0; c < 64; c++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)c;
            accel_out[(int)ct*64 + c] = (long)(int)IO32(STREAM_BASE + S_RDATA);""",
     r"""        stream_tile(ct);
        IO32(STREAM_BASE + S_RIDX) = 0u;
        for (c = 0; c < 64; c++) {
            accel_out[(int)ct*64 + c] = (long)(int)IO32(STREAM_BASE + S_RDATA);"""),

    # ---- Q.K^T --------------------------------------------------------
    (r"""        for (i = 0; i < 64u; i++) {
            IO32(STREAM_BASE + S_RIDX) = (unsigned int)i;
            o[c * 64u + i] = (int)IO32(STREAM_BASE + S_RDATA);""",
     r"""        IO32(STREAM_BASE + S_RIDX) = 0u;
        for (i = 0; i < 64u; i++) {
            o[c * 64u + i] = (int)IO32(STREAM_BASE + S_RDATA);"""),

    # ---- P.V ----------------------------------------------------------
    (r"""            for (i = 0; i < 64u; i++) {
                IO32(STREAM_BASE + S_RIDX) = (unsigned int)i;
                o[dch * 64u + i] += (int)IO32(STREAM_BASE + S_RDATA);""",
     r"""            IO32(STREAM_BASE + S_RIDX) = 0u;
            for (i = 0; i < 64u; i++) {
                o[dch * 64u + i] += (int)IO32(STREAM_BASE + S_RDATA);"""),
]
