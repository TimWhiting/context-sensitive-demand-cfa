#lang scribble/text
@(require "base.rkt"
          "syntax.rkt"
          "bib.rkt"
          "mathpar.rkt")
@(define-syntax-rule (omit . rst) (void))
\documentclass[10pt,acmsmall,timestamp,screen,anonymous,review]{acmart}

\usepackage{mathpartir}
\usepackage{natbib}
\usepackage{xcolor}
\definecolor{light-gray}{gray}{0.8}
\usepackage{textgreek}
\usepackage{wrapfig}
\usepackage{alltt}
\usepackage[inline]{enumitem}
\graphicspath{
    {evaluation/plots}
}
\usepackage{subcaption}
\acmJournal{PACMPL}
\acmVolume{ICFP}
\acmYear{2024}
\acmArticleType{Research}
\citestyle{acmauthoryear}

\title{Context-Sensitive Demand-Driven Control-Flow Analysis}

\acmConference[ICFP '24]{International Conference on Functional Programming}{Sept 2024}{Milan, Italy}


\begin{abstract}
By decoupling and decomposing control flows, demand control-flow analysis (CFA) is able to resolve 
only those segments of flows it determines necessary to resolve a given query.
Thus, it presents a much more flexible interface and pricing model for CFA, making many useful applications practical.
At present, the only realization of demand CFA is demand 0CFA, which is context-insensitive.
This paper presents a context-sensitive demand CFA hierarchy, Demand $m$-CFA, 
based on the top-$m$-stack-frames abstraction of $m$-CFA.
We evaluate the scalability of Demand $m$-CFA in contrast to the scalability of $m$-CFA.
We also show that in the case of singleton flow sets, 
Demand $m$-CFA resolves a similar number of singleton flow sets as an \emph{exponential} formulation of $m$-CFA, but with tunable effort. 
\end{abstract}

@(define (clause-label label) (list "\\textit{" label "}"))

\begin{document}


\maketitle
\def\labelitemi{\normalfont\bfseries{--}}
\def\labelitemii{\(\ast\)}
\def\labelitemiii{\(\cdot\)}


\begin{CCSXML}
<ccs2012>
   <concept>
       <concept_id>10011007.10010940.10010992.10010998.10011000</concept_id>
       <concept_desc>Software and its engineering~Automated static analysis</concept_desc>
       <concept_significance>500</concept_significance>
   </concept>
   <concept>
       <concept_id>10003752.10010124.10010138.10010143</concept_id>
       <concept_desc>Theory of computation~Program analysis</concept_desc>
       <concept_significance>500</concept_significance>
   </concept>
   <concept>
       <concept_id>10003752.10010124.10010138.10010139</concept_id>
       <concept_desc>Theory of computation~Invariants</concept_desc>
       <concept_significance>300</concept_significance>
   </concept>
   <concept>
       <concept_id>10011007.10010940.10010941.10010942.10010943</concept_id>
       <concept_desc>Software and its engineering~Interpreters</concept_desc>
       <concept_significance>300</concept_significance>
   </concept>
   <concept>
       <concept_id>10011007.10011006.10011008.10011009.10011012</concept_id>
       <concept_desc>Software and its engineering~Functional languages</concept_desc>
       <concept_significance>300</concept_significance>
   </concept>
   <concept>
       <concept_id>10011007.10011006.10011008.10011024.10011027</concept_id>
       <concept_desc>Software and its engineering~Control structures</concept_desc>
       <concept_significance>300</concept_significance>
   </concept>
   <concept>
       <concept_id>10003752.10003753.10010622</concept_id>
       <concept_desc>Theory of computation~Abstract machines</concept_desc>
       <concept_significance>300</concept_significance>
   </concept>
 </ccs2012>
\end{CCSXML}

\ccsdesc[500]{Software and its engineering~Automated static analysis}
\ccsdesc[500]{Theory of computation~Program analysis}
\ccsdesc[300]{Theory of computation~Invariants}
\ccsdesc[300]{Software and its engineering~Interpreters}
\ccsdesc[300]{Software and its engineering~Functional languages}
\ccsdesc[300]{Software and its engineering~Control structures}
\ccsdesc[300]{Theory of computation~Abstract machines}
\section{Getting into the Flow}

\keywords{Demand CFA, m-CFA, Context-Sensitivity, Control Flow Analysis}

Conventional control-flow analysis is tactless---unthinking and inconsiderate.

To illustrate, consider the program fragment on the right which defines the recursive \texttt{fold} function.
As this function iterates, it evolves the index \texttt{n} using the function \texttt{f} and the accumulator \texttt{a} using the function \texttt{g}, all arguments 
to \texttt{fold} itself. The values of \texttt{f} and \texttt{g} flow in parallel
\begin{wrapfigure}[6]{r}{0.65\textwidth}
\vspace{-1em}
\begin{verbatim}
(letrec ([fold (λ (f g n a)
                  (if (zero? n)
                    a
                    (fold f g (f n) (g f n a))))])
  (fold sub1 h 42 1))
\end{verbatim}
\end{wrapfigure}
within the fold itself, each
(1)~being bound in the initial call,
(2)~flowing to its corresponding parameter, and
(3)~being called directly once per iteration.
But their flows don't completely overlap:
\texttt{f}'s value's flow begins at \texttt{sub1} whereas \texttt{g}'s value's comes from a reference to \texttt{h}
and
\texttt{f}'s value's flow branches into the call to \texttt{g}.

Now consider a tool focused on the call \texttt{(f n)} and seeking the value of \texttt{f} in order to, say, expand \texttt{f} inline.
Only the three flow segments identified above respective to \texttt{f} are needed to fully determine this value---and know that it is fully-determined.
Yet conventional control-flow analysis (CFA) is \emph{exhaustive}, insistent on determining every segment of every flow, starting from the program's entry point.\footnote{Exhaustive CFA can be made to work with program components where free variables are treated specially (e.g. using Shivers' escape technique@~cite["Ch. 3"]{dvanhorn:Shivers:1991:CFA}). This special treatment does not change the fundamental \emph{exhaustive} nature of the analysis nor bridge the shortcomings we describe.}
In the account it produces, the segmentation of individual flows and independence of distinct flows are completely implicit.
To obtain \texttt{f}'s value with a conventional CFA, the user must be willing to pay for \texttt{g}'s---and any other values incidental to it---as well.

Inspired by demand dataflow analysis@~cite{duesterwald1997practical}, a \emph{demand} CFA does not determine every segment of every flow 
but only those segments which contribute to the values of specified program points.
Moreover, because its segmentation of flows is explicit, it only need analyze each segment once and can reuse the result in any flow which contains the segment.
In this example, a supporting demand CFA would work backwards from the reference to \texttt{f} to determine its value, and would consider only the three flow segments identified above to do so.

The interface and pricing model demand CFA offers make many useful applications practical.
@citet{horwitz1995demand} identify several ways this practicality is realized:
\begin{enumerate}
\item
One can restrict analysis to a program's critical path or only where certain features are used.
\item
One can analyze more often, and interleave analysis with other tools.
For example, a demand analysis does not need to worry about optimizing transformations invalidating analysis results since one can simply re-analyze the transformed points.
\item
One can let a user drive the analysis, even interactively, to enhance, e.g., an IDE experience.
We have implemented the demand CFA we present in this paper in VSCode [XXX cite] for the Koka language [XXX cite].
\end{enumerate}
@omit{
The first point may seem counterintuitive since only a small portion of information of a program will be learned for each query.
We appeal to the reader's intuition to recognize that many use cases for control flow analysis do not need a full accounting of every variable in the program. 
For example:
\begin{enumerate*}
\item Inlining and constant propagation only care about variables where a single value flows to,
\item security analyses determine where particular values from unsanitized input sources flow,
\item developers question where unexpected values originate and propagate through the program.
\end{enumerate*}
None of these questions care about complicated control flow at the beginning of the program if it is irrelevant to their query. Instead a demand analysis partitions 
the state space into only the relevant parts of the program for the query in question.
}
@;{
Demand analyses---including demand CFA---
We claim that demand CFA is what we term a \emph{demand-scalable} analysis. We characterize such analyses as \begin{enumerate*} \item being able to
answer many relevant questions about a program in constant time or effort, and \item being robust to increases in program size \end{enumerate*}.
\emph{Demand-scalable} analyses are focused on the information gleaned from the analysis regardless of the underlying computational complexity, and opt for the usage of timeouts or early stopping criteria to keep the analysis practical.
Additionally, we theorize that \emph{demand-scalable} analyses are much better suited than monolithic analyses for integration in modern
compilers which typically involve incremental recompilation, language servers, linters, debuggers and other tools, which can each benefit from additional semantic information.
}

\subsection{Adding Context Sensitivity to Demand CFA}

