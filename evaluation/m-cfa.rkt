#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list)
(provide meval)



(define (eval* args)
  (match args
    [(list) (unit (list))]
    [(cons e as)
     (>>= e; This is just a compuation ran Ce p i
          (λ (e p)
            (>>= (eval* as)
                 (λ (ress)
                   (>>= (meval e p)
                        (λ (res) (unit (cons res ress)))
                        )))))]
    ))

(define (new-env call callp)
  (match callp
    [(menv calls) (menv (take (cons call calls) (current-m)))]
    ))

(define-key (store addr) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (λ (_) ⊥))

(define (extend-store var env val)
  ; (pretty-print `(extend-store ,var ,env ,val))
  ; (store (cons var env))
  (extend-store-internal var env val)
  )
(define product-absorb-lit (node-absorb/product litbottom lit-lte lit-union))

(define (((extend-store-internal var env val) k) s)
  ((k #f) ((product-absorb-lit (cons var env) val) s)))

(define (get-store var env)
  (store (cons var env)))

(define (bind-args vars p values)
  (if (equal? (length vars) (length values))
      (match vars
        [(list) (unit)]
        [(cons var vars)
         (>>= (extend-store var p (car values))
              (λ (_) (bind-args vars p (cdr values))))])
      ⊥))

(define (store-lookup x ρ)
  (match (mcfa-kind)
    ['rebinding (get-store x ρ)]
    ['exponential
     (pretty-print `(store-lookup ,x ,ρ))
     (>>= (get-store x ρ)
          (λ (val)
            (if val
                (unit val)
                (match ρ
                  [(menv (cons _ ρ)) (store-lookup (menv ρ))]
                  [_ (clos 'error `("Unbound variable" ,x))]
                  ))))]
    ))

; demand evaluation
(define-key (meval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(meval ,Ce ,ρ)
   (λ ()
     (match Ce
       [(cons _ #t) (clos Ce ρ)]
       [(cons _ #f) (clos Ce ρ)]
       [(cons _ (? integer? x)) (lit (litint x))]
       [(cons _ (? symbol? x))
        (match (lookup-primitive x)
          [#f (store-lookup x ρ)]
          [Ce (clos Ce ρ)]
          )
        ]
       [(cons _ `(λ ,_ ,_))
        (clos Ce ρ)]
       [(cons C `(app ,f ,@args))
        (pretty-trace `(APP ,ρ))
        (>>=clos
         (>>= (rat Ce ρ) meval)
         (λ (lam lamp)
           ; (pretty-trace `(got closure or primitive ,Ce′))
           (match lam
             [`(prim ,_)
              ; (pretty-trace `(eval args prim: ,args))
              (>>= (eval* (map
                           (λ (i) (ran Ce ρ i))
                           (range (length args))))
                   (λ (args)
                     (pretty-trace `(applying prim: ,lam ,args))
                     (apply-primitive lam C ρ args)))]
             [(cons _ `(λ ,xs ,_))
              (pretty-print `(applying closure: ,lam ,args))
              (>>= (eval* (map
                           (λ (i) (ran Ce ρ i))
                           (range (length args))))
                   (λ (evaled-args)
                     (pretty-print `(applying closure: ,lam ,args ,evaled-args))
                     (let ([p-new (new-env Ce ρ)])
                       (>>= (bind-args xs p-new evaled-args)
                            (λ () (>>= (bod lam lamp) meval))))))
              ]
             [(cons C con)
              (>>= (eval* (map
                           (λ (i) (ran Ce ρ i))
                           (range (length args))))
                   (λ (evaled-args)
                     (>>= (bind-args (range (length args)) ρ evaled-args)
                          (λ () (clos (list con (length args)) lamp)))))]
             )))
        ]
       [(cons _ `(let ,binds ,_))
        (>>= (eval* (map
                     (λ (i) (bin Ce ρ i))
                     (range (length binds))))
             (λ (evaled-binds)
               (>>= (bind-args (map car binds) ρ evaled-binds); TODO: Do we need a new environment?
                    (λ () (>>= (bod Ce ρ) meval)))))]
       [(cons _ `(match ,_ ,@clauses))
        (>>=eval (>>= (focus-match Ce ρ) meval)
                 (eval-con-clause Ce ρ clauses 0)
                 (eval-lit-clause Ce ρ clauses 0))]
       [(cons C e) (error 'meval (pretty-format `(can not eval expression: ,e in context ,C)))]
       ))))


(define ((eval-con-clause parent parentp clauses i) ce p)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-con-matches (car clause) ce p)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (match matches
              [(list vars exprs)
               (>>= (bind-args vars p exprs) ; TODO: This seems
                    (λ () (>>= (focus-clause parent parentp i) meval)))]
              [#f ((eval-con-clause parent clauses (+ i 1)) ce p)])
            ))]
    [_ (clos (cons parent 'match-error) parentp)]
    ))

(define ((eval-lit-clause parent parentp clauses i) lit)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-lit-matches (car clause) lit)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (>>= (focus-clause parent parentp i) meval)
                ((eval-con-clause parent clauses (+ i 1)) lit)
                )))]
    [_ (clos (cons parent 'match-error) parentp)]
    ))

(define (store-lookups vars p)
  (match vars
    [(list) (unit (list))]
    [(cons var vars)
     (>>= (store-lookups vars p)
          (λ (vals)
            (>>= (store-lookup var p)
                 (λ (val)
                   (unit (cons val vals))))))]
    ))

(define ((pattern-matches p) val)
  (match val
    [(product/lattice l) (pattern-lit-matches p l)]
    [(product/set (list Ce p)) (pattern-con-matches Ce p)]
    )
  )

(define-key (pattern-con-matches pattern Ce p)
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [(cons con1 num-args)
        (if (and (equal? con con1) (equal? num-args (length subpats)))
            (>>= (store-lookups (range num-args) p)
                 (λ (vals)
                   (let loop ([subpats subpats] [vals vals])
                     (>>= (pattern-matches (car subpats) (car vals))
                          (λ (res)
                            (match res
                              [#f   (unit #f)]
                              [(list bind val)
                               (>>= (loop (cdr subpats) (cdr vals))
                                    (λ (ress)
                                      (match ress
                                        [#f (unit #f)]
                                        [(list binds vals)
                                         (unit (list (cons bind binds) (append val vals)))])
                                      ))
                               ]
                              )
                            )))))
            #f)]
       )
     ]
    [(? symbol? x) (unit (list (list x) (list Ce p)))]
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
