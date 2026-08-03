"""One-shot patcher: give stage_check.py a raw read-back and a diff.

The bridge to the board caps shell commands well below the size of this
edit, so it lands as a file rather than as an unreadable one-liner.
Idempotent; safe to run twice.
"""
p = "tools/stage_check.py"
s = open(p).read()

dumpr = '''    def dumpr(self, slot, n):
        """Whole vector, raw. The payload can hold any byte including
        newline, so count bytes rather than read lines."""
        self.send(f"DUMPR {slot} {n}\\n")
        hdr = b""
        while not hdr.endswith(b"\\n"):
            d = os.read(self.fd, 1)
            if d:
                hdr += d
        buf = b""
        while len(buf) < n:
            d = os.read(self.fd, n - len(buf))
            if d:
                buf += d
        self.until("OK DR")
        return np.frombuffer(buf, dtype=np.int8)

    def dumpb(self, slot, n):'''

if "def dumpr" not in s:
    assert "    def dumpb(self, slot, n):" in s
    s = s.replace("    def dumpb(self, slot, n):", dumpr, 1)

diff = '''    got = b.dumpr(2, n)
    d = got.astype(int) - want.astype(int)
    nz = int(np.count_nonzero(d))
    print(f"    diff: {nz}/{n} differ, max |d| {int(np.abs(d).max())}, "
          f"mean {d.mean():+.4f}")
    ok_chk = got_chk == bchk(want)'''

if "differ, max |d|" not in s:
    assert "    ok_chk = got_chk == bchk(want)" in s
    s = s.replace("    ok_chk = got_chk == bchk(want)", diff, 1)

open(p, "w").write(s)
print("patched" if "def dumpr" in s else "MISS")