Presently, the only realization of demand CFA is Demand 0CFA@~cite{germane2019demand} which is contextinsensitive.
(We offer some intuition about Demand 0CFA's operation in \S~\ref{sec:intuition} and review it in \S~\ref{sec:demand-0cfa}.)
However, context sensitivity would endow demand CFA with the same benefits that it does analyses at large:
increased precision and, in some cases, a reduced workload@~cite{dvanhorn:Might:2006:GammaCFA} (which we discuss at an intuitive level in \S~\ref{sec:intuition}).

However, the demand setting presents a particular challenge to adding context sensitivity:
unlike exhaustive analyses in which the context is fully determined at each point in analysis,
a demand analysis is deployed on an arbitrary program point in an undetermined context.
Thus, the task of a context-sensitive demand CFA is not only to respect the context as far as it is known, but also to determine unknown context as it is discovered relevant to analysis.
Achieving this task requires a compatible choice of context, context representation, and even environment representation, as we discuss in \S~\ref{sec:progression}.

After overcoming this challenge, we arrive at Demand $m$-CFA (\S~\ref{sec:demand-mcfa}), a hierarchy of context-sensitive demand CFA.@;{
At a high level, Demand $m$-CFA achieves context sensitivity by permitting indeterminate contexts, which stand for any context, and instantiating them when further information is discovered.
It then uses instantiated contexts to filter its resolution of control flow to ensure that its view of evaluation remains consistent with respect to context.
(We offer intuition about these operations in \S~\ref{sec:intuition} as well.)}
Demand $m$-CFA is sound with respect to a concrete albeit demand semantics called \emph{demand evaluation} (\S~\ref{sec:demand-mcfa-correctness}), which is itself sound with respect to a standard call-by-value semantics.

Demand $m$-CFA determines the context only to the extent necessary to soundly answer analysis questions, as opposed to determining the entire context.
Not only does this allow Demand $m$-CFA to avoid analysis work, it offers information to the analysis client regarding which aspects of the context are relevant to a particular analysis question, which the client can use to formulate subsequent questions.

@;{
is comprehensive in the sense that it discovers all contexts to the extent necessary for evaluation.
It achieves this by carefully ensuring at certain points that it proceeds only when the context is known, even if it is not strictly necessary to produce a value.
We find this disposition toward analysis fairly effective:
in some cases, it produces effectively-exhaustive, identically-precise results as an exhaustive analysis at the same level of context sensitivity but \emph{at a constant price}.
}


@;Although Demand $m$-CFA requires a fair amount of technical machinery to formulate,
We have implemented Demand $m$-CFA in several settings using the \emph{Abstracting Definitional Interpreters} (ADI) technique@~cite{darais2017abstracting}.
XXX
@;{
To illustrate its directness, we reproduce and discuss the core of Demand $m$-CFA's implementation in \S~\ref{sec:implementation}.
One virtue of using the ADI approach is that it endows the implemented analyzer with ``pushdown precision'' with respect to the reference semantics---which, for our analyzer, are the demand semantics.
However, as we discuss in \S~\ref{sec:implementation}, Demand $m$-CFA satisfies the \emph{Pushdown for Free} criteria@~cite{local:p4f} which ensures that it has pushdown precision with respect to the direct semantics as well.
}

%\subsection{Contributions}

This paper makes the following contributions:
\begin{itemize}
\item a new formalism for Demand 0CFA which can be implemented straightforwardly using contemporary techniques@~cite{darais2017abstracting,wei2018refunctionalization} (\S~\ref{sec:demand-0cfa});
\item Demand $m$-CFA (\S~\ref{sec:demand-mcfa}), a hierarchy of context-sensitive demand CFA and a proof of its soundness (\S~\ref{sec:demand-mcfa-correctness});
\item an empirical evaluation of the scalability and precision of Demand $m$-CFA(\S~\ref{sec:evaluation});
\end{itemize}

\section{Demand CFA, Intuitively}
\label{sec:intuition}

A user interacts with demand CFA by submitting queries, which the analyzer resolves online.
There are two types of queries:
\begin{enumerate}
\item
An \emph{evaluation} query seeks the values to which a specified expression may evaluate.
In essence, it is asking which values flow to a given expression.
\item
A \emph{trace} query seeks the sites at which the value of a specified expression may be used.
In essence, it is asking where values flow from a given expression.
\end{enumerate}
To resolve all but trivial queries, the analysis issues subqueries---of one type or the other---to resolve flows on which the original query depends.

We illustrate the operation of a demand CFA considering queries over the program
\begin{verbatim}
(let ([f (λ (x) x)]) (+ (f 42) (f 35)))
\end{verbatim}
which is written in Pure Scheme (i.e. purely-functional Scheme).

@(define (evq e) (list "\\textsf{evaluate}\\," "\\texttt{" e  "}"))
@(define (exq e) (list "\\textsf{trace}\\," "\\texttt{" e  "}"))
@(define (caq e) (list "\\textsf{caller}\\," "\\texttt{" e  "}"))
\setlength\intextsep{0pt}

\subsection{Without Context Sensitivity}

\begin{wrapfigure}{l}{0.3\textwidth}
\begin{tabular}{cl}
$q_0$ & @evq{(f 35)} \\
$q_1$ & \phantom{XX} @evq{f} \\
$q_2$ & \phantom{XX} @evq{(λ (x) x)} \\
      & \phantom{XX} $\Rightarrow$ \texttt{(λ (x) x)} \\
$q_3$ & @evq{x} \\
$q_4$ & \phantom{XX} @exq{(λ (x) x)} \\
$q_5$ & \phantom{XX} @exq{f} in \texttt{(f 42)} \\
      & \phantom{XX} $\Rightarrow$ \texttt{(f 42)} \\
$q_7$ & @evq{42} \\
      & $\Rightarrow$ $42$ \\
$q_6$ & \phantom{XX} @exq{f} in \texttt{(f 35)}\\
      & \phantom{XX} $\Rightarrow$ \texttt{(f 35)} \\
$q_8$ & @evq{35} \\
      & $\Rightarrow$ $35$
\end{tabular}
\end{wrapfigure}
As many readers are likely unfamiliar with demand CFA, we'll first look at how demand 0CFA, the context-\emph{in}sensitive embodiment of demand CFA, resolves queries.

Suppose that a user submits an evaluation query $q_0$ on the expression \texttt{(f 35)}.
Since \texttt{(f 35)} is a function application, demand 0CFA issues a subquery $q_1$ to evaluate the operator \texttt{f}.
For each procedure value of \texttt{f}, demand 0CFA will issue a subquery to determine the value of its body as the value of $q_0$.
To the left is a trace of the queries that follow $q_0$.
Indented queries denote subqueries whose results are used to continue resolution of the superquery.
A subsequent query at the same indentation level is a query in ``tail position'', whose results are those of a preceding query.
A query often issues multiple queries in tail position, as this example demonstrates.
The operator \texttt{f} is a reference, so demand 0CFA walks the syntax to find where \texttt{f} is bound.
Upon finding it bound by a \texttt{let} expression, demand 0CFA issues a subquery $q_2$ to evaluate its bound expression \texttt{(λ~(x)~x)}.
The expression \texttt{(λ~(x)~x)} is a $\lambda$ term---a value---which $q_2$ propagates directly to $q_1$.
Once $q_1$ receives it, demand 0CFA issues a subquery $q_3$ for the evaluation of its body.
Its body \texttt{x} is a reference, so demand 0CFA walks the syntax to discover that it is $\lambda$-bound and therefore that its value is the value of the argument at the application of \texttt{(λ (x) x)}.
That this call to \texttt{(λ~(x)~x)} originated at \texttt{(f 35)} is contextual information, to which demand 0CFA is insensitive.
Consequently, demand 0CFA issues a trace query $q_4$ to find all the application sites of \texttt{(λ (x) x)}.
Because it is an expression bound to \texttt{f}, demand 0CFA issues a subqueries $q_5$ and $q_6$ to find the use sites of both references to $f$.
Each of these subqueries resolves immediately since each of the references is in operator position and their results are propagated to $q_4$.
For each result, $q_3$ issues a subquery---$q_7$ and $q_8$---to evaluate the arguments, each of which is a numeric literal, whose value is immediately known.
Each query propagates its results to $q_3$ which propagates them to $q_0$ which returns them to the user.
Thus, demand 0CFA concludes that \texttt{(f 35)} may evaluate to $42$ or $35$.
\subsection{With Context Sensitivity}

We'll now look at how Demand $m$-CFA, a context-sensitive demand CFA, resolves queries.
As is typical, Demand $m$-CFA uses an environment to record the binding context of each in-scope variable.
Hence, in this setting, queries and results include not only expressions, but environments as well.
We will also see that Demand $m$-CFA does not need a timestamp to record the ``current'' context, a fact we discuss further in \S~\ref{sec:whence-timestamp}.

@(define (evqcs e ρ) (list "\\textsf{evaluate}\\," "\\texttt{" e  "}" " " "\\textsf{in}" " " (ensuremath ρ)))
@(define (exqcs e ρ) (list "\\textsf{trace}\\," "\\texttt{" e  "}" " " "\\textsf{in}" " " (ensuremath ρ)))
@(define (caqcs e ρ) (list "\\textsf{caller}\\," "\\texttt{" e  "}" " " "\\textsf{in}" " " (ensuremath ρ)))
@(define (rescs e ρ) (list (ensuremath "\\Rightarrow") " " "\\texttt{" e  "}" " " "\\textsf{in}" " " (ensuremath ρ)))

\begin{wrapfigure}{r}{0.4\textwidth}
\begin{tabular}{cl}
$q_0$ & @evq{(f 35)} \textsf{in} $\langle\rangle$\\
$q_1$ & \phantom{XX} @evq{f} \textsf{in} $\langle\rangle$\\
$q_2$ & \phantom{XX} @evq{(λ (x) x)} \textsf{in} $\langle\rangle$\\
      & \phantom{XX} $\Rightarrow$ \texttt{(λ (x) x)} \textsf{in} $\langle\rangle$\\
$q_3$ & @evq{x} \textsf{in} $\langle\texttt{(f 35)}\rangle$\\
$q_3'$ & \phantom{XX} @caq{x} \textsf{in} $\langle\texttt{(f 35)}\rangle$\\
$q_4$ & \phantom{XX} \phantom{XX} @exq{(λ (x) x)} \textsf{in} $\langle\rangle$\\
$q_5$ & \phantom{XX} \phantom{XX} @exq{f} \textsf{in} $\langle\rangle$\\
      & \phantom{XX} \phantom{XX} $\Rightarrow$ \texttt{(f 42)} \textsf{in} $\langle\rangle$\\
      & \phantom{XX} $\Rightarrow$ \textit{fail}\\
$q_6$ & \phantom{XX} \phantom{XX} @exq{f} \textsf{in} $\langle\rangle$\\
      & \phantom{XX} \phantom{XX} $\Rightarrow$ \texttt{(f 35)} \textsf{in} $\langle\rangle$\\
      & \phantom{XX} $\Rightarrow$ \texttt{(f 35)} \textsf{in} $\langle\rangle$\\
$q_8$ & @evq{35} \textsf{in} $\langle\rangle$\\
      & $\Rightarrow$ $35$ \textsf{in} $\langle\rangle$
\end{tabular}
\end{wrapfigure}

Let's consider the same evaluation query $q_0$ over \texttt{(f 35)}, this time in the top-level environment $\langle\rangle$.
Like Demand 0CFA, Demand $m$-CFA issues the subquery $q_1$ to determine the operator \texttt{f}, also in $\langle\rangle$.
After it discovers \texttt{(λ (x) x)} to be the binding expression of \texttt{f}, it issues an evaluation query over it ($q_2$) again in $\langle\rangle$.
The result of $q_2$ is \texttt{(λ (x) x)} in $\langle\rangle$, essentially a closure.
As before, this result is passed first to $q_1$ and then to $q_0$ at which point Demand $m$-CFA constructs $q_3$, an evaluation query over its body.
The query's environment $\langle\texttt{(f 35)}\rangle$ records the context in which the parameter \texttt{x} was bound.
In order to evaluate \texttt{x}, Demand $m$-CFA issues a \emph{caller} query $q_3'$ to determine the caller of \texttt{(λ (x) x)} that yielded the environment $\langle\texttt{(f 35)}\rangle$.
It then issues the trace query $q_4$, this time subordinate to $q_3'$, which issues $q_5$ and $q_6$ and results in the same two applications of \texttt{f}.
However, when $q_3'$ receives a caller from $q_4$, Demand $m$-CFA ensures that the caller could produce the binding context of the parameter in $q_3'$'s environment.
If so, $q_3'$ yields the result to $q_3$; if not, it cuts off the resolution process for that path.
In this case, $q_5$'s result \texttt{(f 42)} is not compatible with $q_3'$, and Demand $m$-CFA ceases resolving it rather than issuing $q_7$.
However, $q_6$'s result \texttt{(f 35)} is compatible, and its resolution continues, issuing $q_8$.
Resolution of $q_8$ occurs immediately and its result is propagated to the top-level query.

This example illustrates how Demand $m$-CFA uses the context information recorded in the environment to filter out discovered callers of a particular closure.
Not only does this filtering increase precision in the expected way, but, in this example, it also prevents Demand $m$-CFA from issuing a spurious query ($q_7$).
This behavior is an example of the well-known phenomenon of high precision keeping the analyzer's search space small@~cite{dvanhorn:Might:2006:GammaCFA}.

\subsection{...And Indeterminacy}

Each environment in the previous section was fully determined.
Typically, Demand $m$-CFA resolves queries and produces results with environments that are---at least partially---indeterminate.
For instance, to obtain all of the values to which \texttt{x}, the body of \texttt{(λ (x) x)}, may evaluate,
a user may issue the query @evq{x} \textsf{in} $\langle ?\rangle$ where $?$ is a ``wildcard'' context to be instantiated with each context the analyzer discovers.
(Though each context in the environment is indeterminate, the shape of the environment itself is determined by the lexical binding structure, which we discuss further in \S~\ref{sec:more-orderly}.)

\begin{wrapfigure}{l}{0.42\textwidth}
\begin{tabular}{cl}
$q_0$ & @evq{x} \textsf{in} $\langle ?\rangle$ \\
$q_0'$ & \phantom{XX} @caq{x} \textsf{in} $\langle ?\rangle$ \\
$q_1$ & \phantom{XX} \phantom{XX} @exq{(λ (x) x)} \textsf{in} $\langle\rangle$ \\
$q_2$ & \phantom{XX} \phantom{XX} @exq{f} \textsf{in} \texttt{(f 42)} \textsf{in} $\langle\rangle$ \\
      & \phantom{XX} \phantom{XX} $\Rightarrow$ \texttt{(f 42)} \textsf{in} $\langle\rangle$ \\
      & \phantom{XX} $\Rightarrow$ \texttt{(f 42)} \textsf{in} $\langle\rangle$ \\
$q_4$ & @evq{x} \textsf{in} $\langle\texttt{(f 42)}\rangle$ \\
$q_5$ & @evq{42} \textsf{in} $\langle\rangle$ \\
      & $\Rightarrow$ $42$ \textsf{in} $\langle\rangle$ \\
$q_3$ & \phantom{XX} @exq{f} \textsf{in} \texttt{(f 35)} \\
      & \phantom{XX} $\Rightarrow$ \texttt{(f 35)} \\
$q_6$ & @evq{x} \textsf{in} $\langle\texttt{(f 35)}\rangle$ \\
$q_7$ & @evq{35} \textsf{in} $\langle\rangle$ \\
      & $\Rightarrow$ $35$ \textsf{in} $\langle\rangle$
\end{tabular}
\end{wrapfigure}

Once issued, resolution of \texttt{x}'s evaluation again depends on a caller query $q_0'$.
However, because the parameter \texttt{x}'s context is unknown, rather than filtering out callers, the caller query will cause $?$ to be instantiated with a context derived from each caller.
As before, Demand $m$-CFA dispatches a trace query $q_1$ which then traces occurrences of \texttt{f} via $q_2$ and $q_3$.
This query locates the call sites \texttt{(f 42)} \textsf{in} $\langle\rangle$ and \texttt{(f 35)} \textsf{in} $\langle\rangle$
Once $q_2$ delivers the result \texttt{(f 42)} \textsf{in} $\langle\rangle$ to $q_1$ and then $q_0'$, Demand $m$-CFA \emph{instantiates} $q_0$ with this newly-discovered caller to form $q_4$, whose result is $q_0$'s also.
After creating $q_3$, it continues with its resolution by issuing $q_4$ to evaluate the argument \texttt{42} \textsf{in} $\langle\rangle$.
Its result of $42$ propagates from $q_4$ to $q_3$ to $q_0$;
from $q_0$, one can see all instantiations of it as well every result of those instantiations.
The instantiation from $q_3$ proceeds similarly.

\section{Language and Notation}
\label{sec:notation}

We present Demand $m$-CFA over the unary $\lambda$ calculus.
It is straightforward to extend it to multiple-arity functions, data structures, constants, primitives, conditionals, and recursive forms---which we have in our implementations---but this small language suffices to discuss the essential aspects of context sensitivity.

In order to keep otherwise-identical expressions distinct, many CFA presentations uniquely label program sub-expressions.\footnote{Others operate over a form which itself names all intermediate results, such as CPS or $\mathcal{A}$-normal form, and identify each expression by its associated (unique) name.}
This approach would be used, for example, to disambiguate the two references to \texttt{f} in the program in \S~\ref{sec:intuition}.
We instead use the syntactic context of each expression, which uniquely determines it, as a de-facto label, since Demand $m$-CFA consults it extensively.

In the unary $\lambda$ calculus,
expressions @(e) adhere to the grammar on the left
and
syntactic contexts @(meta "C" #f) adhere to the grammar on the right.
\begin{align*}
@(e) & ::= @(ref (var 'x)) \,|\, @(lam (var 'x) (e)) \,|\, @(app (e) (e))
&
@(meta "C" #f) & ::= @(lam (var 'x) (meta "C" #f)) \,|\, @(app (meta "C" #f) (e)) \,|\, @(app (e) (meta "C" #f)) \,|\, @|□|.
\end{align*}

The syntactic context @(meta "C" #f) of an instance of an expression @(e) within a program $\mathit{pr}$ is $\mathit{pr}$ itself with a hole @|□| in place of the selected instance of @(e).
For example, the program @(lam (var 'x) (app (ref (var 'x)) (ref (var 'x)))) contains two references to @(var 'x),
one with syntactic context @(lam (var 'x) (app □ (ref (var 'x))))
and the other with @(lam (var 'x) (app (ref (var 'x)) □)).

The composition @(cursor (e) (∘e)) of a syntactic context @(meta "C" #f) with an expression @(e) consists of @(meta "C" #f) with @|□| replaced by @(e).
In other words, @(cursor (e) (∘e)) denotes the program itself but with a focus on @(e).
For example, we focus on the reference to @(var 'x) in operator position in the program @(lam (var 'x) (app (ref (var 'x)) (ref (var 'x)))) with @(cursor (ref (var 'x)) (rat (ref (var 'x)) (bod (var 'x) (top)))).

We typically leave the context unspecified, referring to, e.g., a reference to @(var 'x) by @(cursor (ref (var 'x)) (∘e)) and two distinct references to @(var 'x) by @(cursor (ref (var 'x)) (∘e 0)) and @(cursor (ref (var 'x)) (∘e 1)) (where $@((∘e 0) #f) \ne @((∘e 1) #f)$).
The immediate syntactic context of an expression is often relevant, however, and we make it explicit by a double composition @(cursor (cursor (e) (∘e 1)) (∘e 0)).
For example, we use @(cursor (ref (var 'x)) (rat (ref (var 'x)) (∘e))) to focus on the expression @(ref (var 'x)) in the operator context @(app □ (ref (var 'x))) in the context @(meta "C" #f).

\section{Demand 0CFA}
\label{sec:demand-0cfa}
\begin{figure}
\[
@|0cfa-bind-name| : \mathit{Var} \times \mathit{Exp} \rightarrow \mathit{Exp}
\]
@(align (list (list (0cfa-bind (var 'x) (cursor (e 0) (rat (e 1) (∘e))))
                    (list "=" (0cfa-bind (var 'x) (cursor (app (e 0) (e 1)) (∘e)))))
              (list (0cfa-bind (var 'x) (cursor (e 1) (ran (e 0) (∘e))))
                    (list "=" (0cfa-bind (var 'x) (cursor (app (e 0) (e 1)) (∘e)))))
              (list (0cfa-bind (var 'x) (cursor (e) (bod (var 'y) (∘e))))
                    (list "=" (0cfa-bind (var 'x) (cursor (lam (var 'y) (e)) (∘e)))
                          "\\text{ where } " (≠  (var 'y) (var 'x))))
              (list (0cfa-bind (var 'x) (cursor (e) (bod (var 'x) (∘e))))
                    (list "=" (cursor (e) (bod (var 'x) (∘e)))))))
\caption{The @|0cfa-bind-name| metafunction}
\label{fig:0cfa-bind}
\end{figure}
@(require (prefix-in 0cfa- "demand-0cfa.rkt"))
Demand 0CFA has two modes of operation, \emph{evaluation} and \emph{tracing}, which users access by submitting evaluation or trace queries, respectively.
A query, in addition to its type, designates a program expression over which the query should be resolved.
An evaluation query resolves the values to which the designated expression may evaluate and a trace query resolves the sites which may apply the value of the designated expression.
These modes are essentially dual and reflect the dual perspective of exhaustive CFA as either
(1) the @(lam (var 'x) (e)) which may be applied at a given site @(app (e 0) (e 1)), or
(2) the @(app (e 0) (e 1)) at which a given @(lam (var 'x) (e)) may be applied. % [find citation].
However, in contrast to exhaustive CFA, demand 0CFA is designed to resolve evaluation queries over arbitrary program expressions.
(It is also able to resolve trace queries over arbitrary program expressions, but exhaustive CFAs have no counterpart to this functionality.)
\begin{figure}
@mathpar[0cfa-parse-judgement]{
Lam
———
C[λx.e] ⇓ C[λx.e]

App
C[([e₀] e₁)] ⇓ C'[λx.e]  C'[λx.[e]] ⇓ Cv[λx.e-v]
———
C[(e₀ e₁)] ⇓ Cv[λx.e-v]

Ref
C'[e-x] = bind(x,C[x])  C'[e-x] ⇐ C''[(e₀ e₁)]  C''[(e₀ [e₁])] ⇓ Cv[λx.e]
———
C[x] ⇓ Cv[λx.e]


Rator
——
C[([e₀] e₁)] ⇒ C[(e₀ e₁)]

Body
C[λx.[e]] ⇐ C'[(e₀ e₁)]  C'[(e₀ e₁)] ⇒ C''[(e₂ e₃)] 
——
C[λx.[e]] ⇒ C''[(e₂ e₃)] 

Rand
C[([e₀] e₁)] ⇓ C'[λx.e]  x C'[λx.[e]] F Cx[x]  Cx[x] ⇒ C'[(e₂ e₃)] 
——
C[(e₀ [e₁])] ⇒ C'[(e₂ e₃)]


Call
C[λx.e] ⇒ C'[(e₀ e₁)] 
———
C[λx.[e]] ⇐ C'[(e₀ e₁)] 

Find-Ref
——
x C[x] F C[x]

Find-Rator
x C[([e₀] e₁)] F Cx[x]
——
x C[(e₀ e₁)] F Cx[x]

Find-Rand
x C[(e₀ [e₁])] F Cx[x]
——
x C[(e₀ e₁)] F Cx[x]

Find-Body
x ≠ y  x C[λy.[e]] F Cx[x]
——
x C[λy.e] F Cx[x]

}
\caption{Demand 0CFA evaluation and trace relations}
\label{fig:demand-0cfa}
\end{figure}
The evaluation and trace modes of operation are effected by the big-step relations @|0cfa-eval-name| and @|0cfa-expr-name|, respectively, which are defined mutually inductively.
These relations are respectively supported by the auxiliary metafunction @|0cfa-bind-name| and relation @|0cfa-find-name|, which concern variable bindings and are also dual to each other.
Anticipating the addition of context sensitivity, we define @|0cfa-eval-name| in terms of the relation @|0cfa-call-name|, which we discuss below.
Figure~\ref{fig:demand-0cfa} presents the definitions of all of these relations.

The judgement @(0cfa-eval (cursor (e) (∘e)) (cursor (lam (var 'x) (e "_v")) (∘e "_v"))) denotes that the expression @(e) (residing in syntactic context @((∘e) #f)) evaluates to (a closure over) @(lam (var 'x) (e "_v")).
(In a context-insensitive analysis, we may represent a closure by the $\lambda$ term itself.) 
Demand 0CFA arrives at such a judgement, as an interpreter does, by considering the type of expression being evaluated.
The @clause-label{Lam} rule captures the intuition that a $\lambda$ term immediately evaluates to itself.
The @clause-label{App} rule captures the intuition that an application evaluates to whatever the body of its operator does.
Hence, if the operator @(e 0) evaluates to @(lam (var 'x) (e)), and @(e) evaluates to @(lam (var 'y) (e "_v")), then the application @(app (e 0) (e 1)) evaluates to @(lam (var 'y) (e "_v")) as well.
Notice that the @clause-label{App} does not evaluate the argument;
if the argument is needed, indicated by a reference to the operator's parameter @(var 'x) during evaluation of its body, the @clause-label{Ref} rule obtains it.
The @clause-label{Ref} rule captures the intuition that a reference to a parameter @(var 'x) takes on the value of the argument at each call site where the $\lambda$ which binds @(var 'x) is called.
% If the @|0cfa-bind-name| metafunction determines the binding configuration of @(var 'x)---i.e. the body of the $\lambda$ term which binds it---to be @(e),
% @(app (e 0) (e 1)) is a caller of that $\lambda$ term, and
% @(e 1) evaluates to @(lam (var 'y) (e "_v")), then
% the reference to @(var 'x) evaluates to @(lam (var 'y) (e "_v")) as well.
The @|0cfa-bind-name| metafunction determines the binding configuration of @(var 'x) by walking outward on the syntax tree until it encounters @(var 'x)'s binder.
Figure~\ref{fig:0cfa-bind} presents its definition, and we note the absence of a rule for the case where @(var 'x) is unbound, since we define programs as closed expressions.

A judgement @(0cfa-call (cursor (e) (bod (var 'x) (∘e))) (cursor (app (e 0) (e 1)) (∘e "'"))) denotes that the application @(app (e 0) (e 1)) applies @(lam (var 'x) (e)), thereby binding @(var 'x).
Demand 0CFA arrives at this judgment by the @clause-label{Call} rule which uses the @|0cfa-expr-name| relation to determine it.
In demand 0CFA, this relation is only a thin wrapper over @|0cfa-expr-name|, but becomes more involved with the addition of context sensitivity.

A judgement @(0cfa-expr (cursor (e) (∘e)) (cursor (app (e 0) (e 1)) (∘e "'"))) denotes that the value of the expression @(e) is applied at @(app (e 0) (e 1)).
Demand 0CFA arrives at such a judgement by considering the type of the syntactic context to which the value flows.
The @clause-label{Rator} rule captures the intuition that, if @(lam (var 'x) (e)) flows to ope\emph{rator} position @(e 0) of @(app (e 0) (e 1)), it is applied by @(app (e 0) (e 1)).
The @clause-label{Body} rule captures the intuition that if a value flows to the body of a $\lambda$ term, then it flows to each of its callers as well.
The @clause-label{Rand} rule captures the intuition that a value in ope\emph{rand} position is bound by the formal parameter of each operator value and hence to each reference to the formal parameter in the operator's body.
If the operator @(e "_f") evaluates to @(lam (var 'x) (e)), then the value of @(e "_a") flows to each reference to @(var 'x) in @(e).

The @|0cfa-find-name| relation associates a variable @(var 'x) and expression @(e) with each reference to @(var 'x) in @(e).
@clause-label{Find-Ref} finds @(e) itself if @(e) is a reference to @(var 'x).
@clause-label{Find-Rator} and @clause-label{Find-Rand} find references to @(var 'x) in @(app (e 0) (e 1)) by searching the ope\emph{rator} @(e 0) and ope\emph{rand} @(e 1), respectively.
@clause-label{Find-Body} finds references to @(var 'x) in @(lam (var 'x) (e)) taking care that @(≠ (var 'x) (var 'y)) so that it does not find shadowed references.

@;{
\subsection{Reachability}
\label{sec:reachability}

All but the most na\"ive exhaustive CFAs compute reachability at the same time as control flow.
For instance, when analyzing the program @(app (lam (var 'x) (lam (var 'y) (ref (var 'x)))) (lam (var 'z) (ref (var 'z)))),
such CFAs do not evaluate the reference @(ref (var 'x)) as it occurs in @(lam (var 'y) (ref (var 'x))) which is never applied.

Demand 0CFA, however, considers reachability not for the sake of control but for data.
In this example, the caller of @(lam (var 'y) (ref (var 'x))) is not needed for evaluation of @(ref (var 'x)), so demand 0CFA remains oblivious to the fact that @(lam (var 'y) (ref (var 'x))) is never called.
If, however, the reference @(ref (var 'x)) were replaced with @(ref (var 'y)) so that the program was @(app (lam (var 'x) (lam (var 'y) (ref (var 'y)))) (lam (var 'z) (ref (var 'z)))),
evaluation of @(ref (var 'y)) would depend on the caller of @(lam (var 'y) (ref (var 'y))).
Unable to find a caller in this case, demand 0CFA would report that @(ref (var 'y)) obtains no value.

By ignoring control that does not influence the sought-after data, Demand 0CFA avoids exploring each path which transported the data, instead relying on the discipline of lexical scope to correspond binding and use.
This policy does mean that Demand 0CFA sometimes analyzes dead code as if it were live.
From a practical standpoint, this is harmless, since any conclusion about genuinely dead code is vacuously true.
However, it is possible for Demand 0CFA to include, e.g., dead references in its trace of a value via a binding, which potentially compromises precision.
We empirically investigate the extent to which precision is compromised in \S~\ref{sec:evaluation}.
}

\section{Adding Context Sensitivity}
\label{sec:progression}

A context-\emph{insensitive} CFA is characterized by each program variable having a single entry in the store, shared by all bindings to it.
A context-sensitive CFA considers the context in which each variable is bound and requires only bindings made in the same context to share a store entry.
By extension, a context-sensitive CFA evaluates an expression under a particular environment, which identifies the context in which free variables within the expression are bound.
(Like Demand 0CFA, our context-sensitive demand CFA will not materialize the store in the semantics, but it can be recovered if desired.)

From this point, we must determine
(1) the appropriate choice of context,
(2) its representation, and
(3) the appropriate representation of environments which record the context,
which we do in this section.
Once these are determined, we combine each expression and its enclosing environment to form a \emph{configuration}.\footnote{Configurations in exhaustive CFAs include a timestamp as well. We discuss its omission from demand CFA configurations in \S~\ref{sec:whence-timestamp}.}
We can extend @|0cfa-eval-name| and @|0cfa-expr-name| trivially to relate configurations rather than mere expressions.

A key constraint in the demand setting is that a client-issued query is typically issued in a completely indeterminate context.
The expectation is that the analysis will both determine the context to the extent necessary to resolve the query (but no more) and also respect the context so that the analysis is in fact context-sensitive.
One implication of this expecation is that queries over expressions which are evaluated in multiple contexts should produce multiple results, one for each context.
To operate under this constraint, we extend @|0cfa-call-name| to instantiate the context and ensure that the analysis respects it.

@;{
However, unlike in exhaustive CFA, in demand CFA, differs from exhaustive CFA in that the precise environment in which an expression is evaluated or traced may not be completely determined.
That is, the context in which each environment variable is bound may not be fully known.
For instance,
users typically
want control-flow information about an expression which is sound with respect to all its evaluations
and
so indicate in queries by leaving the environment completely indeterminate.
In this case, demand CFA should instantiate the environment (only) as necessary to distinguish evaluations in different contexts.
Demand CFA thus requires a choice of context, context representation, and environment representation which support its ability to do so.
In this section, we examine each of these choices in turn.
}

\subsection{Choosing the context}

To formulate context-sensitive demand CFA in the most general setting possible, we will avoid sensitivities to properties not present in our semantics, such as types.
Since we focus on an untyped $\lambda$ calculus, the most straightforward choice is call-site sensitivity.

The canonical call-site sensitivity is that of $k$-CFA@~cite{dvanhorn:Shivers:1991:CFA} which sensitizes each binding to the last $k$ call sites encountered in evaluation.
However, this form of call-site sensitivity works against the parsimonious nature of demand CFA.
To make this concrete, consider that, in the fragment \texttt{(begin (f x) (g y))}, 
the binding of \texttt{g}'s parameter under a last $k$ call-site sensitivity will depend on the particular calls made during the evaluation of \texttt{(f x)}.
If the value of \texttt{(f x)} is not otherwise demanded, this dependence either provokes demand analysis to discover more of the context or requires that the portion of the context contributed by \texttt{(f x)} be left indeterminate, thereby sacrificing precision.

A more fitting call-site sensitivity would allow demand CFA to discover more of the context through its course of operation.
A natural fit, it turns out, is $m$-CFA's call-site sensitivity which models the top-$m$ stack frames.

\subsubsection{$m$-CFA's context abstraction}

The $m$-CFA hierarchy@~cite{dvanhorn:Might2010Resolving} is the result of an investigation into the polynomial character of $k$-CFA in an object-oriented setting versus its exponential character in a functional setting.
The crucial discovery of that investigation was that OO-oriented $k$-CFA induces flat environments whereas functional-oriented $k$-CFA induces nested environments.
Specifically, OO-oriented $k$-CFA re-binds object (closure) variables in the allocation context which collapses the exponential environment space to a polynomial size.
From this insight they derive $m$-CFA, which simulates the OO binding discipline even when analyzing functional programs;
that is, when applied, $m$-CFA binds a closure's arguments and rebinds its environment's bindings all in the binding context of the application.
Under this policy, within a given environment, all bindings are in the same context and, consequently, the analysis can represent that environment simply as that binding context.

However, this binding policy amplifies a weakness of the $k$-most-recent-call-sites abstraction of $k$-CFA.
Consider a $[k=2]$CFA analysis of a call to \texttt{f} defined by
\begin{verbatim}
(define (f x) (log "called f") (g x))
\end{verbatim}
and suppose that \texttt{log} doesn't itself make any calls.
When control reaches \texttt{(g x)}, the most-recent call is always \texttt{(log "called f")} so the binding context of \texttt{g}'s parameter, the most-recent two calls \texttt{(log "called f")} and \texttt{(g x)}, determine only one point in the program---the body of \texttt{f}.
In $k$-CFA, only \texttt{g}'s parameter binding suffers this abbreviated precision; the bindings in \texttt{g}'s closure environment refer to the context in which they were introduced into it.
In $m$-CFA, however, the bindings of \texttt{g}'s closure environment are re-bound in the context of \texttt{g}'s application as \texttt{g} is applied and once-distinct bindings are merged together in a semi-degenerate context.

To accommodate this binding policy, @citet{dvanhorn:Might2010Resolving} use the top-$m$ stack frames as a binding context rather than the last $k$ call sites as the former is unaffected by static sequences of calls.
Hence, when control reaches \texttt{(g x)} in $[m=2]$-CFA analysis, the binding context is that of \texttt{f}'s entry and \texttt{g}'s parameter is bound in the context of \texttt{(g x)} and \texttt{f}'s caller---no context is wasted.

Because we're using $m$-CFA's top-$m$-stack-frames context abstraction, we call our context-sensitive demand CFA \emph{Demand $m$-CFA}.
It is important to keep in mind, however, that we do \emph{not} adopt its re-binding policy. @;, which is the essence of $m$-CFA.

\subsection{Representing the top-$m$ stack frames}

Now that we have identified a context abstraction, we must choose a representation for it which will allow us to model incomplete knowledge.
One choice would be an $m$-length vector of possibly-indeterminate call sites which Demand $m$-CFA could fill in as it discovers contexts.
However, this representation fails to capture a useful invariant.

To illustrate, suppose we are evaluating \texttt{x} in the function \texttt{(λ (x) x)} and that we have no knowledge about the binding context of \texttt{x}.
In order to determine \texttt{x}'s value, we must determine the sites that call \texttt{(λ (x) x)}.
If our analyzer determines that one such site is \texttt{(f 42)}, then it learns that the \emph{top} frame---the first of the top-$m$ frames---is \texttt{(f 42)}.
The next frame is whatever the top frame of \texttt{(f 42)}'s context is, which may be indeterminate.
Thus, the analyzer's knowledge of the top-$m$ frames always increases from the top down.
(This invariant holds when the analyzer enters a call as well, since it necessarily knows the call site when doing so.)

@(define (intuit-cc [ℓ #f]) (meta "\\mathit{cc}" ℓ))

We devise a context representation that captures this invariant.
A context @(intuit-cc "^m") representing $m$ stack frames is either
completely indeterminate,
a pair of a call @(cursor (app (e 0) (e 1)) (∘e)) and a context @(intuit-cc "^{m-1}") of $m-1$ frames, or
the stack bottom $()$ (which occurs at the top level of evaluation).
A context @(intuit-cc "^0") of zero frames (which is a different notion than the stack bottom) is simply the degenerate $\square$.
Formally, we have
\begin{align*}
\mathit{Context}_0 \ni @(intuit-cc "^0") &::= \square & \mathit{Context}_m \ni @(intuit-cc "^m") &::=\, ? \,|\, (@(cursor (app (e 0) (e 1)) (∘e)),@(intuit-cc "^{m-1}")) \,|\, ()
\end{align*}
With the context representation chosen, we can now turn to the environment representation.


\subsection{More-Orderly Environments}
\label{sec:more-orderly}

In a lexically-scoped language, the environment at the reference \texttt{x} in the fragment
\begin{verbatim}
(define f (λ (x y) ... (λ (z) ... (λ (w) ... x ...) ...) ...))
\end{verbatim}
 contains bindings for \texttt{x}, \texttt{y}, \texttt{z}, and \texttt{w}.
Exhaustive CFAs typically model this environment as a finite map from variables to contexts (i.e., the type $\mathit{Var} \rightarrow \mathit{Context}$).@;{
For instance, $k$-CFA uses this model with $\mathit{Binding} = \mathit{Contour}$ where a \emph{contour} $@(meta "c" #f) \in \mathit{Contour} = \mathit{Call}^{\le k}$ is the $k$-most-recent call sites encountered during evaluation
(and $\mathit{Call}$ is the set of call sites in the analyzed program).
Hence, $k$-CFA models the environment at the reference \texttt{x} as
$[
\mathtt{x} \mapsto @(meta "c" 0),
\mathtt{y} \mapsto @(meta "c" 1),
\mathtt{z} \mapsto @(meta "c" 2),
\mathtt{w} \mapsto @(meta "c" 3)
]$
for some contours @(meta "c" 0), @(meta "c" 1), @(meta "c" 2), and @(meta "c" 3).
$m$-CFA uses a similar representation, though it's contours represent the top-$m$ stack frames.

While this representation captures the structure necessary for $k$-CFA (or $m$-CFA), we observe that due to lexical-scoping}
We instead use a variable's de Bruijn index, which is statically determined by the program syntax,
and model environments as a sequence $\mathit{Context}^{*}$ which, for any finite program, has length bounded by the maximum lexical depth therein.
@;, splitting the environment by the context associated with each lexical set of variables.
@;{
For instance, we model the environment at the reference \texttt{x} as $[c1, c2, c3]$ 
where $c1$ represents the $m$-stack frames that led to calling the outermost $\lambda$, 
$c2$ the m-stack frames for the middle $\lambda$, and `c3` the m-stack frames for the innermost $\lambda$.
This representation discards none of the environment structure of $k$-CFA and captures more of the structure inherent in evaluation, 
although the selection of contours differs in the same way as $m$-CFA.
}

Given this environment representation, we make one final tweak to the definition of contexts:
we will qualify an indeterminate context $?$ with the parameter of the function whose context it represents, and assume programs are alphatized.\footnote{In practice, we use the syntactic context of the body instead of the parameter, which is unique even if the program is not alpha-converted.}
This way, an environment of even completely indeterminate contexts still determines the expression it closes.
For instance, we represent the indeterminate environment of \texttt{y} in \texttt{(λ (x) ((λ (y) y) (λ (z) z)))} by $\langle ?_{\mathtt{y}},?_{\mathtt{x}}\rangle$
which is distinct from the indeterminate environment of \texttt{z}, which we represent by $\langle ?_{\mathtt{z}},?_{\mathtt{x}}\rangle$, even though they have the same shape.

\subsection{Instantiating Contexts}

Demand $m$-CFA, at certain points during resolution, discovers information about the context in which the resolved flow occurs, and must instantiate relevant environments with that information.
For instance, in the program
\begin{verbatim}
(let ([apply (λ (f) (λ (x) (f x)))])
  (+ ((apply add1) 42)
     ((apply sub1) 35)))
\end{verbatim}
suppose that Demand $m$-CFA is issued an evaluation query for \texttt{(f x)} in the environment $\langle ?_{\mathtt{x}}, ?_{\mathtt{f}} \rangle$, i.e., the fully-indeterminate environment.
With our global view, we can see that \texttt{(f x)} evaluates to $43$ and $34$.
Let's consider how Demand $m$-CFA would arrive at the same conclusion.

First, it would trace \texttt{(λ (f) (λ (x) (f x)))} in the environment $\langle\rangle$ to the binding \texttt{apply} and then to the call sites \texttt{(apply add1)} in $\langle\rangle$ and \texttt{(apply sub1)} in $\langle\rangle$.
Each of these sites provides a context in which \texttt{f} is bound, so the evaluation of \texttt{(f x)} continues in two instantiations of $\langle ?_{\mathtt{x}}, ?_{\mathtt{f}} \rangle$:
the first to $\langle ?_{\mathtt{x}}, \mathtt{(apply\,add1)}::?_{\mathit{tl}}\rangle$ and the second to $\langle ?_{\mathtt{x}}, \mathtt{(apply\,sub1)}::?_{\mathit{tl}}\rangle$, where $?_{\mathit{tl}}$ is a dummy variable for the top-level context (the stack bottom).
To evaluate either \texttt{add1} or \texttt{sub1}, its argument is needed, which flows through \texttt{x}.
Then the two callers of \texttt{(λ (x) (f x))} must be resolved.
When \texttt{(λ (x) (f x))} flows to the result of \texttt{(apply add1)}, it is applied immediately at \texttt{((apply add1) 42)}.
Similarly, when it flows to the result of \texttt{(apply sub1)}, it is applied immediately at \texttt{((apply sub1) 35)}.
These two call sites provide the binding contexts for \texttt{x}.

We might be tempted at this point to blindly instantiate $?_{\mathtt{x}}$ with each of these sites.
However, in doing so, we will get \emph{six} environments, instantiating $?_{\mathtt{x}}$ in each of
$\langle ?_{\mathtt{x}}, ?_{\mathtt{f}} \rangle$,
$\langle ?_{\mathtt{x}}, \mathtt{(apply\,add1)}::?_{\mathit{tl}}\rangle$, and
$\langle ?_{\mathtt{x}}, \mathtt{(apply\,sub1)}::?_{\mathit{tl}}\rangle$
with each of
$\mathtt{((apply\,add1)\,42)}::?_{\mathit{tl}}$ and
$\mathtt{((apply\,sub1)\,35)}::?_{\mathit{tl}}$.
In particular, we obtain
\begin{align*}
\langle \mathtt{((apply\,sub1)\,35)}::?_{\mathit{tl}}, \mathtt{(apply\,add1)}::?_{\mathit{tl}}\rangle & & \langle \mathtt{((apply\,add1)\,42)}::?_{\mathit{tl}}, \mathtt{(apply\,sub1)}::?_{\mathit{tl}}\rangle
\end{align*}
which do not correspond to any environment which arises in an exhaustive analysis.

The issue is that blindly instantiating indeterminate contexts ignores the evaluation path taken to arrive at the call site.
In particular, it ignores where the nesting $\lambda$ is applied, which must be applied first (as we observed in the previous section).
In this example, we must consider the context of \texttt{(λ (f) (λ (x) (f x)))} before we instantiate the context of \texttt{(λ (x) (f x))}.

The solution, then, is to not substitute a indeterminate context with a more-determined context, but an entire environment headed by an indeterminate context with that same environment headed by the more-determined one.
This policy would, in this example, lead to all occurrences of
\begin{align*}
\langle ?_{\mathtt{x}}, \mathtt{(apply\,add1)}::?_{\mathit{tl}}\rangle & & \text{being substituted with} & & \langle \mathtt{((apply\,add1)\,42)}::?_{\mathit{tl}}, \mathtt{(apply\,add1)}::?_{\mathit{tl}}\rangle
\end{align*}
and            
\begin{align*}
\langle ?_{\mathtt{x}}, \mathtt{(apply\,sub1)}::?_{\mathit{tl}}\rangle & & \text{being substituted with} & & \langle \mathtt{((apply\,sub1)\,35)}::?_{\mathit{tl}}, \mathtt{(apply\,sub1)}::?_{\mathit{tl}}\rangle
\end{align*}
and no others, which is precisely what we would hope.

This policy is effective even when the result of the function does not depend on both values.
For instance, when Demand $m$-CFA evaluates \texttt{x} in \texttt{(λ (f) (λ (x) x))}, it must still determine the caller of \texttt{(λ (f) (λ (x) x))} to determine the downstream caller of \texttt{(λ (x) x)}.

\subsection{Whence the timestamp?}
\label{sec:whence-timestamp}

In addition to introducing environments, context-sensitivity also typically introduces ``timestamps'' which serve as snapshots of the context at each evaluation step.
For instance, classic $k$-CFA evaluates \emph{configurations}, consisting of an expression, environment, and timestamp, to results.

With a top-$m$-stack-frames abstraction, the ``current context'' is simply the context of the variable(s) most recently bound in the environment.
Lexical scope makes identifying these variables straightforward
and
our environment representation makes accessing their binding context straightforward as well.
Thus, under such an abstraction, the environment uniquely determines the timestamp, and we can omit timestamps from configurations with no loss of information.

With the context, its representation, and the environment's representation identified,
we are now ready to define Demand $m$-CFA.

\section{Demand $m$-CFA}
\label{sec:demand-mcfa}

@(require (rename-in (prefix-in mcfa- "demand-mcfa.rkt")))

\begin{figure}
\[
@|mcfa-bind-name| : \mathit{Var} \times \mathit{Exp} \times \mathit{Env} \rightarrow \mathit{Exp} \times \mathit{Env}
\]
@(align (list (list (mcfa-bind (var 'x) (cursor (e 0) (rat (e 1) (∘e))) (mcfa-ρ))
                    (list "=" (mcfa-bind (var 'x) (cursor (app (e 0) (e 1)) (∘e)) (mcfa-ρ))))
              (list (mcfa-bind (var 'x) (cursor (e 1) (ran (e 0) (∘e))) (mcfa-ρ))
                    (list "=" (mcfa-bind (var 'x) (cursor (app (e 0) (e 1)) (∘e)) (mcfa-ρ))))
              (list (mcfa-bind (var 'x) (cursor (e) (bod (var 'y) (∘e))) (:: (mcfa-cc) (mcfa-ρ)))
                    (list "=" (mcfa-bind (var 'x) (cursor (lam (var 'y) (e)) (∘e)) (mcfa-ρ))
                          "\\text{ where } " (≠  (var 'y) (var 'x))))
              (list (mcfa-bind (var 'x) (cursor (e) (bod (var 'x) (∘e))) (mcfa-ρ)) 
                    (list "=" (pair (cursor (e) (bod (var 'x) (∘e))) (mcfa-ρ))))))
\caption{The @|mcfa-bind-name| metafunction}
\label{fig:mcfa-bind}
\end{figure}

\begin{figure}
@mathpar[mcfa-parse-judgement]{
Lam
———
C[λx.e] ρ ⇓ C[λx.e] ρ


Rator
——
C[([e₀] e₁)] ρ ⇒ C[(e₀ e₁)] ρ


Ref
(Cx[e-x],ρ-x) = bind(x,C[x],ρ)  Cx[e-x] ρ-x ⇐ C'[(e₀ e₁)] ρ'  C'[(e₀ [e₁])] ρ' ⇓ Cv[λx.e] ρ-v
———
C[x] ρ ⇓ Cv[λx.e] ρ-v

App
C[([e₀] e₁)] ρ ⇓ C'[λx.e] ρ'  C'[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ' ⇓ Cv[λx.e-v] ρ-v
———
C[(e₀ e₁)] ρ ⇓ Cv[λx.e-v] ρ-v


Rand
C[([e₀] e₁)] ρ ⇓ C'[λx.e] ρ'  x C'[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ' F Cx[x] ρ-x  Cx[x] ρ-x ⇒ C''[(e₂ e₃)] ρ''
——
C[(e₀ [e₁])] ρ ⇒ C''[(e₂ e₃)] ρ''

Body
C[λx.[e]] ρ ⇐ C'[(e₀ e₁)] ρ'  C'[(e₀ e₁)] ρ' ⇒ C''[(e₂ e₃)] ρ''
——
C[λx.[e]] ρ ⇒ C''[(e₂ e₃)] ρ''

Find-Ref
——
x C[x] ρ F C[x] ρ

Find-Rator
x C[([e₀] e₁)] ρ F Cx[x] ρ-x
——
x C[(e₀ e₁)] ρ F Cx[x] ρ-x

Find-Rand
x C[(e₀ [e₁])] ρ F Cx[x] ρ-x
——
x C[(e₀ e₁)] ρ F Cx[x] ρ-x

Find-Body
x ≠ y  x C[λy.[e]] ?C[λy.[e]]::ρ F Cx[x] ρ-x
——
x C[λy.e] ρ F Cx[x] ρ-x

}
\caption{Demand $m$-CFA Resolution}
\label{fig:mcfa-resolution}
\end{figure}

Demand $m$-CFA augments Demand 0CFA with environments and environment-instantiation mechanisms which together provide context sensitivity.
The addition of environments pervades @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-find-name| which are otherwise identical to their Demand 0CFA counterparts;
these enriched relations are presented in Figure~\ref{fig:mcfa-resolution}.


When a call is entered, which occurs in the @clause-label{App} and @clause-label{Rand} rules, a new environment is synthesized using the @|mcfa-time-succ-name| metafunction which determines the binding context of the call as 
\[
@(mcfa-time-succ (cursor (app (e 0) (e 1)) (∘e)) (:: (mcfa-cc) (mcfa-ρ))) = \lfloor @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc)) \rfloor_m
\]
where $\lfloor\cdot\rfloor_{m}$ is defined
\begin{align*}
\lfloor @(mcfa-cc) \rfloor_0 = \square & & \lfloor ?_{@(var 'x)} \rfloor_m = ?_{@(var 'x)} & & \lfloor @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc)) \rfloor_m = @(:: (cursor (app (e 0) (e 1)) (∘e)) (list "\\lfloor " (mcfa-cc) "\\rfloor_{m-1}"))
\end{align*}
The @|mcfa-bind-name| metafunction, which locates the binding configuration of a variable reference, is lifted to accommodate environments as well;
its definition is presented in Figure~\ref{fig:mcfa-bind}.

However, the @|mcfa-call-name| relation changes substantially.

The particular changes to the @|mcfa-call-name| require us to make the reachability relation @|mcfa-reach-name| explicit.
We define reachability over queries themselves;
the judgment @(mcfa-reach "q" "q'") captures that, if query $q$ is reachable in analysis, then $q'$ is also, where $q$ is of the form
\[
\mathit{Query} \ni q ::= \mathsf{eval}(@(cursor (e) (∘e)),@(mcfa-ρ)) \,|\, \mathsf{expr}(@(cursor (e) (∘e)),@(mcfa-ρ)) \,|\, \mathsf{call}(@(cursor (e) (∘e)),@(mcfa-ρ))
\]
Figure~\ref{fig:demand-mcfa-reachability} presents a formal definition of @|mcfa-reach-name|.

\begin{figure}
@mathpar[mcfa-parse-judgement]{
Reflexivity
——
q ⇑ q


Ref-Caller
q ⇑ ev C[x] ρ  (C'[e],ρ') = bind(x,C[x],ρ)
——
q ⇑ ca C'[e] ρ'

Ref-Argument
q ⇑ ev C[x] ρ  (C'[e],ρ') = bind(x,C[x],ρ)  C'[e] ρ' ⇐ C''[(e₀ e₁)] ρ''
——
q ⇑ ev C''[(e₀ [e₁])] ρ''


App-Operator
q ⇑ ev C[(e₀ e₁)] ρ
——
q ⇑ ev C[([e₀] e₁)] ρ

App-Body
q ⇑ ev C[(e₀ e₁)] ρ  C[([e₀] e₁)] ρ ⇓ C'[λx.e] ρ'
——
q ⇑ ev C'[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ'


Call-Trace
q ⇑ ca C[λx.[e]] ctx::ρ
——
q ⇑ ex C[λx.e] ρ


Rand-Operator
q ⇑ ex C[(e₀ [e₁])] ρ
——
q ⇑ ev C[([e₀] e₁)] ρ

Rand-Body
q ⇑ ex C[(e₀ [e₁])] ρ  C[([e₀] e₁)] ρ ⇓ C'[λx.e] ρ'  x C'[λx.[e]] time-succ(C[(e₀ e₁)],ρ)::ρ' F Cx[x] ρ-x
——
q ⇑ ex Cx[x] ρ-x


Body-Caller-Find
q ⇑ ex C[λx.[e]] ρ
——
q ⇑ ca C[λx.[e]] ρ

Body-Caller-Trace
q ⇑ ex C[λx.[e]] ρ  C[λx.[e]] ρ ⇐ C'[(e₀ e₁)] ρ'
——
q ⇑ ex C'[(e₀ e₁)] ρ'

}
\caption{Demand $m$-CFA Reachability}
\label{fig:demand-mcfa-reachability}
\end{figure}

\begin{figure}
@mathpar[mcfa-parse-judgement]{
Known-Call
q ⇑ ca C[λx.[e]] ctx₀::ρ  C[λx.e] ρ ⇒ C'[(e₀ e₁)] ρ'  ctx₁ := time-succ(C'[(e₀ e₁)],ρ')  ctx₀ = ctx₁
——
C[λx.[e]] ctx₀::ρ ⇐ C'[(e₀ e₁)] ρ'

Unknown-Call
q ⇑ ca C[λx.[e]] ctx₀::ρ  C[λx.e] ρ ⇒ C'[(e₀ e₁)] ρ'  ctx₁ := time-succ(C'[(e₀ e₁)],ρ')  ctx₁ ⊏ ctx₀
——
ctx₀::ρ R ctx₁::ρ

}
\caption{Demand $m$-CFA Call Discovery}
\label{fig:mcfa-call-reachability}
\end{figure}

The @clause-label{Reflexivity} rule ensures that the top-level query is considered reachable.
The @clause-label{Ref-Caller} and @clause-label{Ref-Argument} rules establish reachability corresponding to the @clause-label{Ref} rule of @|mcfa-eval-name|:
@clause-label{Ref-Caller} makes the caller query reachable and, if it succeeds, @clause-label{Ref-Argument} makes the ensuing evaluation query reachable.
@clause-label{App-Operator} and @clause-label{App-Body} do the same for the @clause-label{App} rule of @|mcfa-eval-name|, making, respectively, the operator evaluation query reachable and, if it yields a value, the body evaluation query reachable.
@clause-label{Rand-Operator} makes the evaluation query of the @clause-label{Rand} rule reachable and @clause-label{Rand-Body} makes the trace query of any references in the operator body reachable.
@clause-label{Body-Caller-Find} makes the caller query of @clause-label{Body} reachable;
if a caller is found, @clause-label{Body-Caller-Trace} makes the trace query of that caller reachable.
Finally, @clause-label{Call-Trace} makes sure that the trace query of an enclosing $\lambda$ of a caller query is reachable.

Now we are in a position to discuss the definition of @|mcfa-call-name|, presented in Figure~\ref{fig:mcfa-call-reachability}.

Unlike @|mcfa-eval-name| and @|mcfa-expr-name|, @|mcfa-call-name| is defined in terms of reachability.
The @clause-label{Known-Call} rule says that the resultant caller of a trace query 
is also a result of a caller query if 
\begin{enumerate*} \item the caller query is reachable,
\item the ensuing trace query of its enclosing $\lambda$ yields a caller, 
\item the discovered call and caller query's binding contexts are the same\end{enumerate*}.
The call is \emph{known} because the caller query has the context of the call already in its environment.
If @(≠ (mcfa-cc 1) (mcfa-cc 0)), however, then the result constitutes an \emph{unknown} caller.
In this case, @clause-label{Unknown-Call} considers whether @(mcfa-cc 1) refines @(mcfa-cc 0) in the sense that @(mcfa-cc 0) can be instantiated to form @(mcfa-cc 1).
Formally, the refinement relation $\sqsubset$ is defined as the least relation satisfying
\begin{align*}
@(:: (cursor (app (e 0) (e 1)) (∘e "'")) (mcfa-cc)) \sqsubset\; ?_{@(cursor (e) (∘e))} & & @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc 1)) \sqsubset @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc 0))\Longleftarrow @(mcfa-cc 1) \sqsubset @(mcfa-cc 0)
\end{align*}
If @(mcfa-cc 1) refines @(mcfa-cc 0), @clause-label{Unknown-Call} does not conclude a @|mcfa-call-name| judgement, but rather an \emph{instantiation} judgement @(mcfa-instantiation (:: (mcfa-cc 0) (mcfa-ρ)) (:: (mcfa-cc 1) (mcfa-ρ))) which denotes that \emph{any} environment @(:: (mcfa-cc 0) (mcfa-ρ)) may be instantiated to @(:: (mcfa-cc 1) (mcfa-ρ)).
It is by this instantiation that @clause-label{Known-Call} will be triggered.
When @(mcfa-cc 1) does not refine @(mcfa-cc 0), the resultant caller is ignored which, in effect, filters the callers to only those which are compatible and ensures that Demand $m$-CFA is indeed context-sensitive.

Figure~\ref{fig:demand-mcfa-instantiation} presents an extension of @|mcfa-reach-name| which propagates instantiations to all reachable queries.
\begin{figure}
@mathpar[mcfa-parse-judgement]{
Instantiate-Reachable-Eval
q ⇑ ev C[e] ρ  ρ₀ R ρ₁
——
q ⇑ ev C[e] ρ[ρ₁/ρ₀]

Instantiate-Eval
ρ₀ R ρ₁  C[e] ρ[ρ₁/ρ₀] ⇓ Cv[λx.e] ρ-v
——
C[e] ρ ⇓ Cv[λx.e] ρ-v


Instantiate-Reachable-Expr
q ⇑ ex C[e] ρ  ρ₀ R ρ₁
——
q ⇑ ex C[e] ρ[ρ₁/ρ₀]

Instantiate-Expr
ρ₀ R ρ₁  C[e] ρ[ρ₁/ρ₀] ⇒ C'[(e₀ e₁)] ρ'
——
C[e] ρ ⇒ C'[(e₀ e₁)] ρ'


Instantiate-Reachable-Call
q ⇑ ca C[e] ρ  ρ₀ R ρ₁
——
q ⇑ ca C[e] ρ[ρ₁/ρ₀]

Instantiate-Call
ρ₀ R ρ₁  C[e] ρ[ρ₁/ρ₀] ⇐ C'[(e₀ e₁)] ρ'
——
C[e] ρ ⇐ C'[(e₀ e₁)] ρ'

App-Body-Instantiation
q ⇑ ev C[(e₀ e₁)] ρ  C[([e₀] e₁)] ρ ⇓ C'[λx.e] ρ'
——
?C'[λx.[e]]::ρ' R time-succ(C[(e₀ e₁)],ρ)::ρ'

Rand-Body-Instantiation
q ⇑ ex C[(e₀ [e₁])] ρ  C[([e₀] e₁)] ρ ⇓ C'[λx.e] ρ'
——
?C'[λx.[e]]::ρ' R time-succ(C[(e₀ e₁)],ρ)::ρ'

}
\caption{Demand $m$-CFA Instantiation}
\label{fig:demand-mcfa-instantiation}
\end{figure}
The @clause-label{Instantiate-Reachable-*} rules ensure that if a query of any kind is reachable, then its instantiation is too.
When an instantiation @(mcfa-instantiation (mcfa-ρ 0) (mcfa-ρ 1)) does not apply (so that @(mcfa-ρ) is unchanged), each rule reduces to a trivial inference.
The counterpart @clause-label{Instantiate-*} rules, also present in Figure~\ref{fig:demand-mcfa-instantiation}, each extend one of @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-call-name| so that, if an instantiated query of that type yields a result, the original, uninstantiated query yields that same result.
As discussed at the beginning of this section, Demand $m$-CFA also discovers instantiations when it extends the environment in the @clause-label{App} and @clause-label{Rand} rules.
The @clause-label{App-Body-Instantiation} and @clause-label{Rand-Body-Instantiation} rules capture these cases.

The definition of Demand $m$-CFA in terms of an ``evaluation'' relation (which includes evaluation, trace, and caller resolution) and a reachability relation follows the full formal approach of \emph{Abstracting Definitional Interpreters} by @citet{darais2017diss}.
From this correspondence, we can define the Demand $m$-CFA resolution of a given query as the least fixed point of these relations, effectively computable with the algorithm @citet{darais2017diss} provides.
We discuss this implementation in more depth in \S~\ref{sec:implementation}.


\section{Demand $m$-CFA Correctness}
\label{sec:demand-mcfa-correctness}

Demand $m$-CFA is a hierarchy of demand CFA.
Instances higher in the hierarchy naturally have larger state spaces.
The size $|@|mcfa-eval-name||$ of the @|mcfa-eval-name| relation satisfies the inequality
\[
|@|mcfa-eval-name|| \le |\mathit{Config} \times \mathit{Config}| = |\mathit{Config}|^{2} = |\mathit{Exp} \times \mathit{Env}|^{2} = |\mathit{Exp}|^{2}|\mathit{Env}|^{2} = n^2|\mathit{Env}|^{2}
\]
where $n$ is the size of the program.
We then have
\[
|\mathit{Env}| \le |\mathit{Ctx}|^{n} \le (|\mathit{Call}|+1)^{mn} \le n^{mn}
\]
since the size of environments is statically bound and may be indeterminate.
Thus, $|@|mcfa-eval-name|| \le n^{mn+2}$;
the state space of @|mcfa-eval-name| is finite but with an exponential bound;
the state spaces of @|mcfa-expr-name| and @|mcfa-call-name| behave similarly.

\subsection{Demand $m$-CFA Refinement}

Instances higher in the hierarchy are also more precise, which we formally express with the following theorems.
\begin{theorem}[Evaluation Refinement]
If
@mcfa-parse-judgement{C[e] ρ₀ ⇓m+1 Cv[λx.e-v] ρ₀'}
where
@mcfa-parse-judgement{ρ₀ ⊑ ρ₁}
then
@mcfa-parse-judgement{C[e] ρ₁ ⇓ Cv[λx.e-v] ρ₁'}
where
@mcfa-parse-judgement{ρ₀' ⊑ ρ₁'}.
\end{theorem}
\begin{theorem}[Trace Refinement]
If
@mcfa-parse-judgement{C[e] ρ₀ ⇒m+1 C'[(e₀ e₁)] ρ₀'}
where
@mcfa-parse-judgement{ρ₀ ⊑ ρ₁}
then
@mcfa-parse-judgement{C[e] ρ₁ ⇒ C'[(e₀ e₁)] ρ₁'}
where
@mcfa-parse-judgement{ρ₀' ⊑ ρ₁'}.
\end{theorem}
\begin{theorem}[Caller Refinement]
If
@mcfa-parse-judgement{C[e] ρ₀ ⇐m+1 C'[(e₀ e₁)] ρ₀'}
where
@mcfa-parse-judgement{ρ₀ ⊑ ρ₁}
then
@mcfa-parse-judgement{C[e] ρ₁ ⇐ C'[(e₀ e₁)] ρ₁'}
where
@mcfa-parse-judgement{ρ₀' ⊑ ρ₁'}.
\end{theorem}
These theorems state that refining configurations submitted to Demand $m$-CFA and its successor Demand $m$+1-CFA yield refining configurations.
The proof proceeds directly (if laboriously) by induction on the derivations of the relations.

\subsection{Demand $\infty$-CFA and Demand Evaluation}

@(require (prefix-in demand- "demand-evaluation.rkt"))

To show that Demand $m$-CFA is sound with respect to a standard call-by-value (CBV) semantics, we consider the limit of the hierarchy, Demand $\infty$-CFA, in which context lengths are unbounded.
From here, we bridge Demand $\infty$-CFA to a CBV semantics with a concrete form of demand analysis called \emph{Demand Evaluation}.
Our strategy will be to show that the Demand $\infty$-CFA semantics is equivalent to Demand Evaluation which itself is sound with respect to a standard CBV semantics.

Demand Evaluation is defined in terms of relations @|demand-eval-name|, @|demand-expr-name|, and @|demand-call-name| which are counterpart to @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-call-name|, respectively.
Like their counterparts, @|demand-eval-name|, @|demand-expr-name|, and @|demand-call-name| relate configurations to configurations.
However, a Demand Evaluation configuration includes a store @(demand-σ) from addresses $n$ to calls consisting of a call site and its environment.
Demand Evaluation environments, rather than being a sequence of contexts, are sequences of addresses.
Like contexts, an address may denote an indeterminate context (i.e. call) which manifests as an address which is not mapped in the store.
Formally, the components of stores and environments are defined
\begin{align*}
(s,n), @(demand-σ) \in \mathit{Store}   &= (\mathit{Addr} \rightarrow \mathit{Call}) \times \mathit{Addr} &
@(demand-ρ) \in \mathit{Env}     &= \mathit{Addr}^{*} \\
@(demand-cc) \in \mathit{Call} &= \mathit{App} \times \mathit{Env} &
n \in \mathit{Addr}              &= \mathbb{N}
\end{align*}
A store is a pair consisting of a map from addresses to calls and the next address to use;
the initial store is $(\bot,0)$.

Figure~\ref{fig:demand-evaluation} presents the definitions of @|demand-eval-name|, @|demand-expr-name|, and @|demand-call-name|.
\begin{figure}
@mathpar[demand-parse-judgement]{
Lam
———
C[λx.e] ρ σ ⇓ C[λx.e] ρ σ


Rator
——
C[([e₀] e₁)] ρ σ ⇒ C[(e₀ e₁)] ρ σ


Ref
(Cx[e-x],ρ-x) = bind(x,C[x],ρ)  Cx[e-x] ρ-x σ₀ ⇐ C'[(e₀ e₁)] ρ' σ₁  C'[(e₀ [e₁])] ρ' σ₁ ⇓ Cv[λx.e] ρ-v σ₂
———
C[x] ρ σ₀ ⇓ Cv[λx.e] ρ-v σ₂

App
C[([e₀] e₁)] ρ σ₀ ⇓ C'[λx.e] ρ' σ₁  (n,σ₂) := fresh(σ₁)  C'[λx.[e]] n::ρ' σ₂[n ↦ (C[(e₀ e₁)],ρ)] ⇓ Cv[λx.e-v] ρ-v σ₃
———
C[(e₀ e₁)] ρ σ₀ ⇓ Cv[λx.e-v] ρ-v σ₃


Rand
C[([e₀] e₁)] ρ σ₀ ⇓ C'[λx.e] ρ' σ₁  (n,σ₂) := fresh(σ₁)  x C'[λx.[e]] n::ρ' σ₂[n ↦ (C[(e₀ e₁)],ρ)] F Cx[x] ρ-x σ₃  Cx[x] ρ-x σ₃ ⇒ C''[(e₂ e₃)] ρ'' σ₄
——
C[(e₀ [e₁])] ρ σ₀ ⇒ C''[(e₂ e₃)] ρ'' σ₄

Body
C[λx.[e]] ρ σ₀ ⇐ C'[(e₀ e₁)] ρ' σ₁  C'[(e₀ e₁)] ρ' σ₁ ⇒ C''[(e₂ e₃)] ρ'' σ₂
——
C[λx.[e]] ρ σ₀ ⇒ C''[(e₂ e₃)] ρ'' σ₂

Find-Ref
——
x C[x] ρ σ F C[x] ρ σ

Find-Rator
x C[([e₀] e₁)] ρ σ₀ F Cx[x] ρ-x σ₁
——
x C[(e₀ e₁)] ρ σ₀ F Cx[x] ρ-x σ₁

Find-Rand
x C[(e₀ [e₁])] ρ σ₀ F Cx[x] ρ-x σ₁
——
x C[(e₀ e₁)] ρ σ₀ F Cx[x] ρ-x σ₁

Find-Body
x ≠ y  (n,σ₁) := fresh(σ₀)  x C[λy.[e]] n::ρ σ₁ F Cx[x] ρ-x σ₂
——
x C[λy.e] ρ σ₀ F Cx[x] ρ-x σ₂

Unknown-Call
σ₀(n) = ⊥  C[λx.e] ρ σ₀ ⇒ C'[(e₀ e₁)] ρ' σ₁  σ₂ := σ₁[n ↦ (C'[(e₀ e₁)],ρ')]
——
C[λx.[e]] n::ρ σ₀ ⇐ C'[(e₀ e₁)] ρ' σ₂

Known-Call
σ₀(n) = (C[(e₀ e₁)],ρ')  C[λx.e] ρ σ₀ ⇒ C'[(e₀ e₁)] ρ'' σ₁  ρ' ≡σ₁ ρ''  σ₂ := σ₁[ρ''/ρ']
——
C[λx.[e]] n::ρ σ₀ ⇐ C'[(e₀ e₁)] ρ'' σ₂

}
\caption{Demand Evaluation}
\label{fig:demand-evaluation}
\end{figure}
Most rules are unchanged from Demand $m$-CFA modulo the addition of stores.
Instantiation in Demand Evaluation is captured by creating a mapping in the store.
For instance, Demand $m$-CFA's @clause-label{App} rule ``discovers'' the caller of the entered call, which effects an instantiation via @clause-label{App-Body-Instantiation}.
In contrast, Demand Evaluation's @clause-label{App} rule allocates a fresh address $n$ using @|demand-fresh-name|, maps it to the caller in the store, and extends the environment of the body with it.
The @|demand-fresh-name| metafunction extracts the unused address and returns a store with the next one.
Store extension is simply lifted over the next unused address.
Formally, they are defined as follows.
\begin{align*}
@|demand-fresh-name|((s,n)) := (n,(s,n+1)) & & (s,n)[n_0 \mapsto @(demand-cc)] := (s[n_0 \mapsto @(demand-cc)],n)
\end{align*}
@clause-label{Unknown-Call} applies when the address $n$ is unmapped in the store.
It instantiates the environment by mapping $n$ with the discovered caller.
@clause-label{Known-Call} uses @|demand-≡σ-name| to ensure that the known and discovered environments are isomorphic in the store.
The @|demand-≡σ-name| relation is defined on addresses and lifted elementwise to environments.
We have
@(demand-≡σ (demand-σ) "n_0" "n_1")
if and only if
$\sigma(n_0) = \bot = \sigma(n_1)$
or
$\sigma(n_0)=(@(cursor (app (e 0) (e 1)) (∘e)),@(demand-ρ 0))$,
$\sigma(n_1)=(@(cursor (app (e 0) (e 1)) (∘e)),@(demand-ρ 1))$, and
@(demand-≡σ (demand-σ) (demand-ρ 0) (demand-ρ 1)).
If the environments are isomorphic, then all instances of the known environment are substituted with the discovered environment in the store, ensuring that queries in terms of the known are kept up to date.
This rule corresponds directly to the instantiation relation of Demand $m$-CFA.

\subsection{Demand Evaluation Equivalence}

@(require (prefix-in combined- "combined.rkt"))

In order to show a correspondence between Demand $\infty$-CFA and Demand Evaluation,
we establish a correspondence between the environments of the former and the environment--store pairs of the latter, captured by the judgement @combined-parse-judgement{ρ ⇓ ρ σ} defined by the following rules.
\begin{mathpar}
\inferrule
{ @combined-parse-judgement{cc-1 F n-1 σ} \\
  \dots \\
  @combined-parse-judgement{cc-k F n-k σ}
  }
{ @combined-parse-judgement{ρ-is ⇓ ρ-is σ}
  }


\inferrule
{ }
{ @combined-parse-judgement{() R () σ}
  }

\inferrule
{ @combined-parse-judgement{app::cc F n σ}
  }
{ @combined-parse-judgement{app::cc R n::ρ σ}
  }

\inferrule
{ @combined-parse-judgement{σ(n) = ⊥}
  }
{ @combined-parse-judgement{? F n σ}
  }

\inferrule
{ @combined-parse-judgement{σ(n) = (app,ρ)} \\
  @combined-parse-judgement{cc R ρ σ}
  }
{ @combined-parse-judgement{app::cc F n σ}
  }

\end{mathpar}
This judgement ensures that each context in the Demand $\infty$-CFA environment matches precisely with the corresponding address with respect to the store:
if the context is indeterminate, the address must not be mapped in the store;
otherwise, if the heads of the context are the same, the relation recurs.

Now it is straightforward to express the equivalence between the Demand $\infty$-CFA relations and Demand Evaluation.

\begin{theorem}[Evaluation Equivalence]
If
@combined-parse-judgement{ρ₀ ⇓ ρ₀ σ₀}
then
@mcfa-parse-judgement{C[e] ρ₀ ⇓∞ C'[λx.e] ρ₁}
if and only if
@demand-parse-judgement{C[e] ρ₀ σ₀ ⇓ C'[λx.e] ρ₁ σ₁}
where
@combined-parse-judgement{ρ₁ ⇓ ρ₁ σ₁}.
\end{theorem}

\begin{theorem}[Trace Equivalence]
If
@combined-parse-judgement{ρ₀ ⇓ ρ₀ σ₀}
then
@mcfa-parse-judgement{C[e] ρ₀ ⇒∞ C'[(e₀ e₁)] ρ₁}
if and only if
@demand-parse-judgement{C[e] ρ₀ σ₀ ⇒ C'[(e₀ e₁)] ρ₁ σ₁}
where
@combined-parse-judgement{ρ₁ ⇓ ρ₁ σ₁}.
\end{theorem}

\begin{theorem}[Caller Equivalence]
If
@combined-parse-judgement{ρ₀ ⇓ ρ₀ σ₀}
then
@mcfa-parse-judgement{C[e] ρ₀ ⇐∞ C'[(e₀ e₁)] ρ₁}
if and only if
@demand-parse-judgement{C[e] ρ₀ σ₀ ⇐ C'[(e₀ e₁)] ρ₁ σ₁}
where
@combined-parse-judgement{ρ₁ ⇓ ρ₁ σ₁}.
\end{theorem}

These theorems are proved by induction on the derivations, corresponding instantiation of environments on the Demand $\infty$-CFA side with mapping an address on the Demand Evaluation side.

\section{Implementation}
\label{sec:implementation}

We have implemented Demand $m$-CFA using the \emph{Abstracting Definitional Interpreters} approach@~cite{darais2017abstracting}.
Using this approach, one defines a definitional interpreter of their evaluator in
a monadic and open recursive style (so that the analyzer can intercept recursive calls to the evaluator).

@omit{
      For illustration, Figure~\ref{fig:implementation} presents the gratifyingly-concise implementation of the core components of Demand $m$-CFA over the unary $\lambda$ calculus using this approach.
      \begin{figure}
      \begin{alltt}
      (define ((eval eval expr call) \ensuremath{C[e']} \ensuremath{\rho})
      (>>= (get-refines \ensuremath{\rho}) 
            (λ (\ensuremath{\rho})
                  (match \ensuremath{C[e']}
                  (\ensuremath{C[\lambda\!\!\!\ x.e]} (unit \ensuremath{C[\lambda\!\!\!\ x.e]} \ensuremath{\rho}))
                  (\ensuremath{C[x]} (let (((\ensuremath{C[\lambda\!\!\!\ x.[e\sb{x}]]} \ensuremath{\rho\sb{x}}) (bind \ensuremath{x} \ensuremath{C[x]} \ensuremath{\rho}))) 
                              (>>= (call \ensuremath{C[\lambda\!\!\!\ x.[e\sb{x}]]} \ensuremath{\rho\sb{x}})
                              (λ (\ensuremath{C[(e\sb{0}\,e\sb{1})]} \ensuremath{\rho\sb{\mathit{call}}})
                                    (eval \ensuremath{C[(e\sb{0}\,[e\sb{1}])]} \ensuremath{\rho\sb{\mathit{call}}})))))
                  (\ensuremath{C[(e\sb{0}\,e\sb{1})]} (>>= (eval \ensuremath{C[([e\sb{0}]\,e\sb{1})]} \ensuremath{\rho})
                              (λ (\ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.e]} \ensuremath{\rho\sb{\lambda}})
                                    (eval \ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.[e]]} (succ m \ensuremath{(C[(e\sb{0}\,e\sb{1})],\rho)})::\ensuremath{\rho\sb{\lambda}}))))))))

      (define ((expr eval expr call) \ensuremath{C'[e]} \ensuremath{\rho})
      (>>= (get-refines \ensuremath{\rho}) 
            (λ (\ensuremath{\rho})
                  (match \ensuremath{C'[e]}
                  (\ensuremath{C[([e\sb{0}]\,e\sb{1})]} (unit \ensuremath{C[(e\sb{0}\,e\sb{1})]} \ensuremath{\rho}))
                  (\ensuremath{C[(e\sb{0}\,[e\sb{1}])]} (>>= (eval \ensuremath{C[([e\sb{0}]\,e\sb{1})]} \ensuremath{\rho})
                                    (λ (\ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.e]} \ensuremath{\rho\sb{\lambda}})
                                    (>>= (find \ensuremath{x} \ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.[e]]} (succ m \ensuremath{(C[(e\sb{0}\,e\sb{1})],\rho)})::\ensuremath{\rho\sb{\lambda}})
                                          expr))))    
                  (\ensuremath{C[\lambda\!\!\!\ x.[e]]} (>>= (call \ensuremath{C[\lambda\!\!\!\ x.[e]]} \ensuremath{\rho}) expr))
                  (\ensuremath{[e]} fail)))))

      (define ((call eval expr call) \ensuremath{C[\lambda\!\!\!\ x.[e]]} \ensuremath{\mathit{ctx}\sb{0}::\rho})
      (>>= (get-refines \ensuremath{\rho}) 
            (λ (\ensuremath{\rho})
                  (>>= (expr \ensuremath{C[\lambda\!\!\!\ x.e]} \ensuremath{\rho})
                  (λ (\ensuremath{C[(e\sb{0}\,e\sb{1})]} \rho\sb{call})
                        (let ((\ensuremath{ctx\sb{1}} (succ m \ensuremath{C[(e\sb{0}\,e\sb{1})]})))
                        (if (eq-refines \ensuremath{\mathit{ctx}\sb{0}} \ensuremath{\mathit{ctx}\sb{1}}) 
                              (unit \ensuremath{C[(e\sb{0}\,e\sb{1})]} \ensuremath{\rho\sb{call}})
                              (if (eq-refines \ensuremath{\mathit{ctx}\sb{1}} \ensuremath{\mathit{ctx}\sb{0}}))
                                    (add-refine \ensuremath{\mathit{ctx}\sb{0}::\rho} \ensuremath{\mathit{ctx}\sb{1}::\rho})
                                    fail
                              )))))))
      
      \end{alltt}
      \caption{The core of Demand $m$-CFA's implementation using the \textit{ADI} approach}
      \label{fig:implementation}
      \end{figure}
      Because the @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-call-name| relations are mutually recursive, their implementations \texttt{eval}, \texttt{expr}, and \texttt{call} are mutually recursive and each receives references to the others with which to make recursive calls.
      Refinements are added to monadic state with continuations registered for each call to @|mcfa-get-refines-name|, which runs computation under every refinement of \ensuremath{\mathit{\rho}} including the identity refinement.
}

The result of the analysis is a map with four types of keys, one corresponding to evaluation queries through \texttt{eval}, one to trace queries through \texttt{expr}, one to uses of \texttt{call}, and one to refinements for each \ensuremath{\mathit{\rho}} encountered in the analysis.
Keys locate the results of the query;
if the key is present in the map, then the results it locates are sound with respect to the query.


\subsection{Pushdown Precision}

An important property of an analyzer is whether its search over the control-flow graph respects CFL reachability.
In the CFA literature, such analyses are often described as ``pushdown'' since they construct a pushdown model of control flow (e.g. @~cite{local:p4f}).
One of the features of the ADI approach to analysis construction is that the analyzer's search is disciplined by the continuation of the defining language, which induces a pushdown model naturally.

Demand $m$-CFA exhibits pushdown precision with respect to two different semantics.
First, it is pushdown precise with respect to the demand semantics given in \S~\ref{sec:demand-mcfa}, defined as big-step relations, by virtue of its implementation using the ADI technique.
Second, it is pushdown precise with respect the the direct semantics as well.
The reason here is a result of the insight of @citet{local:p4f}: a continuation address which consists of a target (function body) expression and its environment is distinct enough to perfectly correspond calls and returns (but not needlessly distinct to increase analysis complexity).
In Demand $m$-CFA, the @|mcfa-call-name| relation serves as a kind of continuation store relating a target body and its environment to caller configurations.
Because the @|mcfa-call-name| relation is used to access caller configurations both to access arguments and return results (via tracing), it fulfills each call and return aspect of control flow.


\section{Evaluation}
\label{sec:evaluation}
We implemented Demand $m$-CFA for a subset of R6RS Scheme@~cite{dvanhorn:Sperber2010Revised} including \texttt{let}, \texttt{let*}, and \texttt{letrec} binding forms;
mutually-recursive definitions and a few dozen primitives. 
We also implemented support for algebraic datatypes and matching on those datatypes, which is a particularly elegant extension to the formalism. 
The representation of closures and constructors both utilize a syntactic context (i.e. lambda, or application of the constructor) paired with an environment.
Pattern matching alternates between @|mcfa-expr-name| and @|mcfa-eval-name| discovering introduction forms (applications of the constructors) 
that flow to the scrutinee and evaluating the appropriate clause based on the discriminant and the pattern order. 
We reuse support for constructors and matching to desugar \texttt{if}, \texttt{cond}, \texttt{and} and \texttt{or} expressions.

We benchmarked on the selection of standard R6RS benchmarks used in ``Pushdown flow analysis with abstract garbage collection''@~cite{johnson:earl:dvanhorn:PushdownGarbage}
and commonly used in other literature on control flow analysis
@;{in the evaluation of $m$-CFA@~cite{dvanhorn:Might2010Resolving}.}

We evaluate Demand $m$-CFA with respect to the following:
\begin{enumerate}
\item Is the implementation cost of Demand $m$-CFA comparable to an exhaustive analysis?
\item What fraction of information is Demand $m$-CFA able to get with different levels of constant effort?
\item How does the precision compare to an exhaustive $m$-CFA?
\end{enumerate}

\subsection{Implementation cost}
Using the ADI framework to implement both analyses we found that the amount of code needed is on the same order of magnitude.
Demand $m$-CFA requires 630 lines of code while $m$-CFA uses 450 lines of code, without supporting functions shared between the two.
Demand $m$-CFA requires additional lines of code due to the fact that it has to be able to not only evaluate, but also trace flow of values.
Due to the ability of Demand $m$-CFA to work on smaller subsections of programs it can fail on unknown primitives, 
and still give information for queries that don't interact with those primitives. 
This is in contrast to $m$-CFA's soundness which requires that the full program be analyzable. 

Primitives have to be done slightly different for constructors which are lazily evaluted using Demand $m$-CFA. 

\subsection{Demand $m$-CFA scalability}
Demand $m$-CFA introduces a different paradigm for context sensitive analyses, due to the ability to set the effort per program point instead of
a global timeout.

Utilizing ADI, we add an effort parameter called gas which at each (mutually) recursive call reduces the amount of gas left. 
When the gas runs out the analysis reports an error and bails out early.


\begin{figure}[t]
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_legendx.png}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_blur.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_eta.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_kcfa2.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_kcfa3.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_loop2.pdf} 
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_mj09.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_primtest.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_regex.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_rsa.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_sat.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{total-queries-answered_scheme2java.pdf}
\end{subfigure}
\caption{The percent of queries answered (y-axis) given the effort allocated (x-axis).}
\label{fig:dmcfa-scalability}
\end{figure}

Figure~\ref{fig:dmcfa-scalability} shows the percent of queries answered for a given amount of effort allotted.

As can be seen, the graphs trend upward and to the right, regardless of our choice of $m$. 
Notable exceptions include the \texttt{loop2} \texttt{regex}, and \texttt{scheme2java} programs.
\texttt{loop2} is small and utilizes the \texttt{set!} form to initialize a recursive function.
In this case we are able to obtain all information that is possible to obtain near instantly.
\texttt{scheme2java} and \texttt{regex} are both larger programs, and significantly improve when explored
at higher $m$ which exemplifies a known phenomenon from exhaustive CFA that increasing precision can actually
decrease the state space due to fewer spurious flows. 
Of notable interest is that at $m=0$ an exhaustive $m$-CFA of \texttt{scheme2java}
requires an effort (gas) of $726764$ while at $m=1$ it requires $400517$, both 
Increasing to $m=2$ however times out after several minutes.
In constrast Demand $m$-CFA over the $1376$ eval queries given the same amount of overall gas as
exhaustive CFA could use $291$ gas per query at $m=1$. 
While this doesn't get all the information as the respective exhaustive CFA 
we see that over 60% of the information could be gained at a cost of $10$ per query (over $29x$ faster than exhaustive CFA).

Additionally we can get 75% of the information at a higher context sensitivity within a cost of $100$ even though
exhaustive CFA doesn't finish in reasonable time.


\begin{figure}[t]
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_legendx.png}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_blur.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_eta.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_kcfa2.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_kcfa3.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_loop2.pdf}
\end{subfigure} 
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_mj09.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_primtest.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_regex.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_rsa.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_sat.pdf}
\end{subfigure}
\begin{subfigure}[t]{.23\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_scheme2java.pdf}
\end{subfigure}
\caption{The number of interesting results returned compared to exhasutive analysis}
\label{fig:dmcfa-answers}
\end{figure}

What fraction of the collected data represents highly useful data (singleton flow sets) 
which can be used for higher order function inlining or constant propagation / evaluation?
Figure~\ref{fig:dmcfa-answers}.


@omit{

      We included in our benchmarks common R6RS benchmarks, as well as a larger example \texttt{tic-tac-toe} which 
      computes the minimax algorithm for an AI to play \texttt{tic-tac-toe}, and extensively uses matching, custom datatypes and higher-order behavior.

      We evaluate Demand $m$-CFA with respect to the following questions:
      \begin{enumerate}
      \item Is the implementation cost of Demand $m$-CFA comparable to an exhaustive analysis?
      \item Is Demand $m$-CFA \emph{demand-scalable}?
      \item How does the precision compare to an exhaustive $m$-CFA?
      \end{enumerate}

      To answer (1) we discuss our observations about implementing both in the same ADI style framework, including the difference in lines of code for the core algorithms.
      For (2) we consider Demand $m$-CFA what fractions of evaluation queries with a cutoff of 5ms from $m$=0 up to $m$=4 return an answer for a variety of program sizes.
      Finally to answer (3) we determine what percentage of singleton flow sets as compared to the corresponding exhaustive analysis we obtain within our budget of 5ms per query.

      \subsection{Implementation Costs}
      In an exhaustive CFA the developer chooses an abstraction and an analysis technique prior to implementation. 
      If any primitive is not supported or any source code is not available (i.e. external libraries), the developer must make a hard choice. 
      They must approximate the behavior or throw away the results of the analysis. 
      It is hard to guarantee the soundness of such an analysis. 
      As languages evolve and add new features and primitives, maintaining and evolving the corresponding analyses becomes both a burden and a source of bugs.

      In contrast Demand $m$-CFA is formulated such that the analysis of each language feature is specified independently as much as possible.
      Due to this design the implementation of an analysis should work transparently across language versions as long as 
      \begin{enumerate*} \item the semantics of each implemented feature and its dependencies does not change, and 
      \item the abstraction does not need to change \end{enumerate*}.

      For example, we did not implement the \texttt{set!} form of R6RS Scheme which mutates the binding of a given variable, and we did not implement primitives with side effects. 
      This omission does \emph{not} mean that demand CFA fails on programs that uses \texttt{set!}.
      Rather, it means that demand CFA fails on \emph{queries} whose resolution depends on a \texttt{set!}'d variable; other queries resolve without issue.
      Because the use of mutation is relatively rare in functional languages such as Scheme, ML, and OCaml, we expect that relatively few queries encounter mutation.


      Concretely, in terms of lines of code needed, our implementation suggests that a demand analysis involves 
      about the same order of magnitude of engineering effort as $m$-CFA (${\sim}$660 lines of code versus ${\sim}$430).
      However, for programs with unsupported features or unimplemented primitives, our implementation of $m$-CFA fails to give any results 
      but our implementation of Demand $m$-CFA gives correct answers for a subset of the queries.

      This answers the first question that Demand $m$-CFA requires a comparable implementation effort to an exhaustive analysis,
      and in particular when considering the number of primitives and language features that modern languages afford.

      \begin{figure}
      \includegraphics[width=1\textwidth]{mcfa.pdf}
      \caption{The scalability of $m$-CFA in practice on simple benchmarks with size of the program (in parethesis) and as we increase $m$}
      \label{fig:mcfa-scalability}
      \end{figure}

      \subsection{Scalability}
      Monolithic analyses such as $m$-CFA require doing an abstract interpretation over the full program. Therefore to discuss scalability of such analyses 
      we typically determine the computational complexity in terms of the program size. 
      0CFA has a complexity of $O(n^3)$@~cite{dvanhorn:Neilson:1999}, and $k$-CFA is proven to be exponential@~cite{dvanhorn:VanHorn-Mairson:ICFP08}. 
      $m$-CFA (with rebinding) has the advantage is that it gives context sensitivity at a polynomial complexity@~cite{dvanhorn:Might2010Resolving}. 
      However, even with small programs it quickly becomes expensive as shown in Figure~\ref{fig:mcfa-scalability}.

      In our results we measure the size of the program as the number of non-trivial syntactic contexts that we could run an evaluation query for, 
      which is closely related to the size of the abstract syntax tree of the program. 
      Trivial queries include lambdas, constants, and references to let bindings that are themselves trivial. 
      These were all omitted from the results unless otherwise stated to determine how Demand $m$-CFA performs in contexts where compiler heuristics would not already trivially understand the control flow.

      Demand $m$-CFA has two sources of inherent overhead compared to a monolithic analysis. These are:
      \begin{enumerate*}
      \item resolving trace queries in addition to evaluation queries, and
      \item instantiating environments.
      \end{enumerate*}

      \begin{figure}
      \includegraphics[width=1\textwidth]{dmcfa.pdf}
      \caption{The percent of answers that Demand $m$-CFA answers based on a 5ms timeout per query. This graph shows all queries (including trivial ones).}
      \label{fig:dmcfa-scalability}
      \end{figure}

      \begin{figure}[b]
      \includegraphics[width=1\textwidth]{dmcfa-noninstant.pdf}
      \caption{The percent of non-trivial queries that Demand $m$-CFA answers using a 5ms/query timeout.}
      \label{fig:dmcfa-scalability-noninstant}
      \end{figure}

      These apparent disadvantages work to the benefit of Demand $m$-CFA in practice. For example, indeterminate queries allow the analysis to disregard exponential combinations of environments when
      it is irrelevant to a particular query. In particular we have observed this behavior in the \textsf{sat-2} benchmark, which induces 
      worst-case behavior in exponential $m$-CFA, due to the exponential combination of nested environments, but where Demand $m$-CFA is able to keep the environments
      indeterminate for the majority of the queries.

      Before deciding to integrate an analysis into their language tooling engineers would like to know the cost benefit tradeoff.
      Theoretically Demand $m$-CFA presents both costs and benefits at a much more granular level which the compiler engineer can control, but how does that work in practice?
      To answer this we measure \begin{itemize} \item the percent of evaluation queries that return within a constant timeout (5ms) per query, 
      as well as \item the percent of singleton flows found as compoared to an exponential $m$-CFA analysis (without rebinding). \end{itemize}
      We choose exponential $m$-CFA to be able to compare singleton flows against a monolithic analysis
      with similar environment representation --- which should return similar if not identical results. 
      The only thing that makes Demand $m$-CFA's environments different from exponential $m$-CFA's environments is that the latter do not contain
      indeterminate environments.

      As seen in Figure~\ref{fig:dmcfa-scalability}, we answer a large majority of all evaluation queries within the specified timeout. 
      When we restrict it to non-trivial queries we get the results in Figure~\ref{fig:dmcfa-scalability-noninstant}, 
      which shows a predictable decrease due to the fact that many flows are lexically obvious (lambdas, constants, etc). 
      When compared to an exhaustive analysis which might timeout or fail, any amount of non-trivial flow at constant cost is welcomed.
      It is worth noting that increasing the timeout to 15ms only marginally improves the number of returned answers. 
      This matches the intuition that if a query only requires a subset of the entire flow of a program, it should be quick to answer. 
      Importantly we see that the size of the program does not seem to have a large effect on the tractability of the problem and neither does $m$. 
      This means that our Demand $m$-CFA analysis is indeed \emph{demand-scalable}, answering our second question.

      \begin{figure}
      \includegraphics[width=1\textwidth]{precision-cmp.pdf}
      \caption{Ratio of the \# singleton flow sets found by Demand $m$-CFA compared to exhaustive $m$-CFA.}
      \label{fig:dmcfa-precision-cmp}
      \end{figure}


      \begin{figure}[b]
      \includegraphics[width=1\textwidth]{precision.pdf}
      \caption{\# of singleton flow sets found by Demand $m$-CFA}
      \label{fig:dmcfa-precision}
      \end{figure}

      Figure~\ref{fig:dmcfa-precision-cmp} shows that in most cases we resolve much more than half the number 
      of singleton value flows as \emph{exponential} $m$-CFA, but in constant time\footnote{
      To compute flow sets we obtain all configurations that have the same evaluation configuration (without environments)
      and join the results (also without environments). 
      % The context sensitivity's purpose is to remove spurious singleton sets during the analysis, but not to distinguish results. 
      % In fact, in many cases Demand $m$-CFA returns closures with indeterminate environments, and upon closer inspection
      % we found that the exhaustive $m$-CFA counterpart had many singleton flow sets under different environments, 
      showing that it had to do more work to arrive at the same conclusion. 
      }. This means that not only is Demand $m$-CFA \emph{demand-scalable}, it also produces useful results.
      In a few cases we actually report more than $100\%$ of the equivalent singleton flow sets of exponential $m$-CFA.
      This is due to the fact that in a few instances Demand $m$-CFA evaluates queries even for parts of the program that are never seen in the
      exhaustive analysis.

      In Figure~\ref{fig:dmcfa-precision}, we show the total number of singleton flow sets found, however,
      we see that increasing $m$ does not seem to have the desired effect of increasing precision in many cases. 
      We attribute this partially to the fact that these benchmark programs are small. 
      The fact that we still get many results with high $m$ within the 5ms timeout shows the power of
      Demand $m$-CFA in allowing us to explore high $m$ at low cost. 
      Of particular note is the omission of regex in Figure~\ref{fig:dmcfa-precision}, this is due to
      exhaustive $m$-CFA not completing within a generous timeout of $100$ seconds for $m=4$ causing that ratio to be ill-defined. 
      The results are similar to the other large example programs, and Figure~\ref{fig:dmcfa-precision}
      shows that we resolve many singleton flows within the timeout period. 
      In some cases a larger $m$ actually shows a decrease in the number of singletons found. 
      In an exhaustive analysis this would be a red flag, due to the fact that the precision 
      of the results should monotonically increase with respect to $m$. 
      However, due to the fact that more configurations have to be evaluated when $m$ gets larger, 
      some queries which used to be resolved within a constant time can timeout as $m$ gets larger. 
      So this behavior is expected in a Demand analysis, and it is remarkable that we don't lose more singletons to timeouts.  

      \subsection{Limitations and Future Work}
      These results are most limited with respect to the benchmark sizes. 
      We intend on scaling up Demand $m$-CFA to handle a full language and larger benchmarks to assuage these concerns.
      In the meantime we appeal to the intuition of the reader about singleton flow sets. 
      The very nature of singleton flows mean they do not become highly entangled with other differentiated flows. 
      Call-site sensitivity (such as the $m$-CFA abstraction) can help tease apart distinguished flow sets which originate from different call sites.
      With supporting evidence from our larger benchmarks we believe our approch will scale to larger programs.

      Additionally Demand $m$-CFA makes reachability assumptions which can, decrease its precision.
      For instance, if Demand $m$-CFA is tracing the caller of \texttt{f} in the expression \texttt{(λ (g) (f 42))} so that it can evaluate the argument,
      it assumes that \texttt{(f 42)} is reachable---i.e., it assumes that \texttt{(λ (g) (f 42))} is called.
      If that assumption is false, then the argument \texttt{42} does not actually contribute to the value that Demand $m$-CFA is resolving, 
      and its inclusion is manifest imprecision.
      We believe this to be the case for several of the benchmarks. 
      Determining callers prior to evaluating would cause the indeterminate environment to be instantiated which could counteract the
      benefit of keeping the environments mostly indeterminate, and a more nuanced approach is left to future work. 

      Some aspects of programs, such as the use of dynamic features, inherently limit the information that can be obtained statically.
      Defensive analysis@~cite{smaragdakis2018defensive} provides both a result and an indicator of whether that result is sound for every execution environment.
      Demand CFA is already defensive in a sense: query resolution fails when it encounters an unsupported language feature.
      However, integrating defensive analysis would require it to be more principled about its reachability assumptions and the status of its results.

      Future work should investigate interesting tradeoffs exposed by Demand $m$-CFA's cost model. This includes:
      \begin{enumerate*}
      \item exploring other criteria for terminating queries early,
      \item beginning with $m=0$, rerun queries with higher $m$ only as needed.
      \end{enumerate*}

      Beyond exploring the tradeoffs and implications of the cost model, future work is also needed to:
      \begin{enumerate*}
      \item develop theories for common language features such as mutation and higher order control flow such as exceptions and continuations,
      \item evaluate Demand $m$-CFA for practical usage in language servers, optimizing compilers, and other analyses, and
      \item consider how selective context sensitivity@~cite{li2020principled} could be realized given the indeterminate environments of our approach.
      \end{enumerate*}
}
\section{Related Work}
\label{sec:related-work}

The original inspiration for demand CFA is demand dataflow analysis@~cite{horwitz1995demand} which refers to dataflow analysis algorithms which allow selective, local, parsimonious analysis of first-order programs driven by the user.
Demand CFA refers to a class of algorithms with those same characteristics which operate in the presence of first-class functions.
This work extends Demand 0CFA@~cite{germane2019demand}, currently the sole embodiment of demand CFA, with context sensitivity using a context abstraction similar to that of $m$-CFA@~cite{dvanhorn:Might2010Resolving}.

The most-closely related work is that of @citet{schoepe2023lifting} which utilizes first-order solvers to construct call graphs on demand to effect higher-order analysis.
Although it treats control with context sensitivity, it does not model or track the environment structure of higher-order objects.
Our work has a similar goal---to achieve demand-driven analysis of higher-order programs---but it has sought to provide a concise analysis which models both the control and environment structure of evaluation with equal facility.

@;{
Most closely related is the technique developed in Lifting On-Demand Analysis to Higher-Order Languages.
The approach developed meets all of our criteria above, including context sensitivity, 
but relegates the context sensitivity to the underlying analyses, 
and requires multiple demand-driven analyses for the language in question. 
Our work differs in two major ways: first, it does not require the existence of pre-existing first-order demand-driven forward and backwards analyses, 
and second, it directly addresses context sensitivity of variables bound in higher order and nested lexical closure environments.
}

DDPA@~cite{palmer2016higher} is nominally a context-sensitive, demand-driven analysis for higher-order programs.
However, before resolving any on-demand queries, DDPA must bootstrap a global control-flow graph to support them.
Because of this large, fixed, up-front cost, 
DDPA does not provide the pricing model expected of a demand analysis.
@;and does not make the kinds of applications targeted by demand analysis practical.

Several other ``demand-driven'' analyses exist for functional programs.
@citet{midtgaard2008calculational} present a ``demand-driven 0-CFA'' derived via a calculational approach which analyzes only those parts of the program on which the program's result depends.
@citet{biswas1997demand} presents a demand analysis that takes a similar approach to ``demand-driven 0-CFA'' to analyze first-order functional programs.
These analyses are certainly ``demand-driven'' in the sense the authors intend, but not in the sense that we use it, as a descriptor for generic demand CFA.
Demand CFA can be considered a loose extension in spirit which analyzes only those parts of a \emph{higher-order} functional program on which \emph{a selected expression}'s result depends.

@citet{dvanhorn:heintze-mcallester-pldi97} describe the ``demand-driven'' subtransitive CFA which computes an underapproximation of control flow in linear time and can be transitively closed for an additional quadratic cost.
Their analysis exploits type structure and applies to typed programs with bounded type, whereas our formulation neither considers nor requires types.

\emph{Points-to} analysis is the analogue of CFA in an object-oriented setting in the sense that both are fundamental analyses that provide the necessary support for higher-level analysis.
Many context-sensitive demand-driven points-to analyses (e.g.~\citet{spath2016boomerang,lu2013incremental,su2014parallel,shang2012demand}) exist, formulated for Java.
Though both points-to analysis and CFA target higher-order programs, @citet{dvanhorn:Might2010Resolving} observed that
the explicit object creation in the object-oriented setting induces flat closures
whereas
implicit closure creation in the functional setting induces nested closures.
Moreover, mutation is routine in many object-oriented settings (e.g. Java) in which points-to analyses are expressed.
Both nested environments and the prevalence of immutable variables are fundamental to our realization of demand CFA.

{Pointer} analysis is the imperative analogue of control-flow analysis and it too enjoys a rich literature.
When function pointers are present, a demand-driven pointer analysis must be able to reconstruct the call graph on the fly, a requirement shared by demand-driven CFA.
%Higher-order values (such as closures) specify not just what code to execute but also what environment to execute it in.
%A context-sensitive demand-driven CFA then must take extreme care where a demand-driven pointer analysis has no such concerns.
%Pointer analysis is akin to demand 0CFA which behaves as though there is a single, flat environment over the program text 

@citet{heintze2001demand} present a demand-driven pointer analysis for C capable of constructing the call graph on the fly.
They recognize that most call targets are not specified indirectly through pointers and advocate demand-driven analysis to resolve indirect targets when they appear.
In the core language of demand $m$-CFA, calls with indirect targets are commonplace;
the language was chosen to emphasize those cases in particular.
In a full-featured language, calls with indirect targets---though still more common than in C---are less common, since calls to primitives are typically direct and statically discernible.
However, closures are not merely code pointers, but environments too, and we have had to exercise great care to ensure that demand $m$-CFA correctly models their behavior.

@citet{saha2005incremental} formulate points-to analysis of C as a logic program, so that the incremental-evaluation capabilities of the logic engine yield an incremental analysis.
They combine an incremental and demand-driven approach to update the points-to model in response to changes in the program.
Our work is similar in that it may be possible to cast it as a logic program and thereby combine an initial exhaustive CFA with an incremental, demand-driven CFA to keep the model synchronized with a changing program.

More recently, \citet{sui2016supa} developed \textsc{Supa}, an on-demand analyzer for C programs which refines value flows during analysis.
\textsc{Supa} is designed for low-budget environments and its evaluation explicitly weighs its ultimate precision against its initial budget.
Demand $m$-CFA can be positioned similarly where the low-budget environments are compilers and IDEs for functional programs.

\section{Conclusion}
\label{sec:conclusion}

This paper presented one strategy for achieving context-sensitive demand CFA, based on the top-$m$-stack-frames context abstraction of $m$-CFA@~cite{dvanhorn:Might2010Resolving}.
This strategy leads to the Demand $m$-CFA hierarchy which exhibits pushdown precision
(1) with respect to the demand semantics, by virtue of using the \emph{Abstracting Definitional Interpreters}@~cite{darais2017abstracting} implementation approach, and
(2) with respect to the direct semantics, by virtue of using the continuation address identified in \emph{Pushdown for Free}@~cite{local:p4f}.
This leads to the Demand $m$-CFA hierarchy, which, for many singleton flow sets, offers the precision of context sensitivity at a constant price, regardless of program size, which we claim makes 
Demand $m$-CFA a \emph{demand-scalable} analysis.

\bibliographystyle{ACM-Reference-Format}
\bibliography{paper}

\end{document}
