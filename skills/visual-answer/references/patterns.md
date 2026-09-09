# Patterns: the recurring vocabulary

Canonical spellings for the elements nearly every explanation uses. Each is a starting point, not a uniform: restyle freely, and let form follow the question. What these end is respelling, not variety.

## Section heading

```html
<h2 class="text-xl font-semibold tracking-[-0.02em]" data-short="Short label">What the section answers</h2>
```

`data-short` feeds the orientation strip when the full heading runs long; omit it otherwise. The heading states the section's finding rather than naming its topic, since it is the line most likely to be the only one read.

To mark the sections, put a Phosphor icon first inside the `h2`. The strip mirrors it automatically, so this is the only place it is written:

```html
<h2 class="flex items-baseline gap-2 text-xl font-semibold tracking-[-0.02em]" data-short="The pattern">
  <i class="ph ph-repeat shrink-0 text-lg text-gray-400"></i>Eleven reactions that keep coming back
</h2>
```

`gap-2` and `items-baseline` sit the glyph on the heading's baseline; `text-gray-400` keeps it a landmark rather than a second piece of emphasis competing with the words. Mark every section or none. The icon names the section's subject, never its genre, which is the difference between a landmark and decoration.

## Kicker label

The small uppercase label above a heading or opening a card. One spelling; vary only the color for tone.

```html
<p class="text-xs font-medium tracking-[0.12em] text-muted-foreground uppercase">The exposure ladder</p>
```

Tones: `text-muted-foreground` neutral, `text-brand-700` emphasis, `text-error-700`/`text-warning-700`/`text-success-700` status.

## Status pills

Theme tokens only, one shape. Coin the label vocabulary per page (shipped/inference/broken, adopt/skip, tier A/B); keep the spelling.

```html
<span class="rounded-full bg-success-100 px-2.5 py-0.5 text-xs font-semibold text-success-700">shipped</span>
<span class="rounded-full bg-warning-100 px-2.5 py-0.5 text-xs font-semibold text-warning-700">inference</span>
<span class="rounded-full bg-error-100 px-2.5 py-0.5 text-xs font-semibold text-error-700">broken</span>
<span class="rounded-full bg-brand-100 px-2.5 py-0.5 text-xs font-semibold text-brand-700">recommended</span>
<span class="rounded-full bg-muted px-2.5 py-0.5 text-xs font-semibold text-muted-foreground">cut</span>
```

On a dark banner: `bg-amber-400/20 text-amber-300` is the established flag-pill look; keep it for dark surfaces only.

## Step circle and numbered rail

```html
<li class="flex gap-3">
  <span class="flex size-7 shrink-0 items-center justify-center rounded-full bg-gray-900 font-mono text-xs text-white">1</span>
  <span class="text-sm leading-6">The step, stated as what happens, not as a heading.</span>
</li>
```

Swap `bg-gray-900` for `bg-brand-600`/`bg-error-500`/`bg-success-700` when the step itself carries status.

## Icon-led list

For a list of short nouns or one-clause claims the reader scans rather than reads. One Phosphor regular icon per row, as a landmark, never two and never an emoji. Brand tone for the focal list, gray for a supporting one.

```html
<ul class="space-y-2 text-sm">
  <li class="flex items-center gap-2.5"><i class="ph ph-folder-open text-lg text-brand-700"></i>The workspace folder</li>
</ul>
```

When the row is a bold label and a clause, align the icon to the first line: `items-start` on the row, `mt-1` on the icon.

```html
<li class="flex items-start gap-3 text-sm leading-6"><i class="ph ph-hand-palm mt-1 text-lg text-brand-700"></i><span><strong>Restraint.</strong> No walls of text.</span></li>
```

## Icon chips

A field of labeled things to scan in any order: what a system captures, what a page covers, the inputs to a decision. Each chip is one icon and two to four words; the icon's tone marks the group, so a page can carry two or three fields without a heading between every row.

