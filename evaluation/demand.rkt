#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "static-contexts.rkt" "demand-abstraction.rkt" "debug.rkt")
(require racket/pretty)
(require racket/match
         racket/set)


#|
TODO:
Add in a small sample with constructors / pattern matching

Implement pattern matchings / constructors

Finish the paper

Presentation
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
  (match Ce
    [(cons _ (? symbol? y))
     (if (equal? x y)
         (unit Ce ρ)
         ⊥)]
    [(cons _ (? integer?)) ⊥]
    [(cons C `(λ (,y) ,e))
     (if (equal? x y)
         ⊥
         (find x (cons `(bod ,y ,C) e) (cons (take-cc `(□? ,y)) ρ)))]
    [(cons C `(app ,e₀ ,e₁))
     (each (find x (cons `(rat ,e₁ ,C) e₀) ρ)
           (find x (cons `(ran ,e₀ ,C) e₁) ρ))]
    [(cons C `(let ([,y ,e₀]) ,e₁))
     (each (find x (cons `(let-bin ,y ,e₁ ,C) e₀) ρ)
           (if (equal? x y)
               ⊥
               (find x (cons `(let-bod ,y ,e₀ ,C) e₁) ρ)))]))

(define (bind x C e ρ)
  (match C
    [`(rat ,e₁ ,C)
     (bind x C `(app ,e ,e₁) ρ)]
    [`(ran ,e₀ ,C)
     (bind x C `(app ,e₀ ,e) ρ)]
    [`(bod ,y ,C)
     (if (equal? x y)
         (unit (cons `(bod ,y ,C) e) ρ)
         (bind x C `(λ (,y) ,e) (match-let ([(cons _ ρ) ρ]) ρ)))]
    [`(let-bod ,y ,e₀ ,C′)
     (if (equal? x y)
         (unit (cons C e) ρ)
         (bind x C′ `(let ([,y ,e₀]) ,e) ρ))]
    [`(let-bin ,y ,e₁ ,C)
     (bind x C `(let ([,y ,e]) ,e₁) ρ)]
    [`(top)
     ⊥]))

; demand evaluation
(define-key (eval Ce ρ) #:⊥ litbottom #:⊑ lit-lte #:⊔ lit-union #:product
  (print-eval-result
   `(eval ,Ce ,ρ)
   (λ ()
     (⊔ (match Ce
          [(cons _ (? integer? x)) (lit (litint x))]
          [(cons C (? symbol? x))
           ;  (pretty-trace "REF")
           (>>= (bind x C x ρ)
                (λ (Ce ρ)
                  (match Ce
                    [(cons `(bod ,x ,C) e)
                     ;  (pretty-trace "REF-BOD")
                     ;  (pretty-trace `(bod ,x ,C, e))
                     (>>= (>>= (call C x e ρ) ran) eval)]
                    [(cons `(let-bod ,_ ,_ ,_) _)
                     ;  (print-eval-result "REF-LETBOD"
                     ; (λ ()
                     (>>= (>>= (out Ce ρ) bin) eval)
                     ; ))
                     ])))]
          [(cons _ `(λ (,_) ,_))
           ;  (pretty-trace "LAM")
           (clos Ce ρ)]
          [(cons _ `(app ,_ ,_))
           ;  (pretty-trace "APP")
           (>>=
            (>>=clos
             (>>= (rat Ce ρ) eval)
             (λ (Ce′ ρ′)
               ;  (print-result
               ;   `('bodof ,Ce ,ρ ,Ce′ ,ρ′)
               ; (λ ()
               (match (demand-kind) ; TODO: WE NEED TO REFINE THE EVALUATION BASED ON THIS APP
                 ['basic (bod-enter Ce′ Ce ρ ρ′)]
                 [_ (bod-calibrate Ce′ Ce ρ ρ′)]
                 )
               ))
            ;  ))
            (debug-eval 'app-eval eval))]
          [(cons _ `(let ,_ ,_))
           ;  (pretty-trace "LET")
           (>>= (bod Ce ρ) eval)]
          )
        (>>= (get-refines* `(eval ,Ce ,ρ) ρ)
             (λ (ρ′) (eval Ce ρ′)))))))


(define (call C x e ρ)
  (print-result
   `(call ,C ,x ,ρ)
   (λ () (match-let ([(cons cc₀ ρ₀) ρ])
           (match (demand-kind)
             ['basic
              ; (pretty-trace "CALL-BASIC")
              (>>= (expr (cons C `(λ (,x) ,e)) ρ₀)
                   (λ (Cee ρee)
                     (pretty-trace Cee)
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
                   (>>= (expr (cons C `(λ (,x) ,e)) ρ₀); Fallback to normal basic evaluation
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
                              [x
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
                [(cons `(ran ,_ ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Cee ρee)
                        (>>=clos (>>= (rat Cee ρee) eval)
                                 (λ (Cλx.e ρλx.e)
                                   (match-let ([(cons C `(λ (,x) ,e)) Cλx.e])
                                     (>>= (find x
                                                (cons `(bod ,x ,C) e)
                                                (cons (enter-cc Cee ρee)
                                                      ρλx.e))
                                          expr))))))]
                [(cons `(bod ,x ,C) e)
                 (>>= (call C x e ρ) expr)]
                [(cons `(let-bod ,x ,_ ,C) e)
                 (>>= (out Ce ρ) expr)]
                [(cons `(let-bin ,x ,_ ,_) _)
                 (>>= (out Ce ρ)
                      (λ (Ce ρe)
                        (>>= (bod Ce ρe)
                             (λ (Cee ρee)
                               (>>= (find x Cee ρee) expr)))))]
                [(cons `(top) _)
                 ⊥])
              (>>= (get-refines* `(expr ,Ce ,ρ) ρ) (λ (ρ′) (expr Ce ρ′))))))))


(provide (all-defined-out)
         (all-from-out "table-monad/main.rkt"))

(define (run-print-query q)
  (pretty-print q)
  (run q))

(module+ main
  (require racket/pretty)
  (require "./simple-examples.rkt")
  (define example0 (list (cons `(top)
                               `(app (λ (x) x)
                                     (λ (y) y))) (list)))

  ; (demand-kind 'basic)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (demand-kind 'hybrid)
  ; (pretty-print (run-print-query (apply eval example0)))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e example0))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example0))))
  ; (trace 1)
  ; (demand-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))
  ; (demand-kind 'hybrid)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example0)))))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example0)))))

  ; (current-m 4)

  (define example1 (list (cons `(top)
                               `(app (λ (x) (app x x))
                                     (λ (y) (app y y))))
                         (list)))
  ; (demand-kind 'basic)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))
  (demand-kind 'hybrid)
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply ran-e example1)))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e (apply rat-e example1)))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply rat-e (apply bod-e (apply ran-e example1))))))

  ; #;"QUERY"
  ; (pretty-print
  ;  (run-print-query (apply eval (apply ran-e example1))))

  ; #;"QUERY"

  (define example2 (list (cons `(top)
                               `(let ([x (λ (y) y)])
                                  (app x 1)))
                         (list)))
  ; (pretty-result
  ;  (run-print-query (apply eval example2)))

  ; (pretty-print
  ;  (run-print-query (apply eval (apply bod-e example2))))

  ; (trace 1)
  (demand-kind 'basic)
  (pretty-result
   (run-print-query (apply eval (list (cons `(top)
                                            example-2) (list)))))

  )