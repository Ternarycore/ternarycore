"""Stage 21: the block driver at the distilled student's shape.

Everything before this stage runs the SST-2 student: 28 blocks of
L28 H1024 I3072 with 16 query heads over 8 kv heads. D2 pruned that to
I2048 and 8 query heads -- width only, no depth -- and D4 distilled it
into a summarizer. The image is already packed: 280 pages, 73.4 MB,
against the resident 420 and 110.1.

Five things move, and only five, because blk_proj already derives its
slice and segment counts from its arguments:

    unsigned long nc = nout >> 10, ns = nin >> 10, c, s;

so the inner loop was never shape-specific. The shape lives in the seven
call sites as literals, in the page rule, and in three tables.

**Page geometry.** Fifteen pages a block becomes ten: q, k, v and o are
one each now that q_proj has 1024 outputs and o_proj 1024 inputs, and
gate, up and down are two each at I2048. The rule page = blk*15 + slot
becomes blk*10 + slot, and the slot offsets close up behind it.

**Query heads, sixteen to eight.** The interesting one. qk_core, sm_core
and pv_core were called with h >> 1, because two query heads shared each
kv head. D2 kept exactly one query head per kv pair -- which is why the
audit could say k_proj and v_proj transfer verbatim -- so the mapping is
now the identity and h >> 1 becomes h. Get this wrong and every head
reads the wrong cache, quietly, and the model is confidently wrong rather
than broken.

**The gain table, which is written twice.** gain_len and gain_off mirror
build_ddr_meta.py, and the comment above them in the C says so: one
layout written twice, in different languages, and MREAD exists to prove
they still agree. o_proj.subln was 2048 wide only because o_proj read
2048, and down_proj.subln 3072 for the same reason; both shrink, and
every offset after o_proj.subln moves down by 4096 bytes.

The widths that follow -- the attention output 2048 -> 1024 and the MLP
product 3072 -> 2048 -- are mechanical. The scratch slots are 16 KB each
and every vector gets smaller, so nothing needs relocating.

Anchors are deliberately long. Four different loops in this file read
`for (h = 0; h < 16u; h++)` and a single-line anchor would replace
whichever came first.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""

#  (description, old, new). Applied in order, each asserted present and
#  unique before it is replaced -- a stale anchor fails the build rather
#  than shipping an ELF that is wrong in one projection.
EDITS = [

    ("page rule blk*15 -> blk*10",
     "            if (!page_load(blk * 15u + slot0 + c * ns + s)) return 0;",
     "            if (!page_load(blk * 10u + slot0 + c * ns + s)) return 0;"),

    ("slot offsets for ten pages a block",
     "#define P_Q    0u\n"
     "#define P_K    2u\n"
     "#define P_V    3u\n"
     "#define P_O    4u\n"
     "#define P_G    6u\n"
     "#define P_U    9u\n"
     "#define P_D   12u",
     "#define P_Q    0u\n"
     "#define P_K    1u\n"
     "#define P_V    2u\n"
     "#define P_O    3u\n"
     "#define P_G    4u\n"
     "#define P_U    6u\n"
     "#define P_D    8u"),

    ("q_proj 2048 -> 1024 outputs, and its eight per-head scales",
     "    if (!blk_proj(blk, P_Q, 2048u, 1024u, a8, p0)) return 0;\n"
     "    qkn_run(blk, 2u, S_P0, S_Q8, 16u, 1, 0u, 0);\n"
     "    for (h = 0; h < 16u; h++) {\n"
     "        qs[h * 2u]      = (int)qkn_sm[h];",
     "    if (!blk_proj(blk, P_Q, 1024u, 1024u, a8, p0)) return 0;\n"
     "    qkn_run(blk, 2u, S_P0, S_Q8, 8u, 1, 0u, 0);\n"
     "    for (h = 0; h < 8u; h++) {\n"
     "        qs[h * 2u]      = (int)qkn_sm[h];"),

    ("attention output 2048 -> 1024, o_proj reads 1024",
     "    if (!nq_run(fab, att, blk, 4u, a8, 2048u)) return 0;\n"
     "    nq_scale(blk, 4u, 2048u, &sa, &ea);\n"
     "    if (!blk_proj(blk, P_O, 1024u, 2048u, a8, p0)) return 0;",
     "    if (!nq_run(fab, att, blk, 4u, a8, 1024u)) return 0;\n"
     "    nq_scale(blk, 4u, 1024u, &sa, &ea);\n"
     "    if (!blk_proj(blk, P_O, 1024u, 1024u, a8, p0)) return 0;"),

    ("gate and up 3072 -> 2048 outputs, and the product",
     "    if (!blk_proj(blk, P_G, 3072u, 1024u, a8, p0)) return 0;\n"
     "    if (!blk_proj(blk, P_U, 3072u, 1024u, a8, p1)) return 0;",
     "    if (!blk_proj(blk, P_G, 2048u, 1024u, a8, p0)) return 0;\n"
     "    if (!blk_proj(blk, P_U, 2048u, 1024u, a8, p1)) return 0;"),

    ("mlp_core width 3072 -> 2048",
     "    mlp_core(p0, p1, m, tm, (long)te + 512, 3072u);",
     "    mlp_core(p0, p1, m, tm, (long)te + 512, 2048u);"),

    ("down_proj reads 2048",
     "    if (!nq_run(fab, m, blk, 5u, a8, 3072u)) return 0;\n"
     "    nq_scale(blk, 5u, 3072u, &sa, &ea);\n"
     "    if (!blk_proj(blk, P_D, 1024u, 3072u, a8, p0)) return 0;",
     "    if (!nq_run(fab, m, blk, 5u, a8, 2048u)) return 0;\n"
     "    nq_scale(blk, 5u, 2048u, &sa, &ea);\n"
     "    if (!blk_proj(blk, P_D, 1024u, 2048u, a8, p0)) return 0;"),

    ("gain widths: o_proj.subln 2048 -> 1024, down_proj.subln 3072 -> 2048",
     "static const unsigned int gain_off[6] =\n"
     "    { 0x0000u, 0x1000u, 0x2000u, 0x2200u, 0x2400u, 0x4400u };\n"
     "static const unsigned int gain_len[6] =\n"
     "    { 1024u, 1024u, 128u, 128u, 2048u, 3072u };",
     "static const unsigned int gain_off[6] =\n"
     "    { 0x0000u, 0x1000u, 0x2000u, 0x2200u, 0x2400u, 0x3400u };\n"
     "static const unsigned int gain_len[6] =\n"
     "    { 1024u, 1024u, 128u, 128u, 1024u, 2048u };"),

    ("attention: eight query heads, one per kv head, so h >> 1 becomes h",
     "    for (h = 0; h < 16u; h++) {\n"
     "        for (i = 0; i < 128u; i++) qh[i] = q8[(h << 7) + i];\n"
     "\n"
     "        core_ok = 0; qk_core(blk, h >> 1, pos, S_QH, S_DOT);",
     "    for (h = 0; h < 8u; h++) {\n"
     "        for (i = 0; i < 128u; i++) qh[i] = q8[(h << 7) + i];\n"
     "\n"
     "        core_ok = 0; qk_core(blk, h, pos, S_QH, S_DOT);"),

    ("softmax and P.V read the same kv head as their query",
     "        sm_core(blk, h >> 1, pos, S_DOT,",
     "        sm_core(blk, h, pos, S_DOT,"),

    ("P.V likewise",
     "        core_ok = 0; pv_core(blk, h >> 1, pos, S_PR, S_NUM);",
     "        core_ok = 0; pv_core(blk, h, pos, S_PR, S_NUM);"),

    ("the shared exponent pass, and the zero case it guards",
     "    /* One exponent for all sixteen. */\n"
     "    Mm = 0u; Me = 0;\n"
     "    for (h = 0; h < 16u; h++) {",
     "    /* One exponent for all eight. */\n"
     "    Mm = 0u; Me = 0;\n"
     "    for (h = 0; h < 8u; h++) {"),

    ("clearing the attention output clears 1024, not 2048",
     "        for (i = 0; i < 2048u; i++) att[i] = 0;",
     "        for (i = 0; i < 1024u; i++) att[i] = 0;"),

    ("the rescale pass",
     "    Me += 1 - 29;\n"
     "    for (h = 0; h < 16u; h++) {\n"
     "        sc_div(fm[h], fe[h], Mm, Me, &t, &te);",
     "    Me += 1 - 29;\n"
     "    for (h = 0; h < 8u; h++) {\n"
     "        sc_div(fm[h], fe[h], Mm, Me, &t, &te);"),

    ("the driver's own comment, so the file still describes itself",
     "   Page slots within a block, in the order build_ddr_image.py wrote them\n"
     "   and the order blk_proj must request them: q takes two (2048 outputs),\n"
     "   k and v one each, o two (2048 inputs), gate and up three each (3072\n"
     "   outputs), down three (3072 inputs). Fifteen, and the image's rule is\n"
     "   page = blk*15 + slot.                                              */",
     "   Page slots within a block, in the order build_ddr_image.py wrote them\n"
     "   and the order blk_proj must request them: q, k, v and o one each at\n"
     "   1024 in and out, gate and up two each (2048 outputs), down two (2048\n"
     "   inputs). Ten, and the image's rule is page = blk*10 + slot.         */"),
]


def apply(s):
    """Every edit asserted present and unique before it is made."""
    for what, old, new in EDITS:
        n = s.count(old)
        assert n == 1, f"stage 21: {what!r} matches {n} times, expected 1"
        s = s.replace(old, new, 1)
    return s
