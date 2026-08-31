# Charts: quantifying honestly and cheaply

Pick the lightest form that answers the question. Hand-rolled HTML/SVG covers ranked bars, shares, and small trends in a few lines; reach for Chart.js only when axes, tooltips, or many series genuinely earn their keep.

**The honesty rule, always:** name the normalization base next to the marks ("bars normalized to 74, the corpus size"), and never draw a value at a different size than its number. If a slice is too small to see at true scale, say so in text rather than inflating it.

## Form chooser

- Ranked quantities → bar rows
- Part of a whole → segmented meter, or a waffle when units matter
- Trend over time → sparkline; Chart.js line when axes matter
- Phases on a shared clock → timeline bars
- One important number → stat tile (big figure, one-line caption)
- Many series, scatter, stacked time series, tooltips → Chart.js

## Stat tile

```html
<div class="rounded-xl border border-border bg-card p-5 shadow-sm">
  <p class="text-3xl font-semibold tracking-[-0.03em]">412<span class="ml-1 text-lg text-muted-foreground">h</span></p>
  <p class="mt-1 text-xs leading-5 text-muted-foreground">what the figure is, plus the comparison that gives it meaning</p>
</div>
```

A toned figure (`text-error-700`) marks the tile carrying the problem.

## Bar rows (generated, never hand-repeated)

```html
<div id="bars" class="space-y-2"></div>
<script>
  const barData = [["checkout", 42], ["search", 28], ["uploads", 17]];
  const barMax = 42; // state the base in the caption
  document.querySelector("#bars").innerHTML = barData.map(([label, n]) =>
    '<div class="flex items-center gap-3">' +
    '<span class="w-32 shrink-0 text-right font-mono text-xs text-muted-foreground">' + label + '</span>' +
    '<div class="h-4 flex-1 overflow-hidden rounded bg-muted"><div class="h-4 rounded" style="width:' + (n / barMax) * 100 + '%;background:var(--color-brand-500)"></div></div>' +
    '<span class="w-10 shrink-0 text-right font-mono text-xs">' + n + '</span></div>').join("");
</script>
```

Inline `style="background: var(--color-…)"` resolves lazily at paint, so it is safe in generated markup regardless of when Tailwind compiles.

## Segmented meter

```html
<div class="flex h-2 gap-[3px] overflow-hidden rounded-full">
  <span class="flex-[45] bg-success-500"></span>
  <span class="flex-[8] bg-warning-500"></span>
  <span class="flex-[1] bg-error-500"></span>
</div>
```

The `flex-[n]` trick keeps segments proportional with no percentage math. Caption the total.

## Sparkline (generated SVG)

```html
<svg id="spark" viewBox="0 0 560 110" class="w-full" role="img" aria-label="What the line shows, including the peak"></svg>
<script>
  const PTS = [3, 1, 0, 5, 11, 14, 2, 8];
  const W = 560, H = 110, P = 14, MAX = Math.max(...PTS);
  const x = (i) => P + (i * (W - 2 * P)) / (PTS.length - 1);
  const y = (v) => P + (1 - v / MAX) * (H - 2 * P);
  document.querySelector("#spark").innerHTML =
    '<polyline fill="none" stroke-width="2" style="stroke:var(--color-brand-500)" points="' +
    PTS.map((v, i) => x(i) + "," + y(v)).join(" ") + '"/>' +
    PTS.map((v, i) => v ? '<circle r="2.5" cx="' + x(i) + '" cy="' + y(v) + '" style="fill:var(--color-brand-600)"/>' : "").join("");
</script>
```

Label at least the endpoints and the peak with small `<text>` marks, or the line is decoration.

## Timeline bars

Rows sharing one time axis: a relative container per row, absolutely positioned bars with `left`/`width` percentages computed from the shared span, and the span named in the caption. Ticks are a top row of mono labels absolutely positioned at the same percentage offsets. Same honesty rule.

## Chart.js, when it earns its keep

The template already depends on CDNs, so one more pinned script is no new fragility. Use version-pinned jsdelivr, pull colors from the theme, and wait for Tailwind's variables before reading them with `getComputedStyle`:

```html
<canvas id="trend" class="max-h-72 w-full"></canvas>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.js"></script>
<script>
  (function draw() {
    const css = getComputedStyle(document.documentElement);
    const v = (n) => css.getPropertyValue(n).trim();
    if (!window.Chart || !v("--color-brand-500")) return setTimeout(draw, 50); // Chart.js and Tailwind's browser build both load async
    new Chart(document.querySelector("#trend"), {
      type: "line",
      data: {
        labels: ["Mar", "Apr", "May", "Jun"],
        datasets: [{ label: "signups", data: [34, 51, 47, 68], borderColor: v("--color-brand-500"), backgroundColor: v("--color-brand-100"), tension: 0.25, fill: true }],
      },
      options: {
        plugins: { legend: { labels: { color: v("--color-gray-600"), font: { family: "Work Sans" } } } },
        scales: {
          x: { ticks: { color: v("--color-gray-500"), font: { family: "JetBrains Mono", size: 10 } }, grid: { color: v("--color-gray-100") } },
          y: { ticks: { color: v("--color-gray-500"), font: { family: "JetBrains Mono", size: 10 } }, grid: { color: v("--color-gray-100") } },
        },
      },
    });
  })();
</script>
```

Status series use `--color-success-500`/`--color-error-500`/`--color-warning-500`; categorical series that carry no status use brand plus grays, not a rainbow. A single flagged value inside an otherwise categorical group takes its status color, with the caption or legend saying why. Give every canvas a `max-h-*` or Chart.js will grow it unbounded inside flex/grid parents.
