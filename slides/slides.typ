// Publishing for Geeks: the slide deck.
// Build with `make` in the project root; paths start at the project root.
// Helpers live in lib.typ, the slides in parts/.

#import "lib.typ": *

// <demo>
// Basic look of the whole deck.
#set page(
  paper: "presentation-16-9",
  margin: (x: 1.5cm, top: 1.4cm, bottom: 1.2cm),
  footer: context {
    set text(size: 10pt, fill: luma(130))
    part.get().name
    h(1fr)
    link(repo, repo.trim("https://", at: start))
    h(1fr)
    counter(page).display()
  },
)
#set text(font: "Inter", size: 19pt)
#show raw: set text(font: "JetBrains Mono", ligatures: false, features: (calt: 0))

// Every level 2 heading starts a new slide.
#show heading.where(level: 2): it => {
  pagebreak(weak: true)
  context block(below: 0.9em, text(
    size: 26pt, weight: "bold", fill: part.get().color, it.body))
}
// </demo>

#show raw.where(block: true): it => block(
  fill: luma(246), inset: 8pt, radius: 4pt, width: 100%, it)
#show raw.where(block: false): it => box(
  fill: luma(240), inset: (x: 3pt), outset: (y: 3pt), radius: 2pt, it)
// Tight lines inside an item, clear space between items.
#set par(leading: 0.5em)
#set list(spacing: 1.1em)
#set enum(spacing: 1.1em)
#set table(inset: 7pt, stroke: 0.5pt + luma(180))
#show link: set text(fill: rgb("#1a6fd4"))

// ---------------------------------------------------------------- title

#page(footer: none, align(horizon, {
  text(size: 50pt, weight: "bold", fill: colors.intro, course-title)
  v(0.1em)
  text(size: 24pt, course-subtitle)
  v(2em)
  text(size: 18pt)[Tobias Oetiker \ OETIKER+PARTNER AG]
}))

#include "parts/intro.typ"
#include "parts/latex.typ"
#include "parts/html.typ"
#include "parts/markdown.typ"
#include "parts/typst.typ"
#include "parts/wrapup.typ"
#include "parts/deck.typ"
