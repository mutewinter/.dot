---
name: visual-answer
description: When the user says "visual answer" or asks for a question answered or work explained visually, they mean this exact skill; invoke it rather than improvising a format. Also use it unprompted whenever a concept, change, plan, or result is complex enough to benefit from a visual treatment; err on that side, since a reader is never sad to receive one. It creates a tailored, single-file HTML page with diagrams, evidence, and forms the reader answers on the page, covering code changes, architecture, plans, incidents, comparisons, decisions, and product behavior.
---

# Visual answer

Create one HTML artifact whose form follows the question. This is a flexible explanatory canvas, not a fixed report, wireframe, slide deck, or exhaustive diff viewer.

The artifact is the primary reading surface. The reader often skips the conversation entirely, so every decision-relevant finding, recommendation, and open question belongs in the page, not only in chat.

## Make the artifact

1. Identify the exact thing the reader is trying to understand or decide. Use context and evidence already available in the task, inspecting only the additional source needed to avoid guessing.
2. Choose the output path before writing. When `docs/visual-answers/` already exists under the repository root, the repository has opted in and is normally ignoring them in git, so write there as `YYYY-MM-DD-<topic>.html`. In a git worktree, check the main checkout: the directory is gitignored so a fresh worktree never contains it, and when the main checkout has it, `mkdir` in the worktree preserves the opt-in. When the repository has not opted in, write to `~/visual-answers/` (create it if missing); never the OS temp directory, whose folders editors refuse to trust. Honor a different path when the user names one.
3. Tag the page on the `<header>` element you write, with two attributes. `data-project="<repo, product, or subject>"` says where the work came from, since every page on this machine lands in one folder. `data-thread="<two or three words naming this conversation>"` ties the pages of one conversation together: pick it on the first page and repeat it verbatim on every later page of the same conversation, even when the subject drifts. Say the thread name in the kicker too, so it is visible on the page rather than buried in an attribute; the template also tints the favicon from it, which is how several pages of one conversation read as a set in a row of browser tabs. Leaf shows and filters on both.
4. `cp` the template, then make one Edit. The placeholders are the `<header>` block containing `TITLE` and `THESIS` and the scaffold `<section>` under the "Replace this scaffold" comment, together spanning roughly lines 139-150 of the copy; Read that span and replace the whole run, header through scaffold, in a single Edit. Do not read the rest of the template, rebuild its theme shell, assemble the body with shell heredocs (anchor mismatches and worktree sandboxes both break them), or Write the whole file (it repays the theme shell and trips the read-before-write rule).
5. Give top-level sections `id`s and real `h2`s. An orientation strip across the very top of the page builds itself from them, carrying the document title and marking the current section as the reader scrolls (`data-short` on an `h2` shortens its label); pages with fewer than four such sections get no strip, which is correct for them. The strip is deliberately one level; a section that grows to many screenfuls should be split, not sub-indexed.
6. When the explanation shows real product UI or rendered output, prefer captured images over redrawn approximations: land them in an `assets/` directory beside the artifact and reference them relatively. They render when the page opens as a file in the browser, not in app preview panes, and they are snapshots, so date them or re-shoot on revision.
7. Return a direct link to the HTML file and a one-sentence description of what it explains.

## Title it with its subject

Name the page after what it is about, and stop there: `Feedback knowledge base`, `1.6.9 test plan`, `Wayfair session post-mortem`, `PR 102 merge behavior`. A noun phrase, the way you would name a folder.

The finding, the verdict and the argument go in the thesis paragraph directly beneath the title, which is where they already read well. Do not put them in the title, and never append them to the subject as a clause: `The block was never a rate limit` and `Feedback knowledge base: Notion, not a repo` both read beautifully to whoever just finished the page and are unrecognizable to the same person a week later. A list of such titles cannot be skimmed at all, because every line has a different shape and none of them names a subject.

The filename is that subject, dated: `YYYY-MM-DD-<subject>.html`. When a later round sharpens what the page is really about, rename the title and the file together; a better name later is worth more than a stable one.

## Keep the latitude

There are no required sections, length, navigation, number of panels, or interactions. Do not automatically add background, a table of contents, a quiz, metrics, or a file-by-file walkthrough. Lead with the answer and prefer selective depth over exhaustive coverage.

