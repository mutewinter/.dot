#!/usr/bin/env python3
"""Render digest.json into one self-contained HTML page.

Usage: render.py <digest.json> <out.html>

The page has no network dependencies. Reviewed checkboxes persist per review
ref in localStorage. Every "disagree" button copies a task prompt carrying the
group, review commit and decision, ending where the reader dictates the
objection.
"""

import html
import json
import re
import sys

CSS = """
:root{--bg:#fbfaf8;--fg:#1c1b19;--muted:#6b675f;--line:#e6e2db;--card:#fff;--accent:#2f5bd3;--accent-bg:#eaf0ff;--warn:#9a5b00;--warn-bg:#fff4e0;--bad:#b42318;--bad-bg:#fdecea;--ok:#1f7a3d;--ok-bg:#e8f5ec;--code:#f3f1ec}
@media (prefers-color-scheme:dark){:root{--bg:#141413;--fg:#eceae4;--muted:#a19d94;--line:#2c2b28;--card:#1c1b19;--accent:#8fb0ff;--accent-bg:#1f2a44;--warn:#f3b65b;--warn-bg:#3a2c12;--bad:#ff8a80;--bad-bg:#3d1d1a;--ok:#7fd49b;--ok-bg:#163222;--code:#262522}}
*{box-sizing:border-box}html{scroll-padding-top:16px}
body{margin:0;background:var(--bg);color:var(--fg);font:15px/1.55 -apple-system,BlinkMacSystemFont,"Inter","Segoe UI",sans-serif}
code,.mono{font-family:ui-monospace,"JetBrains Mono",SFMono-Regular,Menlo,monospace;font-size:.86em}
code{background:var(--code);padding:.05em .35em;border-radius:4px}
a{color:var(--accent);text-decoration:none}a:hover{text-decoration:underline}
.layout{display:grid;grid-template-columns:260px minmax(0,1fr);gap:32px;max-width:1240px;margin:0 auto;padding:32px 20px 80px}
@media (max-width:900px){.layout{grid-template-columns:1fr}nav.side{position:static!important;max-height:none!important}}
nav.side{position:sticky;top:16px;align-self:start;max-height:calc(100vh - 32px);overflow:auto;font-size:13px}
nav.side ol{list-style:none;padding:0;margin:8px 0 0}nav.side li{display:flex;gap:8px;align-items:flex-start;padding:5px 6px;border-radius:6px}
nav.side li:hover{background:var(--code)}nav.side li.done a{color:var(--muted);text-decoration:line-through}
nav.side .n{color:var(--muted);font-variant-numeric:tabular-nums;min-width:1.6em}
.kicker{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:var(--muted);font-weight:600}
h1{font-size:30px;letter-spacing:-.02em;margin:6px 0 8px}h2{font-size:21px;letter-spacing:-.01em;margin:0}
.lede{color:var(--muted);max-width:72ch}.lede p{margin:.5em 0}
.stats{display:flex;flex-wrap:wrap;gap:8px;margin:16px 0}.stat{border:1px solid var(--line);background:var(--card);border-radius:10px;padding:8px 12px}
.stat b{display:block;font-size:18px;font-variant-numeric:tabular-nums}.stat span{font-size:12px;color:var(--muted)}
.box{border:1px solid var(--line);background:var(--card);border-radius:12px;padding:16px 18px;margin:18px 0}
.cmd{display:flex;gap:8px;align-items:center;margin:6px 0;flex-wrap:wrap}.cmd code{flex:1;min-width:0;overflow-x:auto;white-space:nowrap;padding:6px 8px}
button{font:inherit;font-size:12px;border:1px solid var(--line);background:var(--card);color:var(--fg);border-radius:6px;padding:4px 9px;cursor:pointer}
button:hover{border-color:var(--accent);color:var(--accent)}button.copied{color:var(--ok);border-color:var(--ok)}
.start li{margin:6px 0}
section.group{border:1px solid var(--line);background:var(--card);border-radius:14px;padding:20px 22px;margin:22px 0}
.ghead{display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;align-items:baseline}
.gmeta{color:var(--muted);font-size:12px}.summary{max-width:75ch}
.asks{border-left:3px solid var(--line);padding-left:12px;color:var(--muted);font-size:14px;margin:12px 0}
.decision{border:1px solid var(--line);border-radius:10px;padding:12px 14px;margin:10px 0}
.decision .row{display:grid;grid-template-columns:110px minmax(0,1fr);gap:4px 12px;font-size:14px}
.decision .k{color:var(--muted);font-size:11px;letter-spacing:.08em;text-transform:uppercase;padding-top:3px}
.decision ul{margin:0;padding-left:18px}.decision .top{display:flex;justify-content:space-between;gap:10px;align-items:flex-start;margin-bottom:8px}
.decision .top strong{font-size:15px}
.pill{display:inline-block;font-size:11px;font-weight:600;border-radius:999px;padding:1px 8px;white-space:nowrap}
.p-rec{background:var(--ok-bg);color:var(--ok)}.p-inf{background:var(--warn-bg);color:var(--warn)}
.p-S1,.p-S2{background:var(--bad-bg);color:var(--bad)}.p-S3,.p-S4{background:var(--code);color:var(--muted)}
.ahead{border:1px solid var(--accent);background:var(--accent-bg);border-radius:10px;padding:12px 14px;margin:14px 0}
.ahead h4,.sub h4{margin:0 0 6px;font-size:12px;letter-spacing:.1em;text-transform:uppercase}
.ahead h4{color:var(--accent)}.ahead li{margin:6px 0}
.cols{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:14px;margin-top:14px}
.sub{font-size:14px}.sub h4{color:var(--muted)}.sub ul,.sub ol{margin:0;padding-left:18px}.sub li{margin:3px 0}
details{margin-top:14px;border-top:1px solid var(--line);padding-top:10px}summary{cursor:pointer;color:var(--muted);font-size:13px}
.finding{margin:8px 0;font-size:14px}.actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:14px;padding-top:12px;border-top:1px solid var(--line)}
label.done{display:flex;gap:6px;align-items:center;font-size:13px;color:var(--muted);cursor:pointer}
footer{color:var(--muted);font-size:12px;margin-top:40px;max-width:80ch}
"""

