#lang racket/base
(require racket/match racket/pretty racket/list racket/set "syntax.rkt")
(provide (all-defined-out))

(define (translate-top-defs-out . ss)
  (define result ((translate-top-defs-internal #t) ss))
  ; (pretty-print result)
  result
  )

(define (is-lam-def d)
  (match d
    [`(define ,id (λ ,xs ,bod)) #t]
    [_ #f])
  )

(define (is-def d)
  (match d
    [`(define ,id ,expr) #t]
    [_ #f])
  )

(define (to-let-bind d)
  (match d
    [`(define ,id ,expr) `(,id ,expr)]
    [_ d]
    ))

(define (to-begin exprs)
  (match exprs
    ['() '()]
    [(list e) e]
    [(cons e es) `(let ((_ ,e)) ,(to-begin es))]
    )
  )

(define (remove-def-types xss)
  (match xss
    ['() '()]
    [(cons `(app ,nm : ,tp) xs) (remove-def-types xs)]
    [(cons `(app define-type ,tp ,@body) xs) (remove-def-types xs)]
    [(cons `(app define-type-alias ,tp ,@body) xs) (remove-def-types xs)]
    [(cons x xs) (cons x (remove-def-types xs))]
    )
  )

(define (get-types xss)
  (match xss
    ['() (list '() '())]
    [(cons `(app define-type ,tp ,@body) xs)
     ;  (pretty-print (car xss))
     ;  (pretty-print body)
     (match-let ([(list fns tps) (get-tps body)]
                 [(list fnss tpss) (get-types xs)])
       (list (append fns fnss) (append tps tpss))
       )
     ]
    [(cons x xs) (get-types xs)]
    ))

(define (get-common-types)
  (list (list
         (list 'car
               `(λ (car-v)
                  (match car-v
                    [(cons car-c car-d) car-c])
                  )
               )
         (list 'cdr
               `(λ (cdr-v)
                  (match cdr-v
                    [(cons cdr-c cdr-d) cdr-d])
                  )
               )
         (list 'cadr
               `(λ (cadr-v)
                  (car (cdr cadr-v))
                  )
               )
         (list 'caddr
               `(λ (cadr-v)
                  (car (cdr (cdr cadr-v)))
                  )
               )
         (list 'map
               `(λ (map-f map-l)
                  (match map-l
                    [(cons map-c map-d) (app cons (app map-f map-c) (app map map-f map-d))]
                    [(nil) (app nil)]
                    )
                  )
               )
         (list 'pair?
               `(λ (pair?-v)
                  (match pair?-v
                    [(cons pair?-c pair?-d) (app #t)]
                    [_ (app #f)])
                  )
               )
         (list 'null?
               `(λ (null?-v)
                  (match null?-v
                    [(nil) (app #t)]
                    [_ (app #f)])
                  )
               )
         )
        (list `(cons car cdr) `(nil)))
  )

(define (get-tps tps)
  (match tps
    ['() (list '() '())]
    [(cons `(app ,nm ,@args) tps)
     ;  (pretty-print `(,nm ,args))
     (define as (map remove-tp args))
     ;  (pretty-print `(,nm ,as))
     (match-let ([(list dfs tps) (get-tps tps)]
                 [fns (gen-type-arg-funcs nm as 0 (length args))])
       ;  (pretty-print fns)
       (list (append dfs fns) (cons `(,nm ,@as) tps))
       )
     ]
    ))

(define (gen-type-arg-funcs nm args i n)
  (match args
    ['() (list (list (string->symbol (string-append (symbol->string nm) "?"))
                     `(λ (a)
                        (match a
                          [(,nm ,@(map (λ (_) '_) (range n))) (app #t)]
                          [_ (app #f)]
                          ))))]
    [(cons a as)
     (define name (string-append (symbol->string nm) "-" (symbol->string a)))
     (define match-name (string-append name "-v"))
     (define select-name (string-append name "-x"))
     (cons (list (string->symbol name)
                 `(λ (,(string->symbol match-name))
                    (match ,(string->symbol match-name)
                      [(,nm ,@(map (λ (ix) (if (= i ix) (string->symbol select-name) '_)) (range n))) x]
                      [_ (app error ,(format "invalid match for ~a-~a" nm a))]
                      )))
           (gen-type-arg-funcs nm as (+ 1 i) n))]))

(define (remove-tp tp)
  (match tp
    [`(app ,nm : ,tp) nm]
    [x x]
    ))


(define (translate-top-defs ss)
  ((translate-top-defs-internal #f) ss)
  )

(define ((translate-top-defs-internal top) ss)
  ; (pretty-print `(translate-top-defs ,ss))
  (define tops-full-defs (if top (map (translate-top #t) ss) (map (translate-top) ss)))
  (define tops (remove-def-types tops-full-defs))
  (define exprs (filter (lambda (d) (not (is-def d))) tops))
  (define all-defs (filter is-def tops))
  (define binds (map to-let-bind all-defs))
  ; (pretty-print `(translate-top-defs ,tops-full-defs))

  ; (pretty-print `(translate-top-defs ,tops))
  (match-let ([(list top-type-defs top-types) (get-types tops-full-defs)]
              [(list common-type-defs common-types) (if top (get-common-types) (list '() '()) )]
              )
    ; (if (empty? top-type-defs) '() (pretty-print top-type-defs))
    ; (if (empty? common-type-defs) '() (pretty-print common-type-defs))
    (define bodies (append exprs (map cadr binds)))
    (define fvs (if (empty? bodies) (set) (apply set-union (map free-vars bodies))))
    ; (pretty-print fvs)
    (define used (filter (lambda (td)
                           (match td
                             [`(,nm ,_) (set-member? fvs nm)]
                             )) (append top-type-defs common-type-defs)))
    (define used-types (filter (lambda (td)
                                 (match td
                                   [`(,nm ,@_) (set-member? fvs nm)]
                                   )) (append common-types top-types)))
    (make-type-defs used-types (make-binds (append used binds) (to-begin exprs)))
    ))


(define (translate-top-defs-expr expr ss)
  ; (pretty-print `(translate-top-defs ,ss))
  (define tops-full-defs (map (translate-top) ss))
  (define tops (remove-def-types tops-full-defs))
  (define binds (map to-let-bind (filter is-def tops)))
  ; (pretty-print `(translate-top-defs ,expr))
  (match-let ([(list top-type-defs top-types) (get-types tops-full-defs)])
    ; (if (empty? top-type-defs) '() (pretty-print top-type-defs))
    (define fvs (apply set-union (free-vars (cons expr (map cadr binds)))))
    ; (pretty-print fvs)
    (define used (filter (lambda (td)
                           (match td
                             [`(,nm ,@_) (set-member? fvs nm)]
                             )) top-type-defs))
    (make-type-defs top-types (make-binds (append used binds) expr))
    ))

(define (make-type-defs tps body)
  (match tps
    ['() body]
    [tps `(lettypes ,tps ,body)]
    ))

(define (make-binds binds expr)
  (match binds
    ['() expr]
    [(cons _ _) `(letrec* ,binds ,expr)]
    ))

(define ((translate-top [top #f]) s)
  (match (translate s)
    [`(app ,e) (if top e `(app ,e))]
    [e e]
    )
  )

(define (translate-def d)
  (match d
    [`(,x ,e) `(,x ,(translate e))]
    )
  )

(define (translate s)
  ; (pretty-print `(translate ,s))
  (match s
    [#f `(app #f)]
    [#t `(app #t)]
    [(? number? x) x]
    [(? symbol? x) x]
    [(? string? x) x]
    [(? char? x) x]
    [`(λ (,@args) ,@es)
     ;  (pretty-print `(translate-bod ,es))
     `(λ (,@(remove-types args)) ,(translate-top-defs es))]
    [`(lambda (,@args) ,@es) `(λ (,@(remove-types args)) ,(translate-top-defs es))]
    [`(local ,defs ,@es) (translate-top-defs-expr (translate-top-defs es) defs)]
    [`(letrec ,defs ,@es) `(letrec ,(map translate-def defs) ,(translate-top-defs es))]
    [`(let ,defs ,@es) `(let ,(map translate-def defs) ,(translate-top-defs es))]
    [`(let* ,defs ,@es) `(let* ,(map translate-def defs) ,(translate-top-defs es))]
    [`(if ,c ,t ,f) `(match ,(translate c) [(#f) ,(translate f)] [_ ,(translate t)] )]
    [`(cond ,@mchs) (unwrap-cond mchs)]
    [`(match ,c ,@mchs) `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(type-case ,tp ,c ,@mchs)
     ;  (pretty-print `(translate-type-case ,@mchs))
     `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(define (,id ,@args) : ,returntype ,@exprs) `(define ,id (λ (,@(remove-types args)) ,(translate-top-defs exprs)))]
    [`(define (,id ,@args) ,@exprs)
     ;  (pretty-print `(translate-define ,exprs))
     `(define ,id (λ (,@(remove-types args)) ,(translate-top-defs exprs)))]
    [`(define ,id ,expr)
     ;  (pretty-print `(translate-def ,expr))
     `(define ,id ,(translate expr))]
    [`(begin ,@exprs) (to-begin (map translate exprs))]
    [`(list ,a ,@as) `(app cons ,(translate a) ,(translate `(list ,@as)))]
    [`(list) `(app nil)]
    [`(quote ,(? number? x)) x]
    [`(quote ,(? char? x)) x]
    [`(quote ,(? string? x)) x]
    [`(quote ,ls) (to-list ls)]
    [`(,@es)
     `(app ,@(map translate es))]
    )
  )

(define (to-list l)
  (match l
    ['() `(app nil)]
    [(cons x xs) `(app cons ,(translate `',x) ,(to-list xs))]
    [x
     ;  (pretty-print `(quoting ,x as ',x))
     `',x]
    )
  )

(define (remove-types args)
  (match args
    [(cons a as) (cons (remove-type a) (remove-types as))]
    ['() '()]
    ))

(define (remove-type a)
  (match a
    [`(,name : ,type) name]
    [x x]
    )
  )

(define (unwrap-match mch)
  (match mch
    [`(,(? symbol? c) ,@es) `((,c) ,(translate-top-defs es))]
    [`(,c ,@es)
     `(,c ,(translate-top-defs es))]
    ))

(define (unwrap-cond mchs)
  (match mchs
    ['() `(app error)]
    [(list `(else ,@es)) (translate-top-defs es)]
    [(cons `(,c ,@es) xs)
     `(match ,(translate c)
        [(#f) ,(unwrap-cond xs)]
        [_ ,(translate-top-defs es)]
        )]))