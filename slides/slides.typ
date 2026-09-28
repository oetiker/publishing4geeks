// Publishing for Geeks: slide deck.
// Build with `make` in the project root (paths below start at the project root).

#let course-title = "Publishing for Geeks"
#let course-subtitle = [Text in, page out: LaTeX, HTML, Markdown and Typst]

#let colors = (
  intro: rgb("#3a3f4b"),
  latex: rgb("#008080"),
  html: rgb("#e34c26"),
  markdown: rgb("#6f42c1"),
  typst: rgb("#239dad"),
)
#let part = state("part", (name: "", color: colors.intro))

// <demo>
// Basic look of the whole deck.
#set page(
  paper: "presentation-16-9",
  margin: (x: 1.5cm, top: 1.4cm, bottom: 1.2cm),
  footer: context {
    set text(size: 10pt, fill: luma(130))
    part.get().name
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
#set list(spacing: 0.65em)
#set enum(spacing: 0.65em)
#set table(inset: 7pt, stroke: 0.5pt + luma(180))
#show link: set text(fill: rgb("#1a6fd4"))

// ---------------------------------------------------------------- helpers

// Show lines `from` to `to` of a source file, optionally in columns.
// With `split`, a second column starts at that line number.
#let src(path, lang, from: 1, to: none, split: none, size: 11pt) = {
  let lines = read(path).trim(at: end).split("\n")
  let to = if to == none { lines.len() } else { calc.min(to, lines.len()) }
  let block-of(a, b) = raw(lines.slice(a - 1, b).join("\n").trim(at: end), lang: lang, block: true)
  set text(size: size)
  if split == none {
    block-of(from, to)
  } else {
    grid(columns: (1fr, 1fr), column-gutter: 0.8em,
      block-of(from, split - 1), block-of(split, to))
  }
}

// Show the lines of a file between two marker lines.
#let between(path, lang, start, end, size: 11pt) = {
  let lines = read(path).split("\n")
  let a = lines.position(l => l.trim() == start) + 2
  let b = lines.position(l => l.trim() == end)
  src(path, lang, from: a, to: b, size: size)
}

// Draw captured terminal output (see tools/ansi2json.py).
#let terminal(path, from: 0, to: none, size: 8pt) = {
  let lines = json(path)
  let to = if to == none { lines.len() } else { calc.min(to, lines.len()) }
  block(fill: rgb("#fdfcf9"), inset: 8pt, radius: 4pt, stroke: luma(190), {
    set text(font: "JetBrains Mono", size: size)
    for line in lines.slice(from, to) {
      block(spacing: 0pt, height: 1.22em, line.map(s => {
        let t = text(
          fill: if s.fg != none { rgb(s.fg) } else { black },
          weight: if s.b { "bold" } else { "regular" },
          style: if s.i { "italic" } else { "normal" },
          s.t.replace(" ", "\u{a0}"),
        )
        if s.u { underline(t) } else { t }
      }).join())
    }
  })
}

#let framed(body) = box(stroke: 0.5pt + luma(170), body)

#let part-slide(key, name, tagline) = {
  page(fill: colors.at(key), footer: none, align(horizon, {
    part.update((name: name, color: colors.at(key)))
    set text(fill: white)
    text(size: 54pt, weight: "bold", name)
    v(0.2em)
    text(size: 24pt, tagline)
  }))
}

#let note(body) = text(size: 0.8em, fill: luma(90), body)

#let exercise(service, url, tasks) = {
  context block(
    fill: part.get().color.lighten(88%), inset: 14pt, radius: 6pt, width: 100%,
    [Open #link(url)[#service] and paste the sample file.])
  v(0.3em)
  enum(..tasks)
}

// ---------------------------------------------------------------- title

#page(footer: none, align(horizon, {
  text(size: 50pt, weight: "bold", fill: colors.intro, course-title)
  v(0.1em)
  text(size: 24pt, course-subtitle)
  v(2em)
  text(size: 18pt)[Tobias Oetiker \ OETIKER+PARTNER AG]
}))