```html
<div class="flex flex-wrap gap-2">
  <span class="flex items-center gap-1.5 rounded-lg border border-border bg-card px-3 py-1.5 text-sm"><i class="ph ph-browser text-base text-brand-700"></i>Pages viewed</span>
</div>
```

## Paired columns

Two positions on one subject, one card per subject, for a disagreement or a before-and-after. The kicker names the subject; the sides are labeled inline so each half reads as a sentence, and the second side takes the brand tone when it is the author's.

```html
<div class="rounded-xl border border-border bg-card p-4 shadow-sm">
  <p class="text-xs font-medium tracking-[0.12em] text-muted-foreground uppercase">Projects</p>
  <div class="mt-2 grid gap-4 text-sm leading-6 sm:grid-cols-2">
    <p><span class="font-semibold">Neil</span> · durable bodies of work. Keep them.</p>
    <p><span class="font-semibold text-brand-700">Me</span> · groups of reachable things. Nearly the same.</p>
  </div>
</div>
```

## Bare numbered list

For claims the reader will say out loud: tenets, rules, a plan's steps. The step circle and the sentence are the whole row. A gray explainer after each line reads as a hedge and doubles the scan cost; put the detail in a section below and link the number to it.

```html
<li class="flex gap-3"><span class="flex size-7 shrink-0 items-center justify-center rounded-full bg-gray-900 font-mono text-xs text-white">1</span><span class="text-[15px] leading-7 font-medium">One agent, and you never take turns with it.</span></li>
```

## Emphasis cards

Three levels on top of the base card (`rounded-xl border border-border bg-card p-5 shadow-sm`):

```html
<!-- verdict: the card IS the finding -->
<div class="rounded-xl border-2 border-success-300 bg-card p-5 shadow-sm">…</div>
<!-- callout: a remark attached to surrounding flow -->
<div class="rounded-xl border-l-4 border-warning-500 bg-card p-5 shadow-sm">…</div>
<!-- tinted panel: a region with a tone, e.g. the failing side of a comparison -->
<div class="rounded-xl border border-error-300 bg-error-50 p-5">…</div>
```

Most sections need no card at all: SKILL.md's volume rule outranks every spelling here.

## Terminal block

One dialect. Dark ground `bg-gray-950`, light text, gray prompt, status colors from the theme's 300 range (they read on dark).

```html
<div class="overflow-x-auto rounded-lg bg-gray-950 p-4 font-mono text-xs leading-6 text-gray-100"><pre><span class="text-gray-500">$</span> agent-reference status
wire-format  <span class="text-warning-300">folder</span> · ready
<span class="text-success-300">&#10003; 6 references resolved</span></pre></div>
```

## Code excerpt

Terminal output is a bare `<pre>` with hand-placed spans (above). Real code is `<pre><code class="language-x">` on the same dark surface; the template loads highlight.js automatically when such a block exists, so never hand-color code:

```html
<pre class="overflow-x-auto rounded-lg bg-gray-950 p-4 text-xs leading-6 text-gray-100"><code class="language-ts">const spy = new IntersectionObserver(onSee, { rootMargin: "-15% 0px -75% 0px" });</code></pre>
```

Name the language; auto-detection is a fallback, not a plan.

The dark surface is a choice rather than a requirement. A `<pre>` written without those classes renders as a light block, bordered and readable, with the token palette that suits it: the template picks the palette from the background it measures, so forgetting the classes costs the house look and never legibility.

## What both blocks get for free

Every `<pre>` on the page, in either dialect, is given a Copy button and a Wrap toggle in its top-right corner, revealed on hover. Never build your own; never leave a long line to run off the right edge on the theory that the reader will scroll.

Blocks wrap by default, and the toggle returns one block to one line per line. Wrapping is right for the prose-shaped lines these pages mostly carry, and wrong for anything whose columns line up, so start those unwrapped with `data-wrap="off"` on the `<pre>`: an ASCII diagram, a box drawing, a table of aligned output. That is the only case where the author decides; everything else takes the default.

