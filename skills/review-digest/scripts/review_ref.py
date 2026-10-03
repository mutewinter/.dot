#!/usr/bin/env python3
"""Turn a range into one synthetic commit per review group, in reading order.

Usage: review_ref.py <groups.json> [--repo PATH] [--worktree PATH]

groups.json:
  {"name": "merge-2-0", "base": "<sha>", "head": "<sha>",
   "groups": [{"id": "g01", "title": "...", "message": "...", "paths": ["apps/studio/src/x/", "README.md", "src/lib/migrate*"]}]}

Each changed file goes to the group whose path entry matches it with the
longest pattern. An entry is a path prefix, or an fnmatch glob when it holds
* ? or [ (a * crosses directories).
Files no group claims go into a last commit titled "Everything else", so the
final tree always equals <head>'s tree. Commit k is base plus the head
version of every file in groups 1..k, so `git show` on it shows exactly that
group. The chain is stored at refs/review/<name> (no branch is created) and,
with --worktree, checked out detached there for lazygit or an editor.
Rerun with --writeups once the groups are written so each commit message
carries its group's summary and decisions, which is what lazygit shows.
Prints JSON mapping group id to commit sha.
"""

import argparse
import fnmatch
import json
import os
import subprocess
import sys
import tempfile

ZERO = "0" * 40


def git(repo, *args, env=None, stdin=None):
    out = subprocess.run(["git", "-C", repo, *args], capture_output=True, text=True, input=stdin, env=env, check=False)
    if out.returncode != 0:
        sys.exit(f"git {' '.join(args[:3])} failed: {out.stderr.strip()}")
    return out.stdout


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("groups")
    ap.add_argument("--repo", default=".")
    ap.add_argument("--worktree")
    ap.add_argument("--writeups", help="directory of <id>.json group write-ups; their summary and decisions become the commit messages")
    args = ap.parse_args()

    spec = json.load(open(args.groups))
    repo = git(args.repo, "rev-parse", "--show-toplevel").strip()
    base = git(repo, "rev-parse", spec["base"]).strip()
    head = git(repo, "rev-parse", spec["head"]).strip()

    changed = []
    for line in git(repo, "diff", "--name-status", "--no-renames", "-z", base, head).split("\0"):
        if line:
            changed.append(line)
    files = [(changed[i][0], changed[i + 1]) for i in range(0, len(changed) - 1, 2)]

    head_entries = {}
    for entry in git(repo, "ls-tree", "-r", "-z", head).split("\0"):
        if entry:
            meta, path = entry.split("\t", 1)
            mode, _, sha = meta.split(" ")
            head_entries[path] = (mode, sha)

    groups = list(spec["groups"])
    if args.writeups:
        for g in groups:
            path = os.path.join(args.writeups, f"{g['id']}.json")
            if os.path.exists(path):
                w = json.load(open(path))
                lines = [w.get("summary", "")]
                for d in w.get("decisions", []):
                    lines.append(f"- Decided: {d.get('decided', '')}")
                    lines += [f"  Commits-to: {c}" for c in d.get("commits_to", [])]
                for t in w.get("two_steps_down", []):
                    lines.append(f"- Two steps down: {t.get('concern', '')} ({t.get('against', '')})")
                g["message"] = "\n".join(lines)
    assigned = {g["id"]: [] for g in groups}
    leftovers = []
    for status, path in files:
        best, best_len = None, -1
        for g in groups:
            for prefix in g.get("paths", []):
                if any(ch in prefix for ch in "*?["):
                    hit = fnmatch.fnmatchcase(path, prefix)
                else:
                    hit = path == prefix or path.startswith(prefix.rstrip("/") + "/")
                if hit and len(prefix) > best_len:
                    best, best_len = g["id"], len(prefix)
        (assigned[best] if best else leftovers).append((status, path))
    if leftovers:
        groups.append({"id": "rest", "title": "Everything else", "message": "Files no review group claimed."})
        assigned["rest"] = leftovers

    fd, index = tempfile.mkstemp(prefix="review-index-")
    os.close(fd)
    os.unlink(index)
    env = {**os.environ, "GIT_INDEX_FILE": index}
    git(repo, "read-tree", base, env=env)
    parent = base
    result = {}
    total = len(groups)
    try:
        for n, g in enumerate(groups, 1):
            rows = []
            for _, path in assigned[g["id"]]:
                if path in head_entries:
                    mode, sha = head_entries[path]
                    rows.append(f"{mode} {sha}\t{path}")
                else:
                    rows.append(f"0 {ZERO}\t{path}")
            if rows:
                git(repo, "update-index", "--index-info", env=env, stdin="\n".join(rows) + "\n")
            tree = git(repo, "write-tree", env=env).strip()
            message = f"review {n:02d}/{total:02d}: {g['title']}\n\n{g.get('message', '').strip()}\n\n{len(rows)} files\n"
            parent = git(repo, "commit-tree", tree, "-p", parent, env=env, stdin=message).strip()
            result[g["id"]] = {"sha": parent, "n": n, "title": g["title"], "files": [p for _, p in assigned[g["id"]]]}
    finally:
        if os.path.exists(index):
            os.unlink(index)

    final_tree = git(repo, "rev-parse", f"{parent}^{{tree}}").strip()
    head_tree = git(repo, "rev-parse", f"{head}^{{tree}}").strip()
    if final_tree != head_tree:
        sys.exit(f"final tree {final_tree} does not match head tree {head_tree}")

    ref = f"refs/review/{spec['name']}"
    git(repo, "update-ref", ref, parent)
    worktree = None
    if args.worktree:
        worktree = os.path.abspath(os.path.expanduser(args.worktree))
        if os.path.exists(os.path.join(worktree, ".git")):
            git(worktree, "checkout", "--detach", "--quiet", parent)
        else:
            git(repo, "worktree", "add", "--detach", "--quiet", worktree, parent)
    print(json.dumps({"ref": ref, "tip": parent, "base": base, "worktree": worktree, "groups": result}, indent=1))


if __name__ == "__main__":
    main()
