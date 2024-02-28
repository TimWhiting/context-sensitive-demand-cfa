TODO: 
Work on Paper!!!
- [ ] Generate results for more r6rs programs
- [ ] Fix mcfa returning bottom on `ormap`? in `tic-tac-toe` - maybe find the issue while doing the above
- [ ] Include error bars in the plots (for mcfa for the trials, and for demand-mcfa for the trials? and for across programs)
- [ ] Work on precision results (i.e. %singletons)
- [ ] Remove discussion of lightweight
- [ ] Move discussion of DDPA
- [ ] Rewrite Thesis
- [ ] For precision, we should really compare an increase from 0-CFA instead of comparing to m-CFA.
- [ ] Update implementation code sample to use regular m-CFA instead of lightweight formulation

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