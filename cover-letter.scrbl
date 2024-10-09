#lang scribble/text
\documentclass[runningheads]{llncs}
\usepackage[T1]{fontenc}

\pagenumbering{gobble}

\title{ESOP 2025 Paper #16 Revisions}

\begin{document}
\author{}
\institute{}

\maketitle

We thank the reviewers for their first round of reviews and for their willingness to do a second round.
We have addressed every reviewer concern and strived to do so fully.
We outline the most significant revisions below.

\begin{enumerate}

\item
We have formatted the paper as 25 LNCS pages.
To accomodate this format, we have moved the proof of soundness and some accompanying formalism from Section 7 to a small appendix.
In its place, we include a high-level description of the proof approach, including key lemmas.

\item
To address the concern that certain challenges were not clearly recognizable as such,
we have more clearly enumerated the specific challenges faced to obtain context sensitivity in the demand setting in Section 5.
Within that section, subsequent subsections explicate each challenge, the constraint it places on the solution, and how our solution satisfies it.

\item
The presentation of each function and judgment includes a precise and correct signature in terms of cursors.
The visual parsing of cursors, which consist of a context and expression, is made unambiguous by light shading which we have found unobtrusive.

\item
In the evaluation (Section 8), we replaced per-program plots with an aggregate plot which we believe is both easier to read and conveys the high-level performance of Demand m-CFA more clearly.
The per-program plots and their analysis are preserved in the appendix.
We have also clarified individual subsections and captions throughout the entire section.

\end{enumerate}

\end{document}