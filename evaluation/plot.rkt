#lang racket/base
(require racket/match
         racket/set
         racket/list
         racket/port
         racket/math
         racket/pretty
         plot
         "config.rkt"
         )

(define (read-file file) (call-with-input-file file read-all))
(define (read-all inport) (map cadr (port->list read inport)))
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
    [`(,kind ,name ,m #f) #f]
    [`(,kind ,name ,m ,gas ,num-instant ,num-eval ,num-store ,instant-singletons ,singletons ,avg-precision ,time-res) (average-or-false time-res)]
    ))

(define ((num-singletons instant) line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant #f) #f]
    [`(shuffled-cache ,shufflen ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant
                      ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                      ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                      ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                      ,time-result) (if
                                     (if instant
                                         (and is-instant is-precise)
                                         (and (not is-instant) is-precise)
                                         ) #t #f)]
    ; Demand no cache
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant #f) #f]
    [`(clean-cache ,name ,m ,gas ,num-queries ,query-kind ,query ,is-instant
                   ,num-entries ,num-eval-subqueries ,num-expr-subqueries ,num-refines
                   ,num-eval-determined ,num-expr-determined, num-fully-determined-subqueries
                   ,eval-groups-avg-size ,eval-sub-avg-determined ,singletons ,is-precise ,avg-precision
                   ,time-result) (if (if instant
                                         (and is-instant is-precise)
                                         (and (not is-instant) is-precise)
                                         ) #t #f)]
    ; Regular mCFA
    [`(,kind ,name ,m #f ,err) 0]
    [`(,kind ,name ,m ,gas ,num-instant ,num-eval ,num-store ,instant-singletons ,singletons ,avg-precision ,time-res)
     (if instant
         instant-singletons
         singletons)
     ]
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

(define (get-name line)
  (match line
    ; Demand shuffled (cached)
    [`(shuffled-cache ,shufflen ,name ,@_) name]
    ; Demand no cache
    [`(clean-cache ,name ,@_) name]
    ; Regular mCFA
    [`(,kind ,name ,@_) name]
    ))

(define (get-singletons-gas gas lines [instant #f])
  (define results (count (num-singletons instant) (filter (filter-gas gas) lines)))
  ; (pretty-print results)
  results
  )

(define (get-mcfa-num-singletons lines [instant #f])
  (pretty-print `(,lines))
  (define results ((num-singletons instant) (car lines)))
  (pretty-print "Lines2")
  results
  )

(define (get-points lines)
  ; (pretty-print lines)
  (map (lambda (g) (list g (* 100 (/ (count is-result (filter (filter-gas g) lines)) (length (filter (filter-gas g) lines)))))) gases)
  )

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

(define (plot-total-queries p hashes out)
  (parameterize ([plot-y-ticks (ticks percent-tick format-percent)])
    (plot
    (map (lambda (m h)
            (lines
            (get-points (find-prog p (hash-ref h "dmcfa-b")))
            #:label (format "m=~a" m)
            #:color m
            ))
          (range (length hashes)) hashes
          )
    #:x-label #f
    #:y-label #f
    #:width plot-width
    #:height plot-height
    #:y-min 0
    #:y-max 100
    #:title (symbol->string p)
    #:aspect-ratio 1
    #:legend-anchor 'no-legend
    #:out-file (format "plots/total-queries-answered_~a.~a" p out)
    )
  )

  (parameterize ([plot-x-ticks no-ticks]
                 [plot-y-ticks no-ticks])
    (plot
    (map (lambda (m) 
      (lines 
        (list (list 0 0))
        #:label (format "m=~a" m)
              #:color m
      )) (range (length hashes))) 
    #:x-label #f
    #:y-label #f
    #:width plot-width
    #:height plot-height
    #:y-min 0
    #:y-max 100
    #:x-min (apply min gases)
    #:x-max (apply max gases)
    #:title "legend"
    #:legend-anchor 'outside-global-top
    #:aspect-ratio 1
    #:out-file (format "plots/total-queries-answered_legend.~a" out)
    )
  )
)


(define (plot-important programs hashes out)

  (line-width 1)
  (plot-legend-font-size 15)
  (plot
   (append 
    (apply
      append
      (map
        (lambda (m h)
          (define dmcfas
            (lines
              (map (lambda (g)
                      (list g (sum (map (lambda (p) 
                                            (get-singletons-gas g (find-prog p (hash-ref h "dmcfa-b")))) 
                                        programs)))) 
                    gases)
              #:color m
              #:label (format "m=~a Demand m-CFA" m)
            ))
          (if (> m 2)
              (list dmcfas)
              (let ()
                (define mcfas-values (sum (map (lambda (p) (get-mcfa-num-singletons (find-prog p (hash-ref h "mcfa-e")))) programs)))
                (define mcfas 
                  (lines
                    (map (lambda (g) (list g mcfas-values)) gases)
                    #:color m
                    #:style 'long-dash
                    #:label (format "m=~a m-CFA" m)
                    ))
                (list mcfas dmcfas))
            ))
        (range 5) hashes
      ))
   )
   #:x-label "Gas"
   #:y-label "Number of Singletons"
   #:aspect-ratio 1
   #:y-min 0
   #:y-max 500 #;(* 1.1 (sum
                   (apply
                    append
                    (map
                     (lambda (h)
                       (map (lambda (g) 
                                (list g (sum (map (lambda (p) 
                                                      (get-singletons-gas g (find-prog p (hash-ref h "dmcfa-b")))) 
                                                  programs)))) 
                              gases))
                     hashes))))
   #:width (exact-truncate (* plot-width 2))
   #:height (exact-truncate (* plot-height 2))
   #:title #f
   #:legend-anchor 'bottom-right
   #:out-file (format "plots/important-queries-answered.~a" out)
   )
)

(define program-size '((indirect-hol 17) (eta 23) (ack 40) (kcfa-2 32) (kcfa2 37) (mj09 33) (tak 41)
                                         (blur 43) (loop2-1 45) (kcfa-3 45) (kcfa3 45) (facehugger 47) (sat-1 58) (cpstak 59)
                                         (loop2 70) (sat 94) (sat-2 96) (map 97) (sat-3 100) (flatten 103) (primtest 180) (rsa 211)
                                         (fermat 246) (deriv 257) (regex 421) (tic-tac-toe 569) (scheme2java 1311)))
(define (get-program-size p [pgs program-size])
  (match pgs
    [(cons (list p1 size) rst) (if (equal? p p1) size (get-program-size p rst))]
    )
  )
(define reachability-bench-programs '(mj09 eta kcfa2 kcfa3 blur sat primtest rsa regex loop2-1 scheme2java))

(define all-programs (sort reachability-bench-programs (λ (p1 p2) (< (get-program-size p1) (get-program-size p2)))))

(define plot-height 150)
(define plot-width 150)

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

(define percent-tick (lambda (min max) (map (lambda (t) (pre-tick (* 10 t) (even? t))) (range 0 11))))

(define format-percent (lambda (min max ticks) (map (lambda (t) (format "~a%" (* 10 t))) (range 0 11))))

(let* ([ms (list 0 1 2 3 4)]
       [expm-res (filter (filter-kind 'exponential) all-results)]
       [rebind-res (filter (filter-kind 'rebinding) all-results)]
       [basic-res (filter (filter-kind 'clean-cache) all-results)]
       [kinds (list (cons "mcfa-r" rebind-res)
                    (cons "mcfa-e" expm-res)
                    (cons "dmcfa-b" basic-res))]
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

  (plot-legend-font-size 10)
  ; (pretty-print all-results)
  (plot-inset 1)
  (for ([out (list "pdf" "png")])
    (plot-important all-programs hashes out)
    (plot-legend-font-size 10)
    (map
     (λ (i p)
       (pretty-print p)
       (if (equal? i 0)
           (begin
             (plot-total-queries p hashes out)
             )
           (parameterize ()
             (plot-total-queries p hashes out)
             )
           )

       )
     (range (length all-programs))
     all-programs
     )
    )
  )