JS = """
const KEY='review-digest:'+document.body.dataset.ref;
let done={};try{done=JSON.parse(localStorage.getItem(KEY)||'{}')}catch(e){}
function paint(){document.querySelectorAll('[data-gid]').forEach(el=>{const g=el.dataset.gid;
 if(el.matches('input'))el.checked=!!done[g];else el.classList.toggle('done',!!done[g])})}
document.addEventListener('change',e=>{if(e.target.matches('input[data-gid]')){done[e.target.dataset.gid]=e.target.checked;
 try{localStorage.setItem(KEY,JSON.stringify(done))}catch(_){} paint()}});
async function copy(text,btn){try{await navigator.clipboard.writeText(text)}catch(_){const t=document.createElement('textarea');
 t.value=text;document.body.appendChild(t);t.select();document.execCommand('copy');t.remove()}
 const o=btn.textContent;btn.textContent='Copied';btn.classList.add('copied');setTimeout(()=>{btn.textContent=o;btn.classList.remove('copied')},1400)}
document.addEventListener('click',e=>{const b=e.target.closest('button[data-copy]');if(b)copy(b.dataset.copy,b)});
paint();
"""


def inline(text):
    out = html.escape(str(text or ""))
    return re.sub(r"`([^`]+)`", r"<code>\1</code>", out)


def copy_button(label, text):
    return f'<button data-copy="{html.escape(text, quote=True)}">{html.escape(label)}</button>'


def li(items):
    return "".join(f"<li>{inline(i)}</li>" for i in items)


