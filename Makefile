all: paper.pdf

paper.pdf: paper.tex paper.bib
paper.pdf: # plots
	pdflatex --interaction=nonstopmode paper.tex || \
	bibtex paper || \
	pdflatex --interaction=nonstopmode paper.tex && \
	pdflatex --interaction=nonstopmode paper.tex || \
	echo '\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!! ERROR WHEN RUNNING LATEX OR BIBTEX !!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

plots: evaluation/plot.rkt $(wildcard evaluation/tests/*)
	cd evaluation && racket plot.rkt

%.tex: %.scrbl base.rkt bib.rkt
	racket $< > $@ || (rm %.tex && false)

clean:
	-rm -f *.tex
	-rm -f *.pdf
	-rm -f *.out
	-rm -f *.log
	-rm -f *.aux
	-rm -f *.bbl
	-rm -f *.blg

watch:
	while true; do \
		fswatch paper.scrbl; \
		make all | echo; \
	done;