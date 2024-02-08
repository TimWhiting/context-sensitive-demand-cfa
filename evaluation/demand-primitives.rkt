#lang racket/base
(require racket/match racket/pretty)
(require "table-monad/main.rkt" "demand-abstraction.rkt" "debug.rkt" "utils.rkt")
(define (lookup-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim ,do-equal)]
    ['- `(prim ,do-sub)]
    ['+ `(prim ,do-add)]
    ['<= `(prim ,do-lte)]
    ['not `(prim ,do-not)]
    ['or `(prim ,do-or)]; TODO Handle in match positions
    ['and `(prim ,do-and)]; TODO Handle in match positions
    ['equal? `(prim, do-equal)]
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
(define (apply-primitive e C p args)
  (match e
    [`(prim ,f)
     (print-eval-result `(applying primitive: ,e ,p ,args) (λ () (apply f (cons p (cons C args)))))]
    [_ #f]
    ))

; TODO: Improve the primitives
(define (do-equal p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (clos (cons C #t) p) (clos (cons C #f) p))]
       [_ (clos (cons C #f) p)]
       )
     ]
    [_ (each (clos (cons C #t) p) (clos (cons C #f) p))])
  )
(define (do-lte p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (clos (cons C #t) p) (clos (cons C #f) p))]
       [_ (clos (cons C #f) p)]
       )
     ]
    [_ (clos (cons C #f) p)])
  )

(define (do-not p C a1)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1))) (each (clos #f p) (clos #t p))]
    [(product/set (list (cons _ #f) _)) (clos (cons C #t) p)]
    [(product/set (list (cons _ #t) _)) (clos (cons C #f) p)]
    )
  )

(define (do-or p C . args)
  ; (pretty-print (ors (map is-true args)))
  (if (ors (map is-truthy args))
      (clos (cons C #t) p)
      (clos (cons C #f) p)
      ))

(define (do-and p C . args)
  (if (alls (map is-truthy args))
      (clos (cons C #t) p)
      (clos (cons C #f) p)
      ))

(define (is-truthy r)
  (not (is-falsey r)))

(define (is-falsey r)
  (match r
    [(product/set (list (cons C #f) env)) #t]; Only #f counts as falsey in scheme
    [_ #f]
    )
  )

(define (do-add p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (lit (literal (list (top) (bottom) (bottom) (bottom))))]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(define (do-sub p C a1 a2)
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