## Ledger opener (series rounds only)

Sits first, wrapped like any titled section so the orientation strip picks it up. The middle column's label flexes with the round: "Changed this round" after a reversal, "Deciding this round" when the round exists to make a call.

```html
<section id="ledger" class="mt-10">
  <h2 class="text-xl font-semibold tracking-[-0.02em]" data-short="Where this stands">Where this round stands</h2>
  <div class="mt-4 grid gap-5 md:grid-cols-3">
    <div><p class="text-xs font-medium tracking-[0.12em] text-success-700 uppercase">Settled</p><ul class="mt-3 space-y-2 text-sm leading-6">…</ul></div>
    <div><p class="text-xs font-medium tracking-[0.12em] text-brand-700 uppercase">Deciding this round</p><ul class="mt-3 space-y-2 text-sm leading-6">…</ul></div>
    <div><p class="text-xs font-medium tracking-[0.12em] text-muted-foreground uppercase">Cut</p><ul class="mt-3 space-y-2 text-sm leading-6">…</ul></div>
  </div>
</section>
```

## Decision ending

One card per open decision. The handle is plain words naming the subject; the chip carries the recommendation.

```html
<div class="rounded-xl border border-border bg-card p-5 shadow-sm">
  <div class="flex flex-wrap items-start justify-between gap-3">
    <div class="min-w-0 flex-1">
      <p class="text-sm font-semibold">1 · Fallback location</p>
      <p class="mt-1 text-sm leading-6 text-muted-foreground">What the decision is and what stays true if it is never made.</p>
    </div>
    <span class="rounded-full bg-brand-100 px-3 py-1 text-xs font-semibold whitespace-nowrap text-brand-700">&#128073; the recommendation</span>
  </div>
</div>
```

## Quoting someone

The distillation is the line, the quote is the support under it. Never the other way round, and never the quote alone.

```html
<figure class="mt-4 border-l-2 border-border pl-4">
  <p class="text-sm leading-6"><strong>Horizontal scrollers eat the wheel.</strong> Scrolling past one stops the page.</p>
  <blockquote class="mt-1 text-xs leading-5 text-muted-foreground">&ldquo;my mouse wheel gets trapped on the horizontal rows&rdquo; &middot; Sep 2</blockquote>
</figure>
```

Clip the quote to the fragment that carries the point and mark the clip with an ellipsis; a paragraph of someone's own words pasted whole is the least-read element on the page, however well it argues. Where many of these stack, they are a table, and the distillation is the first column.

## Evidence footer

Close pages whose claims rest on gathered evidence with provenance: what was read, how counts were made, what is verbatim versus inferred.

```html
<footer class="mt-14 max-w-3xl border-t border-border pt-6 text-xs leading-6 text-muted-foreground">
  <strong class="text-foreground">Evidence.</strong> All 74 artifacts read in full; counts from corpus-wide greps run today; quotes verbatim from session logs.
</footer>
```

Illustrative or invented content is disclosed twice: a warning-toned kicker up top and a sentence here.

## Leaving the column

Two steps out, both supplied by the template and both centered on the column. The attribute is the whole spelling; nothing else on the element positions it.

```html
<!-- wide, ~76rem: the everyday step. Dense tables, matrices, comparisons. -->
<div data-width="wide" class="mt-6 overflow-x-auto">
  <table class="w-full text-left text-sm">…</table>
</div>

<!-- full, up to 132rem: content that is the argument rather than illustrating it. -->
<div data-width="full">
  <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-5">…</div>
</div>
```

Put it on the block that needs the room, never on the `<section>`, or the heading and intro drift out of line with every other heading on the page. Both steps cap at `92vw` rather than `100vw`, which keeps a margin and avoids the horizontal scrollbar a full-viewport child causes on Windows. Use them for a handful of blocks on a page, never as the default wrapper -- a page where everything is wide has no column left to break out of.

Prefer either step over a horizontal scroller, and where one is unavoidable, always pair the classes:

