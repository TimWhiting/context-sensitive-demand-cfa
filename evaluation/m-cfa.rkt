#lang racket/base
(require (rename-in "table-monad/main.rkt"))
(require "config.rkt" "static-contexts.rkt" "abstract-value.rkt"
         "syntax.rkt" "envs.rkt" "debug.rkt" "primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list
         racket/set)
(provide meval store)

; Creates a list of m xs
(define (repeat x m)
  (map (lambda (_) x) (range m))
  )

; Sequences a list in the monad and returns a list of results
(define (seql xss)
  (match xss
    ['() (unit '())]
    [(cons x xs)
     (>>= x
          (λ (r)
            (>>= (seql xs)
                 (λ (rs)
                   (unit (cons r rs))
                   ))))]))

; Defines the store, which is a product of clos/constructor like things and literals
(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ⊥)

; Specifies using litbottom lit-lte and lit-union for the union of literal elements in the store
(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

; Extends the variable `x` uniquely
; identified by the context `Ce` / constructor it was bound at
; in environment `env` with the value `val`
(define (((extend-store x bindCe env val) k) s)
  (assert-right-value-mcfa val)
  ; (pretty-print `(extend-store ,x ,(show-simple-ctx bindCe) ,(show-simple-env env)))
  ((k #f) ((product-absorb-lit (store (list x bindCe env)) val) s))
  )

; Looks up an item in the store
(define (get-store x Ce env)
  ; (pretty-print `(get-store ,x ,(show-simple-ctx Ce) ,(show-simple-env env)))
  (store (list x Ce env))
  )

; Gets an element from the store by looking up the binding site of x (or where it was rebound to)
; Then returns into the monad based on the type of the result from the store
(define (get-store-val x Ce env)
  (>>= (get-store x Ce env)
       (λ (val)
         (match val
           [(product/set (list Ce ρ)) (clos Ce ρ)]
           [(product/lattice l) (lit l)]
           ))
       )
  )

; Get the uniquely identifying binding context
(define (get-binding-context x Ce ρ)
  (>>=
   ((bind x) Ce ρ)
   (λ (Cex px i)
     ;  (pretty-print `(bind ,(show-simple-ctx Cex)))
     (match i
       [-1 (unit Ce ρ i)]
       [_
        (match Cex
          [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
           ;  (pretty-print 'let-bin)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  (unit Cex px i)))]
          [(cons `(let-bod ,_ ,_ ,_) _)
           ;  (pretty-print 'let-bod)
           (>>= (>>= (out Cex ρ) (bin i))
                (λ (Cex p)
                  (unit Cex px i)))]
          [_ (unit Cex px i)]
          )])
     )))

