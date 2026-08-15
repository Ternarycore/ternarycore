# Recovering the board after power loss

`bash tools/regress.sh` is the gate and it only means something if the
board is actually loaded. Four steps, about ninety seconds:

```
cd ~/hwsw/tcore/tc-arty
~/Applications/2025.2/Vivado/bin/xsdb Arty7/program.tcl \
    arty_ddr/arty_ddr.runs/impl_1/arty_ddr_wrapper.bit firmware/ddr_host.elf
~/tc-train/bin/python3-netraw tools/eth_load.py --image ~/tc-ddr/weights.bin
~/tc-train/bin/python3-netraw tools/eth_load.py --image ~/tc-ddr/meta.bin --at 0x07000000
~/tc-train/bin/python tools/ddr_audit.py --meta
```

Then `bash tools/regress.sh`, which should end `ALL PASS`.

## The step that is easy to miss

**The meta load is not optional and used to look like it was.**

`tools/build_ddr_meta.py` writes `~/tc-ddr/meta.bin` and does not upload
it. Its readback reads back the file it just wrote, so it passes whatever
the board contains. DDR keeps its contents across FPGA reprogramming, so
for as long as the 3.3 V rail stays up, meta written days ago is still
sitting at `0x07000000` and the audit passes without anyone loading it.

The Arty is USB-powered from fort. A reboot keeps the rail up; a power cut
does not. So the failure only appears after a genuine blackout, and its
signature is unmistakable — **all 420 weight pages pass and all 28 meta
records fail**, which is what a region nobody writes looks like.

## Reading the audit

| symptom | cause |
|---|---|
| pages fail, meta passes | weight image not loaded, or loaded to the wrong offset |
| pages pass, meta fails | `meta.bin` never uploaded — the case above |
| both fail | FPGA not programmed, or the ELF is not running |
| scattered single pages fail | a real corruption; reload and audit again before believing it |

`tools/ddr_audit.py` compares the board against the files on disk with the
same weighted checksum the firmware computes, so it catches ordering
errors a plain byte sum would miss.

## After the audit passes

The FPGA configuration goes with the power too, so the token timing is
worth re-checking: `python tools/tokrep.py --pos 0 --n 5` should read
**2832 ms** with a spread well under a millisecond. A different number
means a different bitstream, not a different mood.

## Training runs

They are separate from the board and resume independently:

```
cd ~/hwsw/tcore/tc-arty && PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
  ~/tc-train/bin/python tools/warmup.py --seq 512 --micro 2 --accum 16 \
  --tokens 2e8 --eval-every 250 --evaln 100 --out ~/tc-run/warmup --resume
```

`warmup.py` and `sft_teacher.py` both checkpoint on SIGTERM, so a clean
shutdown on the UPS signal loses nothing. A hard cut loses back to the
last eval, which is 250 steps.

**Write logs under `~/tc-run/logs`, not `/tmp`.** `/tmp` is cleared on
boot, which is precisely when you want the log of what happened.

SPDX-License-Identifier: CERN-OHL-S-2.0
