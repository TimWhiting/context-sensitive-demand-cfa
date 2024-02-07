#lang scribble/text
@(require "base.rkt"
          "syntax.rkt"
          "bib.rkt"
          "mathpar.rkt")
@(define-syntax-rule (omit . rst) (void))
\documentclass[10pt,acmsmall,timestamp,screen,anonymous,review]{acmart}

\usepackage{mathpartir}
\usepackage{xcolor}
\definecolor{light-gray}{gray}{0.8}
\usepackage{tikz-cd}
\usepackage{textgreek}
\usepackage{wrapfig}
\usepackage{alltt}
\definecolor{codegreen}{rgb}{0,0.6,0} 
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}
\newcommand{\tw}[1]{\textcolor{blue}{(T: #1)}}
\newcommand{\todo}[1]{\textcolor{red}{(TODO: #1)}}
\newcommand{\TODO}[1]{{\color{red}#1}}

\acmJournal{PACMPL}
\acmVolume{POPL}
\acmYear{2021}
\citestyle{acmauthoryear}

\title{Context-Sensitive Demand-Driven Control-Flow Analysis}
\author{Tim Whiting}
\affiliation{Brigham Young University}
\author{Kimball Germane}
\affiliation{Brigham Young University}
\author{Jay McCarthy}
\affiliation{University of Massachusetts Lowell}

\acmConference[POPL '22]{Principles of Programming Languages}{January 17--22}{Philadelphia, Pennsylvania, USA}

% DON'T WRITE IT BEGGING TO GET IN
% WRITE IT SO THAT THEY WOULD BE FOOLISH NOT TO ACCEPT IT
% CONVINCE THEM THAT THIS WORK WILL BRING PRESTIGE TO THEIR CONFERENCE
% I.E.
% DON'T WRITE IT SO THAT THEY CAN ACCEPT IT
% WRITE IT SO THAT THEY CAN'T REJECT IT

% SHOW THEM THAT
% - IT'S USEFUL
% - IT'S DIFFICULT (so need some false starts, maybe)
% - YOU DID IT

% LOOK AT A REALLY WELL-WRITTEN PAPER AND TRY TO CHANNEL IT

\begin{abstract}
By decoupling and decomposing control flows, demand control-flow analysis (CFA) is able to resolve only those segments of flows it determines necessary to resolve a given query.
Thus, it presents a much more flexible interface and pricing model to CFA, making many useful applications practical.
At present, however, the only realization of demand CFA is demand 0CFA, which is context-insensitive.
This paper presents two strategies for achieving context-sensitive demand CFA, each of which induces a hierarchy of CFA.
The first is based on the top-$m$-stack-frames abstraction of $m$-CFA and induces Demand $m$-CFA.
The second exploits the ability of demand CFA to operate with reduced context knowledge and induces Lightweight Demand $m$-CFA.
We evaluate both, finding that Lightweight Demand $m$-CFA in some cases offers, strikingly, the precision of context sensitivity at the price of context insensitivity.
\end{abstract}

@(define (clause-label label) (list "\\textit{" label "}"))


\begin{document}
\def\labelitemi{\normalfont\bfseries{--}}
\def\labelitemii{\(\ast\)}
\def\labelitemiii{\(\cdot\)}

\maketitle

\section{Getting into the Flow}

Conventional control-flow analysis is tactless---unthinking and inconsiderate.

To illustrate, consider the program fragment on the right which defines the recursive \texttt{fold} function.
As this function iterates, it evolves the index \texttt{n} by \texttt{f} and the accumulator \texttt{a} by \texttt{g}, all arguments
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
to \texttt{fold} itself.
The values of \texttt{f} and \texttt{g} flow in parallel within the fold itself, each
(1)~being bound in the initial call,
(2)~flowing to its corresponding parameter, and
(3)~being called directly once per iteration.
But their flows don't completely overlap:
\texttt{f}'s value's flow begins at \texttt{sub1} whereas \texttt{g}'s value's continues at \texttt{h}
and
\texttt{f}'s value's flow branches into the call to \texttt{g}.

\tw{Update references to lightweight to change to a new name}
\tw{Improve related work section here}

Now consider a tool focused on the call \texttt{(f n)} and seeking the value of \texttt{f} in order to, say, expand \texttt{f} inline.
Only the three flow segments identified above respective to \texttt{f} are needed to fully determine this value---and know that it is fully-determined.
Yet conventional control-flow analysis (CFA) is \emph{exhaustive}, insistent on determining every segment of every flow, starting from the program's entry point.\footnote{Exhaustive CFA can be made to work with program components where free variables are treated specially (e.g. using Shivers' escape technique@~cite["Ch. 3"]{dvanhorn:Shivers:1991:CFA}). This special treatment does not change the fundamental \emph{exhaustive} nature of the analysis nor bridge the shortcomings we describe.}
In the account it produces, the segmentation of individual flows and independence of distinct flows are completely implicit.
To obtain \texttt{f}'s value with a conventional CFA, the user must be willing to pay for \texttt{g}'s---and any other values incidental to it---as well.

Inspired by demand dataflow analysis@~cite{duesterwald1997practical}, a \emph{demand} CFA does not determine every segment to every flow but only those segments which contribute to the values of user-specified program points.
Moreover, because its segmentation of flows is explicit, it need analyze each segment only once and can reuse the result in any flow which contains the segment.
In this example, a supporting demand CFA would work backwards from the reference to \texttt{f} to determine its value, and would consider only the three flow segments identified above to do so.

The interface and pricing model demand analysis offers---and exhibited by demand CFA---make many useful applications practical.
@citet{horwitz1995demand} identify several ways this practicality is realized:
First, one can restrict analysis to a program's critical path or only where certain features are used.
Second, one can analyze more or more often, and interleave analysis with other tools.
For example, a demand analysis does not need to worry about optimizing transformations invalidating analysis results since one can simply re-analyze the transformed points.
Finally, one can let a user drive the analysis, even interactively, to enhance, e.g., an IDE experience.

Presently, the only realization of demand CFA is Demand 0CFA@~cite{germane2019demand} which is context-\emph{insensitive}.
(We offer some intuition about Demand 0CFA's operation in \S~\ref{sec:intuition} and review it in \S~\ref{sec:demand-0cfa}.)
However, the benefits to a context-\emph{sensitive} demand CFA are clear.
A demand CFA would enjoy increased precision and also, in some cases, a reduced workload (which we discuss at an intuitive level in \S~\ref{sec:intuition}).
The primary difficulty is to determine control flow about an arbitrary program point, in an arbitrary context.
Thus, the task of a context-sensitive demand CFA is not only to correctly maintain the context but to \emph{discover} the contexts in which evaluation occurs.
To achieve this requires a compatible choice of context, context representation, and even environment representation, as we discuss in \S~\ref{sec:progression}.

After surmounting these issues, we arrive at Demand $m$-CFA (\S~\ref{sec:demand-mcfa}), a hierarchy of demand CFA that exhibits context sensitivity.
At a high level, Demand $m$-CFA achieves context sensitivity by permitting indeterminate contexts, which stand for any context, and instantiating them when further information is discovered.
It then uses instantiated contexts to filter its resolution of control flow to ensure that its view of evaluation remains consistent with respect to context.
(We offer intution about these operations in \S~\ref{sec:intuition} as well.)
Demand $m$-CFA is sound with respect to a concrete albeit demand-driven semantics called \emph{demand evaluation} (\S~\ref{sec:demand-mcfa-correctness}), which is itself sound with respect to a standard call-by-value semantics.

Demand $m$-CFA is comprehensive in the sense that it discovers all contexts to the extent necessary for evaluation.
It achieves this by carefully ensuring at certain points that it proceeds only when the context is known, even if it isn't strictly necessary to produce a value.
\emph{Lightweight Demand $m$-CFA} (\S~\ref{sec:lightweight-demand-mcfa}) is an alternative approach to achieving a context-sensitive demand CFA which relies on the ability of a demand CFA to resolve control-flow just-in-time.
We find this disposition toward analysis fairly effective:
in some cases, it produces effectively-exhaustive, identically-precise results as an exhaustive analysis at the same level of context sensitivity but \emph{several orders of magnitude faster}.

Although Demand $m$-CFA requires a fair amount of technical machinery to formulate, its implementation is very straightforward using the \emph{Abstracting Definitional Interpreters} (ADI) technique@~cite{darais2017abstracting}.
To illustrate its directness, we reproduce and discuss the core of Demand $m$-CFA's implementation in \S~\ref{sec:implementation}.
One virtue of using the ADI approach is that it endows the implemented analyzer with ``pushdown precision'' with respect to the reference semantics---which, for our analyzer, are the demand semantics.
However, as we discuss in \S~\ref{sec:implementation}, Demand $m$-CFA satisfies the \emph{Pushdown for Free} criteria@~cite{local:p4f} which ensures that it has pushdown precision with respect to the direct semantics as well.

TODO: THIS NEEDS TO BE UPDATED> THE MOST RECENT & CLOSELY RELATED WORK IS THE AMAZON PAPER
The concept of context-sensitive demand-driven CFA is also found in
Demand-Driven Program Analysis (DDPA)@~cite{palmer2016higher},
a higher-order program analysis which provides a dataflow ``lookup'' facility.
However, DDPA's lookup facility depends on a global control-flow graph which it must bootstrap before it can resolve general dataflow queries;
consequently, it is not suitable for the same applications of demand analysis as we have described it.

%\subsection{Contributions}

This paper makes the following contributions:
\begin{itemize}
\item a new formalism for Demand 0CFA which can be implemented straightforwardly using contemporary techniques@~cite{darais2017abstracting,wei2018refunctionalization} (\S~\ref{sec:demand-0cfa});
\item Demand $m$-CFA (\S~\ref{sec:demand-mcfa}), a hierarchy of context-sensitive demand CFA and a proof of its soundness (\S~\ref{sec:demand-mcfa-correctness});
\item Lightweight Demand $m$-CFA, a hierarchy of demand CFAs using a different approach to achieving context sensitivity;
\item an empirical evalution of Demand 0CFA to demonstrate that it is a genuine demand CFA; and
\item an empirical evaluation of (Lightweight) Demand $m$-CFA against $m$-CFA@~cite{dvanhorn:Might2010Resolving}.
\end{itemize}



\section{Demand CFA, Intuitively}
\label{sec:intuition}

A user interacts with demand CFA by submitting queries, which the analyzer resolves online.
There are two types of queries:
An \emph{evaluation} query yields the values to which a specified expression may evaluate.
A \emph{trace} query yields the sites at which the value of a specified expression may be called.
Some queries are trivially resolved, such as those for the value of a constructor application.
Typically, however, the control flow within a query depends on adjacent flows, for which the analyzer issues subqueries.

We illustrate the operation of a demand CFA considering queries over the program
\begin{verbatim}
(let ([f (λ (x) x)]) (+ (f 42) (f 35)))
\end{verbatim}
which is written in an applicative functional language with Lisp syntax.

@(define (evq e) (list "\\textsf{evaluate}\\," "\\texttt{" e  "}"))
@(define (exq e) (list "\\textsf{trace}\\," "\\texttt{" e  "}"))
@(define (caq e) (list "\\textsf{caller}\\," "\\texttt{" e  "}"))
\setlength\intextsep{0pt}

\subsection{Without Context Sensitivity}

As many readers are likely unfamiliar with demand CFA, we'll first look at how demand 0CFA, the context-\emph{in}sensitive embodiment of demand CFA, resolves queries.

\begin{wrapfigure}{l}{0.35\textwidth}
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

Suppose that a user submits an evaluation query $q_0$ on the expression \texttt{(f 35)}.
Since \texttt{(f 35)} is a function application, demand 0CFA issues a subquery $q_1$ to evaluate the operator \texttt{f}.
For each procedure value of \texttt{f}, demand 0CFA will issue a subquery to determine the value of its body as the value of $q_0$.
(To the left is a trace of the queries that follow $q_0$.
    Indented queries denote subqueries whose results are used to continue resolution of the superquery.
    A subsequent query at the same indentation level is a query in ``tail position'', whose results are those of a preceding query.
    A query often issues multiple queries in tail position, as this example demonstrates.)
The operator \texttt{f} is a reference, so demand 0CFA walks the syntax to find where \texttt{f} is bound.
Upon finding it bound by a \texttt{let} expression, demand 0CFA issues a subquery $q_2$ to evaluate its bound expression \texttt{(λ (x) x)}.
The expression \texttt{(λ (x) x)} is a $\lambda$ term---a value---which $q_2$ propagates directly to $q_1$.
Once $q_1$ receives it, demand 0CFA issues a subquery $q_3$ for the evaluation of its body.
Its body \texttt{x} is a reference, so demand 0CFA walks the syntax to discover that it is $\lambda$-bound and therefore that its value is the value of the argument at the application of \texttt{(λ (x) x)}.
That this call to \texttt{(λ (x) x)} originated at \texttt{(f 35)} is contextual information, to which demand 0CFA is insensitive.
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


\begin{wrapfigure}{r}{0.42\textwidth}
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
If so, $q_3'$ forwards the result to $q_3$; if not, it cuts off the resolution process for that path.
In this case, $q_5$'s result \texttt{(f 42)} isn't compatible with $q_3'$, and Demand $m$-CFA ceases resolving it rather than issuing $q_7$.
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
locates the call sites \texttt{(f 42)} \textsf{in} $\langle\rangle$ and \texttt{(f 35)} \textsf{in} $\langle\rangle$
Once $q_2$ delivers the result \texttt{(f 42)} \textsf{in} $\langle\rangle$ to $q_1$ and then $q_0'$, Demand $m$-CFA \emph{instantiates} $q_0$ with this newly-discovered caller to form $q_4$, whose result is $q_0$'s also.
After creating $q_3$, it continues with its resolution by issuing $q_4$ to evaluate the argument \texttt{42} \textsf{in} $\langle\rangle$.
Its result of $42$ propagates from $q_4$ to $q_3$ to $q_0$;
from $q_0$, one can see all instantiations of it as well every result of those instantiations.
The instantiation from $q_3$ proceeds similarly.

\section{Language and Notation}
\label{sec:notation}

In order to keep otherwise-identical expressions distinct, many presentations of CFA uniquely label program sub-expressions.\footnote{Others operate over a form which itself names all intermediate results, such as CPS or $\mathcal{A}$-normal form, and identify each expression by its associated (unique) name.}
This approach would be used, for example, to disambiguate the two references to \texttt{f} in the program in \S~\ref{sec:intuition}.
Demand $m$-CFA extensively consults the syntactic context of each expression, which uniquely determines it, and uses it as a de facto label.

The syntactic context @(meta "C" #f) of an instance of an expression @(e) within a program $\mathit{pr}$ is $\mathit{pr}$ itself with a hole @|□| in place of the selected instance of @(e).
For example, the program @(lam (var 'x) (app (ref (var 'x)) (ref (var 'x)))) contains two references to @(var 'x),
one with syntactic context @(lam (var 'x) (app □ (ref (var 'x))))
and the other with @(lam (var 'x) (app (ref (var 'x)) □)).

In the unary $\lambda$ calculus,
expressions @(e) adhere to the grammar on the left
and
syntactic contexts @(meta "C" #f) adhere to the grammar on the right.
\begin{align*}
@(e) & ::= @(ref (var 'x)) \,|\, @(lam (var 'x) (e)) \,|\, @(app (e) (e))
&
@(meta "C" #f) & ::= @(lam (var 'x) (meta "C" #f)) \,|\, @(app (meta "C" #f) (e)) \,|\, @(app (e) (meta "C" #f)) \,|\, @|□|.
\end{align*}

\tw{Should we extend the language grammar to include primitives, constructors, letrec, and match, or just add the rules?}

The composition @(cursor (e) (∘e)) of a syntactic context @(meta "C" #f) with an expression @(e) consists of @(meta "C" #f) with @|□| replaced by @(e).
In other words, @(cursor (e) (∘e)) denotes the program itself but with a focus on @(e).
For example, we focus on the reference to @(var 'x) in operator position in the program @(lam (var 'x) (app (ref (var 'x)) (ref (var 'x)))) with @(cursor (ref (var 'x)) (rat (ref (var 'x)) (bod (var 'x) (top)))).

We typically leave the context unspecified, referring to, e.g., a reference to @(var 'x) by @(cursor (ref (var 'x)) (∘e)) and two distinct references to @(var 'x) by @(cursor (ref (var 'x)) (∘e 0)) and @(cursor (ref (var 'x)) (∘e 1)) (where $@((∘e 0) #f) \ne @((∘e 1) #f)$).
The immediate syntactic context of an expression is often relevant, however, and we make it explicit by a double composition @(cursor (cursor (e) (∘e 1)) (∘e 0)).
For example, we use @(cursor (ref (var 'x)) (rat (ref (var 'x)) (∘e))) to focus on the expression @(ref (var 'x)) in the operator context @(app □ (ref (var 'x))) in the context @(meta "C" #f).

@omit{
\tw{Additional contexts include (let-bin ...) for letrec-bindings (let-bod ...) for let bodies, (match-expr ...) for match discriminators and (match-clause i ...) for the i'th match clauses}
\tw{We also need a pattern grammar}
\begin{align*}
@(p) & ::= @(literal) \,|\, @(var 'x) \,|\, @(con-pattern)
\end{align*}
}

\section{Demand 0CFA}
\label{sec:demand-0cfa}

@(require (prefix-in 0cfa- "demand-0cfa.rkt"))

Demand 0CFA has two modes of operation, \emph{evaluation} and \emph{tracing}, which users access by submitting evaluation or trace queries, respectively.
A query, in addition to its type, designates a program expression over which the query should be resolved.
An evaluation query resolves the values to which the designated expression may evaluate and a trace query resolves the sites which may apply the value of the designated expression.
These modes are essentially dual and reflect the dual perspective of exhaustive CFA as either
(1) the @(lam (var 'x) (e)) which may be applied at a given site @(app (e 0) (e 1)), or
(2) the @(app (e 0) (e 1)) at which a given @(lam (var 'x) (e)) may be applied. % [find citation].
However, in contrast to exhaustive CFA, demand 0CFA is designed to resolve evaluation queries over arbitrary program expressions.
(It is also able to resolve trace queries over arbitrary program expressions, but exhaustive CFAs have no counterpart to this functionality.)

The evaluation and trace modes of operation are effected by the big-step relations @|0cfa-eval-name| and @|0cfa-expr-name|, respectively, which are defined mutually inductively.
These relations are supported by auxiliary relations @|0cfa-call-name| and @|0cfa-find-name|.
Figure~\ref{fig:demand-0cfa} presents the definitions of all of these relations.
\begin{figure}
@mathpar[0cfa-parse-judgement]{
Lam
———
C[λx.e] ⇓ C[λx.e]

App
C[([e₀] e₁)] ⇓ C'[λx.e]  C'[λx.[e]] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]
———
C[(e₀ e₁)] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]

Ref-Lam
C'[λx.e] = bind(x,C[x])  C'[λx.e] ⇐ C''[(e₀ e₁)]  C''[(e₀ [e₁])] ⇓ Cv[λy.e-v] / Cv[c] / Cv[i]
———
C[x] ⇓ Cv[λy.e-v] / Cv[c] / Cv[i]

Ref-LetBod
C'[(let (x e₀) [e₁])] = bind(x,C[x])  C'[(let (x [e₀]) e₁)] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]
———
C[x] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]

Ref-LetRec
C'[(letrec (x [e₀]) e₁)] = bind(x,C[x])  C'[(letrec (x [e₀]) e₁)] ⇓ Cv[λx.e-v]
———
C[x] ⇓ Cv[λx.e-v]

Ref-LetRec-Bod
C'[(letrec (x e₀) [e₁])] = bind(x,C[x])  C'[(letrec (x [e₀]) e₁)] ⇓ Cv[λx.e-v]
———
C[x] ⇓ Cv[λx.e-v]

LetRec
C[(letboth (x e₀) [e₁])] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]
———
C[(letboth (x e₀) e₁)] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]

Match
C[(match [e-s] ... (p-n e-n) ...)] ⇓ Cv[λx.e-s] / Cv[c-s] / Cv[i-s]  Cv[λx.e-s] / Cv[c-s] / Cv[i-s] matches! p-(0..n)  Cv[λx.e-s] / Cv[c-s] / Cv[i-s] matches p-n  C[(match e-s ... (p-n [e-n]) ...)] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]
———
C[(match e-s ... (p-n e-n) ...)] ⇓ Cv[λx.e-v] / Cv[c] / Cv[i]

}
\caption{Demand 0CFA Eval relation}
\label{fig:demand-0cfa}
\end{figure}

\begin{figure}
@mathpar[0cfa-parse-judgement]{
Rator
——
C[([e₀] e₁)] ⇒ C[(e₀ e₁)]

Bod
C[λx.[e]] ⇐ C'[(e₀ e₁)]  C'[(e₀ e₁)] ⇒ C''[(e₂ e₃)] 
——
C[λx.[e]] ⇒ C''[(e₂ e₃)] 

Bod-Let
C[(letboth (x e₀) e₁)] ⇒ C'[(e₀ e₁)]
——
C[(letboth (x e₀) [e₁])] ⇒ C'[(e₀ e₁)]

Bin-FindBod
x C[(letboth (x e₀) [e₁])] F Cx[x]  Cx[x] ⇒ C'[(e₂ e₃)] 
——
C[(letboth (x [e₀]) e₁)] ⇒ C'[(e₂ e₃)] 

Bin-FindBin-LetRec
x C[(letrec (x [e₀]) e₁)] F Cx[x]  Cx[x] ⇒ C'[(e₂ e₃)] 
——
C[(letrec (x [e₀]) e₁)] ⇒ C'[(e₂ e₃)] 

Rand
C[([e₀] e₁)] ⇓ C'[λx.e]  x C'[λx.[e]] F Cx[x]  Cx[x] ⇒ C'[(e₂ e₃)] 
——
C[(e₀ [e₁])] ⇒ C'[(e₂ e₃)]


Call
C[λx.e] ⇒ C'[(e₀ e₁)] 
———
C[λx.[e]] ⇐ C'[(e₀ e₁)]

}
\caption{Demand 0CFA Expr / Call relations}
\label{fig:demand-0cfa-expr-call}
\end{figure}

\begin{figure}
@mathpar[0cfa-parse-judgement]{
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

Find-Let-Binding
x ≠ y  x C[(letboth (x [e₀]) e₁)] F Cx[x]
——
x C[(letboth (x e₀) e₁)] F Cx[x]

Find-Let-Body
x ≠ y  x C[(letboth (x e₀) [e₁])] F Cx[x]
——
x C[(letboth (x e₀) e₁)] F Cx[x]

Find-Body
x ≠ y  x C[λy.[e]] F Cx[x]
——
x C[λy.e] F Cx[x]

}
\caption{Demand 0CFA Find relation}
\label{fig:demand-0cfa-find}
\end{figure}


The judgement @(0cfa-eval (cursor (e) (∘e)) (cursor (lam (var 'x) (e "_v")) (∘e "_v"))) denotes that the expression @(e) (residing in syntactic context @((∘e) #f)) evaluates to (a closure over) @(lam (var 'x) (e "_v")).
(In a context-insensitive analysis, we may represent a closure by the $\lambda$ term itself.) 
Demand 0CFA arrives at such a judgement, as an interpreter does, by considering the type of expression being evaluated.
The @clause-label{Lam} rule captures the intuition that a $\lambda$ term immediately evaluates to itself.
The @clause-label{App} rule captures the intuition that an application evaluates to whatever the body of its operator does.
Hence, if the operator @(e 0) evaluates to @(lam (var 'x) (e)), and @(e) evaluates to @(lam (var 'y) (e "_v")), then the application @(app (e 0) (e 1)) evaluates to @(lam (var 'y) (e "_v")) as well.
Notice that the @clause-label{App} does not evaluate the argument;
if the argument is needed, indicated by a reference to the operator's parameter @(var 'x) during evaluation of its body, the @clause-label{Ref} rule obtains it.
The @clause-label{Ref} rule captures the intuition that a reference to a parameter @(var 'x) takes on the values of the arguments of each site at which the $\lambda$ which binds @(var 'x) is called.
If the @|0cfa-bind-name| metafunction determines the binding configuration of @(var 'x)---i.e. the body of the $\lambda$ term which binds it---to be @(e),
@(app (e 0) (e 1)) is a caller of that $\lambda$ term, and
@(e 1) evaluates to @(lam (var 'y) (e "_v")), then
the reference to @(var 'x) evaluates to @(lam (var 'y) (e "_v")) as well.
The @|0cfa-bind-name| metafunction determines the binding configuration of @(var 'x) by walking outward on the syntax tree until it encounters @(var 'x)'s binder.
Figure~\ref{fig:0cfa-bind} presents its definition.

A judgement @(0cfa-call (cursor (e) (bod (var 'x) (∘e))) (cursor (app (e 0) (e 1)) (∘e "'"))) denotes that the application @(app (e 0) (e 1)) applies @(lam (var 'x) (e)), thereby binding @(var 'x).
Demand 0CFA arrives at this judgment by the @clause-label{Call} rule which uses the @|0cfa-expr-name| relation to determine it.
In demand 0CFA, this relation is only a thin wrapper over @|0cfa-expr-name|, but it becomes more involved in context-sensitive demand CFA.
We include it here for consistency.

A judgement @(0cfa-expr (cursor (e) (∘e)) (cursor (app (e 0) (e 1)) (∘e "'"))) denotes that value of the expression @(e) is applied at @(app (e 0) (e 1)).
Demand 0CFA arrives at such a judgement by considering the type of the syntactic context to which the value flows.
The @clause-label{Rator} rule captures the intuition that, if @(lam (var 'x) (e)) flows to ope\emph{rator} position @(e 0) of @(app (e 0) (e 1)), it is applied by @(app (e 0) (e 1)).
The @clause-label{Body} rule captures the intuition that if a value flows to the body of a $\lambda$ term, then it flows to each of its callers as well.
The @clause-label{Rand} rule captures the intuition that a value in ope\emph{rand} position is bound by the parameter of each operator value and hence to each reference to a parameter in the operator's body.
If the operator @(e "_f") evaluates to @(lam (var 'x) (e)), then the value of @(e "_a") flows to each reference to @(var 'x) in @(e).

The @|0cfa-find-name| relation associates a variable @(var 'x) and expression @(e) with each reference to @(var 'x) in @(e).
@clause-label{Find-Ref} finds @(e) itself if @(e) is a reference to @(var 'x).
@clause-label{Find-Rator} and @clause-label{Find-Rand} find references to @(var 'x) in @(app (e 0) (e 1)) by searching the ope\emph{rator} @(e 0) and ope\emph{rand} @(e 1), respectively.
@clause-label{Find-Body} finds references to @(var 'x) in @(lam (var 'x) (e)) taking care that @(≠ (var 'x) (var 'y)) so that it doesnt' find shadowed references.

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

\subsection{Reachability}
\label{sec:reachability}

All but the most na\"ive exhaustive CFAs compute reachability at the same time as control flow.
For instance, when analyzing the program @(app (lam (var 'x) (lam (var 'y) (ref (var 'x)))) (lam (var 'z) (ref (var 'z)))),
such CFAs do not evaluate the reference @(ref (var 'x)) as it occurs in @(lam (var 'y) (ref (var 'x))) which is never applied.

Demand 0CFA, however, considers reachability not for the sake of control but for data.
In this example, the caller of @(lam (var 'y) (ref (var 'x))) is not needed for evaluation of @(ref (var 'x)), so demand 0CFA remains oblivious to the fact that @(lam (var 'y) (ref (var 'x))) is never called.
If, however, the reference @(ref (var 'x)) were replaced with @(ref (var 'y)) so that the program was @(app (lam (var 'x) (lam (var 'y) (ref (var 'x)))) (lam (var 'z) (ref (var 'z)))),
evaluation of @(ref (var 'y)) would depend on the caller of @(lam (var 'y) (ref (var 'y))).
Unable to find a caller in this case, demand 0CFA would report that @(ref (var 'y)) obtains no value.

By ignoring control that does not influence the sought-after data, Demand 0CFA avoids exploring each path which transported the data, instead relying on the discipline of lexical scope to correspond binding and use.
This policy does mean that Demand 0CFA sometimes analyzes dead code as if it were live.
From a practical standpoint, this is harmless, since any conclusion about genuinely dead code is vacuously true.
However, it is possible for Demand 0CFA to include, e.g., dead references in its trace of a value via a binding, which potentially compromises precision.
We empirically investigate the extent to which precision is compromised in \S~\ref{sec:evaluation}.



\section{Adding Context Sensitivity}
\label{sec:progression}

A context-\emph{insensitive} CFA is characterized by each program variable having a single entry in the store, shared by all bindings to it.
A context-sensitive CFA considers the context in which each variable is bound and requires only bindings made in the same context to share a store entry.
By extension, a context-sensitive CFA evaluates an expression under a particular environment, which identifies the context in which free variables within the expression are bound.
Together, an expression and its enclosing environment constitute a \emph{configuration}.\footnote{Configurations in exhaustive CFAs include a timestamp as well. We discuss its omission from demand CFA configurations in \S~\ref{sec:whence-timestamp}.}
In order to introduce context sensitivity to demand 0CFA, we extend @|0cfa-eval-name|, @|0cfa-expr-name|, and @|0cfa-call-name| to relate not just expressions to expressions, but configurations to configurations.
(Like Demand 0CFA, our context-sensitive demand CFA will not materialize the store in the semantics, but it can be recovered if desired.)

However, demand CFA differs from exhaustive CFA in that the precise environment in which an expression is evaluated or traced may not be completely determined.
That is, the context in which each environment variable is bound may not be known or known fully.
For instance,
users typically
want control-flow information about an expression which sound with respect to all its evaluations
and
so indicate in queries by leaving the environment completely indeterminate.
In this case, demand CFA should instantiate the environment (only) as necessary to distinguish evaluations in different contexts.
Demand CFA thus requires a choice of context, context representation, and environment representation that support its ability to do so.
In this section, we examine each of these choices in turn.

\subsection{Choosing the context}

To formulate context-sensitive demand CFA in the most general setting possible, we will avoid sensitivities to properties not present in our semantics, such as types.
In fact, if we wish to maintain our focus on an untyped $\lambda$ calculus, the most straightforward choice is call-site sensitivity.

The canonical call-site sensitivity is that of $k$-CFA@~cite{dvanhorn:Shivers:1991:CFA} which sensitizes each binding to the last $k$ call sites encountered in evaluation.
However, this form of call-site sensitivity appears to work against the parsimonious nature of demand CFA.
To make this concrete, consider that, in the fragment \texttt{(begin (f x) (g y))}, 
the binding of \texttt{g}'s parameter will in general depend on the particular calls made during the evaluation of \texttt{(f x)}.
If the value of \texttt{(f x)} is not otherwise demanded, this dependence provokes demand analysis solely to discover more of the context or requires that the portion of the context contributed by \texttt{(f x)} be left indeterminate, thereby sacrificing precision.

A more fitting call-site sensitivity would allow demand CFA to discover more of the context through its natural course of operation.
A natural fit, it turns out, is $m$-CFA's call-site sensitivity which models the top-$m$ stack frames.

\subsubsection{$m$-CFA's context abstraction}

The $m$-CFA hierarchy@~cite{dvanhorn:Might2010Resolving} is the result of an investigation into the polynomial character of $k$-CFA in an object-oriented setting versus its exponential character in a functional setting.
The crucial discovery of that investigation was that OO-oriented $k$-CFA induces flat environments whereas functional-oriented $k$-CFA induces nested environments.
Specifically, OO-oriented $k$-CFA re-binds object (closure) variables in the allocation context which collapses the exponential environment space to a polynomial size.
From this insight, they derived $m$-CFA which simulates the OO binding discipline even when analyzing functional programs;
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
It is important to keep in mind, however, that we do \emph{not} adopt its re-binding policy, which is the essence of $m$-CFA.

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

We devise a context represenation that captures this invariant.
A context @(intuit-cc "^m") representing $m$ stack frames is either
completely indeterminate,
a pair of a call @(cursor (app (e 0) (e 1)) (∘e)) and a context @(intuit-cc "^{m-1}") of $m-1$ frames, or
the stack bottom $()$ (which occurs at the top level of evaluation).
A context @(intuit-cc "^0") of zero frames (which is a different notion than the stack bottom) is simply the degenerate $\square$.
Formally, we have
\begin{align*}
\mathit{Context}_0 \ni @(intuit-cc "^0") &::= \square & \mathit{Context}_m \ni @(intuit-cc "^m") &::=\, ? \,|\, (@(cursor (app (e 0) (e 1)) (∘e)),@(intuit-cc "^{m-1}")) \,|\, ()
\end{align*}
With the context represenation chosen, we can now turn to the environment representation.


\subsection{More-Orderly Environments}
\label{sec:more-orderly}

In a lexically-scoped language, the environment at the reference \texttt{x} in the fragment
\begin{verbatim}
(define f (λ (x y) ... (λ (z) ... (λ (w) ... x ...) ...) ...))
\end{verbatim}
 contains bindings for \texttt{x}, \texttt{y}, \texttt{z}, and \texttt{w}.
Exhaustive CFAs typically model this environment as a finite map from variables to contexts (i.e., the type $\mathit{Var} \rightarrow \mathit{Context}$).
For instance, $k$-CFA uses this model with $\mathit{Binding} = \mathit{Contour}$ where a \emph{contour} $@(meta "c" #f) \in \mathit{Contour} = \mathit{Call}^{\le k}$ is the $k$-most-recent call sites encountered during evaluation
(and $\mathit{Call}$ is the set of call sites in the analyzed program).
$m$-CFA uses a similar representation, though its interpretation differs.
Hence, $k$-CFA models the environment at the reference \texttt{x} as
$[
\mathtt{x} \mapsto @(meta "c" 0),
\mathtt{y} \mapsto @(meta "c" 1),
\mathtt{z} \mapsto @(meta "c" 2),
\mathtt{w} \mapsto @(meta "c" 3)
]$
for some contours @(meta "c" 0), @(meta "c" 1), @(meta "c" 2), and @(meta "c" 3).

While this representation captures the structure necessary for $k$-CFA (or $m$-CFA), it does not capture all the structure present when environments are constructed and extended.
For example, some of the structure not captured is that variables bound in the same evaluation step (e.g., multiple parameters in the function call) always have the same binding context.
In our example, we will always have @(= (meta "c" 0) (meta "c" 1)).
In general, we can partition environment variables according to the evaluation step which bound them.
In our example, this partition is $\{ \{ \mathtt{x}, \mathtt{y} \}, \{ \mathtt{z} \}, \{ \mathtt{w} \} \}$.
When an environment is extended with a binding for a variable in a constituent set of that partition, it is extended with bindings for all variables in that set.

But there is even more structure to environments.
In a lexically-scoped language, there is only one order in which the environment is extended with variable bindings.
In our example, the environment at the reference \texttt{x} is always extended first with bindings for \texttt{x} and \texttt{y}, then with a binding for \texttt{z}, and finally with a binding for \texttt{w}.

This allows us to refactor the environment to $(\mathit{Var} \rightarrow \mathbb{N}) \times \mathit{Context}^{*}$,
a pair of a finite map and a sequence where the map associates variables to the index of their binding contexts in the sequence.
In our example, this representation of the environment is
$(
 [
  \texttt{x} \mapsto 2,
  \texttt{y} \mapsto 2,
  \texttt{z} \mapsto 1,
  \texttt{w} \mapsto 0
  ],
 \langle @(meta "c" 3), @(meta "c" 2), @(meta "c" 0) \rangle
 )$.

Finally, again due to lexical-scoping, the index of a variable's binding context is in fact its de Bruijn index, which is statically determined by the program syntax.
Hence, the map component is unnecessary and we can model environments as a sequence $\mathit{Context}^{*}$.
This representation discards none of the environment structure of $k$-CFA and captures more of the structure inherent in evaluation.

Given this environment representation, we make one final tweak to the definition of contexts:
we will qualify an indeterminate context $?$ with the parameter of the function whose context it represents, and assume programs are alphatized.\footnote{In practice, we use the syntactic context of the body instead of the parameter, which is unique even if the program isn't alphatized.}
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

First, it would trace \texttt{(λ (f) (λ (x) (f x)))} in $\langle\rangle$ through \texttt{apply} to the call sites \texttt{(apply add1)} in $\langle\rangle$ and \texttt{(apply sub1)} in $\langle\rangle$.
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

This policy is effective even when the result of the function doesn't depend on both values.
For instance, when Demand $m$-CFA evaluates \texttt{x} in \texttt{(λ (f) (λ (x) x))}, it must still determine the caller of \texttt{(λ (f) (λ (x) x))} to determine the downstream caller of \texttt{(λ (x) x)}.

\subsection{Whence the timestamp?}
\label{sec:whence-timestamp}

In addition to introducing environments, context-sensitivity also typically introduces ``timestamps'' which serve as snapshots of the context at each evaluation step.
For instance, the exemplary $k$-CFA evaluates \emph{configurations}, consisting of an expression, environment, and timestamp, to results.

With a top-$m$-stack-frames abstraction, the ``current context'' is simply the context of the variable(s) most recently bound in the environment.
Lexical scope makes identifying these variables easy as does our representation of the environment as a sequence of binding contexts for the context itself.
In other words, with such an abstraction, the environment uniquely determines the timestamp, and our configurations consisting of an expression paired with its environment can be viewed to include the timestamp as well.

With our context identified as well as its and the environment's representation, we are ready to define Demand $m$-CFA.


\section{Demand $m$-CFA}
\label{sec:demand-mcfa}

@(require (rename-in (prefix-in mcfa- "demand-mcfa.rkt")))

Demand $m$-CFA augments Demand 0CFA with environments and environment-instantiation mechanisms which together provide context sensitivity.
The addition of environments pervades @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-find-name| which are otherwise identical to their Demand 0CFA counterparts;
these enriched relations are presented in Figure~\ref{fig:mcfa-resolution}.
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

Bod
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
When a call is entered, which occurs in the @clause-label{App} and @clause-label{Rand} rules, a new environment is synthesized using the @|mcfa-time-succ-name| metafunction which determines the binding context of the call by
\[
@(mcfa-time-succ (cursor (app (e 0) (e 1)) (∘e)) (:: (mcfa-cc) (mcfa-ρ))) = \lfloor @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc)) \rfloor_m
\]
where $\lfloor\cdot\rfloor_{m}$ is defined
\begin{align*}
\lfloor @(mcfa-cc) \rfloor_0 = \square & & \lfloor ?_{@(var 'x)} \rfloor_m = ?_{@(var 'x)} & & \lfloor @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc)) \rfloor_m = @(:: (cursor (app (e 0) (e 1)) (∘e)) (list "\\lfloor " (mcfa-cc) "\\rfloor_{m-1}"))
\end{align*}
The @|mcfa-bind-name| metafunction, which locates the binding configuration of a variable reference, is lifted to accommodate environments as well;
its definition is presented in Figure~\ref{fig:mcfa-bind}.
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
However, the @|mcfa-call-name| relation changes substantially.

Now we are in a position to discuss the definition of @|mcfa-call-name|, presented in Figure~\ref{fig:mcfa-call-reachability}.
\begin{figure}
@mathpar[mcfa-parse-judgement]{
Known-Call
C[λx.e] ρ ⇒ C'[(e₀ e₁)] ρ'  ctx₁ := time-succ(C'[(e₀ e₁)],ρ')  ctx₁ = ctx₀
——
C[λx.[e]] ctx₀::ρ ⇐ C'[(e₀ e₁)] ρ'

Unknown-Call
C[λx.e] ρ ⇒ C'[(e₀ e₁)] ρ'  ctx₁ := time-succ(C'[(e₀ e₁)],ρ')  ctx₁ ⊏ ctx₀
——
ctx₀::ρ R ctx₁::ρ

}
\caption{Demand $m$-CFA Call Discovery}
\label{fig:mcfa-call-reachability}
\end{figure}
Unlike @|mcfa-eval-name| and @|mcfa-expr-name|, @|mcfa-call-name| is defined in terms of reachability.
The @clause-label{Known-Call} rule says that, if a caller query is reachable, the ensuing trace query of its enclosing $\lambda$ yields a caller, and the binding context of the call is the same as the caller query's,
the resultant caller of the trace query is also a result of the caller query.
The call is \emph{known} because the caller query has the context of the call already in its environment.
If @(≠ (mcfa-cc 1) (mcfa-cc 0)), however, then the result constitutes an \emph{unknown} caller.
In this case, @clause-label{Unknown-Call} considers whether @(mcfa-cc 1) refines @(mcfa-cc 0) in the sense that @(mcfa-cc 0) can be instantiated to form @(mcfa-cc 1).
Formally, the refinement relation $\sqsubset$ as the least relation satisfying
\begin{align*}
?_{@(cursor (e) (∘e))} \sqsubset @(:: (cursor (app (e 0) (e 1)) (∘e "'")) (mcfa-cc)) & & @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc 1)) \sqsubset @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc 0))\Longleftarrow @(mcfa-cc 1) \sqsubset @(mcfa-cc 0)
\end{align*}
If @(mcfa-cc 1) refines @(mcfa-cc 1), @clause-label{Unknown-Call} does not conclude a @|mcfa-call-name| judgement, but rather an \emph{instantiation} judgement @(mcfa-instantiation (:: (mcfa-cc 0) (mcfa-ρ)) (:: (mcfa-cc 1) (mcfa-ρ))) which denotes that \emph{any} environment @(:: (mcfa-cc 0) (mcfa-ρ)) may be instantiated to @(:: (mcfa-cc 1) (mcfa-ρ)).
It is by this instantiation that @clause-label{Known-Call} will be triggered.
When @(mcfa-cc 1) does not refine @(mcfa-cc 0), the resultant caller is ignore which, in effect, filters the callers to only those which are compatible and ensures that Demand $m$-CFA is indeed context-sensitive.

Figure~\ref{fig:demand-mcfa-instantiation} presents inference rules which propagates discovered instantiations.
\begin{figure}
@mathpar[mcfa-parse-judgement]{
Instantiate-Eval
ρ₀ R ρ₁  C[e] ρ[ρ₁/ρ₀] ⇓ Cv[λx.e] ρ-v
——
C[e] ρ ⇓ Cv[λx.e] ρ-v

Instantiate-Expr
ρ₀ R ρ₁  C[e] ρ[ρ₁/ρ₀] ⇒ C'[(e₀ e₁)] ρ'
——
C[e] ρ ⇒ C'[(e₀ e₁)] ρ'

Instantiate-Call
ρ₀ R ρ₁  C[e] ρ[ρ₁/ρ₀] ⇐ C'[(e₀ e₁)] ρ'
——
C[e] ρ ⇐ C'[(e₀ e₁)] ρ'

}
\caption{Demand $m$-CFA Instantiation}
\label{fig:demand-mcfa-instantiation}
\end{figure}
The @clause-label{Instantiate-Reachable-*} rules ensure that if a query of any kind is reachable, then its instantiation is too.
When an instantiation @(mcfa-instantiation (mcfa-ρ 0) (mcfa-ρ 1)) doesn't apply (so that @(mcfa-ρ) is unchanged), each rule reduces to a trivial inference.
The counterpart @clause-label{Instantiate-*} rules, also present in Figure~\ref{fig:demand-mcfa-instantiation}, each extend one of @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-call-name| so that, if an instantiated query of that type yields a result, the original, uninstantiated query yields that same result.
As discussed at the beginning of this section, Demand $m$-CFA also discovers instantiations when it extends the environment in the @clause-label{App} and @clause-label{Rand} rules.
The @clause-label{App-Body-Instantiation} and @clause-label{Rand-Body-Instantation} rules capture these cases.

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

Bod
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
For instance, Demand $m$-CFA's @clause-label{App} rule ``discovers'' the caller of the entered call, which effects an instantation via @clause-label{App-Body-Instantiation}.
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

These theorems are proved by induction on the derivations, corresponding instantiation of environments on the Demand $\infty$-CFA side with mapping an address on the Demand Evaluation side..

\section{Lightweight Demand $m$-CFA}
\label{sec:lightweight-demand-mcfa}

@(define (lcfa-ρ [ℓ #f]) (meta "\\rho" ℓ))
@(define (lcfa-cc [ℓ #f]) (meta "\\mathit{cc}" ℓ))

To resolve a call which enters a function body @(e) with environment @(mcfa-ρ), Demand $m$-CFA dispatches a query to determine \emph{every} call of the enclosing function @(lam (var 'x) (e)) and filters those calls to only those that could produce @(mcfa-ρ).
Considering every call is necessary to maintain full precision but requires significant analysis effort.
Given that the top-$m$-stack frames context abstraction Demand $m$-CFA uses explicitly includes the call site of the caller, it seems that, at least in some cases, we could use it to accelerate call resolution.
This section presents just such an approach which we call \emph{Lightweight Demand $m$-CFA}.

The key step the analysis must make is to go from a function body and environment to its caller---including call site and environment.
However, the top stack frame contains only the call site and not the environment.
We remedy this simply by changing the definition of contexts to include the environment.
Thus, an $m$-deep environment is a sequence of $m$-deep contexts.
A 0-deep context is always the degenerate $\square$.
An $m$-deep context is either indeterminate (as $?$), a pair of a call site and $m$-1-deep environment, or the stack bottom $()$.
Formally, we have
\begin{align*}
@(lcfa-ρ "^m") \in \mathit{Env}_{m} &= \mathit{Context}_{m}^{*} & \mathit{Context}_0 \ni @(lcfa-cc "^0") &::= \square & \mathit{Context}_{m} \ni @(lcfa-cc "^m") ::=\, ? \,|\, (@(cursor (app (e 0) (e 1)) (∘e)),@(lcfa-ρ "^{m-1}")) \,|\, ()
\end{align*}

@(define (calibrate-name m) (ensuremath (list "\\mathsf{calibrate}" "_{" m "}")))
@(define (calibrate m ρ) (ensuremath (list (calibrate-name m) "(" ρ ")")))

Figure~\ref{fig:lightweight-demand-mcfa-call} presents Demand $m$-CFA's @clause-label{Call-Known} and @clause-label{Call-Unknown} call resolution rules modified accordingly.
\begin{figure}
\begin{mathpar}

\inferrule[Call-Known]
{ 
  }
{ @(mcfa-call (cursor (e) (bod (var 'x) (∘e))) (:: (pair (cursor (app (e 0) (e 1)) (∘e "'")) (lcfa-ρ "'")) (lcfa-ρ))
              (cursor (app (e 0) (e 1)) (∘e)) (calibrate "m" (lcfa-ρ "'")))
  }

\inferrule[Call-Unknown]
{ @(mcfa-expr (cursor (lam (var 'x) (e)) (∘e)) (lcfa-ρ)
              (cursor (app (e 0) (e 1)) (∘e "'")) (lcfa-ρ "'"))
  }
{ @(mcfa-call (cursor (e) (bod (var 'x) (∘e))) (:: "?" (lcfa-ρ))
              (cursor (app (e 0) (e 1)) (∘e)) (lcfa-ρ "'"))
  }

\end{mathpar}
\caption{The modified @clause-label{Call-Known} and @clause-label{Call-Unknown} rules}
\label{fig:lightweight-demand-mcfa-call}
\end{figure}
The modified @clause-label{Call-Known} ensures that, if a caller is sought and the top stack frame (which includes a call site and environment) is known, then that stack frame is reified as the caller.
The @(calibrate-name "m") function extends the $m$-1-deep environment to an $m$-deep environment with indeterminate placeholders $?$.
If the top stack frame is not known, the @clause-label{Call-Unknown} rule applies which simply traces the callers and delivers them.

We must change a few other rules as well.
For instance, when entering a call, either in the @clause-label{App} or @clause-label{Rand} rules, we must @(calibrate-name "m-1") the caller environment from $m$-deep to an $m-1$-deep before we use it to extend the closure environment and enter the call.
@(calibrate-name "m") is a family of metafunctions defined as
\begin{align*}
@(calibrate 0 (lcfa-cc)) &= \square &
@(calibrate "m" "\\square") &= \,? &
@(calibrate "m" "?") &= \,?
\end{align*}
\vspace{-14pt}
\[
@(calibrate "m" (pair (cursor (app (e 0) (e 1)) (∘e)) (lcfa-ρ))) = @(pair (cursor (app (e 0) (e 1)) (∘e)) (calibrate "m-1" (lcfa-ρ)))
\]
which is lifted elementwise to environments.

In the next section, we see that the core of Lightweight Demand $m$-CFA's implementation is succinct and straightforward.
In \S~\ref{sec:evaluation}, we see the Lightweight Demand $m$-CFA can be extremely effective.





\section{Implementation}
\label{sec:implementation}

We have implemented (Lightweight) Demand $m$-CFA using the \emph{Abstracting Definitional Interpreters} approach@~cite{darais2017abstracting}.
Using this approach, one defines a definitional interpreter of their evaluator in
monadic style
as well as
open recursive style (so that the analyzer can intercept recursive calls to the evaluator).
For illustration, Figure~\ref{fig:implementation} presents the gratifyingly-concise implementation of the core components of Lightweight Demand $m$-CFA over the unary $\lambda$ calculus using this approach.
\begin{figure}
\begin{alltt}
(define ((eval eval expr call) \ensuremath{C[e']} \ensuremath{\rho})
  (match \ensuremath{C[e']}
    [\ensuremath{C[\lambda\!\!\!\ x.e]} (unit \ensuremath{C[\lambda\!\!\!\ x.e]} \ensuremath{\rho})]
    [\ensuremath{C[x]} (let ([(\ensuremath{C[\lambda\!\!\!\ x.[e\sb{x}]]} \ensuremath{\rho\sb{x}}) (bind \ensuremath{x} \ensuremath{C[x]} \ensuremath{\rho})]) 
            (>>= (call \ensuremath{C[\lambda\!\!\!\ x.[e\sb{x}]]} \ensuremath{\rho\sb{x}})
                 (λ (\ensuremath{C[(e\sb{0}\,e\sb{1})]} \ensuremath{\rho\sb{\mathit{call}}})
                   (eval \ensuremath{C[(e\sb{0}\,[e\sb{1}])]} \ensuremath{\rho\sb{\mathit{call}}}))))]
    [\ensuremath{C[(e\sb{0}\,e\sb{1})]} (>>= (eval \ensuremath{C[([e\sb{0}]\,e\sb{1})]} \ensuremath{\rho})
                   (λ (\ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.e]} \ensuremath{\rho\sb{\lambda}})
                     (eval \ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.[e]]} (calibrate m \ensuremath{(C[(e\sb{0}\,e\sb{1})],\rho)::\rho\sb{\lambda}}))))]))

(define ((expr eval expr call) \ensuremath{C'[e]} \ensuremath{\rho})
  (match \ensuremath{C'[e]}
    [\ensuremath{C[([e\sb{0}]\,e\sb{1})]} (unit \ensuremath{C[(e\sb{0}\,e\sb{1})]} \ensuremath{\rho})]
    [\ensuremath{C[(e\sb{0}\,[e\sb{1}])]} (>>= (eval \ensuremath{C[([e\sb{0}]\,e\sb{1})]} \ensuremath{\rho})
                     (λ (\ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.e]} \ensuremath{\rho\sb{\lambda}})
                       (>>= (find \ensuremath{x} \ensuremath{C\sb{\lambda}[\lambda\!\!\!\ x.[e]]} (calibrate m \ensuremath{(C[(e\sb{0}\,\,e\sb{1})],\rho)::\rho\sb{\lambda}}))
                            expr)))]     
    [\ensuremath{C[\lambda\!\!\!\ x.[e]]} (>>= (call \ensuremath{C[\lambda\!\!\!\ x.[e]]} \ensuremath{\rho}) expr)]
    [\ensuremath{[e]} fail]))

(define ((call eval expr call) \ensuremath{C[\lambda\!\!\!\ x.[e]]} \ensuremath{\mathit{ctx}::\rho})
  (match \ensuremath{\mathit{ctx}}
    [\ensuremath{\square} (expr \ensuremath{C[\lambda\!\!\!\ x.e]} \ensuremath{\rho})]
    [\ensuremath{(C[(e\sb{0}\,e\sb{1})],\rho')} (unit \ensuremath{C[(e\sb{0}\,e\sb{1})]} (calibrate m \ensuremath{\rho'}))]))
\end{alltt}
\caption{The core of Lightweight Demand $m$-CFA's implementation using the \textit{ADI} approach}
\label{fig:implementation}
\end{figure}
Because the @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-call-name| relations are mutually recursive, their implementations \texttt{eval}, \texttt{expr}, and \texttt{call} are mutually recursive so each receives references for each with which to make recursive calls.
The result of the analysis is a map with three types of keys, one corresponding to evaluation queries through \texttt{eval}, one to trace queries through \texttt{expr}, and one to uses of \texttt{call} (which does not correspond directly to a type of query).
Keys locate the results of the query;
if the key is present in the map, then the results it locates are sound with respect to the query.

\subsection{Pushdown Precision}

An important property of an analyzer is whether its search over the control-flow graph respects CFL reachability.
In the CFA literature, such analyses are often described as ``pushdown'' since they construct a pushdown model of control flow (e.g. @citet{local:p4f}).
One of the features of the ADI approach to analysis construction is that the analyzer's search is disciplined by the continuation of the defining language, which induces a pushdown model naturally.

Demand $m$-CFA exhibits pushdown precision with respect to two different semantics.
First, it is pushdown precise with respect to the demand semantics given in \S~\ref{sec:demand-mcfa}, defined as big-step relations, by virtue of its implementation using the ADI technique.
Second, it is pushdown precise with respect the the direct semantics as well.
The reason here as a result of the insight of @citet{local:p4f}: a continuation address which consists of a target (function body) expression and its environment is distinct enough to perfectly correspond calls and returns (but not needlessly distinct to increase analysis complexity).
In Demand $m$-CFA, the @|mcfa-call-name| relation serves as a kind of continuation store relating a target body and its environment to caller configurations.
Because the @|mcfa-call-name| relation is used to access caller configurations both to access arguments and return results (via tracing), it fulfills each call and return aspect of control flow.


\section{Evaluation}
\label{sec:evaluation}

We extended the implementation described in \S\ref{sec:implementation} of (Lightweight) Demand $m$-CFA to handle a subset of R6RS Scheme@~cite{dvanhorn:Sperber2010Revised} including
conditional expressions;
\texttt{let}, \texttt{let*}, and \texttt{letrec} binding forms;
definition contexts in which a sequence of definitions and expressions can be mixed in a mutually-recursive scope; and
a few dozen primitives.
We did not implement the \texttt{set!} form which mutates the binding of a given variable nor primitives with side effects.\footnote{
This omission does \emph{not} mean that demand CFA fails on any program that uses \texttt{set!}.
Rather, it means that demand CFA fails on any \emph{query} whose resolution depends on a \texttt{set!}'d variable; other queries resolve without issue.
Because the use of mutation in functional languages such as Scheme, ML, and OCaml is relatively rare,
we expect that relatively few queries encounter mutation.}

We evaluate (Lightweight) Demand $m$-CFA with respect to three questions:
\begin{enumerate}
\item \emph{What is the overhead of (Lightweight) Demand $m$-CFA relative to an off-the-shelf exhaustive CFA?}
\item \emph{Does (Lightweight) Demand $m$-CFA behave in practice as a demand CFA?}
\item \emph{How much does the assumption of reachability compromise precision?}
\end{enumerate}

\tw{
Although this paper focuses on context-sensitive demand CFA, we include an evaluation of context-insensitive demand CFA as well.
Specifically, we evaluate Demand 0CFA against 0DDPA, the context-insensitive base of DDPA@~cite{palmer2016higher} hierarchy, and (exhaustive) 0CFA.
Likewise, 
}
We evaluate both Demand $m$-CFA and Demand $m$-CFA against exponential $m$-CFA and regular $m$-CFA with rebinding.
We implement the analyses in Racket@~cite{plt-tr1}, each using the \emph{Abstracting Definitional Interpreters}@~cite{darais2017abstracting} implementation strategy, so that we obtain a close comparison.

\tw{
We evaluate each analysis against a suite of 19 R6RS programs, compiled from a variety of benchmarks by @citet{facchinetti2019ddpa}.
This suite includes, among others,
a derivative-based regular expression matcher@~cite{Brzozowski:1964},
a toy RSA implementation,
a toy computer algebra system,
various programs that exhibit specific functional idioms, and
pathological programs designed to provoke exponential run times or to hemorrhage precision.
We ensure each program is alphatized to aid $k$-CFA.
None of the programs in our benchmark suite use mutation.
}

We ran our benchmarks on a 2015 MacBook Pro with a four-core Intel Core i7 processor and 16 GB RAM.
For $m$-CFA and (Lightweight) Demand $m$-CFA, we used Racket CS 7.7..

\subsection{Demand CFA Overhead}

A demand analysis is typically more expensive per fact than a corresponding exhaustive analysis \emph{on average}.
Demand analysis is viable only because not all facts require the same amount of analysis to obtain.
Thus, a demand analysis can often obtain a useful subset of facts in a fraction of the time of an exhaustive analysis.

Nevertheless, some idea of the raw overhead of demand analysis is useful.
To get such an idea, we measured the time taken by (Lightweight) Demand $m$-CFA, and $m$-CFA to analyze each program.
Each analysis was tasked with analyzing the entire given program.
For $m$-CFA, we simply ran it on the program.
For (Lightweight) Demand $$-CFA, we issued an evaluation query for each expression.
We performed the measurement both without and with context sensitivity.

\subsection{A demand CFA in practice?}

Given that demand CFA is inherently more expensive that exhaustive CFA for a given fact, it doesn't make sense to apply it to every part of the program.
This question seeks to what extent (Lightweight) Demand $m$-CFA can obtain flow information economically.
Our methodology is to measure the time a comparable exhaustive CFA takes to analyze the program as a baseline.
We then calculate what timeout to impose on (Lightweight) Demand $m$-CFA so that total analysis time is 30\% of the baseline, by considering the number of expressions to analyze.
(We chose 30\% simply because it makes CFA reasonably more practical.)
We report the fraction of control-flow information obtained across all programs with this timeout in place:
Demand 0CFA obtained 49.7\%, Demand 1CFA obtained 65.8\%, and Lightweight Demand 1CFA obtained 76.0\%.
These fractions demonstrate that (Lightweight) Demand $m$-CFA is able to obtain an appreciable fraction of control flow at a fairly large discount.

\subsection{Relative Precision}

Demand $m$-CFA makes reachability assumptions which can, in theory, decrease its precision.
For instance, if Demand $m$-CFA is tracing the caller of \texttt{f} in the expression \texttt{(λ (g) (f 42))} so that it can evaluate the argument,
it assumes that \texttt{(f 42)} is reachable---i.e., it assumes that \texttt{(λ (g) (f 42))} is called.
If that assumption is false, then the argument \texttt{42} does not actually contribute to the value that Demand $m$-CFA is resolving, and its inclusion is manifest imprecision.

To determine how frequently erroneous reachability assumptions affect precision, we compared the results produced by (Lightweight) Demand $m$-CFA against those produced by an exhaustive analysis.
We first ran exponential $m$-CFA---that is, standard exhaustive $m$-CFA but \emph{without} performing rebinding---to obtain a cache from configurations to their values.\footnote{
We used exponential $m$-CFA rather than $m$-CFA so that we could reconstruct the (lightweight) Demand $m$-CFA environments, to verify equivalence.}
From each configuration, we reconstructed an evaluation query;
in particular, we used the configuration's environment to produce an instantiated (Lightweight) Demand $m$-CFA environment.
We then compared the query results with the cached results of the exhaustive analysis.
We performed this comparison when $m=0$ and $m=1$.

For every single of
1899 [$m$=0]-CFA configurations
and
8610 [$m$=1]-CFA configurations,
both Demand $m$-CFA \emph{and} Lightweight Demand $m$-CFA
are \emph{exactly as precise} as their exhaustive counterpart.
We also verified that precision strictly increased with the level of context sensitivity.


To be clear, these results mean that, for example, Lightweight Demand 1CFA was able to obtain \emph{all} of the exact same control-flow information as exhaustive 1CFA on the \textsf{sat-2} benchmark \emph{over $300\times$ faster}.
This result, of course, is not typical.
That particular benchmark is designed so that $k$-CFA and exponential $m$-CFA produce an exponential number of environments.
Lightweight Demand $m$-CFA, however, forgets just the right parts of the context so that many of those environments are folded together.
Simultaneously, it retains just enough to perfectly resolve argument values.
(We also manually verified that the precision on \texttt{sat-2} actually increases in the transition from $m=0$ to $m=1$.)
Lightweight Demand 2CFA witnesses a $1000\times$ slowdown as 2-deep environments are enough to support the exponential explosion of environments.

Our takeaway here is that it is worth investigating Lightweight Demand $m$-CFA's context abstraction and mechanism further to determine whether selective context forgetfulness might curtail the explosion in general.


\section{Related Work}
\label{sec:related-work}

The original inspiration for demand CFA is demand dataflow analysis@~cite{horwitz1995demand} which refers to dataflow analysis algorithms which allow selective, local, parsimonious analysis of first-order programs driven by the user.
Demand CFA seeks algorithms with those same characteristics which operate in the presence of first-class functions.
This work extends Demand 0CFA@~cite{germane2019demand}, currently the sole embodiment of demand CFA, with context sensitivity using the context abstraction of $m$-CFA@~cite{dvanhorn:Might2010Resolving}.

DDPA@~cite{palmer2016higher} is a context-sensitive, demand-driven analysis for higher-order programs so, nominally, it is in precisely the same category as (Lightweight) Demand $m$-CFA.
However, before resolving any on-demand queries, DDPA must bootstrap a global control-flow graph to support them.
Because of this large, fixed, up-front cost, DDPA doesn't provide the pricing model of a demand analysis and does not make the kinds of applications targeted by demand analysis practical.

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

In addition, many points-to analyses rely on other aspects of program structure imposed by the language.
@citet{sridharan2005demand} present a demand-driven points-to analysis for Java that utilizes the class hierarchy to approximate the call graph.
In follow-on work, @citet{sridharan2006refinement} use the class hierarchy to bootstrap a context-sensitive refinement of it.
Our work is oriented toward functional programs with no typing discipline;
hence, we cannot rely on anything resembling a class hierarchy.

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
Lightweight Demand $m$-CFA can be positioned similarly where the low-budget environments are compilers and IDEs for functional programs.

\section{Conclusion}
\label{sec:conclusion}

This paper presented two strategies for achieving context-sensitive demand CFA, each based on the top-$m$-stack-frames context abstraction of $m$-CFA@~cite{dvanhorn:Might2010Resolving}.
The first strategy leads to the Demand $m$-CFA hierarchy which exhibits pushdown precision
(1) with respect to the demand semantics, by virtue of using the \emph{Abstracting Definitional Interpreters}@~cite{darais2017abstracting} implementation approach, and
(2) with respect to the direct semantics, by virtue of using the continuation address identified in \emph{Pushdown for Free}@~cite{local:p4f}.
The second strategy leads to the Lightweight Demand $m$-CFA hierarchy which, in some cases, offers the precision of context sensitivity at the price of context insensitivity.

The techniques we used to achieve context-sensitive demand CFA may also be effective at realizing selective context sensitivity@~cite{li2020principled} in a functional setting.
It might also be possible to combine demand CFA with selective context sensitivity such that the user can specify what aspects of the results should be preserved by analysis, allowing the analyzer to approximate other aspects where profitable.

Some aspects of programs, such as the use of dynamic features, inherently limit the information that can be obtained statically.
When analyzing such programs, defensive analysis@~cite{smaragdakis2018defensive} provides both a result and an indicator of whether that result is sound for every execution environment.
Demand CFA is already defensive in a sense:
query resolution fails when the analyzer encounters an unsupported language feature.
However, integrating defensive analysis would require it to be more principled about its reachability assumptions and the status of its results.

\bibliographystyle{ACM-Reference-Format}
\bibliography{paper}

\end{document}
