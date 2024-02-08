#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "run.rkt" "results.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match)

(define print-simple-diff #t)
(define max-context-length 2)

(define (run-mcfa name kind kindstring query exp m out-time)
  (define out (open-output-file
               (string-append "tests/m" (number->string (current-m)) "/"
                              (symbol->string name) "-" kindstring "-results.txt")
               #:exists 'replace))
  (pretty-print `(expression: ,exp) out)
  (define result-hash (hash))
  (define timed-result
    (run/timeout
     m kind
     (match-let-values
      ([((list hash-new) cpu real gc)
        (time-apply (lambda () (run-get-hash query (hash))) '())])
      (set! result-hash hash-new)
      (list cpu real gc)
      )))

  (report-mcfa-hash result-hash out)
  (pretty-display
   (string-append "\"" (symbol->string name) "\", "
                  (number->string m)
                  (report-times timed-result))
   out-time)
  (close-output-port out)
  )

(define (run-rebind name exp m out-time)
  (run-mcfa name 'rebinding "rebind" (meval (cons `(top) exp) (flatenv '())) exp m out-time))

(define (run-expm name exp m out-time)
  (run-mcfa name 'exponential "expm" (meval (cons `(top) exp) (expenv '())) exp m out-time))

(define (run-demand name num-queries kind m Ce p out out-time)
  (define query (eval Ce p))
  (define hash-result (hash))
  (define time-result
    (run/timeoutn
     num-queries m kind
     (match-let-values
      ([((list hash-new) cpu real gc)
        (time-apply (lambda () (run-get-hash query (hash))) '())])
      (set! hash-result hash-new)
      (list cpu real gc)
      )))
  (pretty-print `(query: ,(show-simple-ctx Ce) ,p) out)
  (pretty-result-out out (from-hash query hash-result))
  (pretty-display
   (string-append "\"" (symbol->string name) "\", "
                  (number->string m) ", " (query->string query) ", "
                  (number->string (hash-num-keys hash-result))
                  (report-times time-result))
   out-time)
  hash-result
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (define out-time-basic (open-output-file (string-append "tests/basic-time.csv") #:exists 'replace))
  (define out-time-light (open-output-file (string-append "tests/light-time.csv") #:exists 'replace))
  (define out-time-hybrid (open-output-file (string-append "tests/hybrid-time.csv") #:exists 'replace))
  (define out-time-rebind (open-output-file (string-append "tests/rebind-time.csv") #:exists 'replace))
  (define out-time-expm (open-output-file (string-append "tests/expm-time.csv") #:exists 'replace))

  (for ([m (in-range 0 (+ 1 max-context-length))])
    (let ([basic-cost 0]
          [light-cost 0]
          [hybrid-cost 0])
      (current-m m)
      (for ([example successful-examples])
        ; (for ([example test-examples])
        (match-let ([`(example ,name ,exp) example])
          (define out-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-results.txt") #:exists 'replace))
          (define out-hybrid (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-hybrid-results.txt") #:exists 'replace))
          (define out-light (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-light-results.txt") #:exists 'replace))
          (pretty-displayn 0 "")
          (pretty-displayn 0 "")
          (for ([file (list out-basic out-hybrid out-light)])
            (pretty-print `(expression: ,exp) file))
          (pretty-displayn 0 "")
          ; (show-envs #t)
          ; (trace 1)
          (run-rebind name exp m out-time-rebind)
          (run-expm name exp m out-time-expm)
          (define qbs (basic-queries exp))
          (define qhs (hybrid-queries exp))
          (define qls (light-queries exp))
          ; (pretty-print "Finished regular mcfa")

          (for ([qs (zip qbs qhs qls)])
            (match-let ([h1 (hash)] ; TODO: Is it okay for the continuations to escape and be reused later?
                        [h2 (hash)]
                        [h3 (hash)]
                        [(list (list cb pb) (list ch ph) (list cl pl)) qs])
              (define evalqb (eval cb pb))
              (define evalqh (eval ch ph))
              (pretty-tracen 0 "Running query ")
              ; (pretty-print `(query: ,(show-simple-ctx cb) ,pb))
              ; (pretty-print `(query: ,(show-simple-ctx ch) ,ph))
              (set! h1 (run-demand name (length qbs) 'basic m cb pb out-basic out-time-basic))
              (set! basic-cost (+ basic-cost (hash-num-keys h1)))
              ; (set! h2 (run-demand name (length qhs) 'hybrid m ch ph out-hybrid out-time-hybrid))
              ; (set! hybrid-cost (+ hybrid-cost (hash-num-keys h2)))
              ; (set! h3 (run-demand name (length qls) 'lightweight m cl pl out-light out-time-light))
              ; (set! light-cost (+ light-cost (hash-num-keys h3)))
              )
            )
          ); TODO: Clean up output ports
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(hybrid-cost ,hybrid-cost))
      (pretty-print `(light-cost ,light-cost))
      )
    )
  (close-output-port out-time-basic)
  (close-output-port out-time-hybrid)
  (close-output-port out-time-rebind)
  (close-output-port out-time-expm)
  )
