#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "run.rkt" "results.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match racket/list)

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
        (time-apply (lambda ()
                      (for/and ([trial (range acc-trials)])
                        (run-get-hash query (hash))))
                    '())])
      (set! result-hash hash-new)
      (list (/ cpu acc-trials) (/ real acc-trials) (/ gc acc-trials))
      )))

  (report-mcfa-hash result-hash out)
  (pretty-print `(,name ,m ,(hash-num-keys result-hash) ,timed-result) out-time)
  (close-output-port out)
  result-hash
  )

(define (run-rebind name exp m out-time)
  (run-mcfa name 'rebinding "rebind" (meval (cons `(top) exp) (flatenv '())) exp m out-time))

(define (run-expm name exp m out-time)
  (run-mcfa name 'exponential "expm" (meval (cons `(top) exp) (expenv '())) exp m out-time))

(define (run-demand name num-queries kind m Ce p out out-time shufflen old-hash)
  (define query (eval Ce p))
  (define hash-result (hash))
  (define time-result
    (run/timeoutn
     num-queries m kind
     (match-let-values
      ([((list hash-new) cpu real gc)
        (time-apply (lambda ()
                      (for/and ([trial (range acc-trials)])
                        (run-get-hash query old-hash)))
                    '())])
      (set! hash-result hash-new)
      (list (/ cpu acc-trials) (/ real acc-trials) (/ gc acc-trials))
      )))

  (if (equal? shufflen -1)
      (begin
        (pretty-print `(query: ,(show-simple-ctx Ce) ,p) out)
        (pretty-result-out out (from-hash query hash-result))
        (pretty-print `(,name ,m ,(query->string query) ,(hash-num-keys hash-result) ,time-result) out-time)
        )
      (begin
        (pretty-print `(,name ,m ,shufflen ,(query->string query) ,(hash-num-keys hash-result) ,time-result) out-time)
        )
      )
  hash-result
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (define out-time-basic (open-output-file (string-append "tests/basic-time.sexpr") #:exists 'replace))
  (define out-time-basic-acc (open-output-file (string-append "tests/basic-time-acc.sexpr") #:exists 'replace))
  (define out-time-rebind (open-output-file (string-append "tests/rebind-time.sexpr") #:exists 'replace))
  (define out-time-expm (open-output-file (string-append "tests/expm-time.sexpr") #:exists 'replace))

  (for ([m (in-range 0 (+ 1 max-context-length))])
    (let ([basic-cost 0]
          [rebind-cost 0]
          [expm-cost 0])
      (current-m m)
      (for ([example successful-examples])
        (match-let ([`(example ,name ,exp) example])
          (define out-basic (open-output-file (string-append "tests/m" (number->string (current-m)) "/" (symbol->string name) "-basic-results.txt") #:exists 'replace))
          (pretty-displayn 0 "")
          (pretty-displayn 0 "")
          (for ([file (list out-basic)])
            (pretty-print `(expression: ,exp) file))
          (pretty-displayn 0 "")

          (define rebindhash (run-rebind name exp m out-time-rebind))
          (set! rebind-cost (+ rebind-cost (hash-num-keys rebindhash)))
          (define expmhash (run-expm name exp m out-time-expm))
          (set! expm-cost (+ expm-cost (hash-num-keys expmhash)))

          (define qbs (basic-queries exp))
          (for ([shufflen (range num-shuffles)])
            (define h1 (hash))
            (for ([qs (shuffle qbs)])
              (match-let ([(list cb pb) qs])
                (pretty-tracen 0 "Running query ")
                (if (equal? shufflen 0)
                    (let ()
                      (define hx (run-demand name (length qbs) 'basic m cb pb out-basic out-time-basic -1 (hash)))
                      (set! basic-cost (+ basic-cost (hash-num-keys hx)))
                      )
                    '()
                    )
                (set! h1 (run-demand name (length qbs) 'basic m cb pb '_ out-time-basic-acc shufflen h1))
                )
              )
            ); TODO: Clean up output ports
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(rebind-cost ,rebind-cost))
      (pretty-print `(expm-cost ,expm-cost))
      )
    )
  (close-output-port out-time-basic)
  (close-output-port out-time-basic-acc)
  (close-output-port out-time-rebind)
  (close-output-port out-time-expm)
  )
