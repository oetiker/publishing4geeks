// Wrap-up
#import "../lib.typ": *

#part-slide("intro", "Wrap-up", [Four languages, one idea])

== Side by side

#{
  set text(size: 13pt)
  let r(..cells) = cells.pos().map(c => if type(c) == str { raw(c) } else { c })
  compare(
    ..r([Section], "\\section{…}", "<h2>…</h2>", "## …", "= …"),
    ..r([Subsection], "\\subsection{…}", "<h3>…</h3>", "### …", "== …"),
    ..r([Paragraph], [empty line], "<p>…</p>", [empty line], [empty line]),
    ..r([Bold], "\\textbf{…}", "<strong>…</strong>", "**…**", "*…*"),
    ..r([Italic], "\\emph{…}", "<em>…</em>", "*…*", "_…_"),
    ..r([Inline code], "\\verb|…|", "<code>…</code>", "`…`", "`…`"),
    ..r([Code block], "\\begin{verbatim}", "<pre><code>", "```", "```"),
    ..r([Bullet list], "\\begin{itemize}", "<ul><li>", "- …", "- …"),
    ..r([Numbered], "\\begin{enumerate}", "<ol><li>", "1. …", "+ …"),
    ..r([Table], "tabular, &, \\\\", "<table><tr><td>", "| … | (GFM)", "#table(…)"),
    ..r([Comment], "% …", "<!-- … -->", [none], "// …"),
  )
}

== Pandoc: the universal converter

John MacFarlane, 2006. Reads Markdown, HTML, LaTeX, Word, …
and writes all of them, and Typst too.

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    ```sh
    pandoc sample.md -o sample.html
    pandoc sample.md -o sample.tex
    pandoc sample.md -o sample.typ
    pandoc sample.md -o sample.docx
    typst compile sample.typ
    ```
    #note[Pandoc converts the *structure*, not the layout.
      Try it on the web: #link("https://pandoc.org/try/")[pandoc.org/try].]
  ],
  src("/build/pandoc-sample.typ", "typ", until: "#align", size: code.small),
)

== Strengths at a glance

#{
  set text(size: 13pt)
  compare(
    [Readable source], [fair], [poor], [*excellent*], [good],
    [PDF and print], [*excellent*], [fair], [depends on the converter], [*excellent*],
    [Maths], [*the reference*], [with KaTeX, MathJax], [with extensions], [very good],
    [Screens, interaction], [no], [*excellent*], [through HTML], [experimental],
    [Programming], [TeX macros (hard)], [JavaScript], [none], [*built in*],
    [Feedback], [seconds], [*instant*], [*instant*], [*instant*],
    [Error messages], [cryptic], [none: the browser guesses], [none], [*clear*],
    [Stability], [*decades*], [*decades*], [depends on the flavour], [young (0.x)],
    [Ecosystem], [*huge* (CTAN)], [*huge*], [large, fragmented], [growing],
  )
}

== Which one when?

#table(
  columns: (1fr, auto),
  stroke: none, inset: (x: 0pt, y: 11pt), column-gutter: 1.5em,
  [A paper for a journal, lots of maths, a publisher's template], text(fill: colors.latex)[*LaTeX*],
  [A web page, or a document with interactive parts], text(fill: colors.html)[*HTML*],
  [README, notes, documentation, a wiki page, a chat message], text(fill: colors.markdown)[*Markdown*],
  [A new PDF document: report, thesis, letter, slides], text(fill: colors.typst)[*Typst*],
  [The same text in many formats], [*Markdown + Pandoc*],
)

== Let the LLM help you well

#two[
- Paste the *complete* error message and the lines around it.
- Ask for the smallest fix, and ask *why* it works.
- Say what you use: “LaTeX with pdflatex”, “GitHub Markdown”, “Typst 0.15”.
][
- Ask for the basic way first: “without extra packages”.
- Compile and look at the result. The LLM can be wrong, too.
]

== Links

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    *LaTeX*
    - #link("https://tobi.oetiker.ch/latex/lshort.pdf")[The Not So Short Introduction to LaTeX]
    - #link("https://www.overleaf.com/learn")[overleaf.com/learn]
    - #link("https://ctan.org")[ctan.org]

    *HTML*
    - #link("https://developer.mozilla.org")[developer.mozilla.org]
    - #link("https://validator.w3.org")[validator.w3.org]
  ],
  [
    *Markdown*
    - #link("https://commonmark.org/help/")[commonmark.org/help]
    - #link("https://github.github.com/gfm/")[github.github.com/gfm]

    *Typst*
    - #link("https://typst.app/docs")[typst.app/docs]
    - #link("https://typst.app/universe")[typst.app/universe]

    *Pandoc*: #link("https://pandoc.org")[pandoc.org]
  ],
)
