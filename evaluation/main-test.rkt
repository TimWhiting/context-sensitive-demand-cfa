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
                              (symbol->string name) "-" kindstring "-results.rkt")
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
  (pretty-display "" out)
  (pretty-print `(query: ,(show-simple-ctx Ce) ,(show-simple-env p)) out)
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
          [rebind-cost 0]
          [expm-cost 0])
      (current-m m)
      (for ([example (get-examples '(sat-small))])
        ; (for ([example test-examples])
        (match-let ([`(example ,name ,exp) example])
          (define out-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-results.rkt") #:exists 'replace))
          ; (define out-keys-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-keys.txt") #:exists 'replace))
          (pretty-displayn 0 "")
          (pretty-displayn 0 "")
          (for ([file (list out-basic)])
            (pretty-print `(expression: ,exp) file))
          (pretty-displayn 0 "")
          ; (show-envs #t)
          ; (trace 1)
          (define rebindhash (run-rebind name exp m))
          (set! rebind-cost (+ rebind-cost (hash-num-keys rebindhash)))
          (define expmhash (run-expm name exp m))
          (set! expm-cost (+ expm-cost (hash-num-keys expmhash)))
          (define qbs (basic-queries exp))

          ; (pretty-print "Finished regular mcfa")

          (for ([qs qbs])
            (match-let ([h1 (hash)]
                        ; TODO: Is it okay for the continuations to escape and be reused later?
                        [(list cb pb) qs])
              (define evalqb (eval cb pb))
              (pretty-tracen 0 "Running query ")

              (set! h1 (run-demand name (length qbs) 'basic m cb pb out-basic))
              (set! basic-cost (+ basic-cost (hash-num-keys h1)))

              )
            )
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(rebind-cost ,rebind-cost))
      (pretty-print `(expm-cost ,expm-cost))
      )
    )
  )
