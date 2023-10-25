#lang racket/base
(require racket/match
         plot/no-gui)

(let ([ddpa (map
              (match-lambda
                [(list program 0 ts-0 k ts-k)
                 (define (process-ts ts)
                   (/ (apply
                       +
                       (map
                        (match-lambda
                          [(list start-time end-time)
                           (- end-time start-time)])
                        ts))
                      (length ts)))
                 (list program
                       0 (process-ts ts-0)
                       k (process-ts ts-k))])
              (call-with-input-file "evaluation/results/ddpa.sexp" read))])
   (let ([programs (map car ddpa)])
     (let ([kcfa-results-0 (for/hasheq ([entry (in-list (call-with-input-file "evaluation/results/k=0.sexp" read))])
                             (match-let ([(list (app string->symbol program) _ (list cpu real gc)) entry])
                               (values program real)))]
           [kcfa-results-1 (for/hasheq ([entry (in-list (call-with-input-file "evaluation/results/k=1.sexp" read))])
                             (match-let ([(list (app string->symbol program) _ (list cpu real gc)) entry])
                               (values program real)))]
           [ddpa-results-0 (for/hasheq ([entry (in-list ddpa)])
                                (match-let ([(list program 0 t-0 k t-k) entry])
                                  (values program (cons 0 (inexact->exact (floor (+ (* t-0 1000) 0.5)))))))]
           [ddpa-results-k (for/hasheq ([entry (in-list ddpa)])
                             (match-let ([(list program 0 t-0 k t-k) entry])
                               (values program (cons k (inexact->exact (floor (+ (* t-k 1000) 0.5)))))))]
           [mcfa-results-0 (for/hasheq ([entry (in-list (call-with-input-file "evaluation/results/ldcfa-time-0-inf.sexp" read))])
                             (match-let ([(list (app string->symbol program) _ (list 'accumulation _ (list cpu real gc))) entry])
                               (values program real)))]
           [mcfa-results-1 (for/hasheq ([entry (in-list (call-with-input-file "evaluation/results/dcfa-time-1-inf.sexp" read))])
                             (match-let ([(list (app string->symbol program) _ (list 'accumulation (list successes failures) (list cpu real gc))) entry])
                               (values program real)))]
           [lightweight-mcfa-results-1 (for/hasheq ([entry (in-list (call-with-input-file "evaluation/results/ldcfa-time-1-inf.sexp" read))])
                             (match-let ([(list (app string->symbol program) _ (list 'accumulation _ (list cpu real gc))) entry])
                               (values program real)))])
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
       (parameterize ([plot-y-transform log-transform]
                      [plot-y-ticks (ticks (λ (y₀ y₁) ts)
                                           (λ (y₀ y₁ ts)
                                             (map (match-lambda
                                                    [(pre-tick y _)
                                                     (format "~a×" y)])
                                                  ts)))]
                      [plot-y-far-ticks no-ticks]
                      [plot-y-label "Time"]
                      [plot-x-label "Program"]
                      [plot-width 1024]
                      [plot-height 512])
         (plot-file #:y-min 1/10
                    #:y-max 10000
                    (list (y-tick-lines)
                          #;
                          (map
                           (match-lambda
                             [(pre-tick y major?)
                              ])
                           ts)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (hash-ref kcfa-results-0 pr))
                                                              (0+ (hash-ref kcfa-results-0 pr)))))
                                              #:skip 3.5
                                              #:x-min 0
                                              #:label "0CFA"
                                              #:color 3 #:line-color 3)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (cdr (hash-ref ddpa-results-0 pr)))
                                                              (0+ (hash-ref kcfa-results-0 pr)))))
                                              #:skip 3.5
                                              #:x-min 1
                                              #:label "0DDPA"
                                              #:color 1 #:line-color 1)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (hash-ref mcfa-results-0 pr))
                                                              (0+ (hash-ref kcfa-results-0 pr)))))
                                              #:skip 3.5
                                              #:x-min 2
                                              #:label "Demand 0CFA"
                                              #:color 2 #:line-color 2))
                    "comprehensive-ci.pdf")
         (plot-file #:y-min 1/1000
                    #:y-max 10000
                    (list (y-tick-lines)
                          #;
                          (map
                           (match-lambda
                             [(pre-tick y major?)
                              ])
                           ts)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (hash-ref kcfa-results-1 pr))
                                                              (0+ (hash-ref kcfa-results-1 pr)))))
                                              #:skip 4.5
                                              #:x-min 0
                                              #:label "1CFA"
                                              #:color 3 #:line-color 3)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (cdr (hash-ref ddpa-results-k pr)))
                                                              (0+ (hash-ref kcfa-results-1 pr)))))
                                              #:skip 4.5
                                              #:x-min 1
                                              #:label "1DDPA"
                                              #:color 1 #:line-color 1)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (hash-ref mcfa-results-1 pr))
                                                              (0+ (hash-ref kcfa-results-1 pr))) ))
                                              #:skip 4.5
                                              #:x-min 2
                                              #:label "Demand 1CFA"
                                              #:color 2 #:line-color 2)
                          (discrete-histogram (for/list ([pr (in-list programs)])
                                                (vector pr (/ (0+ (hash-ref lightweight-mcfa-results-1 pr))
                                                              (0+ (hash-ref kcfa-results-1 pr)))))
                                              #:skip 4.5
                                              #:x-min 3
                                              #:label "Lightweight Demand 1CFA"
                                              #:color 4 #:line-color 4))
                    "comprehensive-cs.pdf")))))
