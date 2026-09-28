# Build the sample renderings and the slide deck.
# Everything generated goes to build/.

B      := build
EX     := examples
CHROME := google-chrome --headless --no-sandbox --hide-scrollbars \
          --disable-gpu --no-pdf-header-footer --force-device-scale-factor=2

RENDERS := $(B)/sample-latex.pdf $(B)/sample-html.png $(B)/sample-md.png \
           $(B)/sample-md-term.json $(B)/sample-typst.pdf \
           $(B)/pandoc-sample.typ $(B)/pandoc-sample.tex \
           $(B)/flavor-strict.html $(B)/flavor-gfm.html \
           $(B)/strength-latex.pdf $(B)/strength-html-wide.png \
           $(B)/strength-html-narrow.png $(B)/strength-typst.pdf \
           $(B)/frontmatter.png $(B)/frontmatter-commonmark.html

all: $(B)/slides.pdf

$(B):
	mkdir -p $@

# LaTeX -> PDF
$(B)/sample-latex.pdf: $(EX)/sample.tex | $(B)
	latexmk -pdf -interaction=nonstopmode -outdir=$(B)/latex $<
	cp $(B)/latex/sample.pdf $@

# HTML -> browser screenshot
$(B)/sample-html.png: $(EX)/sample.html | $(B)
	$(CHROME) --window-size=1280,800 --screenshot=$(abspath $@) file://$(abspath $<)

# Markdown -> HTML (pandoc) -> browser screenshot
$(B)/sample-md.html: $(EX)/sample.md | $(B)
	pandoc -f gfm -t html5 --standalone --metadata pagetitle="Counting Words" \
	  -V maxwidth=40em -o $@ $<
$(B)/sample-md.png: $(B)/sample-md.html
	$(CHROME) --window-size=1280,800 --screenshot=$(abspath $@) file://$(abspath $<)

# Markdown -> terminal (mdmost), captured through a pseudo terminal
$(B)/sample-md-term.json: $(EX)/sample.md tools/ansi2json.py | $(B)
	script -qc 'mdmost --render-once --width 64 --no-icons --theme light $<' /dev/null \
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

# Strengths: one small demo per language
$(B)/strength-latex.pdf: $(EX)/strength-latex.tex | $(B)
	latexmk -pdf -interaction=nonstopmode -outdir=$(B)/latex $<
	pdfcrop --margins 10 $(B)/latex/strength-latex.pdf $@
$(B)/strength-html-wide.png: $(EX)/strength-html.html | $(B)
	$(CHROME) --window-size=900,260 --screenshot=$(abspath $@) file://$(abspath $<)
$(B)/strength-html-narrow.png: $(EX)/strength-html.html | $(B)
	$(CHROME) --window-size=360,470 --screenshot=$(abspath $@) file://$(abspath $<)
$(B)/strength-typst.pdf: $(EX)/strength-typst.typ | $(B)
	typst compile $< $@

# YAML front matter: pandoc knows it, plain CommonMark does not
$(B)/frontmatter.html: $(EX)/frontmatter.md | $(B)
	pandoc -f markdown -t html5 --standalone -V maxwidth=40em -o $@ $<
$(B)/frontmatter.png: $(B)/frontmatter.html
	$(CHROME) --window-size=900,520 --screenshot=$(abspath $@) file://$(abspath $<)
$(B)/frontmatter-commonmark.html: $(EX)/frontmatter.md | $(B)
	pandoc -f commonmark -t html -o $@ $<

# The slides read the examples and renders; --root lets them reach ../
# The fonts come from fonts/, so every machine gets the same look.
TYPST_SLIDES := --root . --font-path fonts --ignore-system-fonts
SLIDES_SRC   := $(wildcard slides/*.typ slides/parts/*.typ fonts/*)

$(B)/slides.pdf: $(SLIDES_SRC) $(RENDERS) $(wildcard $(EX)/*)
	typst compile $(TYPST_SLIDES) slides/slides.typ $@

watch: $(RENDERS)
	typst watch $(TYPST_SLIDES) slides/slides.typ $(B)/slides.pdf

# The web site: landing page, slides and sample files (for GitHub Pages)
site: $(B)/slides.pdf site/index.html
	mkdir -p $(B)/site/examples
	cp site/index.html $(B)/slides.pdf $(B)/site/
	cp $(EX)/sample.* $(B)/site/examples/

clean:
	rm -rf $(B)

.PHONY: all watch site clean