#part.update((name: course-title, color: colors.intro))

== Learning a new language got cheap

- *Before:* a missing brace, a cryptic error message, and days
  in manuals and forums to find the cause.
- *Now:* LLMs know these languages very well. Paste the
  error, get an explanation and a fix in seconds.
- The painful part of learning a computer language is (mostly) gone.

#v(0.6em)
*What remains is your part:* know what the language can do,
ask for the right thing, and recognise a good answer.

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

#let road(src, tool, out, c) = (
  text(fill: c, weight: "bold", src), sym.arrow.r, tool, sym.arrow.r, out,
)
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

All four languages use *logical markup*:

#grid(
  columns: (auto, auto), column-gutter: 3em, row-gutter: 0.8em,
  [LaTeX: `\section{Introduction}`], [Markdown: `## Introduction`],
  [HTML: `<h2>Introduction</h2>`], [Typst: `= Introduction`],
)

Each line says the same thing: _“this is a section heading”_.
The size, font and numbering come from somewhere else:

- the document class (LaTeX)
- the style sheet (HTML with CSS)
- the renderer (Markdown)
- `set` and `show` rules (Typst)

== Fifty years of markup

#let timeline(events) = {
  let (y0, y1) = (1974, 2027)
  box(width: 100%, height: 9cm, {
    place(horizon, line(length: 100%, stroke: 3pt + luma(200)))
    for (i, ev) in events.enumerate() {
      let (year, label, c) = ev
      let x = (year - y0) / (y1 - y0) * 100%
      let up = calc.even(i)
      place(left + horizon, dx: x - 5pt, circle(radius: 5pt, fill: c))
      place(left + horizon, dx: x - 1pt, dy: if up { -1.1cm } else { 1.1cm },
        line(angle: 90deg, length: 1.2cm, stroke: 1pt + c))
      place(left + horizon, dx: x - 1.6cm, dy: if up { -2.6cm } else { 2.6cm },
        box(width: 3.2cm, align(center, text(size: 13pt, {
          text(weight: "bold", fill: c, str(year)); linebreak(); label
        }))))
    }
  })
}
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

- a title and an author
- a paragraph with *bold*, _italic_ and `inline code`
- two sections, each with a subsection
- a bullet list, a numbered list and a small table
- a short Python program as a code block
- comments that explain the markup

#v(0.5em)
The text stays the same. Only the markup changes.
All files are in the `examples/` folder.

// ================================================================ LaTeX

#part-slide("latex", "LaTeX", [Beautiful documents on paper, since 1984])

== What is LaTeX for?

- Scientific and technical documents: papers, theses, reports, books
- Excellent typesetting: line breaks, hyphenation, spacing
- The best mathematical formulas: $sum_(k=1)^n k = (n(n+1))/2$
- The standard in maths, physics and computer science;
  many journals accept only LaTeX
- The product is a *PDF*: fixed pages, made for print

== History

- *1977:* Donald Knuth does not like the typesetting of the
  new edition of his book _The Art of Computer Programming_.
  He writes his own typesetting system: *TeX* (first release 1978).
- TeX is frozen. Its version number approaches $pi$: today 3.141592653.
- *1984:* Leslie Lamport writes *LaTeX*: macros on top of TeX
  for _logical_ markup (`\section` instead of “big bold font”).
- *1994:* LaTeX2e. This is still the LaTeX you use today;
  the LaTeX Project team keeps improving it.
- New engines: pdfTeX (makes PDF directly), XeTeX and LuaTeX
  (Unicode and the fonts of your system).

== The source (1/2)

#src("/examples/sample.tex", "latex", to: 28, split: 18, size: 13pt)

== The source (2/2)

#src("/examples/sample.tex", "latex", from: 29, split: 47, size: 13pt)

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

- Commands: `\name{argument}`, for example `\textbf{bold}`
- Environments: `\begin{itemize}` … `\end{itemize}`
- `%` starts a comment until the end of the line
- An empty line starts a new paragraph
- These characters are special: `# $ % & ~ _ ^ \ { }`. \
  Write them as `\# \$ \% \& \_` and so on.

