#!/bin/bash
# D0 unattended runner: waits for the pip install to finish, then runs
# sanity generation + quick evals for floor (1bitLLM) and ceiling (Qwen3).
# Log: ~/tc-d0.log   Results: training/D0-results.md (uncommitted; review first)
set -u
cd "$(dirname "$0")"
source ~/tc-train/bin/activate

echo "[d0] waiting for install to finish..."
while pgrep -f 'pip install' > /dev/null; do sleep 20; done
python - <<'EOF' || { echo '[d0] torch import failed - see ~/tc-train-install.log'; exit 1; }
import torch; assert torch.cuda.is_available()
print(f"[d0] torch {torch.__version__} on {torch.cuda.get_device_name(0)}")
EOF

RES=D0-results.md
{
  echo "# D0 results ($(date -u +%F))"
  echo; echo '## Environment'; echo '```'
  python -c "import torch,transformers; print('torch',torch.__version__); print('transformers',transformers.__version__)"
  nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
  echo '```'
} > "$RES"

for M in 1bitLLM/bitnet_b1_58-large Qwen/Qwen3-0.6B; do
  echo "[d0] sanity: $M"
  { echo; echo "## Sanity: $M"; echo '```'; } >> "$RES"
  python d0_sanity.py "$M" >> "$RES" 2>&1
  echo '```' >> "$RES"
done

for M in 1bitLLM/bitnet_b1_58-large Qwen/Qwen3-0.6B; do
  echo "[d0] eval: $M"
  { echo; echo "## Eval (arc_easy, hellaswag, limit 200): $M"; echo '```'; } >> "$RES"
  lm_eval --model hf --model_args pretrained=$M,dtype=float16 \
          --tasks arc_easy,hellaswag --limit 200 --device cuda:0 --batch_size 8 \
          2>&1 | tail -20 >> "$RES"
  echo '```' >> "$RES"
done

pip freeze > requirements-frozen.txt
echo "[d0] DONE — review $PWD/$RES then commit to feat/distillation"
