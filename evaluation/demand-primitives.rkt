#lang racket/base
(require racket/match racket/pretty)
(require "table-monad/main.rkt" "demand-abstraction.rkt" "debug.rkt" "static-contexts.rkt")
(define (lookup-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim ,do-equal)]
    ['- `(prim ,do-sub)]
    ['+ `(prim ,do-add)]
    ['<= `(prim ,do-lte)]
    ['not `(prim ,do-not)]
    ['or `(prim ,do-or)]
    ['and `(prim ,do-and)]
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
    [_ (each (clos #t p) (clos #f p))])
  )
(define (do-lte p a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (clos #t p) (clos #f p))]
       [_ (clos #f p)]
       )
     ]
    [_ (clos #f p)])
  )

(define (do-not p a1)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1))) (each (clos #f p) (clos #t p))]
    [(product/set (list #f _)) (clos #t p)]
    [(product/set (list #t _)) (clos #f p)]
    )
  )

(define (do-or p . args)
  (if (ors (map is-true args))
      (clos #t p)
      (clos #f p)
      ))

(define (do-and p . args)
  (if (alls (map is-true args))
      (clos #t p)
      (clos #f p)
      ))

(define (is-true r)
  (match r
    [(product/set (list #t _)) #t]
    [_ #f]
    )
  )
(define (is-false r)
  (match r
    [(product/set (list #f _)) #t]
    [_ #f]
    )
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

(provide (all-defined-out))

