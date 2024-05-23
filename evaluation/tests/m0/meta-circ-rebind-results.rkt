'(expression:
  (lettypes
   ((cons car cdr) (nil) (error r))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
     (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
     (map
      (λ (map-f map-l)
        (match
         map-l
         ((cons map-c map-d)
          (app cons (app map-f map-c) (app map map-f map-d)))
         ((nil) (app nil)))))
     (length
      (λ (length-l)
        (match
         length-l
         ((cons length-c length-d) (app + 1 (app length length-d)))
         ((nil) 0))))
     (pair?
      (λ (pair?-v)
        (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
     (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
     (cadr (λ (p) (app car (app cdr p))))
     (cddr (λ (p) (app cdr (app cdr p))))
     (cdddr (λ (p) (app cdr (app cdr (app cdr p)))))
     (caadr (λ (p) (app car (app car (app cdr p)))))
     (cdadr (λ (p) (app cdr (app car (app cdr p)))))
     (caddr (λ (p) (app car (app cdr (app cdr p)))))
     (cadar (λ (p) (app car (app cdr (app car p)))))
     (cadddr (λ (p) (app car (app cdr (app cdr (app cdr p))))))
     (map
      (λ (f lst)
        (match
         (app pair? lst)
         ((#f) (app nil))
         (_ (app cons (app f (app car lst)) (app map f (app cdr lst)))))))
     (for-each
      (λ (f lst)
        (let ((_
               (match
                (app pair? lst)
                ((#f) (app nil))
                (_
                 (app cons (app f (app car lst)) (app map f (app cdr lst)))))))
          (app void))))
     (append
      (λ (lst1 lst2)
        (match
         (app not (app pair? lst1))
         ((#f) (app cons (app car lst1) (app append (app cdr lst1) lst2)))
         (_ lst2))))
     (reverse
      (λ (lst)
        (match
         (app not (app pair? lst))
         ((#f)
          (app
           append
           (app reverse (app cdr lst))
           (app cons (app car lst) (app nil))))
         (_ lst))))
     (string->list
      (λ (s)
        (letrec*
         ((f
           (λ (i)
             (match
              (app < i (app string-length s))
              ((#f) (app nil))
              (_ (app cons (app string-ref s i) (app f (app + i 1))))))))
         (app f 0))))
     (apply
      (λ (f l)
        (let ((len (app length l)))
          (match
           (app = len 0)
           ((#f)
            (match
             (app = len 1)
             ((#f)
              (match
               (app = len 2)
               ((#f)
                (match
                 (app = len 3)
                 ((#f)
                  (match
                   (app = len 4)
                   ((#f) (app error "no-match"))
                   (_
                    (app
                     f
                     (app car l)
                     (app cadr l)
                     (app caddr l)
                     (app cadddr l)))))
                 (_ (app f (app car l) (app cadr l) (app caddr l)))))
               (_ (app f (app car l) (app cadr l)))))
             (_ (app f (app car l)))))
           (_ (app f))))))
     (assv
      (λ (x f)
        (match
         (app pair? f)
         ((#f) (app #f))
         (_
          (match
           (app eqv? (app car (app car f)) x)
           ((#f) (app assv x (app cdr f)))
           (_ (app car f)))))))
     (assq
      (λ (x f)
        (match
         (app pair? f)
         ((#f) (app #f))
         (_
          (match
           (app eq? (app car (app car f)) x)
           ((#f) (app assv x (app cdr f)))
           (_ (app car f)))))))
     (gensym-count 0)
     (gensym
      (λ (name)
        (let ((_ (app set! gensym-count (app + gensym-count 1))))
          (app
           string->symbol
           (app
            string-append
            (match
             (app symbol? name)
             ((#f) name)
             (_ (app symbol->string name)))
            "$"
            (app number->string gensym-count))))))
     (three-d-tagged-list?
      (λ (tag lst)
        (app
         and
         (app pair? lst)
         (app
          or
          (app eq? (app car lst) tag)
          (app
           and
           (app procedure? (app car lst))
           (app equal? (app (app car lst)) (app initial tag)))))))
     (tagged-list?
      (λ (tag lst) (app and (app pair? lst) (app eq? (app car lst) tag))))
     (singlet?
      (λ (list) (app and (app pair? list) (app null? (app cdr list)))))
     (partition-k
      (λ (pred list k)
        (match
         (app not (app pair? list))
         ((#f)
          (app
           partition-k
           pred
           (app cdr list)
           (λ (trues falses)
             (match
              (app pred (app car list))
              ((#f) (app k trues (app cons (app car list) falses)))
              (_ (app k (app cons (app car list) trues) falses))))))
         (_ (app k (app nil) (app nil))))))
     (unzip-amap-k
      (λ (amap k)
        (match
         (app not (app pair? amap))
         ((#f)
          (app
           unzip-amap-k
           (app cdr amap)
           (λ (xs ys)
             (app
              k
              (app cons (app car (app car amap)) xs)
              (app cons (app cadr (app car amap)) ys)))))
         (_ (app k (app nil) (app nil))))))
     (void (λ () (match (app #f) ((#f) (app void)) (_ (app #t)))))
     (define? (λ (s-exp) (app tagged-list? 'define s-exp)))
     (define-var?
      (λ (s-exp) (app and (app define? s-exp) (app symbol? (app cadr s-exp)))))
     (define-fun?
      (λ (s-exp) (app and (app define? s-exp) (app pair? (app cadr s-exp)))))
     (define->var
      (λ (s-exp)
        (match
         (app define-var? s-exp)
         ((#f)
          (match
           (app define-fun? s-exp)
           ((#f) (app error "unknown define!"))
           (_ (app caadr s-exp))))
         (_ (app cadr s-exp)))))
     (define->exp
      (λ (s-exp)
        (match
         (app define-var? s-exp)
         ((#f)
          (match
           (app define-fun? s-exp)
           ((#f) (app error "no-match"))
           (_
            (app
             cons
             three-d-lambda
             (app cons (app cdadr s-exp) (app cddr s-exp))))))
         (_ (app caddr s-exp)))))
     (if? (λ (s-exp) (app three-d-tagged-list? 'if s-exp)))
     (if-single?
      (λ (s-exp) (app and (app if? s-exp) (app null? (app cdddr s-exp)))))
     (if->cond (λ (s-exp) (app cadr s-exp)))
     (if->true (λ (s-exp) (app caddr s-exp)))
     (if->false (λ (s-exp) (app cadddr s-exp)))
     (quote? (λ (s-exp) (app three-d-tagged-list? 'quote s-exp)))
     (quote->text (λ (s-exp) (app cadr s-exp)))
     (lambda? (λ (s-exp) (app three-d-tagged-list? 'lambda s-exp)))
     (lambda-multi?
      (λ (s-exp) (app and (app lambda? s-exp) (app symbol? (app cadr s-exp)))))
     (lambda->formals (λ (s-exp) (app cadr s-exp)))
     (lambda->body (λ (s-exp) (app cddr s-exp)))
     (lambda->body-as-exp (λ (s-exp) (app make-begin (app cddr s-exp))))
     (begin? (λ (s-exp) (app three-d-tagged-list? 'begin s-exp)))
     (begin->body (λ (s-exp) (app cdr s-exp)))
     (make-begin
      (λ (exps)
        (match
         (app singlet? exps)
         ((#f) (app cons three-d-begin exps))
         (_ (app car exps)))))
     (app? (λ (s-exp) (app pair? s-exp)))
     (app->fun (λ (s-exp) (app car s-exp)))
     (app->args (λ (s-exp) (app cdr s-exp)))
     (binding->var (λ (binding) (app car binding)))
     (binding->exp (λ (binding) (app cadr binding)))
     (letrec? (λ (s-exp) (app three-d-tagged-list? 'letrec s-exp)))
     (letrec->bindings (λ (s-exp) (app cadr s-exp)))
     (letrec->body (λ (s-exp) (app cddr s-exp)))
     (letrec->body-as-exp
      (λ (s-exp) (app make-begin (app letrec->body s-exp))))
     (let? (λ (s-exp) (app three-d-tagged-list? 'let s-exp)))
     (let->bindings (λ (s-exp) (app cadr s-exp)))
     (let->body (λ (s-exp) (app cddr s-exp)))
     (let->body-as-exp (λ (s-exp) (app make-begin (app let->body s-exp))))
     (let*? (λ (s-exp) (app three-d-tagged-list? 'let* s-exp)))
     (let*->bindings (λ (s-exp) (app cadr s-exp)))
     (let*->body (λ (s-exp) (app cddr s-exp)))
     (let*->body-as-exp (λ (s-exp) (app make-begin (app let*->body s-exp))))
     (or? (λ (s-exp) (app three-d-tagged-list? 'or s-exp)))
     (or->exps (λ (s-exp) (app cdr s-exp)))
     (make-or
      (λ (exps)
        (match
         (app null? exps)
         ((#f)
          (match
           (app singlet? exps)
           ((#f) (app cons 'or exps))
           (_ (app car exps))))
         (_ (app #f)))))
     (and? (λ (s-exp) (app three-d-tagged-list? 'and s-exp)))
     (and->exps (λ (s-exp) (app cdr s-exp)))
     (make-and
      (λ (exps)
        (match
         (app null? exps)
         ((#f)
          (match
           (app singlet? exps)
           ((#f) (app cons 'and exps))
           (_ (app car exps))))
         (_ (app #t)))))
     (cond? (λ (s-exp) (app three-d-tagged-list? 'cond s-exp)))
     (cond->clauses (λ (s-exp) (app cdr s-exp)))
     (arrow-clause?
      (λ (clause)
        (app
         and
         (app pair? clause)
         (app pair? (app cdr clause))
         (app eq? (app cadr clause) '=>))))
     (else-clause? (λ (clause) (app three-d-tagged-list? 'else clause)))
     (cond-clause->exp
      (λ (clause)
        (match
         (app singlet? clause)
         ((#f)
          (match
           (app else-clause? clause)
           ((#f)
            (match
             (app arrow-clause? clause)
             ((#f) (app make-begin (app cdr clause)))
             (_ (app caddr clause))))
           (_ (app cadr clause))))
         (_ (app car clause)))))
     (cond-clause->test
      (λ (clause)
        (match
         (app singlet? clause)
         ((#f)
          (match
           (app else-clause? clause)
           ((#f)
            (match
             (app arrow-clause? clause)
             ((#f) (app car clause))
             (_ (app car clause))))
           (_ (app #t))))
         (_ (app car clause)))))
     (set!? (λ (s-exp) (app three-d-tagged-list? 'set! s-exp)))
     (set!->var (λ (s-exp) (app cadr s-exp)))
     (set!->exp (λ (s-exp) (app caddr s-exp)))
     (macro? (λ (s-exp) (app three-d-tagged-list? 'macro s-exp)))
     (macro->proc (λ (s-exp) (app cadr s-exp)))
     (syntax-primitive?
      (λ (value) (app three-d-tagged-list? 'syntax-primitive value)))
     (syntax-primitive->eval (λ (value) (app cadr value)))
     (def->binding
      (λ (def)
        (app
         cons
         (app define->var def)
         (app cons (app define->exp def) (app nil)))))
     (body->letrec
      (λ (decs)
        (app
         partition-k
         define?
         decs
         (λ (defs exps)
           (match
            (app null? defs)
            ((#f)
             (let ((bindings (app map def->binding defs)))
               (app
                cons
                three-d-letrec
                (app
                 cons
                 bindings
                 (app cons (app make-begin exps) (app nil))))))
            (_ (app make-begin exps)))))))
     (letrec->lets+sets
      (λ (exp)
        (match
         (app not (app letrec? exp))
         ((#f)
          (let ((bindings
                 (app
                  map
                  (λ (binding)
                    (app
                     cons
                     (app binding->var binding)
                     (app cons (app #f) (app nil))))
                  (app letrec->bindings exp)))
                (sets
                 (app
                  map
                  (λ (binding)
                    (app
                     cons
                     three-d-set!
                     (app
                      cons
                      (app binding->var binding)
                      (app cons (app binding->exp binding) (app nil)))))
                  (app letrec->bindings exp))))
            (app
             cons
             three-d-let
             (app
              cons
              bindings
              (app
               cons
               (app make-begin (app append sets (app letrec->body exp)))
               (app nil))))))
         (_ exp))))
     (cond->if
      (λ (cond-exp)
        (match
         (app not (app cond? cond-exp))
         ((#f) (app cond-clauses->if (app cond->clauses cond-exp)))
         (_ cond-exp))))
     (cond-clauses->if
      (λ (clauses)
        (match
         (app null? clauses)
         ((#f)
          (let ((clause (app car clauses)))
            (match
             (app singlet? clause)
             ((#f)
              (match
               (app else-clause? clause)
               ((#f)
                (app
                 cons
                 three-d-if
                 (app
                  cons
                  (app cond-clause->test clause)
                  (app
                   cons
                   (app cond-clause->exp clause)
                   (app
                    cons
                    (app cond-clauses->if (app cdr clauses))
                    (app nil))))))
               (_ (app cond-clause->exp clause))))
             (_
              (app
               make-or
               (app cons clause (app cond-clauses->if (app cdr clauses))))))))
         (_ (app cons 'void (app nil))))))
     (and->if
      (λ (exp)
        (match
         (app not (app and? exp))
         ((#f)
          (let ((exps (app and->exps exp)))
            (match
             (app null? exps)
             ((#f)
              (match
               (app singlet? exps)
               ((#f)
                (app
                 cons
                 three-d-if
                 (app
                  cons
                  (app car exps)
                  (app
                   cons
                   (app and->if (app cons 'and (app cdr exps)))
                   (app cons (app #f) (app nil))))))
               (_ (app car exps))))
             (_ (app #t)))))
         (_ exp))))
     (or->if
      (λ (exp)
        (match
         (app not (app or? exp))
         ((#f)
          (let ((exps (app or->exps exp)))
            (match
             (app null? exps)
             ((#f)
              (match
               (app singlet? exps)
               ((#f)
                (let (($tmp (app gensym "or-tmp")))
                  (app
                   cons
                   three-d-let
                   (app
                    cons
                    (app
                     cons
                     (app cons $tmp (app cons (app car exps) (app nil)))
                     (app nil))
                    (app
                     cons
                     (app
                      cons
                      three-d-if
                      (app
                       cons
                       $tmp
                       (app
                        cons
                        $tmp
                        (app
                         cons
                         (app or->if (app cons three-d-or (app cdr exps)))
                         (app nil)))))
                     (app nil))))))
               (_ (app car exps))))
             (_ (app #f)))))
         (_ exp))))
     (let*->let
      (λ (exp)
        (match
         (app not (app let*? exp))
         ((#f)
          (app
           let*-bindings->let
           (app let*->bindings exp)
           (app let*->body exp)))
         (_ exp))))
     (let*-bindings->let
      (λ (bindings body)
        (match
         (app singlet? bindings)
         ((#f)
          (match
           (app null? bindings)
           ((#f)
            (app
             cons
             three-d-let
             (app
              cons
              (app cons (app car bindings) (app nil))
              (app
               cons
               (app let*-bindings->let (app cdr bindings) body)
               (app nil)))))
           (_ (app make-begin body))))
         (_
          (app
           cons
           three-d-let
           (app cons (app cons (app car bindings) (app nil)) body))))))
     (let->app
      (λ (exp)
        (match
         (app not (app let? exp))
         ((#f)
          (app
           unzip-amap-k
           (app let->bindings exp)
           (λ (vars exps)
             (app
              cons
              (app cons three-d-lambda (app cons vars (app let->body exp)))
              exps))))
         (_ exp))))
     (eval
      (λ (exp env)
        (match
         (app symbol? exp)
         ((#f)
          (match
           (app number? exp)
           ((#f)
            (match
             (app boolean? exp)
             ((#f)
              (match
               (app string? exp)
               ((#f)
                (match
                 (app procedure? exp)
                 ((#f)
                  (match
                   (app app? exp)
                   ((#f) (app error "no-match"))
                   (_
                    (app
                     perform-apply
                     (app eval (app app->fun exp) env)
                     exp
                     env))))
                 (_ (app exp))))
               (_ exp)))
             (_ exp)))
           (_ exp)))
         (_ (app env-lookup env exp)))))
     (eval-with (λ (env) (λ (exp) (app eval exp env))))
     (eval* (λ (exps env) (app map (app eval-with env) exps)))
     (eval-quote (λ (exp env) (app quote->text exp)))
     (eval-if
      (λ (exp env)
        (match
         (app if-single? exp)
         ((#f)
          (match
           (app eval (app if->cond exp) env)
           ((#f) (app eval (app if->false exp) env))
           (_ (app eval (app if->true exp) env))))
         (_
          (match
           (app eval (app if->cond exp) env)
           ((#f) (app void))
           (_ (app eval (app if->true exp) env)))))))
     (eval-cond (λ (exp env) (app eval (app cond->if exp) env)))
     (eval-and (λ (exp env) (app eval (app and->if exp) env)))
     (eval-or (λ (exp env) (app eval (app or->if exp) env)))
     (eval-let (λ (exp env) (app eval (app let->app exp) env)))
     (eval-let* (λ (exp env) (app eval (app let*->let exp) env)))
     (eval-letrec (λ (exp env) (app eval (app letrec->lets+sets exp) env)))
     (eval-begin
      (λ (exp env)
        (let ((simplified (app body->letrec (app begin->body exp))))
          (match
           (app begin? simplified)
           ((#f) (app eval simplified env))
           (_
            (app car (app reverse (app eval* (app begin->body exp) env))))))))
     (eval-set!
      (λ (exp env)
        (app
         env-set!
         env
         (app set!->var exp)
         (app eval (app set!->exp exp) env))))
     (eval-lambda
      (λ (exp env)
        (let ((formals (app lambda->formals exp)))
          (λ args
            (match
             (app symbol? formals)
             ((#f)
              (app
               eval
               (app lambda->body-as-exp exp)
               (app env-extend* env formals args)))
             (_
              (app
               eval
               (app lambda->body-as-exp exp)
               (app env-extend env formals args))))))))
     (eval-macro
      (λ (exp env)
        (app
         cons
         'macro
         (app cons (app eval (app macro->proc exp) env) (app nil)))))
     (env-lookup
      (λ (env var) (let ((value (app env var (app #f) 'unused))) value)))
     (env-set! (λ (env var value) (app env var (app #t) value)))
     (env-extend
      (λ (env var value)
        (λ (seek-var modify? value!)
          (match
           (app eq? var seek-var)
           ((#f) (app env seek-var modify? value!))
           (_ (match modify? ((#f) value) (_ (app set! value value!))))))))
     (env-extend*
      (λ (env vars values)
        (match
         (app pair? vars)
         ((#f) env)
         (_
          (app
           env-extend*
           (app env-extend env (app car vars) (app car values))
           (app cdr vars)
           (app cdr values))))))
     (empty-env
      (λ (var modify? value!)
        (let ((_
               (match
                modify?
                ((#f)
                 (let ((_
                        (app
                         display
                         "error: cannot look up undefined variable: ")))
                   (app display var)))
                (_
                 (let ((_
                        (app
                         display
                         "error: cannot modify undefined variable: ")))
                   (let ((_ (app display var)))
                     (let ((_ (app display " with ")))
                       (app display value!))))))))
          (let ((_ (app newline))) (app error)))))
     (initial-environment-amap
      (app
       cons
       (app cons 'apply (app cons apply (app nil)))
       (app
        cons
        (app cons '+ (app cons + (app nil)))
        (app
         cons
         (app cons 'not (app cons not (app nil)))
         (app
          cons
          (app cons 'display (app cons display (app nil)))
          (app
           cons
           (app cons 'newline (app cons newline (app nil)))
           (app
            cons
            (app cons 'cons (app cons cons (app nil)))
            (app
             cons
             (app cons 'car (app cons car (app nil)))
             (app
              cons
              (app cons 'cdr (app cons cdr (app nil)))
              (app
               cons
               (app cons 'cadr (app cons cadr (app nil)))
               (app
                cons
                (app cons 'caadr (app cons caadr (app nil)))
                (app
                 cons
                 (app cons 'cadar (app cons cadar (app nil)))
                 (app
                  cons
                  (app cons 'cddr (app cons cddr (app nil)))
                  (app
                   cons
                   (app cons 'cdddr (app cons cdddr (app nil)))
                   (app
                    cons
                    (app cons 'null? (app cons null? (app nil)))
                    (app
                     cons
                     (app cons 'pair? (app cons pair? (app nil)))
                     (app
                      cons
                      (app cons 'list? (app cons list? (app nil)))
                      (app
                       cons
                       (app cons 'number? (app cons number? (app nil)))
                       (app
                        cons
                        (app cons 'string? (app cons string? (app nil)))
                        (app
                         cons
                         (app cons 'symbol? (app cons symbol? (app nil)))
                         (app
                          cons
                          (app
                           cons
                           'procedure?
                           (app cons procedure? (app nil)))
                          (app
                           cons
                           (app cons 'eq? (app cons eq? (app nil)))
                           (app
                            cons
                            (app cons '= (app cons = (app nil)))
                            (app
                             cons
                             (app cons 'gensym (app cons gensym (app nil)))
                             (app
                              cons
                              (app cons 'void (app cons void (app nil)))
                              (app
                               cons
                               (app
                                cons
                                'quote
                                (app
                                 cons
                                 (app
                                  cons
                                  'syntax-primitive
                                  (app cons eval-quote (app nil)))
                                 (app nil)))
                               (app
                                cons
                                (app
                                 cons
                                 'if
                                 (app
                                  cons
                                  (app
                                   cons
                                   'syntax-primitive
                                   (app cons eval-if (app nil)))
                                  (app nil)))
                                (app
                                 cons
                                 (app
                                  cons
                                  'cond
                                  (app
                                   cons
                                   (app
                                    cons
                                    'syntax-primitive
                                    (app cons eval-cond (app nil)))
                                   (app nil)))
                                 (app
                                  cons
                                  (app
                                   cons
                                   'and
                                   (app
                                    cons
                                    (app
                                     cons
                                     'syntax-primitive
                                     (app cons eval-and (app nil)))
                                    (app nil)))
                                  (app
                                   cons
                                   (app
                                    cons
                                    'or
                                    (app
                                     cons
                                     (app
                                      cons
                                      'syntax-primitive
                                      (app cons eval-or (app nil)))
                                     (app nil)))
                                   (app
                                    cons
                                    (app
                                     cons
                                     'let
                                     (app
                                      cons
                                      (app
                                       cons
                                       'syntax-primitive
                                       (app cons eval-let (app nil)))
                                      (app nil)))
                                    (app
                                     cons
                                     (app
                                      cons
                                      'let*
                                      (app
                                       cons
                                       (app
                                        cons
                                        'syntax-primitive
                                        (app cons eval-let* (app nil)))
                                       (app nil)))
                                     (app
                                      cons
                                      (app
                                       cons
                                       'letrec
                                       (app
                                        cons
                                        (app
                                         cons
                                         'syntax-primitive
                                         (app cons eval-letrec (app nil)))
                                        (app nil)))
                                      (app
                                       cons
                                       (app
                                        cons
                                        'begin
                                        (app
                                         cons
                                         (app
                                          cons
                                          'syntax-primitive
                                          (app cons eval-begin (app nil)))
                                         (app nil)))
                                       (app
                                        cons
                                        (app
                                         cons
                                         'set!
                                         (app
                                          cons
                                          (app
                                           cons
                                           'syntax-primitive
                                           (app cons eval-set! (app nil)))
                                          (app nil)))
                                        (app
                                         cons
                                         (app
                                          cons
                                          'lambda
                                          (app
                                           cons
                                           (app
                                            cons
                                            'syntax-primitive
                                            (app cons eval-lambda (app nil)))
                                           (app nil)))
                                         (app
                                          cons
                                          (app
                                           cons
                                           'macro
                                           (app
                                            cons
                                            (app
                                             cons
                                             'syntax-primitive
                                             (app cons eval-macro (app nil)))
                                            (app nil)))
                                          (app
                                           nil))))))))))))))))))))))))))))))))))))))
     (initial-environment
      (λ ()
        (app
         unzip-amap-k
         initial-environment-amap
         (λ (symbols values) (app env-extend* empty-env symbols values)))))
     (initial (λ (sym) (app env-lookup (app initial-environment) sym)))
     (three-d (λ (value) (λ () value)))
     (three-d-quote (app three-d (app initial 'quote)))
     (three-d-if (app three-d (app initial 'if)))
     (three-d-cond (app three-d (app initial 'cond)))
     (three-d-and (app three-d (app initial 'and)))
     (three-d-or (app three-d (app initial 'or)))
     (three-d-let (app three-d (app initial 'let)))
     (three-d-let* (app three-d (app initial 'let*)))
     (three-d-letrec (app three-d (app initial 'letrec)))
     (three-d-set! (app three-d (app initial 'set!)))
     (three-d-lambda (app three-d (app initial 'lambda)))
     (three-d-begin (app three-d (app initial 'begin)))
     (perform-apply
      (λ (fun app-exp env)
        (let ((args (app app->args app-exp)))
          (match
           (app macro? fun)
           ((#f)
            (match
             (app syntax-primitive? fun)
             ((#f)
              (let ((arg-values (app eval* args env)))
                (app apply fun arg-values)))
             (_ (app (app syntax-primitive->eval fun) app-exp env))))
           (_ (app eval (app apply (app macro->proc fun) args) env)))))))
    (app
     eval
     (app
      cons
      (app
       cons
       'lambda
       (app cons (app cons 'x (app nil)) (app cons 'x (app nil))))
      (app cons 10 (app nil)))
     (app initial-environment)))))
