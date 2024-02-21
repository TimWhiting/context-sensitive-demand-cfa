#lang racket/base
(require (rename-in "table-monad/main.rkt"))
(require "config.rkt" "static-contexts.rkt" "abstract-value.rkt"
         "syntax.rkt" "envs.rkt" "debug.rkt" "primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list
         racket/set)
(provide meval)

(define (eval* args)
  (match args
    [(list) (unit (list))]
    [(cons e as)
     (>>= e; This is just a compuation i.e. ((ran i) Ce ρ) and needs to be evaluated
          (λ (e ρ)
            (>>= (eval* as)
                 (λ (ress)
                   (>>= (meval e ρ)
                        (λ (res) (unit (cons res ress)))
                        )))))]
    ))

(define (evalbind* binds ρ args)
  (match args
    [(list) (unit (list))]
    [(cons e as)
     (match binds
       [(cons b bs)
        (>>= e; This is just a compuation i.e. ((ran i) Ce ρ) and needs to be evaluated
             (λ (e ρ)
               (>>= (meval e ρ)
                    (λ (res)
                      (>>= (extend-store b ρ res)
                           (λ (_) (evalbind* bs ρ as))))
                    )))
        ])
     ]
    )
  )

(define (lookup-all xss)
  (match xss
    ['() (unit '())]
    [(cons x xs)
     (>>= (lookup-all xs)
          (λ (rs)
            (>>= x ; (store ...)
                 (λ (r)
                   (unit (cons r rs))
                   ))))]
    )
  )

(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  ⊥)

