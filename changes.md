Changes if need to resubmit:
- [ ] Cite m-CFA is Pushdown
- [ ] Larger / More Benchmarks
- [ ] Reflow some figures
- [ ] Move Reachability to Supplementary Material
- [ ] Get code ready for Supplementary Material
- [ ] Talk about testing / ensuring precision & correctness
- [ ] Talk about implementation in Koka
- [ ] Talk about & benchmark where m-CFA gains precision (k-cfa benchmarks do not make sense, whereas eta is a particularly simple example that shows that we do in fact gain precision)
- [ ] Highlight those simple cases where we obviously do gain precision, figure out why even regular exponential $m$-CFA doesn't gain precision for other programs
- [ ] Potentially check for reachability in terms of recursive application of expr.



Larger changes:

Section 11 will need updating

Focus on Introduction Elimination forms instead maybe, (can we formalize it this way, and provide the specialization to lambda calculus and ADTs separately?)

Consider adding the environment information in Lightweight Demand-mCFA as a non-memoized piece, but use the original Demand-mCFA when that information is unavailable. 

Pushdown precision section can be cut down some

Consider putting the demand evaluation section in an appendix / separate technical report if we need the space

Timestamp section (is it necessary?)

Code examples need to be adjusted - reflowed?

Maybe add implementation considerations section - could relegate details to a technical report but should mention
- Datatype representation and handling
- Top level bindings / separate compilation
- Preprocessing with checking if a function is actually ever called (to not run eval if it is dead code) 

Section 6. are we missing a p^ on succm definition
Just before in the definitions, are we really limiting to m prior to appending p'?






Questions? 
\begin{enumerate}
- [ ] Should we do variable timeouts based on 'complexity' of query? 
- [ ] For example lambda queries are constant time always. Is there any insights on what makes a query 'complex'?

Anticipated Questions to Answer?
- [x] How does caching work?
- [x] How does the pricing model work?
- [x] Is the pricing model effective?
- [x] What is the breakdown of queries (obviously individual lambdas will be instantaneous)?
- [x] What benchmarks were used and why those ones?
- [x] How does it scale to program size?
- [ ] Is there exponential blowup?

Desired Takeaways
- [x] The pricing model allows you to choose what price you are willing to pay for any particular type of flow information
- [ ] Reusing caches discovers instantiated environments - which can cause exponential blowup (same as regular exponential m-cfa).
- [ ] Many non-trivial queries can be answered quickly without fully-determined environments (i.e. what percentage of queries are not refined further?)

Plots
- [ ] x - cumulative time, y % queries answered (sort by time to completion), lines $m$-CFA, Demand at various timeouts and cached / non-cached
- [ ] One plot (simple + more complex example), same plot axes as above, but with dots colored in type of query, shows simple and complex examples have similar proportion of queries answered fast?


FEEDBACK from prior submissions
- paper's core idea is unclear => the core idea is a context representation which can model unknown information (via variables) and abstract information.
  - also, the fact that two unknowns can have the same name is powerful—we know they must be identical.
    is this useful for environment analysis? (just mention that it could be.)
- "Are you making repeated queries until the model is sound for all call sites? This is an all-important detail!"
  => this is obviously a misconception, but it's my fault.


Lower Priority / Future Work:
- [ ] Create tests for each path in the demand / mcfa code?
- [ ] Consider adding prepass for determining reachability
  - [ ] Recursive `expr` (similar to the delegation in call, but don't add refinements - (is there any case we would want to add refinements?))
- [ ] Work on results 
  - [ ] Need to demonstrate adaptability of queries (i.e. if not precise, increase precision and try again), what kind of graph or visual would be useful here?

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