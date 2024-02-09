#lang racket/base
(require racket/match
         racket/string
         racket/set
         racket/pretty
         racket/list
         racket/port
         plot
         "config.rkt"
         )

(define (read-file file) (call-with-input-file file read-all))
(define (read-all inport) (map cadr (port->list read inport)))
(define (average l) (/ (sum l) (length l)))
(define (sum l) (apply + (replace-zeros l)))
(define (replace-zeros l) (map (lambda (v) (if (equal? v 0) 1/1000 v)) l))

(define (avg-time-res line)
  (match line
    ; Demand shuffled (cached)
    [`(,name ,m ,shufflen ,query ,hash-num ,time-res) (average (map car time-res))]
    ; Demand no cache
    [`(,name ,m ,query ,hash-num ,time-res) (average (map car time-res))]
    ; Regular mCFA
    [`(,name ,m ,hash-num ,time-res) (average (map car time-res))]
    ))

(define ((cfa mexpected) line)
  (match line
    ; Demand shuffled (cached)
    [`(,name ,m ,shufflen ,query ,hash-num ,time-res) (equal? m mexpected)]
    ; Demand no cache
    [`(,name ,m ,query ,hash-num ,time-res) (equal? m mexpected)]
    ; Regular mCFA
    [`(,name ,m ,hash-num ,time-res) (equal? m mexpected)]
    ))

(define (step-n lines m-value [do-sort #f])
  (define avg (avg-time-res m-value))
  (define avgs (map avg-time-res lines))
  (define avgsort (if do-sort (sort avgs) avgs))
  (define cum (cumulative avgsort))
  (pretty-print avg)
  (pretty-print cum)
  (lambda (normt)
    (define t (* normt 1))
    (define res (map (lambda (v) (if (>= t v) 1 0)) cum))
    (average res)))

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
       [mcfa-r0 (filter (cfa 0) mcfa-rebind-results)]
       [mcfa-r1 (filter (cfa 1) mcfa-rebind-results)]
       [mcfa-r2 (filter (cfa 2) mcfa-rebind-results)]
       [mcfa-e0 (filter (cfa 0) mcfa-expm-results)]
       [mcfa-e1 (filter (cfa 1) mcfa-expm-results)]
       [mcfa-e2 (filter (cfa 2) mcfa-expm-results)]
       [dmcfa-b0 (filter (cfa 0) dmcfa-results)]
       [dmcfa-b1 (filter (cfa 1) dmcfa-results)]
       [dmcfa-b2 (filter (cfa 2) dmcfa-results)]
       [dmcfa-a0 (filter (cfa 0) dmcfa-acc-results)]
       [dmcfa-a1 (filter (cfa 1) dmcfa-acc-results)]
       [dmcfa-a2 (filter (cfa 2) dmcfa-acc-results)]
       )
  (define programs (set->list (apply set (map car mcfa-rebind-results))))
  (define num-programs (length programs))
  (pretty-print (exact->inexact (/ (sum (map avg-time-res mcfa-r1)) num-programs)))
  (pretty-print (exact->inexact (/ (sum (map avg-time-res mcfa-e1)) num-programs)))
  (pretty-print (exact->inexact (/ (sum (map avg-time-res dmcfa-b1)) num-programs)))
  (pretty-print (exact->inexact (/ (sum (map avg-time-res dmcfa-a1)) (* num-shuffles num-programs))))
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

    (map (lambda (prog)
           (define p (find-prog prog mcfa-e1))
           (plot
            #:x-min 1/500
            #:x-max 500
            #:y-min 0
            #:y-max 1.1
            #:out-file (format "plots/~a.pdf" prog)
            (cons
             (function (step-n p (car p))
                       1/500 500
                       #:samples 1000
                       #:style 'solid
                       #:label (format "1CFA ~a" prog)
                       #:color 0)
             (cons (function (step-n (find-prog prog dmcfa-b1) (car p) #t)
                             1/500 500
                             #:samples 1000
                             #:style 'solid
                             #:label (format "d1CFA ~a" prog)
                             #:color 0)
                   (map (lambda (iter)
                          (function (step-n (find-prog-randiter prog iter dmcfa-a1) (car p))
                                    1/500 500
                                    #:samples 1000
                                    #:style 'solid
                                    #:color iter)
                          )
                        (range num-shuffles))
                   )

             )
            )
           ) programs)
    )
  )
