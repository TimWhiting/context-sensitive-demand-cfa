#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match)

(define (hash-num-keys h) (length (hash-keys h)))
(define (zip l1 l2) (map list l1 l2))

(define-syntax-rule (run/timeoutn n m k x ...)
  (let ()
    (define thd (current-thread))
    (sync/timeout
     (/ 0.5 n)
     (thread (lambda ()
               (analysis-kind k)
               (current-m m)
               (let ([result (let () x ...)])
                 (thread-send thd result)
                 )
               )))
    (define result (thread-receive))
    (if result
        result
        (begin
          (pretty-print (string-append "timeout " "m=" (number->string m) " kind=" (symbol->string k)))
          #f
          )
        ))
  )

(define-syntax-rule (run/timeout m k x ...)
  (run/timeoutn 1 m k x ...))

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

(define (run-rebind-example example name exp m out-time)
  (define out (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-rebind-results.txt") #:exists 'replace))
  (pretty-print `(expression: ,exp) out)
  ; (pretty-print "Finished exponential mcfa")
  (define time (run/timeout
                m 'rebinding
                (let* ([timestart (current-inexact-monotonic-milliseconds)]
                       [rebh (run-get-hash (meval (cons `(top) exp) (flatenv '())) (hash))]
                       [timeend (current-inexact-monotonic-milliseconds)])
                  (report-mcfa-hash rebh out)
                  (- timeend timestart)
                  )))
  (pretty-display
   (string-append (symbol->string name) ", " (number->string m) ", " (number->string time))
   out-time)
  (close-output-port out)
  )

(define (run-expm-example example name exp m out-time)
  (define out (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-expm-results.txt") #:exists 'replace))
  (pretty-print `(expression: ,exp) out)
  ; (pretty-print "Finished exponential mcfa")
  (define time (run/timeout
                m 'exponential
                (let* ([timestart (current-inexact-monotonic-milliseconds)]
                       [exph (run-get-hash (meval (cons `(top) exp) (expenv '())) (hash))]
                       [timeend (current-inexact-monotonic-milliseconds)])
                  (report-mcfa-hash exph out)
                  (- timeend timestart)
                  )))
  (pretty-display
   (string-append "\"" (symbol->string name) "\", " (number->string m) ", " (number->string time))
   out-time)
  (close-output-port out)
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (define out-time-basic (open-output-file (string-append "tests/basic-time.csv") #:exists 'replace))
  (define out-time-hybrid (open-output-file (string-append "tests/hybrid-time.csv") #:exists 'replace))
  (define out-time-rebind (open-output-file (string-append "tests/rebind-time.csv") #:exists 'replace))
  (define out-time-expm (open-output-file (string-append "tests/expm-time.csv") #:exists 'replace))

  (for ([m (in-range 0 4)])
    (let ([basic-cost 0]
          [hybrid-cost 0])
      (for ([example successful-examples])
        ; (for ([example test-examples])
        (match-let ([`(example ,name ,exp) example])
          (define out-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-results.txt") #:exists 'replace))
          (define out-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-results.txt") #:exists 'replace))
          (define out-keys-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-keys.txt") #:exists 'replace))
          (define out-keys-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-keys.txt") #:exists 'replace))
          (pretty-displayn 0 "")
          (pretty-displayn 0 "")
          (pretty-print `(expression: ,exp) out-basic)
          (pretty-print `(expression: ,exp) out-hybrid)
          (pretty-print `(expression: ,exp) out-keys-basic)
          (pretty-print `(expression: ,exp) out-keys-hybrid)
          (pretty-displayn 0 "")
          ; (show-envs #t)
          ; (trace 1)
          (run-rebind-example example name exp m out-time-rebind)
          (run-expm-example example name exp m out-time-expm)
          ; (pretty-print "Finished regular mcfa")
          (let ([qbs (basic-queries exp)]
                [qhs (hybrid-queries exp)])
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

                (define basic-time
                  (run/timeoutn
                   ; (pretty-print "Starting basic demand-mcfa")
                   (length qbs) m 'basic
                   (let* ([timestart (current-inexact-monotonic-milliseconds)]
                          [_ (set! h1 (run-get-hash evalqb h1))]
                          [timeend (current-inexact-monotonic-milliseconds)]
                          [time (- timeend timestart)])
                     (set! basic-cost (+ basic-cost (hash-num-keys h1)))
                     (pretty-result-out out-basic (from-hash evalqb h1))
                     time
                     )))
                (pretty-display
                 (string-append "\"" (symbol->string name) "\", " (number->string m) ", " (query->string evalqb) ", "
                                (number->string (hash-num-keys h1)) ", " (number->string basic-time))
                 out-time-basic)
                (if #t
                    (let ()
                      (define hybrid-time
                        (run/timeoutn
                         (length qhs) m 'hybrid
                         ;  (pretty-print "Starting hybrid demand-mcfa")
                         (let* ([timestart (current-inexact-monotonic-milliseconds)]
                                [_ (set! h2 (run-get-hash evalqh h2))]
                                [timeend (current-inexact-monotonic-milliseconds)]
                                [time (- timeend timestart)])
                           (set! hybrid-cost (+ hybrid-cost (hash-num-keys h2)))
                           (pretty-tracen 0 (from-hash evalqh h2))
                           (pretty-result-out out-hybrid (from-hash evalqh h2))
                           time
                           )))
                      (pretty-display
                       (string-append "\"" (symbol->string name) "\", " (number->string m) ", " (query->string evalqh) ", "
                                      (number->string (hash-num-keys h2)) ", " (number->string hybrid-time))
                       out-time-hybrid)

                      (if (equal? (length (hash-keys h1)) (length (hash-keys h2)))
                          '()
                          (begin
                            (pretty-display "" out-keys-basic)
                            (pretty-display "" out-keys-hybrid)
                            (pretty-print `(query: ,(show-simple-ctx cb) ,pb) out-keys-basic)
                            (pretty-print `(query: ,(show-simple-ctx ch) ,ph) out-keys-hybrid)
                            (pretty-display "" out-keys-basic)
                            (pretty-display "" out-keys-hybrid)
                            (pretty-print (queries h1) out-keys-basic)
                            (pretty-print (length (hash-keys h1)) out-keys-basic)
                            (pretty-print (queries h2) out-keys-hybrid)
                            (pretty-print (length (hash-keys h2)) out-keys-hybrid)
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
            ); TODO: Clean up output ports
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(hybrid-cost ,hybrid-cost))
      )
    )
  (close-output-port out-time-basic)
  (close-output-port out-time-hybrid)
  (close-output-port out-time-rebind)
  (close-output-port out-time-expm)
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