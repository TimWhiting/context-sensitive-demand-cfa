#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list)

#|
TODO:
Work on paper based on pattern matching / constructors

Add more simple tests

Handle Errors

Make sure more r6rs programs work

Work on Koka version

Finish the paper
|#

; environment refinement
(define-key (refine ρ) fail)

(define (((put-refines ρ₀ ρ₁) k) s)
  (pretty-trace `(addrefine ,ρ₀ ,ρ₁))
  ((k #f) ((node-absorb/powerset (refine ρ₁) (list ρ₀)) s)))


; Just wraps do-get-refines so we can do a debug statement around it
(define (get-refines* kind ρ)
  ; (pretty-print `(get-refines ,ρ))
  (match (env-list ρ)
    [(list) ⊥]
    [(cons _ _)
     (print-result-env `(refines ,kind) (λ () (do-get-refines* ρ)))
     ]))

(define (do-get-refines* ρ)
  (match (split-env ρ)
    [(cons cc ρ′)
     ;  (pretty-trace "GET-REFINES")
     ;  (pretty-trace ρ)
     (⊔ (if (cc-determined? cc) ; won't have any refinements at this scope
            fail
            (refine ρ))
        (>>= (do-get-refines* ρ′)
             (λ (ρ′)
               (match ρ
                 [(menv _) (unit (menv (cons cc (menv-m ρ′))))]
                 [(envenv _) (unit (envenv (cons cc (envenv-m ρ′))))]
                 ))))]
    [_ ⊥]
    ))

(define ((find x) Ce ρ)
  ; (pretty-print `(find ,x ,(drop Ce 1) ,ρ))
  (match Ce
    [(cons _ #t) ⊥]
    [(cons _ #f) ⊥]
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
                         (>>= (focus-clause Ce ρ i) (find x)))
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
                         (>>= (ran Ce ρ i) (find x)))
                       (range (length es))))
            )]
    [(cons _ `(let (,@binds) ,_))
     (apply each
            (cons (if (ors (map (λ (n) (equal? n x)) (map car binds)))
                      ⊥
                      (>>= (bod Ce ρ) (find x)))
                  (map (λ (i)
                         (>>= (bin Ce ρ i)
                              (λ (Ce ρ)
                                (match Ce
                                  [(cons `(let-bin ,y ,_ ,_ ,_ ,_) _) (if (equal? x y) ⊥ ((find x) Ce ρ))]
                                  [_ ((find x) Ce ρ)])
                                )))
                       (range (length binds)))))
     ]
    [(cons _ e) (error 'find (pretty-format `(no match for find ,e)))]
    ))


(define (eval* args)
  (let loop ([ags args]
             [acc (list)])
    (match ags
      [(list) (unit acc)]
      [(cons e as) (>>= e (λ (ce ρ) (>>= (eval ce ρ) (λ (r) (loop as (append acc (list r)))))))]
      )
    )
  )

; demand evaluation
(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (expect-no-cut ρ)
  (print-eval-result
   `(eval ,Ce ,ρ)
   (λ ()
     (⊔ (match Ce
          [(cons _ #t) (clos Ce ρ)]
          [(cons _ #f) (clos Ce ρ)]
          [(cons _ (? integer? x)) (lit (litint x))]
          [(cons _ (? symbol? x))
           ;  (pretty-trace `(bind ,x ,Ce ,ρ))
           (>>= (bind x Ce ρ)
                (λ (Cex ρ i)
                  ; (pretty-print `(bound to ,Cex ,i))
                  (match Cex
                    [(cons `(bod ,x ,C) e)
                     ;  (pretty-trace `(bound ,C ,e ,x ,Cex))
                     (>>= (call C x e ρ)
                          (λ (Ce ρ)
                            (if (equal? (length x) (length (args-e Ce)))
                                ;  (pretty-print `(,Ce ,ρ ,i))
                                (>>= (ran Ce ρ i) (debug-eval `(ref ,i) eval))
                                ⊥)))

                     ]
                    [(cons `(let-bod ,_ ,_) _)
                     ;  (print-eval-result `(ref-let-bod)
                     ;                     (λ ()
                     (>>= (>>= (out Cex ρ)
                               (λ (Ce ρ)
                                 ;  (pretty-print `(,Ce))
                                 (bin Ce ρ i)))
                          (debug-eval `(letbin) eval))
                     ; ) #t)
                     ]
                    [(cons `(let-bin ,_ ,_ ,_ ,_ ,_) _) ; Recursive bindings
                     (>>= (>>= (out Cex ρ) (λ (Ce ρ) (bin Ce ρ i))) eval)
                     ]
                    [(cons `(match-clause ,_ ,_ ,_ ,_ ,_) _)
                     (>>= (out Cex ρ)
                          (λ (Ce ρ)
                            (>>= (focus-match Ce ρ)
                                 (eval-match-binding i))))
                     ]
                    [(? symbol? x)
                     (match (lookup-primitive x)
                       [#f
                        (pretty-tracen 0 `(constructor? ,x))
                        (clos Ce ρ)]
                       [Ce (clos Ce ρ)]
                       )]
                    )))]
          [(cons _ `(λ ,_ ,_))
           ;  (pretty-trace "LAM")
           (clos Ce ρ)]
          [(cons C `(app ,@args))
           (pretty-trace `(APP ,ρ))
           (>>=clos
            (>>= (rat Ce ρ) eval)
            (λ (Ce′ ρ′)
              ; (pretty-trace `(got closure or primitive ,Ce′))

              (match Ce′
                [`(prim ,_)
                 (pretty-trace `(eval args prim: ,args))
                 (>>= (eval* (map
                              (λ (i) (ran Ce ρ i))
                              (range (- (length args) 1))))
                      (λ (args)
                        (pretty-trace `(applying prim: ,Ce′ ,args))
                        (apply-primitive Ce′ C ρ args)))]
                [(cons _ `(λ ,_ ,_))
                 (>>= (bod-enter Ce′ Ce ρ ρ′) (debug-eval 'app-eval eval))
                 ]
                [con (clos con ρ′)]
                )
              ))
           ]
          [(cons _ `(let ,_ ,_))
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(match ,_ ,@clauses))
           (>>= (focus-match Ce ρ)
                (λ (Cm ρm)
                  (pretty-trace `(eval-match ,Cm ,ρm))
                  ;  (pretty-trace `(eval-clause ,Ce′ ,ρ′))
                  (>>=eval (eval Cm ρm) (eval-clausecon Ce ρ clauses 0) (eval-clauselit Ce ρ clauses 0))
                  ))]
          [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,e in context ,C)))]
          )
        (>>= (get-refines* `(eval ,Ce ,ρ) ρ)
             (λ (ρ′) (eval Ce ρ′)))))))


