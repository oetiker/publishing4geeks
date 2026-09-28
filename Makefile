# Build the sample renderings and the slide deck.
# Everything generated goes to build/.

B      := build
EX     := examples
CHROME := google-chrome --headless --no-sandbox --hide-scrollbars \
          --disable-gpu --no-pdf-header-footer

RENDERS := $(B)/sample-latex.pdf $(B)/sample-html.png $(B)/sample-md.png \
           $(B)/sample-md-term.json $(B)/sample-typst.pdf \
           $(B)/pandoc-sample.typ $(B)/pandoc-sample.tex \
           $(B)/flavor-strict.html $(B)/flavor-gfm.html

all: $(B)/slides.pdf

$(B):
	mkdir -p $@

# LaTeX -> PDF
$(B)/sample-latex.pdf: $(EX)/sample.tex | $(B)
	latexmk -pdf -interaction=nonstopmode -outdir=$(B)/latex $<
	cp $(B)/latex/sample.pdf $@

# HTML -> browser screenshot
$(B)/sample-html.png: $(EX)/sample.html | $(B)
	$(CHROME) --window-size=900,1000 --screenshot=$(abspath $@) file://$(abspath $<)

# Markdown -> HTML (pandoc) -> browser screenshot
$(B)/sample-md.html: $(EX)/sample.md | $(B)
	pandoc -f gfm -t html5 --standalone --metadata pagetitle="Counting Words" \
	  -V maxwidth=40em -o $@ $<
$(B)/sample-md.png: $(B)/sample-md.html
	$(CHROME) --window-size=900,1000 --screenshot=$(abspath $@) file://$(abspath $<)

# Markdown -> terminal (mdmost), captured through a pseudo terminal
$(B)/sample-md-term.json: $(EX)/sample.md tools/ansi2json.py | $(B)
	script -qc 'mdmost --render-once --width 64 --no-icons $<' /dev/null \
	  | python3 tools/ansi2json.py > $@

# Typst -> PDF
$(B)/sample-typst.pdf: $(EX)/sample.typ | $(B)
	typst compile $< $@

# Pandoc: one Markdown source, other formats
$(B)/pandoc-sample.typ: $(EX)/sample.md | $(B)
	pandoc -f gfm -t typst -o $@ $<
$(B)/pandoc-sample.tex: $(EX)/sample.md | $(B)
	pandoc -f gfm -t latex -o $@ $<

# Markdown fragmentation: the same table, two flavours
$(B)/flavor-strict.html: slides/table.md | $(B)
	pandoc -f markdown_strict -t html -o $@ $<
$(B)/flavor-gfm.html: slides/table.md | $(B)
	pandoc -f gfm -t html -o $@ $<

# The slides read the examples and renders; --root lets them reach ../
$(B)/slides.pdf: slides/slides.typ $(RENDERS) $(wildcard $(EX)/*)
	typst compile --root . $< $@

watch: $(RENDERS)
	typst watch --root . slides/slides.typ $(B)/slides.pdf

clean:
	rm -rf $(B)

.PHONY: all watch clean
