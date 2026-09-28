#!/usr/bin/env python3
"""Convert ANSI terminal output (24-bit colour SGR) to JSON for Typst.

Output: a list of lines; each line is a list of spans
{"t": text, "fg": "#rrggbb"|null, "bg": "#rrggbb"|null, "b": bool, "i": bool, "u": bool}.
"""
import json
import re
import sys

SGR = re.compile(r"\x1b\[([0-9;]*)m")
OTHER_CSI = re.compile(r"\x1b\[[0-9;?]*[A-Za-z]")


def parse_sgr(params, st):
    codes = [int(c) if c else 0 for c in params.split(";")] if params else [0]
    i = 0
    while i < len(codes):
        c = codes[i]
        if c == 0:
            st.update(fg=None, bg=None, b=False, i=False, u=False)
        elif c == 1:
            st["b"] = True
        elif c == 3:
            st["i"] = True
        elif c == 4:
            st["u"] = True
        elif c == 22:
            st["b"] = False
        elif c == 23:
            st["i"] = False
        elif c == 24:
            st["u"] = False
        elif c in (38, 48) and i + 4 < len(codes) and codes[i + 1] == 2:
            r, g, b = codes[i + 2:i + 5]
            st["fg" if c == 38 else "bg"] = f"#{r:02x}{g:02x}{b:02x}"
            i += 4
        elif c == 39:
            st["fg"] = None
        elif c == 49:
            st["bg"] = None
        i += 1


def convert(raw):
    # mdmost probes the terminal first (emoji width test, cursor query);
    # the real frame starts after the first "erase line" sequence.
    start = raw.find("\x1b[K")
    if start >= 0:
        raw = raw[start + 3:]
    raw = raw.replace("\r", "")
    st = dict(fg=None, bg=None, b=False, i=False, u=False)
    lines = []
    for line in raw.split("\n"):
        spans = []
        pos = 0
        for m in SGR.finditer(line):
            text = OTHER_CSI.sub("", line[pos:m.start()])
            if text:
                spans.append(dict(t=text, **st))
            parse_sgr(m.group(1), st)
            pos = m.end()
        text = OTHER_CSI.sub("", line[pos:])
        if text:
            spans.append(dict(t=text, **st))
        lines.append(spans)
    while lines and not lines[-1]:
        lines.pop()
    return lines


if __name__ == "__main__":
    data = sys.stdin.buffer.read().decode("utf-8", "replace")
    json.dump(convert(data), sys.stdout, ensure_ascii=False)
