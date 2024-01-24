#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt" "demand-primitives.rkt")
(require racket/pretty)
(require racket/match
         racket/list)


#|
TODO:
Implement pattern matchings / constructors

Finish the paper
|#


; (define ((>>= m f) k)
;   ((>>=1 m
;          (λ x
;            (begin
;              ;  (pretty-trace x)
;              (apply f x))))
;    k))


; environment refinement
(define-key (refine p) fail)

(define (((put-refines ρ₀ ρ₁) k) s)
  (pretty-trace `(addrefine ,ρ₀ ,ρ₁))
  ((k #f) ((node-absorb/powerset (refine ρ₁) (list ρ₀)) s)))

; Just wraps do-get-refines so we can do a debug statement around it
(define (get-refines* kind ρ)
  (match ρ
    [(list)
     ⊥]
    [(cons _ _)
     (print-result-env `(refines ,kind) (λ () (do-get-refines* ρ)))
     ]))

(define do-get-refines*
  (match-lambda
    [(list)
     ⊥]
    [(and ρ (cons cc ρ′))
     ;  (pretty-trace "GET-REFINES")
     ;  (pretty-trace ρ)
     (⊔ (if (cc-determined? cc)
            ; won't have any refinements at this scope
            fail
            (refine ρ))
        (>>= (do-get-refines* ρ′) (λ (ρ′) (unit (cons cc ρ′)))))]))

(define (find x Ce ρ)
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
                       (λ (Cm ρm) (find x Cm ρm)))
                  (map (λ (i)
                         (>>= (focus-clause Ce ρ i)
                              (λ (Cm ρm) (find x Cm ρm))))
                       (range (length ms)))))]
    [(cons C `(λ ,ys ,e))
     (if (ors (map (λ (y) (equal? x y)) ys))
         ⊥
         (find x
               (cons `(bod ,ys ,C) e)
               (cons (take-cc `(□? ,ys)) ρ)))]
    [(cons _ `(app ,_ ,@es))
     (apply each
            (cons (>>= (rat Ce ρ)
                       (λ (Ce ρ) (find x Ce ρ)))
                  (map (λ (i)
                         ;  (pretty-print i)
                         (>>= (ran Ce ρ i)
                              (λ (Ce ρ) (find x Ce ρ))))
                       (range (length es))))
            )]
    [(cons _ `(let (,@binds) ,_))
     (apply each
            (cons (if (ors (map (λ (n) (equal? n x)) (map car binds)))
                      ⊥
                      (>>= (bod Ce ρ)
                           (λ (Ce ρ) (find x Ce ρ))))
                  (map (λ (i)
                         (>>= (bin Ce ρ i)
                              (λ (Ce ρ)
                                (match Ce
                                  [(cons `(let-bin ,y ,_ ,_ ,_ ,_) _) (if (equal? x y) ⊥ (find x Ce ρ))]
                                  [_(find x Ce ρ)])
                                )))
                       (range (length binds)))))
     ;  (each (find x (cons `(let-bin ,y ,e₁ ,C) e₀) ρ)
     ;        (if (equal? x y)
     ;            ⊥
     ;            (find x (cons `(let-bod ,y ,e₀ ,C) e₁) ρ)))
     ]
    [(cons _ e) (error 'find (pretty-format `(no match for find ,e)))]
    ))

