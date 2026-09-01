# Interaction: orient, never gate

The governing principle: vertical scroll is how the reader discovers what a page contains. Interaction that helps them orient (a sidebar that tracks position) or tuck away supporting depth (a labeled collapsible) earns its place; interaction that gates load-bearing content behind a click is a liability, because content the reader never clicks is content they never see.

The second test, which killed two candidates in review: an interaction must give the reader something scrolling cannot. A reply assembled, state remembered, pixels compared, a figure enlarged: those earn their click. A stepper that narrates a diagram already visible, or a filter that dims a list short enough to scan, only re-presents information the reader has; cut those.

## Section orientation: automatic

The TOC exists so the reader knows where they are and what is coming; scrolling stays the interaction, so it must be visible, never tucked behind a button. The template builds it from every `main > section[id]` that has an `h2` (fewer than four sections: nothing), in two forms: at 1500px and wider, the left scrollspy sidebar; below that, down to a phone, a slim sticky strip across the top of the page showing the section names with the current one marked, horizontally scrolling itself to keep the mark in view. Links work in both, but visibility is the point. `data-short="Label"` on an `h2` shortens labels; `data-toc="Short label"` on inner chunk headings adds indented sidebar sub-entries (the strip stays top-level). Do not build a second navigation on top of them.

## Answer form

When the page needs decisions back from the reader, collect them as a form a non-technical reader can follow: they are answering questions, and the result is a reply they hand back to the agent. All of that is said in words on the page, not implied by affordances.

- Each question lives where the reader forms the opinion, never gathered into a quiz at the end: a numbered card, the question in plain language, segmented option buttons, and a note that a second click clears the answer. The what-happens-next explanation ("your answers build a reply at the bottom to paste back into the chat") lives on the first question card, not in the bar.
- A reply bar appears at the bottom of the window once the first answer lands. Its layout is a single-row grid that can never wrap: a compact progress chip ("2/3"), a truncating one-line preview, and one button labeled "Copy reply". Nothing else; instruction text in the bar is what breaks its wrapping.
- What the button copies is not the preview: it is Markdown the receiving agent can parse, opening with a line naming the page and file, then a numbered list with each question's topic and the chosen option in bold, unanswered ones marked as such:

  ```markdown
  Answers from "The answer form, spelled out" (2026-09-01-answer-form-round-two.html):

  1. Form shape: **ship it like this**
  2. Runbook numbering: **leave it to the agent**
  3. Contents button: _unanswered_
  ```

- The page must read complete with the form untouched. The form is how the reply travels; it is never how the argument is made.

Mechanics: option buttons with data attributes, one delegated click handler, preview and Markdown both assembled from `data-topic` and `data-reply` labels, `navigator.clipboard` with a select-the-text fallback. Zero dependencies.

## Runbook ticks

For a plan the reader executes over hours or days: a checkbox per item, a progress meter, and state in localStorage so the page remembers per browser. Number the steps when order matters; whether it does is a per-page judgment, not a default. Wrap every storage read and write in try/catch and render correctly with nothing stored; state never carries anything the page's argument depends on, and a reset control keeps a reused browser honest.

## Real screenshots and the comparator

When the subject is shipped UI or rendered output, capture the real thing into `assets/` beside the artifact and show pixels rather than prose (SKILL.md carries the convention). When two captures are a true before/after of the same region, overlay them with a drag divider: the after image in flow, the before image inside a width-clipped absolute wrapper whose inner img is sized to the container, a divider bar, and pointerdown/move setting the split. Label both sides on the image, and date the captures or re-shoot on revision.

## Click to enlarge

A figure legible at page width but better at full width gets a native `<dialog>`: a labeled button, `showModal()`, click or Esc closes, `backdrop:` tint via Tailwind. Ten lines, no dependencies, and the inline figure stays fully readable for whoever never clicks.

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
