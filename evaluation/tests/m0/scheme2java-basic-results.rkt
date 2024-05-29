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
     (caadr (λ (p) (app car (app car (app cdr p)))))
     (caddr (λ (p) (app car (app cdr (app cdr p)))))
     (cadddr (λ (p) (app car (app cdr (app cdr (app cdr p))))))
     (map
      (λ (f lst)
        (match
         (app pair? lst)
         ((#f) (app nil))
         (_ (app cons (app f (app car lst)) (app map f (app cdr lst)))))))
     (append
      (λ (lst1 lst2)
        (match
         (app not (app pair? lst1))
         ((#f) (app cons (app car lst1) (app append (app cdr lst1) lst2)))
         (_ lst2))))
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
     (tagged-list?
      (λ (tag l)
        (match
         (app pair? l)
         ((#f) (app #f))
         (_ (match (app eq? tag (app car l)) ((#f) (app #f)) (_ (app #t)))))))
     (char->natural
      (λ (c)
        (let ((i (app char->integer c)))
          (match (app < i 0) ((#f) (app + (app * 2 i) 1)) (_ (app * -2 i))))))
     (integer->char-list (λ (n) (app string->list (app number->string n))))
     (const? (λ (exp) (app integer? exp)))
     (ref? (λ (exp) (app symbol? exp)))
     (let? (λ (exp) (app tagged-list? 'let exp)))
     (let->bindings (λ (exp) (app cadr exp)))
     (let->exp (λ (exp) (app caddr exp)))
     (letrec1?
      (λ (exp)
        (match
         (app tagged-list? 'letrec exp)
         ((#f) (app #f))
         (_
          (match
           (app = (app length (app cadr exp)) 1)
           ((#f) (app #f))
           (_ (app #t)))))))
     (letrec1->binding (λ (exp) (app caadr exp)))
     (letrec1->exp (λ (exp) (app caddr exp)))
     (lambda? (λ (exp) (app tagged-list? 'lambda exp)))
     (lambda->formals (λ (exp) (app cadr exp)))
     (lambda->exp (λ (exp) (app caddr exp)))
     (if? (λ (exp) (app tagged-list? 'if exp)))
     (if->condition (λ (exp) (app cadr exp)))
     (if->then (λ (exp) (app caddr exp)))
     (if->else (λ (exp) (app cadddr exp)))
     (app? (λ (exp) (app pair? exp)))
     (app->fun (λ (exp) (app car exp)))
     (app->args (λ (exp) (app cdr exp)))
     (prim?
      (λ (exp)
        (match
         (app eq? exp '+)
         ((#f)
          (match
           (app eq? exp '-)
           ((#f)
            (match
             (app eq? exp '*)
             ((#f)
              (match
               (app eq? exp '=)
               ((#f)
                (match (app eq? exp 'display) ((#f) (app #f)) (_ (app #t))))
               (_ (app #t))))
             (_ (app #t))))
           (_ (app #t))))
         (_ (app #t)))))
     (begin? (λ (exp) (app tagged-list? 'begin exp)))
     (begin->exps (λ (exp) (app cdr exp)))
     (set!? (λ (exp) (app tagged-list? 'set! exp)))
     (set!-var (λ (exp) (app cadr exp)))
     (set!-exp (λ (exp) (app caddr exp)))
     (let=>lambda
      (λ (exp)
        (match
         (app let? exp)
         ((#f) exp)
         (_
          (let ((vars (app map car (app let->bindings exp)))
                (args (app map cadr (app let->bindings exp))))
            (app
             cons
             (app
              cons
              (app
               cons
               'lambda
               (app
                cons
                (app append vars (app nil))
                (app cons (app let->exp exp) (app nil))))
              (app append args (app nil)))
             (app nil)))))))
     (arity (λ (lam) (app length (app lambda->formals lam))))
     (xargs
      (λ (n)
        (match
         (app <= n 0)
         ((#f)
          (app
           cons
           (app string->symbol (app string-append "x" (app number->string n)))
           (app xargs (app - n 1))))
         (_ (app nil)))))
     (Yn
      (λ (n)
        (app
         cons
         (app
          cons
          (app
           cons
           'lambda
           (app
            cons
            (app cons 'h (app nil))
            (app
             cons
             (app
              cons
              'lambda
              (app
               cons
               (app cons 'F (app nil))
               (app
                cons
                (app
                 cons
                 'F
                 (app
                  cons
                  (app
                   cons
                   'lambda
                   (app
                    cons
                    (app append (app xargs n) (app nil))
                    (app
                     cons
                     (app
                      cons
                      (app
                       cons
                       (app cons 'h (app cons 'h (app nil)))
                       (app cons 'F (app nil)))
                      (app append (app xargs n) (app nil)))
                     (app nil))))
                  (app nil)))
                (app nil))))
             (app nil))))
          (app
           cons
           (app
            cons
            'lambda
            (app
             cons
             (app cons 'h (app nil))
             (app
              cons
              (app
               cons
               'lambda
               (app
                cons
                (app cons 'F (app nil))
                (app
                 cons
                 (app
                  cons
                  'F
                  (app
                   cons
                   (app
                    cons
                    'lambda
                    (app
                     cons
                     (app append (app xargs n) (app nil))
                     (app
                      cons
                      (app
                       cons
                       (app
                        cons
                        (app cons 'h (app cons 'h (app nil)))
                        (app cons 'F (app nil)))
                       (app append (app xargs n) (app nil)))
                      (app nil))))
                   (app nil)))
                 (app nil))))
              (app nil))))
           (app nil)))
         (app nil))))
     (letrec1=>Y
      (λ (exp)
        (match
         (app letrec1? exp)
         ((#f) exp)
         (_
          (let* ((binding (app letrec1->binding exp))
                 (name (app car binding))
                 (arg (app cadr binding))
                 (num-args (app arity arg)))
            (app
             cons
             (app
              cons
              'let
              (app
               cons
               (app
                cons
                (app
                 cons
                 name
                 (app
                  cons
                  (app
                   cons
                   (app Yn num-args)
                   (app
                    cons
                    (app
                     cons
                     'lambda
                     (app
                      cons
                      (app cons name (app nil))
                      (app cons arg (app nil))))
                    (app nil)))
                  (app nil)))
                (app nil))
               (app cons (app letrec1->exp exp) (app nil))))
             (app nil)))))))
     (begin=>let
      (λ (exp)
        (letrec*
         ((singlet?
           (λ (l)
             (match
              (app list? l)
              ((#f) (app #f))
              (_
               (match
                (app = (app length l) 1)
                ((#f) (app #f))
                (_ (app #t)))))))
          (dummy-bind
           (λ (exps)
             (match
              (app singlet? exps)
              ((#f)
               (match
                (app pair? exps)
                ((#f) (app error "no-match"))
                (_
                 (app
                  cons
                  (app
                   cons
                   'let
                   (app
                    cons
                    (app
                     cons
                     (app cons '$_ (app cons (app car exps) (app nil)))
                     (app nil))
                    (app cons (app dummy-bind (app cdr exps)) (app nil))))
                  (app nil)))))
              (_ (app car exps))))))
         (app dummy-bind (app begin->exps exp)))))
     (mutable-variables (app nil))
     (mark-mutable
      (λ (symbol)
        (app set! mutable-variables (app cons symbol mutable-variables))))
     (is-mutable?
      (λ (symbol)
        (letrec*
         ((is-in?
           (λ (S)
             (match
              (app not (app pair? S))
              ((#f)
               (match
                (app eq? (app car S) symbol)
                ((#f) (app is-in? (app cdr S)))
                (_ (app #t))))
              (_ (app #f))))))
         (app is-in? mutable-variables))))
     (analyze-mutable-variables
      (λ (exp)
        (match
         (app const? exp)
         ((#f)
          (match
           (app ref? exp)
           ((#f)
            (match
             (app prim? exp)
             ((#f)
              (match
               (app lambda? exp)
               ((#f)
                (match
                 (app let? exp)
                 ((#f)
                  (match
                   (app letrec1? exp)
                   ((#f)
                    (match
                     (app set!? exp)
                     ((#f)
                      (match
                       (app if? exp)
                       ((#f)
                        (match
                         (app begin? exp)
                         ((#f)
                          (match
                           (app app? exp)
                           ((#f) (app error "unknown expression type: " exp))
                           (_
                            (let ((_ (app map analyze-mutable-variables exp)))
                              (app void)))))
                         (_
                          (let ((_
                                 (app
                                  map
                                  analyze-mutable-variables
                                  (app begin->exps exp))))
                            (app void)))))
                       (_
                        (let ((_
                               (app
                                analyze-mutable-variables
                                (app if->condition exp))))
                          (let ((_
                                 (app
                                  analyze-mutable-variables
                                  (app if->then exp))))
                            (app
                             analyze-mutable-variables
                             (app if->else exp)))))))
                     (_ (app mark-mutable (app set!-var exp)))))
                   (_
                    (let ((_
                           (app
                            analyze-mutable-variables
                            (app cadr (app letrec1->binding exp)))))
                      (app
                       analyze-mutable-variables
                       (app letrec1->exp exp))))))
                 (_
                  (let ((_
                         (app
                          map
                          analyze-mutable-variables
                          (app map cadr (app let->bindings exp)))))
                    (app analyze-mutable-variables (app let->exp exp))))))
               (_ (app analyze-mutable-variables (app lambda->exp exp)))))
             (_ (app void))))
           (_ (app void))))
         (_ (app void)))))
     (mangle
      (λ (symbol)
        (letrec*
         ((m
           (λ (chars)
             (match
              (app null? chars)
              ((#f)
               (match
                (match
                 (match
                  (app char-alphabetic? (app car chars))
                  ((#f) (app #f))
                  (_
                   (match
                    (app not (app char=? (app car chars) #\_))
                    ((#f) (app #f))
                    (_ (app #t)))))
                 ((#f)
                  (match
                   (app char-numeric? (app car chars))
                   ((#f) (app #f))
                   (_ (app #t))))
                 (_ (app #t)))
                ((#f)
                 (app
                  cons
                  #\_
                  (app
                   append
                   (app integer->char-list (app char->natural (app car chars)))
                   (app m (app cdr chars)))))
                (_ (app cons (app car chars) (app m (app cdr chars))))))
              (_ (app nil))))))
         (app
          list->string
          (app m (app string->list (app symbol->string symbol)))))))
     (java-compile-program
      (λ (exp)
        (app
         string-append
         "public class BOut extends RuntimeEnvironment {\n"
         " public static void main (String[] args) {\n"
         (app java-compile-exp exp)
         " ;\n"
         " }\n"
         "}\n")))
     (java-compile-exp
      (λ (exp)
        (match
         (app const? exp)
         ((#f)
          (match
           (app prim? exp)
           ((#f)
            (match
             (app ref? exp)
             ((#f)
              (match
               (app lambda? exp)
               ((#f)
                (match
                 (app if? exp)
                 ((#f)
                  (match
                   (app set!? exp)
                   ((#f)
                    (match
                     (app let? exp)
                     ((#f)
                      (match
                       (app letrec1? exp)
                       ((#f)
                        (match
                         (app begin? exp)
                         ((#f)
                          (match
                           (app app? exp)
                           ((#f) (app error "no-match"))
                           (_ (app java-compile-app exp))))
                         (_ (app java-compile-exp (app begin=>let exp)))))
                       (_ (app java-compile-exp (app letrec1=>Y exp)))))
                     (_ (app java-compile-exp (app let=>lambda exp)))))
                   (_ (app java-compile-set! exp))))
                 (_ (app java-compile-if exp))))
               (_ (app java-compile-lambda exp))))
             (_ (app java-compile-ref exp))))
           (_ (app java-compile-prim exp))))
         (_ (app java-compile-const exp)))))
     (java-compile-const
      (λ (exp)
        (match
         (app integer? exp)
         ((#f) (app error "unknown constant: " exp))
         (_
          (app string-append "new IntValue(" (app number->string exp) ")")))))
     (java-compile-prim
      (λ (p)
        (match
         (app eq? '+ p)
         ((#f)
          (match
           (app eq? '- p)
           ((#f)
            (match
             (app eq? '* p)
             ((#f)
              (match
               (app eq? '= p)
               ((#f)
                (match
                 (app eq? 'display p)
                 ((#f) (app error "unhandled primitive " p))
                 (_ "display")))
               (_ "numEqual")))
             (_ "product")))
           (_ "difference")))
         (_ "sum"))))
     (java-compile-ref
      (λ (exp)
        (match
         (app is-mutable? exp)
         ((#f) (app mangle exp))
         (_ (app string-append "m_" (app mangle exp) ".value")))))
     (java-compile-formals
      (λ (formals)
        (match
         (app not (app pair? formals))
         ((#f)
          (app
           string-append
           "final Value "
           (app mangle (app car formals))
           (match
            (app pair? (app cdr formals))
            ((#f) "")
            (_
             (app
              string-append
              ", "
              (app java-compile-formals (app cdr formals)))))))
         (_ ""))))
     (java-compile-lambda
      (λ (exp)
        (letrec*
         ((java-wrap-mutables
           (λ (vars)
             (match
              (app not (app pair? vars))
              ((#f)
               (app
                string-append
                (match
                 (app is-mutable? (app car vars))
                 ((#f) "")
                 (_
                  (app
                   string-append
                   " final ValueCell m_"
                   (app mangle (app car vars))
                   " = new ValueCell("
                   (app mangle (app car vars))
                   ");\n")))
                (app java-wrap-mutables (app cdr vars))))
              (_ "")))))
         (let* ((formals (app lambda->formals exp))
                (num-args (app length formals)))
           (app
            string-append
            "new NullProcValue"
            (app number->string num-args)
            " () {\n"
            " public Value apply("
            (app java-compile-formals formals)
            ") {\n"
            (app java-wrap-mutables formals)
            "\n"
            "  return "
            (app java-compile-exp (app lambda->exp exp))
            " ;\n"
            "}}\n")))))
     (java-compile-args
      (λ (args)
        (match
         (app not (app pair? args))
         ((#f)
          (app
           string-append
           (app java-compile-exp (app car args))
           (match
            (app pair? (app cdr args))
            ((#f) "")
            (_
             (app
              string-append
              ", "
              (app java-compile-args (app cdr args)))))))
         (_ ""))))
     (java-compile-set!
      (λ (exp)
        (app
         string-append
         "VoidValue.Void(m_"
         (app mangle (app set!-var exp))
         ".value = "
         (app java-compile-exp (app set!-exp exp))
         ")")))
     (java-compile-app
      (λ (exp)
        (let* ((args (app app->args exp))
               (fun (app app->fun exp))
               (num-args (app length args)))
          (app
           string-append
           "((ProcValue"
           (app number->string num-args)
           ")("
           (app java-compile-exp fun)
           ")).apply("
           (app java-compile-args args)
           ")\n"))))
     (java-compile-if
      (λ (exp)
        (app
         string-append
         "("
         (app java-compile-exp (app if->condition exp))
         ").toBoolean() ? ("
         (app java-compile-exp (app if->then exp))
         ") : ("
         (app java-compile-exp (app if->else exp))
         ")")))
     (input-program
      (app
       cons
       (app
        cons
        'lambda
        (app
         cons
         (app cons 'x (app nil))
         (app
          cons
          (app
           cons
           'let
           (app
            cons
            (app
             cons
             (app
              cons
              'z
              (app
               cons
               (app cons '+ (app cons 3 (app cons 'x (app nil))))
               (app nil)))
             (app nil))
            (app
             cons
             (app cons '+ (app cons 3 (app cons 'x (app cons 'z (app nil)))))
             (app nil))))
          (app cons 10 (app nil)))))
       (app nil))))
    (let ((_ (app analyze-mutable-variables input-program)))
      (app display (app java-compile-program input-program))))))

'(query: ((top) lettypes (cons ... error) ...) (env ()))
