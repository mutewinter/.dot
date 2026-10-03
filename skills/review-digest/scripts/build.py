#!/usr/bin/env python3
"""Join collect.json with the authored concerns into the page's data.

Usage: build.py <work> [--topics DIR] [--briefs]

Reads <work>/collect.json and <work>/concerns.json, writes <work>/data.json
and <work>/groups.json (the concerns as review_ref.py groups, for lazygit).

concerns.json:
  {"title": "Since beta.42", "summary": "Two or three sentences.",
   "concerns": [{"id": "disk", "name": "Chats on disk", "icon": "hard-drives",
                 "gist": "One line.", "paths": ["packages/workspace/src/lib/migrate", "apps/studio/src/x/*.ts"],
                 "topics": [{"head": "Eight words at most", "line": "One sentence.", "shas": ["85ca20767"], "note": "optional detail for the Ask prompt"}]}]}

With --briefs it writes <work>/briefs/<id>.md instead, one per concern: the
commits that land in it with their bodies, asks and sessions, for a subagent
writing that concern's topics.

A concern's topics may instead live in <topics-dir>/<id>.json as {"topics": [...]},
which is where per-concern subagents write them.

Each commit lands in one concern: the first topic that cites it, otherwise the
concern whose paths cover most of its changed lines, with tests, docs,
lockfiles and snapshots counting a twentieth. A path entry is a prefix, or an
fnmatch glob when it holds * ? or [; the longest match wins. Commits no
concern claims go to a closing "Everything else" concern.
"""

import argparse
import fnmatch
import json
import re
import subprocess
import sys
from pathlib import Path

LIGHT = re.compile(r"(\.(test|spec|browser\.test)\.[cm]?[jt]sx?|\.mdx?|\.snap|pnpm-lock\.yaml|package-lock\.json|yarn\.lock)$|/__snapshots__/|/tests?/")
SKIP_FILES = re.compile(r"(pnpm-lock\.yaml|package-lock\.json|yarn\.lock|\.snap)$")


def matcher(concerns):
    rules = []
    for con in concerns:
        for p in con.get("paths", []):
            glob = any(ch in p for ch in "*?[")
            rules.append((len(p), con["id"], p, glob))
    rules.sort(reverse=True)

    def owner(path):
        for _, cid, p, glob in rules:
            if (glob and fnmatch.fnmatch(path, p)) or (not glob and path.startswith(p)):
                return cid
        return None
    return owner


