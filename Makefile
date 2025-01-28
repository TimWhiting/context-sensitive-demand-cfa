all: paper.pdf

paper.pdf: paper.tex paper.bib
paper.pdf: # plots
	pdflatex --interaction=nonstopmode paper.tex || \
	bibtex paper || \
	pdflatex --interaction=nonstopmode paper.tex && \
	pdflatex --interaction=nonstopmode paper.tex || \
	echo '\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!! ERROR WHEN RUNNING LATEX OR BIBTEX !!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

techreport.pdf: techreport.tex paper.bib
techreport.pdf: # plots
	pdflatex --interaction=nonstopmode techreport.tex || \
	bibtex techreport || \
	pdflatex --interaction=nonstopmode techreport.tex && \
	pdflatex --interaction=nonstopmode techreport.tex || \
	echo '\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!! ERROR WHEN RUNNING LATEX OR BIBTEX !!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

cover-letter.pdf: cover-letter.tex
	pdflatex --interaction=nonstopmode cover-letter.tex || \
	echo '\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!! ERROR WHEN RUNNING LATEX OR BIBTEX !!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

plots: evaluation/plot.rkt $(wildcard evaluation/tests/*)
	cd evaluation && racket plot.rkt

%.tex: %.scrbl base.rkt bib.rkt
	racket $< > $@ || (rm %.tex && false)

paper: paper.scrbl
	racket paper.scrbl > paper.tex
	make paper.pdf

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