(define ((eval-match-binding match-bind) Ce ρ)
  (match match-bind
    [`(,con ,locsub ,sub)
     (>>=clos
      (eval Ce ρ) ; Evaluate the constructor
      (λ (Ce ρ)
        (match Ce
          [(cons _ con1)
           (if (equal? con con1)
               (>>= (expr Ce ρ); Evaluate where the constructor is applied
                    (λ (Ce ρ)
                      ; (pretty-print `(ran subpat ,sub ,locsub))
                      (>>= (ran Ce ρ locsub) (eval-match-binding sub))))
               ⊥
               )]
          ))) ]
    [#t (eval Ce ρ)]
    ))

(define (patterns-match Ce ρ args subpats i)
  (match args
    [(list) (unit #t)]
    [(cons _ as)
     (match-let ([(cons subpat subpats) subpats])
       ; (pretty-print `(ran subpat matches ,Ce))
       (>>= (ran Ce ρ i)
            (λ (Cex ρx)
              (>>= (>>=eval (eval Cex ρx)
                            (λ (Ce ρ) (pattern-matches subpat Ce ρ))
                            (λ (lit) (pattern-matches-lit subpat lit)))
                   (λ (matches)
                     ; (pretty-print `(subpat match ,subpat ,Ce ,matches))
                     (if matches (patterns-match Ce ρ as subpats (+ 1 i)) (unit #f))
                     )))))]
    ))

