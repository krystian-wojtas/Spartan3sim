NAZWA=praca

all: build

run: build
	evince $(NAZWA).pdf
	
build: $(NAZWA).tex
	pdflatex $(NAZWA).tex -halt-on-error
	
clear:
	rm -f $(NAZWA).aux $(NAZWA).log $(NAZWA).dvi $(NAZWA).toc $(NAZWA).idx

