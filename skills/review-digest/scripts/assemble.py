#!/usr/bin/env python3
"""Join collect.json, review_ref.py's output, the per-group JSON and a meta file into digest.json.

Usage: assemble.py <collect.json> <ref.json> <groups-dir> <meta.json> <digest.json>

meta.json: {"title": "...", "overview": ["paragraph"], "start_here": [{"group": "g02", "text": "..."}], "footer": "..."}
Groups appear in review-commit order; a group with no JSON file is listed with
its title and file count only, so a missing write-up is visible rather than silent.
"""

import json
import sys
from pathlib import Path


def main():
    collect, ref = json.load(open(sys.argv[1])), json.load(open(sys.argv[2]))
    groups_dir, meta = Path(sys.argv[3]), json.load(open(sys.argv[4]))
    groups = []
    for gid, r in ref["groups"].items():
        path = groups_dir / f"{gid}.json"
        g = json.load(open(path)) if path.exists() else {"summary": "No write-up for this group."}
        files = set(r["files"])
        g.update({
            "id": gid, "n": r["n"], "sha": r["sha"], "title": g.get("title") or r["title"],
            "files_count": len(files),
            "commits_count": sum(1 for c in collect["commits"] if any(p in files for _, _, p in c["files"])),
        })
        groups.append(g)
    digest = {
        "title": meta["title"], "overview": meta.get("overview", []), "start_here": meta.get("start_here", []), "footer": meta.get("footer", ""),
        "repo_name": Path(collect["repo"]).name,
        "range": {"base": collect["base"], "head": collect["head"]},
        "stats": collect["stats"],
        "open": {"ref": ref["ref"], "tip": ref["tip"], "worktree": ref.get("worktree")},
        "groups": groups,
    }
    Path(sys.argv[5]).write_text(json.dumps(digest, indent=1))
    print(sys.argv[5])


if __name__ == "__main__":
    main()
