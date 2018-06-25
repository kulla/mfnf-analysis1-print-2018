# Makefile for creating a PDF from a LaTeX project
LATEX = lualatex
LATEXFLAGS = -halt-on-error -no-shell-escape
LATEXMK = latexmk
LATEXMKFLAGS = -f

FIGURES  = $(patsubst %.svg,%.pdf,$(wildcard *.svg)) \
           $(patsubst %.jpg,%.pdf,$(wildcard *.jpg)) \
           $(patsubst %.png,%.pdf,$(wildcard *.png))

.PHONY: all
all: analysis1.pdf analysis1-sw.pdf

analysis1-sw.pdf: analysis1.pdf
	gs -o '$@' -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
		-sColorConversionStrategy=Gray \
		-sColorConversionStrategyForImages=Gray \
		-sProcessColorModel=DeviceGray -dCompatibilityLevel=1.4 '$<'

analysis1.pdf: ${FIGURES} analysis1.tex $(wildcard predesigned_pages/*)
	$(LATEXMK) $(LATEXMKFLAGS) -pdflatex="$(LATEX) $(LATEXFLAGS) %O %S" \
		-pdf "analysis1"

%.pdf: %.svg
	inkscape --without-gui --export-area-page --export-text-to-path \
		--export-ignore-filters --export-pdf=$@ $<

%.pdf: %.jpg
	convert $< $@

%.pdf: %.png
	convert $< $@

.PHONY: clean
clean:
	git -fx clean

.PHONY: upload
upload:
	scp cover.pdf analysis1.pdf analysis1-sw.pdf hp:~/mfnf-print-2018
