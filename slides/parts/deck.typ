// Behind the slides
#import "../lib.typ": *

#part-slide("typst", "Behind the slides", [This deck is a Typst document, too])

== How this deck works

#between("/slides/slides.typ", "typ", "// <demo>", "// </demo>")

== A slide is just a heading

A level 2 heading starts a new slide. This is the real source of
the slide “Where LaTeX shines”:

#src("/slides/parts/latex.typ", "typ",
  from: "== Where LaTeX shines", until: "== Where LaTeX hurts", size: code.large)

== How the files fit together

#two[
#set text(size: code.large)
```
slides/
  slides.typ    look, title page
  lib.typ       helpers, colours
  parts/
    intro.typ
    latex.typ
    html.typ
    …
```
][
- `slides.typ` sets the look, then pulls in each part:
  `#include "parts/latex.typ"`
- Each part starts with `#import "../lib.typ": *`
- Helpers are plain functions: `#two[…][…]` puts two columns side by side
- The code on the slides is read from the real example files:
  `read("/examples/sample.tex")`
]

== One `make` builds everything

#two[
The slides show real output of the real tools:

- `latexmk` makes a PDF. Typst places a PDF page like an image:
  `image("sample-latex.pdf")`
- Headless Chrome takes screenshots; `browser()` draws the window
- `mdmost` runs in a pseudo terminal; its colours become JSON,
  and `terminal()` draws them
- `pandoc` writes HTML and Typst files, shown as text
][
#src-text("make         # every render, then the deck
make watch   # rebuild on every save", "sh", size: code.large)

- `make` rebuilds only what changed
- The fonts come from `fonts/`:

#src-text("typst compile --root . \\
  --font-path fonts \\
  --ignore-system-fonts \\
  slides/slides.typ", "sh", size: code.normal)
]
