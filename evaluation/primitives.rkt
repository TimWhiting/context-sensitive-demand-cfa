#lang racket/base
(require racket/match racket/pretty racket/list)
(require "table-monad/main.rkt" "abstract-value.rkt" "debug.rkt" "utils.rkt" "config.rkt" "envs.rkt")


(define (lookup-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['= `(prim ,do-equal)]
    ['- `(prim ,do-sub)]
    ['+ `(prim ,do-add)]
    ['* `(prim ,do-mult)]
    ['< `(prim ,do-lt)]
    ['<= `(prim ,do-lte)]
    ['not `(prim ,do-not)]
    ['or `(prim ,do-or)]; TODO Handle in match positions
    ['and `(prim ,do-and)]; TODO Handle in match positions
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
    ['exponential (clos `(con #t) (top-env))]
    ['rebinding (clos `(con #t) (top-env))]
    ['basic (clos (cons `(top) `(app #t)) (top-env))]
    )
  )

(define (false C p)
  (match (analysis-kind)
    ['exponential (clos `(con #f) (top-env))]
    ['rebinding (clos `(con #f) (top-env))]
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
     ;  (print-eval-result `(applying primitive: ,e ,p ,args) (λ ()
     (apply f (cons p (cons C args)))
     ; ))
     ]
    [_ #f]
    ))

(define (do-equal p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 eq?) (f-lit f1 f2 eq?) (f-lit c1 c2 char=?) (f-lit s1 s2 eq?) C p)
        ]
       [_ (false C p)]
       )
     ]
    [_ (each (true C p) (false C p))]) ; Constructors need refinement for equal? - not eq?
  )

(define (do-lte p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 <=) (f-lit f1 f2 <=) (f-lit c1 c2 char<=?) (f-lit s1 s2 string<=?) C p)
        ]
       [_ (clos (cons C 'error-lte-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-lte-not-implemented) p)])
  )


(define (do-lt p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 f2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 <) (f-lit f1 f2 <) (f-lit c1 c2 char<?) (f-lit s1 s2 string<?) C p)]
       [_ (clos (cons C 'error-lte-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-lte-not-implemented) p)])
  )

(define (do-not p C a1)
  (if (is-truthy a1) (false C p) (true C p)))

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
    [(product/set (list `(con #f) _)) #t]; Only literal #f counts as falsey in scheme
    [_ #f]
    )
  )

(define (do-add p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 (bottom) (bottom))))
     (match a2
       [(product/lattice (literal (list i2 f2 (bottom) (bottom)))) (lit (literal (list (when-lit i1 i2 + (top)) (when-lit f1 f2 + (top)) (bottom) (bottom))))]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(define (do-mult p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 (bottom) (bottom))))
     (match a2
       [(product/lattice (literal (list i2 f2 (bottom) (bottom)))) (lit (literal (list (when-lit i1 i2 * (top)) (when-lit f1 f2 * (top)) (bottom) (bottom))))]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(define (do-sub p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 f1 (bottom) (bottom))))
     (match a2
       [(product/lattice (literal (list i2 f2 (bottom) (bottom)))) (lit (literal (list (when-lit i1 i2 - (top)) (when-lit f1 f2 - (top)) (bottom) (bottom))))]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(define (when-lit sl1 sl2 f orelse)
  (match sl1
    [(singleton s1)
     (match sl2
       [(singleton s2) (singleton (f s1 s2))]
       [_ orelse]
       )
     ]
    [(bottom) (match sl2 [(bottom) (bottom)] [_ orelse])]
    [_ orelse]
    )
  )

(define ((for-lit p C) f1 f2 f)
  (match f1
    [(singleton x1)
     (match f2
       [(singleton x2) (f x1 x2)]
       [(bottom) 'bot]
       [_ 'top]
       )
     ]
    [(bottom) (match f2 [(bottom) 'bot])]
    [(top) 'top]
    ))

(define (bool-result r1 r2 r3 r4 C p)
  (if (or (eq? r1 'top) (eq? r2 'top) (eq? r3 'top) (eq? r4 'top))
      (each (true C p) (false C p))
      (if (and (eq? r1 'bot) (eq? r2 'bot) (eq? r3 'bot) (eq? r4 'bot))
          ⊥
          (apply each (map (to-bool C p) (list r1 r2 r3 r4)))
          )))

(define ((to-bool C p) r)
  (if r (true C p) (false C p)))

(define (do-newline p C) (clos `((top) app void) p))
(define (do-display p C . args) (clos `((top) app void) p))
(define (do-void p C) (clos `((top) app void) p))

(provide (all-defined-out))

