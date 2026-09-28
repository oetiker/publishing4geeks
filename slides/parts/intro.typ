// Introduction
#import "../lib.typ": *

#part.update((name: course-title, color: colors.intro))

== Learning a new language got cheap

#two[
- *Before:* a missing brace, a cryptic error message, and days
  in manuals and forums to find the cause.
- *Now:* LLMs know these languages very well. Paste the
  error, get an explanation and a fix in seconds.
][
- The painful part of learning a computer language is (mostly) gone.
- *What remains is your part:* know what the language can do,
  ask for the right thing, and recognise a good answer.
]

== What we learn today

The everyday toolkit: *nothing fancy*.

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    - Title, sections and subsections
    - Paragraphs of body text
    - *Bold* and _italic_
    - Inline `code` and code blocks
  ],
  [
    - Bullet lists
    - Numbered lists
    - Tables
    - Comments in the source
  ],
)

#v(0.6em)
No macros, no templates, no tricks. Only what the basic system gives you.

== Four roads to a page

#v(0.5em)
#grid(
  columns: (auto, auto, 1fr, auto, auto),
  column-gutter: 0.8em, row-gutter: 1.1em, align: horizon,
  ..road(`sample.tex`, [`pdflatex` / `latexmk`], [PDF], colors.latex),
  ..road(`sample.html`, [any web browser], [screen (any size)], colors.html),
  ..road(`sample.md`, [`pandoc`, GitHub, `mdmost`, …], [HTML, terminal, PDF, …], colors.markdown),
  ..road(`sample.typ`, [`typst compile`], [PDF (HTML is coming)], colors.typst),
)

#v(1em)
All four are *plain text files*. You can edit them with any editor,
keep them in git, and compare versions with `diff`.

== Say what it is, not how it looks

#two[
All four languages use *logical markup*:

#grid(row-gutter: 0.9em,
  [LaTeX: `\section{Introduction}`],
  [HTML: `<h2>Introduction</h2>`],
  [Markdown: `## Introduction`],
  [Typst: `= Introduction`],
)
][
Each line says the same thing: _“this is a section heading”_.
The size, font and numbering come from somewhere else:

- the document class (LaTeX)
- the style sheet (HTML with CSS)
- the renderer (Markdown)
- `set` and `show` rules (Typst)
]

== Fifty years of markup

#timeline((
  (1978, [TeX], colors.latex),
  (1984, [LaTeX], colors.latex),
  (1991, [HTML], colors.html),
  (1996, [CSS 1], colors.html),
  (2004, [Markdown], colors.markdown),
  (2006, [Pandoc], colors.intro),
  (2014, [CommonMark, HTML5], colors.markdown),
  (2023, [Typst], colors.typst),
))

== The sample document

We write *the same document* in all four languages:

#two[
- a title and an author
- a paragraph with *bold*, _italic_ and `inline code`
- two sections, each with a subsection
][
- a bullet list, a numbered list and a small table
- a short Python program as a code block
- comments that explain the markup
]

#v(0.5em)
The text stays the same. Only the markup changes.
All files are in the `examples/` folder.
