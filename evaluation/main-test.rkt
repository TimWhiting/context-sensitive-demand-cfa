#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "results.rkt" "run.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match)

(define print-simple-diff #t)
(define max-context-length 0)

(define (run-mcfa name kind kindstring query exp m)
  (define out (open-output-file
               (string-append "tests/m" (number->string (current-m)) "/"
                              (symbol->string name) "-" kindstring "-results.rkt")
               #:exists 'replace))
  (pretty-print `(expression: ,exp) out)
  (define hash-result (hash))
  (pretty-display (format "running ~a, m=~a kind=~a" name m kind))
  (match-let
      ([(cons res t)
        (run/parameters
         name
         m kind
         (let ([hash-new (run-get-hash query (hash))])
           (set! hash-result hash-new)
           )
         )])
    (pretty-display (format "finished in ~a ms, result:\n~a\n" t res))
    (report-mcfa-hash hash-result out)
    hash-result
    )
  )

(define (run-rebind name exp m)
  (run-mcfa name 'rebinding "rebind" (meval (cons `(top) exp) (flatenv '())) exp m))

(define (run-expm name exp m)
  (run-mcfa name 'exponential "expm" (meval (cons `(top) exp) (expenv '())) exp m))

(define (run-demand name num-queries kind m Ce p out hashed to-out)
  (define query (eval Ce p))
  (define hash-result (hash))

  (if to-out
      (pretty-display "" out)
      '()
      )
  (if to-out
      (pretty-print `(query: ,(show-simple-ctx Ce) ,(show-simple-env p)) out)
      '())
  (match-let
      ([(cons res t)
        (run/parameters
         name
         m kind
         (let
             ([hash-new (run-get-hash query hashed)])
           (set! hash-result hash-new)
           (from-hash query hash-result)
           ))])
    (if (and to-out (is-bottom res))
        (pretty-display (format "running ~a, m=~a kind=~a info=~a resulted in bottom" name m kind (show-simple-ctx Ce)))
        '()
        )
    (pretty-display (format "finished ~a in ~a ms, result:\n~a\n" (show-simple-ctx Ce) t (show-simple-results res)))
    (if to-out (pretty-result-out out (from-hash query hash-result)) '())
    hash-result
    )
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  ; (trace 1)
  (trace #f)
  (for ([m (in-range 0 2)])
    (let ([basic-cost 0]
          [rebind-cost 0]
          [expm-cost 0]
          [num-queries 0]
          [basic-acc-cost 0])
      (current-m m)
      (define all-examples '(ack blur cpstak deriv eta facehugger flatten
                                 kcfa-2 kcfa-3 loop2-1 map mj09 primtest
                                 regex rsa sat-1 sat-2 sat-3 tak sat-small))
      (define kcfas '(kcfa-worst-case-1 kcfa-worst-case-2 kcfa-worst-case-3 kcfa-worst-case-4 kcfa-worst-case-5 kcfa-worst-case-6 kcfa-worst-case-7 kcfa-worst-case-8 kcfa-worst-case-9 kcfa-worst-case-10))
      (define kcfas-large '(kcfa-worst-case-16 kcfa-worst-case-20 kcfa-worst-case-32))
      (define kcfas-mega '(kcfa-worst-case-40 kcfa-worst-case-64 kcfa-worst-case-80 kcfa-worst-case-128 kcfa-worst-case-160 kcfa-worst-case-256))
      (define benchmarks '(map-pattern rsa sat-brute simple-id solovay-strassen indirect-hol fermat))
      (define more-bench '(primtest blur eta kcfa2 kcfa3 mj09 sat facehugger initial-example))
      ; Missing primitives or takes longer
      (define benchmark-2 '(meta-circ regex-derivative regex loop2 scheme-to-c scheme2java))
      ; Just missing meta-circ right now....
      ; (for ([example (get-examples '(scratch))])
      (for ([example (get-examples '(meta-circ) all-benchmarks)])
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
          ; (define qbs (basic-queries exp))

          ; ; ; (pretty-print "Finished regular mcfa")
          ; (set! num-queries (+ num-queries (length qbs)))
          ; (define h1 (hash))
          ; (for ([qs qbs])
          ;   (match-let ([(list cb pb) qs])
          ;     (pretty-tracen 0 "Running query ")
          ;     ; (set! h1 (run-demand name (length qbs) 'basic m cb pb out-basic h1 #t))
          ;     (define h2 (run-demand name (length qbs) 'basic m cb pb out-basic (hash) #t))
          ;     (set! basic-cost (+ basic-cost (hash-num-keys h2)))
          ;     ; (set! basic-acc-cost (hash-num-keys h1))
          ;     )
          ;   )
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      ; (pretty-print `(avg-cost-per-query-basic-acc ,(exact->inexact (/ basic-acc-cost num-queries))))
      ; (pretty-print `(total-cost-basic-acc ,basic-acc-cost))
      ; (pretty-print `(avg-cost-per-query-basic ,(exact->inexact (/ basic-cost num-queries))))
      (pretty-print `(total-cost-basic ,basic-cost))
      (pretty-print `(rebind-cost ,rebind-cost))
      (pretty-print `(expm-cost ,expm-cost))
      )
    )
  )