#v(0.4em)
*The classic trap:* write `file_name.txt` in the text and you get

```
! Missing $ inserted.
```

The `_` means “subscript”, and that is only allowed in maths.
Write `file\_name.txt`. An LLM explains messages like this one immediately.

== Where LaTeX shines

- *Maths:* the reference. MathJax and KaTeX show LaTeX maths on the web,
  and Markdown and Word accept its syntax.
- *Numbers that stay correct:* cross-references, table of contents,
  index, bibliography (BibTeX, biblatex)
- *Fine typography:* line breaks chosen for the whole paragraph, hyphenation
- *Stable:* a document from the 1990s still compiles today
- *Accepted everywhere:* journals, arXiv, publishers' templates

== Strength: maths and cross-references

#grid(columns: (1fr, 1fr), column-gutter: 1em, align: horizon,
  src("/examples/strength-latex.tex", "latex", size: 11pt),
  framed(image("/build/strength-latex.pdf", width: 100%)),
)

== Using LaTeX

*On the web:*
- #link("https://www.overleaf.com")[Overleaf]: free account, live preview, work together on a document

*On your computer:*
- *TeX Live* (Linux, Windows), *MacTeX* (macOS): a full install is several GB
- *MiKTeX* (Windows): small install, gets packages when you need them
- Compile: `latexmk -pdf sample.tex` (runs LaTeX as often as needed)
- Editors: TeXstudio, VS Code with _LaTeX Workshop_

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

// ================================================================ HTML

#part-slide("html", "HTML", [The language of the web browser, since 1991])

== What is HTML for?

- Pages for the *web*: a browser shows them
- *Links* between documents: that is the “hyper” in HyperText
- No fixed pages: the text flows to fit every screen,
  from a phone to a wall display
- Also inside e-mails, e-books (EPUB is HTML) and help systems
- *HTML* says what things are. *CSS* says how they look.

== History

- *1989:* Tim Berners-Lee at CERN proposes a system to share
  documents between physicists.
- *1990:* The first browser, _WorldWideWeb_, is also an *editor*.
  The plan: writing a page is as easy as reading one.
- *1991:* “HTML Tags”: 18 simple elements, based on SGML.
- *1994–1996:* W3C is founded. Håkon Wium Lie proposes CSS; CSS 1 follows in 1996.
- *Browser wars:* each browser adds its own tags (`<font>`, `<blink>`, `<marquee>`).
- *2004:* WHATWG (Apple, Mozilla, Opera) continues HTML.
  *2014:* HTML5. Since 2019: one _HTML Living Standard_.

== The source: head and style sheet

#src("/examples/sample.html", "html", to: 18, size: 16pt)

== The source: body (1/2)

#src("/examples/sample.html", "html", from: 19, to: 37, size: 12.5pt)

== The source: body (2/2)

#src("/examples/sample.html", "html", from: 38, size: 12.5pt)

== The result

#grid(columns: (auto, 1fr), column-gutter: 1.2em,
  framed(image("/build/sample-html.png", height: 11.5cm)),
  [
    Open the file in a browser. That is all.

    - No automatic numbers: we typed “1.1”.
    - The CSS in `<style>` sets fonts, widths and borders.
    - Make the window narrow: the text reflows.
  ],
)

== The rules

- Elements: `<tag>content</tag>`, for example `<em>word</em>`
- Attributes: `<html lang="en">`
- Some elements have no end: `<meta …>`, `<br>`, `<img …>`
- Comments: `<!-- … -->` in HTML, `/* … */` in CSS
- Spaces and line breaks in the source collapse to one space.
  Only `<pre>` keeps them.
- `<` and `&` must be written as `&lt;` and `&amp;`

#v(0.3em)
*CSS* is a second language:
`selector { property: value; }`, for example `h1 { text-align: center; }`

== HTML was meant to be human friendly

