#!/usr/bin/env python3
"""tc_serve.py -- the board, over HTTP, so you can show someone.

    python tools/tc_serve.py
    tailscale serve --bg 8080          # then it is on your tailnet

Everything here is the same path tools/ternary.py takes: prefill the
prompt one position at a time, generate from the last hidden state, and
let the board hold the KV cache. The only thing this adds is that the
tokens come out as they are produced instead of at the end, which matters
because at 4.6 seconds a token a six-token answer is half a minute of a
blank screen otherwise.

Three deliberate constraints, all for the same reason -- there is one
serial port and one board:

  * one generation at a time, enforced by a lock. A second request gets
    409 and a clear message rather than two writers interleaving commands
    on the same UART, which produces garbage that looks like a hardware
    fault.
  * the board is opened once at startup and preflighted once. If DDR is
    empty the server refuses to start, rather than serving confident
    zeros -- argmax of a constant vector is still a token and it looks
    exactly like an answer.
  * bound to localhost by default. `tailscale serve` proxies to it, which
    gives you TLS and tailnet identity without this process ever
    listening on anything routable. --host 0.0.0.0 is there if you want
    it and is not the default on purpose.

SPDX-License-Identifier: CERN-OHL-S-2.0
"""
import argparse
import json
import os
import sys
import threading
import time
import traceback
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tc_ref
from stage_check import Board
from ternary import preflight, step, NB

MAX_TOKENS = 32
MAX_POS = 511

STATE = {
    "board": None,
    "lock": threading.Lock(),
    "embed": None,
    "gf": None,
    "tok": None,
    "blocks": NB,
    "fab": 1,
    "dev": "",
    "busy": False,
    "served": 0,
}


def generate(prompt, ntok, emit):
    """Prefill, then generate, calling emit() after every position.

    emit takes a dict and is expected to put it on the wire immediately.
    The board is the slow part by three orders of magnitude, so there is
    no value in batching anything here.
    """
    tk, embed, gf = STATE["tok"], STATE["embed"], STATE["gf"]
    b, blocks, fab = STATE["board"], STATE["blocks"], STATE["fab"]

    ids = tk.encode(prompt)
    if not ids:
        raise ValueError("empty prompt")
    if len(ids) + ntok > MAX_POS:
        raise ValueError(f"prompt plus {ntok} tokens exceeds {MAX_POS} "
                         f"positions, which is the KV cache")

    emit({"type": "start", "prompt_tokens": len(ids), "want": ntok})

    t0, pos, h = time.time(), 0, None
    for i, tid in enumerate(ids):
        ts = time.time()
        h = step(b, embed[tid].copy(), pos, blocks, fab)
        pos += 1
        emit({"type": "prefill", "i": i + 1, "n": len(ids),
              "text": tk.decode([int(tid)]), "ms": (time.time() - ts) * 1e3})

    out = []
    for _ in range(ntok):
        logits = embed @ tc_ref.rmsnorm(h, gf)
        nxt = int(np.argmax(logits))
        out.append(nxt)
        order = np.argsort(-logits)[:5]
        emit({"type": "token", "id": nxt, "text": tk.decode([nxt]),
              "top": [{"text": tk.decode([int(j)]),
                       "logit": float(logits[j])} for j in order]})
        if pos >= MAX_POS or len(out) >= ntok:
            break
        ts = time.time()
        h = step(b, embed[nxt].copy(), pos, blocks, fab)
        pos += 1
        emit({"type": "step", "pos": pos, "ms": (time.time() - ts) * 1e3})

    dt = time.time() - t0
    npos = max(1, len(ids) + len(out) - 1)
    emit({"type": "done", "seconds": dt, "positions": npos,
          "s_per_token": dt / npos,
          "text": tk.decode(out)})


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def log_message(self, fmt, *args):          # one line, not three
        sys.stderr.write("  %s %s\n" % (self.address_string(), fmt % args))

    def _send(self, code, ctype, body):
        if isinstance(body, str):
            body = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path in ("/", "/index.html"):
            return self._send(200, "text/html; charset=utf-8", PAGE)
        if self.path == "/status":
            return self._send(200, "application/json", json.dumps({
                "device": STATE["dev"],
                "blocks": STATE["blocks"],
                "normalizer": "fabric" if STATE["fab"] else "soft CPU",
                "busy": STATE["busy"],
                "served": STATE["served"],
                "max_tokens": MAX_TOKENS,
            }))
        self._send(404, "text/plain", "no")

    def do_POST(self):
        if self.path != "/generate":
            return self._send(404, "text/plain", "no")
        try:
            n = int(self.headers.get("Content-Length", 0))
            req = json.loads(self.rfile.read(n) or b"{}")
            prompt = str(req.get("prompt", "")).strip()
            ntok = max(1, min(MAX_TOKENS, int(req.get("tokens", 6))))
        except Exception as e:
            return self._send(400, "application/json",
                              json.dumps({"error": f"bad request: {e}"}))
        if not prompt:
            return self._send(400, "application/json",
                              json.dumps({"error": "empty prompt"}))

        if not STATE["lock"].acquire(blocking=False):
            return self._send(409, "application/json", json.dumps(
                {"error": "the board is busy with another request. "
                          "There is one serial port; wait for it."}))

        STATE["busy"] = True
        self.send_response(200)
        self.send_header("Content-Type", "application/x-ndjson")
        self.send_header("Transfer-Encoding", "chunked")
        self.send_header("Cache-Control", "no-store")
        self.end_headers()

        def emit(obj):
            line = (json.dumps(obj) + "\n").encode()
            self.wfile.write(b"%x\r\n" % len(line) + line + b"\r\n")
            self.wfile.flush()

        try:
            generate(prompt, ntok, emit)
            STATE["served"] += 1
        except Exception as e:
            traceback.print_exc()
            try:
                emit({"type": "error", "message": str(e)})
            except Exception:
                pass
        finally:
            STATE["busy"] = False
            STATE["lock"].release()
            try:
                self.wfile.write(b"0\r\n\r\n")
                self.wfile.flush()
            except Exception:
                pass


