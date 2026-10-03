#!/usr/bin/env python3
"""Render build.py's data.json into one HTML page.

Usage: render.py <data.json> <out.html>

The page loads Inter, JetBrains Mono and Phosphor icons from their CDNs and
carries everything else inline. Commit SHAs link to GitHub when origin is a
GitHub remote.
"""

import json
import sys
from html import escape
from pathlib import Path


def main():
    data = json.load(open(sys.argv[1]))
    page = (Path(__file__).resolve().parent.parent / "assets" / "page.html").read_text()
    out = page.replace("__TITLE__", escape(data["title"])).replace("__DATA__", json.dumps(data, separators=(",", ":")).replace("</", "<\\/"))
    Path(sys.argv[2]).write_text(out)
    print(sys.argv[2], f"{len(out) // 1024} KB")


if __name__ == "__main__":
    main()
