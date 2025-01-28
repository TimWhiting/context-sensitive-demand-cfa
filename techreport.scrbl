#lang scribble/text
@(require "base.rkt"
          "syntax.rkt"
          "bib.rkt"
          "mathpar.rkt")
@(define-syntax-rule (omit . rst) (void))
\documentclass[runningheads]{llncs}
\usepackage[T1]{fontenc}

\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{mathpartir}
\usepackage{xcolor}
\definecolor{light-gray}{gray}{0.8}
\usepackage{textgreek}
\usepackage{wrapfig}
\usepackage{alltt}
\usepackage[inline]{enumitem}
\usepackage{graphicx}
\graphicspath{{evaluation/plots}}
\usepackage{subcaption}

\setlength\fboxsep{0pt}
\newcommand{\highlightout}[1]{%
  \colorbox{gray!20}{$\strut\displaystyle#1$}}
\newcommand{\highlightin}[1]{%
  \colorbox{white}{$\strut\displaystyle#1$}}
  
\begin{document}

\title{Context-Sensitive Demand-Driven Control-Flow Analysis}

\author{
      Tim Whiting\orcidID{0000-0003-4016-1071} \and Kimball Germane\orcidID{0000-0003-4903-5645}
}

\institute{
Brigham Young University, Provo UT 84601, USA\\
\email{tim@"@"whitings.org}\\
\email{kimball@"@"cs.byu.edu}
}

\maketitle

\begin{abstract}

By decoupling and decomposing control flows, 
demand control-flow analysis (CFA) resolves only the flow segments determined necessary to produce a specified control-flow fact.
It therefore presents a more flexible interface and pricing model than typical CFA, 
making many useful applications practical.
At present, the only realization of demand CFA is the context-insensitive Demand 0CFA.
Typical mechanisms for adding context sensitivity are not compatible with the demand setting because the analyzer is dispatched at arbitrary program points in indeterminate contexts.
We overcome this challenge by identifying a context suitable for a demand analysis and designing a representation thereof that allows it to model incomplete knowledge of the context.
On top of this design, we construct Demand $m$-CFA, a context-sensitive demand CFA hierarchy.
With
the attractive pricing model of demand analysis
and
the precision offered by context sensitivity,
we show that Demand $m$-CFA can
replace its exhaustive counterpart in compiler backends
and
integrate into interactive tools such as language servers.

\keywords{Demand CFA, m-CFA, Context-Sensitivity, Control Flow Analysis}

\end{abstract}

\section{Demand $m$-CFA Correctness}
\label{techreport:demand-evaluation}
\subsection{Demand $\infty$-CFA and Demand Evaluation}

@(require (rename-in (prefix-in mcfa- "demand-mcfa.rkt")))
@(require (prefix-in demand- "demand-evaluation.rkt"))
@(define env-domain "\\mathit{Env}")
@(define var-domain "\\mathsf{Var}")
@(define cursor-domain "\\mathsf{Cursor}")
@(define (clause-label label) (list "\\textit{" label "}"))

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
@(demand-ρ) \in @|env-domain|     &= \mathit{Addr}^{*} \\
@(demand-cc) \in \mathit{Call} &= \mathit{App} \times @|env-domain| &
n \in \mathit{Addr}              &= \mathbb{N}
\end{align*}
A store is a pair consisting of a map from addresses to calls and the next address to use;
the initial store is $(\bot,0)$.

Figure~\ref{fig:demand-evaluation} presents the definitions of @|demand-eval-name|, @|demand-expr-name|, and @|demand-call-name|.
\begin{align*}
@|demand-eval-name|, @|demand-expr-name|, @|demand-call-name|\; \subseteq @|cursor-domain| \times @|env-domain| \times @(demand-σ) \times @|cursor-domain| \times @|env-domain| \times @(demand-σ) \\
@|demand-find-name|\; \subseteq @|var-domain| \times @|cursor-domain| \times @|env-domain| \times @(demand-σ) \times @|cursor-domain| \times @|env-domain| \times @(demand-σ)
\end{align*}
\begin{figure}
@mathpar[demand-parse-judgment]{
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
iff\,
$\sigma(n_0) = \bot = \sigma(n_1)$
or
$\sigma(n_0)=(@(cursor (app (e 0) (e 1)) (∘e)),@(demand-ρ 0))$,
$\sigma(n_1)=(@(cursor (app (e 0) (e 1)) (∘e)),@(demand-ρ 1))$, and
@(demand-≡σ (demand-σ) (demand-ρ 0) (demand-ρ 1)).
If the environments are isomorphic, then all instances of the known environment are substituted with the discovered environment in the store, ensuring that queries in terms of the known are kept up to date.
This rule corresponds directly to the instantiation relation of Demand $m$-CFA.

\subsection{Demand Evaluation Equivalence}

@(require (rename-in (prefix-in combined- "combined.rkt")))

In order to show a correspondence between Demand $\infty$-CFA and Demand Evaluation,
we establish a correspondence between the environments of the former and the environment--store pairs of the latter, captured by the judgment @combined-parse-judgment{ρ ⇓ ρ σ} defined by the following rules.
\begin{mathpar}
\inferrule
{ @combined-parse-judgment{cc-1 F n-1 σ} \\
  \dots \\
  @combined-parse-judgment{cc-k F n-k σ}
  }
{ @combined-parse-judgment{ρ-is ⇓ ρ-is σ}
  }


\inferrule
{ }
{ @combined-parse-judgment{() R () σ}
  }

\inferrule
{ @combined-parse-judgment{app::cc F n σ}
  }
{ @combined-parse-judgment{app::cc R n::ρ σ}
  }

\inferrule
{ @combined-parse-judgment{σ(n) = ⊥}
  }
{ @combined-parse-judgment{? F n σ}
  }

\inferrule
{ @combined-parse-judgment{σ(n) = (app,ρ)} \\
  @combined-parse-judgment{cc R ρ σ}
  }
{ @combined-parse-judgment{app::cc F n σ}
  }

\end{mathpar}
This judgment ensures that each context in the Demand $\infty$-CFA environment matches precisely with the corresponding address with respect to the store:
if the context is indeterminate, the address must not be mapped in the store;
otherwise, if the heads of the context are the same, the relation recurs.

Now it is straightforward to express the equivalence between the Demand $\infty$-CFA relations and Demand Evaluation.

@(require (prefix-in combined- "combined.rkt"))
\begin{theorem}[Evaluation Equivalence]
If
@combined-parse-judgment{ρ₀ ⇓ ρ₀ σ₀}
then
@mcfa-parse-judgment{C[e] ρ₀ ⇓∞ C'[λx.e] ρ₁}
iff\,
@demand-parse-judgment{C[e] ρ₀ σ₀ ⇓ C'[λx.e] ρ₁ σ₁}
where
@combined-parse-judgment{ρ₁ ⇓ ρ₁ σ₁}.
\end{theorem}

\begin{theorem}[Trace Equivalence]
If
@combined-parse-judgment{ρ₀ ⇓ ρ₀ σ₀}
then
@mcfa-parse-judgment{C[e] ρ₀ ⇒∞ C'[(e₀ e₁)] ρ₁}
iff\,
@demand-parse-judgment{C[e] ρ₀ σ₀ ⇒ C'[(e₀ e₁)] ρ₁ σ₁}
where
@combined-parse-judgment{ρ₁ ⇓ ρ₁ σ₁}.
\end{theorem}

\begin{theorem}[Caller Equivalence]
If
@combined-parse-judgment{ρ₀ ⇓ ρ₀ σ₀}
then
@mcfa-parse-judgment{C[e] ρ₀ ⇐∞ C'[(e₀ e₁)] ρ₁}
iff\,
@demand-parse-judgment{C[e] ρ₀ σ₀ ⇐ C'[(e₀ e₁)] ρ₁ σ₁}
where
@combined-parse-judgment{ρ₁ ⇓ ρ₁ σ₁}.
\end{theorem}

These theorems are proved by induction on the derivations, corresponding instantiation of environments on the Demand $\infty$-CFA side with mapping an address on the Demand Evaluation side.

\section{Detailed Precision Results}
\label{techreport:results}

\begin{figure}[t]
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_legendx.png}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_blur.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_eta.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_kcfa2.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_kcfa3.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_loop2-1.pdf}
\end{subfigure} 
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_mj09.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_primtest.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_regex.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_rsa.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_sat.pdf}
\end{subfigure}
\begin{subfigure}[t]{.245\linewidth}
\includegraphics[width=\linewidth]{important-queries-answered_scheme2java.pdf}
\end{subfigure}
\caption{
The number of singleton flow sets (y-axis) found by a Demand $m$-CFA analysis given gas allocated per query (x-axis).
Dashed lines represent the baseline number of singleton flow sets found by an exhaustive exponential $m$-CFA analysis with a 10 minute timeout.
\texttt{scheme2java} does not have results for $m>=2$ exhaustive $m$-CFA due to timing out.
}
\label{fig:dmcfa-detailed-answers}
\end{figure}

Figure~\ref{fig:dmcfa-detailed-answers} shows the number of singleton flow sets found by Demand $m$-CFA for each program individually.
As can be seen, the majority of programs reach the corresponding exhaustive $m$-CFA results at low effort. 
Notably, increasing $m$ doesn't drastically increase the cost. 
This demonstrates that, due to its cost model, Demand $m$-CFA can run at much higher levels of $m$ than is practical in exhaustive analyses, obtaining more precise results.
On \texttt{primtest}, and to a lesser degree \texttt{rsa}, Demand $m$-CFA issues queries on pieces of dead code, resulting in additional singleton flow sets.
Additionally, due to the reachability assumption explained previously in the results section, we see precision loss in cases like \textt{blur}
We plan to investigate ways to overcome these limitations in future work.


\bibliographystyle{splncs04}

\bibliography{paper}

\end{document}