#let strip(s) = s.replace(regex("(?s)<!--.*?-->"), "").replace(regex("\[//\]: #.*\n"), "")
#let html-len = strip(read("/examples/sample.html")).len()
#let md-len = strip(read("/examples/sample.md")).len()

The idea in 1991: a few simple tags that anybody can type.
It did not turn out that way:

- The text hides between tags. Without comments, our sample has
  *#html-len characters in HTML* and *#md-len in Markdown*.
- Every list item, every table cell needs its own start and end tag.
- Browsers accept broken HTML and guess what you meant.
  So errors stay invisible until another browser guesses differently.
- The look moved to CSS: now you must learn two languages.

#v(0.3em)
*Result:* today, most HTML is written by programs: content management
systems, Markdown converters, site generators, JavaScript frameworks.

== Where HTML shines

- *Runs everywhere:* every device has a browser. Nothing to install.
- *Every screen:* the page reflows. Readers can zoom, choose dark mode,
  or listen with a screen reader.
- *Links:* to a place in the page, or anywhere on the web
- *Interaction:* forms, video, audio, and with JavaScript anything
- *CSS:* one change restyles every page of a site
- *Backwards compatible:* pages from 1995 still open today

== Strength: one page, every screen

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  src("/examples/strength-html.html", "html", from: 8, to: 31, size: 9pt),
  {
    framed(image("/build/strength-html-wide.png", width: 100%))
    v(0.4em)
    grid(columns: (auto, 1fr), column-gutter: 0.8em, align: bottom,
      framed(image("/build/strength-html-narrow.png", height: 7.2cm)),
      note[The same file, 900 and 360 pixels wide. No JavaScript.],
    )
  },
)

== Using HTML

*You have all you need already:* a text editor and a browser.

- Open the file directly (`file:///…/sample.html`) and press reload after each change
- Developer tools (#box[`F12`]) show how the browser understands your page
- VS Code with _Live Preview_ reloads on every save
- Check your page: #link("https://validator.w3.org")[validator.w3.org]
- Reference: #link("https://developer.mozilla.org")[MDN Web Docs]

*On the web:* #link("https://codepen.io/pen/")[CodePen], #link("https://jsfiddle.net")[JSFiddle]:
edit HTML and CSS, see the result live.

== Extensions

HTML itself has no packages. It grows in layers:

- *CSS* for the look, *JavaScript* for behaviour
- *Classless style sheets*: add one `<link>` line and plain HTML
  looks good (Pico CSS, Water.css, simple.css)
- *Frameworks*: Bootstrap, Tailwind
- *Libraries*: KaTeX or MathJax for formulas, highlight.js or Prism for code
- *Web Components*: define your own elements, like `<my-chart>`

== Your turn: HTML (10 minutes)

#exercise("CodePen", "https://codepen.io/pen/", (
  [Paste the `<body>` into the HTML box and the CSS into the CSS box.],
  [Add a third row to the table.],
  [Add a link to `https://typst.app` with `<a href="…">`.],
  [Colour all `h2` headings with CSS.],
  [Add the line `if a < b and b > c:` to the program. What must you change?],
))

// ================================================================ Markdown

#part-slide("markdown", "Markdown", [Plain text that stays readable, since 2004])

== What is Markdown for?

- Text that is *easy to read as plain text* and can become HTML
- README files, documentation, wikis, notes, forum posts, chat messages
- GitHub, GitLab, Stack Overflow, Obsidian, Jupyter … all speak it
- LLMs answer in Markdown, too
- The product is usually *HTML*. But there are also renderers for the
  terminal, and converters to PDF, Word, slides …

== History

- *2004:* John Gruber, with help from Aaron Swartz, writes a Perl script:
  `Markdown.pl` converts text to HTML.
- The idea comes from plain-text e-mail: `*stars*`, `> quotes`, `- lists`.
- The goal: _“readable as-is, without looking like it has been marked up”_.
- The description was informal and left many cases open.
  The last release came in December 2004.
- *2008 and later:* GitHub, Stack Overflow, Reddit adopt Markdown,
  and each one adds its own extensions.
