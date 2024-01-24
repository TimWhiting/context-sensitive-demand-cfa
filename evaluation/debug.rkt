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

(define (pretty-result-out out r)
  (match r
    [(cons s l)
     (define (pretty-closure/cons c)
       (match c
         [(cons `(prim ,l) env) (if (show-envs) `(prim: ,l env: ,(show-simple-env env)) l)]
         [(cons (cons C e) env) (if (show-envs) `(expr: ,e env: ,(show-simple-env env)) e)]
         [(cons const env) (if (show-envs) `(con: ,const env: ,(show-simple-env env)) const)]
         ))
     (define (pretty-simple l) (match l [(top) '⊤] [(bottom) '⊥] [(singleton x) x]))
     (define (pretty-lit l) (match l [(literal l) (map pretty-simple l)]))
     (define (pretty-env e) (pretty-print `(env: ,(show-simple-env e))))
     (if (set-empty? s) (pretty-print `(clos/con: ⊥) out) (pretty-print `(clos/con: ,(map pretty-closure/cons (set->list s))) out))
     (pretty-print `(literals: ,(pretty-lit l)) out)
     ]))

(define (pretty-tracen n p)
  (if (trace)
      (if (> (trace) n)
          (pretty-print p)
          '())
      '()))

(define (pretty-trace p)
  (if (trace)
      (pretty-print p)
      '()))