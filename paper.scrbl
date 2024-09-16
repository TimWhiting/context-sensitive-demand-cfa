#lang scribble/text
@(require "base.rkt"
          "syntax.rkt"
          "bib.rkt"
          "mathpar.rkt")
@(define-syntax-rule (omit . rst) (void))
\documentclass[runningheads]{llncs}
\usepackage[T1]{fontenc}

\usepackage{mathpartir}
\usepackage{natbib}
\usepackage{xcolor}
\definecolor{light-gray}{gray}{0.8}
\usepackage{textgreek}
\usepackage{wrapfig}
\usepackage{alltt}
\usepackage[inline]{enumitem}
\usepackage{graphicx}
\graphicspath{evaluation/plots}
\usepackage{subcaption}

\bibliographystyle{splncs04nat}
\begin{document}

\title{Context-Sensitive Demand-Driven Control-Flow Analysis}

\maketitle

\begin{abstract}
By decoupling and decomposing control flows, demand control-flow analysis (CFA) is able to resolve only those segments of flows it determines necessary to resolve a given query.
Thus, it presents an interface and pricing model much more flexible than typical CFA, making many useful applications practical.
At present, the only realization of demand CFA is demand 0CFA, which is context-insensitive.
This paper presents a context-sensitive demand CFA hierarchy, Demand $m$-CFA, 
based on the top-$m$-stack-frames abstraction of $m$-CFA.
We evaluate the implementation effort, scalability, and precision of Demand $m$-CFA.
We demonstrate that Demand $m$-CFA \begin{enumerate*} 
\item resolves a large percent of queries quickly even when we increase context sensitivity and program size,
\item can resolve as many singleton value flows as a formulation of $m$-CFA with full environment precision, and
\item can be implemented cheaply and integrated into interactive tools such as language servers.
\end{enumerate*}

\keywords{Demand CFA, m-CFA, Context-Sensitivity, Control Flow Analysis}

\end{abstract}

@(define (clause-label label) (list "\\textit{" label "}"))


\section{Getting into the Flow}

Conventional control-flow analysis is tactless---unthinking and inconsiderate.

To illustrate, consider the program fragment on the right which defines 
\begin{wrapfigure}[6]{r}{0.65\textwidth}
\vspace{-2.75em}
\begin{verbatim}
(letrec ([fold (λ (f g n a)
          (if (zero? n)
            a
            (fold f g (f n) (g f n a))))])
  (fold sub1 h 42 1))
\end{verbatim}
\end{wrapfigure}
the recursive \texttt{fold} function.
As this function iterates, it evolves the index \texttt{n} using the function \texttt{f} and the accumulator \texttt{a} using the function \texttt{g}, all arguments 
to \texttt{fold} itself. The values of \texttt{f} and \texttt{g} flow in parallel
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
In this example, a supporting demand CFA works backwards from the reference to \texttt{f} to determine its value, and considers only the three flow segments identified above to do so.

The interface and pricing model demand CFA offers make many useful applications practical.
@citet{horwitz1995demand} identify several ways this practicality is realized:
\begin{enumerate}
\item One can restrict analysis to a program's critical path or only where certain features are used.
\item One can analyze more often, and interleave analysis with other tools. For example, 
a demand analysis does not need to worry about optimizing transformations invalidating analysis results since one can simply re-analyze the transformed points.
\item One can let a user drive the analysis, even interactively, to enhance, e.g., an IDE experience.
We have implemented the demand CFA we present in this paper in Visual Studio Code for the Koka language@~cite{koka2019}.
\end{enumerate}

\subsection{Adding Context Sensitivity to Demand CFA}

