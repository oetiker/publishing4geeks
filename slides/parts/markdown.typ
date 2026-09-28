// Markdown
#import "../lib.typ": *

#part-slide("markdown", "Markdown", [Plain text that stays readable, since 2004])

== What is Markdown for?

#two[
- Text that is *easy to read as plain text* and can become HTML
- README files, documentation, wikis, notes, forum posts, chat messages
- GitHub, GitLab, Stack Overflow, Obsidian, Jupyter … all speak it
][
- LLMs answer in Markdown, too
- The product is usually *HTML*. But there are also renderers for the
  terminal, and converters to PDF, Word, slides …
]

== History

#two[
- *2004:* John Gruber, with help from Aaron Swartz, writes a Perl script:
  `Markdown.pl` converts text to HTML.
- The idea comes from plain-text e-mail: `*stars*`, `> quotes`, `- lists`.
- The goal: _“readable as-is, without looking like it has been marked up”_.
][
- The description was informal and left many cases open.
  The last release came in December 2004.
- *2008 and later:* GitHub, Stack Overflow, Reddit adopt Markdown,
  and each one adds its own extensions.
- *2014:* *CommonMark*: an exact specification with a test suite.
  *2017:* *GitHub Flavored Markdown* (GFM) = CommonMark + tables, task lists, …
]

== The source

#src("/examples/sample.md", "markdown", split: "## How to do it")

== The result in a browser

#grid(columns: (1.9fr, 1fr), column-gutter: 1.2em,
  browser("/build/sample-md.png", title: "Counting Words",
    url: "file:///…/sample.html"),
  [
    `pandoc -f gfm --standalone`\
    `  sample.md -o sample.html`

    - Headings, lists and the table become HTML.
    - No numbers on the headings.
    - The look comes from pandoc's default style.
  ],
)

== The result in a terminal

#terminal("/build/sample-md-term.json", split: "How to do it")
#note[`mdmost sample.md`: a pager like `less`, but for Markdown.]

== The rules

#two[
- `#`, `##`, `###`: headings
- `*italic*` or `_italic_`, `**bold**`, #raw("`code`")
- `-` or `*` for bullets, `1.` for numbered lists
- Indent to nest a list
][
- An empty line starts a new paragraph
- Three backticks start a code block, with the language name after them
- `[text](https://example.com)` makes a link
- Keep HTML out: it spoils the readable source
]

== Where Markdown shines

#two[
- *The source is the document:* the markup stays out of the way.
  You can read a README in a terminal, a mail or a diff without rendering it.
- *Almost nothing to learn:* five minutes, and you can start
][
- *Plain text in git:* clean diffs, easy merges
- *Everywhere:* GitHub, wikis, chat, note apps, documentation sites
- *One source, many outputs* with Pandoc
]

== Where Markdown hurts

#two[
- *Many flavours:* a file that works in one tool breaks in another
- *Little structure:* no captions, no cross-references, no variables,
  no includes, no comments
- *Tables:* an extension; pipes are tedious to align, and a cell holds
  only one line
][
- *No control of the look:* the renderer decides
- *Invisible rules:* the indent of nested lists, two trailing spaces
  for a line break
- *When you need more,* you add HTML or extensions, and the readable
  source is gone
]

== Markdown: the language of LLMs

#two[
- Chatbots answer in Markdown, and the chat window renders it.
- LLMs learned from a web full of Markdown (GitHub, Stack Overflow),
  so they read and write it fluently.
- Instructions for coding agents are Markdown files:
  `README.md`, `AGENTS.md`, `CLAUDE.md`
][
- `llms.txt` (a proposal from 2024): a Markdown summary of a web site, for LLMs
- Few characters for much content (our sample: #md-len in Markdown,
  #html-len in HTML). That means fewer tokens, lower cost and more room
  in the context.
- *Tip:* ask the LLM for Markdown, then convert it with Pandoc.
]

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

#src("/slides/table.md", "markdown", size: code.large)

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  [
    `pandoc -f markdown_strict`
    #src("/build/flavor-strict.html", "html")
  ],
  [
    `pandoc -f gfm`
    #src("/build/flavor-gfm.html", "html")
  ],
)

== And comments?

#two[
Markdown has no comment syntax. Two tricks are common:

```markdown
[//]: # (a link that is never used)
<!-- an HTML comment -->
```

- The link trick is ugly, but every renderer drops it.
  Our sample uses it.
- The HTML comment works in a browser. But it is HTML inside Markdown.
][
*Keep HTML out of Markdown.*

The point of Markdown is to stay out of the way, so that people can
read the file as it is. Tags spoil that.

Some renderers, like `mdmost`, do not show HTML at all, on purpose.

If you need HTML, write HTML.
]

== Metadata: YAML front matter

#grid(columns: (1fr, 1fr), column-gutter: 1.2em,
  {
    src("/examples/frontmatter.md", "markdown", size: code.large)
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

#src("/build/frontmatter-commonmark.html", "html", size: code.large)

#two[
- The first `---` becomes a horizontal rule.
- The YAML lines become a paragraph, and the second `---` under them
  turns that paragraph into a heading.
][
- `pandoc -f gfm` drops the block without a word.
- *Again:* know which flavour your tools read.
]

== Using Markdown

#two[
*On your computer*
- Any text editor. VS Code shows a preview with #box[`Ctrl+Shift+V`].
- Read it in the terminal: `mdmost sample.md`
- Convert it: `pandoc sample.md -o sample.html`
- Note apps built on Markdown: Obsidian, Zettlr, Typora
][
*On the web*
- GitHub and GitLab show every `.md` file (and your README) as a page
- #link("https://dillinger.io")[Dillinger], #link("https://stackedit.io")[StackEdit]:
  editor and preview side by side
- HedgeDoc: write Markdown together
]

== Extensions

Markdown has no packages. Extensions live *in the tool* that converts it.

#two[
*Tools*
- pandoc: filters (for example in Lua)
- markdown-it, remark, Python-Markdown: plugins
][
*Popular extensions*
- maths with KaTeX or MathJax: `$E = m c^2$`
- diagrams: a code block with the language `mermaid` (GitHub draws it)
- call-out boxes: `> [!NOTE]` on GitHub
- footnotes: `text[^1]`
]

#note[Each extension works only in the tools that know it.]

== Your turn: Markdown (10 minutes)

#exercise("Dillinger", "https://dillinger.io", (
  [Add a third row to the table.],
  [Add a nested list: a bullet list inside item 2 of the numbered list.],
  [Add a link to `https://commonmark.org`.],
  [Force a line break inside a paragraph, without a new paragraph.],
  [Paste the same text into #link("https://stackedit.io")[StackEdit]. Do you see a difference?],
))