def render_group(g, d):
    gid, n = g["id"], g.get("n", "")
    sha = g.get("sha", "")
    ctx = f"Review digest {d['open']['ref']}, group {n} \"{g['title']}\" (review commit {sha[:12]}, range {d['range']['base'][:12]}..{d['range']['head'][:12]})."
    parts = [f'<section class="group" id="{gid}">']
    parts.append(
        f'<div class="ghead"><h2><span class="mono" style="color:var(--muted)">{n:02d}</span> {inline(g["title"])}</h2>'
        f'<label class="done"><input type="checkbox" data-gid="{gid}"> reviewed</label></div>'
        if isinstance(n, int) else f'<div class="ghead"><h2>{inline(g["title"])}</h2></div>'
    )
    meta = [f"{g.get('files_count', '?')} files"]
    if g.get("commits_count"):
        meta.append(f"{g['commits_count']} commits")
    if sha:
        meta.append(f"review commit <span class='mono'>{sha[:9]}</span>")
    parts.append(f'<p class="gmeta">{" &middot; ".join(meta)}</p>')
    parts.append(f'<p class="summary">{inline(g.get("summary"))}</p>')
    if g.get("asks"):
        parts.append('<div class="asks"><div class="kicker">What you asked for</div><ul>' + li(g["asks"][:5]) + "</ul></div>")
    for dec in g.get("decisions", []):
        basis = dec.get("basis", "inferred")
        pill = f'<span class="pill {"p-rec" if basis == "recorded" else "p-inf"}">{html.escape(basis)}</span>'
        prompt = f"{ctx} Decision: {dec.get('decided')} My objection: "
        rows = []
        if dec.get("rejected"):
            rows.append(f'<div class="k">Rejected</div><div><ul>{li(dec["rejected"])}</ul></div>')
        if dec.get("commits_to"):
            rows.append(f'<div class="k">Commits to</div><div><ul>{li(dec["commits_to"])}</ul></div>')
        if dec.get("evidence"):
            rows.append(f'<div class="k">Evidence</div><div>{inline(dec["evidence"])}</div>')
        parts.append(
            f'<div class="decision"><div class="top"><strong>{inline(dec.get("decided"))}</strong>'
            f'<span style="display:flex;gap:6px;align-items:center">{pill}{copy_button("Disagree", prompt)}</span></div>'
            f'<div class="row">{"".join(rows)}</div></div>'
        )
    if g.get("two_steps_down"):
        items = "".join(
            f'<li><strong>{inline(t.get("concern"))}</strong> <span class="gmeta">vs {inline(t.get("against"))}</span><br>{inline(t.get("why"))}</li>'
            for t in g["two_steps_down"]
        )
        parts.append(f'<div class="ahead"><h4>Two steps down</h4><ul>{items}</ul></div>')
    cols = []
    if g.get("questions"):
        cols.append(f'<div class="sub"><h4>Can you answer these?</h4><ol>{li(g["questions"])}</ol></div>')
    if g.get("hotspots"):
        cols.append('<div class="sub"><h4>Still moving</h4><ul>' + "".join(f'<li><code>{html.escape(h.get("path", ""))}</code> {inline(h.get("note"))}</li>' for h in g["hotspots"][:6]) + "</ul></div>")
    if g.get("read_order"):
        cols.append(f'<div class="sub"><h4>Read in this order</h4><ol>{"".join(f"<li><code>{html.escape(p)}</code></li>" for p in g["read_order"])}</ol></div>')
    if g.get("tests"):
        cols.append(f'<div class="sub"><h4>Tests</h4><p style="margin:0">{inline(g["tests"])}</p></div>')
    if cols:
        parts.append(f'<div class="cols">{"".join(cols)}</div>')
    if g.get("findings"):
        fs = "".join(
            f'<div class="finding"><span class="pill p-{html.escape(f.get("severity", "S4"))}">{html.escape(f.get("severity", ""))}</span> '
            f'<code>{html.escape(f.get("where", ""))}</code> {inline(f.get("text"))} <span class="gmeta">({html.escape(f.get("basis", ""))})</span></div>'
            for f in g["findings"]
        )
        parts.append(f'<details><summary>{len(g["findings"])} findings, folded so they do not steer your reading</summary>{fs}</details>')
    if g.get("key_commits"):
        parts.append('<details><summary>Key commits</summary><ul>' + "".join(f'<li><span class="mono">{html.escape(c.get("short", ""))}</span> {inline(c.get("subject"))}</li>' for c in g["key_commits"]) + "</ul></details>")
    actions = []
    if sha:
        actions.append(copy_button("Copy hunk command", f"hunk show {sha[:12]}"))
        actions.append(copy_button("Copy git show --stat", f"git show --stat {sha[:12]}"))
    actions.append(copy_button("Walk me through this", f"{ctx} Walk me through this group in hunk: I have `hunk show {sha[:12]}` open. Drive the session in the read order from the digest and highlight what matters."))
    actions.append(copy_button("Disagree with the group", f"{ctx} My objection: "))
    parts.append(f'<div class="actions">{"".join(actions)}</div></section>')
    return "".join(parts)