PAGE = r"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>TernaryCore &mdash; inference on an Arty A7-100T</title>
<style>
:root{--bg:#0e1113;--fg:#d8dee2;--dim:#7c8a93;--acc:#63c8a8;--warn:#e0a458;
      --line:#1e2428;--card:#141a1d}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);
     font:15px/1.55 ui-monospace,SFMono-Regular,Menlo,Consolas,monospace}
.wrap{max-width:900px;margin:0 auto;padding:32px 20px 80px}
h1{font-size:19px;font-weight:600;margin:0 0 4px;letter-spacing:.02em}
.sub{color:var(--dim);font-size:13px;margin:0 0 28px}
.sub b{color:var(--fg);font-weight:600}
.card{background:var(--card);border:1px solid var(--line);border-radius:8px;
      padding:18px;margin-bottom:18px}
label{display:block;font-size:12px;color:var(--dim);margin-bottom:6px;
      text-transform:uppercase;letter-spacing:.08em}
textarea{width:100%;background:#0b0e10;color:var(--fg);border:1px solid var(--line);
         border-radius:6px;padding:10px 12px;font:inherit;resize:vertical;min-height:64px}
textarea:focus{outline:none;border-color:var(--acc)}
.row{display:flex;gap:14px;align-items:flex-end;margin-top:14px;flex-wrap:wrap}
.row .grow{flex:1 1 200px}
input[type=range]{width:180px;accent-color:var(--acc)}
button{background:var(--acc);color:#07120e;border:0;border-radius:6px;
       padding:10px 20px;font:inherit;font-weight:600;cursor:pointer}
