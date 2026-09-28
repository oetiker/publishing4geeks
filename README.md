# Publishing for Geeks

A two-hour course: write plain text in a markup language, get a rendered page.
Four systems, one sample document:

| Language | Source                  | Product       |
|----------|-------------------------|---------------|
| LaTeX    | `examples/sample.tex`   | PDF           |
| HTML+CSS | `examples/sample.html`  | browser       |
| Markdown | `examples/sample.md`    | browser, terminal |
| Typst    | `examples/sample.typ`   | PDF           |

The slides are written in Typst:

- `slides/slides.typ`: the look of the deck, the title page, and one
  `#include` per part
- `slides/lib.typ`: helpers (`src`, `two`, `browser`, `terminal`, …) and colours
- `slides/parts/*.typ`: the slides, one file per part

Code excerpts on the slides are read from the files in `examples/` and
selected by text (`until: "<h1>"`, `split: "## How to do it"`), not by
line number, so editing a sample does not break a slide.

## Build

```sh
make          # renders all samples, then build/slides.pdf
make watch    # live-rebuild the slides while editing
make clean
```

Needs: `typst`, `latexmk` + pdflatex, `pandoc`, `mdmost`, `google-chrome`
(headless screenshots), `python3`, `script` (util-linux).

The slides use only the fonts in `fonts/` (Inter and JetBrains Mono, each
with its licence file), so the deck looks the same on every machine.

The slides read the sample files directly, so a changed sample shows up
on the slides after the next `make`.

## Time plan (120 min)

| Time    | Part                                          |
|---------|-----------------------------------------------|
| 10 min  | Intro: LLMs, logical markup, timeline         |
| 25 min  | LaTeX (incl. 10 min exercise on Overleaf)     |
| 25 min  | HTML (incl. 10 min exercise on CodePen)       |
| 25 min  | Markdown (incl. 10 min exercise on Dillinger) |
| 25 min  | Typst (incl. 10 min exercise on typst.app)    |
| 10 min  | Wrap-up: side by side, Pandoc, which one when |

Overleaf and typst.app need a free account: ask participants to create
one before the course.