(define (extend-store var env val)
  ; (pretty-print "extend")
  ; (pretty-print `(extend-store ,var ,(show-simple-env env) ,(show-simple-result val)))
  ; (store (cons var env))
  (extend-store-internal var env val)
  )
(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

(define (((extend-store-internal var env val) k) s)
  ((k #f) ((product-absorb-lit (store (cons var env)) val) s)))

(define (get-store var env)
  (store (cons var env)))

(define (bind-args vars ρ values)
  ; (pretty-print `(bind-args ,vars ,(show-simple-env ρ) ,values))
  ; (pretty-print `(bind-args ,vars ,(show-simple-env ρ) ,(map show-simple-result values)))
  (if (equal? (length vars) (length values))
      (match vars
        [(list) (unit #f)]
        [(cons var vars)
         ;  (pretty-print "extend")
         (>>= (extend-store var ρ (car values))
              (λ (_) (bind-args vars ρ (cdr values))))])
      ⊥))

(define (rebind-vars Ce vars ρ ρnew)
  ; (pretty-print `(rebind-vars ,(show-simple-ctx Ce) ,vars ,(show-simple-env ρ) ,(show-simple-env ρnew)))
  (match vars
    [(list) (unit #f)]
    [(cons var vars)
     (match (lookup-primitive var)
       [#f
        (>>=
         ((bind var) Ce ρ)
         (λ (_ __ i)
           (match i
             [-1 (rebind-vars Ce vars ρ ρnew)]
             [_  (>>= (get-store var ρ)
                      (λ (v)
                        (>>= (extend-store var ρnew v)
                             (λ (_) (rebind-vars Ce vars ρ ρnew)))))])
           ))
        ]
       [_ (rebind-vars Ce vars ρ ρnew)]
       )
     ]))

(define (store-lookup Ce x ρ)
  (>>=
   ((bind x) Ce ρ)
   (λ (_ ρ i)
     (match i
       [-1
        ; (pretty-print `(returning-cons ,Ce ,ρ))
        (clos Ce ρ)] ; treat as constructor]
       [_
        ; (pretty-print "lookup")
        ;  (pretty-print `(store-lookup ,x ,ρ))
        (>>= (get-store x ρ)
             (λ (val)
               ; (pretty-print `(store-lookup got ,val ,x ,ρ))
               (match val
                 [(product/set (list Ce ρ)) (clos Ce ρ)]
                 [(product/lattice l) (lit l)]
                 ))
             )]))))

(define (symbol-lookup Ce x ρ)
  (match (lookup-primitive x)
    [#f (store-lookup Ce x ρ)]
    [Ce (clos Ce ρ)]
    ))

; demand evaluation
(define-key (meval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(meval ,(show-simple-ctx Ce) ,(show-simple-env ρ))
   (λ ()
     (match Ce
       [(cons _ #t) (truecon Ce ρ)]
       [(cons _ #f) (falsecon Ce ρ)]
       [(cons _ (? integer? x)) (lit (litint x))]
       [(cons _ (? string? x)) (lit (litstring x))]
       [(cons _ (? symbol? x)) (symbol-lookup Ce x ρ)]
       [(cons _ `(λ ,_ ,_)) (clos Ce ρ)]
       [(cons _ `(app quote ,_)) (>>= ((ran 0) Ce) clos)]
       [(cons _ `(lettypes ,_ ,_))
        (>>= (bod Ce ρ) meval)]
       [(cons _ `(let ,binds ,_))
        (>>= (eval* (map
                     (λ (i) ((bin i) Ce ρ))
                     (range (length binds))))
             (λ (evaled-binds)
               (>>= (bind-args (map car binds) ρ evaled-binds)
                    (λ (_)
                      ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
                      (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(let* ,binds ,_))
        (>>= (evalbind*
              (map car binds)
              ρ
              (map
               (λ (i) ((bin i) Ce ρ))
               (range (length binds))))
             (λ (_)
               ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
               (>>= (bod Ce ρ) meval)))]
       [(cons _ `(letrec ,binds ,_))
        ; Scheme rules state that the recursive definitions should not depend on order
        ; and shouldn't reference each other until they have all been initialized
        ; (as is often the case with recursive lambdas), as such we treat just like normal let
        (>>= (eval* (map
                     (λ (i) ((bin i) Ce ρ))
                     (range (length binds))))
             (λ (evaled-binds)
               (>>= (bind-args (map car binds) ρ evaled-binds)
                    (λ (_)
                      ; (pretty-print `(bound-let-vars ,(map car binds) ,ρ ,evaled-binds))
                      (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(match ,_ ,@clauses))
        (>>=eval (>>= (focus-match Ce ρ) meval)
                 (eval-con-clause Ce ρ clauses 0)
                 (eval-lit-clause Ce ρ clauses 0))]
       [(cons C `(app ,f ,@args))
        (pretty-trace `(eval-fun ,f ,(show-simple-env ρ)))
        (>>=clos
         (>>= (rat Ce ρ) meval)
         (λ (lam lamρ)
           (pretty-trace `(eval-args ,args))
           (>>= (eval* (map
                        (λ (i) ((ran i) Ce ρ))
                        (range (length args))))
                (λ (evaled-args)
                  ; (pretty-trace `(got closure or primitive ,(show-simple-ctx lam)))
                  (match lam
                    [`(prim ,_)
                     (pretty-trace `(applying prim: ,lam ,args))
                     (apply-primitive lam C ρ evaled-args)]
                    [(cons _ `(λ ,xs ,bod))
                     ;  (pretty-print `(applying closure: ,lam ,args ,ρ))
                     ;  (pretty-print `(applying closure: ,lam ,args ,ρ ,lamρ ,evaled-args))
                     (>>= (bod-enter lam Ce ρ lamρ)
                          (λ (Ce ρ-new)
                            ;  (pretty-print `(binding in ,ρ-new))
                            (>>=
                             (bind-args xs ρ-new evaled-args)
                             (λ (_)
                               (match (analysis-kind)
                                 ['exponential (meval Ce ρ-new)]
                                 ['rebinding
                                  (define frees (set->list (set-subtract (free-vars `(λ ,xs ,bod)) (apply set xs))))
                                  (>>= (rebind-vars Ce frees lamρ ρ-new)
                                       (λ (_) (meval Ce ρ-new)))]
                                 ))))
                          )]
                    [(cons C con)
                     (>>=
                      ((bind con) Ce ρ)
                      (λ (_ ρ i)
                        (match i
                          [-1
                           (define argse (map (lambda (i) (car ((ran-e i) Ce ρ))) (range (length args))))
                           ;  (pretty-print con)
                           ;  (pretty-print `(conapp ,con))
                           (if (= (length args) 0)
                               (clos `(con ,con) (top-env))
                               (>>= (bind-args argse ρ evaled-args)
                                    (λ (_) (clos `(con ,con ,@argse) ρ)))
                               )])))
                     ]
                    ))))

         )
        ]
       [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
       ))))


(define ((eval-con-clause parent parentρ clauses i) ce ρ)
  ; (pretty-print `(eval-con-clause ,ce ,ρ))
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (match matches
              [(list vars exprs) ; Matches and binds variables
               ;  (pretty-print `(pattern ,(car clause) binds ,vars to ,exprs))
               (>>= (bind-args vars parentρ exprs)
                    (λ (_)
                      ; (pretty-print 'finished-binding)
                      (>>= ((match-clause i) parent parentρ) meval)))]
              [#f ((eval-con-clause parent parentρ clauses (+ i 1)) ce ρ)] ; Doesn't match
              [#t (>>= ((match-clause i) parent parentρ) meval)] ; Matches, but doesn't bind anything
              )
            ))]
    [_ ;(clos (cons parent 'match-error) parentρ)
     ⊥]
    ))

(define ((eval-lit-clause parent parentρ clauses i) lit)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (>>= ((match-clause i) parent parentρ) meval)
                ((eval-con-clause parent clauses (+ i 1)) lit)
                )))]
    [_ ;(clos (cons parent 'match-error) parentρ)
     ⊥
     ]
    ))

(define (pattern-matches pat val)
  (match val
    [(product/lattice l) (pattern-lit-matches pat l)]
    [(product/set (list Ce ρ)) (pattern-con-matches pat Ce ρ)]
    )
  )

(define (store-lookup-vals xs ρ)
  ; (pretty-print `(lookup ,(map show-simple-ctx xs)))
  (lookup-all (map (lambda (x) (get-store x ρ)) xs))
  )

(define (pattern-con-matches pattern Ce ρ)
  ; (pretty-print `(con-matches ,pattern ,Ce ,ρ))
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [`(con ,con1 ,@args)
        ; (pretty-print `(matching-con-clause ,con ,con1 ,(length args) ,(length subpats)))
        (if (and (equal? con con1) (equal? (length args) (length subpats)))
            (begin
              ; (pretty-print `(looking-up ,@args))
              (>>= (store-lookup-vals args ρ)
                   (λ (vals)
                     ;  (pretty-print `(matching ,vals to ,subpats and ,con to ,con1))
                     ;  (pretty-print `(matching ,vals to ,subpats))
                     (let loop ([subpats subpats] [vals vals])
                       (if (empty? subpats) (unit (list (list) (list)))
                           (>>= (pattern-matches (car subpats) (car vals))
                                (λ (res)
                                  (match res
                                    [#f (unit #f)]
                                    [#t (loop (cdr subpats) (cdr vals))]
                                    [(list carbinds carvals)
                                     (>>= (loop (cdr subpats) (cdr vals))
                                          (λ (ress)
                                            (match ress
                                              [#f (unit #f)]
                                              [(list binds vals)
                                               (unit (list (append carbinds binds) (append carvals vals)))])
                                            ))
                                     ]
                                    ))
                                ))))))
            (unit #f))
        ]
       )
     ]
    [(? symbol? x)
     ;  (pretty-print `(matches-symbol ,x ,Ce))
     (>>= (clos Ce ρ) (λ (res) (unit (list (list x) (list res)))))]
    [lit1
     (match Ce
       [(cons _ con1); Singleton constructor
        ;  (pretty-print `(match-singleton constructor ,Ce ,con1 ,lit1 ,(equal? lit1 con1)))
        (if (equal? lit1 con1)
            (unit #t)
            (unit #f)
            )])
     ]))

(define (pattern-lit-matches pattern lit2)
  (match pattern
    [lit1 (unit (equal? (to-lit lit1) lit2))]
    ))