```html
<div data-width="wide" class="mt-6 overflow-x-auto overflow-y-hidden">…</div>
```

`overflow-x-auto` alone computes `overflow-y` to `auto` as well. A horizontal scrollbar then steals its own height from the content box, which leaves the block scrollable downward by exactly that much, and a reader scrolling past it spends the gesture there and thinks the page is stuck. It only bites with a mouse attached, because overlay scrollbars take no space, which is why it survives every check made on a trackpad. The template already pins this down for `<pre>` and the orientation strip; a table wrapper is yours to spell.

## Comparison gallery

N renders of the same brief, one per candidate, each captioned with what to look at. The caption does the work: a bare grid of screenshots asks the reader to find the difference themselves, which they will not.

```html
<figure>
  <button type="button" class="block w-full cursor-zoom-in" data-full="./assets/x.png" data-label="Model &middot; poster">
    <img src="./assets/x.png" alt="…" class="w-full rounded-lg border border-border transition hover:brightness-95" loading="lazy" />
  </button>
  <figcaption class="mt-2 text-xs leading-5 text-muted-foreground">
    <strong class="text-foreground">Model name</strong>
    <span class="ml-2 rounded-full bg-success-100 px-2 py-0.5 text-[10px] font-semibold text-success-700">my pick</span><br />
    What is good or wrong about this one, in a clause or two.
  </figcaption>
</figure>
```

Three rules. Mark the winner and the defective one with a `border-2` in `success` or `error` and a pill, so the eye lands before it reads. Say plainly that the ranking is your judgement and only the counted things were counted. And `loading="lazy"` on every image past the first row, because these pages run to tens of megabytes.

Pair it with the click-to-enlarge dialog in `references/interaction.md` whenever the grid is dense enough that a tile is smaller than the thing it shows.

## Capturing an artifact

Rendering a real output beats describing it, and the rendering is where the claim and the thing come apart -- so look at every capture before writing a caption about it.

```bash
qlmanage -t -s 1200 -o . file.pptx        # Office, PDF, most macOS-previewable types; first page only
chrome --headless --disable-gpu --screenshot=out.png \
  --window-size=1280,1400 --hide-scrollbars "file://$PWD/page.html"
```

The trap: **the capture window is the image size**, so a window wider than the content leaves a white band down the side of every tile, and it is invisible until the grid is assembled. Read the SVG's `viewBox` or the page's own width and shoot at exactly that. For a long page, shoot tall and say in the caption that it is the first screen.

`--virtual-time-budget=9000` gives a page with a CDN stylesheet time to compile before the shutter; without it a Tailwind page captures unstyled.

Land every asset at its native resolution and let CSS scale it down. A file downscaled on the way in is fine in the grid and useless the moment the reader opens it to read what it shows, which is the whole reason it is on the page.

## Retraction

When a later round overturns something an earlier page recommended, say so where the reader will hit it, not in a footnote. The value of a series is that its reversals are legible.

```html
<div class="rounded-xl border-l-4 border-error-500 bg-card p-5 shadow-sm">
  <p class="text-sm leading-6"><strong>What I got wrong.</strong> The claim as it was made, then what the new evidence is, then what it changes. No hedging about how it was defensible at the time.</p>
</div>
```

Distinguish the two kinds, because they cost the reader differently: a **reversal** (new evidence, different answer) and an **overstatement** (right direction, wrong absolute -- "never" that turned out to be "21% of the time"). Name which it is.

## Coach marks

Commentary about a depicted thing (a slide, a UI, a transcript) sits outside the depicted surface in a visibly different voice, so content and annotation never blur:

```html
<div class="relative">
  <div class="rounded-lg border border-border bg-card p-4"><!-- the depicted thing --></div>
  <p class="mt-2 flex items-start gap-1.5 text-xs leading-5 text-warning-700">
    <i class="ph-fill ph-hand-pointing mt-0.5"></i>
    <span>Annotation about the thing above, never inside it.</span>
  </p>
</div>
```
