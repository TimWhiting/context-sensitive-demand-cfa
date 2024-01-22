#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "demand-abstraction.rkt")
(require racket/match racket/pretty racket/set)

(provide (all-defined-out))

(define (print-eval-result input computation)
  (if (trace) (pretty-print `(start ,input)) '())
  (>>=eval
   (computation)
   (λ (Cee ρee)
     (if (trace)
         (begin
           (pretty-print `(end ,input))
           (pretty-print `(result ,Cee ,ρee))
           (clos Cee ρee))
         (clos Cee ρee)
         )
     )
   (λ (num)
     (if (trace)
         (begin
           (pretty-print `(end ,input))
           (pretty-print `(result ,num))
           (lit num))
         (lit num)
         )
     )
   )
  )

(define (debug-eval name comp)
  (λ (Ce p) (print-eval-result `(,name ,Ce ,p) (λ () (comp Ce p))))
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
           (pretty-print `(result ,Cee ,ρee))
           (unit Cee ρee))
         (unit Cee ρee)))))


(define (pretty-result r)
  (pretty-result-out (current-output-port) r))

(define (pretty-result-out out r)
  (match r
    [(cons s l)
     (define (pretty-closure/cons c)
       (match c
         [(cons (cons ctx ex) env) (if (show-envs) `(expr: ,ex env: ,env) ex )]
         ))
     (define (pretty-simple l) (match l [(top) '⊤] [(bottom) '⊥] [(singleton x) x]))
     (define (pretty-lit l) (match l [(literal l) (map pretty-simple l)]))
     (define (pretty-env e) (pretty-print `(env: ,e)))
     (if (set-empty? s) (pretty-print `(clos/con: ⊥) out) (pretty-print `(clos/con: ,(map pretty-closure/cons (set->list s))) out))
     (pretty-print `(literals: ,(pretty-lit l)) out)
     ]))

(define (pretty-tracen n p)
  (if (trace)
      (if (> (trace) n)
          (pretty-print p)
          (void))
      (void)))

(define (pretty-trace p)
  (if (trace)
      (pretty-print p)
      (void)))