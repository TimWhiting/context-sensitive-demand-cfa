#lang racket/base
(require racket/match racket/pretty racket/list)
(require "table-monad/main.rkt" "demand-abstraction.rkt" "debug.rkt" "utils.rkt" "config.rkt")

(define (check-known-constructor? x)
  (match x
    ['cons #t]
    ['nil #t]
    ['error #t]
    ))

(define (lookup-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim ,do-equal)]
    ['- `(prim ,do-sub)]
    ['+ `(prim ,do-add)]
    ['< `(prim ,do-lt)]
    ['<= `(prim ,do-lte)]
    ['not `(prim ,do-not)]
    ['or `(prim ,do-or)]; TODO Handle in match positions, TODO: Handle not evaluating all arguments
    ['and `(prim ,do-and)]; TODO Handle in match positions, TODO: Handle not evaluating all arguments
    ['equal? `(prim ,do-equal)]
    ['newline `(prim ,do-newline)]
    ['display `(prim ,do-display)]
    ['void  `(prim ,do-void)]
    [_ #f]
    )
  )


(define (truecon C p)
  (match (analysis-kind)
    ['exponential (clos (cons C #t) p)]
    ['rebinding (clos (cons C #t) p)]
    ['basic (clos (cons C #t) p)]
    ['light (clos (cons C #t) p)]
    ['hybrid (clos (cons C #t) p)]
    )
  )

(define (falsecon C p)
  (match (analysis-kind)
    ['exponential (clos (cons C #f) p)]
    ['rebinding (clos (cons C #f) p)]
    ['basic (clos (cons C #f) p)]
    ['light (clos (cons C #f) p)]
    ['hybrid (clos (cons C #f) p)]
    )
  )


(define (true C p)
  (match (analysis-kind)
    ['exponential (clos `(con #t ()) p)]
    ['rebinding (clos `(con #t ()) p)]
    ['basic (clos (cons C `(app #t)) p)]
    ['light (clos (cons C `(app #t)) p)]
    ['hybrid (clos (cons C `(app #t)) p)]
    )
  )

(define (false C p)
  (match (analysis-kind)
    ['exponential (clos `(con #f ()) p)]
    ['rebinding (clos `(con #f ()) p)]
    ['basic (clos (cons C `(app #f)) p)]
    ['light (clos (cons C `(app #f)) p)]
    ['hybrid (clos (cons C `(app #f)) p)]
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
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (true C p) (false C p))]
       [_ (false C p)]
       )
     ]
    [_ (each (true C p) (false C p))])
  )

(define (do-lte p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (true C p) (false C p))]
       [_ (clos (cons C 'error-lte-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-lte-not-implemented) p)])
  )


(define (do-lt p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2))) (each (true C p) (false C p))]
       [_ (clos (cons C 'error-lte-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-lte-not-implemented) p)])
  )

(define (do-not p C a1)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1))) (each (true C p) (false C p))]
    [(product/set (list `(con #f ()) _)) (true C p)]
    [(product/set (list _ _)) (false C p)]
    )
  )

(define (do-or p C . args)
  (match args
    ['() (false C p)]
    [(cons x '()) (if (is-truthy x) (unit x) (false C p))]
    [(cons x xs) (if (is-truthy x) (unit x) (apply do-or (cons p (cons C xs))))]
    ))

(define (do-and p C . args)
  (match args
    ['() (true C p)]
    [(cons x '()) (if (is-truthy x) (unit x) (false C p))]
    [(cons x xs) (if (is-truthy x) (apply do-and (cons p (cons C xs))) (false C p))]
    ))

(define (is-truthy r)
  (not (is-falsey r)))

(define (is-falsey r)
  (match r
    [(product/set (list `(con #f ()) env)) #t]; Only #f counts as falsey in scheme
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

(define (do-newline p C) ⊥)
(define (do-display p C . args) ⊥)
(define (do-void p C) ⊥)

(provide (all-defined-out))

