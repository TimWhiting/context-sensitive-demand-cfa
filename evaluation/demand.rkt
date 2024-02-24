#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "static-contexts.rkt" "abstract-value.rkt"
         "debug.rkt" "primitives.rkt"
         "envs.rkt" "utils.rkt" "syntax.rkt")
(require racket/pretty)
(require racket/match
         racket/list)

#|
TODO:
Add more simple tests

Handle Errors

Make sure more r6rs programs work

Work on Koka version

Finish the paper
|#

; environment refinement
(define-key (refine ρ) fail)

; The first is a refinement of the second parameter
(define (((put-refines ρ₀ ρ₁) k) s)
  ; (pretty-trace `(addrefine ,(show-simple-env ρ₀) ,(show-simple-env ρ₁)))
  ((k #f) ((node-absorb/powerset (refine ρ₁) (list ρ₀)) s)))


; Just wraps do-get-refines so we can do a debug statement around it
(define (get-refines* kind ρ)
  ; (pretty-print `(get-refines ,ρ))
  (match (env-list ρ)
    [(list) (unit ρ)]
    [(cons _ _)
     ;(print-result-env `(refines ,kind) (λ ()
     (do-get-refines* ρ) ; ))
     ]))

(define (do-get-refines* ρ)
  (match (split-env ρ)
    [(cons c ρ′)
     ;  (pretty-trace "GET-REFINES")
     ;  (pretty-trace ρ)
     (⊔ (if (cc-determined? c) ; won't have any refinements at this scope
            (unit ρ)
            (>>= (node-exists/powerset (refine ρ))
                 (λ (yes) (if yes (refine ρ) (each (unit ρ) (refine ρ))))
                 ))
        (>>= (do-get-refines* ρ′)
             (λ (ρ′)
               (match ρ′
                 [(menv ccs) (unit (menv (cons (callc c) ccs)))]
                 ))))]
    [(menv '()) ⊥]
    ))

(define ((find x) Ce ρ)
  ; (pretty-print `(find ,x ,(drop Ce 1) ,ρ))
  ; Different let versions are handled in expr, once inside the definition we avoid all further shadowing
  (define (handle-let binds)
    (apply each
           (cons (if (ors (map (λ (n) (equal? n x)) (map car binds)))
                     ⊥
                     (>>= (bod Ce ρ) (find x)))
                 (map (λ (i)
                        (>>= ((bin i) Ce ρ)
                             (λ (Ce ρ)
                               (match Ce
                                 [(cons `(bin ,_ ,y ,_ ,_ ,_ ,_) _) (if (equal? x y) ⊥ ((find x) Ce ρ))]
                                 [_ ((find x) Ce ρ)])
                               )))
                      (range (length binds))))))
  (match Ce
    [(cons _ #t) ⊥]
    [(cons _ #f) ⊥]
    [(cons C `',x) ⊥]
    [(cons _ (? string?)) ⊥]
    [(cons _ (? symbol? y))
     (if (equal? x y)
         (unit Ce ρ)
         ⊥)]
    [(cons _ (? integer?)) ⊥]
    [(cons _ `(match ,_ ,@ms))
     (apply each
            (cons (>>= (focus-match Ce ρ)
                       (λ (Cm ρm) ((find x) Cm ρm)))
                  (map (λ (i)
                         (>>= ((match-clause i) Ce ρ) (find x)))
                       (range (length ms)))))]
    [(cons C `(λ ,ys ,e))
     (if (ors (map (λ (y) (equal? x y)) ys))
         ⊥
         (>>= (bod Ce ρ) (find x)))]
    [(cons _ `(app ,_ ,@es))
     (apply each
            (cons (>>= (rat Ce ρ) (find x))
                  (map (λ (i)
                         ;  (pretty-print i)
                         (>>= ((ran i) Ce ρ) (find x)))
                       (range (length es))))
            )]
    ; Different let versions are handled in expr, once inside the definition we avoid all further shadowing
    [(cons _ `(let (,@binds) ,_))    (handle-let binds)]
    [(cons _ `(letrec (,@binds) ,_)) (handle-let binds)]
    [(cons _ `(letrec* (,@binds) ,_)) (handle-let binds)]
    [(cons _ `(let* (,@binds) ,_))   (handle-let binds)]
    [(cons _ e) (error 'find (pretty-format `(no match for find ,e)))]
    ))


(define (eval* args)
  (let loop ([ags args]
             [acc (list)])
    (match ags
      [(list) (unit acc)]
      [(cons e as)
       (>>= e (λ (ce ρ)
                ; (pretty-print `(evaling-arg ,(show-simple-ctx ce) ,(show-simple-env ρ)))
                (>>=
                 (eval ce ρ)
                 (λ (r)
                   ;  (pretty-print `(evaling-arg-result ,(show-simple-ctx ce) result ,r))
                   (loop as (append acc (list r)))))))]
      )
    )
  )

; We need special primitives that can evaluate only what is needed
;  in the demanded constructor / closure data model
(define (lookup-demand-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim = ,do-demand-equal)]
    ['equal? `(prim equal? ,do-demand-equal)]
    ['eq? `(prim eq? ,do-demand-equal)]
    ['symbol? `(prim symbol? ,do-symbol?)]
    ['char? `(prim char? ,do-char?)]
    ['or `(prim or ,do-demand-or)]; TODO Handle in match positions
    ['and `(prim and ,do-demand-and)]; TODO Handle in match positions
    ['not `(prim not ,do-demand-not)]
    ['random `(prim random ,do-random)]
    ['ceiling `(prim ceiling ,do-ceiling)]
    ['log `(prim log ,do-log)]
    ['- `(prim - ,do-sub)] ; Numbers work with the regular data model
    ['+ `(prim + ,do-add)] ; Numbers work with the regular data model
    ['* `(prim * ,do-mult)] ; Numbers work with the regular data model
    ['/ `(prim / ,do-div)] ; Numbers work with the regular data model
    ['modulo `(prim modulo ,do-modulo)]
    ['gcd `(prim gcd ,do-gcd)]
    ['quotient `(prim quotient ,do-quotient)]
    ['<= `(prim <= ,do-lte)] ; Numbers work with the regular data model
    ['< `(prim < ,do-lt)] ; Numbers work with the regular data model
    ['> `(prim > ,do-gt)] ; Numbers work with the regular data model
    ['odd? `(prim odd? ,do-odd)] ; Numbers work with the regular data model
    ['newline `(prim newline ,do-newline)]
    ['display `(prim display ,do-display)]
    ['void `(prim void ,do-void)]
    [_ #f]
    ))

(define (do-demand-not ρ C a1)
  (>>= (is-truthy ρ C a1)
       (λ (t)
         (match t
           [#f (true C ρ)]
           [#t (false C ρ)]
           )
         )))

(define (is-truthy ρ C v)
  (match v
    [(product/lattice (literal (list i1 f1 c1 s1))) (unit #t)]
    [(product/set (list (cons C `(λ ,_ ,@_)) p)) (unit #t)]; Closures
    [(product/set (list (cons C `',x) p)) (unit #t)]; quoted symbols
    [(product/set (list Ce ρe)) ; Constructors
     (>>=clos (>>= (rat Ce ρe) eval) ; Eval the constructor
              (λ (Cc ρc)
                (match Cc ; Check if it is false
                  [(cons _ #f) (unit #f)]
                  [(cons _ _) (unit #t)]
                  )))]))

(define (do-demand-or ρ C . args)
  (match args
    ['() (false C ρ)]
    [(cons a '())
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#t (unit a)]
              [#f (false C ρ)]
              )))]
    [(cons a as)
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#t (unit a)]
              [#f (apply do-demand-or (cons ρ (cons C as)))]
              )))]))

(define (do-demand-and ρ C . args)
  (match args
    ['() (true C ρ)]
    [(cons a '())
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#t (unit a)]
              [#f (false C ρ)]
              )))]
    [(cons a as)
     (>>= (is-truthy ρ C a)
          (λ (t)
            (match t
              [#t (apply do-demand-and (cons ρ (cons C as)))]
              [#f (false C ρ)]
              )))]))

(define (do-demand-equal ρ C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2)))
        (define f-lit (for-lit ρ C))
        (bool-result (f-lit i1 i2 eq?) (f-lit f1 f2 eq?) (f-lit c1 c2 char=?) (f-lit s1 s2 eq?) C ρ)
        ]
       [_ (false C ρ)] ; Primitive != Clos/Con
       )]
    [(product/set (list _ `(λ ,_ ,@_))) (each (true C ρ) (false C ρ))]; Closures can actually be equal according to scheme
    [(product/set (list _ _)) (each (true C ρ) (false C ρ))] ; Constructors need refinement for equal? - not eq?
    ))

; demand evaluation
(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (>>= (get-refines* `(eval ,(show-simple-ctx Ce) ,(show-simple-env ρ)) ρ)
       (λ (ρ)
         (print-eval-result
          `(eval ,(show-simple-ctx Ce) ,(show-simple-env ρ))
          (λ ()
            (match Ce
              [(cons C #t) (truecon C ρ)]
              [(cons C #f) (falsecon C ρ)]
              [(cons _ (? string? s)) (lit (litstring s))]
              [(cons _ (? integer? x)) (lit (litint x))]
              [(cons _ `',x);  (pretty-print `(quoted ,x))
               (clos Ce ρ)
               ]
              [(cons _ (? symbol? x))
               ;  (pretty-print `(bind ,x ,(show-simple-ctx Ce) ,(show-simple-env ρ)))
               (>>= ((bind x) Ce ρ)
                    (λ (Cex ρ i)
                      ; (pretty-print `(bound-to ,x ,i ,(show-simple-ctx Cex)))
                      (match Cex
                        [(cons `(bod ,xs ,C) e)
                         (>>= (call C xs e ρ)
                              (λ (Ce ρ)
                                ; (pretty-print `(call-for-ref ,x ,i ,(show-simple-ctx Ce)))
                                (if (equal? (length xs) (length (args-e Ce)))
                                    (>>= ((ran i) Ce ρ) eval)
                                    ⊥)))

                         ]
                        [(cons `(let-bod ,_ ,_ ,_) _)
                         (>>= (>>= (out Cex ρ)
                                   (bin i))
                              eval)
                         ]
                        [(cons `(bin ,_ ,_ ,_ ,_ ,_ ,_) _)
                         (>>= (>>= (out Cex ρ)
                                   (bin i))
                              eval)
                         ]
                        [(cons `(match-clause ,m ,_ ,_ ,_ ,_) _)
                         ;  (pretty-print `(bound-in-match ,x ,(show-simple-ctx Cex)))
                         (>>= (out Cex ρ)
                              (λ (Ce ρ)
                                (>>=eval (>>= (focus-match Ce ρ) eval)
                                         (eval-match-binding m i Ce ρ)
                                         (eval-match-binding-lit i)
                                         )))
                         ]
                        [(? symbol? x)
                         (match (lookup-demand-primitive x)
                           [#f
                            ; (pretty-print `(constructor? ,x))
                            (clos Ce ρ)]
                           [Ce (clos Ce ρ)]
                           )]
                        )))]
              [(cons _ `(λ ,_ ,_))
               ;  (pretty-trace "LAM")
               (clos Ce ρ)]
              [(cons C `(app ,f ,@args))
               ;  (pretty-trace `(APP ,ρ))
               (>>=clos
                (>>= (rat Ce ρ) eval)
                (λ (Ce′ ρ′)
                  ; (pretty-trace `(got closure or primitive ,Ce′))
                  (match Ce′
                    [`(prim ,_ ,_)
                     ;  (pretty-trace `(eval args prim: ,args))
                     (>>= (eval* (map
                                  (λ (i) ((ran i) Ce ρ))
                                  (range (length args))))
                          (λ (args)
                            ; (pretty-trace `(applying prim: ,Ce′ ,args))
                            (apply-primitive Ce′ C ρ args)))]
                    [(cons _ `(λ ,y ,C))
                     (>>= (bod-enter Ce′ Ce ρ ρ′)
                          (λ (Ce p)
                            (>>= (put-refines p (menv (cons (callc `(□? ,y ,C)) (env-list ρ′))))
                                 (λ _
                                   (eval Ce p)))
                            ))
                     ]
                    ; Constructors just return the application. We need the context to further resolve demand queries for arguments
                    [(cons _ con)
                     (if (or (equal? con #t) (equal? con #f) (symbol? con))
                         (if (= (length args) 0)
                             (clos (cons `(top) `(app ,con ,@args)) (top-env))
                             (clos Ce ρ))
                         (error 'invalid-rator (format "~a" con))
                         )

                     ]
                    )
                  ))
               ]
              [(cons _ `(lettypes ,_ ,_))
               (>>= (bod Ce ρ) eval)]
              [(cons _ `(let ,_ ,_))
               (>>= (bod Ce ρ) eval)]
              [(cons _ `(let* ,_ ,_))
               (>>= (bod Ce ρ) eval)]
              [(cons _ `(letrec ,_ ,_))
               (>>= (bod Ce ρ) eval)]
              [(cons _ `(letrec* ,_ ,_))
               (>>= (bod Ce ρ) eval)]
              [(cons _ `(match ,_ ,@clauses))
               (>>= (focus-match Ce ρ)
                    (λ (Cm ρm)
                      ; (pretty-print `(eval-match ,Cm ,ρm))
                      (>>=eval (eval Cm ρm) (eval-clausecon Ce ρ clauses 0) (eval-clauselit Ce ρ clauses 0))
                      ))]
              [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,e in context ,C)))]
              )
            )))
       ))


(define (take-till m l)
  (match l
    ['() '()]
    [(cons x rst) (if (equal? m x) '() (cons x (take-till m rst)))]
    )
  )

(define ((eval-match-binding m match-bind parentCe parentρ) Ce ρ)
  ; (pretty-print `(eval-match-bind ,m ,(show-simple-ctx Ce)))
  (match-let ([(cons _ `(match ,_ ,@clauses)) parentCe])
    (>>= (let loop ([cls (take-till m (map car clauses))])
           (match cls
             ['() (unit #f)]
             [(cons cl cls)
              (>>= (pattern-matches cl Ce ρ)
                   (λ (m) (if m
                              ; (begin (pretty-print `(matches-prev ,(show-simple-ctx Ce) ,cl))
                              (unit #t);)
                              (loop cls)))
                   )]
             ))
         (λ (res)
           ;  (pretty-print `(eval-match ,m ,(show-simple-ctx Ce) ,res))
           (if res
               ⊥
               ((eval-match-bindingx match-bind) Ce ρ)
               )
           )
         ))); Ensure the previous

(define ((eval-match-binding-lit match-bind) l)
  (match match-bind
    [#t (lit l)]
    [_ ⊥]
    ))

(define ((eval-match-bindingx match-bind) Ce ρ)
  (match match-bind
    [`(,con ,locsub ,sub)
     ; (pretty-print `(got-con ,con ,locsub ,sub ,(show-simple-ctx Ce)))
     (match Ce
       [`((top) app ,con1) ⊥]; Singleton constructor -- no arguments possible
       [(cons C `',x) ⊥] ; Doesn't match cons
       [_ (>>=clos
           ; This is the application site of the constructor, need to see what constructor it is
           (>>= (rat Ce ρ) eval)
           (λ (Cc ρc)
             (match Cc
               [(cons _ con1)
                ;  (pretty-print `(ran subpat ,sub ,locsub))
                (if (equal? con con1)
                    (>>=eval
                     (>>= ((ran locsub) Ce ρ) eval)
                     (eval-match-bindingx sub)
                     (eval-match-binding-lit sub)
                     )
                    ⊥
                    )]
               )))])
     ]
    [#t (clos Ce ρ)]
    ))

(define (patterns-match Ce ρ args subpats i)
  (match args
    [(list) (unit #t)]
    [(cons _ as)
     (match-let ([(cons subpat subpats) subpats])
       ;  (pretty-print `(subpat-matches ,(show-simple-ctx Ce) ,args))
       (>>= ((ran i) Ce ρ)
            (λ (Cex ρx)
              (>>= (>>=eval (eval Cex ρx)
                            (λ (Ce ρ) (pattern-matches subpat Ce ρ))
                            (λ (lit)
                              ; (pretty-print `(subpat ,subpat ,lit))
                              (pattern-matches-lit subpat lit)))
                   (λ (matches)
                     ; (pretty-print `(subpat match ,subpat ,Ce ,matches))
                     (if matches (patterns-match Ce ρ as subpats (+ 1 i)) (unit #f))
                     )))))]))

(define (pattern-matches pattern Ce ρe)
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [`((top) app ,con1) (if (equal? con con1) (unit #t) (unit #f))] ; Singleton constructors
       [(cons C `',x) (unit #f)] ; Symbols
       [_
        ; (pretty-print (show-simple-ctx Ce))
        (>>=clos
         ; This is the application site of the constructor, need to see what constructor it is
         (>>= (rat Ce ρe) eval)
         (λ (Cc ρc)
           (match Cc
             [(cons _ con1)
              (if (equal? con con1)
                  ; Find where the constructor is applied
                  (match Ce
                    [(cons _ `(app ,_ ,@as))
                     ;  (pretty-print `(subpat ,subpats ,as))
                     (if (equal? (length as) (length subpats))
                         (patterns-match Ce ρe as subpats 0)
                         (unit #f)
                         )]
                    )
                  ; Wrong constructor
                  (unit #f))])))])
     ]
    [`',x
     (match Ce
       [(cons C `',x1)
        (if (eq? x x1) (unit #t) (unit #f))
        ]
       [_ (unit #f)]
       )
     ]
    [(? symbol? _) (unit #t)] ; Variable binding
    [lit1
     (match Ce
       [(cons _ con1); Singleton constructor #t #f
        ; (pretty-print `(match-singleton constructor ,con1 ,lit1 ,(equal? lit1 con1)))
        (if (equal? lit1 con1)
            (unit #t)
            (unit #f)
            )])
     ]
    )
  )

(define (pattern-matches-lit pat lit2)
  ; (pretty-print pat)
  ; (pretty-print lit2)
  (unit (or (symbol? pat) (equal? (to-lit pat) lit2)))
  )

(define ((eval-clauselit parent parentρ clauses i) lit1)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches-lit (car clause) lit1)
          (λ (matches)
            (if matches
                (begin
                  ; (pretty-print `(clause-match ,clause))
                  (>>= ((match-clause i) parent parentρ) eval)
                  )
                ((eval-clauselit parent parentρ clauses (+ i 1)) lit1)
                )))
     ]
    [_
     ;  (pretty-print `(no match in ,parent for ,(cdr ce)))

     ;  (clos (cons `(top) `(app error 'match-error ,lit1)) parentρ)
     ;  (clos (cons lit 'match-error) parentρ)
     ⊥
     ]
    )
  )

(define ((eval-clausecon parent parentρ clauses i) ce ρ)
  (assert (is-constructor ce) (format "~a is not a constructor" ce))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (begin
                  ; (pretty-print `(clause-match ,clause))
                  (>>= ((match-clause i) parent parentρ) eval)
                  )
                ((eval-clausecon parent parentρ clauses (+ i 1)) ce ρ)
                )))]
    [_
     ;  (pretty-print `(no match in ,parent for ,(cdr ce)))
     ;  (clos (cons ce 'match-error) ρ)
     ;  (clos (cons `(top) `(app error 'match-error)) ρ)
     ⊥
     ] ; TODO: Test match error
    ))

(define (call C xs e ρ)
  (define lambod (car (bod-e (cons C `(λ ,xs ,e)) ρ)))
  (print-result
   `(call ,(show-simple-ctx (cons C `(λ ,xs ,e))) ,(show-simple-env ρ))
   (λ ()
     (match ρ
       [(menv (cons (callc cc₀) ρ₀))
        ; (pretty-trace `(CALL-BASIC ,(show-simple-ctx (cons C `(λ ,xs ,e)))))
        (>>= (expr (cons C `(λ ,xs ,e)) (menv ρ₀))
             (λ (Cee ρee)
               (let ([cc₁ (enter-cc Cee ρee)])
                 (cond
                   [(equal? cc₀ cc₁)
                    ;  (pretty-print "equal")
                    ;  (pretty-trace `(CALL-EQ ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                    (unit Cee ρee)]
                   [(⊑-cc cc₁ cc₀)
                    ; (pretty-print `(refines-new? ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                    ;  (pretty-trace `(CALL-REFINES ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                    ; strictly refines because of above
                    (>>= (put-refines (menv (cons (callc cc₁) ρ₀)) ρ) (λ _ ⊥))
                    ]
                   [(⊑-cc cc₀ cc₁)
                    ; (pretty-print `(refines? ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                    ; (>>= (put-refines ρ (menv (cons (callc cc₀) ρ₀))) (λ _
                    (unit Cee ρee)
                    ; ))
                    ;  ⊥
                    ;   (define new-cc (take-cc (replace-cc cc₁ cc₀)))
                    ;   (pretty-trace "old-refines")
                    ;   (pretty-trace `(CALL-OLD-REFINES ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁) ,(show-simple-call new-cc)))
                    ;   (unit Cee (menv (cons (callc cc₀) ρ₀)))
                    ]
                   [else
                    ;  (pretty-trace "no-refine")
                    ;  (pretty-tracen 0 `(CALL-NO-REFINE ,xs ,(show-simple-call cc₀) ,(show-simple-call cc₁)))
                    ⊥]))))]
       )
     )
   ))

(define-key (expr Ce ρ)
  (>>= (get-refines* `(expr ,(show-simple-ctx Ce) ,(show-simple-env ρ)) ρ)
       (λ (ρ)
         (print-result
          `(expr ,(show-simple-ctx Ce) ,(show-simple-env ρ))
          (λ ()
            (match Ce
              [(cons `(top) _) ⊥] ; No application / deconstruction if we reached the top
              [(cons `(match-e ,mchs ,_) _)
               (apply each (cons (out Ce ρ)
                                 (map (λ (index mch)
                                        (match mch
                                          [`(_ ,_) ⊥] ; Underscore doesn't bind
                                          [`(,(? symbol? x) ,_) ((match-clause index) Ce ρ)]
                                          ; Subpatterns mean we have deconstructed instead of propagating
                                          [_ ⊥]
                                          )
                                        )
                                      (range (length mchs)) mchs)))]; The struct is used at this deconstruction site; TODO Also all rebindings
              [(cons `(rat ,_ ,_) _) (out Ce ρ)]; The lambda is used at this application site
              ; Lambda is returned from body (find callers of it) (TODO: Does this need adjustment for constructors?)
              [(cons `(bod ,xs ,C) e) (>>= (call C xs e ρ) expr)]
              ; lambda / struct is returned from let body (i.e. )
              [(cons `(let-bod ,_ ,_ ,_) _) (>>= (out Ce ρ) expr)]
              [(cons `(ran ,bound ,before ,_ ,_) _); An argument to a constructor or lambda
               (define arg-offset (length before))
               (>>= (out Ce ρ)
                    (λ (Cee ρee)
                      (>>=clos ; Evaluate the lambda or constructor
                       (>>= (rat Cee ρee) eval)
                       (λ (Cλx.e ρλx.e)
                         ;  (pretty-print (show-simple-ctx Ce))
                         ;  (pretty-print (show-simple-ctx Cλx.e))
                         (match Cλx.e
                           [(cons C `(λ ,xs ,e)) ; It is a lambda
                            (>>= (bod-enter Cλx.e Cee ρee ρλx.e)
                                 (λ (Ce ρ) ; Find where the parameter is used
                                   (>>= (put-refines ρ (menv (cons (callc `(□? ,xs ,C)) (env-list ρλx.e))))
                                        (λ _
                                          (>>= ((find (car (drop xs arg-offset))) Ce ρ)
                                               expr)))
                                   ))
                            ]
                           [(cons C (? symbol? x)) ; Constructors
                            ; (pretty-print `(,x ,(show-simple-ctx Cee)))
                            (>>= (expr Cee ρee) ; Find the deconstruction sites
                                 (λ (Cem ρem)
                                   (match Cem
                                     ; Flows to a match deconstructor
                                     [(cons _ `(match ,_ ,@mchs))
                                      ; For match in mchs get the nth binding of any match that has an outer x constructor
                                      ; And find all usages of that binding
                                      (apply each
                                             (map (λ (index m)
                                                    (match m
                                                      [`((,con ,@args) ,e)
                                                       (define bind (car (drop args arg-offset)))
                                                       (if (equal? con x)
                                                           (match bind
                                                             [(? symbol? _)
                                                              ; (pretty-print `(flow-from ,(show-simple-ctx Ce) to-match (,con ,@args) ,bind ,(show-simple-expr e)))
                                                              (>>= ((match-clause index) Cem ρem)
                                                                   (λ (Cec ρec) (>>= ((find bind) Cec ρec) expr)))]

                                                             [`(,con1 ,@args1) ; Subpattern
                                                              (>>= ((match-clause index) Cem ρem)
                                                                   (λ (Cec ρec) (unit `(con-subpat ,bind ,Cec) ρec)))
                                                              ]
                                                             [_ ⊥]; Constructor parameters do not flow from literals
                                                             )
                                                           ⊥
                                                           )
                                                       ]
                                                      [_ ⊥]
                                                      )) (range (length mchs)) mchs))
                                      ]
                                     ; Flows to a subpattern deconstructor
                                     [`(con-subpat (,con ,@bound-args) ,Cec)
                                      (define bind (car (drop bound-args arg-offset)))
                                      (if (equal? con x)
                                          (match bind
                                            [(? symbol? _)
                                             ;  (pretty-print `(flow-from ,(show-simple-ctx Ce) to-match (,con ,@bound-args) ,bind ,(show-simple-ctx Cec)))
                                             (>>= ((find bind) Cec ρem) expr)]
                                            [`(,con2 ,@args2) (unit `(con-param ,bind ,Cec) ρem)]
                                            [_ ⊥]
                                            )
                                          ⊥
                                          )]
                                     )

                                   )
                                 )
                            ; Constructor, see where the constructor flows
                            ]
                           )))) )]
              ; lambda / struct is bound by let binding with name ,x
              [(cons `(bin ,let-kind ,x ,_ ,before ,after ,_) _)
               ;  (pretty-print `(bin-expr ,let-kind ,x))
               (>>= (out Ce ρ)
                    (λ (Cex ρe)
                      ; (pretty-print `(bin-find ,let-kind ,x ,Cex))
                      (apply each
                             (cons (>>= (bod Cex ρe)
                                        (λ (Cee ρee)
                                          (>>= ((find x) Cee ρee)
                                               (λ (Cee ρee)
                                                 ;  (pretty-print `(find-body-found: ,(show-simple-ctx Cee)))
                                                 (expr Cee ρee)))))
                                   (match let-kind
                                     ['letrec
                                      ; x could be referenced in all of the bindings as well
                                      (map (λ (i)
                                             (>>= ((bin i) Cex ρe)
                                                  (λ (Cee ρee)
                                                    ; (pretty-print `(try-to-find ,x ,(show-simple-ctx Cee)))
                                                    (>>= ((find x) Cee ρee)
                                                         (λ (Cee ρee)
                                                           ; (pretty-print `(found ,x ,(show-simple-ctx Cee)))
                                                           (expr Cee ρee))))))
                                           (range (+ 1 (length before) (length after))))]
                                     ['letrec*
                                      ; x could be referenced in all of the bindings after as well as it's own
                                      (map (λ (i)
                                             (>>= ((bin i) Cex ρe)
                                                  (λ (Cee ρee)
                                                    ; (pretty-print `(try-to-find ,x ,(show-simple-ctx Cee)))
                                                    (>>= ((find x) Cee ρee)
                                                         (λ (Cee ρee)
                                                           ;  (pretty-print `(found ,x ,(show-simple-ctx Cee)))
                                                           (expr Cee ρee))))))
                                           (range (+ 1 (length before) (length after))))]
                                     ['let* ; x could be referenced in all following bindings
                                      (if (> 1 (length after))
                                          (map (λ (i)
                                                 (>>= ((bin i) Cex ρe)
                                                      (λ (Cee ρee)
                                                        (>>= ((find x) Cee ρee) expr))))
                                               (range (+ 1 (length before)) (+ 1 (length before) (length after))))
                                          '())]
                                     [_ '()]
                                     )
                                   )
                             )))]
              [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,(show-simple-ctx Ce))))]
              ))))
       ))

(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (match q
    [(eval ce p) (pretty-print `(,(show-simple-ctx ce) ,(show-simple-env p)))]
    [(expr ce p) (pretty-print `(,(show-simple-ctx ce) ,(show-simple-env p)))]
    )
  (run q))