- *2014:* *CommonMark*: an exact specification with a test suite.
  *2017:* *GitHub Flavored Markdown* (GFM) = CommonMark + tables, task lists, …

== The source

#src("/examples/sample.md", "markdown", split: 26, size: 11.5pt)

== The result in a browser

#grid(columns: (auto, 1fr), column-gutter: 1.2em,
  framed(image("/build/sample-md.png", height: 11.5cm)),
  [
    `pandoc -f gfm --standalone`\
    `  sample.md -o sample.html`

    - Headings, lists and the table become HTML.
    - No numbers on the headings.
    - The look comes from pandoc's default style.
  ],
)

== The result in a terminal

#grid(columns: (1fr, 1fr), column-gutter: 0.6em,
  terminal("/build/sample-md-term.json", to: 20, size: 8.8pt),
  terminal("/build/sample-md-term.json", from: 21, size: 8.8pt),
)
#note[`mdmost sample.md`: a pager like `less`, but for Markdown.]

== The rules

- `#`, `##`, `###`: headings
- `*italic*` or `_italic_`, `**bold**`, #raw("`code`")
- `-` or `*` for bullets, `1.` for numbered lists
- Indent to nest a list
- An empty line starts a new paragraph
- Three backticks start a code block, with the language name after them
- `[text](https://example.com)` makes a link
- Keep HTML out: it spoils the readable source

== Where Markdown shines

- *The source is the document:* the markup stays out of the way.
  You can read a README in a terminal, a mail or a diff without rendering it.
- *Almost nothing to learn:* five minutes, and you can start
- *Plain text in git:* clean diffs, easy merges
- *Everywhere:* GitHub, wikis, chat, note apps, documentation sites
- *One source, many outputs* with Pandoc

== Markdown: the language of LLMs

- Chatbots answer in Markdown, and the chat window renders it.
- LLMs learned from a web full of Markdown (GitHub, Stack Overflow),
  so they read and write it fluently.
- Instructions for coding agents are Markdown files:
  `README.md`, `AGENTS.md`, `CLAUDE.md`
- `llms.txt` (a proposal from 2024): a Markdown summary of a web site, for LLMs
- Few characters for much content (our sample: #md-len in Markdown,
  #html-len in HTML). That means fewer tokens, lower cost and more room
  in the context.

#v(0.3em)
*Tip:* ask the LLM for Markdown, then convert it with Pandoc.

== One name, many languages

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    *Flavours*
    - Original (Gruber, 2004)
    - CommonMark
    - GitHub Flavored Markdown
    - Pandoc Markdown
    - MultiMarkdown, PHP Markdown Extra
    - R Markdown, Quarto, MDX, Obsidian …
  ],
  [
    *They do not agree on*
    - tables and footnotes
    - maths: `$x^2$`
    - task lists: `- [ ]`
    - a title block (YAML “front matter”)
    - how far to indent nested lists
    - comments: there are none
  ],
)

== The same table, two flavours

#src("/slides/table.md", "markdown", size: 13pt)

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    `pandoc -f markdown_strict`
    #src("/build/flavor-strict.html", "html", size: 11pt)
  ],
  [
    `pandoc -f gfm`
    #src("/build/flavor-gfm.html", "html", size: 11pt)
  ],
)

== And comments?

Markdown has no comment syntax. Two tricks are common:

```markdown
[//]: # (a link definition that is never used)
<!-- an HTML comment -->
```

- The link trick is ugly, but every renderer drops it.
  Our sample uses it.
- The HTML comment works in a browser. But it is HTML inside Markdown.

#v(0.3em)
*Keep HTML out of Markdown.* The point of Markdown is to stay out of
the way, so that people can read the file as it is. Tags spoil that.
Some renderers, like `mdmost`, do not show HTML at all, on purpose.
If you need HTML, write HTML.

== Metadata: YAML front matter

