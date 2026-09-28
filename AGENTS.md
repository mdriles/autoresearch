# autoresearch — AGENTS.md (the only rules file; every agent reads this)

You are one of several agents on this repo: Claude Code, Codex, Grok, Hermes, Cursor.
This file is the constitution. Chat history, Obsidian, old PRDs and other chats do NOT override it.
**Automatic, every session, without being asked:** your first actions are SESSION START, your last are SESSION END.
If Riles just says "go", "start", or "next", that means: do the NOW item.
Scripts live in `~/.claude/skills/canon/scripts/` (below: `$C`; set `C=~/.claude/skills/canon/scripts` in your shell).
Your agent name = `<tool>-<machine>`: `claude-wsl`, `codex-piclaw`, `grokbot`, `hermes-piclaw`.
Codex: run with network access on, or git/gh/claim will fail.

## SESSION START
1. `git status --porcelain` must be empty. If not, stop: tell Riles what's uncommitted. Don't carry it into new work.
2. `git switch master && git pull --ff-only`. If that fails, stop and tell Riles.
3. Read this file. Then `python3 $C/canon_state.py show` — NOW.md as it is on GitHub right now (it lives on the `canon-state` branch, never here).
4. `python3 $C/canon_state.py claim --agent <you>` → prints your session id (e.g. `claude-wsl#3f9a`); use it for release.
   Exit 2 = another session holds it: change nothing, tell Riles, stop.
5. `python3 $C/canon_check.py --repo . --repo-only`. Fix code-side issues on your branch. NOW.md issues get fixed in your release file.
6. `git switch -c agent/<you>/<short-slug>`. All code goes on this branch. Do only the item under `## NOW`.
   If something isn't in this file or NOW.md, ask Riles. Don't dig through old notes, PRDs or chats.

## SESSION END (output contract)
The status line reports THIS session. NOW.md is the NEXT session's handoff.
- Done (tests pass):
  1. `git push -u origin HEAD`, then `gh pr create --base master --title "<NOW item>" --body-file <file>` where the body is:
     **What changed** (2 lines, plain English) · **Tests** (n/n) · **Outside the NOW item** (none, or what and why) · **Preview** (link, if the repo gets preview deploys).
  2. `bash $C/canon_review.sh <pr#> <you>` — a different agent comments SAFE TO MERGE / DON'T MERGE on the PR and sets the `canon/review` check GitHub requires before merging.
  3. `NOWF=$(mktemp)`; write the new NOW.md there: STATE gains "<date> PR #n open: <item>", NOW = top item of NEXT (removed from NEXT),
     BLOCKED `none` — or `BLOCKED · <next item> · needs PR #n merged · NEED YOU: merge #n` if the next item depends on it.
     `python3 $C/canon_state.py release --agent <session id> --now-file "$NOWF"` (exit 5 = fix the file and rerun).
  4. Print: `DONE · <item> · tests <n/n> · PR #<n> · review: <first line of the review>`
- Stuck: push the branch if it has work. New NOW.md: NOW unchanged, BLOCKED = the line below. Release the same way. Print:
  `BLOCKED · <item> · <what failed> · NEED YOU: <exact action, or "none — next: <command>">`
- A paragraph, "still working", "see chat", "updated the PRD" = a leak. Not an ending.
- Can't finish properly (lint won't pass, release keeps failing)? Release anyway with the current `show` output plus one BLOCKED line describing it. Never leave the lock held.

## MERGING
Only when Riles says "merge it" / "merge #n": `gh pr merge <n> --squash --delete-branch`, then `git switch <default> && git pull --ff-only`.
Merging is what deploys. Never merge on your own judgment, never because a review said SAFE.

## WHAT THIS IS
Michael's small-GPU fork of Karpathy's autoresearch: an AI agent edits `train.py`, trains a small GPT for a fixed 5-minute budget,
keeps the change if `val_bpb` (validation bits per byte, lower is better) improves, and loops overnight. Done = an experiment branch
with a `results.tsv` log and a better `val_bpb` than the baseline. Adapted for GTX 1060 / Pascal (commit `d016423`).

## WHAT'S LIVE
- Repo: mdriles/autoresearch (public; canonical; any other repo/folder for this project is dead). Deploys: none.
- Runtime: single NVIDIA GPU, Python 3.10+, `uv`. `bash setup.sh` = `uv sync` + `uv run prepare.py` + one smoke run of `uv run train.py`.
- Data/tokenizer cache: `~/.cache/autoresearch/` (present on Alienware WSL). Clones on piclaw, Alienware, hermes-cloud; only a GPU host can train.
- Files: `prepare.py` (fixed constants, data prep, dataloader, `evaluate_bpb` — never modified), `train.py` (the only file experiments edit),
  `program.md` (the agent's research instructions — edited by Riles only).

## HOW TO WORK WITH RILES
- He does not code. Terse, decisive answers. Recommend one thing; no option menus.
- Key decisions get an explicit `[VERIFY]` and a yes before executing.
- Never cut, kill, demote, delete, or drop scope without his yes on the specific item.
- Merge / deploy / send / spend = his explicit yes.

## HARD RULES
- State lives only in NOW.md on the `canon-state` branch, and only `canon_state.py` changes it. Never create a NOW.md on a code branch.
  Never write status into this file, a PRD, or Obsidian.
- Obsidian updates itself from GitHub (piclaw mirrors NOW.md every 2 min). Never edit the vault copy.
- Never push to the default branch yourself (GitHub and a local hook both refuse it). Never force-push. Code = branch + PR.
- Don't edit the PRD unless Riles named a requirement change. Docs and code disagree → believe code + tests.
- Scratch notes go in `docs/notes/`. History is git.

## LOCKED (settled — do not re-open)
- Experiment runs follow `program.md` exactly: branch `autoresearch/<tag>` off master, commit per experiment, reset on no gain,
  `results.tsv` untracked. Those branches are the one exception to `agent/<you>/<slug>` and are never merged to master.
- Metric = `val_bpb` from `prepare.py`'s `evaluate_bpb`; time budget fixed at 5 minutes. No new dependencies beyond `pyproject.toml`.
- Small-GPU constants live in `prepare.py` (MAX_SEQ_LEN, VOCAB_SIZE, EVAL_TOKENS); `train.py` auto-detects FA3/bf16/compile vs SDPA/fp32/eager.

## KILLED (dead — never resurface; deleted from runtime, not archived)
- none yet.

## ROADMAP (order is locked; build only the current phase)
- v1: a verified baseline run on the small-GPU fork, then overnight experiment branches per `program.md`.

## SPEC
- `README.md` (upstream context), `program.md` (research-loop instructions). No PRD.
