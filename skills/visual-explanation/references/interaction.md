# Interaction: orient, never gate

The governing principle: vertical scroll is how the reader discovers what a page contains. Interaction that helps them orient (a sidebar that tracks position) or tuck away supporting depth (a labeled collapsible) earns its place; interaction that gates load-bearing content behind a click is a liability, because content the reader never clicks is content they never see.

## Sidebar table of contents: automatic

The template builds a left scrollspy sidebar on wide viewports from every `main > section[id]` that has an `h2`, and skips pages with fewer than four. You get it by writing real sections with ids, which the page wants anyway for anchors. `data-short="Label"` on an `h2` shortens its sidebar label; omitting ids on minor sections keeps them out. Do not build a second navigation on top of it.

## details/summary: use sparingly

Field observation from real readers: collapsed regions go unnoticed entirely, even on a third read. Default to showing a trimmed version in the open: the top rows plus a count, with a sentence naming what was elided. Reach for details only for appendix-grade material near the end of the page, write the summary line to carry the payload's headline number, and accept that most readers will never open it; nothing that changes a decision goes inside one.

```html
<details class="group rounded-xl border border-border bg-card shadow-sm">
  <summary class="flex cursor-pointer items-center gap-2 p-5 text-sm font-medium select-none">
    <i class="ph ph-caret-right transition-transform group-open:rotate-90"></i>
    All 21 per-suite timings · slowest is e2e-checkout at 14m
  </summary>
  <div class="px-5 pb-5">…the table…</div>
</details>
```

## Generator JavaScript

Blessed, and distinct from interaction: a script that emits repeated markup from a data array (bar rows, matrices, waffles, radial layouts). See `charts.md` and `diagrams.md` for recipes. The test: if you are about to paste the third near-identical sibling, generate instead.

## Hover linking

Optional garnish for dense figures: hovering a legend entry dims unrelated marks (toggle an `opacity-30` class on non-matching `data-series` elements). Never make hover the only way to read a value.

## Tabs: the narrow case

Default to stacking content vertically. Tabs are justified only when the panels are true alternatives, where the reader picks one and the others become irrelevant: the same integration shown per candidate API, per-OS instructions, one worked example in three formats. Never tab sequential content or comparisons the reader should see together. When a tabbed panel carries part of the argument, the argument must also appear un-gated elsewhere on the page; the tabs then hold only the per-variant rendering. (Generated markup is different: it renders on load and gates nothing, so it may carry decision-relevant content.) When in doubt, stack.

```html
<div data-tabs>
  <div role="tablist" class="flex flex-wrap gap-1 border-b border-border">
    <button data-tab="a" aria-selected="true" class="rounded-t-lg border border-b-0 border-transparent px-3.5 py-2 text-sm text-muted-foreground aria-selected:border-border aria-selected:bg-background aria-selected:font-medium aria-selected:text-foreground">macOS</button>
    <button data-tab="b" aria-selected="false" class="rounded-t-lg border border-b-0 border-transparent px-3.5 py-2 text-sm text-muted-foreground aria-selected:border-border aria-selected:bg-background aria-selected:font-medium aria-selected:text-foreground">Linux</button>
  </div>
  <div data-panel="a" class="p-4 text-sm leading-6">…</div>
  <div data-panel="b" hidden class="p-4 text-sm leading-6">…</div>
</div>
<script>
  document.querySelectorAll("[data-tabs]").forEach((root) => {
    const tabs = root.querySelectorAll("[data-tab]");
    tabs.forEach((btn) => btn.addEventListener("click", () => {
      tabs.forEach((b) => b.setAttribute("aria-selected", b === btn ? "true" : "false"));
      root.querySelectorAll("[data-panel]").forEach((p) => (p.hidden = p.dataset.panel !== btn.dataset.tab));
    }));
  });
</script>
```
