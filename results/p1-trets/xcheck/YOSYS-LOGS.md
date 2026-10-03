# Yosys logs for the 2026-10-01 xcheck bundle

The three `*.yosys.log` files in that bundle are zero bytes. The runs used
`yosys -q ... > file.log`, and `-q` suppresses everything that would have gone
to stdout. That is our mistake, not a lost file.

These logs come from re-running the same commands on 2026-10-02 with `-l <log>`
instead of `-q`. Same Yosys build, 0.67+post (git sha1 b8e7da6f40ae8f552c116bf6c359b07c6533e159),
same working directories, same relative source paths. The only difference is
where the outputs were written, which shows as absolute paths in line 9 of each log.

The re-run reproduces the shipped netlists byte for byte. These hashes match
`INPUTS.sha256` in the bundle:

    0789f62313d5ea72b0ce115ce0d039d6dd2427d8cd1bec774207e8eb3fa9b445  ternary.json            (debug/arty7 @ 25358a24, ternary_dot_nodebug.v)
    cc7a83f0c658848048c7330e71bc294b3d4bf22330868b6070f902f103b003af  int8.json               (debug/arty7 @ 25358a24, int8_dot.v)
    51d3423b958f053ef6d3a2cfd1f04e98fd3e05ff2daaf649555223f60b8af233  tag-rtl/ternary_tag.json (v1.0.1-trets rtl/ + xcheck_top.v)

The `.stat` files here are byte-identical to the ones in the bundle.

| log in this zip | replaces bundle file |
|---|---|
| ternary.yosys.log     | xcheck/ternary.yosys.log |
| int8.yosys.log        | xcheck/int8.yosys.log |
| ternary_tag.yosys.log | xcheck/tag-rtl/yosys.log |
