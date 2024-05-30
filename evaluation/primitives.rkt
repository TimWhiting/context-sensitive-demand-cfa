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
    ['char=? `(prim = ,do-equal)]
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
    ['char-numeric? `(prim char-numeric? ,do-char-numeric?)]
    ['char-alphabetic? `(prim char-alphabetic? ,do-char-alphabetic?)]
    ['char->integer `(prim char->integer ,do-char->integer)]
    ['symbol->string `(prim symbol->string ,do-symbol->string)]
    ['string-ref `(prim string-ref ,do-string-ref)]
    ['string->symbol `(prim string->symbol ,do-string->symbol)]
    ['list->string `(prim list->string ,do-list-string)]
    ['void  `(prim void ,do-void)]
    [_ #f]
    )
  )

; Primitive constructors can be top env / contexts


(define (truecon)
  (match (analysis-kind)
    ['exponential (clos (cons `(top) `(typedef (#t))) (top-env))]
    ['rebinding (clos (cons `(top) `(typedef (#t))) (top-env))]
    ['basic (clos (cons `(top) #t) (top-env))]
    )
  )

(define (falsecon)
  (match (analysis-kind)
    ['exponential (clos (cons `(top) `(typedef (#f))) (top-env))]
    ['rebinding (clos (cons `(top) `(typedef (#f))) (top-env))]
    ['basic (clos (cons `(top) #f) (top-env))]
    )
  )

(define (errorv msg) ; Singleton constructors can be top context / envs
  (match (analysis-kind)
    ['exponential (clos `(con error ,(cons `(top) `(app error ,msg))) (top-env))]
    ['rebinding (clos `(con error ,(cons `(top) `(app error ,msg))) (top-env))]
    ['basic (clos (cons `(top) `(app error ,msg)) (top-env))]
    )
  )

(define (voidv) ; Singleton constructors can be top context / envs
  (match (analysis-kind)
    ['exponential (clos `(con void) (top-env))]
    ['rebinding (clos `(con void) (top-env))]
    ['basic (clos (cons `(top) `(app void)) (top-env))]
    )
  )

(define (true) ; Singleton constructors can be top context / envs
  (match (analysis-kind)
    ['exponential (clos `(con #t) (top-env))]
    ['rebinding (clos `(con #t) (top-env))]
    ['basic (clos (cons `(top) `(app #t)) (top-env))]
    )
  )

(define (false)
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

(define (do-equal p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1)))
           (product/lattice (literal (list i2 c2 s2 sy2))))
     (define f-lit (for-lit p C))
     (bool-result (f-lit i1 i2 =) (f-lit c1 c2 char=?) (f-lit s1 s2 eq?) (f-lit sy1 sy2 eq?) C p)]
    [_ (each (true) (false))]) ; Constructors need refinement for equal? - not eq?
  )

(define (do-number-string p C . args)
  ; (pretty-print args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))))
     (match i1
       [(bottom) ⊥]
       [_ topstr]
       )
     ]
    [_ ⊥])
  )


(define (do-list-string p C . args)
  topstr)

(define (do-symbol->string p C . args)
  (match args
    [(list (product/lattice (literal (list n1 c1 s1 (singleton sy1)))))
     (lit (litstring (symbol->string sy1)))
     ]
    [(list (product/lattice (literal (list n1 c1 s1 (top)))))
     topstr
     ]
    [_ ⊥]
    ))

(define (do-string->symbol p C . args)
  (match args
    [(list (product/lattice (literal (list n1 c1 (singleton s1) sy1))))
     (lit (litsym (string->symbol s1)))
     ]
    [(list (product/lattice (literal (list n1 c1 (top) sy1))))
     topsym
     ]
    [_ ⊥]
    ))

(define (do-string-ref p C . args)
  (match args
    [(list (product/lattice (literal (list n1 c1 (singleton s1) sy1))) (product/lattice (literal (list (singleton n2) c2 s2 sy2))))
     (if (>= n2 (string-length s1)) (errorv "index-out-of-range") (lit (litchar (string-ref s1 n2))))
     ]
    [(list (product/lattice (literal (list n1 c1 s1 sy1))) (product/lattice (literal (list n2 c2 s2 sy2))))
     (if (or (not (bottom? s1)) (not (bottom? n2))) topchar ⊥)
     ]
    [_ ⊥]
    ))

; TODO: Refinement make sure all args are string
(define (do-string-append p C . args) topstr)

(define (do-string-length p C . args) topnum)

(define (do-not p C . args)
  (if (is-truthy (car args)) (false) (true)))

(define (do-boolean? p C . args)
  ; (pretty-print args)
  (if (is-bool (car args)) (true) (false)))

(define (do-integer? p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))))
     (if (bottom? i1)
         (false)
         (if (top? i1) ; A number could be either a int or some other number
             (each (false) (true))
             (true)
             )
         )]
    [_ (false)]
    ))

(define (do-number? p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))))
     (if (bottom? i1)
         (false)
         (true)
         )]
    [_ (false)]
    ))

(define (do-string? p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))))
     (if (bottom? s1)
         (false)
         (true)
         )]
    [_ (false)]
    ))

