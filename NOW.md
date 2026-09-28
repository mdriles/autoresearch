# NOW — autoresearch

## STATE (as of 2026-09-28)
- 2026-09-28 canon init: AGENTS.md + CLAUDE.md added; `.gitignore` no longer ignores them. Rollback tag `canon-pre-20260928`.
- 2026-07-06 Last code commit `d016423`: fork adapted for small GPUs (GTX 1060 / Pascal), `setup.sh` fixed. Untouched since.
- `~/.cache/autoresearch/` holds `data/` + `tokenizer/` on Alienware WSL (prepare step done there at least once).
- No `autoresearch/<tag>` experiment branch on GitHub; no `results.tsv` baseline recorded in the repo.

## NOW
On the Alienware GPU, run `uv run train.py > run.log 2>&1` on master and confirm `grep "^val_bpb:" run.log` prints a number — the small-GPU baseline.

## BLOCKED
none

## OWNER
none

## NEXT
- Start the first overnight run per `program.md` on branch `autoresearch/<tag>` with the baseline recorded in `results.tsv`.
