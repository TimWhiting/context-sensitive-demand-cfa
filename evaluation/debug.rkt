#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt" "abstract-value.rkt" "envs.rkt" "syntax.rkt")
(require racket/match racket/pretty racket/set)

(provide (all-defined-out))


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
           (print-eval-result `(,name ,(show-simple-ctx Ce) ,(show-simple-env p))
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
           (pretty-print `(result ,(show-simple-env p)))
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

(define (show-simple-result r)
  (match r
    [(product/set s) `(clos/con: ,(show-simple-clos/con s))]
    [(product/lattice l) `(literals: ,(show-simple-literal l))]
    )
  )

(define (show-simple-clos/con e [no-env-datatype #t])
  (match e
    [(list `(prim ,l) env) (if (show-envs) `(prim: ,l env: ,(show-simple-env env no-env-datatype)) l)]
    [(list (cons C e) env) (if (show-envs) `(expr: ,(show-simple-ctx (cons C e)) env: ,(show-simple-env env no-env-datatype))
                               `(,(show-simple-ctx (cons C e)) ,(show-simple-env env no-env-datatype)))]
    ;  [(list const env) (if (show-envs) `(con: ,const env: ,(show-simple-env env)) const)]
    )
  )

(define (show-simple-lattice l) (match l [(top) '⊤] [(bottom) '⊥] [(singleton x) x]))
(define (show-simple-literal l) (match l [(literal l) (map show-simple-lattice l)]))
