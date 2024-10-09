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
We have formatted the paper as 25 LNCS pages, with a minor appendix.

\item
To address the concern that the challenges were not clearly recognizable as such,
we have reworked our abstract to make these challenges more explicit. 
Additionally, in Section 5,
we have more clearly enumerated the specific challenges faced to obtain context sensitivity in the demand setting.
Within that section, subsequent subsections explicate each challenge, the constraint it places on the solution, and how our solution satisfies it.
Most of the content was there previously, but benefits from more explicit headings, explicit lists, and other markers to make the structure of the paper more clear. 

\item
The presentation of each function and judgment includes a precise and correct signature in terms of cursors.
The visual parsing of cursors, which consist of a context and expression, is made unambiguous by light shading which we have found unobtrusive.

\item
The evaluation section was reorganized to put plots closer to their descriptions, which should help to make the plots more interpretable.
Additionally, we have improved the plot captions to make the axis labels more clear. 
We have aggregated the results of individual programs in the plot about precision and actionable information
This allows for a more concise representation of the results, and more distinguishable lines.
A full individual program breakdown for the results of that section are still available in the appendix.

\item
The proof of soundness and accompanying formalism on demand-evaluation and its correspondance to Demand $m$-CFA has been moved to a small appendix.
The high level description of the approach for the proof, along with statements of the Theorems remains in section 7.

\end{enumerate}

\end{document}