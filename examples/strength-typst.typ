#set page(width: 12cm, height: auto, margin: 1cm)

// #let stores a value in a variable.
#let tools = (
  ("wc", "wc -w file.txt"),
  ("Python", "python3 count.py"),
  ("awk", "awk '{n += NF} END {print n}'"),
)

// A show rule restyles every match.
#show "Typst": set text(fill: rgb("#239dad"))

// Build the table from the data.
#table(
  columns: 2,
  table.header[*Tool*][*Command*],
  ..tools.map(((name, cmd)) => (name, raw(cmd))).flatten(),
)

Typst lists #tools.len() tools for you.

// A loop inside the text.
#for n in range(1, 6) [#n² = #(n * n). ]
