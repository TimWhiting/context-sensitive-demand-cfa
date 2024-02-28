TODO: 
Work on Paper!!!
- [ ] Rewrite Thesis




Questions? 
\begin{enumerate}
\item Should we do variable timeouts based on 'complexity' of query? 
  For example lambda queries are constant time always. Is there any insights on what makes a query 'complex'?
\end{enumerate}

Anticipated Questions to Answer?
\begin{enumerate}
\item How does caching work? ✓
\item How does the pricing model work? ✓
\item Is the pricing model effective? ✓
\item What is the breakdown of queries (obviously individual lambdas will be instantaneous)? ✓
\item Is there exponential blowup? ✓
\item What benchmarks were used and why those ones?
\item How does it scale to program size? ✓
\item How is precision compared to exhaustive? ✓
\end{enumerate}

Desired Takeaways
\begin{enumerate}
\item The pricing model allows you to choose what price you are willing to pay for any particular type of flow information ✓
\item Reusing caches discovers instantiated environments - which can cause exponential blowup (same as regular exponential m-cfa). ✓
\item Many non-trivial queries can be answered quickly without fully-determined environments (i.e. what percentage of queries are not refined further?) ✓
\end{enumerate}

Plots
\begin{enumerate}
\item x - cumulative time, y % queries answered (sort by time to completion), lines $m$-CFA, Demand at various timeouts and cached / non-cached
\item Another one with larger $m$ (3 / 4)
\item One plot (simple + more complex example), same plot axes as above, but with dots colored in type of query, shows simple and complex examples have similar proportion of queries answered fast?
\tw{Should I color code points by kind of query?, and do points? How to represent all the points essentially on top of each other at the beginning}
\item Another one with larger $m$ (3 / 4)?
\item Selective increase in precision based on whether the result is singleton flow set yet (up to timeout), start m=0?
\end{enumerate}

Needed Data
\begin{enumerate}
\item For t timeout what y% of queries are answered prior to cumulative time X - sorted cumulative time
\item For every eval query Ce rho, how many refined queries are made & what percent are fully refined?
\item Number of eval queries for each program (proxy measure of program size)
\item Number of results in the cache & number of refinements in the cache for each query 
\item Classification for each query - app, lambda, etc...
\item Number of eval / expr / refine in the cache - per query?
\item Benchmarks for all original programs "ack", "blur", "cpstak", "deriv", "eta",
 "facehugger", "flatten", "kcfa-2/3" "loop2-1" "map" "mj09", "primtest", "regex", "rsa", "sat-1/3" "tak"
\item Thorough analysis of sat-1/sat-2?
\item Larger timeouts / larger $m$?
\end{enumerate}




Lower Priority / Future Work:
- [ ] Create tests for each path in the demand / mcfa code?
- [ ] Consider adding prepass for determining reachability
  - [ ] Recursive `expr` (similar to the delegation in call, but don't add refinements - (is there any case we would want to add refinements?))
- [ ] Work on results 
  - [ ] Need to demonstrate adaptability of queries (i.e. if not precise, increase precision and try again), what kind of graph or visual would be useful here?
  - [ ] Consider higher $m$s (i.e. m=5) - unlikely time-worth-it unless lightweight?

FEEDBACK from prior submission
- include 2CFA as well as 1CFA => perhaps even consider, e.g. 5CFA as defensive program analysis does
- evaluation doesn't show practicality => be concrete about what is going on so that even the less-attentive reader will pick it up
- motivation of context sensitivity is not clear => show the pathology of 0CFA forgetting and discuss the counter-intuitive result that more precision can mean less work is done
- paper's core idea is unclear => the core idea is a context representation which can model unknown information (via variables) and abstract information.
  - also, the fact that two unknowns can have the same name is powerful—we know they must be identical.
    is this useful for environment analysis? (just mention that it could be.)
- "Are you making repeated queries until the model is sound for all call sites? This is an all-important detail!"
  => this is obviously a misconception, but it's my fault.
- talk about how to integrate defensive program analysis.

show a functional program fragment, say that it is embedded within a larger program, and say that we want some piece of information about a particular subexpression.
we could apply CFA to the whole program, but CFA is expensive.
(obviously, we probably want information about many different locations of the program, spread throughout the program.)
this subexpression has free variables.


General comments:

Page 3:
- contributions:
- 4) empirical needs work -- what are the results and what is the significance of them

Future work:
  - actually implemented in a real language
  - actually integrated into language server
  - actually implemented specialized optimization (that wouldn't be worth a full static analysis)
  - actually don't support the full language and acts conservatively
  - actually run at various points (interleaving between optimizing transformations)
  - (It would be good to point out ability to incorporate a testing framework)

WILD FUTURE IDEAS:


Page 2:
Does Horwitz say that it allows more precision
Second, one can analyze with more precision due to the reduced size of `N`.

Additional Motivation:
- Knowing if an argument is used and effect free could allow for strict evaluation of typically lazy variables

Consider approach where we cut off early more imprecise portions of the analysis and focus on instantiating earlier
- How about an approach where we check if a value is used prior to doing any forward evaluation on it? 
- This way, we can avoid doing any work on values that are not used, and find dead code as a side effect.
- This should give us more complete instantiations of environments potentially reducing the number of less determinate queries that we do.

Also consider not instantiating further or refining when a less precise instantiation already has a precise result 
- (i.e. closure set of 1, or a single constructor or number context) 
- This could save work in cases where we want more precision, but not equally everywhere (i.e. we want n=2 precision but some things can be resolved with n=1)

Consider a query flow that allows for bootstrapping a lightweight control flow graph that can be later refined by a more precise analysis (i.e. a hybrid approach) 
- lets say that later with addition of integer ranges we determine more precise information about control flow
- can we subtract from the control flow graph? 
- (i.e. if we know that a particular branch is not taken, can we remove it from the control flow graph?)