button:disabled{background:#2c3a35;color:#6d7c76;cursor:not-allowed}
#out{white-space:pre-wrap;word-break:break-word;min-height:52px;font-size:16px}
#out .p{color:var(--dim)}
#out .g{color:var(--acc)}
#cursor{display:inline-block;width:8px;height:17px;background:var(--acc);
        vertical-align:-3px;animation:bl 1s steps(2) infinite}
@keyframes bl{50%{opacity:0}}
.log{font-size:12px;color:var(--dim);max-height:190px;overflow:auto;
     border-top:1px solid var(--line);margin-top:14px;padding-top:10px}
.log div{white-space:pre}
.stats{display:flex;gap:26px;flex-wrap:wrap;font-size:12px;color:var(--dim);
       margin-top:14px}
.stats b{display:block;color:var(--fg);font-size:17px;font-weight:600}
.top{margin-top:12px;font-size:12px;color:var(--dim)}
.top span{color:var(--fg)}
.err{color:var(--warn)}
.foot{color:var(--dim);font-size:12px;margin-top:26px;line-height:1.7}
.foot a{color:var(--acc)}
.dot{display:inline-block;width:7px;height:7px;border-radius:50%;
     background:var(--acc);margin-right:7px;vertical-align:1px}
</style></head><body><div class="wrap">

<h1><span class="dot"></span>TernaryCore</h1>
<p class="sub">A 596M-parameter ternary model on a <b>$299 Digilent Arty
A7-100T</b>. All twenty-eight transformer blocks run on the FPGA, reading
110 MB of {&minus;1,&nbsp;0,&nbsp;+1} weights out of the board's own DDR3.
The host tokenizes, looks up the embedding, and turns the last hidden
state back into logits &mdash; nothing else.</p>

<div class="card">
  <label for="p">prompt</label>
  <textarea id="p">The movie was</textarea>
  <div class="row">
    <div>
      <label for="n">tokens &mdash; <span id="nv">6</span></label>
      <input type="range" id="n" min="1" max="16" value="6">
    </div>
    <div class="grow"></div>
    <button id="go">generate</button>
  </div>
</div>

<div class="card">
  <div id="out"><span class="p">&nbsp;</span></div>
  <div class="top" id="top"></div>
  <div class="stats" id="stats"></div>
  <div class="log" id="log"></div>
</div>

<p class="foot">
Roughly 2.9&nbsp;s a token at the start of a context and 4.7&nbsp;s at 512,
because attention walks the KV cache and the rest of a block does not.
The board's arithmetic is about a tenth of a per cent of that; the rest is
a soft CPU doing elementwise work and handing the array bytes one 32-bit
register write at a time. That is the finding, not the speed.<br>
Output repeating one word is the model, not the machine &mdash; this
student was distilled on a sentiment task.<br>
<a href="https://github.com/Ternarycore/ternarycore">github.com/Ternarycore/ternarycore</a>
&middot; CERN-OHL-S v2
</p>

</div><script>
const $=s=>document.querySelector(s);
const out=$("#out"),log=$("#log"),stats=$("#stats"),topd=$("#top");
$("#n").oninput=e=>$("#nv").textContent=e.target.value;

function line(t,cls){const d=document.createElement("div");
  if(cls)d.className=cls;d.textContent=t;log.appendChild(d);
  log.scrollTop=log.scrollHeight;}