Presently, the only realization of demand CFA is Demand 0CFA@~cite{germane2019demand} which is context insensitive.
(We offer some intuition about Demand 0CFA's operation in \S\ref{sec:intuition} and present a streamlined version of it in \S\ref{sec:demand-0cfa}.)
However, context sensitivity would endow demand CFA with the same benefits that it does analyses at large:
increased precision and, in some cases, a reduced workload@~cite{dvanhorn:Might:2006:GammaCFA} (which we discuss at an intuitive level in \S\ref{sec:intuition}).

However, the demand setting presents a particular challenge for adding context sensitivity:
unlike exhaustive analyses in which the context is fully determined at each point in analysis,
a demand analysis is deployed on an arbitrary program point in an undetermined context.
Thus, the task of a context-sensitive demand CFA is not only to respect the context as far as it is known, but also to determine unknown contexts as they are discovered relevant to analysis.
Achieving this task requires a compatible choice of context, context representation, and even environment representation, as we discuss in \S\ref{sec:progression}.

After overcoming this challenge, we arrive at Demand $m$-CFA (\S\ref{sec:demand-mcfa}), a hierarchy of context-sensitive demand CFA.@;{
At a high level, Demand $m$-CFA achieves context sensitivity by permitting indeterminate contexts, which stand for any context, and instantiating them when further information is discovered.
It then uses instantiated contexts to filter its resolution of control flow to ensure that its view of evaluation remains consistent with respect to context.
(We offer intuition about these operations in \S\ref{sec:intuition} as well.)}
Demand $m$-CFA is sound with respect to a concrete albeit demand semantics called \emph{demand evaluation} (\S\ref{sec:demand-mcfa-correctness}), which is itself sound with respect to a standard call-by-value semantics.

Demand $m$-CFA determines the context only to the extent necessary to soundly answer analysis questions, as opposed to determining the entire context.
Not only does this allow Demand $m$-CFA to avoid analysis work, it offers information to the analysis client regarding which aspects of the context are relevant to a particular analysis question, which the client can use to formulate subsequent questions.

We have implemented Demand $m$-CFA in several settings using the \emph{Abstracting Definitional Interpreters} (ADI) technique@~cite{darais2017abstracting}.
We evaluate the implementation cost and performance to empirically assess Demand $m$-CFA (\S\ref{sec:evaluation}).

We conclude by discussing related (\S\ref{sec:related-work}) and future work (\S\ref{sec:future-work}).

@;{
is comprehensive in the sense that it discovers all contexts to the extent necessary for evaluation.
It achieves this by carefully ensuring at certain points that it proceeds only when the context is known, even if it is not strictly necessary to produce a value.
We find this disposition toward analysis fairly effective:
in some cases, it produces effectively-exhaustive, identically-precise results as an exhaustive analysis at the same level of context sensitivity but \emph{at a constant price}.
}


@;Although Demand $m$-CFA requires a fair amount of technical machinery to formulate,
@;
@;{
To illustrate its directness, we reproduce and discuss the core of Demand $m$-CFA's implementation in \S\ref{sec:implementation}.
One virtue of using the ADI approach is that it endows the implemented analyzer with ``pushdown precision'' with respect to the reference semantics---which, for our analyzer, are the demand semantics.
However, as we discuss in \S\ref{sec:implementation}, Demand $m$-CFA satisfies the \emph{Pushdown for Free} criteria@~cite{local:p4f} which ensures that it has pushdown precision with respect to the direct semantics as well.
}
@;{
This paper makes the following contributions:
\begin{itemize}
\item a new formalism for Demand 0CFA which can be implemented straightforwardly using contemporary techniques@~cite{darais2017abstracting,wei2018refunctionalization} (\S\ref{sec:demand-0cfa});
\item Demand $m$-CFA (\S\ref{sec:demand-mcfa}), a hierarchy of context-sensitive demand CFA and a proof of its soundness (\S\ref{sec:demand-mcfa-correctness}); and
\item an empirical evaluation of the scalability and precision of Demand $m$-CFA (\S\ref{sec:evaluation}).
\end{itemize}
}

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
We will also see that Demand $m$-CFA does not need a timestamp to record the ``current'' context, a fact we discuss further in \S\ref{sec:whence-timestamp}.

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
\begin{wrapfigure}{l}{0.40\textwidth}
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
$q_3$ & \phantom{XX} \phantom{XX} @exq{f} \textsf{in} \texttt{(f 35)} \textsf{in} $\langle\rangle$ \\
      & \phantom{XX} \phantom{XX} $\Rightarrow$ \texttt{(f 35)} \textsf{in} $\langle\rangle$  \\
$q_6$ & @evq{x} \textsf{in} $\langle\texttt{(f 35)}\rangle$ \\
$q_7$ & @evq{35} \textsf{in} $\langle\rangle$ \\
      & $\Rightarrow$ $35$ \textsf{in} $\langle\rangle$
\end{tabular}
\end{wrapfigure}
For instance, to obtain all of the values to which \texttt{x}, the body of \texttt{(λ (x) x)}, may evaluate,
a user may issue the query @evq{x} \textsf{in} $\langle ?\rangle$ ($q_0$ at left) where $?$ is a ``wildcard'' context to be instantiated with each context the analyzer discovers.
(Though each context in the environment is indeterminate, the shape of the environment itself is determined by the lexical binding structure, which we discuss further in \S\ref{sec:more-orderly}.)
Once issued, resolution of \texttt{x}'s evaluation again depends on a caller query $q_0'$.
However, because the parameter \texttt{x}'s context is unknown, rather than filtering out callers, the caller query will cause $?$ to be instantiated with a context derived from each caller.
As before, Demand $m$-CFA dispatches a trace query $q_1$ which then traces occurrences of \texttt{f} via $q_2$ and $q_3$.
This query locates the call sites \texttt{(f 42)} \textsf{in} $\langle\rangle$ and \texttt{(f 35)} \textsf{in} $\langle\rangle$.
Once $q_2$ delivers the result \texttt{(f 42)} \textsf{in} $\langle\rangle$ to $q_1$ and then $q_0'$, Demand $m$-CFA \emph{instantiates} $q_0$ with this newly-discovered caller to form $q_4$, whose result is $q_0$'s also.
After creating $q_3$, it continues with its resolution by issuing $q_4$ to evaluate the argument \texttt{42} \textsf{in} $\langle\rangle$.
Its result of $42$ propagates from $q_4$ to $q_0$;
from $q_0$, one can see all instantiations of it as well every result of those instantiations.
The instantiation from $q_3$ proceeds similarly.

\section{Language and Notation}
\label{sec:notation}

We present Demand $m$-CFA over the unary $\lambda$ calculus.
It is straightforward to extend it to multiple-arity functions, data structures, constants, primitives, conditionals, and recursive forms---which we have in our implementations---but this small language suffices to discuss the essential aspects of context sensitivity.

In order to keep otherwise-identical expressions distinct, many CFA presentations uniquely label program sub-expressions.\footnote{Others operate over a form which itself names all intermediate results, such as CPS or $\mathcal{A}$-normal form, and identify each expression by its associated (unique) name.}
This approach would be used, for example, to disambiguate the two references to \texttt{f} in the program in \S\ref{sec:intuition}.
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
@(require (prefix-in 0cfa- "demand-0cfa.rkt"))
Demand 0CFA has two modes of operation, \emph{evaluation} and \emph{tracing}, which users access by submitting evaluation or trace queries, respectively.
A query designates a program expression over which the query should be resolved.
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


Operator
——
C[([e₀] e₁)] ⇒ C[(e₀ e₁)]

Body
C[λx.[e]] ⇐ C'[(e₀ e₁)]  C'[(e₀ e₁)] ⇒ C''[(e₂ e₃)] 
——
C[λx.[e]] ⇒ C''[(e₂ e₃)] 

Operand
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

Find-Operator
x C[([e₀] e₁)] F Cx[x]
——
x C[(e₀ e₁)] F Cx[x]

Find-Operand
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

A judgement @(0cfa-call (cursor (e) (bod (var 'x) (∘e))) (cursor (app (e 0) (e 1)) (∘e "'"))) denotes that the application @(app (e 0) (e 1)) applies @(lam (var 'x) (e)), thereby binding @(var 'x).
Demand 0CFA arrives at this judgment by the @clause-label{Call} rule which uses the @|0cfa-expr-name| relation to determine it.
In demand 0CFA, this relation is only a thin wrapper over @|0cfa-expr-name|, but becomes more involved with the addition of context sensitivity.

A judgement @(0cfa-expr (cursor (e) (∘e)) (cursor (app (e 0) (e 1)) (∘e "'"))) denotes that the value of the expression @(e) is applied at @(app (e 0) (e 1)).
Demand 0CFA arrives at such a judgement by considering the type of the syntactic context to which the value flows.
The @clause-label{Operator} rule captures the intuition that, if @(lam (var 'x) (e)) flows to operator position @(e 0) of @(app (e 0) (e 1)), it is applied by @(app (e 0) (e 1)).
The @clause-label{Body} rule captures the intuition that if a value flows to the body of a $\lambda$ term, then it flows to each of its callers as well.
The @clause-label{Operand} rule captures the intuition that a value in operand position is bound by the formal parameter of each operator value and hence to each reference to the formal parameter in the operator's body.
If the operator @(e "_f") evaluates to @(lam (var 'x) (e)), then the value of @(e "_a") flows to each reference to @(var 'x) in @(e).

The @|0cfa-find-name| relation associates a variable @(var 'x) and expression @(e) with each reference to @(var 'x) in @(e).
@clause-label{Find-Ref} finds @(e) itself if @(e) is a reference to @(var 'x).
@clause-label{Find-Operator} and @clause-label{Find-Operand} find references to @(var 'x) in @(app (e 0) (e 1)) by searching the operator @(e 0) and operand @(e 1), respectively.
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
We empirically investigate the extent to which precision is compromised in \S\ref{sec:evaluation}.
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
Once these are determined, we combine each expression and its enclosing environment to form a \emph{configuration}.\footnote{Configurations in exhaustive CFAs include a timestamp as well. We discuss its omission from demand CFA configurations in \S\ref{sec:whence-timestamp}.}
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


Operator
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


Operand
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

Find-Operator
x C[([e₀] e₁)] ρ F Cx[x] ρ-x
——
x C[(e₀ e₁)] ρ F Cx[x] ρ-x

Find-Operand
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

Demand $m$-CFA augments Demand 0CFA with environments and a mechanism to instantiate contexts within environments, which together provide context sensitivity.
The addition of environments pervades @|mcfa-eval-name|, @|mcfa-expr-name|, and @|mcfa-find-name| which are otherwise identical to their Demand 0CFA counterparts;
these enriched relations are presented in Figure~\ref{fig:mcfa-resolution}.
The mechanism is located in @|mcfa-call-name|, which is significantly elaborated relative to its Demand 0CFA counterpart.

In Demand $m$-CFA, environments are constructed when the analysis follows evaluation forward, such as entering a call, and instantiated when the analysis follows it backward, such as when the caller of an entry configuration is sought.

\subsection{Following Evaluation Forwards}

When a call is entered, which occurs in the @clause-label{App} and @clause-label{Operand} rules, a new environment is synthesized using the @|mcfa-time-succ-name| metafunction which determines the binding context of the call as 
\[
@(mcfa-time-succ (cursor (app (e 0) (e 1)) (∘e)) (:: (mcfa-cc) (mcfa-ρ))) = \lfloor @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc)) \rfloor_m
\]
where $\lfloor\cdot\rfloor_{m}$ is defined
\begin{align*}
\lfloor @(mcfa-cc) \rfloor_0 = \square & & \lfloor ?_{@(var 'x)} \rfloor_m = ?_{@(var 'x)} & & \lfloor @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc)) \rfloor_m = @(:: (cursor (app (e 0) (e 1)) (∘e)) (list "\\lfloor " (mcfa-cc) "\\rfloor_{m-1}"))
\end{align*}

\subsection{Following Evaluation Backwards}

When the value of a reference is demanded, Demand $m$-CFA first uses the @|mcfa-bind-name| metafunction to locate its binding configuration.
Its definition, presented in Figure~\ref{fig:mcfa-bind}, is lifted from Demand 0CFA's to accommodate environments.

With the binding configuration in hand, Demand $m$-CFA issues a call query to resolve calls which enter that configuration.
The @|mcfa-call-name| relation resolves such queries.
As in Demand 0CFA, @|mcfa-call-name| defers to @|mcfa-expr-name| to determine the call configurations at which a particular closure is applied.
In the presence of contexts, however, there are two possibilities when a call configuration is resolved.
The first possibility is that the call entry context computed from that configuration precisely matches that of the binding configuration, in which case the call configuration is a caller of the binding configuration;
we refer to this as the @clause-label{Known-Call} case.
The second possibility is that the call entry context refines the binding configuration's context, in which case the refined context and environment should be instantiated to the refining context and environment;
we refer to this as the @clause-label{Unknown-Call} case.

\subsection{Discovering Callers}

We now describe how @|mcfa-call-name|, presented in Figure~\ref{fig:mcfa-call-reachability}, handles each of these cases.
\begin{figure}
@mathpar[mcfa-parse-judgement]{
Known-Call
q ⇑ ca C[λx.[e]] ctx₀::ρ  C[λx.e] ρ ⇒ C'[(e₀ e₁)] ρ'  ctx₁ := time-succ(C'[(e₀ e₁)],ρ')  ctx₁ = ctx₀
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
Each case is handled by a corresponding rule.
Each rule is predicated on the \emph{reachability} of the call query, which we discuss shortly, and resolution of the corresponding trace query.
The @clause-label{Known-Call} rule says that, if the call entry context of the delivered call matches the binding configuration's,
then the delivered call is a known call---\emph{known} because the caller query has the context of the call already in its environment.
If @(≠ (mcfa-cc 1) (mcfa-cc 0)), however, then the result constitutes an \emph{unknown} caller.
In this case, @clause-label{Unknown-Call} considers whether @(mcfa-cc 1) refines @(mcfa-cc 0) in the sense that @(mcfa-cc 0) can be instantiated to form @(mcfa-cc 1).
Formally, the refinement relation $\sqsubset$ is defined as the least relation satisfying
\begin{align*}
@(:: (cursor (app (e 0) (e 1)) (∘e "'")) (mcfa-cc)) \sqsubset\; ?_{@(cursor (e) (∘e))} & & @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc 1)) \sqsubset @(:: (cursor (app (e 0) (e 1)) (∘e)) (mcfa-cc 0))\Longleftarrow @(mcfa-cc 1) \sqsubset @(mcfa-cc 0)
\end{align*}
If @(mcfa-cc 1) refines @(mcfa-cc 0), @clause-label{Unknown-Call} does not conclude a @|mcfa-call-name| judgement, but rather an \emph{instantiation} judgement @(mcfa-instantiation (:: (mcfa-cc 0) (mcfa-ρ)) (:: (mcfa-cc 1) (mcfa-ρ))) which denotes that \emph{any} environment @(:: (mcfa-cc 0) (mcfa-ρ)) may be instantiated to @(:: (mcfa-cc 1) (mcfa-ρ)).
It is by this instantiation that @clause-label{Known-Call} will be triggered.
When @(mcfa-cc 1) does not refine @(mcfa-cc 0), the resultant caller is ignored which, in effect, filters the callers to only those which are compatible and ensures that Demand $m$-CFA is indeed context-sensitive.

The @|mcfa-call-name| relation relies on a reachability relation @|mcfa-reach-name| which establishes which queries are (transitively) issued in the course of resolving a top-level query.
This relation allows @|mcfa-call-name| to instantiate only seen queries with refinement results.
This relation is defined over queries themselves;
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


Operand-Operator
q ⇑ ex C[(e₀ [e₁])] ρ
——
q ⇑ ev C[([e₀] e₁)] ρ

Operand-Body
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
The @clause-label{Reflexivity} rule ensures that the top-level query is considered reachable.
The @clause-label{Ref-Caller} and @clause-label{Ref-Argument} rules establish reachability corresponding to the @clause-label{Ref} rule of @|mcfa-eval-name|:
@clause-label{Ref-Caller} makes the caller query reachable and, if it succeeds, @clause-label{Ref-Argument} makes the ensuing evaluation query reachable.
@clause-label{App-Operator} and @clause-label{App-Body} do the same for the @clause-label{App} rule of @|mcfa-eval-name|, making, respectively, the operator evaluation query reachable and, if it yields a value, the body evaluation query reachable.
@clause-label{Operand-Operator} makes the evaluation query of the @clause-label{Operand} rule reachable and @clause-label{Operand-Body} makes the trace query of any references in the operator body reachable.
@clause-label{Body-Caller-Find} makes the caller query of @clause-label{Body} reachable;
if a caller is found, @clause-label{Body-Caller-Trace} makes the trace query of that caller reachable.
Finally, @clause-label{Call-Trace} makes sure that the trace query of an enclosing $\lambda$ of a caller query is reachable.

Figure~\ref{fig:demand-mcfa-instantiation} presents an extension of @|mcfa-reach-name| which propagates instantiations to evaluation and trace queries.
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

Operand-Body-Instantiation
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
As discussed at the beginning of this section, Demand $m$-CFA also discovers instantiations when it extends the environment in the @clause-label{App} and @clause-label{Operand} rules.
The @clause-label{App-Body-Instantiation} and @clause-label{Operand-Body-Instantiation} rules capture these cases.

The definition of Demand $m$-CFA in terms of an ``evaluation'' relation (which includes evaluation, trace, and caller resolution) and a reachability relation follows the full formal approach of \emph{Abstracting Definitional Interpreters} by @citet{darais2017diss}.
From this correspondence, we can define the Demand $m$-CFA resolution of a given query as the least fixed point of these relations, effectively computable with the algorithm @citet{darais2017diss} provides.
We discuss this implementation in more depth in \S\ref{sec:evaluation}.


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


Operator
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


Operand
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

Find-Operator
x C[([e₀] e₁)] ρ σ₀ F Cx[x] ρ-x σ₁
——
x C[(e₀ e₁)] ρ σ₀ F Cx[x] ρ-x σ₁

Find-Operand
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

\section{Evaluation}
\label{sec:evaluation}

We implemented Demand $m$-CFA for a subset of R6RS Scheme@~cite{dvanhorn:Sperber2010Revised} including \texttt{let}, \texttt{let*}, \texttt{letrec} binding forms,
mutually-recursive definitions and a few dozen primitives. We also implemented support for constructors, numbers, symbols, strings, and characters.

We evaluate Demand $m$-CFA with respect to the following questions:
\begin{enumerate}
\item How does the implementation cost compare to a typical CFA?
\item What is the distribution of required analysis effort to resolve queries?
\item How does the precision compare to a typical CFA?
\end{enumerate}
To answer performance questions, we evaluate Demand $m$-CFA on the set of R6RS programs used by @citet{johnson:earl:dvanhorn:PushdownGarbage}, which is standard within the literature.


\subsection{Implementation cost}
We used the \emph{Abstracting Definitional Interpreters} approach@~cite{darais2017abstracting} to implement $m$-CFA and Demand $m$-CFA analyses for the Pure Scheme language.
The amount of code needed to implement each analysis is on the same order of magnitude.
Demand $m$-CFA requires 630 lines of code while $m$-CFA uses 450 lines of code, without counting the supporting functions shared between the two.
Demand $m$-CFA requires additional lines of code due to the fact that in addition to evaluation, it also traces the flow of values.

We also implemented Demand $m$-CFA for the Koka language compiler and language server to provide analyzer interaction within the editor (e.g. providing control flow information on hover).
Many queries resolve at interactive latencies, providing the user with near-real-time control flow information.
We did not implement a corresponding exhaustive analysis for Koka which would require whole program transformations and many more primitives.

Our implementation for Koka is about 652 lines of Haskell code for the core analysis,
with an additional 2364 lines of supporting code for primitives, the fixpoint ADI framework, 
and mapping the core syntax to the user syntax for showing results.
%The queries respond interactively when hovering over an identifier in VSCode.

Our experience is that integrating Demand $m$-CFA into a compiler or language server is in some cases \emph{more} tractable than an exhaustive analysis, since not all language features or primitives need to be implemented to get at least some utility.
@;{and integrating it into a compiler is straightforward, 
and that implementation costs are minimal and unintrusive.}

\subsection{Query complexity distribution}
Like an exhaustive analysis, a demand analysis is subject to client-imposed resource constraints.
However, unlike with exhaustive analysis, failure in a demand analysis is not catastrophic:
because analysis information is sought selectively and independently through queries,
the client can increase the budget and reissue the query or proceed without control flow information.

We evaluate the proportion of queries that Demand $m$-CFA is able to resolve for different effort limits and at different context sensitivity levels.
Effort is measured in gas, where each subquery consumes one unit.@;{
(Because flow information is offered allows clients to specify 
Demand $m$-CFA provides a different interface to analysis than is typical for most control flow analyses.
Since its cost framework provides a different utility model 
% and therefore ability to be embedded into a language server and work on subportions of programs, 
it is important to evaluate how well it resolves queries given a limited amount of effort.

Utilizing ADI's fixpoint
we added an effort parameter we call gas, which at each (mutually) recursive call gets reduced by one. 
When the gas runs out the analysis returns from the fixpoint computation by reporting an error.
In the language server for Koka we still report the normal hover info (type information / documentation)
when additional semantic precision is not obtainable due to lack of supporting primitives or running out of gas.
}
Figure~\ref{fig:dmcfa-scalability} displays the percent of queries answered depending on the gas allotted.
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
\includegraphics[width=\linewidth]{total-queries-answered_loop2-1.pdf} 
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
\caption{The percent of queries answered (y-axis) given the effort allocated (x-axis) to Demand $m$-CFA per query.
Each figure has a line for each setting of $m$.
Many trivial queries ($40\%$-$60\%$) are answered given very little effort.
In order to answer more queries sometimes it is enough to give the analysis more gas, 
while larger examples like scheme2java and regex require more context sensitivity 
to appropriately distinguish unrelated flows to avoid exploring the full control flow graph.
}
\label{fig:dmcfa-scalability}
\end{figure}
The graphs trend upward and to the right, regardless of our choice of $m$. 
Notable exceptions include \texttt{regex}, and \texttt{scheme2java} which both contain highly connected control flow graphs. 
Additionally \texttt{scheme2java} uses \texttt{set!} which we do not support.
Both significantly improve when explored at higher $m$ which exemplifies the known paradox of precision 
from exhaustive CFA, in which increasing precision can sometimes decrease the state space due to fewer spurious flows.
Our results show that this phenomenon holds even for subportions of programs.
We hypothesize that this paradox might be more useful in the demand context 
due to not exploring undemanded or unrelevant portions of the program with higher sensitivity.

@;From the experimental results, we claim that Demand $m$-CFA is in fact scalable, both with increasing context sensitivity and with program size.

\subsection{Demand $m$-CFA precision}

To measure the precision of Demand $m$-CFA, we focus on the singleton flow sets that it is able to identify.
Singleton flow sets represent actionable flow information;
for instance, they enable compilers to proceed with constant propagation and procedure inlining.@;{
Any flow result for a particular program point can help IDE users
narrow down where bad values might flow into their program, 
or start to understand a complex code base---even if the result is not entirely precise.

However, a compiler needs more guarantees in order to soundly perform
constant propagation, inlining, or other optimizations.
The invariants required for different kinds of values differ as exemplified by the environment problem for closures@~cite{dvanhorn:Might:2006:GammaCFA},
but a commonality is knowing that the flow set of a particular variable is limited in some way.
In particular when a single syntactic lambda, or constant value or constructor flows to a particular program
point we call the resulting flow set a singleton flow set.
}
Figure~\ref{fig:dmcfa-answers}, shows the number of results that contain singleton flow sets.
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
\includegraphics[width=\linewidth]{important-queries-answered_loop2-1.pdf}
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
\caption{
The number of singleton flow sets (y-axis) found by a Demand $m$-CFA analysis given limited effort (x-axis).
Dashed lines represent the baseline number of singleton flow sets found by an exhaustive exponential $m$-CFA analysis with a 10 minute timeout, regardless of effort.
\texttt{scheme2java} doesn't have results for $m>=1$ exhaustive $m$-CFA due to timing out.
}
\label{fig:dmcfa-answers}
\end{figure}
Exhaustive $m$-CFA results are dashed and are represented as a straight line, whereas Demand $m$-CFA results are graphed as a function of effort.
\texttt{scheme2java} doesn't have results for exhaustive analysis beyond $m=1$ due to timing out after 10 minutes.

In some cases, Demand $m$-CFA finds singleton flow sets that exhaustive $m$-CFA doesn't,
explained by the fact that some of the code on which Demand $m$-CFA is dispatched is dead.
@;{on dead code due to the fac
Occasionally Demand $m$-CFA finds more singleton flow sets than $m$-CFA,
which is typically due to Demand $m$-CFA returning results on parts of the state space
which correspond to unexplored dead code in the exhaustive analysis. 
In these benchmarks, we believe this happens only infrequently.}
In some cases, Demand $m$-CFA doesn't find singleton flow sets that exhaustive $m$-CFA does.
These cases are explained by reachability assumptions Demand $m$-CFA makes when resolving bindings.@;{
In other cases Demand $m$-CFA does not find as many singleton flow sets. 
For some queries that involve a large portion of the overall flow, this can be attributed to the analysis running out of gas.
However we believe that more often it is due to Demand $m$-CFA making reachability assumptions which can decrease its precision.}
For instance, if Demand $m$-CFA is finding the callers of \texttt{f} in the expression \texttt{(λ (g) (f 42))} to discover arguments to \texttt{f},
it assumes that \texttt{(f 42)} is reachable---i.e., it assumes that \texttt{(λ (g) (f 42))} is called.
If that assumption is false, then the argument \texttt{42} does not actually contribute to the value that Demand $m$-CFA is resolving, 
and its inclusion is manifest as imprecision.
@;We believe this to be the case for several of the benchmarks, in particular the blur benchmark.

The results show that Demand $m$-CFA generally finds a similar amount of singleton value flows as exhaustive $m$-CFA, and does it with a low effort bound.
@;{
This matches our intuition that if a flow is precise then it does not get mixed up with other flows, and should be quickly resolvable.
As such, we can confidently claim that Demand $m$-CFA acheives similar precision to the exhaustive $m$-CFA (with exponential environments). 
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

@citet{nicolay_effect-driven_2019} produce a flow analysis where new information is propagated between interprocedural and intraprocedural parts of the program via the store.
As such they incrementally build a reactive control flow graph on demand. 
In addition to read and write dependency tracking their analysis explicitly tracks call effects which triggers a demand for functions stored at that point in the store to be evaluated interprocedurally with new arguments.
However, while they present the theory for a context sensitive analysis, they do not present results for context sensitivity,
and while their approach could be adapted to a demand based setting, their focus is on full program analysis.

@;{Additionally, several incremental analyses have been presented which allow for result invalidation at certain boundaries such as function boundaries.
@citet{stein_demanded_2021}, present one such analysis, however, it requires an initial control flow graph up front and only handles first order functions.
@citet{vanDerPlas:incremental}, present a framework for building modular dependency driven analyses, that incrementally incorporate updates from changes to the source code. 
}

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

\section{Future Work}
\label{sec:future-work}

@;{
This paper presented one strategy for achieving context-sensitive demand CFA, based on the top-$m$-stack-frames context abstraction of $m$-CFA@~cite{dvanhorn:Might2010Resolving}.
@;{
This strategy leads to the Demand $m$-CFA hierarchy which exhibits pushdown precision
(1) with respect to the demand semantics, by virtue of using the \emph{Abstracting Definitional Interpreters}@~cite{darais2017abstracting} implementation approach, and
(2) with respect to the direct semantics, by virtue of using the continuation address identified in \emph{Pushdown for Free}@~cite{local:p4f}.
}
This leads to the Demand $m$-CFA hierarchy, which offers context sensitivity with tunable runtime costs.
We reported the required effort to implement the analysis for Pure Scheme as well as the Koka language server.
We also provided empirical results showing that Demand $m$-CFA provides a large percentage of control flow information and 
a similar number of singleton flow sets as the corresponding exhaustive analysis but at low cost.

\subsection{Future Work} 
}

Having established context sensitivity for Demand CFA,
its primary limitation is its inability to reason about higher-order effectful computation.
To address this limitation, we intend to develop a general operational framework in which a variety of effects can be expressed.
We also intend to
\begin{enumerate*}
\item investigate the tradeoff between precision and the nondetection of dead code within the analysis (occurring during binding resolution);
@;\item develop theories for language features including mutation, exceptions, and continuations,
\item determine how to reuse fixpoint caches between queries while keeping environments as indeterminate as possible to create an incremental analysis@~cite{stein_demanded_2021,vanDerPlas:incremental},
\item consider how selective context sensitivity@~cite{li2020principled} could be realized given the indeterminate environments of our approach
\end{enumerate*}.

@;{
Future work should also investigate interesting tradeoffs exposed by Demand $m$-CFA's cost model including:
\begin{enumerate*}
\item exploring different criteria for terminating queries early,
\item and incrementally running queries with higher context-sensitivity as needed
\end{enumerate*}.
}

\bibliography{paper}

\end{document}