If three consecutive sections are coming out as prose lists, stop and reshape them into a diagram, sequence, table, or ledger. Long runs of text-shaped content are the single most common reader complaint with these artifacts.

Vary the volume. The bordered card is the focal layer, not the default wrapper: sections that support rather than decide can sit directly on the page background with tighter type and no chrome. Reserve toned fills, colored borders, and status color for the few elements carrying the verdict; when every panel is a card and every card is loud, nothing reads as important.

Respect the column. `main` is deliberately modest (`max-w-4xl`): these pages are read on laptops, and long lines defeat scanning. Structural elements (cards, grids, tables, figures) span the column; prose paragraphs cap near `max-w-3xl` for measure; wide tables and diagrams scroll inside their own overflow container rather than widening the page. Do not widen `main`, and do not leave blocks stranded at assorted widths.

Distinguish depicted content from commentary. When a panel shows a thing (a slide, a UI, a transcript), annotations about it get a visibly distinct treatment and sit outside the depicted surface (the coach-mark idiom in `references/patterns.md`), so the reader never wonders whether a label is part of the thing shown.

For code changes, establish the relevant scope and distinguish implemented behavior from plans or open questions, but do not turn artifact creation into a separate code review or audit. Use focused code or diff excerpts only when exact syntax matters.

Label inference as inference. If evidence is incomplete or contradictory, show that uncertainty rather than smoothing it away.

## Reference files, read on demand

The `references/` directory holds canonical spellings and recipes. They are vocabulary, not layout: starting points to restyle freely, never a required structure. Read the ones whose form is in play, not all of them.

- `references/patterns.md`: the recurring vocabulary. Kicker labels, status pills, step circles, emphasis cards, terminal blocks, ledger openers, decision endings, evidence footers, coach marks. Worth reading for almost any page.
- `references/charts.md`: bar rows, meters, waffles, sparklines, timelines, when to reach for Chart.js, and the normalization rule. Read whenever anything is quantified.
- `references/diagrams.md`: the SVG kit. Scroll wrappers, theme fills, arrowheads, swimlanes, and when HTML/CSS beats coordinate SVG. Read when geometry matters.
- `references/interaction.md`: the sidebar TOC, answer forms, runbook ticks, the screenshot comparator, click to enlarge, details/summary, generator JavaScript, and the narrow case for tabs. Read when the page is long, dense, or comparative, or when it asks the reader to decide or execute something.

Four rules that apply even without reading the references:

- **What the shell provides.** Trust this roster instead of reading the template: color scales `gray` and `brand` (25 through 950) and `error`/`warning`/`success`/`yellow`/`brown` (50/100/300/500/700/900); semantic tokens `background`, `foreground`, `card`, `popover`, `muted`, `muted-foreground`, `accent`, `primary`, `secondary`, `destructive`, `border`, `input`, `ring`; fonts Inter (`font-sans`) and JetBrains Mono (`font-mono`); Phosphor `ph` (regular) and `ph-fill`; automatic syntax highlighting for `pre > code` blocks (see the code-excerpt pattern). Light theme only, by design; there is no dark mode to defend against.

- **Color.** Status is always the theme's `success`/`error`/`warning`/`brand` tokens, never raw Tailwind emerald/rose/red/amber. In SVG, use `fill-*`/`stroke-*` utility classes or `style="fill: var(--color-…)"`; presentation attributes cannot resolve `var()`, and hardcoded hex drifts from the theme.
- **Generated markup.** Small local JavaScript is welcome both for interaction that materially helps and for generating repeated structure from a data array (matrices, waffles, chart marks, rings). Never hand-repeat markup a ten-line loop can emit; conversely, hand-write elements whose instances carry heterogeneous content (decision cards, verdict cards). Generated markup renders on load and gates nothing, so it may carry decision-relevant content. Place page scripts at the end of the inserted body, inside `main`; they share one global scope with the template's trailing script (which owns `heading`, `tocSections`, `toc`, and `spy`), so name bindings something else.
- **Micro-lint.** The recurring authoring bugs: an unclosed bracket in an arbitrary value (`tracking-[-0.02em]`), template-literal syntax leaking into plain HTML, and Phosphor weights other than `ph` (regular) and `ph-fill`, the only two the template loads.

