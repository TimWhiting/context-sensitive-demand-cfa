#lang racket/base
(require racket/match racket/pretty racket/list)
(provide (all-defined-out))
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
    )
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
     (cons (list (string->symbol (string-append (symbol->string nm) "-" (symbol->string a)))
                 `(λ (a)
                    (match a
                      [(,nm ,@(map (λ (ix) (if (= i ix) 'x '_)) (range n))) x]
                      [_ (app error ,(format "invalid match for ~a" a))]
                      )))
           (gen-type-arg-funcs nm as (+ 1 i) n))]))

(define (remove-tp tp)
  (match tp
    [`(app ,nm : ,tp) nm]
    [x x]
    ))

(define (translate-top-defs . ss)
  ; (pretty-print `(translate-top-defs ,ss))
  (define tops-full-defs (map translate-top ss))
  (define tops (remove-def-types tops-full-defs))
  (define exprs (filter (lambda (d) (not (is-def d))) tops))
  (define binds (map to-let-bind (filter is-def tops)))
  ; (pretty-print `(translate-top-defs ,tops))
  (match-let ([(list top-type-defs top-types) (get-types tops-full-defs)])
    ; (if (empty? top-type-defs) '() (pretty-print top-type-defs))
    (make-type-defs top-types (make-binds (append top-type-defs binds) exprs))
    ))

(define (translate-top-defs-expr expr ss)
  ; (pretty-print `(translate-top-defs ,ss))
  (define tops-full-defs (map translate-top ss))
  (define tops (remove-def-types tops-full-defs))
  (define binds (map to-let-bind (filter is-def tops)))
  ; (pretty-print `(translate-top-defs ,expr))
  (match-let ([(list top-type-defs top-types) (get-types tops-full-defs)])
    ; (if (empty? top-type-defs) '() (pretty-print top-type-defs))
    (make-type-defs top-types (make-binds (append top-type-defs binds) (list expr)))
    ))

(define (make-type-defs tps body)
  (match tps
    ['() body]
    [tps `(lettypes ,tps ,body)]
    ))

(define (make-binds binds exprs)
  (match binds
    ['() (to-begin exprs)]
    [(cons _ _) `(letrec ,binds ,(to-begin exprs))]
    ))

(define (translate-top s)
  (match (translate s)
    [`(app ,e) e]
    [e e]
    )
  )

(define (translate-def d)
  (match d
    [`(,x ,e) `(,x ,(translate-top-defs e))]
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
    [`(λ (,@args) ,@es) `(λ (,@(remove-types args)) ,(apply translate-top-defs es))]
    [`(lambda (,@args) ,@es) `(λ (,@(remove-types args)) ,(apply translate-top-defs es))]
    [`(local ,defs ,@es) (translate-top-defs-expr (apply translate-top-defs es) defs)]
    [`(letrec ,defs ,@es) `(letrec ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(let ,defs ,@es) `(let ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(let* ,defs ,@es) `(let* ,(map translate-def defs) ,(apply translate-top-defs es))]
    [`(if ,c ,t ,f) `(match ,(translate c) [(#t) ,(translate t)] [(#f) ,(translate f)])]
    [`(cond ,@mchs) (unwrap-cond mchs)]
    [`(match ,c ,@mchs) `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(type-case ,tp ,c ,@mchs) `(match ,(translate c) ,@(map unwrap-match mchs))]
    [`(define (,id ,@args) : ,returntype ,@exprs) `(define ,id (λ (,@(remove-types args)) ,(apply translate-top-defs exprs)))]
    [`(define (,id ,@args) ,@exprs) `(define ,id (λ (,@(remove-types args)) ,(apply translate-top-defs exprs)))]
    [`(define ,id ,expr) `(define ,id ,(translate-top-defs expr))]
    [`(begin ,@exprs) (to-begin (map translate exprs))]
    [`(list ,a ,@as) `(app cons ,(translate a) ,(translate `(list ,@as)))]
    [`(list) `(app nil)]
    [`(,@es)
     ;  (pretty-print `(translate-app))
     `(app ,@(map translate es))]
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
    [`(,c ,@es)
     `(,c ,(apply translate-top-defs es))]))

(define (unwrap-cond mchs)
  (match mchs
    ['() `(app error)]
    [(list `(else ,@es)) (apply translate-top-defs es)]
    [(cons `(,c ,@es) xs)
     `(match ,(translate c)
        [(#f) ,(unwrap-cond xs)]
        [_ ,(apply translate-top-defs es)]
        )]))