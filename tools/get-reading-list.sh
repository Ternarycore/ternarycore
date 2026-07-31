#!/bin/bash
# TernaryCore reading list fetcher — downloads all free/official PDFs into a
# folder. Usage:  bash get-reading-list.sh [destination]   (default below)
DEST="${1:-$HOME/ternarycore/reading-list}"
mkdir -p "$DEST/papers" "$DEST/books" "$DEST/related-work"
ok=0; fail=0
get () { # get <url> <outfile>
  if curl -sSLf --retry 2 -o "$2" "$1"; then
    echo "  ok   $(basename "$2")  ($(du -h "$2" | cut -f1))"; ok=$((ok+1))
  else
    echo "  FAIL $(basename "$2")  <- $1"; fail=$((fail+1)); rm -f "$2"
  fi
}

echo "== Papers (arXiv) =="
get https://arxiv.org/pdf/1706.03762 "$DEST/papers/attention-is-all-you-need.pdf"
get https://arxiv.org/pdf/2310.11453 "$DEST/papers/bitnet-1bit-transformers.pdf"
get https://arxiv.org/pdf/2402.17764 "$DEST/papers/bitnet-b1.58-ternary.pdf"
get https://arxiv.org/pdf/2504.12285 "$DEST/papers/bitnet-2b4t-tech-report.pdf"
get https://arxiv.org/pdf/2510.13998 "$DEST/papers/bitnet-distillation.pdf"
get https://arxiv.org/pdf/2103.13630 "$DEST/papers/quantization-survey-gholami.pdf"

echo "== Books (official free PDFs) =="
get https://d2l.ai/d2l-en.pdf "$DEST/books/dive-into-deep-learning.pdf"
# Understanding Deep Learning (Prince) — if this version 404s, grab the
# current link from https://udlbook.github.io/udlbook/
get "https://github.com/udlbook/udlbook/releases/download/v.5.0.0/UnderstandingDeepLearning_24_11_23_C.pdf" \
    "$DEST/books/understanding-deep-learning.pdf" || true
# The Zynq Book — official free ebook; if it 404s, use www.zynqbook.com
get "http://www.zynqbook.com/Zynq_Book_ebook.pdf" "$DEST/books/the-zynq-book.pdf" || true

echo "== Related work (arXiv, for the P1 citation pass) =="
get https://arxiv.org/pdf/1612.07119 "$DEST/related-work/finn-bnn-fpga.pdf"
get https://arxiv.org/pdf/1603.05279 "$DEST/related-work/xnor-net.pdf"
get https://arxiv.org/pdf/1605.04711 "$DEST/related-work/ternary-weight-networks.pdf"
get https://arxiv.org/pdf/1612.01064 "$DEST/related-work/trained-ternary-quantization.pdf"
get https://arxiv.org/pdf/1804.06913 "$DEST/related-work/hls4ml.pdf"

echo
echo "Done: $ok downloaded, $fail failed -> $DEST"
echo "Not auto-downloadable (visit manually):"
echo "  Parhami slide sets: https://web.ece.ucsb.edu/~parhami/text_comp_arit.htm"
echo "  Knuth TAOCP v2 / Harris&Harris / Hennessy&Patterson: openlibrary.org lending"
