#lang racket/base
(require "demand.rkt" "all-examples.rkt" "config.rkt" "utils.rkt" "abstract-value.rkt" "static-contexts.rkt"
         "debug.rkt" "syntax.rkt" "envs.rkt" "demand-queries.rkt" "run.rkt" "results.rkt")
(require "m-cfa.rkt")
(require (rename-in "table-monad/main.rkt" [void fail]))
(require racket/pretty racket/match racket/list racket/set)

(define max-context-length 2)
(define (result-size r)
  (result-size-val (cons '_ (from-value (cdr r)))))

(define (result-size-val r)
  (match-let ([(cons s (literal l)) (cdr r)])
    (+ (set-count s) (count (match-lambda [(bottom) 0] [(singleton _) 1] [(top) 2]) l))
    ))

(define (is-singleton r)
  (is-singleton-val (cons '_ (from-value (cdr r)))))

(define (is-singleton-val r)
  (match-let ([(cons s (literal l)) (cdr r)])
    (or (and (equal? 1 (set-count (apply set (map car (set->list s))))) (andmap bottom? l))
        (equal? 1 (count (match-lambda [(bottom) 0] [(singleton _) 1] [(top) 2]) l)))
    )
  )

(define (join oldres res)
  (match-let ([(cons s1 l1) oldres]
              [(cons s2 l2) (from-value res)])
    (cons (set-union s1 s2) (lit-union l1 l2))
    )
  )

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
     (define eval-results-hash (hash))
     (for ([result eval-results-x])
       (match-let ([(cons (meval Ce p) res) result])
         (set! eval-results-hash (hash-update eval-results-hash Ce (λ (oldres) (join oldres res)) (from-value res)))
         )
       )
     (define eval-results (hash->list eval-results-hash))
     (define store-keys (filter (lambda (q) (match q [(store _) #t] [_ #f])) (hash-keys result-hash)))
     (define num-eval-subqueries (length eval-subqueries))
     (define num-store-values (length store-keys))

     (define singletons (count is-singleton-val eval-results))
     (define avg-precision (/ (apply + (map result-size-val eval-results)) (length eval-results)))
     (pretty-print `(,kind ,name ,m ,(timeout) ,num-eval-subqueries ,num-store-values ,singletons ,avg-precision ,timed-result) out-time)
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
         (pretty-print `(clean-cache ,name ,m ,num-queries ,query-kind ,(query->string query) #f) out-time)
         ; Warning, the num-eval-subqueries etc, are going to be strictly increasing for the shuffled due to reuse of cache
         (pretty-print `(shuffled-cache ,shufflen ,name ,m ,num-queries ,query-kind ,(query->string query) #f) out-time)

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
         (pretty-print `(clean-cache ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query)
                                     ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                                     ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                                     ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,(is-singleton (cons '_ result)) ,avg-precision
                                     ,time-result) out-time)
         ; Warning, the num-eval-subqueries etc, are going to be strictly increasing for the shuffled due to reuse of cache
         (pretty-print `(shuffled-cache ,shufflen ,name ,m ,(timeout) ,num-queries ,query-kind ,(query->string query)
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
  (define do-run-demand #f)
  (define do-run-exhaustive #t)
  (define all-programs '(ack blur cpstak eta flatten map facehugger kcfa-2 kcfa-3 loop2-1 mj09 primtest sat-1 sat-2 sat-3 regex rsa deriv tic-tac-toe))
  (define programs all-programs); '(blur eta kcfa-2 loop2-1))
  (if do-run-exhaustive
      (for ([m (in-range 0 3)])
        (let ([rebind-cost 0]
              [expm-cost 0])
          (current-m m)
          (for ([example (get-examples programs)])
            (match-let ([`(example ,name ,exp) example])
              (define out-time-exhaustive (open-output-file (format "tests/m~a/exhaustive_~a-time.sexpr" m name) #:exists 'replace))

              (timeout full-timeout)

              (define rebindhash (run-rebind name exp m out-time-exhaustive))
              (set! rebind-cost (+ rebind-cost (hash-num-keys rebindhash)))
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
        (for ([m (in-range 0 3)])
          (let ([basic-cost 0]
                [basic-acc-cost 0]
                [num-queries 0])
            (current-m m)
            (for ([example (get-examples programs)])
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
            (pretty-print `(basic-acc-cost ,basic-acc-cost))
            (pretty-print `(basic-acc-cost-per-query ,(exact->inexact (/ basic-acc-cost  (* num-shuffles num-queries)))))

            )
          )
        )
      '()
      )
  )
