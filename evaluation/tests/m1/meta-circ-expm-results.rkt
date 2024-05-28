'(expression:
  (lettypes
   ((cons car cdr) (nil) (error r))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
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

'(query:
  (app
   cons
   (-> (app cons 'apply (app cons apply (app nil))) <-)
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
                      (app cons 'procedure? (app cons procedure? (app nil)))
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
                                       nil)))))))))))))))))))))))))))))))))))))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    empty-env
    (initial-environment-amap
     (->
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
                                           nil)))))))))))))))))))))))))))))))))))))
      <-))
    initial-environment
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes cons ... error (letrec* (car ... perform-apply) ...))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query: (app cons 'apply (-> (app cons apply (app nil)) <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(store:
  and->exps
  (letrec* (... and? (and->exps (-> (λ (s-exp) ...) <-)) make-and ...) ...)
  (env ()))
clos/con:
	'((letrec* (... and? (and->exps (-> (λ (s-exp) ...) <-)) make-and ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  and->if
  (letrec*
   (... cond-clauses->if (and->if (-> (λ (exp) ...) <-)) or->if ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cond-clauses->if (and->if (-> (λ (exp) ...) <-)) or->if ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  and?
  (letrec* (... make-or (and? (-> (λ (s-exp) ...) <-)) and->exps ...) ...)
  (env ()))
clos/con:
	'((letrec* (... make-or (and? (-> (λ (s-exp) ...) <-)) and->exps ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app->args
  (letrec*
   (... app->fun (app->args (-> (λ (s-exp) ...) <-)) binding->var ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... app->fun (app->args (-> (λ (s-exp) ...) <-)) binding->var ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app->fun
  (letrec* (... app? (app->fun (-> (λ (s-exp) ...) <-)) app->args ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app? (app->fun (-> (λ (s-exp) ...) <-)) app->args ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app?
  (letrec* (... make-begin (app? (-> (λ (s-exp) ...) <-)) app->fun ...) ...)
  (env ()))
clos/con:
	'((letrec* (... make-begin (app? (-> (λ (s-exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... for-each (append (-> (λ (lst1 lst2) ...) <-)) reverse ...) ...)
  (env ()))
clos/con:
	'((letrec* (... for-each (append (-> (λ (lst1 lst2) ...) <-)) reverse ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  apply
  (letrec*
   (...
    empty-env
    (initial-environment-amap
     (->
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
                                           nil)))))))))))))))))))))))))))))))))))))
      <-))
    initial-environment
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(store:
  apply
  (letrec* (... string->list (apply (-> (λ (f l) ...) <-)) assv ...) ...)
  (env ()))
clos/con:
	'((letrec* (... string->list (apply (-> (λ (f l) ...) <-)) assv ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  arrow-clause?
  (letrec*
   (...
    cond->clauses
    (arrow-clause? (-> (λ (clause) ...) <-))
    else-clause?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    cond->clauses
    (arrow-clause? (-> (λ (clause) ...) <-))
    else-clause?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  assq
  (letrec* (... assv (assq (-> (λ (x f) ...) <-)) gensym-count ...) ...)
  (env ()))
clos/con:
	'((letrec* (... assv (assq (-> (λ (x f) ...) <-)) gensym-count ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  assv
  (letrec* (... apply (assv (-> (λ (x f) ...) <-)) assq ...) ...)
  (env ()))
