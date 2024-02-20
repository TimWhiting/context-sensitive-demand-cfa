#lang racket/base
(require racket/match
         racket/set
         racket/list
         racket/port
         plot
         "config.rkt"
         )

(define (read-file file) (call-with-input-file file read-all))
(define (read-all inport) (map cadr (port->list read inport)))
(define (average l) (/ (sum l) (length l)))
(define (sum l) (apply + (replace-zeros l)))
(define (replace-zeros l) (map (lambda (v) (match v [0 0] [#f 0] [v v])) l))

(define (average-or-false time-res)
  (if (empty? (filter (lambda (v) (equal? v #f)) time-res))
      (average (map car time-res))
      #f
      )
  )

(define (avg-time-res line)
  ; (pretty-print line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,num-queries ,query-kind ,query
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined
                      #f) #f]
    [`(shuffled-cache ,shufflen ,name ,m ,num-queries ,query-kind ,query
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined
                      ,time-result) (average-or-false time-result)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,num-queries ,query-kind ,query
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined
                   #f) #f]
    [`(clean-cache ,name ,m ,num-queries ,query-kind ,query
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined
                   ,time-result) (average-or-false time-result)]
    ; Regular mCFA
    [`(,name ,m ,hash-num #f) #f]
    [`(,name ,m ,hash-num ,time-res) (average-or-false time-res)]
    ))

(define ((cfa mexpected) line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,num-queries ,query-kind ,query
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined
                      ,time-result) (equal? m mexpected)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,num-queries ,query-kind ,query
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined
                   ,time-result) (equal? m mexpected)]
    ; Regular mCFA
    [`(,name ,m ,hash-num ,time-res) (equal? m mexpected)]
    ))

(define (id l) l)

(define (step-n lines m-value [do-sort #t])
  (define avg (avg-time-res m-value))
  (define avgs (map avg-time-res lines))
  (define valid-avgs (filter id avgs))
  (define avgsort (if do-sort (sort valid-avgs <) valid-avgs))
  (define cum (cumulative 0 avgsort))
  ; (pretty-print avg)
  ; (pretty-print cum)
  (lambda (normt)
    (define t (* normt 1))
    ; Count how many queries returned prior to t (t >= v)
    (define res (map (lambda (v) (if (>= t v) 1 0)) cum))
    ; return the percentage of queries that returned prior to t
    (/ (sum res) (length avgs))))

(define (cumulative x lines)
  (match lines
    ['() '()]
    [(cons l lines)
     (cons (+ x l) (cumulative (+ x l) lines))]
    ))

(define (find-prog prog values)
  (filter (lambda (ln) (equal? (car ln) prog)) values))

(define (find-prog-randiter prog iter values)
  (filter (lambda (ln)
            (match ln
              [`(,name ,m ,shufflen ,query ,hash-num ,time-res) (and (equal? name prog) (equal? shufflen iter)) ]
              ))
          values))

(let* ([mcfa-rebind-results (read-file "tests/rebind-time.sexpr")]
       [mcfa-expm-results (read-file "tests/expm-time.sexpr")]
       [dmcfa-results (read-file "tests/basic-time.sexpr")]
       [dmcfa-acc-results (read-file "tests/basic-time-acc.sexpr")]
       [ms (list 0 1 2)]
       [kinds (list (cons "mcfa-r" mcfa-rebind-results) (cons "mcfa-e" mcfa-expm-results)
                    (cons "dmcfa-b" dmcfa-results) (cons "dmcfa-a" dmcfa-acc-results))]
       [hashes
        (for/list ([m ms])
          (let loop ([kinds kinds]
                     [h (hash)])
            (match kinds
              ['() h]
              [(cons (cons nm results) res) (loop res (hash-set h nm (filter (cfa m) results)))]
              )
            )
          )
        ]
       )
  (define programs (set->list (set-subtract (apply set (map car mcfa-rebind-results))
                                            ; The following are simple test programs for evaluating correctness, not for benchmarking
                                            (apply set '(id err constr constr2 basic-letrec basic-letstar app-num let let-num multi-param structural-rec)))))
  (define num-programs (length programs))
  ; (pretty-print (exact->inexact (/ (sum (map avg-time-res mcfa-r1)) num-programs)))
  ; (pretty-print (exact->inexact (/ (sum (map avg-time-res mcfa-e1)) num-programs)))
  ; (pretty-print (map avg-time-res dmcfa-b1))
  ; (pretty-print (exact->inexact (/ (sum (map avg-time-res dmcfa-b1)) num-programs)))
  ; (pretty-print (exact->inexact (/ (sum (map avg-time-res dmcfa-a1)) (* num-shuffles num-programs))))
  (define (0+ x) (if (zero? x) 1/2 x))
  (define ts
    (list (pre-tick 1/500 #f)
          (pre-tick 1/100 #t)
          (pre-tick 1/50 #f)
          (pre-tick 1/10 #t)
          (pre-tick 1/2 #f)
          (pre-tick 1 #t)
          (pre-tick 5 #f)
          (pre-tick 10 #t)
          (pre-tick 50 #f)
          (pre-tick 100 #t)
          (pre-tick 500 #f)))

  (parameterize (
                 [plot-x-transform log-transform]
                 [plot-x-ticks (ticks (λ (y₀ y₁) ts)
                                      (λ (y₀ y₁ ts)
                                        (map (match-lambda
                                               [(pre-tick x _)
                                                (format "~ams" x)])
                                             ts)))]
                 [plot-x-far-ticks no-ticks]
                 [plot-x-label "Time"]
                 [plot-y-label "% Queries Answered"]
                 [plot-width 1024]
                 [plot-height 512])
    (map
     (lambda (h m)
       (map (lambda (prog)
              ;  (pretty-display (format "Looking for program ~a" prog))
              (define pr (find-prog prog (hash-ref h "mcfa-r")))
              (define pe (find-prog prog (hash-ref h "mcfa-e")))
              (plot
               #:x-min 1/500
               #:x-max 500
               #:y-min 0
               #:y-max 1.1
               #:out-file (format "plots/m~a/~a.pdf" m prog)
               (cons
                (function (step-n pr (car pr))
                          1/500 500
                          #:samples 1000
                          #:style 'solid
                          #:label (format "1CFA ~a (rebinding)" prog)
                          #:color 0)
                (cons
                 (function (step-n pe (car pe))
                           1/500 500
                           #:samples 1000
                           #:style 'solid
                           #:label (format "1CFA ~a (exponential)" prog)
                           #:color 1)
                 (cons (function (step-n (find-prog prog (hash-ref h "dmcfa-b")) (car pe) #t)
                                 1/500 500
                                 #:samples 1000
                                 #:style 'short-dash
                                 #:label (format "d1CFA ~a" prog)
                                 #:color 2)
                       (map (lambda (iter)
                              (function (step-n (find-prog-randiter prog iter (hash-ref h "dmcfa-a")) (car pe))
                                        1/500 500
                                        #:samples 1000
                                        #:style 'long-dash
                                        #:label (format "d1CFA ~a cached" prog)
                                        #:color (+ 3 iter))
                              )
                            (range num-shuffles)))
                 )

                )
               )
              ) programs)
       )
     hashes
     (range 3)
     )
    )
  )
