#lang racket/base
(require "demand.rkt" "debug.rkt" "syntax.rkt" "envs.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match racket/set)
(provide (all-defined-out))

(define (report-times times [trial 0])
  (match times
    ['() ""]
    [(cons (list cpu real gc) rst)
     (string-append
      ","
      (number->string trial)
      ","
      (number->string cpu)
      ","
      (number->string real)
      ","
      (number->string gc)
      (report-times rst (+ 1 trial)))]
    )
  )

(define (report-mcfa-hash h out)
  (for ([keyval (hash->list h)])
    (match keyval
      [(cons (and key (meval Ce p)) _)
       (pretty-print `(query: ,(show-simple-ctx Ce) ,p) out)
       (pretty-result-out out (from-hash key h))
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
    [(envenv l1)
     (match e2
       [(envenv l2) (lt-expr l1 l2)]
       )]
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
  (match r
    [(cons s l)
     (if (set-empty? s)
         (pretty-print `(clos/con: ⊥) out)
         (pretty-print `(clos/con: ,(map show-simple-clos/con (set->list s))) out))
     (pretty-print `(literals: ,(show-simple-literal l)) out)
     ]))
