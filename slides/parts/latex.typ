// LaTeX
#import "../lib.typ": *

#part-slide("latex", "LaTeX", [Beautiful documents on paper, since 1984])

== What is LaTeX for?

#two[
- Scientific and technical documents: papers, theses, reports, books
- Excellent typesetting: line breaks, hyphenation, spacing
- The best mathematical formulas: $sum_(k=1)^n k = (n(n+1))/2$
][
- The standard in maths, physics and computer science;
  many journals accept only LaTeX
- The product is a *PDF*: fixed pages, made for print
]

== History

#two[
- *1977:* Donald Knuth does not like the typesetting of the
  new edition of his book _The Art of Computer Programming_.
  He writes his own typesetting system: *TeX* (first release 1978).
- TeX is frozen. Its version number approaches $pi$: today 3.141592653.
][
- *1984:* Leslie Lamport writes *LaTeX*: macros on top of TeX
  for _logical_ markup (`\section` instead of “big bold font”).
- *1994:* LaTeX2e. This is still the LaTeX you use today;
  the LaTeX Project team keeps improving it.
- New engines: pdfTeX (makes PDF directly), XeTeX and LuaTeX
  (Unicode and the fonts of your system).
]

== The source (1/2)

#src("/examples/sample.tex", "latex", until: "\\section{How to do it}",
  split: "\\section{Introduction}", size: code.large)

== The source (2/2)

#src("/examples/sample.tex", "latex", from: "\\section{How to do it}",
  split: "\\subsection{A small program}", size: code.large)

== The result

#grid(columns: (auto, 1fr), column-gutter: 1.2em,
  framed(image("/build/sample-latex.pdf", page: 1, height: 11.5cm)),
  [
    `latexmk -pdf sample.tex`

    - Sections are numbered automatically.
    - The paragraph indent, the fonts and the spacing come
      from the class `article`.
    - A4 page, page number at the bottom.
  ],
)

== The rules

#two[
- Commands: `\name{argument}`, for example `\textbf{bold}`
- Environments: `\begin{itemize}` … `\end{itemize}`
- `%` starts a comment until the end of the line
- An empty line starts a new paragraph
- These characters are special: `# $ % & ~ _ ^ \ { }`.
  Write them as `\# \$ \% \& \_` and so on.
][
*The classic trap:* write `file_name.txt` in the text and you get

```
! Missing $ inserted.
```

The `_` means “subscript”, and that is only allowed in maths.
Write `file\_name.txt`.

An LLM explains messages like this one immediately.
]

== Where LaTeX shines

#two[
- *Maths:* the reference. MathJax and KaTeX show LaTeX maths on the web,
  and Markdown and Word accept its syntax.
- *Numbers that stay correct:* cross-references, table of contents,
  index, bibliography (BibTeX, biblatex)
][
- *Fine typography:* line breaks chosen for the whole paragraph, hyphenation
- *Stable:* a document from the 1990s still compiles today
- *Accepted everywhere:* journals, arXiv, publishers' templates
]

== Where LaTeX hurts

#two[
- *Cryptic errors:* the message points to where TeX noticed the problem,
  not to where you made the mistake
- *Slow feedback:* compile, and often compile again for references
  and the bibliography
- *Big install:* several GB, several engines, packages that can clash
][
- *Hard to change the look:* the class decides, and changing it needs
  macro knowledge
- *Special characters:* `% & _ # $` need a backslash in normal text
- *Made for paper:* the output is PDF; converting to HTML is rough
]

== Strength: maths and cross-references

#grid(columns: (1fr, 1fr), column-gutter: 1em, align: horizon,
  src("/examples/strength-latex.tex", "latex"),
  framed(image("/build/strength-latex.pdf", width: 100%)),
)

== Using LaTeX

#two[
*On the web*
- #link("https://www.overleaf.com")[Overleaf]: free account, live preview,
  work together on a document
][
*On your computer*
- *TeX Live* (Linux, Windows), *MacTeX* (macOS): a full install is several GB
- *MiKTeX* (Windows): small install, gets packages when you need them
- Compile: `latexmk -pdf sample.tex` (runs LaTeX as often as needed)
- Editors: TeXstudio, VS Code with _LaTeX Workshop_
]

== Learn more: lshort

#two[
*The Not So Short Introduction to LaTeX*

by Tobias Oetiker and others

- Free PDF: #link("https://tobi.oetiker.ch/latex/lshort.pdf")[tobi.oetiker.ch/latex/lshort.pdf]
- With a full TeX Live it is already on your disk: `texdoc lshort`
- On CTAN in many languages
][
- Everything from today, and much more: maths, tables, pictures,
  bibliographies, your own commands
- Sticks to what the basic LaTeX system offers
- A good companion to an LLM: read the chapter, then ask the questions
]

== Packages

`\usepackage{name}` loads a package.
#link("https://ctan.org")[CTAN] (since 1992) has more than 6000 of them.

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    - `graphicx`: include images
    - `hyperref`: clickable links in the PDF
    - `booktabs`: good-looking tables
  ],
  [
    - `listings`, `minted`: highlighted code
    - `tikz`: drawings and diagrams
    - `babel`: language rules (hyphenation)
  ],
)

Document classes set the basic layout:
`article`, `report`, `book`, `beamer` (slides), KOMA-Script (`scrartcl`, …)

#note[Packages can conflict, and their load order can matter. This is a good question for an LLM.]

== Your turn: LaTeX (10 minutes)

#exercise("Overleaf", "https://www.overleaf.com", (
  [Create a blank project and paste `sample.tex`.],
  [Add a third row to the table.],
  [Add a subsection “Pitfalls” with a numbered list of two items.],
  [Write the sentence `50% of file_name.txt & more` and make it compile.],
  [Make one word *bold and italic* at the same time.],
))
