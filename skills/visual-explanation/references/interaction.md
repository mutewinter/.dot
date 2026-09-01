# Interaction: orient, never gate

The governing principle: vertical scroll is how the reader discovers what a page contains. Interaction that helps them orient (a sidebar that tracks position) or tuck away supporting depth (a labeled collapsible) earns its place; interaction that gates load-bearing content behind a click is a liability, because content the reader never clicks is content they never see.

The second test, which killed two candidates in review: an interaction must give the reader something scrolling cannot. A reply assembled, state remembered, pixels compared, a figure enlarged: those earn their click. A stepper that narrates a diagram already visible, or a filter that dims a list short enough to scan, only re-presents information the reader has; cut those.

## Section orientation: automatic

Orientation exists so the reader knows which document they are in, where they are, and what is coming; scrolling stays the interaction, so it must be visible, never tucked behind a button. The template builds one strip at every width from every `main > section[id]` that has an `h2` (fewer than four sections: nothing): the document title on the left, then the section names, the current one marked by darker weight and a quiet underline, the strip scrolling itself to keep the mark in view; when the page is scrolled to its end, the last section takes the mark even if a taller neighbor is still on screen. It occupies the very top of the page from the moment it loads, so sticking never moves or resizes it. Links work; visibility is the point. `data-short="Label"` on an `h2` shortens labels. Do not build a second navigation on top of it.

## Answer form

When the page needs decisions back from the reader, collect them as a form a non-technical reader can follow: they are answering questions, and the result is a reply they hand back to the agent. All of that is said in words on the page, not implied by affordances.

- Each question lives where the reader forms the opinion, never gathered into a quiz at the end: a numbered card, the question in plain language, and the options joined into one segmented control (`inline-flex` bordered group, selected segment filled via `aria-pressed:` variants), so single-choice is legible before the first click. A second click on the active segment clears it. The what-happens-next explanation ("your answers build a reply at the bottom to paste back into the chat") lives on the first question card, not in the bar.
- A reply bar floats centered at the bottom of the window once the first answer lands, animating up into view so the reader connects its appearance to their click. A one-line caption above the controls says what the widget is, a descriptor rather than an instruction, in the register of "The reply this page is building from your answers"; never name a specific agent, since these pages outlive whichever assistant made them. Under the caption: one numbered marker per question (filled when answered, outlined while pending, each an anchor jumping to its question) and one button labeled "Copy reply". No Clear control and no prose previews; re-clicking an active segment already clears that answer.
- What the button copies is not the preview: it is Markdown the receiving agent can parse, opening with a line naming the page and file, then a numbered list with each question's topic and the chosen option in bold, unanswered ones marked as such:

  ```markdown
  Answers from "The answer form, spelled out" (2026-09-01-answer-form-round-two.html):

  1. Form shape: **ship it like this**
  2. Runbook numbering: **leave it to the agent**
  3. Contents button: _unanswered_
  ```

- The page must read complete with the form untouched. The form is how the reply travels; it is never how the argument is made.

This is the most intricate pattern in the skill, so copy the complete working example below and extend it rather than re-deriving the machinery; everything is driven by `data-q`/`data-topic`/`data-reply` attributes, and the styling of selected segments rides entirely on `aria-pressed:` variants.

```html
<div data-q="1" id="q1" data-topic="Form shape" class="mt-5 rounded-xl border-2 border-brand-200 bg-card p-5 shadow-sm">
  <p class="text-xs font-medium tracking-[0.12em] text-brand-700 uppercase">Question 1 of 2</p>
  <p class="mt-2 text-sm leading-6 font-medium">The question, in plain language?</p>
  <p class="mt-1 text-sm leading-6 text-muted-foreground">Pick one; clicking it again clears it. Your answers build a reply at the bottom to copy and paste back into the chat.</p>
  <div class="mt-3 inline-flex overflow-hidden rounded-lg border border-border" role="radiogroup">
    <button data-opt data-reply="option one" aria-pressed="false" class="border-l border-border px-3.5 py-2 text-sm text-muted-foreground transition-colors first:border-l-0 hover:text-foreground aria-pressed:bg-brand-600 aria-pressed:text-white aria-pressed:hover:text-white">Option one</button>
    <button data-opt data-reply="option two" aria-pressed="false" class="border-l border-border px-3.5 py-2 text-sm text-muted-foreground transition-colors first:border-l-0 hover:text-foreground aria-pressed:bg-brand-600 aria-pressed:text-white aria-pressed:hover:text-white">Option two</button>
  </div>
</div>

<div data-reply-bar hidden class="pointer-events-none fixed inset-x-0 bottom-4 z-30 flex justify-center px-4 print:hidden">
  <div class="bar-inner pointer-events-auto rounded-xl border border-border bg-card px-4 py-3 shadow-xl">
    <p class="text-xs leading-4 text-muted-foreground">The reply this page is building from your answers</p>
    <div class="mt-2 flex items-center justify-between gap-4">
      <span data-reply-marks class="flex items-center gap-1.5"></span>
      <button data-reply-copy class="shrink-0 rounded-md bg-primary px-3 py-1.5 text-sm font-medium whitespace-nowrap text-primary-foreground hover:opacity-90">Copy reply</button>
    </div>
  </div>
</div>

<script>
  (() => {
    document.head.insertAdjacentHTML("beforeend", "<style>@keyframes bar-rise{from{transform:translateY(14px);opacity:0}}[data-reply-bar]:not([hidden]) .bar-inner{animation:bar-rise .3s ease}</style>");
    const qs = [...document.querySelectorAll("[data-q]")];
    const bar = document.querySelector("[data-reply-bar]");
    const state = {};
    const render = () => {
      const answered = qs.filter((q) => state[q.dataset.q]).length;
      bar.hidden = answered === 0;
      document.querySelector("main").style.paddingBottom = answered ? "4.5rem" : "";
      document.querySelector("[data-reply-marks]").innerHTML = qs
        .map((q, i) => {
          const a = state[q.dataset.q];
          return "<a href='#" + q.id + "' title='" + q.dataset.topic + (a ? ": " + a : " · pending") + "' class='flex size-6 items-center justify-center rounded-full font-mono text-[11px] " + (a ? "bg-brand-600 text-white" : "border border-border text-muted-foreground") + "'>" + (i + 1) + "</a>";
        })
        .join("");
      qs.forEach((q) => q.querySelectorAll("[data-opt]").forEach((btn) => btn.setAttribute("aria-pressed", state[q.dataset.q] === btn.dataset.reply ? "true" : "false")));
    };
    qs.forEach((q) => {
      q.style.scrollMarginTop = "3rem";
      q.addEventListener("click", (e) => {
        const btn = e.target.closest("[data-opt]");
        if (!btn) return;
        state[q.dataset.q] = state[q.dataset.q] === btn.dataset.reply ? undefined : btn.dataset.reply;
        render();
      });
    });
    const buildReply = () =>
      'Answers from "PAGE TITLE" (FILENAME.html):\n\n' +
      qs.map((q, i) => i + 1 + ". " + q.dataset.topic + ": " + (state[q.dataset.q] ? "**" + state[q.dataset.q] + "**" : "_unanswered_")).join("\n");
    document.querySelector("[data-reply-copy]").addEventListener("click", () => {
      const btn = document.querySelector("[data-reply-copy]");
      if (navigator.clipboard) navigator.clipboard.writeText(buildReply()).then(() => { btn.textContent = "Copied"; setTimeout(() => (btn.textContent = "Copy reply"), 1200); }).catch(() => {});
    });
  })();
</script>
```

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
