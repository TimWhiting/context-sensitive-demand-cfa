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
     (void (λ () (match (app #f) ((#f) (app void)) (_ (app #t)))))
     (tagged-list?
      (λ (tag l) (app and (app pair? l) (app eq? tag (app car l)))))
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
        (app
         and
         (app tagged-list? 'letrec exp)
         (app = (app length (app cadr exp)) 1))))
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
        (app
         or
         (app eq? exp '+)
         (app eq? exp '-)
         (app eq? exp '*)
         (app eq? exp '=)
         (app eq? exp 'display))))
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
         ((singlet? (λ (l) (app and (app list? l) (app = (app length l) 1))))
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
                (app
                 or
                 (app
                  and
                  (app char-alphabetic? (app car chars))
                  (app not (app char=? (app car chars) #\_)))
                 (app char-numeric? (app car chars)))
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
     (input-program 3))
    (let ((_ (app analyze-mutable-variables input-program)))
      (app display (app java-compile-program input-program))))))

'(query:
  (app
   (-> string-append <-)
   "public class BOut extends RuntimeEnvironment {\n"
   " public static void main (String[] args) {\n"
   (app java-compile-exp exp)
   " ;\n"
   " }\n"
   "}\n")
  (env (())))
clos/con:
	'((prim string-append) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   string-append
   "public class BOut extends RuntimeEnvironment {\n"
   " public static void main (String[] args) {\n"
   (-> (app java-compile-exp exp) <-)
   " ;\n"
   " }\n"
   "}\n")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query:
  (app
   string-append
   "public class BOut extends RuntimeEnvironment {\n"
   " public static void main (String[] args) {\n"
   (app java-compile-exp exp)
   " ;\n"
   " }\n"
   (-> "}\n" <-))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ "}\n")

'(query:
  (app
   string-append
   "public class BOut extends RuntimeEnvironment {\n"
   " public static void main (String[] args) {\n"
   (app java-compile-exp exp)
   " ;\n"
   (-> " }\n" <-)
   "}\n")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ " }\n")

'(query:
  (app
   string-append
   "public class BOut extends RuntimeEnvironment {\n"
   " public static void main (String[] args) {\n"
   (app java-compile-exp exp)
   (-> " ;\n" <-)
   " }\n"
   "}\n")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ " ;\n")

'(query:
  (app
   string-append
   "public class BOut extends RuntimeEnvironment {\n"
   (-> " public static void main (String[] args) {\n" <-)
   (app java-compile-exp exp)
   " ;\n"
   " }\n"
   "}\n")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ " public static void main (String[] args) {\n")

'(query:
  (app
   string-append
   (-> "public class BOut extends RuntimeEnvironment {\n" <-)
   " public static void main (String[] args) {\n"
   (app java-compile-exp exp)
   " ;\n"
   " }\n"
   "}\n")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ "public class BOut extends RuntimeEnvironment {\n")

'(query:
  (app (-> display <-) (app java-compile-program input-program))
  (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> string-append <-) "new IntValue(" (app number->string exp) ")")
  (env (())))
clos/con:
	'((prim string-append) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app display (-> (app java-compile-program input-program) <-))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query:
  (app string-append "new IntValue(" (-> (app number->string exp) <-) ")")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query:
  (app string-append "new IntValue(" (app number->string exp) (-> ")" <-))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ")")

'(query:
  (app string-append (-> "new IntValue(" <-) (app number->string exp) ")")
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ "new IntValue(")

