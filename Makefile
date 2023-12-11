all: paper.pdf

paper.pdf: paper.tex paper.bib
paper.pdf: comprehensive-ci.pdf
	pdflatex --interaction=nonstopmode paper.tex && \
	bibtex paper && \
	pdflatex --interaction=nonstopmode paper.tex && \
	pdflatex --interaction=nonstopmode paper.tex || \
	echo '\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!! ERROR WHEN RUNNING LATEX OR BIBTEX !!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

comprehensive-ci.pdf: plot.rkt evaluation/results/ddpa.sexp evaluation/results/k=0.sexp evaluation/results/k=1.sexp evaluation/results/ldcfa-time-0-inf.sexp evaluation/results/dcfa-time-1-inf.sexp evaluation/results/ldcfa-time-1-inf.sexp
	racket plot.rkt

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
