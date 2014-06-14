NAZWA=praca

all: build

run: build
	evince $(NAZWA).pdf

build: $(NAZWA).tex
	pdflatex -halt-on-error --shell-escape $(NAZWA).tex

clear:
	rm -f $(NAZWA).aux $(NAZWA).log $(NAZWA).dvi $(NAZWA).toc $(NAZWA).idx
