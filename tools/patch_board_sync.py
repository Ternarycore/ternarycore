"""Give Board a reset-tolerant handshake, and use it everywhere.

Symptom: the softmax check timed out on its first LOADB, having received
the board's boot banner and a PONG *during* that wait. Cause: xsdb had not
finished releasing the core when the test opened the port, so the first
PING was swallowed by a board still resetting; the reply that matched
belonged to the previous firmware, and everything after it was lost.

LOADB on its own was fine at 16, 256 and 1024 bytes -- which ruled out the
obvious suspect and pointed here instead.

A sleep would paper over it. Retrying the handshake until the board
actually answers fixes every check script at once, and turns an
intermittent confusing failure into a bounded wait.

Idempotent; safe to run twice.
"""
p = "tools/stage_check.py"
s = open(p).read()

sync = '''    def sync(self, tries=8):
        """Handshake that tolerates a board still coming out of reset.

        xsdb can still be releasing the core when a check opens the port,
        so a single PING gets swallowed and the PONG that arrives belongs
        to the previous firmware -- after which every subsequent command
        is lost. Retry until the board genuinely answers.
        """
        for _ in range(tries):
            termios.tcflush(self.fd, termios.TCIOFLUSH)
            self.buf = b""
            self.send("PING\\n")
            try:
                self.until("PONG", timeout=3)
                return
            except TimeoutError:
                time.sleep(1)
        raise TimeoutError("board never answered PING")

    def loadv(self, slot, vec):'''

if "def sync" not in s:
    assert "    def loadv(self, slot, vec):" in s
    s = s.replace("    def loadv(self, slot, vec):", sync, 1)
    open(p, "w").write(s)
    print("stage_check: sync added")
else:
    print("stage_check: already has sync")

for f in ("stage_check.py", "stage2_check.py", "stage3_check.py",
          "stage4_check.py", "stage5_check.py", "stage6_check.py",
          "stage7_check.py"):
    path = "tools/" + f
    try:
        t = open(path).read()
    except FileNotFoundError:
        continue
    n = t.replace('    b.send("PING\\n")\n    b.until("PONG")\n', "    b.sync()\n")
    if n != t:
        open(path, "w").write(n)
        print(f"{f}: uses sync()")
