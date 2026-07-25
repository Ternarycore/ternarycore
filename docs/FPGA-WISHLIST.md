# TernaryCore FPGA Wishlist

> Three application areas, budget options in each, one pick per category.
> Prices are approximate street/list as of July 2026 — verify before ordering.
> Context: Tier 1 (CPU vs ternary A/B) is proven on the Arty A7-100T at 3.67×
> with the array ~3% utilized; the constraint everywhere below is **memory
> bandwidth and I/O, not LUTs**. See [HOST_STREAMING.md](HOST_STREAMING.md)
> for the bandwidth math.

---

## Category 1 — BitNet inference (prove a real model)

Single-token inference reads every weight once per token → tokens/sec is
capped by memory bandwidth, not by how many ternary columns fit.

| Board | ~Price | Memory / BW | Host path | Realistic ternary target | Notes |
|---|---|---|---|---|---|
| Arty A7-100T *(owned)* | — | 256 MB DDR3, ~1 GB/s | UART/JTAG (Ethernet possible) | ≤700M-param models @ ~5–7 tok/s ceiling; layer benchmarks | Stays the clean with/without-ternary proof machine |
| PYNQ-Z2 / Arty Z7-20 (Zynq-7020) | ~$150–230 | 512 MB DDR3 shared, ~1 GB/s | **hard ARM + Linux** — streaming problem disappears | same ceiling as Arty, but working model in days | Cheapest path to "model runs" |
| Kria KV260 (Zynq US+) | ~$250–300 | 4 GB DDR4, >10 GB/s | quad A53 + Linux | 2B-4T fits; tens of tok/s | Best perf/$ jump |
| ZCU104-class (Zynq US+ EV) | ~$1,300–1,800 | 2 GB DDR4 + PL DDR | ARM + Linux | similar to KV260, more fabric | Only if a specific IP needs it |
| **Alveo U50** ⭐ | new ~$2,600–3,000 list; used ~$600–1,200 | **8 GB HBM2 @ ~316 GB/s** | PCIe Gen3 x16 host | **2B-4T @ 100+ tok/s theoretical** — the "beats a desktop CPU" tier | Already named in the budget & monthly report; used-market prices make it reachable |

**Pick: Alveo U50.** It is the only option where a 2B-parameter BitNet fits
*with bandwidth headroom* — 316 GB/s of HBM2 vs the ~1 GB/s that caps every
DDR3 board at single-digit tok/s. PCIe means the host feeds it directly (no
UART bridge, no soft-CPU chaperoning). Fort Silicon has the free PCIe slot
and the airflow problem is already solved in the budget (3D-printed shroud).
*Bootstrap alternate if the U50 waits: Kria KV260.*

---

## Category 2 — SDR / ternary radio (bladeRF track)

The angle: ternary-quantized DSP — FIR filters, decimators, correlators with
{−1, 0, +1} coefficients are **multiplier-free**, exactly like the GEMM. A
ternary matched filter or channelizer in fabric next to the radio, plus the
PQC work (Kyber accelerator) securing the link, is a story no other SDR
project is telling.

| Board | ~Price | FPGA (user fabric) | RF | Notes |
|---|---|---|---|---|
| RTL-SDR v4 | ~$40 | none | RX only, 0.5–1.7 GHz | Antenna-up validation only; no ternary story |
| ADALM-Pluto | ~$230–260 | Zynq-7010 (small but real PL) | AD9363, 325 MHz–3.8 GHz, 1×1 | Budget pick: same AD936x family, ARM + fabric, huge community |
| LimeSDR Mini 2.0 | ~$400 | ECP5-85F (open toolchain!) | LMS7002M, 10 MHz–3.5 GHz | Open-source flow end to end; smaller RF range |
| **bladeRF 2.0 micro xA9** ⭐ | ~$680–780 | **Cyclone V 301 KLE** — by far the most user fabric in class | AD9361, 47 MHz–6 GHz, 2×2 MIMO, USB 3.0 | Room for ternary channelizer + PicoRV32 + Kyber core *simultaneously* |