(define (do-procedure? p C . args)
  (match args
    [(list (product/set (list (cons C `(λ ,_ ,_)) pl))) (true)]
    [_ (false)]
    )
  )

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

(define (do-symbol? p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))))
     (if (bottom? sy1)
         (false)
         (true)
         )]
    [_ (false)]
    ))

(define (do-list? p C . args)
  (match args
    [(list (product/set (list (list C 'con _) p)))
     (true) ]
    [(list (product/set (list (list C 'nil) p)))
     (true) ]
    [_ (false)])
  )

(define (do-char? p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))))
     (if (not (bottom? c1)) (true) (false)) ]
    [_ (false)])
  )

(define (do-char-numeric? p C . args)
  (match args
    [(list (product/lattice (literal (list n1 (singleton c) s1 sy1))))
     (if (char-numeric? c) (true) (false))
     ]
    [(list (product/lattice (literal (list n1 (top) s1 sy1))))
     (each (true) (false))
     ]
    [_ (false)]
    )
  )

(define (do-char-alphabetic? p C . args)
  (match args
    [(list (product/lattice (literal (list n1 (singleton c) s1 sy1))))
     (if (char-alphabetic? c) (true) (false))
     ]
    [(list (product/lattice (literal (list n1 (top) s1 sy1))))
     (each (true) (false))
     ]
    [_ (false)]
    )
  )

(define (do-char->integer p C . args)
  (match args
    [(list (product/lattice (literal (list n1 (singleton c) s1 sy1))))
     (lit (litnum (char->integer c)))
     ]
    [(list (product/lattice (literal (list n1 (top) s1 sy1))))
     topnum
     ]
    [_ (false)]
    )
  )


(define (do-lte p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1)))
           (product/lattice (literal (list i2 c2 s2 sy2))))
     (define f-lit (for-lit p C))
     (bool-result (f-lit i1 i2 <=) (f-lit c1 c2 char<=?) (f-lit s1 s2 string<=?)
                  (f-lit sy1 sy1 (lambda (x1 x2) (or (eq? x1 x2) (symbol<? x1 x2)))) C p)
     ]
    [_ ⊥])
  )


(define (do-lt p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1)))
           (product/lattice (literal (list i2 c2 s2 sy2))))
     (define f-lit (for-lit p C))
     (bool-result (f-lit i1 i2 <) (f-lit c1 c2 char<?) (f-lit s1 s2 string<?) (f-lit sy1 sy2 symbol<?) C p)]

    [_ ⊥])
  )

(define (do-gt p C . args)
  (match args
    [(list (product/lattice (literal (list i1 c1 s1 sy1))) (product/lattice (literal (list i2 c2 s2 sy2))))
     (define f-lit (for-lit p C))
     (bool-result (f-lit i1 i2 >) (f-lit c1 c2 char>?) (f-lit s1 s2 string>?) (f-lit sy2 sy1 symbol<?) C p)]
    [_ ⊥])
  )

(define (do-odd p C . args)
  (match args
    [(list (product/lattice (literal (list (singleton x) (bottom) (bottom) (bottom)))))
     (if (integer? x)
         (if (odd? x) (true) (false))
         (each (true) (false))
         )
     ]
    [(list (product/lattice (literal (list (top) c1 s1 sy1))))
     (each (true) (false))
     ]
    [_ ⊥]
    ; [_ (clos (cons C 'error-odd-not-implemented) p)]
    ))

(define (do-even p C . args)
  (match args
    [(list (product/lattice (literal (list (singleton x) (bottom) (bottom) (bottom)))))
     (if (integer? x)
         (if (even? x) (true) (false))
         (each (true) (false))
         )
     ]
    [(list (product/lattice (literal (list (top) c1 s1 sy1))))
     (each (true) (false))
     ]
    [_ ⊥]
    ; [_ (clos (cons C 'error-odd-not-implemented) p)]
    ))

(define (do-add p C . args)
  (do-num-op args +)
  )

(define (do-mult p C . args)
  (do-num-op args *)
  )

(define (do-div p C . args)
  (do-num-op-check args / check-non-zero)
  )

(define (do-sub p C . args)
  (do-num-op args -)
  )

(define (do-modulo p C . args)
  (do-num-op-check args modulo check-non-zero)
  )

(define (do-gcd p C . args)
  (do-num-op args gcd)
  )

(define (do-quotient p C . args)
  (do-num-op-check args quotient check-non-zero)
  )

(define (check-non-zero x y)
  (if (equal? y 0) #f #t)
  )

(define (do-ceiling p C . args)
  (match args
    [(list (product/lattice (literal (list x c1 s1 sy1))))
     (apply each (list
                  (if (singleton? x) (lit (litnum (ceiling x))) ⊥)
                  (if (top? x)
                      topnum
                      ⊥
                      )))
     ]
    [_ ⊥])
  )

(define (do-log p C . args)
  (match args
    [(list (product/lattice (literal (list x c1 s1 sy1))))
     (apply each (list
                  (if (singleton? x) (if (eq? x 1)
                                         (lit (litnum 0))
                                         (if (eq? x 0)
                                             ⊥ ; Exception
                                             (lit (litnum (log (singleton-x x))))
                                             )
                                         ) ⊥)
                  (if (top? x)
                      topnum
                      ⊥
                      )))
     ]
    [_ ⊥])
  )


(define (do-num-op-check args op check)
  (match args
    [(list (product/lattice (literal (list n1 c1 s1 sy1)))
           (product/lattice (literal (list n2 c2 s2 sy2))))
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
    [_ ⊥])
  )

(define (do-num-op args op)
  (match args
    [(list (product/lattice (literal (list n1 c1 s1 sy1)))
           (product/lattice (literal (list n2 c2 s2 sy2))))
     (if (and (singleton? n1) (singleton? n2)) (lit (litnum (op (singleton-x n1) (singleton-x n2))))
         (if (or (top? n1) (top? n2)) topnum ⊥))
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

(define (bool-result r1 r3 r4 r5 C p)
  (if (or (eq? r1 'top) (eq? r3 'top) (eq? r4 'top) (eq? r5 'top))
      (each (true) (false))
      (if (and (eq? r1 'bot) (eq? r3 'bot) (eq? r4 'bot) (eq? r5 'bot))
          ⊥
          (apply each (map (to-bool C p) (list r1 r3 r4 r5)))
          )))

(define ((to-bool C p) r)
  (match r
    ['bot ⊥]
    ['top (each (true) (false))]
    [#f (false)]
    [#t (true)]
    ))

(define (do-newline p C . args) (voidv))
(define (do-display p C . args) (voidv))
(define (do-void p C . args) (voidv))
(define (do-random p C . args)
  (match args
    [(list b t) (error 'unsupported-primitive-random-2-args "")]
    [(list n)
     topnum]
    [(list)
     topnum])
  )


(provide (all-defined-out))

