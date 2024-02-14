#lang racket/base
(require racket/match racket/pretty racket/list)
(require "table-monad/main.rkt" "demand-abstraction.rkt" "debug.rkt" "utils.rkt" "config.rkt" "envs.rkt")


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

; Primitive constructors can be top env / contexts
(define (truecon C p)
  (match (analysis-kind)
    ['exponential (clos (cons `(top) #t) (top-env))]
    ['rebinding (clos (cons `(top) #t) (top-env))]
    ['basic (clos (cons `(top) #t) (top-env))]
    )
  )

(define (falsecon C p)
  (match (analysis-kind)
    ['exponential (clos (cons `(top) #f) (top-env))]
    ['rebinding (clos (cons `(top) #f) (top-env))]
    ['basic (clos (cons `(top) #f) (top-env))]
    )
  )


(define (true C p) ; Singleton constructors can be top context / envs
  (match (analysis-kind)
    ['exponential (clos `(con #t ()) (top-env))]
    ['rebinding (clos `(con #t ()) (top-env))]
    ['basic (clos (cons `(top) `(app #t)) (top-env))]
    )
  )

(define (false C p)
  (match (analysis-kind)
    ['exponential (clos `(con #f ()) (top-env))]
    ['rebinding (clos `(con #f ()) (top-env))]
    ['basic (clos (cons `(top) `(app #f)) (top-env))]
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

