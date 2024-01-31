#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "demand-abstraction.rkt" "static-contexts.rkt")
(require racket/match racket/pretty racket/set)

(provide (all-defined-out))

(define (print-eval-result input computation [override #f])
  (define show (or (trace) override))
  (if show (pretty-print `(start ,input)) '())
  (>>=eval
   (computation)
   (λ (Cee ρee)
     (if show
         (begin
           (pretty-print `(end ,input))
           (pretty-print `(result ,(show-simple-ctx Cee) ,(show-simple-env ρee)))
           (clos Cee ρee))
         (clos Cee ρee)
         )
     )
   (λ (num)
     (if show
         (begin
           (pretty-print `(end ,input))
           (pretty-print `(result ,num))
           (lit num))
         (lit num)
         )
     )
   )
  )

(define ((debug-eval name comp) . args)
  (apply (λ (Ce p)
           (print-eval-result `(,name ,Ce ,p)
                              (λ () (comp Ce p))))
         args)
  )

(define (print-result-env input computation)
  (if (trace) (pretty-print `(start ,input)) '())
  (>>=
   (computation)
   (λ (p)
     (if (trace)
         (begin
           (pretty-print `(end ,input))
           (pretty-print `(result ,p))
           (unit p))
         (unit p)))))

(define (print-result input computation)
  (if (trace) (pretty-print `(start ,input)) '())
  (>>=
   (computation)
   (λ (Cee ρee)
     (if (trace)
         (begin
           (pretty-print `(end ,input))
           (pretty-print `(result ,(show-simple-ctx Cee) ,(show-simple-env ρee)))
           (unit Cee ρee))
         (unit Cee ρee)))))


(define (pretty-result r)
  (pretty-result-out (current-output-port) r))

(define (equal-simplify-envs? result1 result2)
  (define r1 (simplify-envs result1))
  (define r2 (simplify-envs result2))
  ; (if (not (equal? r1 r2))
  ;     (pretty-print `(,r1 == ,r2)) '())
  (match r1
    [(cons s1 l1)
     (match r2
       [(cons s2 l2)
        ; Hybrid can be a subset of the basic, since it doesn't visit extraneous
        (and (equal? l1 l2) (subset? s2 s1))]
       )]
    )
  )

(define (simplify-envs result)
  (match result
    [(cons s l)
     (define (simple-closure-envs c)
       (match c
         [(list `(prim ,l) env) (list `(prim ,l) (simple-env env))]
         [(list (cons C e) env) (list (cons C e) (simple-env env))]
         ;  [(list const env) (list const (simple-env env))]
         ))
     (cons (apply set (map simple-closure-envs (set->list s))) l)
     ]
    )
  )

(define (pretty-result-out out r)
  (match r
    [(cons s l)
     (if (set-empty? s)
         (pretty-print `(clos/con: ⊥) out)
         (pretty-print `(clos/con: ,(map show-simple-clos/con (set->list s))) out))
     (pretty-print `(literals: ,(show-simple-literal l)) out)
     ]))

(define (pretty-tracen n p)
  (if (trace)
      (if (> (trace) n)
          (pretty-print p)
          '())
      '()))

(define (pretty-displayn n p)
  (if (trace)
      (if (> (trace) n)
          (displayln p)
          '())
      '()))

(define (pretty-trace p)
  (if (trace)
      (pretty-print p)
      '()))