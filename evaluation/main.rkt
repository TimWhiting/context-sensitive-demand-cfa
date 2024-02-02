#lang racket/base
(require "demand.rkt" "all-examples.rkt" "static-contexts.rkt" "config.rkt" "debug.rkt" racket/match)
(require "m-cfa.rkt")
(require racket/pretty)

(define (hash-num-keys h) (length (hash-keys h)))
(define (zip l1 l2) (map list l1 l2))

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (for ([m (in-range 2)])
    (current-m m)
    (let ([basic-cost 0]
          [hybrid-cost 0]
          [mcfa-cost 0])
      (for ([example successful-examples])
        ; (for ([example test-examples])
        (match-let ([`(example ,name ,exp) example])
          (define out-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-results.txt") #:exists 'replace))
          (define out-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-results.txt") #:exists 'replace))
          (define out-keys-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-keys.txt") #:exists 'replace))
          (define out-keys-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-keys.txt") #:exists 'replace))
          (define out-mcfa-rebinding (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-rebind-results.txt") #:exists 'replace))
          (define out-mcfa-expm (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-expm-results.txt") #:exists 'replace))
          (pretty-displayn 0 "")
          (pretty-displayn 0 "")
          (pretty-display "Analyzing expression: ")
          (pretty-display name)
          (pretty-print exp)
          (pretty-print `(expression: ,exp) out-basic)
          (pretty-print `(expression: ,exp) out-hybrid)
          (pretty-print `(expression: ,exp) out-keys-basic)
          (pretty-print `(expression: ,exp) out-keys-hybrid)
          (pretty-print `(expression: ,exp) out-mcfa-rebinding)
          (pretty-print `(expression: ,exp) out-mcfa-expm)
          (pretty-displayn 0 "")
          ; (show-envs #t)
          ; (trace 1)
          (analysis-kind 'exponential)
          (define exph (run-get-hash (meval (cons `(top) exp) (expenv '())) (hash)))
          ; (pretty-print exph)
          (for ([keyval (hash->list exph)])
            (match keyval
              [(cons (and key (meval Ce p)) _)
               (pretty-print `(query: ,(show-simple-ctx Ce) ,p) out-mcfa-expm)
               (pretty-result-out out-mcfa-expm (from-hash key exph))
               ]
              [_ '()]
              )
            )
          (analysis-kind 'rebinding)
          (define rebh (run-get-hash (meval (cons `(top) exp) (flatenv '())) (hash)))
          ; (pretty-print exph)
          (for ([keyval (hash->list rebh)])
            (match keyval
              [(cons (and key (meval Ce p)) _)
               (pretty-print `(query: ,(show-simple-ctx Ce) ,p) out-mcfa-rebinding)
               (pretty-result-out out-mcfa-rebinding (from-hash key rebh))
               ]
              [_ '()]
              )
            )
          (analysis-kind 'basic)
          (let ([qbs (gen-queries (cons `(top) exp) (menv (list)))])
            (analysis-kind 'hybrid)
            (let ([qhs (gen-queries (cons `(top) exp) (envenv (list)))])
              (for ([qs (zip qbs qhs)])
                (match-let ([h1 (hash)]
                            [h2 (hash)]
                            ; TODO: Is it okay for the continuations to escape and be reused later?
                            [(list (list cb pb) (list ch ph)) qs])
                  (define evalqb (eval cb pb))
                  (define evalqh (eval ch ph))
                  (pretty-tracen 0 "Running query ")
                  (pretty-print `(query: ,(show-simple-ctx cb) ,pb) out-basic)
                  (pretty-print `(query: ,(show-simple-ctx ch) ,ph) out-hybrid)
                  ; (pretty-print `(query: ,(show-simple-ctx cb) ,pb))
                  ; (pretty-print `(query: ,(show-simple-ctx ch) ,ph))

                  (analysis-kind 'basic)
                  (set! h1 (run-get-hash evalqb h1))
                  (set! basic-cost (+ basic-cost (hash-num-keys h1)))
                  (pretty-result-out out-basic (from-hash evalqb h1))
                  (if #t (begin
                           (analysis-kind 'hybrid)
                           (set! h2 (run-get-hash evalqh h2))
                           (set! hybrid-cost (+ hybrid-cost (hash-num-keys h2)))
                           (pretty-tracen 0 (from-hash evalqh h2))
                           (pretty-result-out out-hybrid (from-hash evalqh h2))
                           (if (equal? (length (hash-keys h1)) (length (hash-keys h2)))
                               '()
                               (begin
                                 (pretty-display "" out-keys-basic)
                                 (pretty-display "" out-keys-hybrid)
                                 (pretty-print `(query: ,(show-simple-ctx cb) ,pb) out-keys-basic)
                                 (pretty-print `(query: ,(show-simple-ctx ch) ,ph) out-keys-hybrid)
                                 (pretty-display "" out-keys-basic)
                                 (pretty-display "" out-keys-hybrid)
                                 (pretty-print (sort (map simple-key (hash-keys h2)) lt-expr) out-keys-hybrid)
                                 (pretty-print (length (hash-keys h2)) out-keys-hybrid)
                                 (pretty-print (sort (map simple-key (hash-keys h1)) lt-expr) out-keys-basic)
                                 (pretty-print (length (hash-keys h1)) out-keys-basic)
                                 (pretty-display "" out-keys-basic)
                                 (pretty-display "" out-keys-hybrid)
                                 )
                               )
                           ; (pretty-print h2)
                           (if (equal-simplify-envs? (from-hash evalqb h1) (from-hash evalqh h2))
                               '() ; (pretty-print "Results match")
                               (begin
                                 ;  (show-envs #t)
                                 (pretty-print (string-append "ERROR: Hybrid and Basic results differ at m=" (number->string (current-m))) (current-error-port))
                                 (displayln "" (current-error-port))
                                 (pretty-print `(query: ,cb ,pb) (current-error-port))
                                 (pretty-display "Basic result: " (current-error-port))
                                 (pretty-result-out (current-error-port) (from-hash evalqb h1))
                                 (displayln "" (current-error-port))
                                 (pretty-print `(query: ,ch ,ph) (current-error-port))
                                 (pretty-display "Hybrid result: " (current-error-port))
                                 (pretty-result-out (current-error-port) (from-hash evalqh h2))
                                 (displayln "" (current-error-port))
                                 '()
                                 ;  (exit)
                                 )
                               )

                           )
                      '()
                      )
                  )
                )

              )
            )
          (close-output-port out-basic)
          (close-output-port out-hybrid)
          (close-output-port out-keys-basic)
          (close-output-port out-keys-hybrid)
          (close-output-port out-mcfa-rebinding)
          (close-output-port out-mcfa-expm)
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(hybrid-cost ,hybrid-cost))
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
    [(refine n) '()]
    )
  )