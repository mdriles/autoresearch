#!/bin/bash
set -e

TRAINFILE="train.py"

if [ ! -f "$TRAINFILE" ]; then
  echo "ERROR: Run this from inside the autoresearch directory"
  exit 1
fi

echo "=== Current values ==="
grep -n "vocab_size\|MAX_SEQ_LEN\|batch_size" $TRAINFILE

echo ""
echo "=== Applying changes ==="
sed -i 's/vocab_size\s*=\s*[0-9]*/vocab_size = 2048/' $TRAINFILE
sed -i 's/MAX_SEQ_LEN\s*=\s*[0-9]*/MAX_SEQ_LEN = 512/' $TRAINFILE

echo "New values:"
grep -n "vocab_size\|MAX_SEQ_LEN\|batch_size" $TRAINFILE

echo ""
echo "=== Installing dependencies ==="
uv sync

echo ""
echo "=== Preparing data ==="
uv run prepare.py

echo ""
echo "=== Running smoke test ==="
uv run train.py
