'(expression:
  (lettypes
   ((cons car cdr) (error r))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (extended-gcd
      (λ (a b)
        (match
         (app = (app modulo a b) 0)
         ((#f)
          (let* ((x:y (app extended-gcd b (app modulo a b)))
                 (x (app car x:y))
                 (y (app cdr x:y)))
            (app cons y (app - x (app * y (app quotient a b))))))
         (_ (app cons 0 1)))))
     (modulo-inverse (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
     (totient (λ (p q) (app * (app - p 1) (app - q 1))))
     (square (λ (x) (app * x x)))
     (modulo-power
      (λ (base exp n)
        (match
         (app = exp 0)
         ((#f)
          (match
           (app odd? exp)
           ((#f)
            (app
             modulo
             (app square (app modulo-power base (app / exp 2) n))
             n))
           (_
            (app
             modulo
             (app * base (app modulo-power base (app - exp 1) n))
             n))))
         (_ 1))))
     (is-legal-public-exponent?
      (λ (e p q)
        (app
         and
         (app < 1 e)
         (app < e (app totient p q))
         (app = 1 (app gcd e (app totient p q))))))
     (private-exponent
      (λ (e p q)
        (match
         (app is-legal-public-exponent? e p q)
         ((#f) (app error "Not a legal public exponent for that modulus."))
         (_ (app modulo-inverse e (app totient p q))))))
     (encrypt
      (λ (m e n)
        (match
         (app > m n)
         ((#f) (app modulo-power m e n))
         (_ (app error "The modulus is too small to encrypt the message.")))))
     (decrypt (λ (c d n) (app modulo-power c d n)))
     (p 41)
     (q 47)
     (n (app * p q))
     (e 7)
     (d (app private-exponent e p q))
     (plaintext 42)
     (ciphertext (app encrypt plaintext e n))
     (decrypted-ciphertext (app decrypt ciphertext d n)))
    (let ((_ (app display "The plaintext is:            ")))
      (let ((_ (app display plaintext)))
        (let ((_ (app newline)))
          (let ((_ (app display "The ciphertext is:           ")))
            (let ((_ (app display ciphertext)))
              (let ((_ (app newline)))
                (let ((_ (app display "The decrypted ciphertext is: ")))
                  (let ((_ (app display decrypted-ciphertext)))
                    (let ((_ (app newline)))
                      (match
                       (app not (app = plaintext decrypted-ciphertext))
                       ((#f) (app void))
                       (_ (app error "RSA fail!")))))))))))))))

'(query:
  (app
   (-> and <-)
   (app < 1 e)
   (app < e (app totient p q))
   (app = 1 (app gcd e (app totient p q))))
  (env ()))
clos/con:
	'((prim and) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (-> (app < 1 e) <-)
   (app < e (app totient p q))
   (app = 1 (app gcd e (app totient p q))))
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app < 1 e)
   (-> (app < e (app totient p q)) <-)
   (app = 1 (app gcd e (app totient p q))))
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   and
   (app < 1 e)
   (app < e (app totient p q))
   (-> (app = 1 (app gcd e (app totient p q))) <-))
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app * base (app modulo-power base (app - exp 1) n)) n)
  (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> modulo <-) (app square (app modulo-power base (app / exp 2) n)) n)
  (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - exp 1) n)) <-) n)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / exp 2) n)) <-) n)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - exp 1) n)) (-> n <-))
  (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / exp 2) n)) (-> n <-))
  (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query:
  (let (...
        ()
        (_ (-> (app display "The ciphertext is:           ") <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_ (-> (app display "The decrypted ciphertext is: ") <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_ (-> (app display "The plaintext is:            ") <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display ciphertext) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display decrypted-ciphertext) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app display plaintext) <-)) () ...) ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_)
    (-> (match (app not (app = plaintext decrypted-ciphertext)) ...) <-))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (... () (x:y (-> (app extended-gcd b (app modulo a b)) <-)) x ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (x:y ... y)
    (-> (app cons y (app - x (app * y (app quotient a b)))) <-))
  (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    ciphertext
    (decrypted-ciphertext (-> (app decrypt ciphertext d n) <-))
    ()
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    plaintext
    (ciphertext (-> (app encrypt plaintext e n) <-))
    decrypted-ciphertext
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... e (d (-> (app private-exponent e p q) <-)) plaintext ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...)
  (env ()))
