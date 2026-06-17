import torch, time
from transformers import AutoModel

model = AutoModel.from_pretrained('HuggingFaceTB/SmolVLM-256M-Instruct', dtype=torch.float32)
model.eval()
inp = torch.randint(0, 32000, (1, 128))

with torch.no_grad():
    t0 = time.time()
    for _ in range(10): model.text_model(inp)
    t_txt = (time.time() - t0) / 10

def count_params(mod): return sum(p.numel() for p in mod.parameters())

vis_p = count_params(model.vision_model)
txt_p = count_params(model.text_model)
conn_p = count_params(model.connector)
lin_p = sum(p.numel() for m in model.text_model.modules() if isinstance(m, torch.nn.Linear) for p in m.parameters())

print(f'Text decoder: {t_txt:.3f}s/forward (seq=128)')
print(f'Params: vis={vis_p/1e6:.0f}M txt={txt_p/1e6:.0f}M conn={conn_p/1e6:.0f}M = {(vis_p+txt_p+conn_p)/1e6:.0f}M total')
print(f'Text Linear (ternarycore target): {lin_p/1e6:.1f}M/{txt_p/1e6:.1f}M = {100*lin_p/txt_p:.0f}% of text decoder')
print(f'Memory: FP32={txt_p*4/1024/1024:.1f}MB → ternary={lin_p*2/8/1024/1024:.1f}MB + rest FP32={(txt_p-lin_p)*4/1024/1024:.1f}MB')