**Pick: bladeRF 2.0 micro xA9.** The 301 KLE Cyclone V is the whole point —
enough fabric to hold a ternary DSP chain, a soft core, and the PQC
accelerator at once, with 2×2 MIMO and 6 GHz reach for real experiments
(ADS-B, LoRa, amateur bands, encrypted links). *Bootstrap alternate:
ADALM-Pluto — same AD936x RF family, so DSP work ports up later.*

---

## Category 3 — Upscaling display target (retro-upscaler track)

Current dev board is the Tang Nano 20K (720p60 proven, 1080p is its
ceiling). The product question is how far up the resolution ladder the
ternary conv pipeline should aim.

| Board (FPGA) | ~Board price | FPGA-direct (bit-bang TMDS) | + external HDMI PHY / native SERDES | DP? | 8K? |
|---|---|---|---|---|---|
| Tang Nano 9K (GW1NR-9) | ~$15–20 | 720p60 | ~1080p (fabric-limited) | no | no |
| Tang Nano 20K (GW2AR-18) *(owned)* | ~$30–40 | 1080p30 (60 = I/O ceiling) | ~1080p60 | no | no |
| Arty A7-100T (Artix-7) *(owned)* | ~$130–480 | 1080p60 (edge) | 4K30 (HDMI TX IC) | no | no |
| ULX3S (ECP5-85F) | ~$115–155 | 1080p60 (~1440p RB) | 4K30 (HDMI TX IC) | no | no |
| Efinix Ti60 | ~$375 kit (chip ~$37) | 1080p60 | 4K30–4K60 (HDMI TX IC) | no | no |
| Efinix Ti180 | ~$700–825 (chip ~$119) | 1440p / 4K30 | 4K60 (HDMI TX IC) | no | no |
| **Lattice CertusPro-NX** ⭐ | ~$300–500 eval (chip ~$130–190) | 4K60 (**native SERDES**) | native — no PHY | DP HBR3 | 8K + VESA DSC |
| Zynq UltraScale+ | ~$1,300–3,000 | 4K60 (native GTH) | native — no PHY | native DP | 8K30/60 + DSC |
| Versal / US+ GTY / Agilex | ~$3,000–10,000+ | 8K60 (native GTY) | native — no PHY | DP2.1 UHBR20 | 8K uncompressed |

**Pick: Lattice CertusPro-NX eval.** It is the knee of the curve: native
SERDES does 4K60 with **no external PHY**, DisplayPort HBR3, and an 8K path
via DSC — at eval-board money, with a chip price (~$130–190) that survives
into a real product BOM. Everything above it costs 3–10× for headroom the
retro/FPV market doesn't need; everything below it needs an external HDMI TX
IC to leave 1080p. The Tang Nano 20K stays the $30 demo/dev board — that
price point *is* its feature. *Bootstrap alternate: ULX3S — fully open
toolchain, 1080p60 today, community distribution built in.*

---

## The one-from-each summary

| Category | Pick | ~Cost | Bootstrap alternate | ~Cost |
|---|---|---|---|---|
| BitNet inference | **Alveo U50** (used) | $600–1,200 | Kria KV260 | $250–300 |
| Ternary SDR | **bladeRF 2.0 micro xA9** | $680–780 | ADALM-Pluto | $230–260 |
| Upscaling target | **CertusPro-NX eval** | $300–500 | ULX3S | $115–155 |
| **Total** | | **~$1,600–2,500** | | **~$600–715** |

Sequencing note: the U50 unblocks the flagship claim (real BitNet model,
100+ tok/s territory) and is already narratively committed in the monthly
report — it goes first. The bladeRF opens an entirely new content/product
lane (ternary DSP + PQC radio) — second. The CertusPro-NX only matters once
the 20K pipeline has learned weights worth showing at 4K — third.
