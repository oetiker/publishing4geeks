[//]: # (Markdown has no comment syntax.)
[//]: # (An unused link definition like this one)
[//]: # (is dropped by every renderer: a comment.)

# Counting Words

A. Geek

[//]: # (An empty line starts a new paragraph.)

This is a *short* sample document. It shows
**bold** text, *italic* text and
`inline code`.

## Introduction

Counting words sounds simple. It is simple,
if you know your tools.

### Why count words

- Essays often have a word limit.
- Editors pay by the word.
- It is fun.

## How to do it

1. Save your text as a plain text file.
2. Open a terminal.
3. Run one of the commands below.

[//]: # (Tables are an extension: GitHub Flavored)
[//]: # (Markdown. The 2004 original has none.)

| Tool   | Command            | Notes    |
|--------|--------------------|----------|
| wc     | `wc -w file.txt`   | fast     |
| Python | `python3 count.py` | flexible |

### A small program

[//]: # (Three backticks start a code block.)
[//]: # (The word after them names the language.)

```python
import sys

words = open(sys.argv[1]).read().split()
print(len(words), "words")
if len(words) < 100:
    print("a short text & a quick read")
```
