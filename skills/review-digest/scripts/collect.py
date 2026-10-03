#!/usr/bin/env python3
"""Collect the facts a review digest is built from.

Usage: collect.py <base> <head> [--repo PATH] [--out DIR] [--no-transcripts]

Writes <out>/collect.json (everything) and <out>/summary.md (what an agent
reads first to propose groups). Commits are base..head without merges, so for
a merge commit M pass base=M^1 head=M and the merged branch's commits are the
ones listed.
"""

import argparse
import json
import os
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

CONTAINERS = {"client", "components", "lib", "routes", "electron-main", "features", "modules", "app", "server", "rpc"}
LOCKFILES = {"pnpm-lock.yaml", "package-lock.json", "yarn.lock", "bun.lockb", "Cargo.lock"}
ASSET_EXT = {".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".ico", ".icns", ".woff", ".woff2", ".ttf", ".mp4", ".pdf"}
COMMIT_LINE = re.compile(r"\[([^\]\s]+)(?: \(root-commit\))? ([0-9a-f]{7,12})\]")
SIGNAL_PATTERNS = [
    ("schema", re.compile(r"schema|zod|\.sql$|/db/|database|migrat", re.I)),
    ("migration", re.compile(r"migrat", re.I)),
    ("rpc", re.compile(r"/rpc/|router|contract|/routes?\.ts$", re.I)),
    ("ipc", re.compile(r"preload|ipc|bridge", re.I)),
    ("on-disk", re.compile(r"settings|storage|persist|layout|paths?\.ts$|fs-", re.I)),
    ("shared-types", re.compile(r"packages/shared/|/types?\.ts$|\.d\.ts$")),
    ("sandbox", re.compile(r"sandbox|bash|mount|containment", re.I)),
    ("build", re.compile(r"package\.json$|vite\.config|electron-builder|\.github/workflows|tsconfig", re.I)),
]


def git(repo, *args, check=True):
    out = subprocess.run(["git", "-C", repo, *args], capture_output=True, text=True, check=False)
    if check and out.returncode != 0:
        sys.exit(f"git {' '.join(args)} failed: {out.stderr.strip()}")
    return out.stdout


def kind_of(path):
    name = os.path.basename(path)
    ext = os.path.splitext(name)[1].lower()
    if name in LOCKFILES:
        return "lockfile"
    if "__snapshots__" in path or ext == ".snap":
        return "snapshot"
    if ".gen." in name or "/generated/" in path:
        return "generated"
    if ext in ASSET_EXT:
        return "asset"
    if re.search(r"\.(test|spec|browser\.test)\.[cm]?[jt]sx?$", name) or "/tests/" in path or "/__tests__/" in path:
        return "test"
    if ext in {".md", ".mdx"}:
        return "doc"
    return "source"


def area_of(path):
    parts = path.split("/")
    if "src" in parts[:-1]:
        i = parts.index("src") + 1
        depth = 0
        while i < len(parts) - 1 and parts[i] in CONTAINERS and depth < 3:
            i += 1
            depth += 1
        end = min(i + 1, len(parts) - 1)
        return "/".join(parts[:end]) if end > 0 else parts[0]
    return "/".join(parts[: min(2, len(parts) - 1)]) or parts[0]


def parse_numstat(text):
    rows = []
    for line in text.splitlines():
        bits = line.split("\t")
        if len(bits) != 3:
            continue
        add, dele, path = bits
        if " => " in path:
            path = re.sub(r"\{[^}]* => ([^}]*)\}", r"\1", path).replace("//", "/")
            if " => " in path:
                path = path.split(" => ")[1]
        rows.append((0 if add == "-" else int(add), 0 if dele == "-" else int(dele), path))
    return rows


def collect_commits(repo, base, head):
    fmt = "%x1e%H%x1f%h%x1f%aI%x1f%s%x1f%b%x1f"
    raw = git(repo, "log", "--no-merges", "--reverse", "--numstat", f"--format={fmt}", f"{base}..{head}")
    commits = []
    for chunk in raw.split("\x1e")[1:]:
        fields = chunk.split("\x1f")
        sha, short, date, subject, body = fields[:5]
        files = parse_numstat(fields[5] if len(fields) > 5 else "")
        commits.append({"sha": sha, "short": short, "date": date, "subject": subject, "body": body.strip(), "files": files})
    return commits


def collect_files(repo, base, head):
    status = {}
    for line in git(repo, "diff", "--name-status", "--no-renames", base, head).splitlines():
        bits = line.split("\t")
        if len(bits) >= 2:
            status[bits[-1]] = bits[0][0]
    files = []
    for add, dele, path in parse_numstat(git(repo, "diff", "--numstat", "--no-renames", base, head)):
        signals = [name for name, rx in SIGNAL_PATTERNS if rx.search(path)]
        files.append({"path": path, "status": status.get(path, "M"), "add": add, "del": dele, "area": area_of(path), "kind": kind_of(path), "signals": signals})
    return files


def new_exports(repo, base, head, paths):
    """Exported names added on the + side, per file, for source files only."""
    out = defaultdict(list)
    if not paths:
        return out
    diff = git(repo, "diff", "--no-renames", "-U0", base, head, "--", *paths)
    current = None
    rx = re.compile(r"^\+export (?:default )?(?:async )?(?:function\*? |const |let |class |type |interface |enum )?([A-Za-z0-9_$]+)")
    for line in diff.splitlines():
        if line.startswith("+++ b/"):
            current = line[6:]
        elif current and line.startswith("+export"):
            m = rx.match(line)
            if m:
                out[current].append(m.group(1))
    return out


def dependency_changes(repo, base, head, files):
    changes = []
    for f in files:
        if not f["path"].endswith("package.json"):
            continue
        def load(rev):
            text = git(repo, "show", f"{rev}:{f['path']}", check=False)
            try:
                return json.loads(text) if text else {}
            except json.JSONDecodeError:
                return {}
        before, after = load(base), load(head)
        for section in ("dependencies", "devDependencies", "peerDependencies", "optionalDependencies"):
            b, a = before.get(section, {}), after.get(section, {})
            for name in sorted(set(a) - set(b)):
                changes.append({"package": f["path"], "section": section, "name": name, "change": "added", "version": a[name]})
            for name in sorted(set(b) - set(a)):
                changes.append({"package": f["path"], "section": section, "name": name, "change": "removed"})
    return changes


def human_text(event):
    if event.get("type") != "user" or event.get("isMeta") or event.get("isSidechain"):
        return None
    content = event.get("message", {}).get("content")
    if isinstance(content, str):
        text = content
    elif isinstance(content, list):
        if any(isinstance(p, dict) and p.get("type") == "tool_result" for p in content):
            return None
        text = "\n".join(p.get("text", "") for p in content if isinstance(p, dict) and p.get("type") == "text")
    else:
        return None
    text = text.strip()
    if not text or text.startswith("<") or text.startswith("Caveat:"):
        return None
    return text


def rg(*args):
    try:
        return subprocess.run(["rg", "-a", "--no-heading", "-n", "-g", "*.jsonl", *args], capture_output=True, text=True, check=False).stdout
    except FileNotFoundError:
        sys.exit("ripgrep (rg) is required for the transcript join")


def join_transcripts(commits, roots):
    """Map each short sha to the session that committed it and the human ask before it.

    First by the `[branch sha]` line git prints on commit, then, for commits
    whose output was never printed in that form, by the subject appearing in
    a Bash tool call that runs `git commit`.
    """
    wanted = {c["short"][:7]: c["short"] for c in commits}
    hits = defaultdict(list)
    found = set()
    for line in rg("-o", r"\[[^\]\s]+(?: \(root-commit\))? [0-9a-f]{7,12}\]", *roots).splitlines():
        try:
            path, lineno, match = line.split(":", 2)
        except ValueError:
            continue
        m = COMMIT_LINE.search(match)
        if m and m.group(2)[:7] in wanted:
            hits[path].append((int(lineno), wanted[m.group(2)[:7]]))
            found.add(wanted[m.group(2)[:7]])
    by_subject = {}
    for c in commits:
        if c["short"] not in found and len(c["subject"]) >= 20:
            by_subject.setdefault(json.dumps(c["subject"])[1:-1], c["short"])
    if by_subject:
        for line in rg(r'"name":"Bash".*git (-C \S+ )?commit', *roots).splitlines():
            try:
                path, lineno, text = line.split(":", 2)
            except ValueError:
                continue
            for subject, short in list(by_subject.items()):
                if subject in text:
                    hits[path].append((int(lineno), short))
                    del by_subject[subject]
    joined = defaultdict(list)
    for path, items in hits.items():
        items.sort()
        last_ask, last_ts, prior_asks = None, None, []
        targets = iter(items)
        target = next(targets, None)
        with open(path, encoding="utf-8", errors="replace") as fh:
            for n, raw in enumerate(fh, 1):
                if target is None:
                    break
                if n < target[0]:
                    if '"type":"user"' in raw or '"type": "user"' in raw:
                        try:
                            event = json.loads(raw)
                        except json.JSONDecodeError:
                            continue
                        text = human_text(event)
                        if text:
                            if last_ask:
                                prior_asks.append(last_ask)
                            last_ask, last_ts = text, event.get("timestamp")
                    continue
                while target is not None and target[0] == n:
                    entry = {"transcript": path, "line": n, "ask": (last_ask or "")[:1200], "ask_at": last_ts}
                    if prior_asks:
                        entry["earlier_asks"] = [a[:300] for a in prior_asks[-3:]]
                    if all(e["transcript"] != path for e in joined[target[1]]):
                        joined[target[1]].append(entry)
                    target = next(targets, None)
    return joined


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("base")
    ap.add_argument("head")
    ap.add_argument("--repo", default=".")
    ap.add_argument("--out", default=None)
    ap.add_argument("--no-transcripts", action="store_true")
    ap.add_argument("--transcripts", default=str(Path.home() / ".claude/projects"))
    args = ap.parse_args()

    repo = git(args.repo, "rev-parse", "--show-toplevel").strip()
    base = git(repo, "rev-parse", args.base).strip()
    head = git(repo, "rev-parse", args.head).strip()
    out = Path(args.out or Path.home() / ".cache/review-digest" / Path(repo).name / f"{base[:9]}-{head[:9]}")
    out.mkdir(parents=True, exist_ok=True)

    commits = collect_commits(repo, base, head)
    files = collect_files(repo, base, head)
    source_paths = [f["path"] for f in files if f["kind"] == "source" and f["status"] != "D" and re.search(r"\.[cm]?[jt]sx?$", f["path"])]
    exports = {}
    for i in range(0, len(source_paths), 200):
        exports.update(new_exports(repo, base, head, source_paths[i : i + 200]))
    for f in files:
        if f["path"] in exports:
            f["new_exports"] = exports[f["path"]][:40]
    deps = dependency_changes(repo, base, head, files)

    joined = {} if args.no_transcripts else join_transcripts(commits, [args.transcripts])
    for c in commits:
        c["sessions"] = joined.get(c["short"], [])

    areas = defaultdict(lambda: {"files": 0, "add": 0, "del": 0, "kinds": defaultdict(int), "signals": defaultdict(int), "new_files": 0, "commits": set()})
    file_area = {}
    for f in files:
        a = areas[f["area"]]
        a["files"] += 1
        a["add"] += f["add"]
        a["del"] += f["del"]
        a["kinds"][f["kind"]] += f["add"] + f["del"]
        a["new_files"] += f["status"] == "A"
        for s in f["signals"]:
            a["signals"][s] += 1
        file_area[f["path"]] = f["area"]
    for c in commits:
        for _, _, p in c["files"]:
            if p in file_area:
                areas[file_area[p]]["commits"].add(c["short"])
    area_list = sorted(
        ({"area": k, **{**v, "kinds": dict(v["kinds"]), "signals": dict(v["signals"]), "commits": sorted(v["commits"])}} for k, v in areas.items()),
        key=lambda a: -(a["add"] + a["del"]),
    )

    total_add = sum(f["add"] for f in files)
    total_del = sum(f["del"] for f in files)
    joined_count = sum(1 for c in commits if c["sessions"])
    data = {
        "repo": repo, "base": base, "head": head,
        "stats": {"commits": len(commits), "files": len(files), "add": total_add, "del": total_del, "commits_with_session": joined_count},
        "areas": area_list, "dependencies": deps, "files": files, "commits": commits,
    }
    (out / "collect.json").write_text(json.dumps(data, indent=1))

    lines = [
        f"# Review range {base[:9]}..{head[:9]}",
        "",
        f"{len(commits)} commits, {len(files)} files, +{total_add} / -{total_del}. {joined_count} commits joined to a session transcript.",
        "",
        "## Areas by lines changed",
        "",
        "| area | files | new | +/- | commits | kinds | signals |",
        "|---|---|---|---|---|---|---|",
    ]
    for a in area_list:
        kinds = ", ".join(f"{k} {v}" for k, v in sorted(a["kinds"].items(), key=lambda kv: -kv[1]))
        signals = ", ".join(f"{k} {v}" for k, v in sorted(a["signals"].items(), key=lambda kv: -kv[1]))
        lines.append(f"| `{a['area']}` | {a['files']} | {a['new_files']} | +{a['add']}/-{a['del']} | {len(a['commits'])} | {kinds} | {signals} |")
    if deps:
        lines += ["", "## Dependency changes", ""]
        lines += [f"- {d['change']} `{d['name']}` ({d['section']}, {d['package']})" for d in deps]
    lines += ["", "## Commits (oldest first)", ""]
    lines += [f"- {c['short']} {c['date'][:10]} {c['subject']}{'' if c['sessions'] else '  [no session]'}" for c in commits]
    (out / "summary.md").write_text("\n".join(lines) + "\n")
    print(json.dumps({"out": str(out), **data["stats"], "areas": len(area_list), "dependency_changes": len(deps)}))


if __name__ == "__main__":
    main()