; Looks up a variable from the store differently based on the kind of analysis
; Delegates to `get-store-val` for the rest
(define (store-lookup x Ce ρ)
  (>>=
   (get-binding-context x Ce ρ) ; Find what x is bound to
   (λ (Cex ρx i)
     (match i
       [-1 (clos Ce ρ)] ; If it is a constructor return directly
       [_
        (match (analysis-kind)
          ['rebinding (get-store-val x Cex ρ)]
          ['exponential (get-store-val x Cex ρx)]
          )
        ] ; Otherwise lookup the rebinding site from the current context.
       ) ; bound ctx
     )
   )
  )

; Same as above but inline the (get-rebindce from get-store-val instead of actually looking it up)
; Only used for set!
(define (lookup-addr x Ce ρ)
  ; (pretty-print `(lookup-addr ,x ,(show-simple-ctx Ce)))
  (>>=
   (get-binding-context x Ce ρ) ; Find what x is bound to
   (λ (Cex ρx i)
     (match i
       [-1 (error 'should-not-happen)] ; Disallow set! on constructors
       [_ (match (analysis-kind)
            ['rebinding (unit x Cex ρ)]
            ['exponential (unit x Cex ρx)]
            )] ; Otherwise lookup the rebinding site from the current context.
       ) ; bound ctx
     )
   ))

; Looks up a symbol
(define (symbol-lookup x Ce ρ)
  ; (pretty-print `(lookup ,(show-simple-ctx Ce) ,x ,(show-simple-env ρ)))
  (match (lookup-primitive x) ; See if it is a primitive
    [#f
     (match ((lookup-constructor x) Ce) ; Check if it is a constructor
       [#f (store-lookup x Ce ρ)] ; Otherwise lookup in the store / environment
       [Ce
        ; (pretty-print `(constructor-found ,x ,(show-simple-ctx Ce)))
        (clos Ce (top-env))] ; Is constructor
       )
     ]
    [Ce (clos Ce (top-env))] ; Primitives return the primitive in this environment
    ))

; Evaluates a sequence of arguments
(define (eval* args)
  (seql (map (λ (a) (apply meval a)) args))
  )

; Evaluates a sequence of arguments, while rebinding in a new environment and binding location
(define (evalbind* vars binds ρnew args)
  ; (pretty-print `(evalbind ,vars ,(show-simple-env ρnew)))
  (seql (map (λ (var bind arg)
               (>>= (apply meval arg)
                    (λ (res)
                      (extend-store var bind ρnew res))
                    ))
             vars binds args)))

; Binds the bindings `bindsCe` with variable identifiers `vars` in the environment `ρ` to the corresponding values from `vals`
(define (bind-args vars bindsCe ρ vals)
  ; (pretty-print `(bind-args ,vars ,(show-simple-env ρ)))
  (if (and (equal? (length vars) (length vals)) (equal? (length vars) (length bindsCe)))
      (seql (map
             (λ (var bind val)
               (extend-store var bind ρ val)
               ) vars bindsCe vals))
      ⊥ ; An error when a closure flows to a place where the number of bindings doesn't match the number of arguments
      ))

(define (rebind-vars vars Ce ρ ρnew)
  ; (pretty-print `(rebind-vars ,(show-simple-ctx Ce) ,vars ,(show-simple-env ρ) ,(show-simple-env ρnew)))
  (seql
   (map
    (λ (var)
      (>>= (get-binding-context var Ce ρ)
           (λ (Ce _ __) ; Uniquely identifies
             (>>= (get-store-val var Ce ρ)
                  (λ (v)
                    (extend-store var Ce ρnew v))))
           )) vars)))

(define (bins Ce ρ binds)
  (map
   (λ (i) ((bin-e i) Ce ρ))
   (range (length binds))))

(define (f-args Ce ρ as)
  (map
   (λ (i) ((ran-e i) Ce ρ))
   (range (length as))))

; demand evaluation
(define-key (meval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ; (print-eval-result
  ;  `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ))
  ;  (λ ()
  ;  (pretty-print Ce)
  ;  (pretty-print `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ)))
  (check-result
   assert-right-value-mcfa
   (match Ce
     [(cons _ #t) (truecon)] ; Return a true value
     [(cons _ #f) (falsecon)] ; Return a false value
     [(cons _ (? number? x)) (lit (litnum x))] ; Return a literal number
     [(cons _ (? string? x)) (lit (litstring x))] ; Return a literal string
     [(cons _ (? char? x)) (lit (litchar x))] ; Return a literal string
     [(cons _ (? symbol? x)) (symbol-lookup x Ce ρ)] ; Lookup the symbol uniquely identified by it's binding context and environment
     [(cons _ `(λ ,_ ,_)) (clos Ce ρ)] ; Return a closure value
     [(cons _ `',x)
      (if (symbol? x)
          (lit (litsym x))
          (error 'quoted-non-symbol (pretty-display `',x)))
      ] ; Return a quoted value
     [(cons _ `(lettypes ,_ ,_)) (>>= (bod Ce ρ) meval)] ; Evaluate the body of a lettypes declaration
     [(cons _ `(let ,binds ,_))
      (define bin-ce-p (bins Ce ρ binds))
      ; Evaluate the arguments
      (>>= (eval* bin-ce-p)
           (λ (evaled-binds)
             ; Then bind the arguments to their bindings in this environment
             (>>= (bind-args (map car binds) (map car bin-ce-p) ρ evaled-binds)
                  (λ (_) ; Then evaluate the body
                    (>>= (bod Ce ρ) meval)))))]
     [(cons _ `(letrec ,binds ,_))
      (define bin-ce-p (bins Ce ρ binds))
      ; Scheme rules state that the recursive definitions should not depend on order
      ; and shouldn't reference each other until they have all been initialized
      ; (as is often the case with recursive lambdas), as such we treat just like normal let
      ; Only the bind rule changes
      (>>= (eval* bin-ce-p)
           (λ (evaled-binds)
             (>>= (bind-args (map car binds) (map car bin-ce-p) ρ evaled-binds)
                  (λ (_)
                    (>>= (bod Ce ρ) meval)))))]
     [(cons _ `(let* ,binds ,_))
      (define bin-ce-p (bins Ce ρ binds))
      (>>= (evalbind* ; Evaluate the bindings in order binding in the environment as you go
            (map car binds)
            (map car bin-ce-p)
            ρ
            bin-ce-p)
           (λ (_) ; Then evaluate the body
             (>>= (bod Ce ρ) meval)))]
     [(cons _ `(letrec* ,binds ,_))
      (define bin-ce-p (bins Ce ρ binds))
      ; Evaluate the bindings in order binding in the environment as you go
      (>>= (evalbind*
            (map car binds)
            (map car bin-ce-p)
            ρ
            bin-ce-p)
           (λ (_)
             (>>= (bod Ce ρ) meval)))]
     ; For match clauses
     [(cons _ `(match ,_ ,@clauses))
      (>>=eval (>>= (focus-match Ce ρ) meval) ; Evaluate the scrutinee
               (eval-con-clause Ce ρ clauses 0) ; For closure/con results match constructors
               (eval-lit-clause Ce ρ clauses 0))] ; Otherwise match literal clauses
     [(cons C `(app set! ,var ,_)) ; For setting a variable
      (>>= (lookup-addr var Ce ρ) ; Lookup the variable binding address
           (λ (var bindVarCe px)
             (define rhs (car ((ran-e 1) Ce ρ)))
             (>>= (meval rhs ρ) ; Evaluate the rhs
                  (λ (res)
                    ;  (pretty-print (show-simple-ctx bindVarCe))
                    ; Add the result to the store at the binding
                    (>>= (extend-store var bindVarCe px res)
                         (λ (_) ; Return void
                           (voidv)
                           ))))))
      ]
     [(cons C `(app ,f ,@as)) ; For an application
      (>>=clos ; TODO: Could this result in a symbol representing a top level application?
       (>>= (rat Ce ρ) meval) ; Evaluate the operator
       (λ (lam lamρ)
         ;  (pretty-print 'before-args)
         (define args-ce-p (f-args Ce ρ as)) ; Get the arguments
         ;  (pretty-print 'after-args)
         (>>= (eval* args-ce-p) ; Evaluate the arguments
              (λ (evaled-args)
                (match lam
                  [`(prim ,_ ,_) ; If the operator is a primitive apply it
                   (apply-primitive lam C ρ evaled-args)]
                  [(cons _ `(λ ,xs ,bod)) ; If it is a lambda
                   ; (pretty-print `(lam ,xs ,(show-simple-ctx lam)))
                   (>>= (bod-enter lam Ce ρ lamρ)
                        (λ (bodCe ρ-new) ; Get the body
                          (>>=
                           ; Bind the arguments to the lambda variables
                           (bind-args xs (repeat bodCe (length xs)) ρ-new evaled-args)
                           (λ (_)
                             (match (analysis-kind)
                               ; If it is exponential just evaluate the body in the new environment
                               ['exponential (meval bodCe ρ-new)]
                               ; Otherwise we need to also bind the free variables by looking them up in the lambda's environment
                               ; and rebinding in the new extended environment?
                               ['rebinding
                                ; Free variables are the freevars of the body, minus the bound variables, primitives, and constructors
                                (define frees (set->list (set-subtract (free-vars `(λ ,xs ,bod)) (apply set xs) primitive-set (constructors bodCe ρ-new))))
                                (>>= (rebind-vars frees bodCe lamρ ρ-new)
                                     (λ (_); Then evaluate the body
                                       (meval bodCe ρ-new)))]
                               ))))
                        )]
                  [(cons C `(typedef (,con ,@conargs))) ; For constructors
                   ; (pretty-print `(constructor? ,con ,conargs))
                   (if (or (equal? con #t) (equal? con #f) (symbol? con)) ; Ensure the constructor is a #t #f or symbol
                       (if (= (length as) 0) ; If the constructor has no arguments
                           (clos `(con ,con) (top-env)) ; Just return the constructor in the top-env
                           ; Otherwise bind the constructor arguments using their unique syntactic contexts
                           (>>= (bind-args (repeat 'con (length as)) (map car args-ce-p) ρ evaled-args)
                                (λ (_)
                                  ;  (pretty-print `(returning-con ,con ,(show-simple-ctx Ce)))
                                  (clos `(con ,con ,Ce) ρ)))
                           )
                       ⊥ ; (error 'invalid-rator (pretty-format `(invalid-rator ,(show-simple-ctx Ce) ,(show-simple-ctx lam))))
                       )
                   ]
                  [`(con ,con ,@Ce)
                   ;(pretty-print (show-simple-ctx Ce))
                   (errorv "invalid-rator")
                   ]
                  [_
                   (pretty-print (show-simple-ctx Ce))
                   (errorv "invalid-rator")
                   ]
                  ))))

       )
      ]
     ; Otherwise throw an error
     [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
     )))
;  #t ))

; Looks up the constructor values requested in a match statement
; Ces represents the binding site of each argument of the constructor application that flowed to this location
(define (lookup-constructor-val Ce ρ)
  (get-store 'con Ce ρ))

; Evaluate match clauses that could match a constructor / closure value
(define ((eval-con-clause parent parentρ clauses i) ce ρ)
  ; (pretty-print `(eval-con-clause ,(show-simple-ctx parent) ,(show-simple-ctx ce)))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce ρ) ; If the clause pattern matches
          (λ (matches)
            (match matches
              [(list vars vals) ; Matches and binds variables
               (define clauseCe (car ((match-clause-e i) parent parentρ)))
               ; Bind the corresponding pattern variables to the values they matched with
               (>>= (bind-args vars (repeat clauseCe (length vars)) parentρ vals)
                    (λ (_) ; Then evaluate the clause it matched
                      (>>= ((match-clause i) parent parentρ) meval)))]
              [#f ((eval-con-clause parent parentρ clauses (+ i 1)) ce ρ)] ; Doesn't match, try the next one
              [#t (>>= ((match-clause i) parent parentρ) meval)] ; Matches, but doesn't bind anything just evaluate the clause
              )
            ))]
    [_ ⊥] ; If it doesn't match any clauses return bottom
    ))

; Check to see if any clauses match a literal value
(define ((eval-lit-clause parent parentρ clauses i) lit)
  ; (pretty-print `(eval-lit-clause))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit) ; Check the pattern
          (λ (matches)
            (match matches
              [#f ((eval-lit-clause parent parentρ clauses (+ i 1)) lit)] ; If it doesn't match try the next one
              [#t (>>= ((match-clause i) parent parentρ) meval)] ; If it does match with no binding evaluate the body
              [(list vars vals) ; If it matches and binds a variable
               (define clauseCe (car ((match-clause-e i) parent parentρ)))
               ; Bind the variables to the corresponding arguments
               (>>= (bind-args vars (repeat clauseCe (length vars)) parentρ vals)
                    (λ (_)
                      ; And evaluate the body
                      (>>= ((match-clause i) parent parentρ) meval)))
               ])))]
    [_ ⊥]
    ))

; A pattern matches a value if it matches a literal or closure
(define (pattern-matches pat val)
  (match val
    [(product/lattice l) (pattern-lit-matches pat l)]
    [(product/set (list Ce ρ)) (pattern-con-matches pat Ce ρ)]
    )
  )

; A pattern matches a literal
(define (pattern-lit-matches pattern lit2)
  (match pattern
    ; if the pattern is a symbol (variable binding)
    [(? symbol? pat) (unit (list (list pat) (list (product/lattice lit2))))]
    ; If the literal is equal to the pattern's literal
    [lit1 (unit (equal? (to-lit lit1) lit2))]
    ))

; A pattern matches a constr/closure
(define (pattern-con-matches pattern Ce ρ)
  (match pattern
    [`(,con ,@subpats) ; If the pattern is a constructor pattern
     (match Ce
       [`(con ,con1) ; if it is a singleton constructor
        (if (eq? con con1)
            (unit #t)
            (unit #f))
        ] ; It either matches or doesn't (no binding)
       [`(con ,con1 ,Ce) ; If it is a constructor with arguments
        (define args (map (lambda (i) (car ((ran-e i) Ce ρ))) (range (length (args-e Ce))))) ; Get the argument locations
        ; If the constructors are equal and the number of arguments matches the number of subpatterns
        (if (not (and (equal? con con1) (equal? (length args) (length subpats))))
            (unit #f) ; Doesn't have the same number of arguments and subpatterns, or are different constructor tags
            (let loop ([subpats subpats] [args args]) ; For each subpattern and value
              (if (empty? subpats) (unit #t) ; If the subpatterns are empty then it always matches
                  (>>= (lookup-constructor-val (car args) ρ) ; Lookup the argument value from the store
                       (λ (val)
                         (>>= (pattern-matches (car subpats) val) ; Otherwise check if the first subpattern matches the first value
                              (λ (res)
                                (match res
                                  [#f (unit #f)] ; If it doesn't then the whole thing will not match
                                  [#t (loop (cdr subpats) (cdr args))] ; If it does, but doesn't bind anything then return it always matches
                                  [(list carbinds carvals) ; Otherwise it binds some variables to some values
                                   (>>= (loop (cdr subpats) (cdr args)) ; Loop on the rest of the bindings
                                        (λ (ress)
                                          (match ress ; If the rest don't match
                                            [#f (unit #f)] ; Return it doesn't match
                                            [#t (unit (list carbinds carvals))] ; The rest always matches, just add the matches from the current subpattern
                                            [(list binds vals) ; More bindings and values from other subpatterns
                                             (unit (list (append carbinds binds) (append carvals vals)))])
                                          ))
                                   ]))
                              ))))))
        ]
       [_ ⊥] ; Symbol or other non-constructors
       ;   [(cons C `',x) ; A quoted symbol match?
       ;   (unit (and (eq? 0 (length subpats)) (eq? `',x con)))
       ;   ]
       ;  [Ce
       ;   (if (equal? pattern `(#t)); Truthy
       ;       (unit #t); if Ce is a constructor it would be caught earlier
       ;       (if (equal? pattern `(#f)) ; Falsey
       ;           (unit #f) ; if Ce is a constructor it would be caught earlier
       ;           ⊥
       ;           ; (error 'pattern-con-match (format "no-matching-pattern for ~a" (show-simple-ctx Ce)))
       ;           ))]
       )]
    [`',x (unit #f)] ; symbols are matched by literals not constructors
    [(? symbol? x)
     ;  (pretty-print (show-simple-ctx Ce))
     (if (eq? x '_) ; If the symbols match and x is a wildcard don't bind anything
         (unit #t)
         ; Otherwise bind the symbol x to the value wrapped back up as a closure
         (>>= (clos Ce ρ) (λ (res) (unit (list (list x) (list res))))))]
    [lit1 ; If it is anything else
     (match Ce
       [(cons _ con1); Singleton constructor
        (if (equal? lit1 con1) ; Check if it is a singleton constructor?
            (unit #t)
            (unit #f)
            )])
     ]))

