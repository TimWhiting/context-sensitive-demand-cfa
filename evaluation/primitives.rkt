#lang racket/base
(require racket/match racket/pretty racket/list)
(require "table-monad/main.rkt" "abstract-value.rkt" "debug.rkt" "utils.rkt" "config.rkt" "envs.rkt")
(require (rename-in "table-monad/main.rkt"))

(define (lookup-primitive x)
  ; (pretty-print `(primitive-lookup ,x))
  (match x
    ['random `(prim random ,do-random)]
    ['ceiling `(prim ceiling ,do-ceiling)]
    ['log `(prim log ,do-log)]
    ['= `(prim = ,do-equal)]
    ['- `(prim - ,do-sub)]
    ['+ `(prim + ,do-add)]
    ['* `(prim * ,do-mult)]
    ['/ `(prim / ,do-div)]
    ['modulo `(prim modulo ,do-modulo)]
    ['gcd `(prim gcd ,do-gcd)]
    ['quotient `(prim quotient,do-quotient)]
    ['< `(prim < ,do-lt)]
    ['> `(prim > ,do-gt)]
    ['<= `(prim <= ,do-lte)]
    ['odd? `(prim odd? ,do-odd)] ; Numbers work with the regular data model
    ['even? `(prim even? ,do-even)] ; Numbers work with the regular data model
    ['not `(prim not ,do-not)]
    ['or `(prim or ,do-or)]; TODO Handle in match positions
    ['and `(prim and ,do-and)]; TODO Handle in match positions
    ['equal? `(prim equal? ,do-equal)]
    ['eq? `(prim eq? ,do-equal)]
    ['symbol? `(prim symbol? ,do-symbol?)]
    ['char? `(prim char? ,do-char?)]
    ['newline `(prim newline ,do-newline)]
    ['display `(prim display ,do-display)]
    ['number->string `(prim number->string ,do-number-string)]
    ['string-append `(prim string-append ,do-string-append)]
    ['string-length `(prim string-length ,do-string-length)]
    ['boolean? `(prim boolean? ,do-boolean?)]
    ['integer? `(prim integer? ,do-integer?)]
    ['number? `(prim number? ,do-number?)]
    ['string? `(prim string? ,do-string?)]
    ['list? `(prim list? ,do-list?)]
    ['procedure? `(prim procedure? ,do-procedure?)]
    ['void  `(prim void ,do-void)]
    [_ #f]
    )
  )

; Primitive constructors can be top env / contexts
(define (voidcon C p)
  (match (analysis-kind)
    ['exponential (clos `((top) app void) (top-env))]
    ['rebinding (clos `((top) app void) (top-env))]
    ['basic (clos `((top) app void) (top-env))]
    )
  )

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
    [`(prim ,_ ,f) #t]
    [_ #f]
    )
  )

; Evaluates a primitive with fully evaluated primitive arguments
(define (apply-primitive e C p args)
  (match e
    [`(prim ,_ ,f)
     ;  (print-eval-result `(applying primitive: ,e ,p ,args) (λ ()
     (apply f (cons p (cons C args)))
     ; ))
     ]
    [_ #f]
    ))

(define (do-equal p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 eq?) (f-lit c1 c2 char=?) (f-lit s1 s2 eq?) C p)
        ]
       [_ (false C p)]
       )
     ]
    [_ (each (true C p) (false C p))]) ; Constructors need refinement for equal? - not eq?
  )



(define (do-number-string p C a1)
  ; (pretty-print a1)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (match i1
       [(bottom) ⊥]
       [_ topstr]
       )
     ]
    [_ ⊥])
  )

; TODO: Refinement make sure all args are string
(define (do-string-append p C . args) topstr)

(define (do-string-length p C s) topnum)

(define (do-not p C a1)
  (if (is-truthy a1) (false C p) (true C p)))

(define (do-boolean? p C a1)
  ; (pretty-print a1)
  (if (is-bool a1) (true C p) (false C p)))

(define (do-integer? p C a1)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (if (bottom? i1)
         (false C p)
         (if (top? i1) ; A number could be either a int or some other number
             (each (false C p) (true C p))
             (true C p)
             )
         )]
    [_ (false C p)]
    ))

(define (do-number? p C a1)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (if (bottom? i1)
         (false C p)
         (true C p)
         )]
    [_ (false C p)]
    ))

(define (do-string? p C a1)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (if (bottom? s1)
         (false C p)
         (true C p)
         )]
    [_ (false C p)]
    ))

(define (do-procedure? p C a1)
  (match a1
    [(product/set (list (cons C `(λ ,_ ,_)) pl)) (true C p)]; Only literal #f counts as falsey in scheme
    [_ (false C p)]
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
    [(product/set (list `(con #f) _)) #t]; Only literal #f counts as falsey in scheme
    [_ #f]
    )
  )

(define (is-bool r)
  (match r
    [(product/set (list `(con #f) _)) #t]
    [(product/set (list `(con #t) _)) #t]
    [_ #f]
    )
  )

(define (do-symbol? p C a1)
  (match a1
    [(product/set (list (cons C `',x) p))
     (true C p) ]
    [_ (false C p)])
  )

(define (do-list? p C a1)
  (match a1
    [(product/set (list (list C 'con _) p))
     (true C p) ]
    [(product/set (list (list C 'nil) p))
     (true C p) ]
    [_ (false C p)])
  )

(define (do-char? p C a1)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (if (not (bottom? c1)) (true C p) (false C p)) ]
    [_ (false C p)])
  )


(define (do-lte p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 <=) (f-lit c1 c2 char<=?) (f-lit s1 s2 string<=?) C p)
        ]
       [_ (clos (cons C 'error-lte-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-lte-not-implemented) p)])
  )


(define (do-lt p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 <) (f-lit c1 c2 char<?) (f-lit s1 s2 string<?) C p)]
       [_ (clos (cons C 'error-lt-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-lt-not-implemented) p)])
  )

(define (do-gt p C a1 a2)
  (match a1
    [(product/lattice (literal (list i1 c1 s1)))
     (match a2
       [(product/lattice (literal (list i2 c2 s2)))
        (define f-lit (for-lit p C))
        (bool-result (f-lit i1 i2 >) (f-lit c1 c2 char>?) (f-lit s1 s2 string>?) C p)]
       [_ (clos (cons C 'error-gt-not-implemented) p)]
       )
     ]
    [_ (clos (cons C 'error-gt-not-implemented) p)])
  )

(define (do-odd p C a1)
  (match a1
    [(product/lattice (literal (list (singleton x) (bottom) (bottom))))
     (if (integer? x)
         (if (odd? x) (true C p) (false C p))
         (each (true C p) (false C p))
         )
     ]
    [(product/lattice (literal (list (top) (bottom) (bottom))))
     (each (true C p) (false C p))
     ]
    [_ ⊥]
    ; [_ (clos (cons C 'error-odd-not-implemented) p)]
    ))

(define (do-even p C a1)
  (match a1
    [(product/lattice (literal (list (singleton x) (bottom) (bottom))))
     (if (integer? x)
         (if (even? x) (true C p) (false C p))
         (each (true C p) (false C p))
         )
     ]
    [(product/lattice (literal (list (top) (bottom) (bottom))))
     (each (true C p) (false C p))
     ]
    [_ ⊥]
    ; [_ (clos (cons C 'error-odd-not-implemented) p)]
    ))

(define (do-add p C a1 a2)
  (do-num-op a1 a2 +)
  )

(define (do-mult p C a1 a2)
  (do-num-op a1 a2 *)
  )

(define (do-div p C a1 a2)
  (do-num-op-check a1 a2 / check-non-zero)
  )

(define (do-sub p C a1 a2)
  (do-num-op a1 a2 -)
  )

(define (do-modulo p C a1 a2)
  (do-num-op-check a1 a2 modulo check-non-zero)
  )

(define (do-gcd p C a1 a2)
  (do-num-op a1 a2 gcd)
  )

(define (do-quotient p C a1 a2)
  (do-num-op-check a1 a2 quotient check-non-zero)
  )

(define (check-non-zero x y)
  (if (equal? y 0) #f #t)
  )

(define (do-ceiling p C a1)
  (match a1
    [(product/lattice (literal (list x (bottom) (bottom))))
     (apply each (list
                  (if (singleton? x) (lit (litnum (ceiling x))) ⊥)
                  (if (top? x)
                      (lit (literal (list (top) (bottom) (bottom))))
                      ⊥
                      )))
     ]
    [_ ⊥])
  )

(define (do-log p C a1)
  (match a1
    [(product/lattice (literal (list x (bottom) (bottom))))
     (apply each (list
                  (if (singleton? x) (if (eq? x 1)
                                         (lit (litnum 0))
                                         (if (eq? x 0)
                                             ⊥ ; Exception
                                             (lit (litnum (log (singleton-x x))))
                                             )
                                         ) ⊥)
                  (if (top? x)
                      (lit (literal (list (top) (bottom) (bottom))))
                      ⊥
                      )))
     ]
    [_ ⊥])
  )


(define (do-num-op-check a1 a2 op check)
  (match a1
    [(product/lattice (literal (list n1 (bottom) (bottom))))
     (match a2
       [(product/lattice (literal (list n2 (bottom) (bottom))))
        (apply each (list
                     (if (and (singleton? n1) (singleton? n2))
                         (if (check (singleton-x n1) (singleton-x n2))
                             (lit (litnum (op (singleton-x n1) (singleton-x n2))))
                             topnum
                             )
                         ⊥)
                     (if (or (top? n1) (top? n2)) topnum ⊥)
                     )
               )
        ]
       [_ ⊥]
       )
     ]
    [_ ⊥])
  )

(define (do-num-op a1 a2 op)
  (match a1
    [(product/lattice (literal (list n1 (bottom) (bottom))))
     (match a2
       [(product/lattice (literal (list n2 (bottom) (bottom))))
        (apply each (list
                     (if (and (singleton? n1) (singleton? n2)) (lit (litnum (op (singleton-x n1) (singleton-x n2)))) ⊥)
                     (if (or (top? n1) (top? n2)) topnum ⊥)
                     )
               )
        ]
       [_ ⊥]
       )
     ]
    [_ ⊥])
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
    [(bottom) (match f2 [_ 'bot])]
    [(top) 'top]
    ))

(define (bool-result r1 r3 r4 C p)
  (if (or (eq? r1 'top) (eq? r3 'top) (eq? r4 'top))
      (each (true C p) (false C p))
      (if (and (eq? r1 'bot) (eq? r3 'bot) (eq? r4 'bot))
          ⊥
          (apply each (map (to-bool C p) (list r1 r3 r4)))
          )))

(define ((to-bool C p) r)
  (match r
    ['bot ⊥]
    ['top (each (true C p) (false C p))]
    [#f (false C p)]
    [#t (true C p)]
    ))

(define (do-newline p C) (voidcon C p))
(define (do-display p C . args) (voidcon C p))
(define (do-void p C) (voidcon C p))
(define (do-random p C . args)
  (match args
    [(list b t) (error 'unsupported-primitive-random-2-args "")]
    [(list n)
     (lit (literal (list (top) (bottom) (bottom))))]
    [(list)
     (lit (literal (list (top) (bottom) (bottom))))])
  )


(provide (all-defined-out))