(define (ors xs)
  (match xs
    [(list) #f]
    [(cons x xs) (or x (ors xs))])
  )

(define (bind x Ce ρ)
  (define (search-out) (>>= (out Ce ρ) (λ (Ce ρ) (bind x Ce ρ))))
  ; (pretty-print `(bind ,x ,Ce ,ρ))
  (match Ce
    [(cons `(top) _) (unit x ρ -1)] ; Constructors
    [(cons `(let-bin ,y ,_ ,before ,after ,_) _)
     ;  (pretty-print `(let-bin-bind ,y ,x))
     (define defs (append (map car before) (list y) (map car after)))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x))
         (search-out))]
    [(cons `(bod ,ys ,_) _)
     ;  (pretty-print `(bodbind ,ys ,x ,(ors (map (λ (y) (equal? x y)) ys)) ,(index-of ys x)))
     (if (ors (map (λ (y) (equal? x y)) ys))
         (unit Ce ρ (index-of ys x))
         (search-out))]
    [(cons `(let-bod ,binds ,_) _)
     (define defs (map car binds))
     ;  (pretty-print `(let-bind ,defs))
     (if (ors (map (λ (y) (equal? x y)) defs))
         (unit Ce ρ (index-of defs x))
         (search-out))]
    ; All other forms do not introduce bindings
    [(cons _ _) (search-out)]
    ))

(define (eval* args)
  (let loop ([ags args]
             [acc (list)])
    (match ags
      [(list) (unit acc)]
      [(cons e as) (>>= e (λ (ce p) (>>= (eval ce p) (λ (r) (loop as (append acc (list r)))))))]
      )
    )
  )

; demand evaluation
(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
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
                     ;  (pretty-trace `(bod ,x ,C, e))
                     (>>= (>>= (call C x e ρ)
                               (λ (Ce ρ)
                                 ;  (pretty-print i)
                                 (ran Ce ρ i))) (debug-eval `(ref ,i) eval))]
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
                    [(? symbol? x)
                     (match (lookup-primitive x)
                       [#f
                        (pretty-print `(constructor? ,x))
                        (clos x ρ)]
                       [Ce (clos Ce ρ)]
                       )]

                    )))]
          [(cons _ `(λ ,_ ,_))
           ;  (pretty-trace "LAM")
           (clos Ce ρ)]
          [(cons _ `(app ,@args))
           (pretty-trace `(APP ,ρ))

           (>>=clos
            (>>= (rat Ce ρ) eval)
            (λ (Ce′ ρ′)
              ; (pretty-trace `(got closure or primitive ,Ce′))
              ;  (print-result
              ;   `('bodof ,Ce ,ρ ,Ce′ ,ρ′)
              ; (λ ()
              (match Ce′
                [`(prim ,_)
                 (pretty-trace `(eval args prim: ,args))
                 (>>= (eval* (map
                              (λ (i) (ran Ce ρ i))
                              (range (- (length args) 1))))
                      (λ (args)
                        (pretty-trace `(applying prim: ,Ce′ ,args))
                        (apply-primitive Ce′ ρ args)))]
                [(cons _ `(λ ,_ ,_))
                 (>>= (match (demand-kind)
                        ['basic (bod-enter Ce′ Ce ρ ρ′)]
                        [_ (bod-calibrate Ce′ Ce ρ ρ′)]
                        ) (debug-eval 'app-eval eval))
                 ]
                [con (clos con ρ′)]
                )
              ))
           ;  ))
           ]
          [(cons _ `(let ,_ ,_))
           ;  (pretty-trace "LET")
           (>>= (bod Ce ρ) eval)]
          [(cons _ `(match ,_ ,@clauses))
           (>>= (focus-match Ce ρ)
                (λ (Cm ρm)
                  (pretty-trace `(eval-match ,Cm ,ρm))
                  (>>=clos (eval Cm ρm)
                           (λ (Ce′ ρ′)
                             ;  (pretty-trace `(eval-clause ,Ce′ ,ρ′))
                             (eval-clause Ce′ ρ′ Ce clauses 0)))))]
          [(cons C e) (error 'eval (pretty-format `(can not eval expression: ,e in context ,C)))]
          )
        (>>= (get-refines* `(eval ,Ce ,ρ) ρ)
             (λ (ρ′) (eval Ce ρ′)))))))

(define (eval-clause c p Ce clauses i)
  (match clauses
    [(cons `(,m ,_) clauses)
     (if (equal? m c)
         (begin
           (pretty-trace `(clause-match: ,m ,c))
           (>>= (focus-clause Ce p i)
                (λ (Ce ρ)
                  (eval Ce ρ))))
         (begin
           (pretty-trace `(clause-no-match: ,m ,c))
           (eval-clause c p Ce clauses (+ i 1))))]
    [(list) ⊥]))

(define (call C xs e ρ)
  (pretty-trace `(call ,C ,xs))
  (print-result
   `(call ,C ,xs ,ρ)
   (λ () (match-let ([(cons cc₀ ρ₀) ρ])
           (match (demand-kind)
             ['basic
              (pretty-trace `(CALL BASIC ,(cons C `(λ ,xs ,e))))
              (>>= (expr (cons C `(λ ,xs ,e)) ρ₀)
                   (λ (Cee ρee)
                     (let ([cc₁ (enter-cc Cee ρee)])
                       (cond
                         [(equal? cc₀ cc₁)
                          (pretty-trace `(CALL-EQ ,cc₀ ,cc₁))
                          (unit Cee ρee)]
                         [(⊑-cc cc₁ cc₀)
                          (pretty-trace `(CALL-REFINES ,cc₀ ,cc₁))
                          ; strictly refines because of above
                          (>>= (put-refines (cons cc₁ ρ₀) ρ) (λ _ ⊥))
                          ]
                         [else
                          (pretty-tracen 0 `(CALL-NO-REFINE ,cc₀ ,cc₁))
                          ⊥]))))]
             [_
              (pretty-trace "HYBRID")
              (match (calibrate-env ρ)
                [(cons Ce ρ′)
                 (pretty-trace "CALL-KNOWN")
                 (unit Ce ρ′)]
                [#f
                 (begin
                   (pretty-trace "CALL UNKNOWN")
                   (>>= (expr (cons C `(λ ,xs ,e)) ρ₀); Fallback to normal basic evaluation
                        (λ (Cee ρee)
                          (pretty-trace `(,Cee ,ρee))
                          (let ([cc₁ (enter-cc Cee ρee)])
                            (cond
                              [(equal? cc₀ cc₁)
                               (pretty-trace "CALL-EQ")
                               (unit Cee ρee)]
                              [(⊑-cc cc₁ cc₀)
                               (pretty-trace "CALL-REFINE")
                               (pretty-trace `(,cc₁ ,cc₀))
                               ; strictly refines because of above
                               (>>= (put-refines (cons cc₁ ρ₀) ρ) (λ _ ⊥))
                               ]
                              [else
                               (pretty-trace "CALL-NOREF")
                               (pretty-trace `(cc₀ ,cc₀))
                               ⊥])))))]
                )])
           ))
   )
  )