clos/con:
	'((letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (car ... decrypted-ciphertext) (-> (let (_) ...) <-))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes cons ... error (letrec* (car ... decrypted-ciphertext) ...))
  (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app is-legal-public-exponent? e p q)
   (#f)
   (_ (-> (app modulo-inverse e (app totient p q)) <-)))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = plaintext decrypted-ciphertext))
   (#f)
   (_ (-> (app error "RSA fail!") <-)))
  (env ()))
clos/con:
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app = plaintext decrypted-ciphertext))
   ((#f) (-> (app void) <-))
   _)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_
    (->
     (app modulo (app * base (app modulo-power base (app - exp 1) n)) n)
     <-)))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f)
    (->
     (app modulo (app square (app modulo-power base (app / exp 2) n)) n)
     <-))
   _)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app not (app = plaintext decrypted-ciphertext)) <-) (#f) _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-)))
  (env ()))
clos/con:
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo a b) 0) ((#f) (-> (let* (x:y ... y) ...) <-)) _)
  (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > m n) ((#f) (-> (app modulo-power m e n) <-)) _)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (app modulo (app car (app extended-gcd a n)) n) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (e p q)
    (->
     (app
      and
      (app < 1 e)
      (app < e (app totient p q))
      (app = 1 (app gcd e (app totient p q))))
     <-))
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (e p q) (-> (match (app is-legal-public-exponent? e p q) ...) <-))
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) (app - p 1) (app - q 1)) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) base (app modulo-power base (app - exp 1) n)) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) p q) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) x x) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> * <-) y (app quotient a b)) (env ()))
clos/con:
	'((prim *) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) exp 1) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) p 1) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) q 1) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> - <-) x (app * y (app quotient a b))) (env ()))
clos/con:
	'((prim -) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> / <-) exp 2) (env ()))
clos/con:
	'((prim /) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> < <-) 1 e) (env ()))
clos/con:
	'((prim <) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> < <-) e (app totient p q)) (env ()))
clos/con:
	'((prim <) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) (app modulo a b) 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) 1 (app gcd e (app totient p q))) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) exp 0) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> = <-) plaintext decrypted-ciphertext) (env ()))
clos/con:
	'((prim =) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> > <-) m n) (env ()))
clos/con:
	'((prim >) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) (app extended-gcd a n)) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> car <-) x:y) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cdr <-) x:y) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) 0 1) (env ()))
clos/con:
	'((app (-> cons <-) 0 1) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> cons <-) y (app - x (app * y (app quotient a b)))) (env ()))
clos/con:
	'((app (-> cons <-) y (app - x (app * y (app quotient a b)))) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> decrypt <-) ciphertext d n) (env ()))
clos/con:
	'((letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) "The ciphertext is:           ") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) "The decrypted ciphertext is: ") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) "The plaintext is:            ") (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) ciphertext) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) decrypted-ciphertext) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> display <-) plaintext) (env ()))
clos/con:
	'((prim display) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> encrypt <-) plaintext e n) (env ()))
clos/con:
	'((letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> error <-) "RSA fail!") (env ()))
clos/con:
	'((app (-> error <-) "RSA fail!") (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> extended-gcd <-) a n) (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> extended-gcd <-) b (app modulo a b)) (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> gcd <-) e (app totient p q)) (env ()))
clos/con:
	'((prim gcd) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> is-legal-public-exponent? <-) e p q) (env ()))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) (app car (app extended-gcd a n)) n) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) a b) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo <-) a b) (env ()))
clos/con:
	'((prim modulo) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo-inverse <-) e (app totient p q)) (env ()))
clos/con:
	'((letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo-power <-) base (app - exp 1) n) (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo-power <-) base (app / exp 2) n) (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo-power <-) c d n) (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> modulo-power <-) m e n) (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> newline <-)) (env ()))
clos/con:
	'((prim newline) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> not <-) (app = plaintext decrypted-ciphertext)) (env ()))
clos/con:
	'((prim not) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> odd? <-) exp) (env ()))
clos/con:
	'((prim odd?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> private-exponent <-) e p q) (env ()))
clos/con:
	'((letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> quotient <-) a b) (env ()))
clos/con:
	'((prim quotient) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> square <-) (app modulo-power base (app / exp 2) n)) (env ()))
