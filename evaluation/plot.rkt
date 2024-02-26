#lang racket/base
(require racket/match
         racket/set
         racket/list
         racket/port
         racket/pretty
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
    [`(shuffled-cache ,shufflen ,name ,m ,timeout ,num-queries ,query-kind ,query #f) #f]
    [`(shuffled-cache ,shufflen ,name ,m ,timeout ,num-queries ,query-kind ,query
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                      ,time-result) (average-or-false time-result)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,timeout ,num-queries ,query-kind ,query #f) #f]
    [`(clean-cache ,name ,m ,timeout ,num-queries ,query-kind ,query
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                   ,time-result) (average-or-false time-result)]
    ; Regular mCFA
    [`(,kind ,name ,m ,timeout #f) #f]
    [`(,kind ,name ,m ,timeout ,num-eval ,num-store ,singletons ,avg-precision ,time-res) (average-or-false time-res)]
    ))

(define (num-singletons line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,timeout ,num-queries ,query-kind ,query #f) 0]
    [`(shuffled-cache ,shufflen ,name ,m ,timeout ,num-queries ,query-kind ,query
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                      ,time-result) (if is-precise 1 0)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,timeout ,num-queries ,query-kind ,query #f) 0]
    [`(clean-cache ,name ,m ,timeout ,num-queries ,query-kind ,query
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                   ,time-result) (if is-precise 1 0)]
    ; Regular mCFA
    [`(,kind ,name ,m ,timeout #f) 0]
    [`(,kind ,name ,m ,timeout ,num-eval ,num-store ,singletons ,avg-precision ,time-res) singletons]
    ))

(define ((restore-time timeout) line)
  ; (pretty-print line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,num-queries ,query-kind ,query #f)
     `(shuffled-cache ,shufflen ,name ,m ,timeout ,num-queries ,query-kind ,query #f)]
    [`(shuffled-cache ,@rest) `(shuffled-cache ,@rest)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,num-queries ,query-kind ,query #f)
     `(clean-cache ,name ,m ,timeout ,num-queries ,query-kind ,query #f)]
    [`(clean-cache ,@rest) `(clean-cache ,@rest)]
    ))

(define (is-result line)
  (avg-time-res line)
  )

(define ((cfa mexpected) line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,@_) (equal? m mexpected)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,@_) (equal? m mexpected)]
    ; Regular mCFA
    [`(,kind ,name ,m ,timeout ,num-eval ,num-store ,singletons ,avg-precision ,time-res) (equal? m mexpected)]
    ))

(define ((filter-timeout timeout) line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,t ,@_) (equal? timeout t)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,t ,@_) (equal? timeout t)]
    ))

(define ((filter-kind mexpected) line)
  (match line
    [`(,kind ,@_) (equal? kind mexpected)]
    ))

(define (id l) l)

(define (get-name line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,@_) name]
    ; Demand no cache
    [`(clean-cache ,name ,@_) name]
    ; Regular mCFA
    [`(,kind ,name ,m ,timeout ,num-eval ,num-store ,singletons ,avg-precision ,time-res) name]
    ))

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
  (filter (lambda (ln)
            ; (pretty-print (get-name ln))
            (equal? (get-name ln) prog)) values))

(define (find-prog-randiter prog iter values)
  (filter (lambda (ln)
            (match ln
              [`(shuffled-cache ,shufflen ,name ,@_) (and (equal? name prog) (equal? shufflen iter)) ]
              ))
          values))
(define program-size '((eta 13) (ack 20) (mj09 21) (kcfa-2 22) (blur 23) (facehugger 23) (loop2-1 26) (kcfa-3 31) (sat-1 34) (cpstak 36) (map 52) (flatten 59) (primtest 94) (regex 255)))
(define (get-program-size p [pgs program-size])
  (match pgs
    [(cons (list p1 size) rst) (if (equal? p p1) size (get-program-size p rst))]
    )
  )

(define all-programs (sort '(eta ack blur loop2-1 kcfa-3 cpstak map flatten primtest) (λ (p1 p2) (< (get-program-size p1) (get-program-size p2)))))

(define all-results
  (let ([results (list)])
    (for ([m (range 3)])
      (for ([program all-programs])
        (for ([t timeouts])
          (set! results (append (map (restore-time t) (read-file (format "tests/m~a/~a-time_~a.sexpr" m program t))) results))
          )
        )
      )
    (for ([m (range 3)])
      (for ([program all-programs])
        (set! results (append (read-file (format "tests/m~a/exhaustive_~a-time.sexpr" m program)) results))
        )
      )
    results
    )
  )

(let* ([ms (list 0 1 2)]
       [expm-res (filter (filter-kind 'exponential) all-results)]
       [rebind-res (filter (filter-kind 'rebinding) all-results)]
       [basic-res (filter (filter-kind 'clean-cache) all-results)]
       [acc-res (filter (filter-kind 'shuffled-cache) all-results)]
       [kinds (list (cons "mcfa-r" rebind-res)
                    (cons "mcfa-e" expm-res)
                    (cons "dmcfa-b" basic-res)
                    (cons "dmcfa-a" acc-res))]
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
  ; (pretty-print rebind-res)
  ; (define programs (set->list (set-subtract (apply set (map car mcfa-rebind-results))
  ;                                           ; The following are simple test programs for evaluating correctness, not for benchmarking
  ;                                           (apply set '(id err constr constr2 basic-letrec basic-letstar app-num let let-num multi-param structural-rec)))))
  (define programs all-programs)
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

  (plot
   (map
    (λ (m h)
      (discrete-histogram
       (map (λ (p) (list p (avg-time-res (car (find-prog p (hash-ref h "mcfa-r")))))) programs)
       #:label (format "m=~a" m)
       #:skip 3.5
       #:x-min m
       #:color m
       ))
    (range 3) hashes
    )
   #:x-label "Program Size"
   #:y-label "Time (ms)"
   #:width 1500
   #:height 500
   #:out-file (format "plots/mcfa.png")
   )

  (plot
   (map
    (λ (m h)
      (discrete-histogram
       (map (λ (p)
              (define num-mcfa (num-singletons (car (find-prog p (hash-ref h "mcfa-e")))))
              (define num-demand (sum (map num-singletons (filter (filter-timeout 25) (find-prog p (hash-ref h "dmcfa-b"))))))
              (list p (/
                       (if (equal? 0 num-mcfa) (+ 1 num-demand) num-demand)
                       (max 1 num-mcfa)
                       )))
            programs)
       #:label (format "m=~a" m)
       #:skip 3.5
       #:x-min m
       #:color m
       ))
    (range 3) hashes
    )
   #:x-label "Program"
   #:y-label "# Singletons Demand / # Singletons Exhaustive"
   #:width 1500
   #:height 500
   #:out-file (format "plots/precision.png")
   )


  (plot
   (map
    (λ (m h)
      (discrete-histogram
       (map (λ (p)
              (define num-mcfa (* num-shuffles (num-singletons (car (find-prog p (hash-ref h "mcfa-e"))))))
              (define num-demand (sum (map num-singletons (filter (filter-timeout 25) (find-prog p (hash-ref h "dmcfa-a"))))))
              (list p (/
                       (if (equal? 0 num-mcfa) (+ num-shuffles num-demand) num-demand)
                       (* num-shuffles (max 1 num-mcfa))
                       )))
            programs)
       #:label (format "m=~a" m)
       #:skip 3.5
       #:x-min m
       #:color m
       ))
    (range 3) hashes
    )
   #:x-label "Program"
   #:y-label "# Singletons Demand / # Singletons Exhaustive"
   #:width 1500
   #:height 500
   #:out-file (format "plots/precision-acc.png")
   )




  (plot
   (map
    (λ (m h)
      (discrete-histogram
       (apply append
              (map (λ (p)
                     (map (λ (t)
                            (define results (filter (filter-timeout t) (find-prog p (hash-ref h "dmcfa-b"))))
                            (list `(,t ,p) (/ (count is-result results) (length results))))
                          timeouts)) programs)
              )
       #:label (format "m=~a" m)
       #:skip 3.5
       #:x-min m
       #:color m
       ))
    (range 3) hashes
    )
   #:x-label "Timeouts (ms)"
   #:y-label "% Answers"
   #:width 1500
   #:height 500
   #:out-file (format "plots/dmcfa.png")
   )

  (plot
   (map
    (λ (m h)
      (discrete-histogram
       (apply append
              (map (λ (p)
                     (map (λ (t)
                            (define results (filter (filter-timeout t) (find-prog p (hash-ref h "dmcfa-a"))))
                            (list `(,t ,p) (/ (count is-result results) (length results))))
                          timeouts)) programs)
              )
       #:label (format "m=~a" m)
       #:skip 3.5
       #:x-min m
       #:color m
       ))
    (range 3) hashes
    )
   #:x-label "Timeouts (ms)"
   #:y-label "% Answers"
   #:width 1500
   #:height 500
   #:out-file (format "plots/dmcfa-cached.png")
   )

  ; (parameterize (
  ;                [plot-x-transform log-transform]
  ;                [plot-x-ticks (ticks (λ (y₀ y₁) ts)
  ;                                     (λ (y₀ y₁ ts)
  ;                                       (map (match-lambda
  ;                                              [(pre-tick x _)
  ;                                               (format "~ams" x)])
  ;                                            ts)))]
  ;                [plot-x-far-ticks no-ticks]
  ;                [plot-x-label "Time"]
  ;                [plot-y-label "% Queries Answered"]
  ;                [plot-width 1024]
  ;                [plot-height 512])
  ; (map
  ;  (lambda (h m)
  ;    (pretty-print (hash-ref h "mcfa-r"))
  ;    (map (lambda (prog)
  ;           ; (pretty-display (format "Looking for program ~a" prog))
  ;           (define pr (find-prog prog (hash-ref h "mcfa-r")))
  ;           ; (pretty-print pr)
  ;           (define pe (find-prog prog (hash-ref h "mcfa-e")))
  ;           ; (pretty-print pe)
  ;           (plot
  ;            #:x-min 1/500
  ;            #:x-max 500
  ;            #:y-min 0
  ;            #:y-max 1.1
  ;            #:out-file (format "plots/m~a/~a.pdf" m prog)
  ;            (cons
  ;             (function (step-n pr (car pr))
  ;                       1/500 500
  ;                       #:samples 1000
  ;                       #:style 'solid
  ;                       #:label (format "1CFA ~a (rebinding)" prog)
  ;                       #:color 0)
  ;             (cons
  ;              (function (step-n pe (car pe))
  ;                        1/500 500
  ;                        #:samples 1000
  ;                        #:style 'solid
  ;                        #:label (format "1CFA ~a (exponential)" prog)
  ;                        #:color 1)
  ;              (cons (function (step-n (find-prog prog (hash-ref h "dmcfa-b")) (car pe) #t)
  ;                              1/500 500
  ;                              #:samples 1000
  ;                              #:style 'short-dash
  ;                              #:label (format "d1CFA ~a" prog)
  ;                              #:color 2)
  ;                    (map (lambda (iter)
  ;                           (function (step-n (find-prog-randiter prog iter (hash-ref h "dmcfa-a")) (car pe))
  ;                                     1/500 500
  ;                                     #:samples 1000
  ;                                     #:style 'long-dash
  ;                                     #:label (format "d1CFA ~a cached" prog)
  ;                                     #:color (+ 3 iter))
  ;                           )
  ;                         (range num-shuffles)))
  ;              )

  ;             )
  ;            )
  ;           ) programs)
  ;    )
  ;  hashes
  ;  (range 3)
  ;  )
  ; )
  )
