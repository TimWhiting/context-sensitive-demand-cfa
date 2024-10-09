#lang scribble/text
\documentclass[runningheads]{llncs}
\usepackage[T1]{fontenc}

\pagenumbering{gobble}

\begin{document}

We thank the reviewers for their first round of reviews and for their willingness to do a second round.
We have strived to address every reviewer concern.
We outline the most significant revisions below.

\begin{enumerate}

\item
We have formatted the paper as 25 LNCS pages.
To accomodate this format, we have moved the proof of soundness and some accompanying formalism from Section 7 to a small appendix.
In its place, we state key theorems and include a high-level description of the proof approach.

\item
To address the concern that the challenges were not clearly recognizable as such,
we have more clearly enumerated the specific challenges faced to obtain context sensitivity in the demand setting in Section 5.
Within that section, subsequent subsections explicate each challenge, the constraint it places on the solution, and how our solution satisfies it.

\item
The presentation of each function and judgment includes a precise and correct signature in terms of cursors.
The visual parsing of cursors, which consist of a context and expression, is made unambiguous by light shading which we have found unobtrusive.

\item
In the evaluation (Section 8), we replaced per-program plots with an aggregate plot which we believe is both easier to read and conveys the high-level performance of Demand m-CFA more clearly.
The per-program plots and their analysis is preserved in the appendix.
We have also clarified individual subsections and captions throughout the entire section.

\end{enumerate}

\end{document}