(define-key (expr Ce ρ)
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
                             (>>= (find (car (drop xs (length before)))
                                        (cons `(bod ,xs ,C) e)
                                        (cons (enter-cc Cee ρee)
                                              ρλx.e))
                                  expr))))))]
                [(cons `(bod ,xs ,C) e)
                 (>>= (call C xs e ρ) expr)]
                [(cons `(let-bod ,_ ,_) _)
                 (>>= (out Ce ρ) expr)]
                [(cons `(let-bin ,x ,_ ,_ ,_ ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Cex ρe)
                        ; (pretty-print `(let-bin find ,x))
                        (each (>>= (bod Cex ρe)
                                   (λ (Cee ρee)
                                     (>>= (find x Cee ρee)
                                          (λ (Cee ρee)
                                            ; (pretty-print `(find: found: ,Cee))
                                            (expr Cee ρee)))))
                              (>>= (find x Ce ρ) (λ (Cee ρee); Recursive bindings
                                                   ;  (pretty-print `(find: found2: ,Cee))
                                                   (expr Cee ρee)))
                              )))]
                [(cons `(top) _)
                 ⊥])
              (>>= (get-refines* `(expr ,Ce ,ρ) ρ) (λ (ρ′) (expr Ce ρ′))))))))

(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (pretty-print q)
  (run q))