'(query:
  (let (...
        ()
        (_ (-> (app analyze-mutable-variables input-program) <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app display (app java-compile-program input-program)) <-))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    analyze-mutable-variables
    (mangle (-> (λ (symbol) ...) <-))
    java-compile-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    analyze-mutable-variables
    (mangle (-> (λ (symbol) ...) <-))
    java-compile-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-app
    (java-compile-if (-> (λ (exp) ...) <-))
    input-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-app
    (java-compile-if (-> (λ (exp) ...) <-))
    input-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-args
    (java-compile-set! (-> (λ (exp) ...) <-))
    java-compile-app
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-args
    (java-compile-set! (-> (λ (exp) ...) <-))
    java-compile-app
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-const
    (java-compile-prim (-> (λ (p) ...) <-))
    java-compile-ref
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-const
    (java-compile-prim (-> (λ (p) ...) <-))
    java-compile-ref
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-exp
    (java-compile-const (-> (λ (exp) ...) <-))
    java-compile-prim
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-exp
    (java-compile-const (-> (λ (exp) ...) <-))
    java-compile-prim
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-formals
    (java-compile-lambda (-> (λ (exp) ...) <-))
    java-compile-args
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-formals
    (java-compile-lambda (-> (λ (exp) ...) <-))
    java-compile-args
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-lambda
    (java-compile-args (-> (λ (args) ...) <-))
    java-compile-set!
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-lambda
    (java-compile-args (-> (λ (args) ...) <-))
    java-compile-set!
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-prim
    (java-compile-ref (-> (λ (exp) ...) <-))
    java-compile-formals
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-prim
    (java-compile-ref (-> (λ (exp) ...) <-))
    java-compile-formals
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-program
    (java-compile-exp (-> (λ (exp) ...) <-))
    java-compile-const
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-program
    (java-compile-exp (-> (λ (exp) ...) <-))
    java-compile-const
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-ref
    (java-compile-formals (-> (λ (formals) ...) <-))
    java-compile-lambda
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-ref
    (java-compile-formals (-> (λ (formals) ...) <-))
    java-compile-lambda
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    java-compile-set!
    (java-compile-app (-> (λ (exp) ...) <-))
    java-compile-if
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-set!
    (java-compile-app (-> (λ (exp) ...) <-))
    java-compile-if
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    mangle
    (java-compile-program (-> (λ (exp) ...) <-))
    java-compile-exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mangle
    (java-compile-program (-> (λ (exp) ...) <-))
    java-compile-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... begin=>let (mutable-variables (-> (app nil) <-)) mark-mutable ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... char->natural (integer->char-list (-> (λ (n) ...) <-)) const? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... char->natural (integer->char-list (-> (λ (n) ...) <-)) const? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... integer->char-list (const? (-> (λ (exp) ...) <-)) ref? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... integer->char-list (const? (-> (λ (exp) ...) <-)) ref? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) letrec1? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) letrec1? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let->exp (letrec1? (-> (λ (exp) ...) <-)) letrec1->binding ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->exp (letrec1? (-> (λ (exp) ...) <-)) letrec1->binding ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec1->binding (letrec1->exp (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1->binding (letrec1->exp (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec1->exp (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1->exp (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec1=>Y (begin=>let (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1=>Y (begin=>let (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec1? (letrec1->binding (-> (λ (exp) ...) <-)) letrec1->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1? (letrec1->binding (-> (λ (exp) ...) <-)) letrec1->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... Yn (letrec1=>Y (-> (λ (exp) ...) <-)) begin=>let ...) ...)
  (env ()))
clos/con:
	'((letrec* (... Yn (letrec1=>Y (-> (λ (exp) ...) <-)) begin=>let ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... append (string->list (-> (λ (s) ...) <-)) void ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (string->list (-> (λ (s) ...) <-)) void ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!-var ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!-var ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) append ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) length ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) length ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caadr (-> (λ (p) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... java-compile-if (input-program (-> 3 <-)) () ...) ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
clos/con:
	'((letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... length (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... length (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... let=>lambda (arity (-> (λ (lam) ...) <-)) xargs ...) ...)
  (env ()))
clos/con:
	'((letrec* (... let=>lambda (arity (-> (λ (lam) ...) <-)) xargs ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... map (append (-> (λ (lst1 lst2) ...) <-)) string->list ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (append (-> (λ (lst1 lst2) ...) <-)) string->list ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... map (length (-> (λ (length-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (length (-> (λ (length-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (cadr (-> (λ (p) ...) <-)) caadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) caadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
clos/con:
	'((letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
clos/con:
	'((letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... set!-exp (let=>lambda (-> (λ (exp) ...) <-)) arity ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!-exp (let=>lambda (-> (λ (exp) ...) <-)) arity ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... set!-var (set!-exp (-> (λ (exp) ...) <-)) let=>lambda ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!-var (set!-exp (-> (λ (exp) ...) <-)) let=>lambda ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... set!? (set!-var (-> (λ (exp) ...) <-)) set!-exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!? (set!-var (-> (λ (exp) ...) <-)) set!-exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... string->list (void (-> (λ () ...) <-)) tagged-list? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... string->list (void (-> (λ () ...) <-)) tagged-list? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... xargs (Yn (-> (λ (n) ...) <-)) letrec1=>Y ...) ...)
  (env ()))
clos/con:
	'((letrec* (... xargs (Yn (-> (λ (n) ...) <-)) letrec1=>Y ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes cons ... error (letrec* (car ... input-program) ...))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app integer? exp)
   (#f)
   (_
    (-> (app string-append "new IntValue(" (app number->string exp) ")") <-)))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query:
  (match (app const? exp) (#f) (_ (-> (app java-compile-const exp) <-)))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query:
  (λ (exp)
    (->
     (app
      string-append
      "public class BOut extends RuntimeEnvironment {\n"
      " public static void main (String[] args) {\n"
      (app java-compile-exp exp)
      " ;\n"
      " }\n"
      "}\n")
     <-))
  (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query: ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> analyze-mutable-variables <-) input-program) (env ()))
clos/con:
	'((letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> const? <-) exp) (env (())))
clos/con:
	'((letrec*
   (... integer->char-list (const? (-> (λ (exp) ...) <-)) ref? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> const? <-) exp) (env (())))
clos/con:
	'((letrec*
   (... integer->char-list (const? (-> (λ (exp) ...) <-)) ref? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> integer? <-) exp) (env (())))
clos/con:
	'((prim integer?) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> integer? <-) exp) (env (())))
clos/con:
	'((prim integer?) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> java-compile-const <-) exp) (env (())))
clos/con:
	'((letrec*
   (...
    java-compile-exp
    (java-compile-const (-> (λ (exp) ...) <-))
    java-compile-prim
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> java-compile-exp <-) exp) (env (())))
clos/con:
	'((letrec*
   (...
    java-compile-program
    (java-compile-exp (-> (λ (exp) ...) <-))
    java-compile-const
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> java-compile-program <-) input-program) (env ()))
clos/con:
	'((letrec*
   (...
    mangle
    (java-compile-program (-> (λ (exp) ...) <-))
    java-compile-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> number->string <-) exp) (env (())))