clos/con:
	'((letrec* (... apply (assv (-> (λ (x f) ...) <-)) assq ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin->body
  (letrec*
   (... begin? (begin->body (-> (λ (s-exp) ...) <-)) make-begin ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... begin? (begin->body (-> (λ (s-exp) ...) <-)) make-begin ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin?
  (letrec*
   (... lambda->body-as-exp (begin? (-> (λ (s-exp) ...) <-)) begin->body ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda->body-as-exp (begin? (-> (λ (s-exp) ...) <-)) begin->body ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  binding->exp
  (letrec*
   (... binding->var (binding->exp (-> (λ (binding) ...) <-)) letrec? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... binding->var (binding->exp (-> (λ (binding) ...) <-)) letrec? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  binding->var
  (letrec*
   (... app->args (binding->var (-> (λ (binding) ...) <-)) binding->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... app->args (binding->var (-> (λ (binding) ...) <-)) binding->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  body->letrec
  (letrec*
   (...
    def->binding
    (body->letrec (-> (λ (decs) ...) <-))
    letrec->lets+sets
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    def->binding
    (body->letrec (-> (λ (decs) ...) <-))
    letrec->lets+sets
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caadr
  (letrec* (... cdddr (caadr (-> (λ (p) ...) <-)) cdadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdddr (caadr (-> (λ (p) ...) <-)) cdadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadar
  (letrec* (... caddr (cadar (-> (λ (p) ...) <-)) cadddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (cadar (-> (λ (p) ...) <-)) cadddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadddr
  (letrec* (... cadar (cadddr (-> (λ (p) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadar (cadddr (-> (λ (p) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cdadr (caddr (-> (λ (p) ...) <-)) cadar ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdadr (caddr (-> (λ (p) ...) <-)) cadar ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdadr
  (letrec* (... caadr (cdadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caadr (cdadr (-> (λ (p) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdddr
  (letrec* (... cddr (cdddr (-> (λ (p) ...) <-)) caadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cddr (cdddr (-> (λ (p) ...) <-)) caadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cddr
  (letrec* (... cadr (cddr (-> (λ (p) ...) <-)) cdddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (cddr (-> (λ (p) ...) <-)) cdddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) length ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) length ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cond->clauses
  (letrec*
   (... cond? (cond->clauses (-> (λ (s-exp) ...) <-)) arrow-clause? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cond? (cond->clauses (-> (λ (s-exp) ...) <-)) arrow-clause? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cond->if
  (letrec*
   (...
    letrec->lets+sets
    (cond->if (-> (λ (cond-exp) ...) <-))
    cond-clauses->if
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    letrec->lets+sets
    (cond->if (-> (λ (cond-exp) ...) <-))
    cond-clauses->if
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cond-clause->exp
  (letrec*
   (...
    else-clause?
    (cond-clause->exp (-> (λ (clause) ...) <-))
    cond-clause->test
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    else-clause?
    (cond-clause->exp (-> (λ (clause) ...) <-))
    cond-clause->test
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cond-clause->test
  (letrec*
   (...
    cond-clause->exp
    (cond-clause->test (-> (λ (clause) ...) <-))
    set!?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    cond-clause->exp
    (cond-clause->test (-> (λ (clause) ...) <-))
    set!?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cond-clauses->if
  (letrec*
   (... cond->if (cond-clauses->if (-> (λ (clauses) ...) <-)) and->if ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cond->if (cond-clauses->if (-> (λ (clauses) ...) <-)) and->if ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cond?
  (letrec*
   (... make-and (cond? (-> (λ (s-exp) ...) <-)) cond->clauses ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... make-and (cond? (-> (λ (s-exp) ...) <-)) cond->clauses ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  def->binding
  (letrec*
   (...
    syntax-primitive->eval
    (def->binding (-> (λ (def) ...) <-))
    body->letrec
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    syntax-primitive->eval
    (def->binding (-> (λ (def) ...) <-))
    body->letrec
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  define->exp
  (letrec* (... define->var (define->exp (-> (λ (s-exp) ...) <-)) if? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... define->var (define->exp (-> (λ (s-exp) ...) <-)) if? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  define->var
  (letrec*
   (... define-fun? (define->var (-> (λ (s-exp) ...) <-)) define->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... define-fun? (define->var (-> (λ (s-exp) ...) <-)) define->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  define-fun?
  (letrec*
   (... define-var? (define-fun? (-> (λ (s-exp) ...) <-)) define->var ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... define-var? (define-fun? (-> (λ (s-exp) ...) <-)) define->var ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  define-var?
  (letrec*
   (... define? (define-var? (-> (λ (s-exp) ...) <-)) define-fun? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... define? (define-var? (-> (λ (s-exp) ...) <-)) define-fun? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  define?
  (letrec*
   (... unzip-amap-k (define? (-> (λ (s-exp) ...) <-)) define-var? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... unzip-amap-k (define? (-> (λ (s-exp) ...) <-)) define-var? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  else-clause?
  (letrec*
   (...
    arrow-clause?
    (else-clause? (-> (λ (clause) ...) <-))
    cond-clause->exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    arrow-clause?
    (else-clause? (-> (λ (clause) ...) <-))
    cond-clause->exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  empty-env
  (letrec*
   (...
    env-extend*
    (empty-env (-> (λ (var modify? value!) ...) <-))
    initial-environment-amap
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    env-extend*
    (empty-env (-> (λ (var modify? value!) ...) <-))
    initial-environment-amap
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-extend
  (letrec*
   (... env-set! (env-extend (-> (λ (env var value) ...) <-)) env-extend* ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-set! (env-extend (-> (λ (env var value) ...) <-)) env-extend* ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-extend*
  (letrec*
   (...
    env-extend
    (env-extend* (-> (λ (env vars values) ...) <-))
    empty-env
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    env-extend
    (env-extend* (-> (λ (env vars values) ...) <-))
    empty-env
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-lookup
  (letrec*
   (... eval-macro (env-lookup (-> (λ (env var) ...) <-)) env-set! ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-macro (env-lookup (-> (λ (env var) ...) <-)) env-set! ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-set!
  (letrec*
   (... env-lookup (env-set! (-> (λ (env var value) ...) <-)) env-extend ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-lookup (env-set! (-> (λ (env var value) ...) <-)) env-extend ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval
  (letrec* (... let->app (eval (-> (λ (exp env) ...) <-)) eval-with ...) ...)
  (env ()))
clos/con:
	'((letrec* (... let->app (eval (-> (λ (exp env) ...) <-)) eval-with ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval*
  (letrec*
   (... eval-with (eval* (-> (λ (exps env) ...) <-)) eval-quote ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-with (eval* (-> (λ (exps env) ...) <-)) eval-quote ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-and
  (letrec*
   (... eval-cond (eval-and (-> (λ (exp env) ...) <-)) eval-or ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-cond (eval-and (-> (λ (exp env) ...) <-)) eval-or ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-begin
  (letrec*
   (... eval-letrec (eval-begin (-> (λ (exp env) ...) <-)) eval-set! ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-letrec (eval-begin (-> (λ (exp env) ...) <-)) eval-set! ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-cond
  (letrec*
   (... eval-if (eval-cond (-> (λ (exp env) ...) <-)) eval-and ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-if (eval-cond (-> (λ (exp env) ...) <-)) eval-and ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-if
  (letrec*
   (... eval-quote (eval-if (-> (λ (exp env) ...) <-)) eval-cond ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-quote (eval-if (-> (λ (exp env) ...) <-)) eval-cond ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-lambda
  (letrec*
   (... eval-set! (eval-lambda (-> (λ (exp env) ...) <-)) eval-macro ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-set! (eval-lambda (-> (λ (exp env) ...) <-)) eval-macro ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-let
  (letrec*
   (... eval-or (eval-let (-> (λ (exp env) ...) <-)) eval-let* ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-or (eval-let (-> (λ (exp env) ...) <-)) eval-let* ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-let*
  (letrec*
   (... eval-let (eval-let* (-> (λ (exp env) ...) <-)) eval-letrec ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-let (eval-let* (-> (λ (exp env) ...) <-)) eval-letrec ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-letrec
  (letrec*
   (... eval-let* (eval-letrec (-> (λ (exp env) ...) <-)) eval-begin ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-let* (eval-letrec (-> (λ (exp env) ...) <-)) eval-begin ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-macro
  (letrec*
   (... eval-lambda (eval-macro (-> (λ (exp env) ...) <-)) env-lookup ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-lambda (eval-macro (-> (λ (exp env) ...) <-)) env-lookup ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-or
  (letrec* (... eval-and (eval-or (-> (λ (exp env) ...) <-)) eval-let ...) ...)
  (env ()))
clos/con:
	'((letrec* (... eval-and (eval-or (-> (λ (exp env) ...) <-)) eval-let ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-quote
  (letrec* (... eval* (eval-quote (-> (λ (exp env) ...) <-)) eval-if ...) ...)
  (env ()))
clos/con:
	'((letrec* (... eval* (eval-quote (-> (λ (exp env) ...) <-)) eval-if ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-set!
  (letrec*
   (... eval-begin (eval-set! (-> (λ (exp env) ...) <-)) eval-lambda ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... eval-begin (eval-set! (-> (λ (exp env) ...) <-)) eval-lambda ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  eval-with
  (letrec* (... eval (eval-with (-> (λ (env) ...) <-)) eval* ...) ...)
  (env ()))
clos/con:
	'((letrec* (... eval (eval-with (-> (λ (env) ...) <-)) eval* ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  for-each
  (letrec* (... map (for-each (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (for-each (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  gensym
  (letrec*
   (... gensym-count (gensym (-> (λ (name) ...) <-)) three-d-tagged-list? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... gensym-count (gensym (-> (λ (name) ...) <-)) three-d-tagged-list? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  gensym-count
  (letrec* (... assq (gensym-count (-> 0 <-)) gensym ...) ...)
  (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store:
  if->cond
  (letrec*
   (... if-single? (if->cond (-> (λ (s-exp) ...) <-)) if->true ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... if-single? (if->cond (-> (λ (s-exp) ...) <-)) if->true ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->false
  (letrec* (... if->true (if->false (-> (λ (s-exp) ...) <-)) quote? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->true (if->false (-> (λ (s-exp) ...) <-)) quote? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->true
  (letrec* (... if->cond (if->true (-> (λ (s-exp) ...) <-)) if->false ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->cond (if->true (-> (λ (s-exp) ...) <-)) if->false ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if-single?
  (letrec* (... if? (if-single? (-> (λ (s-exp) ...) <-)) if->cond ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if? (if-single? (-> (λ (s-exp) ...) <-)) if->cond ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if?
  (letrec* (... define->exp (if? (-> (λ (s-exp) ...) <-)) if-single? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... define->exp (if? (-> (λ (s-exp) ...) <-)) if-single? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->body
  (letrec*
   (...
    lambda->formals
    (lambda->body (-> (λ (s-exp) ...) <-))
    lambda->body-as-exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    lambda->formals
    (lambda->body (-> (λ (s-exp) ...) <-))
    lambda->body-as-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->body-as-exp
  (letrec*
   (... lambda->body (lambda->body-as-exp (-> (λ (s-exp) ...) <-)) begin? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda->body (lambda->body-as-exp (-> (λ (s-exp) ...) <-)) begin? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->formals
  (letrec*
   (...
    lambda-multi?
    (lambda->formals (-> (λ (s-exp) ...) <-))
    lambda->body
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    lambda-multi?
    (lambda->formals (-> (λ (s-exp) ...) <-))
    lambda->body
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda-multi?
  (letrec*
   (... lambda? (lambda-multi? (-> (λ (s-exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda? (lambda-multi? (-> (λ (s-exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda?
  (letrec*
   (... quote->text (lambda? (-> (λ (s-exp) ...) <-)) lambda-multi? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... quote->text (lambda? (-> (λ (s-exp) ...) <-)) lambda-multi? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  length
  (letrec* (... cdr (length (-> (λ (length-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (length (-> (λ (length-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let*->bindings
  (letrec*
   (... let*? (let*->bindings (-> (λ (s-exp) ...) <-)) let*->body ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let*? (let*->bindings (-> (λ (s-exp) ...) <-)) let*->body ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let*->body
  (letrec*
   (...
    let*->bindings
    (let*->body (-> (λ (s-exp) ...) <-))
    let*->body-as-exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    let*->bindings
    (let*->body (-> (λ (s-exp) ...) <-))
    let*->body-as-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let*->body-as-exp
  (letrec*
   (... let*->body (let*->body-as-exp (-> (λ (s-exp) ...) <-)) or? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let*->body (let*->body-as-exp (-> (λ (s-exp) ...) <-)) or? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let*->let
  (letrec*
   (... or->if (let*->let (-> (λ (exp) ...) <-)) let*-bindings->let ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... or->if (let*->let (-> (λ (exp) ...) <-)) let*-bindings->let ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let*-bindings->let
  (letrec*
   (...
    let*->let
    (let*-bindings->let (-> (λ (bindings body) ...) <-))
    let->app
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    let*->let
    (let*-bindings->let (-> (λ (bindings body) ...) <-))
    let->app
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let*?
  (letrec*
   (... let->body-as-exp (let*? (-> (λ (s-exp) ...) <-)) let*->bindings ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->body-as-exp (let*? (-> (λ (s-exp) ...) <-)) let*->bindings ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let->app
  (letrec*
   (... let*-bindings->let (let->app (-> (λ (exp) ...) <-)) eval ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let*-bindings->let (let->app (-> (λ (exp) ...) <-)) eval ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let->bindings
  (letrec*
   (... let? (let->bindings (-> (λ (s-exp) ...) <-)) let->body ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let? (let->bindings (-> (λ (s-exp) ...) <-)) let->body ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let->body
  (letrec*
   (... let->bindings (let->body (-> (λ (s-exp) ...) <-)) let->body-as-exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->bindings (let->body (-> (λ (s-exp) ...) <-)) let->body-as-exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let->body-as-exp
  (letrec*
   (... let->body (let->body-as-exp (-> (λ (s-exp) ...) <-)) let*? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->body (let->body-as-exp (-> (λ (s-exp) ...) <-)) let*? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let?
  (letrec*
   (... letrec->body-as-exp (let? (-> (λ (s-exp) ...) <-)) let->bindings ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec->body-as-exp (let? (-> (λ (s-exp) ...) <-)) let->bindings ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec->bindings
  (letrec*
   (... letrec? (letrec->bindings (-> (λ (s-exp) ...) <-)) letrec->body ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec? (letrec->bindings (-> (λ (s-exp) ...) <-)) letrec->body ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec->body
  (letrec*
   (...
    letrec->bindings
    (letrec->body (-> (λ (s-exp) ...) <-))
    letrec->body-as-exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    letrec->bindings
    (letrec->body (-> (λ (s-exp) ...) <-))
    letrec->body-as-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec->body-as-exp
  (letrec*
   (... letrec->body (letrec->body-as-exp (-> (λ (s-exp) ...) <-)) let? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec->body (letrec->body-as-exp (-> (λ (s-exp) ...) <-)) let? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec->lets+sets
  (letrec*
   (... body->letrec (letrec->lets+sets (-> (λ (exp) ...) <-)) cond->if ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... body->letrec (letrec->lets+sets (-> (λ (exp) ...) <-)) cond->if ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec?
  (letrec*
   (... binding->exp (letrec? (-> (λ (s-exp) ...) <-)) letrec->bindings ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... binding->exp (letrec? (-> (λ (s-exp) ...) <-)) letrec->bindings ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  macro->proc
  (letrec*
   (... macro? (macro->proc (-> (λ (s-exp) ...) <-)) syntax-primitive? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... macro? (macro->proc (-> (λ (s-exp) ...) <-)) syntax-primitive? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  macro?
  (letrec*
   (... set!->exp (macro? (-> (λ (s-exp) ...) <-)) macro->proc ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... set!->exp (macro? (-> (λ (s-exp) ...) <-)) macro->proc ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  make-and
  (letrec* (... and->exps (make-and (-> (λ (exps) ...) <-)) cond? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... and->exps (make-and (-> (λ (exps) ...) <-)) cond? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  make-begin
  (letrec* (... begin->body (make-begin (-> (λ (exps) ...) <-)) app? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin->body (make-begin (-> (λ (exps) ...) <-)) app? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  make-or
  (letrec* (... or->exps (make-or (-> (λ (exps) ...) <-)) and? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... or->exps (make-or (-> (λ (exps) ...) <-)) and? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) for-each ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) for-each ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  null?
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or->exps
  (letrec* (... or? (or->exps (-> (λ (s-exp) ...) <-)) make-or ...) ...)
  (env ()))
clos/con:
	'((letrec* (... or? (or->exps (-> (λ (s-exp) ...) <-)) make-or ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or->if
  (letrec* (... and->if (or->if (-> (λ (exp) ...) <-)) let*->let ...) ...)
  (env ()))
clos/con:
	'((letrec* (... and->if (or->if (-> (λ (exp) ...) <-)) let*->let ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or?
  (letrec*
   (... let*->body-as-exp (or? (-> (λ (s-exp) ...) <-)) or->exps ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let*->body-as-exp (or? (-> (λ (s-exp) ...) <-)) or->exps ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  pair?
  (letrec* (... length (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... length (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  partition-k
  (letrec*
   (... singlet? (partition-k (-> (λ (pred list k) ...) <-)) unzip-amap-k ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... singlet? (partition-k (-> (λ (pred list k) ...) <-)) unzip-amap-k ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  quote->text
  (letrec* (... quote? (quote->text (-> (λ (s-exp) ...) <-)) lambda? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... quote? (quote->text (-> (λ (s-exp) ...) <-)) lambda? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  quote?
  (letrec*
   (... if->false (quote? (-> (λ (s-exp) ...) <-)) quote->text ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... if->false (quote? (-> (λ (s-exp) ...) <-)) quote->text ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  reverse
  (letrec* (... append (reverse (-> (λ (lst) ...) <-)) string->list ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (reverse (-> (λ (lst) ...) <-)) string->list ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!->exp
  (letrec* (... set!->var (set!->exp (-> (λ (s-exp) ...) <-)) macro? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!->var (set!->exp (-> (λ (s-exp) ...) <-)) macro? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!->var
  (letrec* (... set!? (set!->var (-> (λ (s-exp) ...) <-)) set!->exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!? (set!->var (-> (λ (s-exp) ...) <-)) set!->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!?
  (letrec*
   (... cond-clause->test (set!? (-> (λ (s-exp) ...) <-)) set!->var ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cond-clause->test (set!? (-> (λ (s-exp) ...) <-)) set!->var ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  singlet?
  (letrec*
   (... tagged-list? (singlet? (-> (λ (list) ...) <-)) partition-k ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... tagged-list? (singlet? (-> (λ (list) ...) <-)) partition-k ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  string->list
  (letrec* (... reverse (string->list (-> (λ (s) ...) <-)) apply ...) ...)
  (env ()))
clos/con:
	'((letrec* (... reverse (string->list (-> (λ (s) ...) <-)) apply ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  syntax-primitive->eval
  (letrec*
   (...
    syntax-primitive?
    (syntax-primitive->eval (-> (λ (value) ...) <-))
    def->binding
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    syntax-primitive?
    (syntax-primitive->eval (-> (λ (value) ...) <-))
    def->binding
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  syntax-primitive?
  (letrec*
   (...
    macro->proc
    (syntax-primitive? (-> (λ (value) ...) <-))
    syntax-primitive->eval
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    macro->proc
    (syntax-primitive? (-> (λ (value) ...) <-))
    syntax-primitive->eval
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tagged-list?
  (letrec*
   (...
    three-d-tagged-list?
    (tagged-list? (-> (λ (tag lst) ...) <-))
    singlet?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    three-d-tagged-list?
    (tagged-list? (-> (λ (tag lst) ...) <-))
    singlet?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  three-d-tagged-list?
  (letrec*
   (...
    gensym
    (three-d-tagged-list? (-> (λ (tag lst) ...) <-))
    tagged-list?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    gensym
    (three-d-tagged-list? (-> (λ (tag lst) ...) <-))
    tagged-list?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  unzip-amap-k
  (letrec*
   (... partition-k (unzip-amap-k (-> (λ (amap k) ...) <-)) define? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... partition-k (unzip-amap-k (-> (λ (amap k) ...) <-)) define? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
