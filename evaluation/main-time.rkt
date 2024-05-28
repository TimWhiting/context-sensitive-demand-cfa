#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt" "abstract-value.rkt" "static-contexts.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "run.rkt" "results.rkt")
(require "m-cfa.rkt")
(require (rename-in "table-monad/main.rkt" [void fail]))
(require racket/pretty racket/match racket/list racket/set)

(define max-context-length 2)

(define (run-mcfa name kind kindstring query exp m out-time)
  (define result-hash (hash))
  (define timed-result
    (run/timeout
     name
     m kind 'mcfa
     (match-let-values
      ([((list hash-new) cpu real gc)
        (time-apply (lambda () (run-get-hash query (hash)))
                    '())])
      (set! result-hash hash-new)
      (list cpu real gc)
      )))
  (match (andmap (lambda (x) x) timed-result)
    [#f (pretty-print `(,kind ,name ,m ,(timeout) #f) out-time)]
    [_
     (define eval-subqueries (filter (lambda (q) (match q [(meval Ce p) (not (is-instant-query (list Ce p)))] [_ #f])) (hash-keys result-hash)))
     (define eval-results-x (filter (lambda (q) (match q [(cons (meval Ce p) _) (not (is-instant-query (list Ce p)))] [_ #f])) (hash->list result-hash)))
     (define eval-subqueries-instant (filter (lambda (q) (match q [(meval Ce p) (is-instant-query (list Ce p))] [_ #f])) (hash-keys result-hash)))
     (define eval-results-instant-x (filter (lambda (q) (match q [(cons (meval Ce p) _) (is-instant-query (list Ce p))] [_ #f])) (hash->list result-hash)))
     (define eval-results-hash (hash))
     (define eval-instant-results-hash (hash))
     (for ([result eval-results-x])
       (match-let ([(cons (meval Ce p) res) result])
         (set! eval-results-hash (hash-update eval-results-hash Ce (λ (oldres) (join oldres res)) (from-value res)))
         )
       )
     (for ([result eval-results-instant-x])
       (match-let ([(cons (meval Ce p) res) result])
         (set! eval-instant-results-hash (hash-update eval-instant-results-hash Ce (λ (oldres) (join oldres res)) (from-value res)))
         )
       )
     (define eval-results (hash->list eval-results-hash))
     (define eval-instant-results (hash->list eval-instant-results-hash))
     (define store-keys (filter (lambda (q) (match q [(store _) #t] [_ #f])) (hash-keys result-hash)))
     (define num-eval-subqueries (length eval-subqueries))
     (define num-instant-eval-subqueries (length eval-subqueries-instant))
     (define num-store-values (length store-keys))
     (define singletons (count is-singleton-val eval-results))
     (define singletons-instant (count is-singleton-val eval-instant-results))
     (define avg-precision (/ (apply + (map result-size-val eval-results)) (length eval-results)))
     (pretty-print `(,kind ,name ,m ,(timeout) ,num-instant-eval-subqueries ,num-eval-subqueries ,num-store-values ,singletons-instant ,singletons ,avg-precision ,timed-result) out-time)
     ]
    )
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
  (define query-kind (expr-kind (cdr Ce)))
  (define hash-result (hash))
  (define is-instant (is-instant-query (list Ce p)))
  (define time-result
    (run/timeoutn
     name
     num-queries m kind shufflen
     (match-let-values
      ([((list hash-new) cpu real gc)
        (time-apply (lambda ()
                      (for/and ([trial (range acc-trials)])
                        (run-get-hash query old-hash)))
                    '())])
      (set! hash-result hash-new)
      (list (/ cpu acc-trials) (/ real acc-trials) (/ gc acc-trials))
      )))
  (match (andmap (lambda (x) x) time-result)
    [#f
     (if (equal? shufflen -1)
         (pretty-print `(clean-cache ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query) ,is-instant #f) out-time)
         ; Warning, the num-eval-subqueries etc, are going to be strictly increasing for the shuffled due to reuse of cache
         (pretty-print `(shuffled-cache ,shufflen ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query) ,is-instant #f) out-time)

         )]
    [`(#f ,err)
     (if (equal? shufflen -1)
         (pretty-print `(clean-cache ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query) ,is-instant #f) out-time)
         ; Warning, the num-eval-subqueries etc, are going to be strictly increasing for the shuffled due to reuse of cache
         (pretty-print `(shuffled-cache ,shufflen ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query) ,is-instant #f) out-time)

         )]
    [_
     (define result (hash-ref hash-result query))
     (define num-entries (hash-num-keys hash-result))
     (define eval-subqueries (filter (lambda (q) (match q [(eval Ce p) #t] [_ #f])) (hash-keys hash-result)))
     (define eval-results (filter (lambda (q) (match q [(cons (eval Ce p) _) #t] [_ #f])) (hash->list hash-result)))
     (define expr-subqueries (filter (lambda (q) (match q [(expr Ce p) #t] [_ #f])) (hash-keys hash-result)))
     (define refines (filter (lambda (q) (match q [(refine p) #t] [_ #f])) (hash-keys hash-result)))
     (define num-eval-subqueries (length eval-subqueries))
     (define num-expr-subqueries (length expr-subqueries))
     (define num-refines (length refines))
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

     (define singletons (count is-singleton eval-results))
     (define avg-precision (/ (apply + (map result-size eval-results)) (length eval-results)))
     (define num-fully-determined-subqueries (+ num-eval-determined num-expr-determined))
     (if (equal? shufflen -1)
         (pretty-print `(clean-cache ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query) ,is-instant
                                     ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                                     ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                                     ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,(is-singleton (cons '_ result)) ,avg-precision
                                     ,time-result) out-time)
         ; Warning, the num-eval-subqueries etc, are going to be strictly increasing for the shuffled due to reuse of cache
         (pretty-print `(shuffled-cache ,shufflen ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query) ,is-instant
                                        ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                                        ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                                        ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,(is-singleton (cons '_ result)) ,avg-precision
                                        ,time-result) out-time)

         )]
    )
  hash-result
  )

(module+ main
  (show-envs-simple #t)
  (show-envs #f)
  (define do-run-demand #t)
  (define do-run-exhaustive #t)
  (define all-programs '(ack blur cpstak tak eta flatten map facehugger kcfa-2 kcfa-3 loop2-1 mj09 primtest sat-1 sat-2 sat-3 regex rsa deriv tic-tac-toe))
  
  (define kcfas '(kcfa-worst-case-1 kcfa-worst-case-2 kcfa-worst-case-3 kcfa-worst-case-4 kcfa-worst-case-5 kcfa-worst-case-6 kcfa-worst-case-7 kcfa-worst-case-8 kcfa-worst-case-9 kcfa-worst-case-10))
  (define kcfas-large '(kcfa-worst-case-16 kcfa-worst-case-20 kcfa-worst-case-32))
  (define kcfas-mega '(kcfa-worst-case-40 kcfa-worst-case-64 kcfa-worst-case-80 kcfa-worst-case-128 kcfa-worst-case-160 kcfa-worst-case-256))
  (define benchmarks '(map-pattern rsa sat-brute simple-id solovay-strassen indirect-hol fermat))
  (define more-bench '(primtest blur eta kcfa2 kcfa3 mj09 sat facehugger initial-example))
  (define programs '(scheme2java))
  (if do-run-exhaustive
      (for ([m (in-range 0 5)])
        (let ([rebind-cost 0]
              [expm-cost 0])
          (current-m m)
          (for ([example (get-examples programs all-benchmarks)])
            (match-let ([`(example ,name ,exp) example])
              (pretty-print `(mcfa ,m ,name))
              (define out-time-exhaustive (open-output-file (format "tests/m~a/exhaustive_~a-time.sexpr" m name) #:exists 'replace))

              (timeout full-timeout)

              (define rebindhash (run-rebind name exp m out-time-exhaustive))
              (set! rebind-cost (+ rebind-cost (hash-num-keys rebindhash)))

              (pretty-print `(mcfae ,m ,name))
              (define expmhash (run-expm name exp m out-time-exhaustive))
              (set! expm-cost (+ expm-cost (hash-num-keys expmhash)))

              (close-output-port out-time-exhaustive)
              ))

          (pretty-print `(current-m: ,(current-m)))
          (pretty-print `(rebind-cost ,rebind-cost))
          (pretty-print `(expm-cost ,expm-cost))
          )
        )
      '()
      )
  (if do-run-demand
      (for ([t timeouts])
        (for ([m (in-range 0 5)])
          (let ([basic-cost 0]
                [basic-acc-cost 0]
                [num-queries 0])
            (current-m m)
            (for ([example (get-examples programs all-benchmarks)])
              (match-let ([`(example ,name ,exp) example])
                (define out-time (open-output-file (format "tests/m~a/~a-time_~a.sexpr" m name t) #:exists 'replace))

                (timeout t)
                (define qbs (basic-queries exp))
                (set! num-queries (+ num-queries (length qbs)))
                (for ([qs qbs])
                  (match-let ([(list cb pb) qs])
                    (define hx (run-demand name (length qbs) 'basic m cb pb out-time -1 (hash)))
                    (set! basic-cost (+ basic-cost (hash-num-keys hx)))
                    )
                  )

                (for ([shufflen (range num-shuffles)])
                  (define h1 (hash))
                  (for ([qs (shuffle qbs)])
                    (match-let ([(list cb pb) qs])
                      (set! h1 (run-demand name (length qbs) 'basic m cb pb out-time shufflen h1))
                      (set! basic-acc-cost (+ basic-acc-cost (hash-num-keys h1)))
                      )
                    )
                  )

                (close-output-port out-time)
                )
              )
            (pretty-print `(current-m: ,(current-m)))
            (pretty-print `(basic-cost ,basic-cost))
            (pretty-print `(basic-cost-per-query ,(exact->inexact (/ basic-cost num-queries))))
            ; (pretty-print `(basic-acc-cost ,basic-acc-cost))
            ; (pretty-print `(basic-acc-cost-per-query ,(exact->inexact (/ basic-acc-cost (* num-shuffles num-queries)))))
            )
          )
        )
      '()
      )
  )