clos/con:
	'((letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> totient <-) p q) (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> totient <-) p q) (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> totient <-) p q) (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> void <-)) (env ()))
clos/con:
	'((prim void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app * (-> (app - p 1) <-) (app - q 1)) (env ()))
clos/con: ⊥
literals: '(40 ⊥ ⊥)

'(query: (app * (-> base <-) (app modulo-power base (app - exp 1) n)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> p <-) q) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app * (-> x <-) x) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> y <-) (app quotient a b)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (app - p 1) (-> (app - q 1) <-)) (env ()))
clos/con: ⊥
literals: '(46 ⊥ ⊥)

'(query: (app * base (-> (app modulo-power base (app - exp 1) n) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * p (-> q <-)) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app * x (-> x <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * y (-> (app quotient a b) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> exp <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> p <-) 1) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app - (-> q <-) 1) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app - (-> x <-) (app * y (app quotient a b))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - exp (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - p (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - q (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app - x (-> (app * y (app quotient a b)) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (-> exp <-) 2) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / exp (-> 2 <-)) (env ()))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query: (app < (-> 1 <-) e) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app < (-> e <-) (app totient p q)) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app < 1 (-> e <-)) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app < e (-> (app totient p q) <-)) (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app = (-> (app modulo a b) <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> 1 <-) (app gcd e (app totient p q))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = (-> exp <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> plaintext <-) decrypted-ciphertext) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app = (app modulo a b) (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = 1 (-> (app gcd e (app totient p q)) <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = exp (-> 0 <-)) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app = plaintext (-> decrypted-ciphertext <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app > (-> m <-) n) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app > m (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app car (-> (app extended-gcd a n) <-)) (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> x:y <-)) (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> x:y <-)) (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app cons (-> 0 <-) 1) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query: (app cons (-> y <-) (app - x (app * y (app quotient a b)))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app cons 0 (-> 1 <-)) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app cons y (-> (app - x (app * y (app quotient a b))) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app decrypt (-> ciphertext <-) d n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app decrypt ciphertext (-> d <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app decrypt ciphertext d (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app display (-> "The ciphertext is:           " <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "The ciphertext is:           ")

'(query: (app display (-> "The decrypted ciphertext is: " <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "The decrypted ciphertext is: ")

'(query: (app display (-> "The plaintext is:            " <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "The plaintext is:            ")

'(query: (app display (-> ciphertext <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app display (-> decrypted-ciphertext <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app display (-> plaintext <-)) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app encrypt (-> plaintext <-) e n) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app encrypt plaintext (-> e <-) n) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app encrypt plaintext e (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app error (-> "RSA fail!" <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "RSA fail!")