## When the artifact is one of a series

A design conversation often returns to the same subject. Whether a later round edits the existing page or writes a new one is yours to judge: editing keeps one name for a subject that is still moving, and a new page earns its place when the decision changed enough that the earlier round is worth keeping beside it. A few things earn their place in this mode and nowhere else:

- **Open with a settled-versus-cut ledger.** A compact grid of what is now decided and what has been dropped, so the reader confirms the shared state before reading the argument. It replaces recapping the previous artifact in prose.
- **Say plainly when you are reversing your own earlier recommendation, and on what new information.** A revision that quietly changes position makes the reader re-derive which version they are holding.
- **Link back to the previous round** near the top, by relative filename. When the predecessor is missing or lives elsewhere, name it in text rather than linking a dead path. Relative links resolve when the page is opened as a file in the browser but not in app preview panes, so keep the filename in the visible text too.
- **Calibrate against a real reference implementation** when one exists, and verify rather than recall it. Comparing against how a known product actually behaves is usually more decisive than reasoning from first principles, and it can turn out to support the opposite conclusion.
- **Keep the open questions last and shrinking.** Lead with the answer while the design is still moving; once it has converged, a short list of what is genuinely undecided is the most useful ending.
- **Add a section for what the reader said they might be forgetting**, when they say so. Adjacent consequences they have not asked about are often the highest-value part of a late round.

## Embedding a wireframe

This section applies only where a `product-wireframe` skill is available. When the explanation needs to show product UI, build it once with that skill and embed that file, rather than redrawing the same frames inline. Hand-rolled UI in an explanation drifts from the app on details the kit already gets right, and building it twice is paid for twice.

Embed with `srcdoc`, carrying the whole wireframe document escaped into the attribute:

```python
html.escape(pathlib.Path(wireframe_path).read_text(), quote=True)
```

`src="./wireframes-topic.html"` does **not** work. Chrome refuses to load a sibling local file into an iframe, so from `file://` the frame renders blank with no error and it looks like the idea is unworkable. `srcdoc` involves no origin, so it always renders, and the wireframe's own scripts run: frames scale to the iframe's width and enlarge-on-click works.

The separate document is the point. Both templates ship their own Tailwind build and `@theme` block, so splicing wireframe markup into the page instead would collide, and the frame-measuring script would measure the wrong container.

Three rules:

- **Embed frames that are small at true size; link the ones that are not.** Enlarge-on-click is bounded by the iframe, so a 1280x800 window state cannot open to full size inside one. A conversation-width frame at 720 is fine; a whole-window flow stays its own file with a sentence pointing at it.
- **The embedded copy is a snapshot.** Revising the wireframe afterwards leaves the page silently stale, so re-embed on every revision or do not embed it.
- **Open the explanation only.** The wireframe is already on screen inside it, and opening both puts two tabs up for one thing to look at.

## End with the decisions

When the work leaves anything genuinely open, end the page with a decision block: one card per decision, a plain-word handle naming its subject (never a coined label the reader must decode), and a recommendation chip on each. Readers report reading this block every time, so a decision left out of it is a decision that silently defaults.

## Hand off quickly

Treat the artifact as a single-use visual answer for the human reading it now. Wherever it lands, it is not history and nothing has to be pruned; if one should outlive the conversation, the user will ask for it to be committed or for its content to move into a durable doc under `docs/`. Open it when it is written (`open <path>` on macOS) so it is on screen rather than waiting to be found, unless the user has said not to.

After writing, a placeholder grep (`TITLE|THESIS|Build the explanation here`) is enough verification for ordinary pages. When the page carries positioned SVG beyond a dozen nodes or nontrivial generated markup, one headless render check at default width is allowed: take a single screenshot, fix what it shows, stop. Beyond that, do not take screenshots, test multiple widths, run theme synchronization, audit the content, or iterate on visual details unless the user explicitly asks or the creation step reported a concrete error. Do not knowingly include secrets or private operational data.

Where the `product-wireframe` skill is vendored into the repository, its theme synchronizer is maintenance tooling for changes to the template or the product theme, not part of ordinary artifact creation:

```bash
node .agents/skills/product-wireframe/scripts/sync-theme.ts --check
```
