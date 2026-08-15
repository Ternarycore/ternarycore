"""Block executor stage 17: DSUM, checking the image where it lives.

eth_load verifies every transfer as it writes it, with a checksum the
firmware computes on the way in. That is a check on the wire. It says the
bytes arrived; it says nothing about what is in memory an hour later, or
after a partial reload, or after a tool wrote to the wrong offset.

Nothing in this project has ever verified the resident image. A page that
held its neighbour's bytes survived here for months because of it, and it
was invisible for a specific reason worth remembering: q_proj's first
output block is the only page in the image that no test ever read, since
the block driver computed q and threw it away. The audit that would have
caught it in one second did not exist.

DSUM is that audit. It is the same weighted sum eth_load already
reproduces in Python, computed over DDR rather than over the wire, so the
host can compare a resident page against the file byte for byte at 420
pages in a few seconds.

The weighting is not decoration and must not be simplified. A plain byte
sum is order-blind, and one once reported a perfect match on a page whose
weights had been scrambled -- which is in article 05 as one of the three
silent failures. Every word is multiplied by its own address.

Escaping caution: raw string, becomes C, \n stays \n.
"""

EXEC17 = r"""
/* ---- Stage 17: DSUM, the resident image's own checksum ---------------

   sum += w * ((addr >> 2) + 1) over 32-bit words, truncated to 32 bits
   at every step -- identical to fw_checksum in eth_load.py, and it has
   to stay identical or the comparison means nothing. */
static void cmd_dsum(const char *p) {
    unsigned long off = parse_u(&p), len = parse_u(&p), i;
    unsigned int sum = 0u, idx;

    if ((off | len) & 3u) { uart_puts("ERR align\n"); return; }
    if (len == 0u || off + len > 224u * 1024u * 1024u) {
        uart_puts("ERR range\n"); return;
    }
    idx = (unsigned int)(off >> 2) + 1u;
    for (i = 0; i < len; i += 4u)
        sum += IO32(DDR_BASE + off + i) * idx++;

    uart_puts("DSUM "); uart_puthex(sum); uart_puts("\nOK DS\n");
}
"""

ANCHOR = "int main(void) {"

CMD_OLD = '        else if (starts(line, "POS ")) cmd_pos(line + 4);'
CMD_NEW = CMD_OLD + '\n        else if (starts(line, "DSUM ")) cmd_dsum(line + 5);'
