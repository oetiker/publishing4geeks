// Publishing for Geeks: shared settings and helpers for the slides.
// Every part file starts with `#import "../lib.typ": *`.

#let course-title = "Publishing for Geeks"
#let course-subtitle = [Text in, page out: LaTeX, HTML, Markdown and Typst]
#let repo = "https://github.com/oetiker/publishing4geeks"

#let colors = (
  intro: rgb("#3a3f4b"),
  latex: rgb("#008080"),
  html: rgb("#e34c26"),
  markdown: rgb("#6f42c1"),
  typst: rgb("#239dad"),
)

// The current part (name and colour), read by the footer and the headings.
#let part = state("part", (name: "", color: colors.intro))

// Three sizes for code on slides.
#let code = (small: 9pt, normal: 11.5pt, large: 13.5pt)

// ---------------------------------------------------------------- source files

// Find a line: an integer is a line number (1-based), a string is the
// first line that starts with it (ignoring leading spaces).
#let find-line(lines, key) = {
  if type(key) == int { return key }
  let i = lines.position(l => l.trim(at: start).starts-with(key))
  assert(i != none, message: "no line starts with " + repr(key))
  i + 1
}

// Show a source file from line `from` up to, but not including, line
// `until`. With `split`, a second column starts at that line.
#let src(path, lang, from: 1, until: none, split: none, size: code.normal) = {
  let lines = read(path).trim(at: end).split("\n")
  let a = find-line(lines, from)
  let b = if until == none { lines.len() + 1 } else { find-line(lines, until) }
  let show-lines(x, y) = raw(
    lines.slice(x - 1, y - 1).join("\n").trim(at: end), lang: lang, block: true)
  set text(size: size)
  if split == none {
    show-lines(a, b)
  } else {
    let s = find-line(lines, split)
    grid(columns: (1fr, 1fr), column-gutter: 0.8em, show-lines(a, s), show-lines(s, b))
  }
}

// Show the lines of a file between two marker lines.
#let between(path, lang, start, end, size: code.normal) = {
  let lines = read(path).split("\n")
  src(path, lang, from: find-line(lines, start) + 1, until: end, size: size)
}

// Character counts of the samples without comments: HTML against Markdown.
#let strip-comments(s) = s.replace(regex("(?s)<!--.*?-->"), "").replace(regex("\[//\]: #.*\n"), "")
#let html-len = strip-comments(read("/examples/sample.html")).len()
#let md-len = strip-comments(read("/examples/sample.md")).len()

// ---------------------------------------------------------------- screenshots

// Captured terminal output (see tools/ansi2json.py). With `split`, a second
// screen starts at the first line that contains that text.
#let terminal(path, split: none) = {
  let lines = json(path)
  let screen(part) = block(
    fill: rgb("#fdfcf9"), inset: 8pt, radius: 4pt, stroke: luma(190), {
      set text(font: "JetBrains Mono", size: 8.8pt)  // 64 columns fill half a slide
      for line in part {
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
  if split == none {
    screen(lines)
  } else {
    let i = lines.position(l => l.map(s => s.t).sum(default: "").contains(split))
    assert(i != none, message: "no terminal line contains " + repr(split))
    grid(columns: (1fr, 1fr), column-gutter: 0.6em,
      screen(lines.slice(0, i)), screen(lines.slice(i)))
  }
}

#let framed(body) = box(stroke: 0.5pt + luma(170), body)

// A screenshot inside a simple browser window: tab, address bar, page.
#let browser(img, title: "", url: "", width: 100%) = block(
  width: width, stroke: 0.8pt + luma(165), radius: 7pt, clip: true, fill: white, {
    set text(size: 9pt, font: "Inter")
    let dot(c) = circle(radius: 3.5pt, fill: rgb(c))
    block(fill: luma(222), width: 100%, inset: (left: 8pt, top: 5pt), spacing: 0pt,
      grid(columns: (auto, auto), column-gutter: 10pt, align: horizon,
        stack(dir: ltr, spacing: 4pt, dot("#ff5f57"), dot("#febc2e"), dot("#28c840")),
        box(fill: luma(246), radius: (top: 5pt), inset: (x: 12pt, y: 5pt), title)))
    block(fill: luma(246), width: 100%, inset: (x: 8pt, y: 4pt), spacing: 0pt,
      box(fill: white, stroke: 0.5pt + luma(210), radius: 9pt, inset: (x: 10pt, y: 3pt),
        width: 100%, text(fill: luma(70), url)))
    block(spacing: 0pt, image(img, width: 100%))
  })

// ---------------------------------------------------------------- layout

// Two columns side by side. Typst does not balance columns,
// so each slide splits its content by hand.
#let two(left, right) = grid(
  columns: (1fr, 1fr), column-gutter: 2.2em, left, right)

#let note(body) = text(size: 0.8em, fill: luma(90), body)

// A full-page slide in the part colour that opens a part.
#let part-slide(key, name, tagline) = page(
  fill: colors.at(key), footer: none, align(horizon, {
    part.update((name: name, color: colors.at(key)))
    set text(fill: white)
    text(size: 54pt, weight: "bold", name)
    v(0.2em)
    text(size: 24pt, tagline)
  }))

// A web exercise: the service to open, then the tasks in two columns.
#let exercise(service, url, tasks) = {
  context block(
    fill: part.get().color.lighten(88%), inset: 14pt, radius: 6pt, width: 100%,
    [Open #link(url)[#service] and paste the sample file.])
  v(0.3em)
  let half = calc.ceil(tasks.len() / 2)
  two(enum(..tasks.slice(0, half)),
      enum(start: half + 1, ..tasks.slice(half)))
}

// ---------------------------------------------------------------- diagrams

// One row of the "four roads" diagram: source → tool → product.
#let road(src, tool, out, c) = (
  text(fill: c, weight: "bold", src), sym.arrow.r, tool, sym.arrow.r, out,
)

// Events on a line of years, labels alternating above and below.
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

// A table with one row per property and one column per language.
#let compare(..rows) = table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  table.header(
    [], text(fill: colors.latex)[*LaTeX*], text(fill: colors.html)[*HTML*],
    text(fill: colors.markdown)[*Markdown*], text(fill: colors.typst)[*Typst*]),
  ..rows,
)
