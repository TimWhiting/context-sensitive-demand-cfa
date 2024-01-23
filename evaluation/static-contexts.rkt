#lang racket/base
(require (rename-in "table-monad/main.rkt" [void fail]))
(require "config.rkt")
(require racket/set racket/match racket/list racket/pretty)
(provide (all-defined-out))
; syntax traversal

(define (oute Ce)
  (match Ce
    [(cons `(rat ,es ,C) e₀)
     (cons C `(app ,@(cons e₀ es)))]
    [(cons `(match-e ,es ,C) e₀)
     (cons C `(match ,e₀ ,@es))]
    [(cons `(ran ,f ,b ,a ,C) e)
     (cons C `(app ,@(cons f (append b (list e) a))))]
    [(cons `(match-clause ,m ,f ,b ,a ,C) e)
     (cons C `(match ,@(cons f (append b (list `(,m ,e)) a))))]
    [(cons `(bod ,y ,C) e)
     (cons C `(λ ,y ,e))]
    [(cons `(let-bod ,binds ,C) e₁)
     (cons C `(let ,binds ,e₁))]
    [(cons `(let-bin ,x ,e₁ ,before ,after ,C) e₀)
     (cons C `(let ,(append before (list `(,x ,e₀)) after) ,e₁))]
    [`(top) (error 'out "top")]))

(define (out Ce ρ)
  ; (pretty-print `(out ,Ce ,ρ))
  (match Ce
    [(cons `(rat ,es ,C) e₀)
     (unit (cons C `(app ,@(cons e₀ es))) ρ)]
    [(cons `(match-e ,es ,C) e₀)
     (unit (cons C `(match ,e₀ ,@es)) ρ)]
    [(cons `(ran ,f ,b ,a ,C) e)
     (unit (cons C `(app ,@(cons f (append b (list e) a)))) ρ)]
    [(cons `(match-clause ,m ,f ,b ,a ,C) e)
     (unit (cons C `(match ,@(cons f (append b (list `(,m ,e)) a)))) ρ)]
    [(cons `(bod ,y ,C) e)
     (unit (cons C `(λ ,y ,e))
           (match-let ([(cons _ ρ) ρ]) ρ))]
    [(cons `(let-bod ,binds ,C) e₁)
     (unit (cons C `(let ,binds ,e₁)) ρ)]
    [(cons `(let-bin ,x ,e₁ ,before ,after ,C) e₀)
     (unit (cons C `(let ,(append before (list `(,x ,e₀)) after) ,e₁)) ρ)]
    [(cons `(top) _)
     (error 'out "top")]))

(define (bin-e Ce ρ i)
  (match Ce
    [(cons C `(let ,binds ,e₁))
     (define before (take binds i))
     (define eqafter (drop binds i))
     (define after (cdr eqafter))
     (define bind (car eqafter))
     (list (cons `(let-bin ,(car bind) ,e₁ ,before ,after ,C) (cadr bind)) ρ)]))

(define (bin Ce ρ i)
  (match Ce
    [(cons C `(let ,binds ,e₁))
     (define before (take binds i))
     (define eqafter (drop binds i))
     (define after (cdr eqafter))
     (define bind (car eqafter))
     ;  (pretty-print bind)
     ;  (pretty-print (car bind))
     ;  (pretty-print (cadr bind))
     (unit (cons `(let-bin ,(car bind) ,e₁ ,before ,after ,C) (cadr bind)) ρ)]))

(define (bod-e Ce ρ)
  (match Ce
    [(cons C `(λ ,x ,e))
     (list (cons `(bod ,x ,C) e) (cons (take-cc `(□? ,x)) ρ))]
    [(cons C `(let ,binds ,e₁))
     (list (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (bod Ce ρ)
  (match Ce
    [(cons C `(λ ,x ,e))
     (unit (cons `(bod ,x ,C) e) (cons (take-cc `(□? ,x)) ρ))]
    [(cons C `(let ,binds ,e₁))
     (unit (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (bod-enter Ce call ρ ρ′)
  (match Ce
    [(cons C `(λ ,x ,e))
     (unit (cons `(bod ,x ,C) e) (cons (enter-cc call ρ) ρ′))]
    [(cons C `(let ,binds ,e₁))
     (unit (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (bod-calibrate Ce call ρ ρ′)
  (match Ce
    [(cons C `(λ ,x ,e))
     (unit (cons `(bod ,x ,C) e) (cons (take-cc `(cenv ,call ,ρ)) ρ′))]
    [(cons C `(let ,binds ,e₁))
     (unit (cons `(let-bod ,binds ,C) e₁) ρ)]))

(define (rat-e Ce ρ)
  (match Ce
    [(cons C `(app ,@es))
     (list (cons `(rat ,(cdr es) ,C) (car es)) ρ)]))

(define (rat Ce ρ)
  (match Ce
    [(cons C `(app ,@es))
     (unit (cons `(rat ,(cdr es) ,C) (car es)) ρ)]))


(define (focus-match-e Ce ρ)
  (match Ce
    [(cons C `(match ,m ,@ms))
     (list (cons `(match-e ,ms ,C) m) ρ)]
    ))

(define (focus-match Ce ρ)
  (match Ce
    [(cons C `(match ,m ,@ms))
     (unit (cons `(match-e ,ms ,C) m) ρ)]
    ))

(define (focus-clause-e Ce ρ i)
  (match Ce
    [(cons C `(match ,@ms))
     (define matches (drop ms 1))
     (define prev-ms (take matches i))
     (define after-ms (drop matches i))
     (define mat (car after-ms))
     (list (cons `(match-clause ,(car mat) ,(car ms) ,prev-ms ,(cdr after-ms) ,C) (cadr mat)) ρ)]
    ))

(define (focus-clause Ce ρ i)
  (match Ce
    [(cons C `(match ,@ms))
     (define matches (drop ms 1))
     (define prev-ms (take matches i))
     (define after-ms (drop matches i))
     (define mat (car after-ms))
     (unit (cons `(match-clause ,(car mat) ,(car ms) ,prev-ms ,(cdr after-ms) ,C) (cadr mat)) ρ)]
    ))

(define (ran-e Ce ρ i)
  (match Ce
    [(cons C `(app ,@es))
     (define args (drop es 1))
     (define prev-args (take args i))
     (define after-args (drop args i))
     (list (cons `(ran ,(car es) ,prev-args ,(cdr after-args) ,C) (car after-args)) ρ)]))

(define (ran Ce ρ i)
  ; (pretty-print `(ran ,i))
  (match Ce
    [(cons C `(app ,@es))
     (define args (drop es 1))
     (define prev-args (take args i))
     (define after-args (drop args i))
     (unit (cons `(ran ,(car es) ,prev-args ,(cdr after-args) ,C) (car after-args)) ρ)]))

(define (gen-queries Ce ρ)
  (define self-query (list Ce ρ))
  (define child-queries (match Ce
                          [(cons _ `(app ,_ ,@args))
                           (foldl set-union (set)
                                  (cons (apply gen-queries (rat-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (ran-e Ce ρ i)))
                                             (range (length args)))))]
                          [(cons _ `(λ ,_ ,_))
                           (apply gen-queries (bod-e Ce ρ))]
                          [(cons _ `(let ,binds ,_))
                           (foldl set-union (set)
                                  (cons (apply gen-queries (bod-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (bin-e Ce ρ i)))
                                             (range (length binds)))))
                           ]
                          [(cons _ `(match ,_ ,@ms))
                           (foldl set-union (set)
                                  (cons (apply gen-queries (focus-match-e Ce ρ))
                                        (map (λ (i)
                                               (apply gen-queries (focus-clause-e Ce ρ i)))
                                             (range (length ms)))))]
                          [_ (set)]))
  (set-add child-queries self-query))


; calling contexts

; Can the environment be refined further?
(define cc-determined?
  (match-lambda
    [(list)
     #t]
    ['! #t] ; Cut known
    ['? #t] ; Cut unknown (can be reinstantiated to an indeterminate context)
    [`(□? ,_)
     #f]
    [`(cenv ,Ce ,ρ)
     (and (map cc-determined? ρ))]
    [(cons Ce cc)
     (cc-determined? cc)]))

(define (take-cc cc)
  (take-ccm (current-m) cc))

(define (take-ccm m cc)
  (if (zero? m)
      (if (equal? 'basic (demand-kind))
          (list)
          (match cc
            [`(cenv ,Ce ,ρ) '!]; Cut known
            [`(cons Ce cc) '!]; Cut known
            ['! '!]
            [(list) (list)]; Already 0
            [_ '?])) ; Cut unknown -- TODO: Can we leave the variable since it terminates anyways?
      (match cc
        [(list)
         (list)]
        ['! '!] ; Cut known
        ['? '?] ; Cut unknown (can be reinstantiated to an indeterminate context)
        [`(□? ,x)
         `(□? ,x)]
        [`(cenv ,Ce ,ρ)
         `(cenv ,Ce ,(map (λ (cc) (take-ccm (- m 1) cc)) ρ))]
        [(cons Ce cc)
         (cons Ce (take-ccm (- m 1) cc))])))

(define (head-env ρ)
  (match ρ
    [(list) (list)]
    [(cons cc _) cc])
  )

(define (enter-cc Ce ρ)
  (match (demand-kind)
    ['basic (take-cc (cons Ce (head-env ρ)))]
    [_ (take-cc `(cenv ,Ce ,ρ))]
    )
  )

(define (indeterminate-env Ce)
  (match Ce
    [(cons `(bod ,y ,C) e)
     (cons `(□? ,y) (indeterminate-env (cons C e)))]
    [`(top)
     (list)]
    [_
     (indeterminate-env (oute Ce))]
    ))

(define (calibrate-envs ρ₀ ρ₁); Adds one level of missing context
  (let [(res (map calibrate-ccs ρ₀ ρ₁))]
    (if (and res)
        res
        #f)
    ))

(define (calibrate-ccs cc₀ cc₁)
  (match cc₀
    [(list) (list)]
    ['! #f]
    ['? cc₁]
    [`(□? ,x) `(□? ,x)]
    [`(cenv ,Ce₀ ,ρ₀)
     (let [(res (calibrate-envs (indeterminate-env Ce₀) cc₁))]
       (if res
           `(cenv ,Ce₀ ,res)
           #f))]
    )
  )

(define (calibrate-env ρ)
  (begin
    ; (pretty-print "Calibrating env")
    ; (pretty-print ρ)
    (match ρ
      [`(cenv ,Ce ,ρ)
       (let [(res (calibrate-envs (indeterminate-env Ce) ρ))]
         (if res (cons Ce res) #f))]
      [_ #f]
      )))

; Is cc0 more refined or equal to cc1?
;  i.e. should an environment with cc1 be instantiate to replace cc1 with cc0?
(define (⊑-cc cc₀ cc₁)
  (match cc₀
    [(list)
     (match cc₁
       [(list) #t] ; equal
       ['? #f]
       ['! #f]
       [`(□? ,_) #f]
       [`(cenv ,Ce ,ρ) #f]
       [(cons _ _) #f])]
    ['!
     (match cc₁
       ['! #t]; cut unknown is equal
       [(list) #f]; cut is not more refined
       ['? #f]; cut known is not more refined
       [`(□? ,_) #f]; cut is not more refined
       [`(cenv ,Ce ,ρ) #f]; cut is not more refined
       [(cons _ _) #f])]; cut is not more refined
    ['?
     (match cc₁
       ['? #t]; cut known is equal
       ['! #f]; cut unknown is not more refined (it is but we don't need to run under unknown if we know)
       [(list) #f]; cut is not more refined
       [`(□? ,_) #f]; cut is not more refined
       [`(cenv ,Ce ,ρ) #f]; cut is not more refined
       [(cons _ _) #f])]; cut is not more refined
    [`(□? ,x)
     (match cc₁
       [(list) #f]; indeterminate is not more refined
       ['! #f]; indeterminate is more refined - we know more
       ['? #t]; indeterminate is more refined - we know the variables
       [`(□? ,y) (equal? x y)]; indeterminate is equal if they are equal otherwise false
       [`(cenv ,Ce ,ρ) #f]; indeterminate is not more refined
       [(cons _ _) #f])]
    [`(cenv ,Ce₀ ,ρ₀)
     (match cc₁
       [(list) #f]; call-env is not more refined
       ['! #t]; call-env is more refined
       ['? #t]; call-env is more refined
       [`(□? ,_) #t]; call-env is more refined
       [`(cenv ,Ce₁ ,ρ₁)
        (and (equal? Ce₀ Ce₁)
             (and (map ⊑-cc ρ₀ ρ₁)))]
       )]
    [(cons Ce₀ cc₀)
     (match cc₁
       [(list) #f]
       ['! #t]
       ['? #t]
       [`(□? ,_) #t]
       [(cons Ce₁ cc₁)
        (and (equal? Ce₀ Ce₁)
             (⊑-cc cc₀ cc₁))])]))
