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


(define (is-expr-determined q)
  (match-let ([(expr Ce p) q]) (is-fully-determined? p))
  )
(define (is-eval-determined q)
  (match-let ([(eval Ce p) q]) (is-fully-determined? p))
  )

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
  (define num-entries (hash-num-keys hash-result))
  (define eval-subqueries (filter (lambda (q) (match q [(eval Ce p) #t] [_ #f])) (hash-keys hash-result)))
  (define expr-subqueries (filter (lambda (q) (match q [(expr Ce p) #t] [_ #f])) (hash-keys hash-result)))
  (define refines (filter (lambda (q) (match q [(refine p) #t] [_ #f])) (hash-keys hash-result)))
  (define num-eval-subqueries (length eval-subqueries))
  (define num-expr-subqueries (length expr-subqueries))
  (define num-refines (length refines))
  (define query-kind (match Ce
                       [(cons C e) (expr-kind e)]
                       ))
  (define eval-determined (filter is-eval-determined eval-subqueries))
  (define expr-determined (filter is-expr-determined expr-subqueries))
  (define num-eval-determined (length eval-determined))
  (define num-expr-determined (length expr-determined))
  (define eval-groups (group-by (lambda (q) (match-let ([(eval Ce p) q]) Ce)) eval-subqueries))
  (define (avg-determined l)
    (/ (length (filter is-eval-determined l)) (length l))
    )
  (define eval-groups-avg-determined (map avg-determined eval-groups))
  (define eval-groups-avg-size (/ (count length eval-groups) (length eval-groups)))
  (define eval-sub-avg-determined (/ (apply + eval-groups-avg-determined) (length eval-groups-avg-determined)))
  (define num-fully-determined-subqueries (+ num-eval-determined num-expr-determined))
  (if (equal? shufflen -1)
      (pretty-print `(clean-cache ,name ,m ,num-queries ,query-kind ,(query->string query)
                                  ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                                  ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                                  ,eval-groups-avg-size ,eval-sub-avg-determined
                                  ,time-result) out-time)
      ; Warning, the num-eval-subqueries etc, are going to be strictly increasing for the shuffled due to reuse of cache
      (pretty-print `(shuffled-cache ,shufflen ,name ,m ,num-queries ,query-kind ,(query->string query)
                                     ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                                     ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                                     ,eval-groups-avg-size ,eval-sub-avg-determined
                                     ,time-result) out-time)

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
          [expm-cost 0]
          [num-queries 0])
      (current-m m)
      (for ([example (get-examples '(sat-small sat-1 sat-2 sat-3 tic-tac-toe))])
        (match-let ([`(example ,name ,exp) example])
          (define rebindhash (run-rebind name exp m out-time-rebind))
          (set! rebind-cost (+ rebind-cost (hash-num-keys rebindhash)))
          (define expmhash (run-expm name exp m out-time-expm))
          (set! expm-cost (+ expm-cost (hash-num-keys expmhash)))

          (define qbs (basic-queries exp))
          (set! num-queries (+ num-queries (length qbs)))
          (for ([shufflen (range num-shuffles)])
            (define h1 (hash))
            (for ([qs (shuffle qbs)])
              (match-let ([(list cb pb) qs])
                (pretty-tracen 0 "Running query ")
                ; (set! h1 (run-demand name (length qbs) 'basic m cb pb out-time-basic-acc shufflen h1))
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
            )
          )
        )
      (pretty-print `(current-m: ,(current-m)))
      (pretty-print `(basic-cost ,basic-cost))
      (pretty-print `(basic-cost-per-query ,(exact->inexact (/ basic-cost num-queries))))
      (pretty-print `(basic-acc-cost ,basic-acc-cost))
      (pretty-print `(basic-acc-cost-per-query ,(exact->inexact (/ basic-acc-cost num-queries))))
      (pretty-print `(rebind-cost ,rebind-cost))
      (pretty-print `(expm-cost ,expm-cost))
      )
    )
  (close-output-port out-time-basic)
  (close-output-port out-time-basic-acc)
  (close-output-port out-time-rebind)
  (close-output-port out-time-expm)
  )
