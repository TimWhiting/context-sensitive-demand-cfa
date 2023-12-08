General comments:

Work on motivating use cases
- Effect handler optimizations?
- Escape Analysis of closures and other things - for stack allocation
- Security Analysis
- Extensible Algebraic Datatypes - remove match when it can only be one due to the dataflow


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

Page 2:
Does Horwitz say that it allows more precision
Second, one can analyze with more precision due to the reduced workload.

Is demand 0CFA the only realization (what about Kimball's dissertation - demand environment analysis)

Line 88 paragraph: Implementation - reference ADI, but also reference the Fixpoint Monad (Maybe also reference the recent fixing abstract interpretation paper)
- More detailed discussion could go into related work
- Got rid of discussion of comparison to DDPA

Page 3:
- contributions:
- 1) a new formalism
- 2) mCFA & soundness
- 3) lightweight -- significance of this needs work
- 4) empirical needs work -- what are the results and what is the significance of them
 - Results 
  - actually implemented in a real language
  - actually integrated into language server
  - actually implemented specialized optimization (that wouldn't be worth a full static analysis)
  - actually don't support the full language and acts conservatively
  - actually run at various points (interleaving between optimizing transformations)
  - (It would be good to point out ability to incorporate a testing framework)

Should we highlight `in`sensitivity with bold instead of italics

Page 4:
The talk about forwarding results might be a bit strange? Maybe just call it filtering the results
Are there other reasons for filtering results

Page 5: Section 3
- Note: Koka doesn't have equality on expression terms so I create labels on demand

Page 6: Fig 1
- Looks good.

Section 4:
The aside (In a context-insensitive analysis, we may represent a closure by the 𝜆 term itself.) - since the environment can be resolved on demand by trace queries on the variables it captures

Presentation of the Ref rule reads a little rough.

- Old: The Ref rule captures the intuition that a reference to a parameter 𝑥 takes on the values of the arguments of each site at which the 𝜆 which binds 𝑥 is called. If the bind metafunction determines the binding configuration of 𝑥—i.e. the body of the 𝜆 term which binds it—to be 𝑒, (𝑒0 𝑒1) is a caller of that 𝜆 term, and 𝑒1 evaluates to 𝜆𝑦.𝑒𝑣, then the reference to 𝑥 evaluates to 𝜆𝑦.𝑒𝑣 as well.
- New: The Ref rule captures the intuition that a reference to a parameter 𝑥 takes on the value of the argument of each site at which the 𝜆 which binds 𝑥 is called. If the bind metafunction determines the lambda 𝜆.𝑥 which binds 𝑥, (𝑒0 𝑒1) is a caller of that lambda term, and 𝑒1 evaluates to 𝜆𝑦.𝑒𝑣, then the reference to 𝑥 evaluates to 𝜆𝑦.𝑒𝑣 as well.

- A judgement 𝐶 [𝑒] ⇒expr 𝐶 ′[(𝑒0 𝑒1)] denotes that [new: the] value of the expression 𝑒 is applied at (𝑒0 𝑒1).



Implementation section:
- Consider reference the fixpoint monad instead ADI (maybe add a more detailed explanation of it in an appendix of my dissertation)

Related Work:
- Reference Amazon's paper and point out the environment problem (they repurpose 1st order backward and forward analyses and string them together, whereas we handle higher order in a manner closer to typical k-cfa).