clos/con:
	'((prim number->string) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> void <-)) (env (())))
clos/con:
	'((prim void) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app analyze-mutable-variables (-> input-program <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app const? (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app const? (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app integer? (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app integer? (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app java-compile-const (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app java-compile-exp (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app java-compile-program (-> input-program <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app number->string (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... arity (xargs (-> (λ (n) ...) <-)) Yn ...) ...) (env ()))
clos/con:
	'((letrec* (... arity (xargs (-> (λ (n) ...) <-)) Yn ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (car ... input-program) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app const? exp) <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app const? exp) <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app integer? exp) <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app const? exp) (#f) (_ (-> (app void) <-))) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (exp) (-> (app integer? exp) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (exp) (-> (match (app const? exp) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(query: (λ (exp) (-> (match (app const? exp) ...) <-)) (env (())))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (exp) (-> (match (app integer? exp) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊥ ⊥ ⊤)

'(store:
  Yn
  (letrec* (... xargs (Yn (-> (λ (n) ...) <-)) letrec1=>Y ...) ...)
  (env ()))
clos/con:
	'((letrec* (... xargs (Yn (-> (λ (n) ...) <-)) letrec1=>Y ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (...
        ()
        (_ (-> (app analyze-mutable-variables input-program) <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  analyze-mutable-variables
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app->args
  (letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app->fun
  (letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app?
  (letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... map (append (-> (λ (lst1 lst2) ...) <-)) string->list ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (append (-> (λ (lst1 lst2) ...) <-)) string->list ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  arity
  (letrec* (... let=>lambda (arity (-> (λ (lam) ...) <-)) xargs ...) ...)
  (env ()))
clos/con:
	'((letrec* (... let=>lambda (arity (-> (λ (lam) ...) <-)) xargs ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin->exps
  (letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin=>let
  (letrec*
   (... letrec1=>Y (begin=>let (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1=>Y (begin=>let (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin?
  (letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
clos/con:
	'((letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caadr
  (letrec* (... cadr (caadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caadr (-> (λ (p) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadddr
  (letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  caddr
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec* (... null? (cadr (-> (λ (p) ...) <-)) caadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) caadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  char->natural
  (letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  const?
  (letrec*
   (... integer->char-list (const? (-> (λ (exp) ...) <-)) ref? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... integer->char-list (const? (-> (λ (exp) ...) <-)) ref? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  exp
  (λ (exp)
    (->
     (app
      string-append
      "public class BOut extends RuntimeEnvironment {\n"
      " public static void main (String[] args) {\n"
      (app java-compile-exp exp)
      " ;\n"
      " }\n"
      "}\n")
     <-))
  (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  if->condition
  (letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->else
  (letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->then
  (letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if?
  (letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
clos/con:
	'((letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  input-program
  (letrec* (... java-compile-if (input-program (-> 3 <-)) () ...) ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  integer->char-list
  (letrec*
   (... char->natural (integer->char-list (-> (λ (n) ...) <-)) const? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... char->natural (integer->char-list (-> (λ (n) ...) <-)) const? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-mutable?
  (letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-app
  (letrec*
   (...
    java-compile-set!
    (java-compile-app (-> (λ (exp) ...) <-))
    java-compile-if
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-set!
    (java-compile-app (-> (λ (exp) ...) <-))
    java-compile-if
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-args
  (letrec*
   (...
    java-compile-lambda
    (java-compile-args (-> (λ (args) ...) <-))
    java-compile-set!
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-lambda
    (java-compile-args (-> (λ (args) ...) <-))
    java-compile-set!
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-const
  (letrec*
   (...
    java-compile-exp
    (java-compile-const (-> (λ (exp) ...) <-))
    java-compile-prim
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-exp
    (java-compile-const (-> (λ (exp) ...) <-))
    java-compile-prim
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-exp
  (letrec*
   (...
    java-compile-program
    (java-compile-exp (-> (λ (exp) ...) <-))
    java-compile-const
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-program
    (java-compile-exp (-> (λ (exp) ...) <-))
    java-compile-const
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-formals
  (letrec*
   (...
    java-compile-ref
    (java-compile-formals (-> (λ (formals) ...) <-))
    java-compile-lambda
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-ref
    (java-compile-formals (-> (λ (formals) ...) <-))
    java-compile-lambda
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-if
  (letrec*
   (...
    java-compile-app
    (java-compile-if (-> (λ (exp) ...) <-))
    input-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-app
    (java-compile-if (-> (λ (exp) ...) <-))
    input-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-lambda
  (letrec*
   (...
    java-compile-formals
    (java-compile-lambda (-> (λ (exp) ...) <-))
    java-compile-args
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-formals
    (java-compile-lambda (-> (λ (exp) ...) <-))
    java-compile-args
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-prim
  (letrec*
   (...
    java-compile-const
    (java-compile-prim (-> (λ (p) ...) <-))
    java-compile-ref
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-const
    (java-compile-prim (-> (λ (p) ...) <-))
    java-compile-ref
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-program
  (letrec*
   (...
    mangle
    (java-compile-program (-> (λ (exp) ...) <-))
    java-compile-exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mangle
    (java-compile-program (-> (λ (exp) ...) <-))
    java-compile-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-ref
  (letrec*
   (...
    java-compile-prim
    (java-compile-ref (-> (λ (exp) ...) <-))
    java-compile-formals
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-prim
    (java-compile-ref (-> (λ (exp) ...) <-))
    java-compile-formals
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  java-compile-set!
  (letrec*
   (...
    java-compile-args
    (java-compile-set! (-> (λ (exp) ...) <-))
    java-compile-app
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    java-compile-args
    (java-compile-set! (-> (λ (exp) ...) <-))
    java-compile-app
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->exp
  (letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->formals
  (letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda?
  (letrec*
   (... letrec1->exp (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1->exp (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  length
  (letrec* (... map (length (-> (λ (length-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (length (-> (λ (length-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let->bindings
  (letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let->exp
  (letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) letrec1? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) letrec1? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let=>lambda
  (letrec* (... set!-exp (let=>lambda (-> (λ (exp) ...) <-)) arity ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!-exp (let=>lambda (-> (λ (exp) ...) <-)) arity ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let?
  (letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
clos/con:
	'((letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec1->binding
  (letrec*
   (... letrec1? (letrec1->binding (-> (λ (exp) ...) <-)) letrec1->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1? (letrec1->binding (-> (λ (exp) ...) <-)) letrec1->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec1->exp
  (letrec*
   (... letrec1->binding (letrec1->exp (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec1->binding (letrec1->exp (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec1=>Y
  (letrec* (... Yn (letrec1=>Y (-> (λ (exp) ...) <-)) begin=>let ...) ...)
  (env ()))
clos/con:
	'((letrec* (... Yn (letrec1=>Y (-> (λ (exp) ...) <-)) begin=>let ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec1?
  (letrec*
   (... let->exp (letrec1? (-> (λ (exp) ...) <-)) letrec1->binding ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->exp (letrec1? (-> (λ (exp) ...) <-)) letrec1->binding ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  mangle
  (letrec*
   (...
    analyze-mutable-variables
    (mangle (-> (λ (symbol) ...) <-))
    java-compile-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    analyze-mutable-variables
    (mangle (-> (λ (symbol) ...) <-))
    java-compile-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) append ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) length ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) length ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  mark-mutable
  (letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  mutable-variables
  (letrec*
   (... begin=>let (mutable-variables (-> (app nil) <-)) mark-mutable ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
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
  pair?
  (letrec* (... length (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... length (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  prim?
  (letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ref?
  (letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!-exp
  (letrec* (... set!-var (set!-exp (-> (λ (exp) ...) <-)) let=>lambda ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!-var (set!-exp (-> (λ (exp) ...) <-)) let=>lambda ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!-var
  (letrec* (... set!? (set!-var (-> (λ (exp) ...) <-)) set!-exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!? (set!-var (-> (λ (exp) ...) <-)) set!-exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!?
  (letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!-var ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!-var ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  string->list
  (letrec* (... append (string->list (-> (λ (s) ...) <-)) void ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (string->list (-> (λ (s) ...) <-)) void ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  tagged-list?
  (letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  void
  (letrec* (... string->list (void (-> (λ () ...) <-)) tagged-list? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... string->list (void (-> (λ () ...) <-)) tagged-list? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  xargs
  (letrec* (... arity (xargs (-> (λ (n) ...) <-)) Yn ...) ...)
  (env ()))
clos/con:
	'((letrec* (... arity (xargs (-> (λ (n) ...) <-)) Yn ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: exp (λ (exp) (-> (app integer? exp) <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store: exp (λ (exp) (-> (match (app const? exp) ...) <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store: exp (λ (exp) (-> (match (app const? exp) ...) <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store: exp (λ (exp) (-> (match (app integer? exp) ...) <-)) (env (())))
clos/con: ⊥
literals: '(3 ⊥ ⊥)
