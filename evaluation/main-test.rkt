#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "results.rkt" "run.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match)

(define print-simple-diff #t)
(define max-context-length 2)
(define (run-mcfa name kind kindstring query exp m)
  (define out (open-output-file
               (string-append "tests/m" (number->string (current-m)) "/"
                              (symbol->string name) "-" kindstring "-results.txt")
               #:exists 'replace))
  (pretty-print `(expression: ,exp) out)
  (define hash-result (hash))
  (run/parameters
   name
   m kind
   '_
   (let ([hash-new (run-get-hash query (hash))])
     (set! hash-result hash-new)
     )
   )
  (report-mcfa-hash hash-result out)
  hash-result
  )

(define (run-rebind name exp m)
  (run-mcfa name 'rebinding "rebind" (meval (cons `(top) exp) (flatenv '())) exp m))

(define (run-expm name exp m)
  (run-mcfa name 'exponential "expm" (meval (cons `(top) exp) (expenv '())) exp m))

(define (run-demand name num-queries kind m Ce p out)
  (define query (eval Ce p))
  (define hash-result (hash))
  (pretty-print `(query: ,(show-simple-ctx Ce) ,p) out)
  (run/parameters
   name
   m kind
   (show-simple-ctx Ce)
   (let
       ([hash-new (run-get-hash query (hash))])
     (set! hash-result hash-new)
     (show-simple-results (from-hash query hash-result))
     ))
  (pretty-result-out out (from-hash query hash-result))
  hash-result
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  ; (trace 1)
  (trace #f)
  (for ([m (in-range 0 (+ 1 max-context-length))])
    (let ([basic-cost 0]
          [light-cost 0]
          [hybrid-cost 0]
          [rebind-cost 0]
          [expm-cost 0])
      (current-m m)
      (for ([example r6rs])
        ; (for ([example test-examples])
        (match-let ([`(example ,name ,exp) example])
          (define out-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-results.txt") #:exists 'replace))
          ; (define out-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-results.txt") #:exists 'replace))
          ; (define out-light (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-light-results.txt") #:exists 'replace))
          ; (define out-keys-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-keys.txt") #:exists 'replace))
          ; (define out-keys-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-keys.txt") #:exists 'replace))
          ; (define out-keys-light (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-light-keys.txt") #:exists 'replace))
          (pretty-displayn 0 "")
          (pretty-displayn 0 "")
          (for ([file (list out-basic)]) ;out-hybrid out-light  out-keys-hybrid out-keys-light)])
            (pretty-print `(expression: ,exp) file))
          (pretty-displayn 0 "")
          ; (show-envs #t)
          ; (trace 1)
          (define rebindhash (run-rebind name exp m))
          (set! rebind-cost (+ rebind-cost (hash-num-keys rebindhash)))
          (define expmhash (run-expm name exp m))
          (set! expm-cost (+ expm-cost (hash-num-keys expmhash)))
          (define qbs (basic-queries exp))
          (define qhs (hybrid-queries exp))
          (define qls (light-queries exp))
          ; (pretty-print "Finished regular mcfa")

          (for ([qs (zip qbs qhs qls)])
            (match-let ([h1 (hash)]
                        [h2 (hash)]
                        [h3 (hash)]
                        ; TODO: Is it okay for the continuations to escape and be reused later?
                        [(list (list cb pb) (list ch ph) (list cl pl)) qs])
              (define evalqb (eval cb pb))
              (define evalqh (eval ch ph))
              (pretty-tracen 0 "Running query ")
              ; (pretty-print `(query: ,(show-simple-ctx cb) ,pb))
              ; (pretty-print `(query: ,(show-simple-ctx ch) ,ph))

              (set! h1 (run-demand name (length qbs) 'basic m cb pb out-basic))
              (set! basic-cost (+ basic-cost (hash-num-keys h1)))
              ; (if #t
              ;     (begin
              ;       (set! h2 (run-demand name (length qhs) 'hybrid m ch ph out-hybrid))
              ;       (set! hybrid-cost (+ hybrid-cost (hash-num-keys h2)))
              ;       (set! h3 (run-demand name (length qls) 'lightweight m cl pl out-light))
              ;       (set! light-cost (+ light-cost (hash-num-keys h3)))
              ;       (if (equal? (length (hash-keys h1)) (length (hash-keys h2)))
              ;           '()
              ;           (begin
              ;             (pretty-display "" out-keys-basic)
              ;             (pretty-display "" out-keys-hybrid)
              ;             (pretty-print `(query: ,(show-simple-ctx cb) ,pb) out-keys-basic)
              ;             (pretty-print `(query: ,(show-simple-ctx ch) ,ph) out-keys-hybrid)
              ;             (pretty-display "" out-keys-basic)
              ;             (pretty-display "" out-keys-hybrid)
              ;             (pretty-print (queries h1) out-keys-basic)
              ;             (pretty-print (length (hash-keys h1)) out-keys-basic)
              ;             (pretty-print (queries h2) out-keys-hybrid)
              ;             (pretty-print (length (hash-keys h2)) out-keys-hybrid)
              ;             (pretty-display "" out-keys-basic)
              ;             (pretty-display "" out-keys-hybrid)
              ;             )
              ;           )
              ;       ; (pretty-print h2)
              ;       (if (equal-simplify-envs? (from-hash evalqb h1) (from-hash evalqh h2))
              ;           '() ; (pretty-print "Results match")
              ;           (begin
              ;             (if print-simple-diff
              ;                 (pretty-print `(hybrid-diff ,(current-m) ,name ,(simple-key evalqh)))
              ;                 (begin
              ;                   (pretty-print (string-append "ERROR: Hybrid and Basic results differ at m=" (number->string (current-m))) (current-error-port))
              ;                   (displayln "" (current-error-port))
              ;                   (pretty-print `(query: ,cb ,pb) (current-error-port))
              ;                   (pretty-display "Basic result: " (current-error-port))
              ;                   (pretty-result-out (current-error-port) (from-hash evalqb h1))
              ;                   (displayln "" (current-error-port))
              ;                   (pretty-print `(query: ,ch ,ph) (current-error-port))
              ;                   (pretty-display "Hybrid result: " (current-error-port))
              ;                   (pretty-result-out (current-error-port) (from-hash evalqh h2))
              ;                   (displayln "" (current-error-port))
              ;                   (exit)
              ;                   )
              ;                 )
              ;             ;  (show-envs #t)

              ;             ;  (exit)
              ;             )
              ;           )
              ;       )
              ;     '()
              ;     )
              )
            )
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(rebind-cost ,rebind-cost))
      (pretty-print `(expm-cost ,expm-cost))
      ; (pretty-print `(hybrid-cost ,hybrid-cost))
      ; (pretty-print `(light-cost ,light-cost))
      )
    )
  )
