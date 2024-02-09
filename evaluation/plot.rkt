#lang racket/base
(require racket/match
         racket/string
         racket/set
         racket/pretty
         racket/port
         plot/no-gui
         )

(define (read-file file) (call-with-input-file file read-all))
(define (read-all inport) (port->list read inport))

(let* ([mcfa-rebind-results (read-file "tests/rebind-time.sexpr")]
       [mcfa-expm-results (read-file "tests/expm-time.sexpr")]
       [dmcfa-results (read-file "tests/basic-time.sexpr")]
       )
  (define programs (apply set (map caadr mcfa-rebind-results)))
  (pretty-print programs)
  (define (0+ x) (if (zero? x) 1/2 x))
  (define ts
    (list (pre-tick 1/1000 #t)
          (pre-tick 1/500 #f)
          (pre-tick 1/100 #t)
          (pre-tick 1/50 #f)
          (pre-tick 1/10 #t)
          (pre-tick 1/2 #f)
          (pre-tick 1 #t)
          (pre-tick 5 #f)
          (pre-tick 10 #t)
          (pre-tick 50 #f)
          (pre-tick 100 #t)
          (pre-tick 500 #f)
          (pre-tick 1000 #t)
          (pre-tick 5000 #f)))
  '()
  ; (parameterize ([plot-y-transform log-transform]
  ;                [plot-y-ticks (ticks (λ (y₀ y₁) ts)
  ;                                     (λ (y₀ y₁ ts)
  ;                                       (map (match-lambda
  ;                                              [(pre-tick y _)
  ;                                               (format "~a×" y)])
  ;                                            ts)))]
  ;                [plot-y-far-ticks no-ticks]
  ;                [plot-y-label "Time"]
  ;                [plot-x-label "Program"]
  ;                [plot-width 1024]
  ;                [plot-height 512])
  ;   (plot-file #:y-min 1/10
  ;              #:y-max 10000
  ;              (list (y-tick-lines)
  ;                    #;
  ;                    (map
  ;                     (match-lambda
  ;                       [(pre-tick y major?)
  ;                        ])
  ;                     ts)
  ;                    (discrete-histogram (for/list ([pr (in-list programs)])
  ;                                          (vector pr (/ (0+ (hash-ref kcfa-results-0 pr))
  ;                                                        (0+ (hash-ref kcfa-results-0 pr)))))
  ;                                        #:skip 3.5
  ;                                        #:x-min 0
  ;                                        #:label "0CFA"
  ;                                        #:color 3 #:line-color 3)
  ;                    (discrete-histogram (for/list ([pr (in-list programs)])
  ;                                          (vector pr (/ (0+ (hash-ref mcfa-results-0 pr))
  ;                                                        (0+ (hash-ref kcfa-results-0 pr)))))
  ;                                        #:skip 3.5
  ;                                        #:x-min 2
  ;                                        #:label "Demand 0CFA"
  ;                                        #:color 2 #:line-color 2))
  ;              "comprehensive-ci.pdf")
  ;   (plot-file #:y-min 1/1000
  ;              #:y-max 10000
  ;              (list (y-tick-lines)
  ;                    #;
  ;                    (map
  ;                     (match-lambda
  ;                       [(pre-tick y major?)
  ;                        ])
  ;                     ts)
  ;                    (discrete-histogram (for/list ([pr (in-list programs)])
  ;                                          (vector pr (/ (0+ (hash-ref kcfa-results-1 pr))
  ;                                                        (0+ (hash-ref kcfa-results-1 pr)))))
  ;                                        #:skip 4.5
  ;                                        #:x-min 0
  ;                                        #:label "1CFA"
  ;                                        #:color 3 #:line-color 3)
  ;                    (discrete-histogram (for/list ([pr (in-list programs)])
  ;                                          (vector pr (/ (0+ (hash-ref mcfa-results-1 pr))
  ;                                                        (0+ (hash-ref kcfa-results-1 pr))) ))
  ;                                        #:skip 4.5
  ;                                        #:x-min 2
  ;                                        #:label "Demand 1CFA"
  ;                                        #:color 2 #:line-color 2))
  ;              "comprehensive-cs.pdf"))
  )
