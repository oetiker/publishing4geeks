// Everything after two slashes is a comment.
/* Block comments
   look like this. */

// "set" rules change the defaults of the document.
#set document(title: [Counting Words],
              author: "A. Geek")
#set page(paper: "a4")
#set text(size: 11pt)
// Number the headings: 1, 1.1, 1.2, 2, ...
#set heading(numbering: "1.1")

#title()  // print the title from set document
A. Geek

// An empty line starts a new paragraph.
This is a _short_ sample document. It shows
*bold* text, _italic_ text and
`inline code`.

= Introduction
Counting words sounds simple. It is simple,
if you know your tools.

== Why count words
- Essays often have a word limit.
- Editors pay by the word.
- It is fun.

= How to do it
+ Save your text as a plain text file.
+ Open a terminal.
+ Run one of the commands below.

// A # switches from markup to code:
// here we call the table function.
#table(
  columns: 3,
  table.header[*Tool*][*Command*][*Notes*],
  [wc],     [`wc -w file.txt`],   [fast],
  [Python], [`python3 count.py`], [flexible],
)

== A small program
// Three backticks start a raw (verbatim) block.
```python
import sys

words = open(sys.argv[1]).read().split()
print(len(words), "words")
if len(words) < 100:
    print("a short text & a quick read")
```
