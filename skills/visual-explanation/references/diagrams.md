# Diagrams: geometry without the tax

## HTML first

Boxes, lanes, grids, rails, and comparisons are HTML/Tailwind jobs: they reflow, wrap text, and cost nothing to revise. Reserve inline SVG for what only geometry expresses: arrows that cross or curve, proportional timelines, trees, topology. A page that is one flex row of cards with Phosphor arrows between them needs no SVG at all:

```html
<div class="flex flex-wrap items-stretch gap-2">
  <div class="min-w-40 flex-1 rounded-lg border border-border bg-card p-3 text-sm">producer</div>
  <i class="ph ph-arrow-right self-center text-muted-foreground"></i>
  <div class="min-w-40 flex-1 rounded-lg border border-border bg-card p-3 text-sm">queue</div>
</div>
```

Pick one arrow mechanism per page (Phosphor icons, or SVG markers inside diagrams); mixing `&rarr;`, icons, and markers on one page reads as noise.

## The SVG kit

Every diagram: `viewBox`, full width with a minimum, inside a scroll wrapper, labeled for assistive tech.

```html
<div class="overflow-x-auto rounded-xl border border-border bg-card p-6 shadow-sm">
  <svg viewBox="0 0 940 220" class="w-full min-w-[680px]" role="img" aria-label="One sentence saying what the diagram shows and how it ends">
    <defs>
      <marker id="ar" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
        <path d="M0 0 L8 4 L0 8 z" class="fill-gray-400" />
      </marker>
    </defs>
    <rect x="0" y="20" width="170" height="56" rx="8" class="fill-card stroke-border" />
    <text x="14" y="52" class="fill-foreground" font-family="JetBrains Mono, monospace" font-size="11">scheduler</text>
    <line x1="176" y1="48" x2="230" y2="48" stroke-width="1.5" class="stroke-gray-400" marker-end="url(#ar)" />
  </svg>
</div>
```

- **Colors**: `fill-*`/`stroke-*` utility classes (`fill-brand-500`, `stroke-border`, `fill-error-50 stroke-error-300`), or `style="fill: var(--color-…)"` in generated markup. Presentation attributes cannot resolve `var()`, and hardcoded hex is how diagrams drift off-theme.
- **Text**: `font-size` 10-12 with `font-family` set per text group; no wrapping exists in SVG, so keep labels to 2-4 words and let a caption under the figure carry sentences.
- **Tones**: neutral boxes `fill-card stroke-border`; the failing/warning/succeeding step gets the 50-fill plus 300-stroke of its status color, with text in the same family's 700, mirroring the pill's 100/700 pairing.

## Swimlanes and sequences

Lanes are horizontal bands (`rect` at full width, `fill-muted` at low opacity, lane label at the left edge); actors sit in lanes; time flows left to right with marker arrows for messages. Number the arrows with small circles in the step-circle idiom (`fill-gray-900`, white 10px mono text) and put the narration in a matching ordered list beside or below the figure rather than cramming clauses into the SVG.

## Generated geometry

When positions derive from data (rings, fans, trees, timelines), compute them in a small script emitting into an empty `<svg>`, exactly like the chart recipes. Radial layouts, evenly spaced fans, and proportional timelines are ten-line loops; hand-placing them is where overlap bugs come from.

## The render check

Coordinate SVG beyond about a dozen positioned nodes, or any generated geometry, gets one headless render check: take a single screenshot at default width, fix the overlaps or clipped labels it shows, stop. One pass is the budget; a diagram that needs more than one fix pass is telling you to simplify it or move parts back to HTML.

Skip diagram libraries (Mermaid and kin): their output ignores the page's theme and typography, and the kit above covers the same ground on-theme.
