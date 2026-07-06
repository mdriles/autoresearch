#!/bin/bash
# One-time setup + smoke test for this small-GPU fork of autoresearch.
# Small-platform constants live directly in prepare.py (MAX_SEQ_LEN, VOCAB_SIZE,
# EVAL_TOKENS); train.py auto-detects GPU capability (FA3/bf16/compile vs.
# SDPA/fp32/eager fallbacks). No file patching needed.
set -e

if [ ! -f "train.py" ]; then
  echo "ERROR: Run this from inside the autoresearch directory"
  exit 1
fi

echo "=== Installing dependencies ==="
uv sync

echo ""
echo "=== Preparing data (downloads shards + trains tokenizer on first run) ==="
uv run prepare.py

echo ""
echo "=== Running smoke test (5-minute training run + eval) ==="
uv run train.py
