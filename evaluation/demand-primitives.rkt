#lang racket/base
(require racket/match racket/pretty)
(require "table-monad/main.rkt" "demand-abstraction.rkt" "debug.rkt")
(define (lookup-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim ,do-equal)]
    ['- `(prim ,do-sub)]
    ['+ `(prim ,do-add)]
    [_ #f]
    )
  )

(define (is-primitive e)
  (match e
    [`(prim ,f) #t]
    [_ #f]
    )
  )

; Evaluates a primitive with fully evaluated primitive arguments
(define (apply-primitive e p args)
  (match e
    [`(prim ,f)
     (print-eval-result `(applying primitive: ,e ,p ,args) (λ () (apply f (cons p args))))]
    [_ #f]
    ))

(define (do-equal p a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (clos #t p) (clos #f p))]
       [_ (clos #f p)]
       )
     ]
    [_ (clos #f p)])
  )

(define (do-sub p a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (lit (literal (list (top) (bottom) (bottom) (bottom))))]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(define (do-add p a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (lit (literal (list (top) (bottom) (bottom) (bottom))))]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(provide (all-defined-out))

