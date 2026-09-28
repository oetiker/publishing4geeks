// HTML
#import "../lib.typ": *

#part-slide("html", "HTML", [The language of the web browser, since 1991])

== What is HTML for?

#two[
- Pages for the *web*: a browser shows them
- *Links* between documents: that is the “hyper” in HyperText
- No fixed pages: the text flows to fit every screen,
  from a phone to a wall display
][
- Also inside e-mails, e-books (EPUB is HTML) and help systems
- *HTML* says what things are. *CSS* says how they look.
]

== History

#two[
- *1989:* Tim Berners-Lee at CERN proposes a system to share
  documents between physicists.
- *1990:* The first browser, _WorldWideWeb_, is also an *editor*.
  The plan: writing a page is as easy as reading one.
- *1991:* “HTML Tags”: 18 simple elements, based on SGML.
][
- *1994–1996:* W3C is founded. Håkon Wium Lie proposes CSS;
  CSS 1 follows in 1996.
- *Browser wars:* each browser adds its own tags
  (`<font>`, `<blink>`, `<marquee>`).
- *2004:* WHATWG (Apple, Mozilla, Opera) continues HTML.
  *2014:* HTML5. Since 2019: one _HTML Living Standard_.
]

== The source: head and style sheet

#src("/examples/sample.html", "html", until: "<h1>", size: code.large)

== The source: body (1/2)

#src("/examples/sample.html", "html", from: "<h1>", until: "<h2>2 How to do it")

== The source: body (2/2)

#src("/examples/sample.html", "html", from: "<h2>2 How to do it")

== The result

#grid(columns: (1.9fr, 1fr), column-gutter: 1.2em,
  browser("/build/sample-html.png", title: "Counting Words",
    url: "file:///…/examples/sample.html"),
  [
    Open the file in a browser. That is all.

    - No automatic numbers: we typed “1.1”.
    - The CSS in `<style>` sets fonts, widths and borders.
    - Make the window narrow: the text reflows.
  ],
)

== The rules

#two[
- Elements: `<tag>content</tag>`, for example `<em>word</em>`
- Attributes: `<html lang="en">`
- Some elements have no end: `<meta …>`, `<br>`, `<img …>`
- Comments: `<!-- … -->` in HTML, `/* … */` in CSS
][
- Spaces and line breaks in the source collapse to one space.
  Only `<pre>` keeps them.
- `<` and `&` must be written as `&lt;` and `&amp;`
- *CSS* is a second language: `selector { property: value; }`,
  for example `h1 { text-align: center; }`
]

== HTML was meant to be human friendly

The idea in 1991: a few simple tags that anybody can type.
It did not turn out that way:

#two[
- The text hides between tags. Without comments, our sample has
  *#html-len characters in HTML* and *#md-len in Markdown*.
- Every list item, every table cell needs its own start and end tag.
][
- Browsers accept broken HTML and guess what you meant.
  So errors stay invisible until another browser guesses differently.
- The look moved to CSS: now you must learn two languages.
]

#v(0.3em)
*Result:* today, most HTML is written by programs: content management
systems, Markdown converters, site generators, JavaScript frameworks.

== Where HTML shines

#two[
- *Runs everywhere:* every device has a browser. Nothing to install.
- *Every screen:* the page reflows. Readers can zoom, choose dark mode,
  or listen with a screen reader.
- *Links:* to a place in the page, or anywhere on the web
][
- *Interaction:* forms, video, audio, and with JavaScript anything
- *CSS:* one change restyles every page of a site
- *Backwards compatible:* pages from 1995 still open today
]

== Where HTML hurts

#two[
- *Hard to read:* the text hides between tags
- *Two or three languages:* HTML, CSS, and JavaScript for anything dynamic
- *Silent errors:* browsers accept broken HTML, so mistakes stay invisible
][
- *Weak on paper:* page breaks, footnotes and headers are hard to control
- *No document features built in:* no table of contents, no cross-references
- *Maths:* MathML works in current browsers, but nobody writes it by hand
- *Many files:* a page with images and CSS is harder to pass on than a PDF
]

== Strength: one page, every screen

#grid(columns: (1fr, 1fr), column-gutter: 1em,
  src("/examples/strength-html.html", "html", size: code.small),
  {
    browser("/build/strength-html-wide.png", title: "Tools",
      url: "file:///…/strength-html.html")
    v(0.4em)
    grid(columns: (auto, 1fr), column-gutter: 0.8em, align: bottom,
      browser("/build/strength-html-narrow.png", title: "Tools",
        url: "…", width: 3.3cm),
      note[The same file, 900 and 360 pixels wide. No JavaScript.],
    )
  },
)

== Using HTML

#two[
*You have all you need already:* a text editor and a browser.
- Open the file directly (`file:///…/sample.html`) and press reload
  after each change
- Developer tools (#box[`F12`]) show how the browser understands your page
- VS Code with _Live Preview_ reloads on every save
][
- Check your page: #link("https://validator.w3.org")[validator.w3.org]
- Reference: #link("https://developer.mozilla.org")[MDN Web Docs]

*On the web*
- #link("https://codepen.io/pen/")[CodePen], #link("https://jsfiddle.net")[JSFiddle]:
  edit HTML and CSS, see the result live
]

== Extensions

HTML itself has no packages. It grows in layers:

#two[
- *CSS* for the look, *JavaScript* for behaviour
- *Classless style sheets*: add one `<link>` line and plain HTML
  looks good (Pico CSS, Water.css, simple.css)
][
- *Frameworks*: Bootstrap, Tailwind
- *Libraries*: KaTeX or MathJax for formulas, highlight.js or Prism for code
- *Web Components*: define your own elements, like `<my-chart>`
]

== Your turn: HTML (10 minutes)

#exercise("CodePen", "https://codepen.io/pen/", (
  [Paste the `<body>` into the HTML box and the CSS into the CSS box.],
  [Add a third row to the table.],
  [Add a link to `https://typst.app` with `<a href="…">`.],
  [Colour all `h2` headings with CSS.],
  [Add the line `if a < b and b > c:` to the program. What must you change?],
))
