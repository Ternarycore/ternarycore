# GVSoC device model

This directory contains a C++17 GVSoC plugin for the four-column
TernaryCore pipeline and a dependency-free host model used by its tests.

```bash
make test                    # strict standalone build and test
python3 test_system.py       # independent Python reference vectors
make plugin GVSOC_PATH=...   # build libternarycore_device.so
make install GVSOC_PATH=...  # install into the GVSoC model directory
```

`ternarycore_model.hpp` is the single source of truth for quantization,
reserved-weight decoding, accumulation, and Q15 scaling. The plugin and host
test both call it, which prevents their arithmetic from drifting apart.

The register map is documented in `ternarycore_device.hpp`. Computation is
synchronous: a valid CTRL start completes before the write returns and leaves
STATUS.DONE set. Starts with `VECTOR_LEN=0` are rejected. The INV register keeps
its low 22 bits, matching the RTL port. The model does not expose an interrupt
line; software should poll STATUS.DONE.

`test_system.py` also emits PULP firmware with
`--create-firmware-source DIR`. It does not create a universal GVSoC platform;
system integration requires an existing target that maps the plugin at
`0x1A100000`:

```bash
python3 test_system.py --firmware app.elf --target YOUR_GVSOC_TARGET
```