#grid(columns: (1fr, 1fr), column-gutter: 1.2em,
  {
    src("/examples/frontmatter.md", "markdown", size: 13pt)
    set text(size: 16pt)
    [
      - YAML between two `---` lines, at the very top
      - Title, author, date and tags stay out of the text.
        The body stays clean.
    ]
  },
  {
    [`pandoc -f markdown --standalone`]
    framed(image("/build/frontmatter.png", width: 100%))
    set text(size: 16pt)
    [Also read by Jekyll, Hugo, Astro, Obsidian (“Properties”).
     GitHub shows it as a table.]
  },
)

== Not every reader knows front matter

The same file, read as plain CommonMark: `pandoc -f commonmark`

#src("/build/frontmatter-commonmark.html", "html", size: 13pt)

- The first `---` becomes a horizontal rule.
- The YAML lines become a paragraph, and the second `---` under them
  turns that paragraph into a heading.
- `pandoc -f gfm` drops the block without a word.

*Again:* know which flavour your tools read.

== Using Markdown

*On your computer:*
- Any text editor. VS Code shows a preview with #box[`Ctrl+Shift+V`].
- Read it in the terminal: `mdmost sample.md`
- Convert it: `pandoc sample.md -o sample.html`
- Note apps built on Markdown: Obsidian, Zettlr, Typora

*On the web:*
- GitHub and GitLab show every `.md` file (and your README) as a page
- #link("https://dillinger.io")[Dillinger], #link("https://stackedit.io")[StackEdit]:
  editor and preview side by side
- HedgeDoc: write Markdown together

== Extensions

Markdown has no packages. Extensions live *in the tool* that converts it:

- pandoc: filters (for example in Lua)
- markdown-it, remark, Python-Markdown: plugins

Popular extensions:

- maths with KaTeX or MathJax: `$E = m c^2$`
- diagrams: a code block with the language `mermaid` (GitHub draws it)
- call-out boxes: `> [!NOTE]` on GitHub
- footnotes: `text[^1]`

#note[Each extension works only in the tools that know it.]

== Your turn: Markdown (10 minutes)

#exercise("Dillinger", "https://dillinger.io", (
  [Add a third row to the table.],
  [Add a nested list: a bullet list inside item 2 of the numbered list.],
  [Add a link to `https://commonmark.org`.],
  [Force a line break inside a paragraph, without a new paragraph.],
  [Paste the same text into #link("https://stackedit.io")[StackEdit]. Do you see a difference?],
))

// ================================================================ Typst

#part-slide("typst", "Typst", [Like LaTeX, but made in this century: since 2023])

== What is Typst for?

- The same jobs as LaTeX: papers, theses, reports, letters, slides
  (_this_ deck is Typst)
- Very fast: the preview changes while you type
- Error messages you can understand
- Markup as light as Markdown, and one real programming language
  for everything else
- The product is a *PDF*. HTML output is experimental.

== History

- *2019:* Laurenz Mädje and Martin Haug start Typst at TU Berlin.
  They do not want to fight LaTeX any more.
- *2022:* their master's theses: the language and fast incremental compilation
- *March 2023:* the compiler becomes open source (Apache 2.0, written in Rust),
  and the web app #link("https://typst.app")[typst.app] opens to everybody.
- Typst GmbH (Berlin) earns its money with the web app.
  The compiler stays free.
- Still version 0.x: a new version can change things.
  This deck uses Typst #sys.version.

== The source

#src("/examples/sample.typ", "typ", split: 30, size: 11pt)

== The result

#grid(columns: (auto, 1fr), column-gutter: 1.2em,
  framed(image("/build/sample-typst.pdf", page: 1, height: 11.5cm)),
  [
    `typst compile sample.typ`

    - Numbers on the headings come from one `set heading` rule.
    - Syntax highlighting in the code block is built in.
    - A4 page: from `set page`.
  ],
)

== The rules

- *Markup mode* (the default): `= Heading`, `*bold*`, `_italic_`,
  #raw("`code`"), `-` bullet, `+` numbered, empty line = paragraph
