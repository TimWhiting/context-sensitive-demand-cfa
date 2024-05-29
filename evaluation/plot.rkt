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
  (if time-res
      (car time-res)
      #f
      )
  )

(define (avg-time-res line)
  ; (pretty-print line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant #f) #f]
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                      ,time-result) (average-or-false time-result)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant #f) #f]
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query, is-instant
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                   ,time-result) (average-or-false time-result)]
    ; Regular mCFA
    [`(,kind ,name ,m ,gas #f) #f]
    [`(,kind ,name ,m ,gas ,num-instant ,num-eval ,num-store ,instant-singletons ,singletons ,avg-precision ,time-res) (average-or-false time-res)]
    ))

(define ((num-singletons instant) line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant #f) 0]
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                      ,time-result) (if
                                     (if instant
                                         (and is-instant is-precise)
                                         (and (not is-instant) is-precise)
                                         ) 1 0)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant #f) 0]
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                   ,time-result) (if (if instant
                                         (and is-instant is-precise)
                                         (and (not is-instant) is-precise)
                                         ) 1 0)]
    ; Regular mCFA
    [`(,kind ,name ,m ,gas #f) 0]
    [`(,kind ,name ,m ,gas ,num-instant ,num-eval ,num-store ,instant-singletons ,singletons ,avg-precision ,time-res)
     (if instant
         instant-singletons
         singletons)
     ]
    ))

(define ((filter-instant i) line)
  (match line
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant ,@_) (equal? i is-instant)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant ,@_) (equal? i is-instant)]
    )
  )

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
    [`(,kind ,name ,m ,@_) (equal? m mexpected)]
    ))

(define ((filter-gas gas) line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,t ,@_) (equal? gas t)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,t ,@_) (equal? gas t)]
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
    [`(,kind ,name ,@_) name]
    ))

(define (gas-amount line)
  (match line
    [`(clean-cache ,name ,m ,gas ,@_) gas]
  ))

(define (get-points lines)
  ; (pretty-print lines)
  (map (lambda (g) (list g (/ (count is-result (filter (filter-gas g) lines)) (length lines)))) gases)
)

(define (step-n lines m-value [do-sort #t])
  (define avg (avg-time-res m-value))
  (define avgs (map avg-time-res lines))
  (define valid-avgs (filter id avgs))
  (define avgsort (if do-sort (sort valid-avgs <) valid-avgs))
  (define cum (cumulative 0 avgsort))
  ; (pretty-print avg)
  ; (pretty-print cum)
  (lambda (normt)
    (define g (* normt 1))
    ; Count how many queries returned prior to t (t >= v)
    (define res (map (lambda (v) (if (>= g v) 1 0)) cum))
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
(define program-size '((indirect-hol 17) (eta 23) (ack 40) (kcfa-2 32) (kcfa2 37) (mj09 33) (tak 41) (blur 43) (loop2-1 45) (kcfa-3 45) (kcfa3 45) (facehugger 47) (sat-1 58) (cpstak 59) (sat 94) (sat-2 96) (map 97) (sat-3 100) (flatten 103) (primtest 180) (rsa 211) (fermat 246) (deriv 257) (regex 421) (tic-tac-toe 569) (scheme2java 1311)))
(define (get-program-size p [pgs program-size])
  (match pgs
    [(cons (list p1 size) rst) (if (equal? p p1) size (get-program-size p rst))]
    )
  )
(define reachability-bench-programs '(mj09 eta kcfa2 kcfa3 blur sat primtest rsa regex)) ; loop2 scheme2java))

; (define all-programs (map car program-size))

(define all-programs (sort reachability-bench-programs (λ (p1 p2) (< (get-program-size p1) (get-program-size p2)))))

; (define all-programs (sort '(eta blur loop2-1 sat-1 sat-2 regex map flatten primtest rsa deriv tic-tac-toe) (λ (p1 p2) (< (get-program-size p1) (get-program-size p2)))))

(define all-results
  (let ([results (list)])
    (for ([m (range 5)])
      (for ([program all-programs])
        (for ([gas gases])
          (set! results (append (read-file (format "tests/m~a/~a-gas_~a_detailed.sexpr" m program gas)) results))
          )
        )
      )
    (for ([m (range 5)])
      (for ([program all-programs])
        (set! results (append (read-file (format "tests/m~a/exhaustive_~a.sexpr" m program)) results))
        )
      )
    results
    )
  )

(let* ([ms (list 0 1 2 3 4)]
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
  (define num-programs (length all-programs))
  (define plot-height 400)
  (define plot-width 900)
  (plot-legend-font-size 10)
  ; (pretty-print all-results)
  (for ([out (list "pdf" "png")])
    (map 
      (lambda (m h) 
        (pretty-print `(plot ,m))
        (plot
          (map (λ (i p) 
                (pretty-print `(plot ,p ,i))
                (lines 
                  (get-points (find-prog p (hash-ref h "dmcfa-b")))
                  #:color i
                  #:label (format "~a" p)
                )
               )
            (range (length all-programs)) all-programs)
        #:x-label "Gas"
        #:y-label "Percent Answered Queries"
        #:width plot-width
        #:height plot-height
        #:out-file (format "plots/total-queries-answered_~a.~a" m out)
        )

        (plot
          (map (λ (i p) 
                (pretty-print `(plot ,p ,i))
                (lines 
                  (get-singletons-gas-increase (find-prog p (hash-ref h "dmcfa-b")))
                  #:color i
                  #:label (format "~a" p)
                )
               )
            (range (length all-programs)) all-programs)
          (map (λ (i p) 
                (pretty-print `(plot ,p ,i))
                (lines 
                  (get-mcfa-num-singletons (find-prog p (hash-ref h "mcfa-r")))
                  #:color i
                  #:label (format "~a" p)
                )
               )
            (range (length all-programs) (* 2 (length all-programs))) all-programs)
        #:x-label "Gas"
        #:y-label "Percent Answered Queries"
        #:width plot-width
        #:height plot-height
        #:out-file (format "plots/total-queries-answered_~a.~a" m out)
        )


      ) 
      (range (length hashes)) hashes)
    ; (parameterize ([plot-y-transform log-transform])
  
  )
)