$("#go").onclick=async()=>{
  const prompt=$("#p").value, tokens=+$("#n").value;
  if(!prompt.trim())return;
  $("#go").disabled=true; log.innerHTML=""; stats.innerHTML=""; topd.innerHTML="";
  out.innerHTML='<span class="p"></span><span class="g"></span><span id="cursor"></span>';
  out.querySelector(".p").textContent=prompt;
  const gen=out.querySelector(".g");
  let r;
  try{
    r=await fetch("/generate",{method:"POST",
      headers:{"Content-Type":"application/json"},
      body:JSON.stringify({prompt,tokens})});
  }catch(e){ line("network: "+e,"err"); $("#go").disabled=false; return; }
  if(!r.ok){ const j=await r.json().catch(()=>({error:r.statusText}));
    line(j.error||"error","err"); $("#go").disabled=false; return; }

  const rd=r.body.getReader(), dec=new TextDecoder(); let buf="";
  while(true){
    const {value,done}=await rd.read(); if(done)break;
    buf+=dec.decode(value,{stream:true});
    let i;
    while((i=buf.indexOf("\n"))>=0){
      const s=buf.slice(0,i); buf=buf.slice(i+1);
      if(!s.trim())continue;
      let m; try{m=JSON.parse(s)}catch(e){continue}
      if(m.type==="start")
        line(`prefilling ${m.prompt_tokens} prompt token(s), then ${m.want}`);
      else if(m.type==="prefill")
        line(`  prefill ${m.i}/${m.n}  ${JSON.stringify(m.text)}  ${m.ms.toFixed(0)} ms`);
      else if(m.type==="step")
        line(`  position ${m.pos}  ${m.ms.toFixed(0)} ms`);
      else if(m.type==="token"){
        gen.textContent+=m.text;
        topd.innerHTML="top 5 &nbsp; "+m.top.map(t=>
          `<span>${t.text.replace(/[<&]/g,c=>c=="<"?"&lt;":"&amp;")}</span> `+
          t.logit.toFixed(2)).join(" &nbsp;&middot;&nbsp; ");
      }
      else if(m.type==="done"){
        const c=$("#cursor"); if(c)c.remove();
        stats.innerHTML=
          `<div><b>${m.s_per_token.toFixed(2)} s</b>per token</div>`+
          `<div><b>${m.seconds.toFixed(1)} s</b>total</div>`+
          `<div><b>${m.positions}</b>positions x 28 blocks</div>`;
        line("done");
      }
      else if(m.type==="error"){ const c=$("#cursor"); if(c)c.remove();
        line("board: "+m.message,"err"); }
    }
  }
  $("#go").disabled=false;
};
</script></body></html>
"""


def main():
    ap = argparse.ArgumentParser(
        description="serve the ternary model on the Arty over HTTP")
    ap.add_argument("--dev", default="/dev/ttyUSB1")
    ap.add_argument("--cache",
                    default=os.path.expanduser("~/tc-ckpt/tc-ref-int8.npz"))
    ap.add_argument("--host", default="127.0.0.1",
                    help="127.0.0.1 by default; put tailscale serve in front")
    ap.add_argument("--port", type=int, default=8080)
    ap.add_argument("--blocks", type=int, default=NB)
    ap.add_argument("--cpu", action="store_true",
                    help="normalize on the soft CPU instead of in fabric")
    a = ap.parse_args()

    print("loading the tokenizer and the embedding table")
    z = np.load(a.cache)
    from transformers import AutoTokenizer
    STATE["tok"] = AutoTokenizer.from_pretrained(tc_ref.TEACHER)
    STATE["embed"] = z["embed"].astype(np.float64)
    STATE["gf"] = z["final_norm"].astype(np.float64)
    STATE["blocks"] = a.blocks
    STATE["fab"] = 0 if a.cpu else 1
    STATE["dev"] = a.dev

    print(f"opening {a.dev}")
    b = Board(a.dev)
    b.sync()
    preflight(b)                      # refuses on an empty or unloaded DDR
    STATE["board"] = b
    print("  board answers, constants present, page 0 computes non-zero")

    srv = ThreadingHTTPServer((a.host, a.port), Handler)
    print(f"\n  http://{a.host}:{a.port}\n")
    if a.host == "127.0.0.1":
        print(f"  to put it on your tailnet:  tailscale serve --bg {a.port}")
        print(f"  and to share it beyond:     tailscale funnel --bg {a.port}")
        print("  (funnel is public. This is a demo of a $299 board, not a "
              "service.)\n")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\nbye")


if __name__ == "__main__":
    main()
