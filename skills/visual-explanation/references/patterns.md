# Patterns: the recurring vocabulary

Canonical spellings for the elements nearly every explanation uses. Each is a starting point, not a uniform: restyle freely, and let form follow the question. What these end is respelling, not variety.

## Section heading

```html
<h2 class="text-xl font-semibold tracking-[-0.02em]" data-short="Short label">What the section answers</h2>
```

`data-short` feeds the sidebar TOC when the full heading runs long; omit it otherwise.

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

## Terminal block

One dialect. Dark ground `bg-gray-950`, light text, gray prompt, status colors from the theme's 300 range (they read on dark).

```html
<div class="overflow-x-auto rounded-lg bg-gray-950 p-4 font-mono text-xs leading-6 text-gray-100"><pre><span class="text-gray-500">$</span> agent-reference status
wire-format  <span class="text-warning-300">folder</span> · ready
<span class="text-success-300">&#10003; 6 references resolved</span></pre></div>
```

## Ledger opener (series rounds only)

Sits first, wrapped like any titled section so the sidebar picks it up. The middle column's label flexes with the round: "Changed this round" after a reversal, "Deciding this round" when the round exists to make a call.

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

## Evidence footer

Close pages whose claims rest on gathered evidence with provenance: what was read, how counts were made, what is verbatim versus inferred.

```html
<footer class="mt-14 max-w-3xl border-t border-border pt-6 text-xs leading-6 text-muted-foreground">
  <strong class="text-foreground">Evidence.</strong> All 74 artifacts read in full; counts from corpus-wide greps run today; quotes verbatim from session logs.
</footer>
```

Illustrative or invented content is disclosed twice: a warning-toned kicker up top and a sentence here.

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
