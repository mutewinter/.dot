#!/usr/bin/env python3
"""Write one Markdown brief per review group from collect.json and review_ref.py's output.

Usage: group_inputs.py <collect.json> <ref.json> <out-dir>

Each <out-dir>/<group-id>.md lists the group's files (with signals and newly
exported names), the commits that touched them oldest first (subject, trimmed
body, and the human ask the transcript join recovered), and the files touched
by the most commits, which is where the design moved around.
"""

import json
import sys
from collections import Counter
from pathlib import Path


def trim(text, n):
    text = " ".join((text or "").split())
    return text if len(text) <= n else text[: n - 1] + "…"


def main():
    collect = json.load(open(sys.argv[1]))
    ref = json.load(open(sys.argv[2]))
    out = Path(sys.argv[3])
    out.mkdir(parents=True, exist_ok=True)
    by_path = {f["path"]: f for f in collect["files"]}
    ordered = list(ref["groups"].items())
    prev = ref["base"]
    for gid, g in ordered:
        files = set(g["files"])
        commits = [c for c in collect["commits"] if any(p in files for _, _, p in c["files"])]
        touches = Counter(p for c in commits for _, _, p in c["files"] if p in files)
        add = sum(by_path[p]["add"] for p in files if p in by_path)
        dele = sum(by_path[p]["del"] for p in files if p in by_path)
        lines = [
            f"# {g['title']} ({gid})",
            "",
            f"Review commit {g['sha']} (diff it against {prev}: `git diff {prev[:12]} {g['sha'][:12]}`).",
            f"{len(files)} files, +{add} / -{dele}, {len(commits)} commits touch them.",
            "",
            "## Files",
            "",
        ]
        for p in sorted(files, key=lambda p: -(by_path.get(p, {}).get("add", 0) + by_path.get(p, {}).get("del", 0))):
            f = by_path.get(p, {"status": "?", "add": 0, "del": 0, "kind": "?", "signals": []})
            extra = []
            if f.get("signals"):
                extra.append("signals: " + ", ".join(f["signals"]))
            if f.get("new_exports"):
                extra.append("exports: " + ", ".join(f["new_exports"][:12]))
            lines.append(f"- {f['status']} `{p}` +{f['add']}/-{f['del']} {f['kind']}" + (f" ({'; '.join(extra)})" if extra else ""))
        lines += ["", "## Most-touched files (design still moving)", ""]
        lines += [f"- `{p}`: {n} commits" for p, n in touches.most_common(12) if n > 2]
        lines += ["", "## Commits, oldest first", ""]
        for c in commits:
            lines.append(f"### {c['short']} {c['date'][:16]} {c['subject']}")
            if c["body"]:
                lines.append(trim(c["body"], 700))
            for s in c.get("sessions", [])[:1]:
                lines.append(f"> asked {str(s.get('ask_at') or '')[:16]}: {trim(s['ask'], 400)}")
                lines.append(f"> transcript: {s['transcript']}:{s['line']}")
            lines.append("")
        (out / f"{gid}.md").write_text("\n".join(lines))
        prev = g["sha"]
    print(json.dumps({gid: str(out / f"{gid}.md") for gid, _ in ordered}))


if __name__ == "__main__":
    main()