- `#` switches to *code mode*: `#table(…)`, `#image("x.png")`
- `[ … ]` is content (markup) inside code
- `// comment` and `/* comment */`
- `#set` changes the defaults of an element: `#set text(size: 11pt)`
- `#show` changes how an element looks

#v(0.3em)
*Watch out:* `*text*` is _italic_ in Markdown, but *bold* in Typst!

== Where Typst shines

- *One language* for markup and programming: variables, loops,
  functions, data from CSV, JSON or YAML files
- *Instant:* it compiles only what changed, and the preview follows your typing
- *Clear error messages* that point at the exact place
- *`set` and `show` rules:* change the look of every element in one place
- *Maths with less typing:* `$sum_(k=1)^n k$` gives $sum_(k=1)^n k$
- *Modern defaults:* Unicode, system fonts, tagged PDF for accessibility

== Strength: scripting in the document

#grid(columns: (1fr, 1fr), column-gutter: 1em, align: horizon,
  src("/examples/strength-typst.typ", "typ", size: 10pt),
  framed(image("/build/strength-typst.pdf", width: 100%)),
)

== How this deck works

#between("/slides/slides.typ", "typ", "// <demo>", "// </demo>", size: 12pt)

== Using Typst

*On the web:*
- #link("https://typst.app")[typst.app]: free account, live preview, work together

*On your computer:*
- One single program (about 55 MB), no big installation
- `typst compile sample.typ`: make the PDF once
- `typst watch sample.typ`: make it again on every save
- VS Code with _Tinymist_: live preview and completion
- Install with a package manager, or download from GitHub

== Packages

```typ
#import "@preview/name:version"
```

Typst downloads the package automatically from
#link("https://typst.app/universe")[Typst Universe].

- `cetz`: drawings
- `fletcher`: diagrams with arrows
- `codly`: nicer code blocks
- `touying`, `polylux`: slides
- templates for theses, letters, journals: `typst init @preview/…`

#note[Many packages are young, too: check the version number.]

== Your turn: Typst (10 minutes)

#exercise("typst.app", "https://typst.app", (
  [Create an empty project and paste `sample.typ`.],
  [Add a third row to the table.],
  [Add a subsection “Pitfalls” with a numbered list of two items.],
  [Change the heading numbers to `I.a` with one change to a `set` rule.],
  [Make the text justified (hint: `par`).],
))

// ================================================================ wrap-up

#part-slide("intro", "Wrap-up", [Four languages, one idea])

== Side by side

#{
  set text(size: 13pt)
  let r(..cells) = cells.pos().map(c => if type(c) == str { raw(c) } else { c })
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [], text(fill: colors.latex)[*LaTeX*], text(fill: colors.html)[*HTML*],
      text(fill: colors.markdown)[*Markdown*], text(fill: colors.typst)[*Typst*]),
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
  src("/build/pandoc-sample.typ", "typ", to: 22, size: 10pt),
)

== Strengths at a glance

#{
  set text(size: 13pt)
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [], text(fill: colors.latex)[*LaTeX*], text(fill: colors.html)[*HTML*],
      text(fill: colors.markdown)[*Markdown*], text(fill: colors.typst)[*Typst*]),
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
  stroke: none, inset: (x: 0pt, y: 7pt), column-gutter: 1.5em,
  [A paper for a journal, lots of maths, a publisher's template], text(fill: colors.latex)[*LaTeX*],
  [A web page, or a document with interactive parts], text(fill: colors.html)[*HTML*],
  [README, notes, documentation, a wiki page, a chat message], text(fill: colors.markdown)[*Markdown*],
  [A new PDF document: report, thesis, letter, slides], text(fill: colors.typst)[*Typst*],
  [The same text in many formats], [*Markdown + Pandoc*],
)

== Let the LLM help you well

- Paste the *complete* error message and the lines around it.
- Ask for the smallest fix, and ask *why* it works.
- Say what you use: “LaTeX with pdflatex”, “GitHub Markdown”, “Typst 0.15”.
- Ask for the basic way first: “without extra packages”.
- Compile and look at the result. The LLM can be wrong, too.

== Links

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    *LaTeX*
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