'(query: (app extended-gcd (-> a <-) n) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app extended-gcd (-> b <-) (app modulo a b)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app extended-gcd a (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app extended-gcd b (-> (app modulo a b) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app gcd (-> e <-) (app totient p q)) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app gcd e (-> (app totient p q) <-)) (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app is-legal-public-exponent? (-> e <-) p q) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app is-legal-public-exponent? e (-> p <-) q) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app is-legal-public-exponent? e p (-> q <-)) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app modulo (-> (app car (app extended-gcd a n)) <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> a <-) b) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> a <-) b) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (app car (app extended-gcd a n)) (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app modulo a (-> b <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo a (-> b <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-inverse (-> e <-) (app totient p q)) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app modulo-inverse e (-> (app totient p q) <-)) (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app - exp 1) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app / exp 2) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> c <-) d n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> m <-) e n) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app modulo-power base (-> (app - exp 1) <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (-> (app / exp 2) <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (app - exp 1) (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app modulo-power base (app / exp 2) (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app modulo-power c (-> d <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power c d (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app modulo-power m (-> e <-) n) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app modulo-power m e (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app not (-> (app = plaintext decrypted-ciphertext) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app odd? (-> exp <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app private-exponent (-> e <-) p q) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app private-exponent e (-> p <-) q) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app private-exponent e p (-> q <-)) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app quotient (-> a <-) b) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app quotient a (-> b <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app square (-> (app modulo-power base (app / exp 2) n) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app totient (-> p <-) q) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app totient (-> p <-) q) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app totient (-> p <-) q) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app totient p (-> q <-)) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app totient p (-> q <-)) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app totient p (-> q <-)) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app newline) <-)) () ...) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con:
	'(((top) app void) (env ()))
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let* (... x (y (-> (app cdr x:y) <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let* (... x:y (x (-> (app car x:y) <-)) y ...) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... d (plaintext (-> 42 <-)) ciphertext ...) ...) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (letrec* (... decrypt (p (-> 41 <-)) q ...) ...) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (letrec* (... n (e (-> 7 <-)) d ...) ...) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (letrec* (... p (q (-> 47 <-)) n ...) ...) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (letrec* (... q (n (-> (app * p q) <-)) e ...) ...) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (match (-> (app = (app modulo a b) 0) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = exp 0) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app > m n) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app is-legal-public-exponent? e p q) <-) (#f) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app odd? exp) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app = exp 0) (#f) (_ (-> 1 <-))) (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (c d n) (-> (app modulo-power c d n) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (m e n) (-> (match (app > m n) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (p q) (-> (app * (app - p 1) (app - q 1)) <-)) (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (λ (x) (-> (app * x x) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    ((app - x (app * y (app quotient a b))))
    (let-bod
     let*
     ((x:y (app extended-gcd b (app modulo a b)))
      (x (app car x:y))
      (y (app cdr x:y)))
     (match-clause
      (#f)
      (app = (app modulo a b) 0)
      ()
      ((_ (app cons 0 1)))
      (bod
       (a b)
       (bin
        letrec*
        extended-gcd
        (let ((_ (app display "The plaintext is:            ")))
          (let ((_ (app display plaintext)))
            (let ((_ (app newline)))
              (let ((_ (app display "The ciphertext is:           ")))
                (let ((_ (app display ciphertext)))
                  (let ((_ (app newline)))
                    (let ((_ (app display "The decrypted ciphertext is: ")))
                      (let ((_ (app display decrypted-ciphertext)))
                        (let ((_ (app newline)))
                          (match
                           (app not (app = plaintext decrypted-ciphertext))
                           ((#f) (app void))
                           (_ (app error "RSA fail!"))))))))))))
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d)))))
        ((modulo-inverse
          (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
         (totient (λ (p q) (app * (app - p 1) (app - q 1))))
         (square (λ (x) (app * x x)))
         (modulo-power
          (λ (base exp n)
            (match
             (app = exp 0)
             ((#f)
              (match
               (app odd? exp)
               ((#f)
                (app
                 modulo
                 (app square (app modulo-power base (app / exp 2) n))
                 n))
               (_
                (app
                 modulo
                 (app * base (app modulo-power base (app - exp 1) n))
                 n))))
             (_ 1))))
         (is-legal-public-exponent?
          (λ (e p q)
            (app
             and
             (app < 1 e)
             (app < e (app totient p q))
             (app = 1 (app gcd e (app totient p q))))))
         (private-exponent
          (λ (e p q)
            (match
             (app is-legal-public-exponent? e p q)
             ((#f) (app error "Not a legal public exponent for that modulus."))
             (_ (app modulo-inverse e (app totient p q))))))
         (encrypt
          (λ (m e n)
            (match
             (app > m n)
             ((#f) (app modulo-power m e n))
             (_
              (app
               error
               "The modulus is too small to encrypt the message.")))))
         (decrypt (λ (c d n) (app modulo-power c d n)))
         (p 41)
         (q 47)
         (n (app * p q))
         (e 7)
         (d (app private-exponent e p q))
         (plaintext 42)
         (ciphertext (app encrypt plaintext e n))
         (decrypted-ciphertext (app decrypt ciphertext d n)))
        (lettypes-bod ((cons car cdr) (error r)) (top)))))))
   .
   y)
  con
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ((ran
    cons
    ()
    (1)
    (match-clause
     _
     (app = (app modulo a b) 0)
     (((#f)
       (let* ((x:y (app extended-gcd b (app modulo a b)))
              (x (app car x:y))
              (y (app cdr x:y)))
         (app cons y (app - x (app * y (app quotient a b)))))))
     ()
     (bod
      (a b)
      (bin
       letrec*
       extended-gcd
       (let ((_ (app display "The plaintext is:            ")))
         (let ((_ (app display plaintext)))
           (let ((_ (app newline)))
             (let ((_ (app display "The ciphertext is:           ")))
               (let ((_ (app display ciphertext)))
                 (let ((_ (app newline)))
                   (let ((_ (app display "The decrypted ciphertext is: ")))
                     (let ((_ (app display decrypted-ciphertext)))
                       (let ((_ (app newline)))
                         (match
                          (app not (app = plaintext decrypted-ciphertext))
                          ((#f) (app void))
                          (_ (app error "RSA fail!"))))))))))))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d)))))
       ((modulo-inverse
         (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
        (totient (λ (p q) (app * (app - p 1) (app - q 1))))
        (square (λ (x) (app * x x)))
        (modulo-power
         (λ (base exp n)
           (match
            (app = exp 0)
            ((#f)
             (match
              (app odd? exp)
              ((#f)
               (app
                modulo
                (app square (app modulo-power base (app / exp 2) n))
                n))
              (_
               (app
                modulo
                (app * base (app modulo-power base (app - exp 1) n))
                n))))
            (_ 1))))
        (is-legal-public-exponent?
         (λ (e p q)
           (app
            and
            (app < 1 e)
            (app < e (app totient p q))
            (app = 1 (app gcd e (app totient p q))))))
        (private-exponent
         (λ (e p q)
           (match
            (app is-legal-public-exponent? e p q)
            ((#f) (app error "Not a legal public exponent for that modulus."))
            (_ (app modulo-inverse e (app totient p q))))))
        (encrypt
         (λ (m e n)
           (match
            (app > m n)
            ((#f) (app modulo-power m e n))
            (_
             (app error "The modulus is too small to encrypt the message.")))))
        (decrypt (λ (c d n) (app modulo-power c d n)))
        (p 41)
        (q 47)
        (n (app * p q))
        (e 7)
        (d (app private-exponent e p q))
        (plaintext 42)
        (ciphertext (app encrypt plaintext e n))
        (decrypted-ciphertext (app decrypt ciphertext d n)))
       (lettypes-bod ((cons car cdr) (error r)) (top))))))
   .
   0)
  con
  (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store:
  ((ran
    cons
    (0)
    ()
    (match-clause
     _
     (app = (app modulo a b) 0)
     (((#f)
       (let* ((x:y (app extended-gcd b (app modulo a b)))
              (x (app car x:y))
              (y (app cdr x:y)))
         (app cons y (app - x (app * y (app quotient a b)))))))
     ()
     (bod
      (a b)
      (bin
       letrec*
       extended-gcd
       (let ((_ (app display "The plaintext is:            ")))
         (let ((_ (app display plaintext)))
           (let ((_ (app newline)))
             (let ((_ (app display "The ciphertext is:           ")))
               (let ((_ (app display ciphertext)))
                 (let ((_ (app newline)))
                   (let ((_ (app display "The decrypted ciphertext is: ")))
                     (let ((_ (app display decrypted-ciphertext)))
                       (let ((_ (app newline)))
                         (match
                          (app not (app = plaintext decrypted-ciphertext))
                          ((#f) (app void))
                          (_ (app error "RSA fail!"))))))))))))
       ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
        (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d)))))
       ((modulo-inverse
         (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
        (totient (λ (p q) (app * (app - p 1) (app - q 1))))
        (square (λ (x) (app * x x)))
        (modulo-power
         (λ (base exp n)
           (match
            (app = exp 0)
            ((#f)
             (match
              (app odd? exp)
              ((#f)
               (app
                modulo
                (app square (app modulo-power base (app / exp 2) n))
                n))
              (_
               (app
                modulo
                (app * base (app modulo-power base (app - exp 1) n))
                n))))
            (_ 1))))
        (is-legal-public-exponent?
         (λ (e p q)
           (app
            and
            (app < 1 e)
            (app < e (app totient p q))
            (app = 1 (app gcd e (app totient p q))))))
        (private-exponent
         (λ (e p q)
           (match
            (app is-legal-public-exponent? e p q)
            ((#f) (app error "Not a legal public exponent for that modulus."))
            (_ (app modulo-inverse e (app totient p q))))))
        (encrypt
         (λ (m e n)
           (match
            (app > m n)
            ((#f) (app modulo-power m e n))
            (_
             (app error "The modulus is too small to encrypt the message.")))))
        (decrypt (λ (c d n) (app modulo-power c d n)))
        (p 41)
        (q 47)
        (n (app * p q))
        (e 7)
        (d (app private-exponent e p q))
        (plaintext 42)
        (ciphertext (app encrypt plaintext e n))
        (decrypted-ciphertext (app decrypt ciphertext d n)))
       (lettypes-bod ((cons car cdr) (error r)) (top))))))
   .
   1)
  con
  (env ()))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store:
  ((ran
    cons
    (y)
    ()
    (let-bod
     let*
     ((x:y (app extended-gcd b (app modulo a b)))
      (x (app car x:y))
      (y (app cdr x:y)))
     (match-clause
      (#f)
      (app = (app modulo a b) 0)
      ()
      ((_ (app cons 0 1)))
      (bod
       (a b)
       (bin
        letrec*
        extended-gcd
        (let ((_ (app display "The plaintext is:            ")))
          (let ((_ (app display plaintext)))
            (let ((_ (app newline)))
              (let ((_ (app display "The ciphertext is:           ")))
                (let ((_ (app display ciphertext)))
                  (let ((_ (app newline)))
                    (let ((_ (app display "The decrypted ciphertext is: ")))
                      (let ((_ (app display decrypted-ciphertext)))
                        (let ((_ (app newline)))
                          (match
                           (app not (app = plaintext decrypted-ciphertext))
                           ((#f) (app void))
                           (_ (app error "RSA fail!"))))))))))))
        ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
         (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d)))))
        ((modulo-inverse
          (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
         (totient (λ (p q) (app * (app - p 1) (app - q 1))))
         (square (λ (x) (app * x x)))
         (modulo-power
          (λ (base exp n)
            (match
             (app = exp 0)
             ((#f)
              (match
               (app odd? exp)
               ((#f)
                (app
                 modulo
                 (app square (app modulo-power base (app / exp 2) n))
                 n))
               (_
                (app
                 modulo
                 (app * base (app modulo-power base (app - exp 1) n))
                 n))))
             (_ 1))))
         (is-legal-public-exponent?
          (λ (e p q)
            (app
             and
             (app < 1 e)
             (app < e (app totient p q))
             (app = 1 (app gcd e (app totient p q))))))
         (private-exponent
          (λ (e p q)
            (match
             (app is-legal-public-exponent? e p q)
             ((#f) (app error "Not a legal public exponent for that modulus."))
             (_ (app modulo-inverse e (app totient p q))))))
         (encrypt
          (λ (m e n)
            (match
             (app > m n)
             ((#f) (app modulo-power m e n))
             (_
              (app
               error
               "The modulus is too small to encrypt the message.")))))
         (decrypt (λ (c d n) (app modulo-power c d n)))
         (p 41)
         (q 47)
         (n (app * p q))
         (e 7)
         (d (app private-exponent e p q))
         (plaintext 42)
         (ciphertext (app encrypt plaintext e n))
         (decrypted-ciphertext (app decrypt ciphertext d n)))
        (lettypes-bod ((cons car cdr) (error r)) (top)))))))
   app
   -
   x
   (app * y (app quotient a b)))
  con
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ((ran
    error
    ()
    ()
    (match-clause
     _
     (app not (app = plaintext decrypted-ciphertext))
     (((#f) (app void)))
     ()
     (let-bod
      let
      ((_ (app newline)))
      (let-bod
       let
       ((_ (app display decrypted-ciphertext)))
       (let-bod
        let
        ((_ (app display "The decrypted ciphertext is: ")))
        (let-bod
         let
         ((_ (app newline)))
         (let-bod
          let
          ((_ (app display ciphertext)))
          (let-bod
           let
           ((_ (app display "The ciphertext is:           ")))
           (let-bod
            let
            ((_ (app newline)))
            (let-bod
             let
             ((_ (app display plaintext)))
             (let-bod
              let
              ((_ (app display "The plaintext is:            ")))
              (let-bod
               letrec*
               ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
                (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
                (extended-gcd
                 (λ (a b)
                   (match
                    (app = (app modulo a b) 0)
                    ((#f)
                     (let* ((x:y (app extended-gcd b (app modulo a b)))
                            (x (app car x:y))
                            (y (app cdr x:y)))
                       (app cons y (app - x (app * y (app quotient a b))))))
                    (_ (app cons 0 1)))))
                (modulo-inverse
                 (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
                (totient (λ (p q) (app * (app - p 1) (app - q 1))))
                (square (λ (x) (app * x x)))
                (modulo-power
                 (λ (base exp n)
                   (match
                    (app = exp 0)
                    ((#f)
                     (match
                      (app odd? exp)
                      ((#f)
                       (app
                        modulo
                        (app square (app modulo-power base (app / exp 2) n))
                        n))
                      (_
                       (app
                        modulo
                        (app * base (app modulo-power base (app - exp 1) n))
                        n))))
                    (_ 1))))
                (is-legal-public-exponent?
                 (λ (e p q)
                   (app
                    and
                    (app < 1 e)
                    (app < e (app totient p q))
                    (app = 1 (app gcd e (app totient p q))))))
                (private-exponent
                 (λ (e p q)
                   (match
                    (app is-legal-public-exponent? e p q)
                    ((#f)
                     (app
                      error
                      "Not a legal public exponent for that modulus."))
                    (_ (app modulo-inverse e (app totient p q))))))
                (encrypt
                 (λ (m e n)
                   (match
                    (app > m n)
                    ((#f) (app modulo-power m e n))
                    (_
                     (app
                      error
                      "The modulus is too small to encrypt the message.")))))
                (decrypt (λ (c d n) (app modulo-power c d n)))
                (p 41)
                (q 47)
                (n (app * p q))
                (e 7)
                (d (app private-exponent e p q))
                (plaintext 42)
                (ciphertext (app encrypt plaintext e n))
                (decrypted-ciphertext (app decrypt ciphertext d n)))
               (lettypes-bod ((cons car cdr) (error r)) (top))))))))))))))
   .
   "RSA fail!")
  con
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "RSA fail!")

'(store:
  *
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
clos/con:
	'((λ (p q) (-> (app * (app - p 1) (app - q 1)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  *
  (letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((λ (x) (-> (app * x x) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  -
  (letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
clos/con:
	'((λ (p q) (-> (app * (app - p 1) (app - q 1)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  /
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  <
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (e p q)
    (->
     (app
      and
      (app < 1 e)
      (app < e (app totient p q))
      (app = 1 (app gcd e (app totient p q))))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  =
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (e p q)
    (->
     (app
      and
      (app < 1 e)
      (app < e (app totient p q))
      (app = 1 (app gcd e (app totient p q))))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  =
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  =
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  >
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con:
	'((λ (m e n) (-> (match (app > m n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  a
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  and
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (e p q)
    (->
     (app
      and
      (app < 1 e)
      (app < e (app totient p q))
      (app = 1 (app gcd e (app totient p q))))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  b
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  base
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  c
  (letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  car
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car-c
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  car-d
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  car-v
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr-c
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-d
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  cdr-v
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cons
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  d
  (letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  e
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  e
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  e
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  error
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (e p q) (-> (match (app is-legal-public-exponent? e p q) ...) <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  error
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con:
	'((λ (m e n) (-> (match (app > m n) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  exp
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  extended-gcd
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  extended-gcd
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  gcd
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (e p q)
    (->
     (app
      and
      (app < 1 e)
      (app < e (app totient p q))
      (app = 1 (app gcd e (app totient p q))))
     <-))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-legal-public-exponent?
  ((top) lettypes (cons ... error) ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-legal-public-exponent?
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  m
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(store:
  modulo
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con:
	'((λ (a n) (-> (app modulo (app car (app extended-gcd a n)) n) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-inverse
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store:
  n
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(store:
  n
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store:
  n
  (letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...)
  (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store:
  odd?
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  p
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store:
  p
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store:
  p
  (letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store:
  q
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store:
  q
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store:
  q
  (letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store:
  quotient
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((λ (a b) (-> (match (app = (app modulo a b) 0) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  square
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  totient
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  totient
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x
  (letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  x:y
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((con
   cons
   (let* (x:y ... y)
     (-> (app cons y (app - x (app * y (app quotient a b)))) <-)))
  (env ()))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: _ ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: car ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cdr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: ciphertext ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: d ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: decrypt ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: decrypted-ciphertext ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: e ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store: encrypt ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: extended-gcd ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: modulo-inverse ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: modulo-power ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: n ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store: p ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store: plaintext ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(store: private-exponent ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: q ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store: square ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: totient ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