def github_slug(repo):
    url = subprocess.run(["git", "-C", repo, "remote", "get-url", "origin"], capture_output=True, text=True).stdout.strip()
    m = re.search(r"github\.com[:/]([^/]+/[^/.]+?)(?:\.git)?$", url)
    return m.group(1) if m else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("work")
    ap.add_argument("--topics", help="directory of <concern-id>.json topic files")
    ap.add_argument("--briefs", action="store_true", help="write one Markdown brief per concern and stop")
    args = ap.parse_args()
    work = Path(args.work)
    collect = json.load(open(work / "collect.json"))
    spec = json.load(open(work / "concerns.json"))
    concerns = spec["concerns"]
    topics_dir = Path(args.topics) if args.topics else work / "topics"
    for con in concerns:
        f = topics_dir / f"{con['id']}.json"
        if not con.get("topics") and f.exists():
            con["topics"] = json.load(open(f)).get("topics", [])
        con.setdefault("topics", [])

    by_prefix = {}
    for c in collect["commits"]:
        for k in range(7, 41):
            by_prefix.setdefault(c["sha"][:k], c["sha"])
    cited = {}
    for con in concerns:
        for t in con["topics"]:
            full = []
            for s in t.get("shas", []):
                sha = by_prefix.get(s)
                if sha:
                    full.append(sha)
                    cited.setdefault(sha, con["id"])
                else:
                    print(f"warning: {con['id']}: {s} is not a commit in this range", file=sys.stderr)
            t["shas"] = full

    owner = matcher(concerns)
    commits = {}
    for c in collect["commits"]:
        cid = cited.get(c["sha"])
        if not cid:
            weight = {}
            for a, r, p in c["files"]:
                o = owner(p)
                if o:
                    weight[o] = weight.get(o, 0) + (a + r + 1) * (0.05 if LIGHT.search(p) else 1)
            cid = max(weight, key=weight.get) if weight else "other"
        files = sorted(([p, a, r] for a, r, p in c["files"] if not SKIP_FILES.search(p)), key=lambda f: -(f[1] + f[2]))
        s = (c.get("sessions") or [{}])[0]
        commits[c["sha"]] = {
            "s": c["subject"], "d": c["date"][:10], "c": cid, "cited": c["sha"] in cited,
            "a": sum(a for a, _, _ in c["files"]), "r": sum(r for _, r, _ in c["files"]), "f": len(c["files"]), "fl": files[:8],
            "b": (c.get("body") or "").strip()[:1200], "ask": (s.get("ask") or "")[:400], "sid": c.get("sid"),
        }
    if args.briefs:
        out = work / "briefs"
        out.mkdir(exist_ok=True)
        sessions = collect.get("sessions", {})
        for con in concerns + [{"id": "other", "name": "Everything else", "gist": "", "paths": []}]:
            mine = [c for c in collect["commits"] if commits[c["sha"]]["c"] == con["id"]]
            if not mine:
                continue
            lines = [f"# {con['name']} ({con['id']})", "", con.get("gist", ""), "", f"Paths: {', '.join(con.get('paths', [])) or 'none'}", f"{len(mine)} commits, oldest first.", ""]
            for c in mine:
                v = commits[c["sha"]]
                lines.append(f"## {c['short']} {c['date'][:10]} {c['subject']}  (+{v['a']} -{v['r']}, {v['f']} files)")
                if v["sid"]:
                    ss = sessions.get(v["sid"], {})
                    lines.append(f"Session: {ss.get('title') or 'untitled'} ({v['sid']})")
                if v["ask"]:
                    lines.append("> asked: " + " ".join(v["ask"].split())[:400])
                if v["b"]:
                    lines.append(" ".join(v["b"].split())[:700])
                lines.append("Files: " + ", ".join(p for p, _, _ in v["fl"][:6]))
                lines.append("")
            (out / f"{con['id']}.md").write_text("\n".join(lines))
        print(json.dumps({"briefs": str(out), "per_concern": {k: sum(1 for v in commits.values() if v["c"] == k) for k in {v["c"] for v in commits.values()}}}))
        return
    if any(v["c"] == "other" for v in commits.values()):
        concerns.append({"id": "other", "name": "Everything else", "icon": "dots-three-outline", "gist": "Commits no concern's paths claim.", "paths": [], "topics": []})

    dates = sorted(v["d"] for v in commits.values())
    data = {
        "title": spec["title"], "summary": spec.get("summary", ""), "repo": github_slug(collect["repo"]),
        "range": {"base": collect["base"], "head": collect["head"], "first": dates[0] if dates else "", "last": dates[-1] if dates else "", "grep": collect.get("grep")},
        "concerns": concerns, "commits": commits, "sessions": collect.get("sessions", {}),
    }
    (work / "data.json").write_text(json.dumps(data, separators=(",", ":")))
    groups = {"name": work.name, "base": collect["base"], "head": collect["head"],
              "groups": [{"id": c["id"], "title": c["name"], "paths": c.get("paths", [])} for c in concerns if c.get("paths")]}
    (work / "groups.json").write_text(json.dumps(groups, indent=1))
    counts = {c["id"]: sum(1 for v in commits.values() if v["c"] == c["id"]) for c in concerns}
    print(json.dumps({"data": str(work / "data.json"), "commits": len(commits), "per_concern": counts,
                      "topics": sum(len(c["topics"]) for c in concerns), "sessions": len(data["sessions"])}))


if __name__ == "__main__":
    main()