def main():
    d = json.load(open(sys.argv[1]))
    s = d["stats"]
    o = d["open"]
    nav = "".join(
        f'<li data-gid="{g["id"]}"><span class="n">{g.get("n", "")}</span><a href="#{g["id"]}">{inline(g["title"])}</a></li>' for g in d["groups"]
    )
    cmds = []
    if o.get("worktree"):
        cmds.append(("All groups as commits in lazygit", f"lazygit -p {o['worktree']} log"))
    cmds.append(("The group chain", f"git log --oneline {o['ref']} -{len(d['groups'])}"))
    cmd_html = "".join(f'<div class="cmd"><span class="gmeta" style="min-width:220px">{html.escape(label)}</span><code>{html.escape(c)}</code>{copy_button("Copy", c)}</div>' for label, c in cmds)
    start = ""
    if d.get("start_here"):
        start = '<div class="box start"><div class="kicker">Start here</div><ol>' + "".join(
            f'<li><a href="#{html.escape(t["group"])}">{inline(t["text"])}</a></li>' for t in d["start_here"]
        ) + "</ol></div>"
    body = f"""<body data-ref="{html.escape(o['ref'])}@{html.escape(o.get('tip', '')[:12])}"><div class="layout">
<nav class="side"><div class="kicker">Groups, reading order</div><ol>{nav}</ol></nav>
<main>
<div class="kicker">Review digest &middot; {html.escape(d.get('repo_name', ''))}</div>
<h1>{inline(d['title'])}</h1>
<div class="lede">{''.join(f'<p>{inline(p)}</p>' for p in d.get('overview', []))}</div>
<div class="stats">
<div class="stat"><b>{s['commits']}</b><span>commits</span></div>
<div class="stat"><b>{s['files']}</b><span>files</span></div>
<div class="stat"><b>+{s['add']:,} / &minus;{s['del']:,}</b><span>lines</span></div>
<div class="stat"><b>{s.get('commits_with_session', 0)}</b><span>commits traced to their session</span></div>
<div class="stat"><b>{len(d['groups'])}</b><span>groups</span></div>
</div>
<div class="box"><div class="kicker">Open the code</div>{cmd_html}
<p class="gmeta" style="margin:8px 0 0">Each group is one synthetic commit on <code>{html.escape(o['ref'])}</code>, so any viewer shows exactly that group. Nothing here is a branch, and nothing was pushed.</p></div>
{start}
{''.join(render_group(g, d) for g in d['groups'])}
<footer>{inline(d.get('footer', ''))}</footer>
</main></div><script>{JS}</script></body>"""
    page = f'<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{html.escape(d["title"])}</title><style>{CSS}</style></head>{body}</html>'
    open(sys.argv[2], "w").write(page)
    print(sys.argv[2])


if __name__ == "__main__":
    main()
