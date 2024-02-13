#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "run.rkt" "results.rkt")
(require "m-cfa.rkt")
(require racket/pretty racket/match racket/list)

(define max-context-length 2)

(define (run-mcfa name kind kindstring query exp m out-time)
  (define result-hash (hash))
  (define timed-result
    (run/timeout
     name
     m kind
     (match-let-values
      ([((list hash-new) cpu real gc)
        (time-apply (lambda () (run-get-hash query (hash)))
                    '())])
      (set! result-hash hash-new)
      (list cpu real gc)
      )))

  (pretty-print `(,name ,m ,(hash-num-keys result-hash) ,timed-result) out-time)
  result-hash
  )

(define (run-rebind name exp m out-time)
  (run-mcfa name 'rebinding "rebind" (meval (cons `(top) exp) (flatenv '())) exp m out-time))

(define (run-expm name exp m out-time)
  (run-mcfa name 'exponential "expm" (meval (cons `(top) exp) (expenv '())) exp m out-time))

(define (run-demand name num-queries kind m Ce p out-time shufflen old-hash)
  (define query (eval Ce p))
  (define hash-result (hash))
  (define time-result
    (run/timeoutn
     name
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
      (pretty-print `(,name ,m ,(query->string query) ,(hash-num-keys hash-result) ,time-result) out-time)
      (pretty-print `(,name ,m ,shufflen ,(query->string query) ,(hash-num-keys hash-result) ,time-result) out-time)
      )
  hash-result
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (define out-time-basic (open-output-file "tests/basic-time.sexpr" #:exists 'replace))
  (define out-time-basic-acc (open-output-file "tests/basic-time-acc.sexpr" #:exists 'replace))
  (define out-time-rebind (open-output-file "tests/rebind-time.sexpr" #:exists 'replace))
  (define out-time-expm (open-output-file "tests/expm-time.sexpr" #:exists 'replace))

  (for ([m (in-range 0 (+ 1 max-context-length))])
    (let ([basic-cost 0]
          [basic-acc-cost 0]
          [rebind-cost 0]
          [expm-cost 0])
      (current-m m)
      (for ([example successful-examples])
        (match-let ([`(example ,name ,exp) example])
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
                (set! h1 (run-demand name (length qbs) 'basic m cb pb out-time-basic-acc shufflen h1))
                (if (equal? shufflen 0)
                    (let ()
                      (define hx (run-demand name (length qbs) 'basic m cb pb out-time-basic -1 (hash)))
                      (set! basic-cost (+ basic-cost (hash-num-keys hx)))
                      )
                    '()
                    )
                )
              )
            (if (equal? shufflen 0)
                (set! basic-acc-cost (+ basic-acc-cost (hash-num-keys h1)))
                '()
                )
            ); TODO: Clean up output ports
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(basic-acc-cost ,basic-acc-cost))
      (pretty-print `(rebind-cost ,rebind-cost))
      (pretty-print `(expm-cost ,expm-cost))
      )
    )
  (close-output-port out-time-basic)
  (close-output-port out-time-basic-acc)
  (close-output-port out-time-rebind)
  (close-output-port out-time-expm)
  )
