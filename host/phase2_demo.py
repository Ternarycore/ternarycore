#!/usr/bin/env python3
"""Phase-2 exit demo: multiple packed layers resident in DDR3, paged into
the weight BRAM one at a time, streamed through the COLS=64 array, verified
exact against the training-side reference.

Protocol: LOADM <off> <len> per layer (UART->DDR, once), then per layer:
PAGE <off> (DDR->BRAM memcpy on the cached MicroBlaze), LOADA+SLOAD, SRUN.

Usage: python phase2_demo.py [--export ~/tc-export/d4-student-sst2-r2]
                             [--dev /dev/ttyUSB1]
                             [--layers 0.self_attn.k_proj,27.self_attn.v_proj]
"""
import argparse, os, sys, termios, time
import numpy as np

PAGE_BYTES = 262144


def open_serial(dev):
    fd = os.open(dev, os.O_RDWR | os.O_NOCTTY)
    a = termios.tcgetattr(fd)
    a[0] = a[1] = a[3] = 0
    a[2] = termios.CS8 | termios.CREAD | termios.CLOCAL
    a[4] = a[5] = termios.B115200
    termios.tcsetattr(fd, termios.TCSANOW, a)
    return fd


class Board:
    def __init__(self, fd):
        self.fd = fd; self.buf = b""
    def read_line(self, timeout=60):
        t0 = time.time()
        while True:
            i = self.buf.find(b"\n")
            if i >= 0:
                l = self.buf[:i].decode(errors="replace").strip()
                self.buf = self.buf[i+1:]
                if l: return l
                continue
            if time.time() - t0 > timeout:
                raise TimeoutError("no line from board")
            try: self.buf += os.read(self.fd, 4096)
            except BlockingIOError: time.sleep(0.005)
    def expect(self, pfx, timeout=60):
        while True:
            l = self.read_line(timeout)
            print("board:", l, flush=True)
            if l.startswith(pfx): return l
    def send(self, s): os.write(self.fd, s.encode())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--export", default=os.path.expanduser("~/tc-export/d4-student-sst2-r2"))
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--pager", choices=["cpu", "dma"], default="cpu",
                    help="cpu = MicroBlaze copy loop, dma = AXI CDMA hardware pager")
    ap.add_argument("--layers", default="0.self_attn.k_proj,27.self_attn.v_proj")
    ap.add_argument("--clock-hz", type=float, default=100e6,
                    help="streaming fabric clock used for throughput estimates")
    args = ap.parse_args()
    names = args.layers.split(",")
    ref = np.load(os.path.join(args.export, "reference.npz"))

    b = Board(open_serial(args.dev))
    time.sleep(0.3)
    b.send("PING\n"); b.expect("PONG")

    # -- one-time: model layers into DDR --------------------------------------
    for i, name in enumerate(names):
        wb = open(os.path.join(args.export, "layers",
                               name.replace(".", "_") + ".bin"), "rb").read()
        assert len(wb) == PAGE_BYTES
        off = i * PAGE_BYTES
        t0 = time.time()
        b.send(f"LOADM {off} {len(wb)}\n")
        for j in range(0, len(wb), 4096):
            os.write(b.fd, wb[j:j+4096])
        b.expect("OK M", timeout=120)
        print(f"LOADM {name} -> DDR+0x{off:x} in {time.time()-t0:.1f}s", flush=True)

    # -- per layer: page + stream + verify ------------------------------------
    results = []
    for i, name in enumerate(names):
        t = ref[name].astype(np.int32)
        rng = np.random.default_rng(hash(name) % 2**31)
        a = rng.integers(-8, 8, 1024).astype(np.int8)
        e = t @ a.astype(np.int32)

        cmd, tag, ack = (("PAGEDMA", "PAGEDMA", "OK PD") if args.pager == "dma"
                         else ("PAGE", "PAGE", "OK P"))
        b.send(f"{cmd} {i*PAGE_BYTES}\n")
        b.expect(f"MARK {tag}_START"); tp0 = time.time()
        b.expect(f"MARK {tag}_END");   tp1 = time.time()
        b.expect(ack)

        b.send(f"LOADA 1024\n"); os.write(b.fd, a.tobytes()); b.expect("OK A")
        b.send("SLOAD\n"); b.expect("OK SL")
        b.send("SRUN 5\n")
        cyc = int(b.expect("CYC").split()[1])
        b.expect("MARK STREAM_END", timeout=120)
        schk = b.expect("SCHK")
        b.expect("DONE")
        outs = [int(x) for x in schk.split("OUT")[1].strip().rstrip(",").split(",")]
        ok = outs == list(e[:8])
        page_s = tp1 - tp0
        page_mib_s = PAGE_BYTES / page_s / (1024 * 1024) if page_s else 0.0
        # One 1024x1024 ternary tile performs 2*1024*1024 operations.
        # `cyc` is the hardware-reported tile latency, not UART wall time.
        gops = (2 * 1024 * 1024) / (cyc / args.clock_hz) / 1e9 if cyc else 0.0
        results.append((name, ok, cyc, page_s, page_mib_s, gops))
        print(f"LAYER {name}: {'EXACT-MATCH' if ok else 'FAIL '+str(outs)+' vs '+str(list(e[:8]))} "
              f"(tile {cyc} cyc, {gops:.2f} GOPS, page ~{page_s*1000:.0f} ms "
              f"{page_mib_s:.2f} MiB/s incl UART)", flush=True)

    good = sum(1 for _, ok, _, _ in results if ok)
    print(f"PHASE2 DEMO: {good}/{len(results)} DDR-resident layers paged+computed exact", flush=True)
    sys.exit(0 if good == len(results) else 1)


if __name__ == "__main__":
    main()
""""""
