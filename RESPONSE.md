RESPONSE TO REBUTTAL:
--------

Reviewer C·Aug 8
Dear authors,

We invite you to revise your paper and resubmit it by October 10th. The revised version will be re-reviewed by the same reviewers and either accepted or rejected.  In the revised version, we ask you to:

- Format your paper as 25 LNCS pages, since this is the format for the camera-ready version. (Done though we need to maybe add more to the appendix)
- Improve the framing of the challenge presented and the specific choices made to overcome it. (Done?)
- Clearly and correctly state the forms of the judgments and functions (e.g., bind). In particular, in places where a cursor/zipper data structure is used, the formal model should have a pair of a context and an expression. While you may use the syntax $C[e]$ to represent such pairs, we note that it is ambiguous because $C[C'[e]]$ could either mean $(C[C'], e)$ or $(C, C'[e])$.  We therefore suggest (but not require) that you use different syntax. (Done as far as highlighting goes, but the forms of the judgements are not always stated, and we need to make sure it includes the consideration of contexts).
- Address all other reviewer comments. (WIP: See below)

-------

REBUTTAL:

We thank the reviewers for their insightful comments which will certainly improve the paper.
We are glad that reviewers found that the paper addresses an important problem, is well-written, and presents an elegant formalism. We are grateful that Reviewer A found the presentation “clear and rigorous”, that it “makes a valuable contribution to the field [...], and deserve[s] acceptance.”

Reviewer C comments that the paper lacks “an argument as to why the extension is non-trivial”. We believe the argument is present, but would benefit from improved framing. Specifically, the challenge is identifying a notion of context sensitivity that comports with demand-driven evaluation (for which we found m-CFA-style call-site sensitivity) and representing environments and contexts in a way amenable to the discovery of contextual information inherent in a demand-driven setting (for which we used a de-Bruijn style environment structure allowing incremental contextual instantiation). We will improve the framing of both the challenge presented and the specific choices made to overcome it.

Reviewer C also comments that “the paper does not adequately evaluate the increased precision gained by the more precise analysis”. Our evaluation finds that context sensitivity allows the analysis to narrow many control flow sets to a single inhabitant. This singleton condition is a key criterion to apply standard optimizations like constant propagation and procedure inlining in higher-order languages. Anecdotally, the increased prevalence of singletons has improved its utility as a tool in an IDE as it allows us to hone in on points of interest more directly. We will improve the presentation of the evaluation results to make the significance of the precision increase more clear.

We feel these to be the two most substantial issues raised by reviewers and we believe that they are entirely resolved through the described improvements to presentation. In addition to these improvements, we will apply all reviewer feedback.

We again thank the reviewers for their helpful and constructive comments. We respond to each individual question and point below.

—

We have addressed the other technical comments and questions individually below:

> A: You present your approach as an extension of Demand 0CFA, but it would be interesting to summarize why it would not be easy to convert a standard m-CFA analysis to this setting. What are the main differences in terms of analysis design?

m-CFA includes a variable rebinding step at each function application which is necessary to achieve flat environments giving it its polynomial complexity. Variable rebinding is defined in terms of a central store which demand CFA does not explicitly model. We see interesting future work in determining whether demand m-CFA would benefit from decreased complexity and whether the m-CFA tactic to achieve it is possible to apply.

FIXME: Do we integrate something here in the introduction, discussion on m-CFA or future work?

> A: The related work list some other « demand-driven » approaches like [Midtgaard and Jensen 2008] and Biswas [1997]. Could explain again what is their definition of demand-driven and why yours is different. I did not find this part completely clear.

Both of these works present analyses that analyze the full program. They are demand-driven in the sense that they only analyze program points if they are demanded by other program points, working backwards to discover dependencies required by the end result of the program. Ours on the other hand is demand driven in the sense that it embodies a combination of backwards and forwards flow analysis. This approach is needed to start at arbitrary program points (i.e. for queries from an IDE), and allows for finer grained partial program analysis.

FIXED: Added a few more emphases, and a few small parentheticals.

> B: The analysis is defined for a pure functional language and cannot handle imperative constructs, which limits its applicability.

It is true that the presented analysis does not handle imperative constructs, and this is future work we intend to pursue. However, the presented analysis can still be deployed in programs with imperative constructs. It will produce sound results for flows that don’t experience imperative update and soundly detect when flows do, and alert appropriately. We will make sure this aspect of the analysis is clear in the paper.

FIXME: I've added this to the Evaluation section. It probably could use another read through and slight adjustments.

> B: L110: Consider defining f's body to be something other than x (e.g., x+1). This distinction can help the reader differentiate between the use of x as the parameter of f and its use as its body. 

This is a good point; we will change the example accordingly.

FIXME: THIS DOES NOT WORK WELL WITH THE FLOW / SPACE, maybe we should use superscripts for the intuition section (but that doesn't flow well with the rest of the paper)

> B: L199: How does q_4 propagate information to q_3? These queries consider different calling contexts.

FIXED: and reworded, because the old version was really confusing. Read through again

> B: L419: Please explain how the use of distinct indeterminate contexts (e.g., ?_x) benefits the analysis.

We will include an explanation in the paper proceeding essentially as follows.

Consider the example: (λ(x) ((λ(y) y) (λ(z) z))) where `call_1` labels ((λ(y) y) …)
Without distinct indeterminate contexts, when discovering the refinement <call_1> for the environment <?_y> 
the rules would cause all queries with <?> to be refined by <call_1> even for those queries whose environments whose bindings obviously do not correspond.
In other words the evaluation of the body of `z` would be run in the environment of <call_1> even though that is not statically possible, and would not be attempted when
using <?_y> and <?_z>. This is a clear win in terms of precision and performance, and does not distinguish more contexts than necessary (i.e. does not increase the number of distinguished abstract values), due to the fact that the indeterminate variables in closure environments can be uniquely derived from their lambda.

FIXED: I added a few things to the discussion on designing indeterminate environments and instantiating contexts.

> C: I found figures 9 and 10 almost impossible to read.

We will improve the presentation of figures 9 and 10. In particular, we will make the unit of the x-axis more clear (the amount of gas the analysis is given: see section 8.2) and to what set of queries each statistic corresponds.

FIXED: I added in the captions explicit references to what each axis measures. 

> - C: Please state the forms of all the judgments.  For example, does ⇒exp  in Fig. 1 take two expressions, two contexts and two expressions, one context and two expressions?  What does ⇒find do? It takes a variable and an expression and returns a context?

FIXED: Is this needed with the new highlighting? Explicitly stating the forms takes up quite a bit of room, when all the judgements are almost identical.





----

OUR REFLECTION ON FEEDBACK -- HIGH LEVEL


Want to say
These are the most substantial issues
They weren’t shared by all reviewers
The most expert reviewer had no issues, so it may be an accessibility issue


—

Praise

A: The paper  presents an experimental evaluation.
A: The use of a hierarchy of semantics to prove soundness is particularly nice, as it provides a clear view of the analysis as an abstract semantics.
A: The implementation is also useful for understanding the current scope of the approach, and the ability to run on-demand analysis within an IDE is an attractive feature.

A: The authors have also provided a thorough evaluation of their approach, including both theoretical and experimental results, which helps to validate the effectiveness of their method.

B: Thus, the paper provides both a useful analysis and an insight into the design process of the analysis.

B: The paper provides helpful examples.
B: The experimental evaluation shows that the analysis is almost as precise as an exhaustive analysis in terms of the number of singleton sets it discovers, with a lower effort bound.
C: I think that this paper makes a useful contribution in the area of control flow analysis,...