(define (pattern-matches pattern Ce ρe)
  (match pattern
    [`(,con ,@subpats)
     (match Ce
       [(cons _ con1)
        (if (equal? con con1)
            ; Find where the constructor is applied
            (>>= (expr Ce ρe)
                 (λ (Ce ρ)
                   (match Ce
                     [(cons _ `(app ,_ ,@as))
                      ;  (pretty-print `(subpat ,subpats ,as))
                      (if (equal? (length as) (length subpats))
                          (patterns-match Ce ρ as subpats 0)
                          (unit #f)
                          )]
                     )))
            ; Wrong constructor
            (unit #f))])]
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
  (unit (equal? (to-lit pat) lit2))
  )

(define ((eval-clauselit parent parentρ clauses i) lit)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches-lit (car clause) lit)
          (λ (matches)
            (if matches
                (begin
                  ; (pretty-print `(clause-match ,clause))
                  (>>= (focus-clause parent parentρ i) eval)
                  )
                ((eval-clauselit parent parentρ clauses (+ i 1)) lit)
                )))
     ]
    [_
     ;  (pretty-print `(no match in ,parent for ,(cdr ce)))
     (clos (cons lit 'match-error) parentρ)
     ]
    )
  )

(define ((eval-clausecon parent parentρ clauses i) ce ρ)
  (match clauses
    [(cons clause clauses)
     (>>= (pattern-matches (car clause) ce ρ)
          (λ (matches)
            ; (pretty-print `(clause-res ,matches))
            (if matches
                (begin
                  ; (pretty-print `(clause-match ,clause))
                  (>>= (focus-clause parent parentρ i) eval)
                  )
                ((eval-clausecon parent parentρ clauses (+ i 1)) ce ρ)
                )))]
    [_
     ;  (pretty-print `(no match in ,parent for ,(cdr ce)))
     (clos (cons ce 'match-error) ρ)
     ] ; TODO: Test match error
    ))

(define (call C xs e ρ)
  (define lambod (car (bod-e (cons C `(λ ,xs ,e)) ρ)))
  (expect-no-cut ρ)
  ; (pretty-trace `(call ,C ,xs ,e ,ρ))
  (print-result
   `(call ,C ,xs ,e ,ρ)
   (λ () (match ρ
           [(menv (cons cc₀ ρ₀))
            (pretty-trace `(CALL BASIC ,(cons C `(λ ,xs ,e))))
            (>>= (expr (cons C `(λ ,xs ,e)) (menv ρ₀))
                 (λ (Cee ρee)
                   (let ([cc₁ (enter-cc Cee ρee lambod)])
                     (cond
                       [(equal? cc₀ cc₁)
                        (pretty-trace `(CALL-EQ ,cc₀ ,cc₁))
                        (unit Cee ρee)]
                       [(⊑-cc cc₁ cc₀)
                        (pretty-trace `(CALL-REFINES ,cc₀ ,cc₁))
                        ; strictly refines because of above
                        (>>= (put-refines (menv (cons cc₁ ρ₀)) ρ) (λ _ ⊥))
                        ]
                       [else
                        (pretty-tracen 0 `(CALL-NO-REFINE ,cc₀ ,cc₁))
                        ⊥]))))]
           [(envenv (cons cc₀ ρ₀))
            (pretty-trace `HYBRID)
            (define indet-env (envenv (indeterminate-env lambod)))
            ; (pretty-print `(hybrid-call ,ρ ,indet-env))
            (match (find-call (calibrate-envs ρ indet-env lambod))
              [`(cenv ,ce ,ρ′)
               ;  (pretty-print 'known)
               (pretty-trace `(CALL-KNOWN))
               (unit ce ρ′)]
              [_
               ;  (pretty-print 'unknown)
               (begin
                 (pretty-trace `(CALL-UNKNOWN ,(calibrate-envs ρ indet-env lambod)))
                 (>>= (expr (cons C `(λ ,xs ,e)) (envenv ρ₀)); Fallback to normal basic evaluation
                      (λ (Cee ρee)
                        (pretty-trace `(,Cee ,ρee))
                        (let ([cc₁ (enter-cc Cee ρee lambod)])
                          (cond
                            [(equal? cc₀ cc₁)
                             (pretty-trace "CALL-EQ")
                             (unit Cee ρee)]
                            [(⊑-cc cc₁ cc₀)
                             (pretty-trace "CALL-REFINE")
                             (pretty-trace `(,cc₁ ,cc₀))
                             ; strictly refines because of above
                             (>>= (put-refines (envenv (cons cc₁ ρ₀)) ρ) (λ _ ⊥))
                             ]
                            [else
                             (pretty-trace "CALL-NOREF")
                             (pretty-trace `(cc₀ ,cc₀ cc₁ ,cc₁))
                             ⊥])))))]
              )])
     )
   )
  )

(define-key (expr Ce ρ)
  (expect-no-cut ρ)
  (begin
    (print-result
     `(expr ,Ce ,ρ)
     (λ () (⊔ (match Ce
                [(cons `(rat ,_ ,_) _)
                 ;  (pretty-trace "RAT")
                 (out Ce ρ)]
                [(cons `(ran ,_ ,before ,_ ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Cee ρee)
                        (>>=clos
                         (>>= (rat Cee ρee) eval)
                         (λ (Cλx.e ρλx.e)
                           (match-let ([(cons C `(λ ,xs ,e)) Cλx.e])
                             (>>= (bod-enter Cλx.e Cee ρee ρλx.e)
                                  (λ (Ce ρ)
                                    (>>= ((find (car (drop xs (length before)))) Ce ρ)
                                         expr))))))))]
                [(cons `(bod ,xs ,C) e)
                 (>>= (call C xs e ρ) expr)]
                [(cons `(let-bod ,_ ,_) _)
                 (>>= (out Ce ρ) expr)]
                [(cons `(let-bin ,x ,_ ,before ,after ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Cex ρe)
                        ; (pretty-print `(let-bin find ,x ,Cex))
                        (apply each
                               (cons (>>= (bod Cex ρe)
                                          (λ (Cee ρee)
                                            (>>= ((find x) Cee ρee)
                                                 (λ (Cee ρee) ; TODO: Calibrate and use the cut environment instead of doing expr if we can
                                                   ; (pretty-print `(find: found: ,Cee))
                                                   (expr Cee ρee)))))
                                     (map (λ (i) ; Recursive bindings
                                            (>>= (bin Cex ρe i)
                                                 (λ (Cee ρee)
                                                   (>>= ((find x) Cee ρee) expr))))
                                          (range (+ 1 (length before) (length after))))
                                     )
                               )))]
                [(cons `(top) _)
                 ⊥])
              (>>= (get-refines* `(expr ,Ce ,ρ) ρ) (λ (ρ′) (expr Ce ρ′))))))))

(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (pretty-print q)
  (run q))