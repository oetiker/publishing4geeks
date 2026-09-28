// Typst
#import "../lib.typ": *

#part-slide("typst", "Typst", [Like LaTeX, but made in this century: since 2023])

== What is Typst for?

#two[
- The same jobs as LaTeX: papers, theses, reports, letters, slides
  (_this_ deck is Typst)
- Very fast: the preview changes while you type
- Error messages you can understand
][
- Markup as light as Markdown, and one real programming language
  for everything else
- The product is a *PDF*. HTML output is experimental.
]

== History

#two[
- *2019:* Laurenz Mädje and Martin Haug start Typst at TU Berlin.
  They do not want to fight LaTeX any more.
- *2022:* their master's theses: the language and fast incremental compilation
- *March 2023:* the compiler becomes open source (Apache 2.0, written in Rust),
  and the web app #link("https://typst.app")[typst.app] opens to everybody.
][
- Typst GmbH (Berlin) earns its money with the web app.
  The compiler stays free.
- Still version 0.x: a new version can change things.
  This deck uses Typst #sys.version.
]

== The source

#src("/examples/sample.typ", "typ", split: "= How to do it")

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

#two[
- *Markup mode* (the default): `= Heading`, `*bold*`, `_italic_`,
  #raw("`code`"), `-` bullet, `+` numbered, empty line = paragraph
- `#` switches to *code mode*: `#table(…)`, `#image("x.png")`
- `[ … ]` is content (markup) inside code
][
- `// comment` and `/* comment */`
- `#set` changes the defaults of an element: `#set text(size: 11pt)`
- `#show` changes how an element looks
- *Watch out:* `*text*` is _italic_ in Markdown, but *bold* in Typst!
]

== The language behind Typst

#let demo = "#let greet(name) = [Hello *#name*!]
#greet(\"Geeks\")

#let squares = range(1, 5).map(n => n * n)
Squares: #squares.map(str).join(\", \")"

#two[
- *Its own language*, made for Typst: not Lua, not JavaScript.
  The syntax looks familiar: `let`, `if`, `for`, `n => n * n`
- *Three modes:* markup for the text, `#` for code, `$…$` for maths
- *Content is a value:* `[Hello *world*]` can be stored,
  passed to a function and returned
- *Functions are pure:* same input, same output. So Typst can
  recompile only what changed.
][
#src-text(demo, "typ", size: code.large)

#block(inset: (left: 8pt))[#eval(demo, mode: "markup")]

#note[LaTeX macros replace text with text.
  Typst functions compute a value and return it.]
]

== Where Typst shines

#two[
- *One language* for markup and programming: variables, loops,
  functions, data from CSV, JSON or YAML files
- *Instant:* it compiles only what changed, and the preview follows your typing
- *Clear error messages* that point at the exact place
][
- *`set` and `show` rules:* change the look of every element in one place
- *Maths with less typing:* `$sum_(k=1)^n k$` gives $sum_(k=1)^n k$
- *Modern defaults:* Unicode, system fonts, tagged PDF for accessibility
]

== Where Typst hurts

#two[
- *Young:* version 0.x, and a new version can break your document
- *Smaller ecosystem:* fewer packages and templates than LaTeX,
  and few journals accept it
- *LLMs know it less well:* they mix old and new syntax,
  or invent functions. Check against the docs.
][
- *PDF first:* HTML export is still experimental
- *Two modes:* markup and code, switched with `#`; easy to mix up at first
- *Business model:* the compiler is free, the web app is a commercial
  service with a free tier
]

== Strength: scripting in the document

#grid(columns: (1fr, 1fr), column-gutter: 1em, align: horizon,
  src("/examples/strength-typst.typ", "typ", size: code.small),
  framed(image("/build/strength-typst.pdf", width: 100%)),
)

== Using Typst

#two[
*On the web*
- #link("https://typst.app")[typst.app]: free account, live preview, work together
][
*On your computer*
- One single program (about 55 MB), no big installation
- `typst compile sample.typ`: make the PDF once
- `typst watch sample.typ`: make it again on every save
- VS Code with _Tinymist_: live preview and completion
- Install with a package manager, or download from GitHub
]

== Packages

#two[
```typ
#import "@preview/name:version"
```

Typst downloads the package automatically from
#link("https://typst.app/universe")[Typst Universe].

#note[Many packages are young, too: check the version number.]
][
- `cetz`: drawings
- `fletcher`: diagrams with arrows
- `codly`: nicer code blocks
- `touying`, `polylux`: slides
- templates for theses, letters, journals: `typst init @preview/…`
]

== Your turn: Typst (10 minutes)

#exercise("typst.app", "https://typst.app", (
  [Create an empty project and paste `sample.typ`.],
  [Add a third row to the table.],
  [Add a subsection “Pitfalls” with a numbered list of two items.],
  [Change the heading numbers to `I.a` with one change to a `set` rule.],
  [Make the text justified (hint: `par`).],
))
