#lang racket/base
(require "demand.rkt" "abstract-value.rkt" "debug.rkt" "syntax.rkt" "envs.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match racket/set racket/string)
(provide (all-defined-out))

(define (sort-by-key l)
  (sort l (lambda (x y) (string<? (car x) (car y))))
  )

(define (report-mcfa-hash h out)
  (define evals (filter (lambda (x) (match x [(cons (meval _ _) _) #t] [_ #f])) (hash->list h)))
  (define stores (filter (lambda (x) (match x [(cons (store _) _) #t] [_ #f])) (hash->list h)))
  (define eval-new-key
    (sort-by-key
     (map (lambda (x)
            (match x [(cons (meval Ce p) v)
                      (cons (pretty-format `(query: ,(show-simple-ctx Ce) ,(show-simple-env p))) v)]))
          evals)))
  (define store-new-key
    (sort-by-key
     (map (lambda (x)
            (match x [(cons (store (cons Ce p)) v)
                      (cons (pretty-format `(store: ,(show-simple-ctx Ce) ,(show-simple-env p))) v)]))
          stores)))

  (for ([keyval eval-new-key])
    (match keyval
      [(cons key v)
       (pretty-display "" out)
       (displayln key out)
       (pretty-result-out out (from-value v))
       ]
      [_ '()]
      )
    )
  (for ([keyval store-new-key])
    (match keyval
      [(cons key v)
       (pretty-display "" out)
       (displayln key out)
       (pretty-result-out out (from-value v))
       ]
      [_ '()]
      )
    )
  )

(define (lt-expr e1 e2)
  (match e1
    [(cons x xs)
     (match e2
       [(cons y ys)
        (if (lt-expr x y)
            #t
            (if (lt-expr y x)
                #f
                (lt-expr xs ys)))]
       [_ #f]
       )]
    [#t #f]
    [#f #t]
    ['() #t]
    [(menv l1)
     (match e2
       [(menv l2) (lt-expr l1 l2)]
       )]
    [(? number? n1) (match e2 [(? number? n2) (< n1 n2)][_ #t])]
    [(? string? n1) (match e2 [(? string? n2) (string<? n1 n2)][_ #t])]
    [(? char? n1) (match e2 [(? char? n2) (char<? n1 n2)][_ #t])]
    [(? symbol? n1) (match e2 [(? symbol? n2) (symbol<? n1 n2)]
                      [n2
                       ;  (pretty-print `(sym-comp ,n1 ,n2))
                       #t])]
    )
  )

(define (simple-key k)
  (match k
    [(eval Ce p) `(eval ,(show-simple-ctx Ce) ,(show-simple-env p))]
    [(expr Ce p) `(expr ,(show-simple-ctx Ce) ,(show-simple-env p))]
    [(refine p) `(refine ,(show-simple-env p))]
    )
  )

(define (query->string q)
  (string-append "\"" (pretty-format (simple-key q)) "\"")
  )

(define (queries hm)
  (sort (filter (lambda (x) (not (equal? x '()))) (map simple-key (hash-keys hm))) lt-expr)
  )

(define (pretty-result r)
  (pretty-result-out (current-output-port) r))

(define (pretty-result-out out r)
  (displayln (show-simple-results r) out))

(define (show-simple-results r)
  ; (pretty-print r)
  (match r
    [(cons s l)
     (string-append
      (if (set-empty? s)
          "clos/con: ⊥"
          (format "clos/con:\n\t~a" (string-join (sort (map (lambda (x) (pretty-format (show-simple-clos/con x))) (set->list s)) string<?) "\n\t")))
      "\n"
      (format "literals: ~a" (pretty-format (show-simple-literal l))))
     ]
    [x (pretty-format x)]
    ))

(define (is-bottom r)
  (match r
    [(cons s (literal l))
     (and (set-empty? s) (andmap bottom? l))
     ]
    )
  )